# Architecture — hi-ha.be

> **100% auto-hébergé** sur un VPS via Coolify. Aucun service tiers.

## Monorepo

```
hi-ha/
├── docker-compose.yml
├── .env.example
├── frontend/                 # Next.js 16 (App Router) — site + /admin
│   ├── Dockerfile
│   ├── app/
│   │   ├── (site)/           # pages marketing publiques
│   │   │   ├── page.tsx              # Accueil
│   │   │   ├── services/page.tsx
│   │   │   ├── souverainete/page.tsx
│   │   │   ├── formations/page.tsx
│   │   │   └── contact/page.tsx      # wizard multi-étapes
│   │   ├── admin/            # backoffice protégé (Better Auth)
│   │   │   ├── layout.tsx            # sidebar + garde d'auth
│   │   │   ├── page.tsx              # tableau de bord
│   │   │   ├── contenus/
│   │   │   ├── demandes/             # inbox formulaire contact
│   │   │   ├── medias/
│   │   │   └── reglages/
│   │   ├── sitemap.ts        # sitemap dynamique
│   │   ├── robots.ts
│   │   └── layout.tsx        # <html> + thème + fonts + JSON-LD global
│   ├── components/
│   │   ├── ui/               # shadcn/ui re-stylé avec nos tokens
│   │   ├── site/             # Header, Hero, ServiceCard, Footer…
│   │   └── admin/            # DataTable, EditorDrawer, MediaPicker…
│   ├── lib/                  # api client, utils, seo helpers
│   └── styles/
│       ├── tokens.css        # ← design-system/colors_and_type.css
│       └── globals.css       # Tailwind v4 @theme + base
├── backend/                  # Hono sur Bun
│   ├── Dockerfile
│   ├── src/
│   │   ├── index.ts          # app Hono + middlewares
│   │   ├── routes/
│   │   │   ├── public/       # contact, contenus publiés (lecture)
│   │   │   └── admin/        # CRUD contenus, médias, demandes, users
│   │   ├── db/
│   │   │   ├── schema.ts     # Drizzle schema
│   │   │   └── migrations/
│   │   ├── auth/             # Better Auth config
│   │   ├── mail/             # Nodemailer + templates React Email
│   │   ├── storage/          # client S3 (Garage) via @aws-sdk/client-s3
│   │   └── middleware/       # cors, rate-limit (Valkey), validation Zod
│   └── drizzle.config.ts
└── packages/
    └── shared/               # types & schémas Zod partagés front↔back
```

> Variante acceptable : tout-Next.js (API via Route Handlers `app/api/**`) sans service Hono séparé. Hono+Bun est recommandé pour un backend isolé, scalable et testable. **Choisir l'un OU l'autre** — ne pas dupliquer la logique.

## Conteneurs Docker (`docker-compose.yml`)

| Service | Image / build | Rôle | Exposé ? |
|---|---|---|---|
| `frontend` | build `./frontend` | Next.js (SSR + /admin) | via Traefik (public) |
| `backend` | build `./backend` (Bun) | API Hono | réseau interne (proxifié `/api`) |
| `db` | `postgres:16-alpine` | PostgreSQL | **interne uniquement** |
| `valkey` | `valkey/valkey:8.1.8-alpine` | cache, sessions, rate-limit | interne |
| `garage` | `dxflrs/garage:latest` | stockage médias S3 (Garage) | interne (API S3 + admin) |
| `mail` | `ghcr.io/.../docker-mailserver` ou `maddy` | SMTP sortant | interne (port 25/587 sortant) |
| `calcom` | image officielle **Cal.com self-hosted** | réservation visio (embed) | interne (embed proxifié) |

Coolify fournit **Traefik** (reverse proxy), **SSL Let's Encrypt** et le **redéploiement par webhook GitHub**. Seul `frontend` est public ; tout le reste vit sur le réseau Docker privé.

## Modèle de données (Drizzle / PostgreSQL)

```ts
// Esquisse — à affiner par Claude Code
users            // admin : id, email, name, role, 2FA secret (Better Auth gère ses propres tables aussi)
content          // id, slug(unique), type('page'|'article'), section, title, excerpt,
                 //   body(richtext JSON Tiptap), status('draft'|'review'|'published'),
                 //   seo(jsonb: metaTitle, metaDescription, ogImageId), publishedAt, updatedAt
                 //   + visible(bool, défaut true) + placement('nav'|'footer'|'both'|'none') + order
                 //   → pilote l'affichage/masquage des pages (méthodologie, domaines, légales, calendrier…)
media            // id, key(Garage S3), filename, mime, width, height, alt, size, createdAt
contact_submissions  // id, orgType, maturity('decouverte'|'essais'|'deploiement'|'avance'),
                     //   needs(text[]), channel('message'|'visio'), name, email, phone, message,
                     //   bookingId(nullable, Cal.com), status('new'|'read'|'archived'), createdAt
testimonials     // id, photoMediaId(logo OU personne), quote, authorName, authorRole, company,
                 //   order, visible, createdAt
events           // id, title, type('formation'|'evenement'), startsAt, endsAt(nullable),
                 //   location, format('presentiel'|'visio'|'hybride'), description, url, visible
settings         // clé/valeur (jsonb) : coordonnées, réseaux, textes globaux
theme            // jsonb borné aux TOKENS : accentColor('lilas'|'peche'|'rose'|'graphite'),
                 //   buttonStyle('primary'|'accent'|'secondary'), radius('md'|'lg'|'pill'),
                 //   headingWeight(600|700|800),
                 //   buttonVariants: { '<buttonId>': 'plein'|'entoure'|'transparent' }
                 //   Injecté en CSS vars sur :root (SSR) ; variants par bouton sur le CTA concerné.
navigation       // (optionnel) arbre de nav éditable : label, href/route, children[], order, visible
```

Index : `content.slug`, `content.status`, `content.visible`, `content.section`, `contact_submissions.status`, `testimonials.order`, `events.startsAt`.

> **Pages toggleables** : méthodologie, domaines, témoignages, calendrier et les 4 légales sont des lignes `content` (type='page') avec `visible`/`placement`. Le rendu serveur, la nav, le footer et `sitemap.ts` filtrent sur `visible=true`. Une page masquée → 404/redirect.

## Cal.com auto-hébergé (réservation visio)

Conteneur Docker **`calcom`** (image officielle self-hosted) sur le réseau interne, base Postgres dédiée (ou schéma séparé). Embarqué dans le wizard de contact (étape « Prévoir une visio ») via l'**embed Cal.com**, **stylé aux tokens du site** (couleurs/typo) pour une intégration transparente. À la prise de rdv : Cal.com crée l'événement **et** le front enregistre une `contact_submissions` (`channel='visio'`, `bookingId`). Aucun service tiers — tout est hébergé chez vous.

## API (Hono) — surface

**Publique** (lecture seule + contact) :
- `GET /api/content/:slug` — page/article **publié ET visible** (cache Valkey)
- `GET /api/content?section=` — listes
- `GET /api/testimonials` — témoignages visibles (ordre)
- `GET /api/events` — événements/formations visibles à venir (si page calendrier active)
- `POST /api/contact` — soumission wizard (incl. `maturity`, `channel`) → Zod → honeypot/Altcha → rate-limit Valkey → insert DB → notif email Nodemailer ; si `channel='visio'`, lie le `bookingId` Cal.com

**Admin** (Better Auth requis, rôle admin) :
- `GET/POST/PATCH/DELETE /api/admin/content[/:id]` — incl. `visible` / `placement` / `order` (afficher-masquer pages)
- `GET/POST/PATCH/DELETE /api/admin/testimonials[/:id]`
- `GET/POST/PATCH/DELETE /api/admin/events[/:id]`
- `GET/PATCH /api/admin/submissions[/:id]`
- `POST /api/admin/media` (upload → Garage S3, retourne key + URL signée) · `DELETE /api/admin/media/:id`
- `GET/PATCH /api/admin/settings`
- `GET/PATCH /api/admin/theme` — réglages d'apparence (valeurs bornées aux tokens) → injectés en CSS vars `:root` au SSR
- `GET/PATCH /api/admin/navigation` — arbre de nav éditable (libellés, ordre, visibilité)

Tous les endpoints : validation **Zod**, erreurs typées, CORS strict, `Cache-Control` adapté.

## Flux clés

**Formulaire de contact** (auto-hébergé de bout en bout) :
1. Front (wizard 5 étapes) → `POST /api/contact` avec payload validé Zod côté client (React Hook Form).
2. Backend : honeypot + Altcha + rate-limit Valkey (par IP) → re-validation Zod.
3. **Insert `contact_submissions`** (source de vérité, visible dans `/admin/demandes`).
4. Notification email via **Nodemailer → SMTP self-hosted** (template React Email). Si le SMTP échoue, la demande reste en base (jamais perdue).

**Rendu d'une page de contenu** :
- RSC `generateMetadata()` + corps → `GET /api/content/:slug` (cache Valkey, invalidé à la publication depuis l'admin).
