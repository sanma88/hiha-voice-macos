# SEO / GEO & Sécurité — hi-ha.be

## SEO — natif Next.js 16 (App Router)

- **Metadata API** : `generateMetadata()` par page, **dynamique depuis la DB** (champs SEO du CMS : metaTitle, metaDescription, ogImage).
- **Structured Data (JSON-LD)** injecté côté serveur : `Organization` (global), `WebSite`, `WebPage`/`Article`, `BreadcrumbList`, `FAQPage` quand pertinent.
- **`app/sitemap.ts`** : sitemap dynamique (pages statiques + contenus publiés depuis la DB).
- **`app/robots.ts`** : robots.txt propre (autoriser le site, bloquer `/admin`).
- **Open Graph + Twitter Cards** auto-générés. Prévoir une **OG image** par page (champ CMS) avec fallback de marque.
- **hreflang** : géré par next-intl **uniquement si** passage multilingue (FR seul aujourd'hui → non requis).
- **Core Web Vitals** : viser **LCP < 1.2s** via RSC + **PPR** (Partial Pre-Rendering), `next/image` (AVIF/WebP, CLS=0), `next/font` self-hosted (zéro CLS).
- **URLs propres** : slugs FR lisibles, une seule URL canonique par page (`<link rel="canonical">`).

## GEO — optimisation pour les moteurs IA (ChatGPT, Perplexity…)

- **Contenu structuré et entités sémantiques claires** : titres explicites, définitions, listes, tableaux — les LLM indexent mieux le contenu structuré.
- **FAQ schema** (`FAQPage`) sur les pages clés (services, souveraineté) avec questions/réponses concrètes.
- **Réponses directes** : chaque page répond à une intention précise dès le premier paragraphe (qui, quoi, pour qui, bénéfice).
- **Glossaire / définitions** des termes différenciants (IA locale, souveraineté des données, n8n, agents) — utile humains **et** machines.
- Cohérence **NAP** (nom, adresse, contact) + `Organization` JSON-LD pour l'entité hi-ha.be.

## Sécurité — checklist production (100% self-hosted)

- **Headers HTTP** : CSP stricte, HSTS, `X-Frame-Options: DENY`, `X-Content-Type-Options: nosniff`, `Referrer-Policy`. Configurer dans Next (middleware/headers) et/ou Traefik.
- **Auth admin** : **Better Auth** (self-hosted, sessions en Valkey), **2FA TOTP** optionnel, cookies `httpOnly`+`secure`+`sameSite`, rôles (`admin`).
- **CSRF** : protection sur les mutations admin (token / double-submit) — Hono middleware.
- **Validation** : **Zod** sur **tous** les endpoints (publics et admin), entrées rejetées par défaut.
- **Uploads** (Garage S3) : validation MIME + extension + taille max, renommage (clé opaque), pas d'exécution, ré-encodage/optimisation image côté backend avant stockage.
- **Rate limiting** : Valkey, sur endpoints publics sensibles (`POST /api/contact`, auth) — par IP + fenêtre glissante.
- **Anti-spam contact** : honeypot + **Altcha** (proof-of-work self-hosted) — **jamais** reCAPTCHA/hCaptcha.
- **Secrets** : variables d'environnement Coolify, **jamais** dans le code ni le repo. Fournir `.env.example` sans valeurs.
- **Réseau** : Postgres, Valkey, Garage, mail = **réseau Docker interne uniquement**. Seul `frontend` est exposé via Traefik. SSL Let's Encrypt auto (Coolify).
- **Sauvegardes** : dumps Postgres planifiés + snapshot des volumes Garage (cron / job Coolify).
- **Logs & erreurs** : pas de fuite de stack en prod ; journaux structurés côté backend.

## Définition de « terminé » (Definition of Done)

- [ ] Build prod OK (`frontend` + `backend`) via `docker-compose up`, derrière Traefik/Coolify.
- [ ] Light **et** dark, responsive mobile/tablette/desktop, `prefers-reduced-motion` respecté.
- [ ] Fonts self-hosted (Manrope/Inter/IBM Plex Mono), zéro CLS.
- [ ] Pages marketing + wizard contact fonctionnels (insert DB + email SMTP self-hosted).
- [ ] `/admin` protégé (Better Auth) : CRUD contenus, Demandes, Médias (Garage), Réglages.
- [ ] SEO : metadata dynamique, JSON-LD, sitemap, robots, OG. Lighthouse SEO ≥ 95, perf ≥ 90.
- [ ] Aucun service tiers SaaS dans les dépendances runtime.
- [ ] Accessibilité AA, focus visibles, cibles ≥ 44px.
