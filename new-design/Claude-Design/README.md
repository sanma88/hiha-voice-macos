# Handoff Claude Code — Site web premium + CMS hi-ha.be

Dossier de passation **auto-suffisant** pour construire l'application hi-ha.be avec **Claude Code**. Un développeur (ou un agent) qui n'a pas participé à la conception doit pouvoir tout implémenter à partir d'ici.

## À propos de ces fichiers
Les éléments de `design-reference/` et `design-system/` sont des **références de conception** : des prototypes HTML/React qui montrent l'apparence et le comportement visés — **pas du code de production à copier**. La tâche consiste à **recréer ces designs dans un codebase Next.js** neuf, avec ses patterns (Tailwind v4 + shadcn/ui re-stylé avec nos tokens). **Fidélité : haute (hi-fi)** — couleurs, typographie, espacements et interactions sont définitifs.

## Comment l'utiliser (one-shot avec `/goal`)
1. Copie ce dossier `claude_code_handoff/` à la racine d'un repo vide.
2. Ouvre **Claude Code** à la racine du repo.
3. Lance **`/goal`** en collant le bloc de **`BUILD_PROMPT.md`**.
4. Procède par les 6 paliers du plan de travail (valide chaque étape).

## Principe non négociable : 100% auto-hébergeable
**Aucun service tiers SaaS.** Email = SMTP self-hosted (Nodemailer + Maddy/docker-mailserver, jamais Resend) · Médias = **Garage S3** (jamais MinIO/R2) · Anti-spam = honeypot + Altcha (jamais reCAPTCHA) · Auth = Better Auth (librairie). Tout en conteneurs Docker sur le VPS (Coolify).

## Index des fichiers

| Fichier | Contenu |
|---|---|
| **`BUILD_PROMPT.md`** | ⭐ Le prompt `/goal` clé en main + conseils d'usage. **Commence ici.** |
| **`BRIEF.md`** | Contexte client : positionnement, différenciateurs, cibles, personnalité, ton de voix. |
| `STACK.md` | Stack technique + **versions exactes vérifiées (juin 2026)** + rationale + pièges. |
| `ARCHITECTURE.md` | Monorepo, conteneurs Docker, modèle de données, surface API, flux clés. |
| `DESIGN.md` | Design system pour le dev : tokens, couleurs, type, composants, motion, logos, à éviter. |
| `CONTENT.md` | Plan du site, **copy de référence en français**, wizard contact (5 étapes), spec CMS. |
| `SEO_GEO_SECURITY.md` | Exigences SEO + GEO (moteurs IA), sécurité production, **Definition of Done**. |
| `design-system/` | `colors_and_type.css` (**tokens**), `fonts.css` + `fonts/` (configs `next-fonts.ts`, `tailwind.fonts.config.js`, `font-tokens.json`, `self-host.css`), `logos/` (SVG + PNG 3D). |
| `design-reference/website/` | Prototype HTML/React du site (Accueil, wizard contact, admin) — **référence visuelle**. |

## Stack en un coup d'œil (détail dans STACK.md)
Next.js **16.2.7** (App Router, Turbopack) · TypeScript strict · Tailwind **v4** · shadcn/ui · Motion **12.40.0** (`motion/react`) · Hono **4.9.4** sur Bun **1.3.14** · Drizzle **0.43.1** · Better Auth **1.3.7** · PostgreSQL **16** · Valkey **8.1.8 LTS** · **Garage S3** · Nodemailer + React Email (SMTP self-hosted) · Tiptap **2** · Zod **3** · Docker + Coolify.

## Ce qui est construit
- **Site marketing** : Accueil (hero verre givré + symbole 3D, services, souveraineté, **témoignages**, CTA, footer), /services, /souverainete, /formations.
- **Pages toggleables (admin)** : /methodologie, /domaines, /temoignages, et les **légales** (/mentions-legales, /confidentialite, /cookies, /cgv) — visibles/masquables selon que le texte est prêt.
- **Témoignages** : section accueil + page dédiée, cartes premium (photo ronde logo/personne, citation, nom + titre + entreprise), éditables en admin.
- **Calendrier** (/calendrier) : agenda événements + formations, **masqué par défaut**, activable en admin.
- **Navigation** : menus **verticaux flottants** en verre givré avec **flyout à droite** (sous-niveaux), Approche (▸ Méthodologie/Domaines/Témoignages) en fin de nav + Calendrier ; en mobile, **overlay plein écran** (logo, toggle clair/sombre, X) à accordéons.
- **/contact** : formulaire dynamique **5 étapes** (Profil → **Maturité IA** → Besoins → **Message ou Visio Cal.com** → Confirmation).
- **/admin** : CMS léger protégé — Contenus (Tiptap + SEO), **Pages** (visible/masqué + emplacement nav/footer), **Témoignages**, **Calendrier** (événements), Demandes (+ maturité/voie), Médias Garage, **Apparence** (style borné aux tokens : accent, bouton, rayon, graisse, **+ style par bouton individuel**, aperçu en haut), Réglages.
- **Footer** réorganisé en annuaire trié (Offre · Approche · Contact · Légal), pages masquées retirées automatiquement.
- Light **et** dark, responsive mobile-first, SEO/GEO natif, **Cal.com auto-hébergé**, 100% auto-hébergé.

## Polices
Manrope / Inter / IBM Plex Mono — **self-hosted** via `next/font` (zéro CLS, RGPD). `design-system/fonts/self-host.css` fournit les `@font-face` prêts si tu déposes les `.woff2` ; sinon `next/font/google` les self-héberge automatiquement au build.
