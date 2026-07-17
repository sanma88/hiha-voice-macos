# Design system pour le dev — hi-ha.be

> Les fichiers de `design-system/` et `design-reference/` sont des **références de conception** (prototypes HTML/React montrant l'apparence et le comportement visés). À **recréer dans le codebase Next.js** avec ses patterns (Tailwind v4 + shadcn/ui), **pas** à copier tel quel. Fidélité : **haute (hi-fi)** — couleurs, type, espacements et interactions sont définitifs.

## Univers
Premium, calme, lumineux. **Verre givré (frosted glass)**, lumière douce, minimalisme premium, technologie humaine. **PAS** de tech sombre/cyber. Symbole : tête de cheval en verre givré 3D. **Contenu en français.** Clair **et** sombre (clair par défaut).

## Tokens
La source unique = **`design-system/colors_and_type.css`** (variables CSS, light + dark). En Tailwind v4, les mapper dans `@theme` (CSS-first). **Ne jamais coder les hex en dur** — toujours passer par les tokens pour que le dark mode fonctionne.

### Couleurs (ratio 60 / 30 / 10)
- **Neutres (~60%)** : Blanc Glacé `#F4F7FB`, Perle Givrée `#DFE1E9`.
- **Gris (~30%)** : Graphite `#41454D`, Graphite profond `#363B41`.
- **Accents iridescents (~10%, souligner seulement)** : Pêche `#ECDAD3`, Rose brume `#E2D0D4`, Lilas froid `#DAD9EE`. Accent lisible (liens/icônes actives) : `--accent-ink` = `#7E7BC4`.
- **Dark** : fond `#0B0B0C`, surface `#16181D`, interface `#22262D`, texte `#E7EAF0`.
- Tokens sémantiques : `--bg --bg-subtle --surface --surface-2 --surface-sunken --surface-glass --fg --fg-2 --fg-3 --fg-muted --border --border-strong --accent-ink --focus-ring --halo --iridescent`.
- **Accessibilité AA min** (Graphite/Blanc Glacé = AAA). Les pastels ne portent **jamais** de longs textes.

### Typographie
- **Titres** : Manrope (600/700/800). **Corps** : Inter (400/500/600/700). **Mono/UI** : IBM Plex Mono (400/500/600). Self-hosted via `next/font` (zéro CLS, RGPD).
- Échelle (taille/interligne px) : **H1 48/56 · H2 36/44 · H3 28/36 · H4 22/30 · H5 18/26 · H6 16/22 · Corps 16/26 · Légende 13/18.**
- Letter-spacing : **H1/H2 −0.01em**, H3 −0.005em, reste 0. Overline mono = +0.12em, MAJUSCULES.

### Espacement & grille
Base **8px** (8/16/24/32/40/48/64/80/96). Grille **12 colonnes**, marges généreuses, conteneur max ~1160px.

### Rayons
`--radius-xs 6 · sm 10 · md 14 · lg 20 · xl 28 · pill 999`. Cartes = md ; grands panneaux = lg/xl ; boutons/chips = pill.

### Ombres & profondeur
Ombres **très douces** (`--shadow-xs → lg`), `--shadow-glow` pour le halo. Jamais d'ombre dure. **Halos iridescents** pastel très diffus en décor (`--halo`). Surfaces **verre givré** : `--surface-glass` + `backdrop-filter: blur(18px)` + bordure 1px.

### Mouvement (Motion v12 — `import { motion } from "motion/react"`)
- Apparitions douces **300–400 ms**, easing `cubic-bezier(0.22,0.61,0.36,1)`. Fade + translation légère.
- **Hover très subtil** : `translateY(-2px)` + halo/ombre un cran au-dessus. Press : léger enfoncement, pas de rebond.
- Micro-interactions discrètes. **Jamais** d'animation permanente ou tape-à-l'œil.
- **Respecter `prefers-reduced-motion`** : l'état final doit toujours être visible (jamais bloqué à `opacity:0`). Gérer l'entrée par une classe ajoutée au montage, pas par un état caché permanent.

## Composants (voir `design-reference/website/`)
- **Boutons** : `primary` (fg/​bg inversé), `accent` (dégradé iridescent, texte graphite), `secondary` (surface + bordure), `ghost`. Tailles sm/md/lg, rayon pill.
- **Header** : barre flottante en **verre givré** (pill), logo + nav + toggle thème + CTA. **Menus verticaux flottants** en verre givré (détachés du header, centrés sous l'item, **sans chevron** dans le menu principal) ; une entrée à sous-niveau ouvre un **flyout vertical vers la droite** au survol. Panneaux peu transparents (≈0.97) pour la lisibilité ; hover+clic+clavier ; ponts de survol anti-fermeture. Sous 760px : **burger morphé en X** + **overlay plein écran** (verre givré quasi-opaque, halo) qui **embarque sa propre barre haute** (logo + hi-ha.be + toggle + X pour fermer) ; entrées en cascade, sous-menus en **accordéons**.
- **Hero** : overline mono, H1, sous-titre accent, description, 2 CTA, mini-stats. Visuel : **symbole 3D frosté** (`logos/symbol-frosted.png`) sur **halo iridescent** ; en **dark mode, halo + lueur émise à opacité 0.6**.
- **Cartes service** : icône (Lucide) dans tuile arrondie, titre, texte, lien « En savoir plus ». Hover translateY(-3px).
- **Panneau verre givré** : `surface-glass` + blur + halo interne (ex. schéma souveraineté en flow vertical).
- **Champs** : fond `surface-sunken`, bordure, focus = anneau `--focus-ring` (lilas). Cibles ≥ 44px.
- **Wizard contact** : indicateur d'étapes (dots + barres), cartes d'options sélectionnables, récap, écran succès. (Voir `CONTENT.md`.)
- **Admin** : sidebar, cartes stats, table de contenus (statut = point coloré), **tiroir d'édition** (onglets Contenu/SEO), **éditeur d'Apparence** (style des éléments borné aux tokens : accent, style de bouton, rayon, graisse, **+ style par bouton individuel** Plein/Entouré/Transparent — aperçu en direct), **Pages** (visible/masqué + emplacement nav/footer), **Témoignages** et **Calendrier** (CRUD).
- **Témoignage (premium)** : carte verre givré / surface, **photo ronde** (logo entreprise OU personne, petite), **citation** Manrope `text-wrap:pretty`, **nom + titre**, puis **entreprise**. Accent iridescent discret (guillemet/filet). Accueil : 2–3 en avant (grille ou carrousel léger) ; page dédiée : grille.
- **Carte événement (Calendrier)** : badge date (jour/mois), chip type (`Formation`/`Événement`), titre, lieu/format, courte description, lien. Filtres simples ; état vide soigné.

## Iconographie
**Lucide** (`stroke-width: 1.75`, grille 24, coins arrondis) — substitution assumée faute d'icônes natives. Mapping : Automatisation `workflow`/`zap` · Assistant `bot`/`message-circle` · Workflow `git-branch` · Formation `graduation-cap` · Paramétrage `settings` · Souveraineté `shield`/`server`/`lock`. **Pas d'emoji.**

## Logos (`design-system/logos/`)
- **SVG** (recommandés) : `symbol.svg` & `wordmark.svg` (mono `currentColor`), `symbol-white.svg`, `symbol-flat-light/dark.svg` (gradient iridescent), `lockup-mono*.svg`, `lockup-flat-*.svg`, `wordmark-editable.svg`.
- **PNG 3D** (visuels hero) : `symbol-frosted.png` (transparent), `lockup-3d-light/dark.png`, `lockup-flat-*.png`.
- **Usage** : SVG mono → favicon/UI/print ; SVG flat → petites marques sur clair/sombre ; PNG 3D → grands visuels hero. Le 3D frosté (clair) **demande un fond contrasté ou un halo** pour ressortir.
- **Zone de protection** : 1× la hauteur du symbole. **Tailles min** : 120px logo complet / 32px icône.

## À éviter absolument
Clichés IA (robots, cerveaux bleus, mains sur hologramme) ; néon/cyber/polygonal ; dégradés saturés cyan-magenta ; fonds spatiaux chargés ; aspect « généré par IA »/stock générique ; dégradés criards. **Seules touches colorées = iridescences pastel très douces.**
