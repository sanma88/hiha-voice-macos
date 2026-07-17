# BUILD_PROMPT.md — Prompt `/goal` pour Claude Code

> **Mode d'emploi** : place ce dossier `claude_code_handoff/` à la racine de ton repo vide, ouvre Claude Code dedans, puis lance la commande `/goal` en collant **tout le bloc ci-dessous** (entre les lignes `====`). Claude Code aura accès aux fichiers du dossier (DESIGN.md, STACK.md, ARCHITECTURE.md, CONTENT.md, SEO_GEO_SECURITY.md, design-system/, design-reference/) et construira l'application.

> ⚠️ Avant de lancer : dépose les `.woff2` de Manrope/Inter/IBM Plex Mono dans le repo (ou laisse Claude Code les configurer via `next/font/google` en self-hosting automatique). Renseigne ensuite les variables de `.env`.

---

```
====================================================================
GOAL : Construire et déployer le site web premium + CMS de hi-ha.be
====================================================================

CONTEXTE
hi-ha.be — conseil, formation et intégration en IA & automatisation pour les
organisations en Belgique francophone. Univers visuel "verre givré" : premium,
calme, lumineux, pédagogique. Contenu 100% en français. Site marketing + page
contact à formulaire multi-étapes + back-office CMS léger. Light ET dark
(clair par défaut), 100% responsive mobile-first.

Toutes les spécifications font autorité et se trouvent dans ./claude_code_handoff/ :
- BRIEF.md ............. contexte client : positionnement, différenciateurs, cibles, ton de voix
- DESIGN.md ............ design system (tokens, type, composants, motion, logos)
- STACK.md ............. stack technique + VERSIONS EXACTES (juin 2026)
- ARCHITECTURE.md ...... monorepo, Docker, modèle de données, API
- CONTENT.md ........... plan du site, COPY de référence (FR), wizard, CMS
- SEO_GEO_SECURITY.md .. exigences SEO/GEO, sécurité, Definition of Done
- design-system/ ....... colors_and_type.css (TOKENS), fonts, logos (SVG + PNG 3D)
- design-reference/website/ ... prototype HTML/React de référence (look & comportement)

LIS CES FICHIERS AVANT DE CODER. Les fichiers de design-reference/ sont des
RÉFÉRENCES VISUELLES (prototypes), à RECRÉER proprement dans la stack ci-dessous,
pas à copier tels quels.

PRINCIPE NON NÉGOCIABLE — 100% AUTO-HÉBERGEABLE
Aucun service tiers SaaS. Tout tourne en conteneurs Docker sur le VPS (Coolify).
- Email : Nodemailer → SMTP auto-hébergé (Maddy ou docker-mailserver). JAMAIS Resend.
- Médias : Garage S3 (Deuxfleurs), via @aws-sdk/client-s3. JAMAIS MinIO ni Cloudflare R2.
- Anti-spam : honeypot + Altcha (proof-of-work self-hosted) + rate-limit Valkey. JAMAIS reCAPTCHA/hCaptcha.
- Auth : Better Auth (librairie self-hosted). Analytics éventuel : Umami self-hosted (optionnel).

STACK (épingler ces versions — voir STACK.md)
- Frontend : Next.js 16.2.7 (App Router, Turbopack par défaut), TypeScript strict.
- Styling : Tailwind CSS v4 (config CSS-first @theme), shadcn/ui re-stylé avec NOS tokens.
- Animations : Motion 12.40.0 — import { motion } from "motion/react" (PAS "framer-motion").
- Fonts : next/font self-hosted (Manrope, Inter, IBM Plex Mono). Images : next/image.
- Backend : Hono 4.9.4 sur Bun 1.3.14. ORM : Drizzle 0.43.1 (PAS la beta 1.0).
- DB : PostgreSQL 16. Cache/sessions/rate-limit : Valkey 8.1.8 LTS.
- Médias : Garage S3. Email : Nodemailer + React Email. Validation : Zod 3. Formulaires : React Hook Form.
- Éditeur CMS : Tiptap 2. Déploiement : Docker + Coolify (Traefik + SSL auto).

ARCHITECTURE (voir ARCHITECTURE.md)
Monorepo : frontend/ (Next 16, inclut /admin), backend/ (Hono/Bun), packages/shared (types + Zod).
docker-compose : frontend (public via Traefik), backend (interne), db postgres:16-alpine,
valkey 8.1.8, garage (dxflrs/garage), mail (SMTP), calcom (Cal.com self-hosted, embed visio).
Seul frontend est exposé.
Modèle de données : users, content (slug, type, section, title, excerpt, body Tiptap JSON,
status, seo jsonb, publishedAt, + visible/placement/order pour afficher-masquer les pages),
media, contact_submissions (+ maturity, channel message/visio, bookingId), testimonials
(photo, quote, author, role, company, order, visible), events (formation/événement, dates,
lieu, format, visible), settings, theme (apparence bornée tokens + buttonVariants), navigation.

CE QU'IL FAUT CONSTRUIRE (voir CONTENT.md pour la copy EXACTE)
1. Site marketing :
   - Accueil : header verre givré flottant (nav Services/Formations/Souveraineté/Approche/Calendrier
     + toggle thème + CTA "Demander un audit"), hero (symbole 3D frosté + halo iridescent ;
     en dark, halo + lueur émise opacité ~0.6), section Services (4 cartes), section
     Souveraineté (panneau verre givré avec flow vertical), TÉMOIGNAGES, bande CTA, footer.
   - NAVIGATION : menus VERTICAUX flottants en verre givré (détachés du header, centrés sous
     l'item, SANS chevron dans le menu principal). Une entrée à sous-niveau ouvre un FLYOUT
     vertical vers la DROITE au survol (Services = 4 entrées, chacune avec son flyout ;
     Formations = liste simple ; APPROCHE — placé vers la fin — = Méthodologie/Domaines/Témoignages ;
     CALENDRIER = lien direct, visible seulement si la page est activée). Panneaux peu transparents
     (lisibilité). Piloté par données, éditable via le CMS. Sous 760px : burger morphé en X +
     OVERLAY PLEIN ÉCRAN verre givré qui EMBARQUE sa propre barre haute (logo + hi-ha.be + toggle +
     X pour fermer) ; entrées en cascade ; sous-menus en accordéon (listes déroulantes).
   - Pages : /services, /souverainete, /formations (même système visuel).
   - TÉMOIGNAGES : section sur l'accueil + page dédiée /temoignages (éditables en admin).
     Carte PREMIUM : photo ronde (logo entreprise OU personne), citation Manrope, nom + titre,
     entreprise. Accent iridescent discret.
   - PAGES TOGGLEABLES : /methodologie, /domaines, /temoignages, /calendrier, et les légales
     (/mentions-legales, /confidentialite, /cookies, /cgv). Chacune a un état VISIBLE/MASQUÉ
     piloté en admin (content.visible) ; une page masquée disparaît de la nav, du footer et du
     sitemap (404/redirect). Permet d'activer une page quand son texte est prêt.
   - CALENDRIER (/calendrier) : page MASQUÉE PAR DÉFAUT (activable en admin), regroupe les
     événements + formations à venir (cartes : badge date, chip type, titre, lieu/format,
     description, lien ; filtres ; état vide soigné). Événements gérés en admin (table events).
   - FOOTER REVU : annuaire de toutes les pages VISIBLES, bien trié (Offre / Approche / Contact /
     Légal), sans surcharge ; placement de chaque page (nav/footer) configurable en admin.
2. /contact : wizard 5 ÉTAPES (Profil → MATURITÉ IA → Besoins → Contact OU Visio → Confirmation).
   - Étape Maturité : choix unique (Découverte / Premiers essais / En déploiement / Avancé),
     envoyé avec la demande (champ contact_submissions.maturity).
   - Dernière étape AVANT confirmation = choix entre deux voies : (A) message classique
     (nom/email/tél/message) OU (B) « Prévoir une visio » → embed CAL.COM AUTO-HÉBERGÉ stylé aux
     tokens du site ; la prise de rdv crée l'événement Cal.com ET enregistre la demande
     (channel='visio', bookingId). Validation Zod + React Hook Form, anti-spam, insert DB d'abord.
3. /admin (protégé Better Auth) : tableau de bord (stats), Contenus (table + tiroir d'édition
   onglets Contenu/SEO, corps Tiptap, statut Publié/Brouillon/En revue), PAGES (afficher/masquer
   + emplacement nav/footer/ordre par page), TÉMOIGNAGES (CRUD : photo, citation, nom, titre,
   entreprise), CALENDRIER (CRUD événements + toggle d'activation de la page), Demandes (inbox,
   incl. maturité + voie message/visio), Médias (upload → Garage S3), Apparence (éditeur de STYLE
   borné aux tokens : accent, style de bouton, rayon, graisse, + STYLE PAR BOUTON INDIVIDUEL
   (Plein/Entouré/Transparent), aperçu en direct ; persisté/injecté CSS vars :root au SSR), Réglages.
   Édition de TEXTE = dans Contenus/Pages ; édition de STYLE = dans Apparence. Les deux respectent le DS.

DESIGN (voir DESIGN.md + design-system/colors_and_type.css)
- Importer les TOKENS depuis colors_and_type.css → mapper dans Tailwind v4 @theme. Ne JAMAIS
  coder les hex en dur. Light + dark via [data-theme] / variante dark.
- Couleurs 60/30/10 (neutres / gris / accents iridescents pastel — souligner seulement).
- Type : Manrope (titres 600/700/800), Inter (corps), IBM Plex Mono (UI/mono). Échelle :
  H1 48/56 ls -0.01em, H2 36/44 -0.01em, H3 28/36, corps 16/26. Espacement base 8.
  Rayons 6/10/14/20/28/pill. Ombres TRÈS douces + halos iridescents. Verre givré = blur 18px.
- Motion : apparitions 300–400ms ease-out, hover translateY(-2px)+halo, press léger.
  Respecter prefers-reduced-motion (état final TOUJOURS visible, jamais bloqué à opacity:0).
- Icônes : Lucide (stroke 1.75, grille 24). PAS d'emoji.
- Logos : SVG mono (currentColor) pour UI/favicon, SVG flat pour petites marques, PNG 3D
  (symbol-frosted.png) pour visuels hero. Voir design-system/logos/.
- À ÉVITER : clichés IA (robots, cerveaux bleus), néon/cyber, dégradés saturés, stock
  générique. Seules touches colorées = iridescences pastel douces.

SEO / GEO / SÉCURITÉ (voir SEO_GEO_SECURITY.md)
- Metadata API dynamique depuis la DB, JSON-LD (Organization, WebPage/Article, BreadcrumbList,
  FAQPage), app/sitemap.ts dynamique, app/robots.ts (bloquer /admin), OG images.
- Viser LCP < 1.2s (RSC + PPR), Lighthouse SEO ≥ 95 / perf ≥ 90, CLS=0.
- Sécurité : CSP/HSTS/X-Frame-Options, Better Auth (sessions Valkey, 2FA TOTP optionnel),
  CSRF sur mutations, Zod partout, uploads validés (MIME/taille/ré-encodage), rate-limit Valkey,
  secrets en env (jamais dans le code), services data en réseau Docker interne.

LIVRABLES
- Monorepo complet qui démarre avec `docker-compose up` (frontend + backend + db + valkey +
  garage + mail), prêt pour Coolify (Traefik + webhook GitHub).
- .env.example documenté (sans secrets). README racine : install local, migrations Drizzle
  (generate/migrate), seed (admin + contenus de démo + réglages), build & déploiement Coolify.
- TypeScript strict, types/schémas Zod partagés. Code propre, composants petits et réutilisables.

PLAN DE TRAVAIL (procède dans cet ordre, montre-moi le résultat à chaque palier)
1) Scaffold monorepo + docker-compose + .env.example + Tailwind v4 avec tokens importés + fonts.
2) Backend : schéma Drizzle + migrations + Better Auth + endpoints publics (content, contact)
   avec Zod, rate-limit Valkey, mail SMTP, storage Garage.
3) Frontend site : layout (thème clair/sombre, fonts, JSON-LD), composants design system
   (Button, Header verre givré, Hero, ServiceCard, GlassPanel, Footer), Accueil pixel-fidèle
   à la référence, puis /services /souverainete /formations.
4) Wizard /contact (5 étapes : Profil → Maturité → Besoins → Message ou Visio Cal.com →
   Confirmation), validation, anti-spam, soumission DB + email ; embed Cal.com auto-hébergé.
5) /admin : auth + garde, tableau de bord, CRUD Contenus (Tiptap + SEO), Pages (afficher/masquer
   + emplacement), Témoignages, Calendrier (événements), Demandes, Médias (Garage), Apparence, Réglages.
6) SEO/GEO (metadata dynamique, JSON-LD, sitemap, robots, OG), sécurité (headers, CSRF),
   accessibilité AA, responsive, dark mode. Vérifier la Definition of Done de SEO_GEO_SECURITY.md.

Respecte la copy française EXACTE de CONTENT.md. En cas d'ambiguïté, privilégie la sobriété
premium "verre givré" décrite dans DESIGN.md et demande-moi avant d'ajouter du contenu non spécifié.
====================================================================
```

---

## Conseils d'usage

- **Donne le contexte d'abord** : ouvre Claude Code à la racine du repo qui contient `claude_code_handoff/`. La commande `/goal` lira les fichiers référencés.
- **Procède par paliers** : le plan de travail en 6 étapes évite le « tout d'un coup » illisible. Valide chaque palier.
- **Versions** : si Claude Code propose d'autres versions, renvoie-le à `STACK.md` (versions juin 2026 vérifiées).
- **Self-hosting** : rappelle le principe « aucun SaaS » si une suggestion tierce apparaît (Resend, R2, reCAPTCHA…).
- **Polices** : fournis les `.woff2` ou laisse `next/font` les self-héberger ; objectif zéro CLS.
