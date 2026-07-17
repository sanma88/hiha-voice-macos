# Design System: HI-HA
**Project ID:** hi-ha-ai-flow

> Format conforme à la [spec Stitch DESIGN.md](https://stitch.withgoogle.com/docs/design-md/overview/) (Google Labs, open source).
> Ce fichier décrit le système visuel de HI-HA Agency — plateforme de formations en IA & automatisation basée à Liège, Belgique — dans un langage lisible à la fois par les humains et par les agents IA de génération d'UI.

---

## 1. Visual Theme & Atmosphere

**Vibe** : cheval cosmique. Moderne, technologique, élégamment chaotique — à l'image de l'IA qu'on enseigne : puissante, galopante, mais domestiquée par le design.

**Adjectifs directeurs** : *lumineux, profond, orbital, précis, confiant, organique-numérique*.

L'interface cultive une tension volontaire entre **deux registres** :
- **Un fond sobre et discipliné** — typographie neutre, grilles strictes, cartes sans bruit — pour que le contenu technique reste lisible et crédible auprès d'un public professionnel.
- **Des éclats visuels flashy et oniriques** — dégradés violet-cyan, halos flous, blobs morphants qui respirent — pour signaler qu'on est dans le domaine de l'IA, pas dans une ERP de comptabilité.

**Posture émotionnelle** : rassurer d'abord (typographie Inter neutre, espacement généreux, bleu marine autoritaire), puis émerveiller (gradient signature sur les titres, blobs flottants en arrière-plan). Jamais l'inverse.

**Pourquoi ce choix** : la cible hybride (dirigeants non-techniques + profils techniques) a besoin d'un code visuel qui dise à la fois "on est sérieux" et "on est à la pointe". Le flashy sur les titres + le sobre sur le contenu résout cette tension.

**Dark-first** : le thème sombre n'est pas un accessoire mais l'expression canonique de la marque (ciel nocturne, étoiles, IA qui calcule la nuit). Le thème clair est une déclinaison fonctionnelle pour lecture diurne et accessibilité.

---

## 2. Color Palette & Roles

Toutes les couleurs sont stockées en HSL dans des variables CSS, permettant un basculement clair/sombre par simple classe `.dark` sur `<html>`. Les noms ci-dessous sont les **appellations canoniques de la marque** — à utiliser dans les discussions design. Les hex sont donnés pour référence visuelle (la vérité technique reste le HSL, voir annexe).

### 2.1 Mode clair (Daybreak)

Ambiance : matin polaire, ciel dégagé après la brume. Fonds presque blancs, contrastes nets, accents violets-cyan saturés pour les moments de grâce.

| Nom canonique | Hex | HSL | Rôle fonctionnel |
|---|---|---|---|
| **Glacial Mist** | `#F9FAFC` | `220 33% 98%` | Fond de page principal — presque blanc, légère teinte bleue pour apaiser les yeux |
| **Abyssal Navy** | `#0F172A` | `222 47% 11%` | Texte principal, titres — bleu nuit très profond pour lisibilité maximale |
| **Pure Canvas** | `#FFFFFF` | `0 0% 100%` | Surface des cartes et popovers — blanc pur pour se détacher de Glacial Mist |
| **Sovereign Marine** | `#0F3A8A` | `222 80% 30%` | Couleur d'action primaire (boutons, CTA, stats) — bleu marine saturé qui inspire la confiance institutionnelle |
| **Electric Violet** | `#7A6EDB` | `250 60% 60%` | Accent 1 (extrémité gauche des dégradés de titres, blobs, icônes sociales) — violet vif, signe de créativité IA |
| **Aurora Cyan** | `#1ABFE6` | `190 80% 50%` | Accent 2 (extrémité droite des dégradés, halos d'arrière-plan) — cyan lumineux, signe de précision technologique |
| **Pale Linen** | `#EEF2F7` | `210 40% 96%` | Fond alternatif de section — gris ultra-pâle pour créer du rythme entre zones sans ajouter de bordure |
| **Slate Mist** | `#64748B` | `215 16% 47%` | Texte discret, labels secondaires, métadonnées — gris moyen qui recule sans disparaître |
| **Misted Silver** | `#E2E8F0` | `214 32% 91%` | Bordures d'inputs, séparateurs — gris très pâle, présent sans être visible |
| **Signal Coral** | `#EF4444` | `0 84% 60%` | Erreurs, actions destructives — rouge saturé qui interrompt volontairement |
| **Obsidian Ring** | `#01060E` | `222 84% 4%` | Anneau de focus clavier — noir bleuté pour contraste absolu |

### 2.2 Mode sombre (Orbital Night)

Ambiance : salle serveur à minuit, lumière des écrans, étoile lointaine. Fond bleu nuit, texte blanc cassé, surfaces qui se fondent les unes dans les autres.

| Nom canonique | Hex | HSL | Rôle fonctionnel |
|---|---|---|---|
| **Abyssal Navy** | `#0F172A` | `222 47% 11%` | Fond de page principal ET surface des cartes — volontairement identique pour créer un univers sans couture |
| **Lunar White** | `#F8FAFC` | `210 40% 98%` | Texte principal ET couleur d'action primaire (inversion délibérée : en sombre, un bouton primaire est blanc) |
| **Graphite Blue** | `#1E293B` | `217 33% 17%` | Surface secondaire unique regroupant `secondary`, `muted`, `accent`, `border` — tous fusionnés en un seul ton pour un dégradé de profondeur plus qu'un jeu de couleurs |
| **Starlight Grey** | `#94A3B8` | `215 20% 65%` | Texte discret — gris clair lumineux qui évoque une étoile distante |
| **Ember Rust** | `#7F1D1D` | `0 63% 31%` | Erreurs, actions destructives — rouge sourd qui alerte sans crier dans l'obscurité |
| **Dawn Ring** | `#F0F9FF` | `212 100% 97%` | Anneau de focus clavier — blanc bleuté, contraste absolu sur le fond sombre |

### 2.3 Règles de rôle transversales

- **Le primaire s'inverse d'un mode à l'autre** (marine bleu en clair, blanc en sombre). C'est intentionnel : la "couleur d'autorité" est toujours la plus forte opposition au fond.
- **En mode sombre, les surfaces secondaires fusionnent** en un unique Graphite Blue. Ne pas chercher à recréer de la variété — la profondeur vient du jeu d'opacités, pas de la diversité chromatique.
- **Le texte secondaire** utilise toujours l'opacité `/80` appliquée à la couleur de texte principale (Abyssal Navy en clair, Lunar White en sombre), jamais une couleur tierce. Cela garantit la cohérence automatique dans les deux modes.
- **Les accents violet-cyan ne sont visibles qu'en mode clair** et dans les dégradés/blobs : ils ne portent pas d'interaction fonctionnelle. Ils sont décoratifs, signalent la marque, mais ne doivent jamais être la seule affordance d'un bouton.

### 2.4 Dégradé signature (brand gradient)

Direction : gauche → droite. Du **Electric Violet** (#7A6EDB) vers l'**Aurora Cyan** (#1ABFE6).

Usage canonique : **uniquement sur les éléments narratifs courts** — titres de hero (H1), wordmark du logo, titre de footer. Jamais sur du texte long (illisible). Jamais sur un bouton (concurrencerait l'action primaire).

**Pourquoi ce gradient** : il raconte la signature HI-HA — la créativité (violet) qui rencontre la précision (cyan). Le parcours visuel de gauche à droite mime la lecture.

### 2.5 Conformité d'accessibilité

Tous les couples `foreground/background` respectent **WCAG 2.1 AA** (ratio ≥ 4.5:1 pour texte normal, ≥ 3:1 pour texte large) :
- Abyssal Navy sur Glacial Mist → ratio ~17:1 (AAA)
- Lunar White sur Abyssal Navy → ratio ~16:1 (AAA)
- Sovereign Marine sur Pure Canvas → ratio ~9:1 (AAA)
- Slate Mist sur Glacial Mist → ratio ~5:1 (AA)

Les accents Electric Violet et Aurora Cyan **ne doivent jamais porter du texte seul** — leur contraste est insuffisant. Toujours les utiliser en fond décoratif, dégradé, ou avec un halo flouté.

---

## 3. Typography Rules

### 3.1 Famille unique

**Inter** est l'unique police du système. Aucune alternative, aucune variante secondaire. Importée depuis Google Fonts, graisses 300 / 400 / 500 / 600 / 700.

**Pourquoi Inter** : lettres ouvertes qui respirent, chiffres tabulaires natifs (utile pour stats), excellent rendu à toutes les tailles, neutralité culturelle — on raconte de l'IA, pas une identité graphique personnelle.

### 3.2 Hiérarchie

La hiérarchie est construite par **contraste de taille et de graisse**, jamais par couleur. Aucun titre n'a de couleur propre — tous héritent du texte principal, sauf les H1 qui reçoivent le dégradé signature.

| Niveau | Taille perçue | Graisse | Usage | Note |
|---|---|---|---|---|
| **Hero H1** | Très grand, responsive (36 → 48 → 60 px) | Bold (700) | Titre principal de page d'accueil, accroches marketing | **Toujours** enveloppé dans le dégradé signature violet-cyan |
| **Section H2** | Grand (30 → 36 px) | Bold (700) | Titre de section (Services, Expertise, Contact…) | Couleur de texte standard, centré dans son bloc d'intro |
| **Sub-heading H3 / CardTitle** | Moyen (24 px) | Semi-bold (600) | Sous-titres, titres de cartes | Tracking légèrement serré, hauteur de ligne resserrée |
| **Column heading H4** | Base (16 px) | Semi-bold (600) | Titres de colonnes en footer, mini-sections | |
| **Lead paragraph** | Large (20 px) | Regular (400) | Premier paragraphe sous un H1 hero | Opacité `/80` sur la couleur de texte |
| **Body** | Base (16 px) | Regular (400) | Corps de texte par défaut | Opacité `/80` pour paragraphes secondaires |
| **Label / meta** | Petit (14 px) | Medium (500) ou Regular | Labels de formulaire, descriptions de carte, métadonnées | Couleur Slate Mist (mode clair) / Starlight Grey (sombre) |
| **Badge / caption** | Très petit (12 px) | Semi-bold (600) | Badges, pastilles de statut | Lettres nettes, pas de capitalisation automatique |

### 3.3 Règles d'usage

- **Une seule H1 par page.** Toujours habillée du dégradé signature. C'est le moment signature de la marque.
- **Les titres ne portent jamais de majuscules forcées** (pas de `uppercase`). L'intention est littéraire, pas corporate.
- **Le texte long ne dépasse jamais `max-w-2xl`** (~672 px) pour rester lisible, sauf contenu tabulaire ou grille de cartes.
- **Interligne** : resserré sur les titres (`leading-tight` ou `leading-none`), aéré sur le corps (interligne par défaut du navigateur).
- **Aucune décoration** : pas de soulignement, pas d'italique superflu. Le gras est réservé aux titres ; dans le corps de texte, on préfère reformuler plutôt qu'emphatiser.
- **Le texte d'opacité `/80`** est la règle pour tout paragraphe secondaire — il recule sans se perdre.

---

## 4. Component Stylings

Chaque composant est décrit en langage naturel. Les classes techniques exactes figurent en annexe (§6).

### 4.1 Buttons

**Philosophie** : le bouton est un volume, pas un lien. Il a un corps plein, des coins subtilement arrondis, une hauteur généreuse qui invite à cliquer.

- **Forme** : coin subtilement arrondi (6 px), jamais de forme pilule sauf cas spécial.
- **Hauteur** : confortable au toucher (40 px par défaut, 44 px en taille large pour les CTA hero).
- **Padding intérieur** : horizontal généreux (16 à 32 px selon la taille) pour que le texte respire.
- **Transition** : uniquement sur les couleurs au survol, jamais de transformation d'échelle, jamais de shadow qui gonfle. Le bouton reste stable, seule sa teinte réagit.
- **Focus clavier** : anneau net de 2 px coloré (Obsidian Ring en clair, Dawn Ring en sombre), décalé de 2 px du bord pour rester visible sur tous les fonds.
- **État désactivé** : opacité à 50 %, curseur bloqué, aucune interaction visuelle.
- **Icône** : si présente, placée à gauche du texte, taille exactement 16 px, espace de 8 px entre icône et label.

**Variantes fonctionnelles** :

1. **Primary (default)** — Fond Sovereign Marine (clair) / Lunar White (sombre), texte inversé. Au survol, le fond s'assombrit légèrement (opacité 90 %). C'est le bouton d'action principale : un seul par zone visible.
2. **Outline** — Bordure fine Misted Silver, fond transparent, texte dans la couleur de texte principale. Au survol, le fond devient la surface secondaire et le texte passe en couleur d'accent. C'est le bouton de choix secondaire ("Découvrir nos services" à côté de "Automatisons !").
3. **Secondary** — Fond Electric Violet (clair) / Graphite Blue (sombre), texte clair. Usage rare ; réservé aux contextes où un bouton doit s'inscrire dans un univers coloré plutôt qu'être l'action primaire.
4. **Ghost** — Aucun fond, aucune bordure. Au survol, prend la surface secondaire. Pour les actions de navigation dans des menus denses.
5. **Link** — Comportement typographique, souligné au survol uniquement, couleur primaire. Pour les liens inline dans du texte courant.
6. **Destructive** — Fond Signal Coral / Ember Rust. Réservé aux actions irréversibles (suppression). Jamais comme CTA marketing.

**Tailles** :
- `sm` (36 px) — boutons de header, actions secondaires condensées
- `default` (40 px) — partout ailleurs
- `lg` (44 px) — CTA de hero, formulaires d'inscription majeurs
- `icon` (40×40 px) — bouton carré ne portant qu'une icône

### 4.2 Cards / Containers

**Philosophie** : la carte est une surface flottante, pas un coffre. Ombre à peine perceptible, coins doux, bordure optionnelle mais discrète. Elle contient du contenu, elle ne l'emprisonne pas.

- **Forme** : coins modérément arrondis (8 px), jamais anguleux.
- **Fond** : Pure Canvas (clair) / Abyssal Navy (sombre). Dans certaines sections secondaires, on utilise un fond semi-transparent `/50` pour que la carte se fonde dans le fond de section.
- **Bordure** : présente par défaut (Misted Silver), mais **souvent retirée** sur les cartes d'expertise et de statistiques pour alléger visuellement une grille dense — on se repose alors sur l'ombre seule.
- **Ombre** : ombre douce à peine perceptible au repos (shadow-sm). Au survol sur les cartes interactives, l'ombre devient légèrement plus marquée (shadow-md) avec une transition de 300 ms, sans aucune transformation géométrique.
- **Padding intérieur** : 24 px partout. Jamais moins, rarement plus.
- **Structure** : un header (titre + description optionnelle), un contenu, un footer optionnel. Les trois zones sont séparées par un padding cohérent plutôt que par des bordures.
- **Titre de carte** : 24 px, semi-bold, tracking resserré, hauteur de ligne collée au texte.
- **Description** : 14 px, couleur Slate Mist / Starlight Grey.

**Variantes d'usage** :
- **Stats card** (chiffres clés) — fond semi-transparent à 50 %, sans bordure, ombre seule. Le chiffre est en 30 px bold Sovereign Marine, la description en Slate Mist.
- **Expertise card** (grille d'items) — sans bordure, ombre douce, réagit au survol par un renforcement d'ombre uniquement.

### 4.3 Inputs / Forms

**Philosophie** : l'input est un champ calme qui s'active lorsqu'on le touche. Pas de décoration, pas de drame, un focus net mais bref.

- **Forme** : coins arrondis (6 px), hauteur identique à un bouton default (40 px) pour que formulaires et CTA s'alignent parfaitement.
- **Bordure** : Misted Silver au repos, très fine (1 px).
- **Fond** : identique au fond de la zone parente (Pure Canvas sur une carte, Glacial Mist sur la page).
- **Padding** : 12 px horizontal, 8 px vertical.
- **Placeholder** : couleur Slate Mist, jamais en italique.
- **Focus** : le champ gagne un anneau de 2 px coloré (Obsidian Ring / Dawn Ring) décalé de 2 px pour rester lisible. Aucune ombre interne, aucun changement de fond.
- **État désactivé** : opacité 50 %, curseur bloqué, jamais grisé d'une teinte différente.
- **Textarea** : même style, hauteur minimale 80 px, redimensionnable verticalement uniquement.
- **Label** : 14 px medium, toujours au-dessus du champ, jamais en placeholder-flottant.

### 4.4 Badges

- **Forme** : pastille complète (rounded-full), bordure transparente, padding horizontal 10 px, vertical 2 px.
- **Texte** : 12 px semi-bold, pas de capitalisation forcée.
- **Usage** : statut, catégorie, étiquette courte. Jamais comme bouton.

### 4.5 Navigation (header)

- **Position** : fixée en haut, toute largeur, toujours au-dessus du contenu (z-index maximal du site).
- **État initial** (haut de page) : totalement transparent, laisse voir les blobs colorés de fond.
- **État scrollé** (après 10 px de scroll) : fond opaque à 95 % avec flou d'arrière-plan (backdrop-blur), ombre légère en bas pour créer la séparation. Transition de 300 ms.
- **Logo** : carré 64 px à coins arrondis à gauche, suivi du wordmark en dégradé signature.
- **Liens nav** : texte de même graisse que le corps, opacité `/80`, passent à `/100` au survol, aucune soulignement.
- **CTA header** : bouton primary taille `sm`, toujours aligné à droite, texte court et direct.
- **Mobile** : menu hamburger à droite, le tiroir descend depuis sous le header avec une bordure supérieure fine.

### 4.6 Decorative background elements

**Blobs animés (hero)** : trois disques flous de 384 px de diamètre, positionnés aux coins opposés d'une zone. Chacun prend une couleur d'accent (Electric Violet, Aurora Cyan, Sovereign Marine) à 20 % d'opacité, passé en mode de fusion *multiply*, flouté massivement (blur-3xl), et flottant doucement verticalement (oscillation de ±10 px sur 6 secondes). Les trois blobs ont un décalage d'animation (0s, 2s, 4s) pour éviter toute synchronisation mécanique — ils respirent indépendamment.

**Blob organique (hero image)** : forme morphante aux bordures asymétriques animées qui passent de `42% 58% 70% 30% / 45% 45% 55% 55%` à `72% 28% 30% 70% / 65% 65% 35% 35%` sur 15 secondes en alternance. Le dégradé qui le remplit va de Electric Violet à 80 % vers Aurora Cyan à 80 %, en diagonale descendante. L'image du hero repose par-dessus, légèrement plus petite, dans un cadre carré arrondi à coins généreux (16 px).

**Halos de section** : variante statique des blobs, à 10 % d'opacité, sans animation, placés aux coins de sections pour créer de la profondeur ambiante sans concurrencer le contenu.

### 4.7 Footer

- **Inversion chromatique volontaire** : en mode clair, le footer est sombre (fond Abyssal Navy, texte Glacial Mist) ; en mode sombre, il est clair (fond Lunar White, texte Abyssal Navy). Cette inversion signale la fin du parcours et crée un contraste franc avec la dernière section.
- **Structure** : quatre colonnes (marque, services, à-propos, newsletter), gap généreux (32 px).
- **Liens** : texte opacité `/80`, passent à `/100` au survol.
- **Séparateur bas** : bordure fine `/20` au-dessus de la ligne de copyright et mentions légales.
- **Icônes sociales** : cercles pleins inverses (fond = couleur de texte du footer), icônes en couleur de fond du footer, au survol l'opacité diminue à 80 %.

---

## 5. Layout Principles

### 5.1 Whitespace strategy

Le blanc est un matériau, pas un vide. HI-HA utilise un **espacement généreux mais rythmé** : on ne remplit pas pour remplir, on laisse respirer les blocs pour que chaque information ait sa scène.

- **Sections** : padding vertical de 64 px sur mobile, 96 px sur desktop. C'est le même intervalle entre toutes les sections — le rythme de lecture est constant.
- **Titre de section vers contenu** : toujours 48 px (`mb-12`) ou 64 px (`mb-16`) pour les sections majeures. Jamais moins, pour que le titre "règne" avant le contenu.
- **Intra-contenu** : entre éléments verticaux, on utilise un stack de 16 à 24 px selon la densité. Entre cartes dans une grille, 24 px (grille dense) ou 32 px (grille aérée).
- **Paragraphes** : limités à `max-w-2xl` (672 px) pour la lisibilité, centrés quand il s'agit d'intro de section.

### 5.2 Grid & container

- **Container maître** : largeur maximale 1280 px, centré, avec padding latéral qui s'étoffe selon le viewport (16 px mobile, 24 px tablette, 32 px desktop).
- **Grilles standards** :
  - 1 colonne sur mobile
  - 2 colonnes sur tablette (≥ 768 px)
  - 3 colonnes sur desktop (≥ 1024 px) pour les grilles denses (expertise), 4 colonnes pour le footer
- **Hero** : grille 2 colonnes symétriques sur desktop (texte à gauche, visuel à droite), empilement vertical sur mobile.
- **Alignement** : les titres d'intro de section sont centrés ; les contenus complexes (grilles, formulaires) sont alignés à gauche.

### 5.3 Sectional rhythm

Les sections alternent leur fond pour créer un pouls visuel, **sans jamais utiliser de bordure horizontale** :
- Section 1 : fond principal (Glacial Mist / Abyssal Navy)
- Section 2 : fond légèrement teinté (Pale Linen à 50 %)
- Section 3 : fond principal
- Section 4 : fond légèrement teinté à 30 %
- etc.

L'effet est un battement discret qui aide l'œil à se repérer dans un long scroll.

### 5.4 Radii & shadows philosophy

- **Rayons** : une seule valeur maîtresse à 8 px, déclinée en 6 px (inputs, boutons) et 4 px (micro-éléments). Pour les avatars et logos, on passe en 16 px ou en cercle complet — jamais d'intermédiaire.
- **Ombres** : uniquement trois niveaux, jamais colorées :
  - **Souffle** (shadow-sm) : état au repos des cartes, quasi-imperceptible, suggère la surface flottante.
  - **Soulèvement** (shadow-md) : état au survol des cartes interactives, transition de 300 ms.
  - **Présence** (shadow-lg) : images hero, portrait à-propos, éléments qui doivent s'ancrer.
- **Aucune ombre intérieure, aucune ombre colorée.** La profondeur vient de la lumière blanche douce, pas d'un effet néon.

### 5.5 Motion philosophy

Le mouvement est **organique et ambiant**, jamais théâtral.

- **Entrée de page** : fondu opacité de 400 ms avec léger délai (150 ms). Aucun slide, aucun bounce.
- **Apparition au scroll** : chaque section majeure se révèle lorsqu'elle entre dans le viewport — translation verticale de 40 px accompagnée d'un fondu, sur 700 ms. Une seule fois, jamais à la sortie.
- **Titres hero et premiers contenus** : cascade de fondus montants à 200 ms d'écart (`fade-in-delay-1`, `-delay-2`, `-delay-3`) pour créer une arrivée orchestrée sans effet "loading".
- **Blobs** : flottement perpétuel de 6 secondes, oscillation verticale de 10 px. Les trois blobs de la scène hero sont désynchronisés (0s, 2s, 4s de délai) pour éviter tout effet mécanique.
- **Blob morphant** : déformation continue sur 15 secondes en alternance, suffisamment lente pour être vue comme "vivante" plutôt que "animée".
- **Hover** : uniquement des transitions de couleur et d'ombre. **Jamais** de transformation géométrique (scale, rotate, translate) au survol — HI-HA refuse l'effet "bouton qui saute" considéré comme daté.
- **Scroll** : lissé globalement (`scroll-behavior: smooth`) pour un défilement cinématographique entre ancres.

### 5.6 Responsive behavior

- **Mobile-first** : toutes les règles sont écrites pour mobile d'abord, puis étendues.
- **Breakpoints** : tablette à 768 px, desktop à 1024 px, large à 1280 px.
- **Règle d'or** : rien ne doit nécessiter de scroll horizontal, ever. Les grilles s'effondrent en colonne unique avant toute autre chose.
- **Menu** : hamburger sous 1024 px, navigation complète au-delà.
- **Hero** : visuel placé sous le texte sur mobile (ordre inversé), à côté du texte sur desktop.

### 5.7 Accessibility contract

- **Focus clavier** systématiquement visible (anneau de 2 px). Jamais d'`outline: none` sans remplacement.
- **Ratio de contraste** minimum WCAG AA partout (voir §2.5).
- **Labels ARIA** sur tout bouton qui ne porte qu'une icône (menu hamburger, liens sociaux).
- **Attributs d'état** (`aria-expanded`, `aria-selected`) sur tous les toggles et onglets.
- **Scroll reveal ne masque jamais le contenu de façon permanente** : si JavaScript échoue, le contenu reste visible.
- **Animations respectent `prefers-reduced-motion`** (à implémenter au besoin en écrasant les keyframes).

---

## Annexe A — Variables CSS officielles

Les valeurs ci-dessous sont **la source de vérité technique**. Les hex donnés dans §2 sont des approximations pour référence visuelle — toute implémentation doit utiliser les HSL.

```css
:root {
  --background: 220 33% 98%;       /* Glacial Mist */
  --foreground: 222 47% 11%;       /* Abyssal Navy */
  --card: 0 0% 100%;                /* Pure Canvas */
  --card-foreground: 222 47% 11%;
  --popover: 0 0% 100%;
  --popover-foreground: 222 47% 11%;
  --primary: 222 80% 30%;           /* Sovereign Marine */
  --primary-foreground: 210 40% 98%;
  --secondary: 250 60% 60%;         /* Electric Violet */
  --secondary-foreground: 210 40% 98%;
  --muted: 210 40% 96%;             /* Pale Linen */
  --muted-foreground: 215 16% 47%;  /* Slate Mist */
  --accent: 190 80% 50%;            /* Aurora Cyan */
  --accent-foreground: 222 47% 11%;
  --destructive: 0 84% 60%;         /* Signal Coral */
  --destructive-foreground: 210 40% 98%;
  --border: 214 32% 91%;            /* Misted Silver */
  --input: 214 32% 91%;
  --ring: 222 84% 4%;               /* Obsidian Ring */
  --radius: 0.5rem;
}

.dark {
  --background: 222 47% 11%;        /* Abyssal Navy */
  --foreground: 210 40% 98%;        /* Lunar White */
  --card: 222 47% 11%;
  --card-foreground: 210 40% 98%;
  --popover: 222 47% 11%;
  --popover-foreground: 210 40% 98%;
  --primary: 210 40% 98%;           /* Lunar White */
  --primary-foreground: 222 47% 11%;
  --secondary: 217 33% 17%;         /* Graphite Blue */
  --secondary-foreground: 210 40% 98%;
  --muted: 217 33% 17%;
  --muted-foreground: 215 20% 65%;  /* Starlight Grey */
  --accent: 217 33% 17%;
  --accent-foreground: 210 40% 98%;
  --destructive: 0 63% 31%;         /* Ember Rust */
  --destructive-foreground: 210 40% 98%;
  --border: 217 33% 17%;
  --input: 217 33% 17%;
  --ring: 212 100% 97%;             /* Dawn Ring */
}
```

## Annexe B — Stack technique de référence

- **Police** : Inter (Google Fonts), graisses 300/400/500/600/700
- **Framework CSS** : Tailwind CSS 3.4 avec `darkMode: ["class"]`
- **Plugin animations** : `tailwindcss-animate`
- **Composants** : shadcn/ui (Radix UI) style `default`
- **Icônes** : lucide-react
- **Scroll smooth global** : `html { scroll-behavior: smooth; }`

## Annexe C — Classes utilitaires signatures (à copier dans index.css)

```css
/* Dégradé signature sur texte */
.text-gradient {
  @apply bg-clip-text text-transparent bg-gradient-to-r from-secondary to-accent;
}

/* Container maître */
.container {
  @apply px-4 md:px-6 lg:px-8 mx-auto max-w-7xl;
}

/* Padding section standard */
.section-padding {
  @apply py-16 md:py-24;
}

/* Blob morphant hero */
.blob {
  border-radius: 42% 58% 70% 30% / 45% 45% 55% 55%;
  animation: morph 15s linear infinite alternate;
  transform-origin: center;
  z-index: 5;
}
@keyframes morph {
  0%   { border-radius: 42% 58% 70% 30% / 45% 45% 55% 55%; }
  100% { border-radius: 72% 28% 30% 70% / 65% 65% 35% 35%; }
}

/* Entrée de page */
.animate-page-in { animation: pageIn 0.4s ease 0.15s both; }
@keyframes pageIn { from { opacity: 0; } to { opacity: 1; } }

/* Fade-in montant */
.animate-fade-in         { animation: fadeIn 0.8s ease forwards; }
.animate-fade-in-delay-1 { animation: fadeIn 0.8s ease 0.2s forwards; opacity: 0; }
.animate-fade-in-delay-2 { animation: fadeIn 0.8s ease 0.4s forwards; opacity: 0; }
.animate-fade-in-delay-3 { animation: fadeIn 0.8s ease 0.6s forwards; opacity: 0; }
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(20px); }
  to   { opacity: 1; transform: translateY(0); }
}

/* Scroll reveal */
.scroll-reveal {
  opacity: 0;
  transform: translateY(40px);
  transition: opacity 0.7s ease, transform 0.7s ease;
}
.scroll-reveal.scroll-revealed {
  opacity: 1;
  transform: translateY(0);
}

/* Délais d'animation custom */
.animation-delay-2000 { animation-delay: 2s; }
.animation-delay-4000 { animation-delay: 4s; }
```

## Annexe D — Keyframes Tailwind (tailwind.config.ts)

```ts
keyframes: {
  float: {
    '0%, 100%': { transform: 'translateY(0)' },
    '50%':      { transform: 'translateY(-10px)' }
  },
  pulse: {
    '0%, 100%': { opacity: '1' },
    '50%':      { opacity: '0.7' }
  }
},
animation: {
  float: 'float 6s ease-in-out infinite',
  pulse: 'pulse 3s ease-in-out infinite'
}
```
