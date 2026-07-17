# Stack technique — hi-ha.be

> Versions stables vérifiées **juin 2026**. Toutes les briques sont adoptées massivement, maintenues activement, et bien connues de Claude Code.
>
> ## ⚠️ Principe non négociable : 100% auto-hébergeable
> **Aucun service tiers SaaS.** Chaque brique tourne dans un conteneur Docker sur le VPS (Coolify). Pas de Resend, pas de Cloudflare R2, pas de reCAPTCHA/hCaptcha, pas d'analytics tiers. Tout ce qui sort du périmètre doit être remplacé par une alternative self-hosted documentée ci-dessous.

## Vue d'ensemble

Trois conteneurs Docker indépendants, orchestrés via `docker-compose`, déployables directement sur **Coolify** (reverse proxy Traefik + SSL + redéploiement webhook GitHub automatiques).

```
┌─────────────────────────────────────────────────────┐
│                   COOLIFY / VPS                       │
│                                                       │
│  ┌──────────────┐  ┌──────────────┐  ┌────────────┐  │
│  │  FRONTEND    │  │   BACKEND    │  │     DB     │  │
│  │  Next.js 16  │◄─┤  Hono + TS   │◄─┤ Postgres16 │  │
│  │ (App Router) │  │ (Bun runtime)│  │  + Valkey  │  │
│  └──────────────┘  └──────────────┘  └────────────┘  │
└─────────────────────────────────────────────────────┘
```

## Versions exactes (à épingler dans les `package.json`)

| Couche | Techno | Version juin 2026 | Notes d'installation |
|---|---|---|---|
| Frontend framework | **Next.js** | **16.2.7** (App Router) | Turbopack **stable et par défaut** (dev + prod) — aucun flag expérimental |
| Langage | **TypeScript** | 5.x `strict: true` | — |
| Styling | **Tailwind CSS** | **v4.x** | Config CSS-first (`@theme`), pas de `tailwind.config.js` lourd |
| Composants UI | **shadcn/ui** | latest (CLI) | Headless, copy-paste, 0 vendor-lock. Re-styler avec nos tokens |
| Animations | **Motion** (ex-Framer Motion) | **12.40.0** | ⚠️ import depuis `"motion/react"` (PAS `"framer-motion"`) |
| Fonts | **next/font** (self-hosted) | natif Next 16 | Manrope · Inter · IBM Plex Mono — zéro CLS, RGPD-friendly |
| Images | **next/image** | natif Next 16 | WebP/AVIF auto, lazy, CLS=0 |
| i18n (optionnel) | **next-intl** | latest | Site FR uniquement aujourd'hui → **non requis** ; à activer si multilingue plus tard |
| Backend API | **Hono** | **4.9.4** | TypeScript-first, ultra-léger |
| Runtime backend | **Bun** | **1.3.14** | Build + runtime du service backend |
| ORM | **Drizzle ORM** | **0.43.1** (stable npm) | ⚠️ **PAS la 1.0.0-beta** — rester sur 0.43.x pour des docs stables |
| Auth admin | **Better Auth** | **1.3.7** | Remplace NextAuth. 2FA TOTP optionnel |
| Email (rendu) | **React Email** | latest | Rendu des templates HTML (librairie, **pas** un service) |
| Email (transport) | **Nodemailer** → **SMTP auto-hébergé** | latest | ⚠️ **PAS Resend.** Relais via votre propre SMTP (voir ci-dessous) |
| Serveur SMTP | **Maddy** ou **docker-mailserver** | latest | Conteneur mail self-hosted. Source unique de vérité = la table `contact_submissions` ; l'email n'est qu'une **notification** |
| Anti-spam | **honeypot + rate-limit Valkey** (+ **Altcha** optionnel) | — | ⚠️ **PAS reCAPTCHA/hCaptcha.** Altcha = captcha proof-of-work auto-hébergeable |
| Base de données | **PostgreSQL** | **16** | Source de vérité unique |
| Cache / sessions | **Valkey** (Redis OSS) | **8.1.8 LTS** | Choix sage (maintenu jusqu'en 2030). 9.1 dispo mais inutile ici |
| Stockage médias | **Garage** (S3) | latest | ⚠️ **PAS MinIO ni Cloudflare R2.** Garage (Deuxfleurs) : S3-compatible, léger, 100% self-hosted, conteneur Docker dédié |
| Éditeur CMS | **Tiptap** | **2.x** | Rich text (blocks, markdown, médias) |
| Validation | **Zod** | **3.x** | Sur TOUS les endpoints + formulaires |
| Formulaires | **React Hook Form** | latest | + résolveur Zod |
| Déploiement | **Docker** + **Coolify** | — | Traefik auto |

## Pourquoi ce choix

- **Next.js 16 (App Router)** : Server Components par défaut → SEO et performance natifs (LCP < 1.2s via RSC + PPR). Imbattable dès qu'il y a auth, backoffice, formulaires dynamiques et interactivité riche (vs Astro qui gagne seulement sur le statique pur, vs SvelteKit dont l'écosystème TS/React est bien plus petit pour un CMS custom).
- **Hono sur Bun** : standard 2026 pour les nouvelles API, remplace Express/Fastify ; léger, edge-ready, typé.
- **Drizzle + Postgres** : migrations SQL lisibles, perfs proches du raw SQL, TS-first.
- **CMS custom** (pas Strapi/Payload) : 100% de contrôle, puisque le code est écrit avec Claude Code. Route `/admin` protégée dans le même monorepo.
- **Email auto-hébergé** : le formulaire de contact écrit d'abord en base (`contact_submissions`, visible dans l'admin “Demandes”). Une notification email est ensuite envoyée via Nodemailer → votre SMTP (Maddy/docker-mailserver). Aucune dépendance à un envoyeur tiers.
- **Garage S3** pour les médias : un conteneur S3-compatible (Deuxfleurs) chez vous, montable en volume Docker. L'API backend signe les URLs et gère l'upload via le SDK S3 standard (`@aws-sdk/client-s3`) — endpoint pointé sur Garage.

## Points de vigilance versions (pièges connus)

1. **Next.js = 16**, pas 15. Turbopack par défaut.
2. **Motion v12** : `import { motion } from "motion/react"`.
3. **Drizzle = 0.43.1**, surtout pas la beta 1.0 (docs instables).
4. **Valkey 8.1.8 LTS** suffit (cache + sessions). Pas besoin de la 9.1.
5. **next-intl** non requis tant que le site est monolingue (FR).
6. **Aucun SaaS** : email = SMTP self-hosted (jamais Resend) ; médias = **Garage S3** (jamais MinIO/R2) ; anti-spam = honeypot + Altcha (jamais reCAPTCHA). La **délivrabilité** d'un SMTP auto-hébergé demande SPF/DKIM/DMARC + IP propre ; si la délivrabilité devient critique, un relais SMTP reste possible **sans changer le code** (juste les variables d'env).
