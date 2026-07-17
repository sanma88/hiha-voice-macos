# Contenu & spécifications fonctionnelles — hi-ha.be

> Copy en **français**, vouvoiement, casse de phrase, **pas d'emoji**. Ton : clair, précis, rassurant, orienté résultats. Microcopy concrète, sans jargon creux. La copy ci-dessous est la **référence** (issue de la charte + UI kit) — réutilisable telle quelle.

## Plan du site

| Route | Page | Affichage | Contenu |
|---|---|---|---|
| `/` | Accueil | toujours | Hero, Services, Souveraineté, **Témoignages**, bande CTA, footer |
| `/services` | Services | toujours | Détail des 4 offres |
| `/souverainete` | Souveraineté des données | toujours | Argumentaire IA locale/open source |
| `/formations` | Formations | toujours | Offre de formation |
| `/methodologie` | Méthodologie | **toggleable (admin)** | Comment nous travaillons (démarche, étapes) |
| `/domaines` | Domaines | **toggleable (admin)** | Secteurs / cas d'usage servis |
| `/temoignages` | Témoignages | toggleable (admin) | Page dédiée (en plus de la section accueil) |
| `/calendrier` | Calendrier | **masquée par défaut, toggleable (admin)** | Agenda : événements + formations à venir |
| `/contact` | Contact | toujours | Wizard (Profil → Maturité → Besoins → Coordonnées **ou Visio Cal.com** → Confirmation) |
| `/mentions-legales` | Mentions légales | toggleable (admin) | Légal |
| `/confidentialite` | Politique de confidentialité (RGPD) | toggleable (admin) | Légal |
| `/cookies` | Politique cookies | toggleable (admin) | Légal |
| `/cgv` | Conditions générales (CGV/CGU) | toggleable (admin) | Légal |
| `/admin/**` | Backoffice | protégé | CMS |

> **Pages toggleables** : chaque page marquée « toggleable » a un état **visible/masqué** piloté depuis l'admin (`content.visible`). Utile au lancement quand le texte n'est pas prêt (ex. RGPD, cookies). Une page masquée renvoie 404 (ou redirige) et **disparaît automatiquement de la nav + du footer + du sitemap**.

Header (nav) : **Services · Formations · Souveraineté · Approche ▸ · Calendrier** + CTA « Demander un audit ». **« Approche »** est un menu déroulant (vers la fin de la nav) regroupant **Méthodologie · Domaines · Témoignages**. **« Calendrier »** n'apparaît que si la page est activée. Footer : **toutes les pages du site, triées** (voir §Footer) — placement configurable depuis l'admin, sans surcharger.

### Navigation — menus verticaux flottants + flyout
La barre de navigation desktop ouvre des **menus verticaux flottants en verre givré** (hover + clic + clavier), **détachés du header** (espace visible, effet « volant »), **centrés sous l'item cliqué**, **sans chevron** dans le menu principal :
- **Services** → liste verticale (Conseil & stratégie, Formations, Automatisation n8n, IA locale & agents). Chaque entrée à sous-niveau ouvre un **flyout vertical vers la DROITE** au survol (ex. Conseil → Audit IA, Feuille de route, Cadrage de projet), avec un chevron droit indicatif.
- **Formations** → liste verticale simple (Sensibilisation, Ateliers pratiques, Parcours équipe).
- **Approche** (placé **vers la fin** de la nav) → menu déroulant : **Méthodologie · Domaines · Témoignages** (les entrées masquées en admin n'apparaissent pas).
- **Souveraineté** et **Calendrier** → liens directs (Calendrier visible seulement si la page est activée).
- Panneaux **peu transparents** (≈0.97, lisibilité du texte garantie), ombre douce, glissement léger. Ponts de survol invisibles (entre header↔menu et menu↔flyout). **Structure pilotée par données** (`NAV`) — **éditable via le CMS** (libellés, ordre, visibilité).

### Navigation mobile — overlay plein écran
Sous 760px : burger **morphé en X** ouvrant un **overlay plein écran en verre givré**. L'overlay **embarque sa propre barre haute** : logo + « hi-ha.be », toggle clair/sombre, et le **X pour fermer** (la fermeture est donc toujours possible). En dessous, les entrées apparaissent en **cascade** ; les entrées à sous-menu sont des **accordéons** (listes déroulantes) qui révèlent les items et leurs sous-liens indentés. CTA pleine largeur en bas. Respecte `prefers-reduced-motion`.

## Accueil — copy de référence

**Hero**
- Overline : `CONSEIL · FORMATION · INTÉGRATION IA`
- H1 : **« Donner du sens à l'IA, de la formation au déploiement. »**
- Sous-titre : « Des formations qui restent utiles, des automatisations qui tournent encore dans six mois. »
- Description : « hi-ha.be accompagne les organisations dans l'adoption concrète de l'intelligence artificielle et de l'automatisation. On part de vos cas concrets, pas de la dernière techno à la mode. »
- CTA : `Parlons de votre projet` (CTA unique, sans flèche)
- Mini-stats : **n8n** — Automatisation · **Local** — IA open source · **100%** — Vos données chez vous
- Visuel : symbole 3D frosté + halo iridescent.

**Services** (titre : « Quatre façons de rendre l'IA concrète chez vous. »)
1. **Conseil & stratégie** — « On clarifie les cas d'usage à fort impact et on trace une feuille de route réaliste. » (icône `message-circle`)
2. **Formations** — « Des sessions concrètes pour rendre vos équipes autonomes avec l'IA au quotidien. » (`graduation-cap`)
3. **Automatisation n8n** — « Des workflows fiables qui relient vos outils et libèrent du temps utile. » (`workflow`)
4. **IA locale & agents** — « Assistants métiers déployés en local, open source, sous votre contrôle. » (`server`)

**Souveraineté** (titre : « Au-delà du simple branchement d'une API cloud. »)
- Intro : « Notre différence : une IA déployée chez vous, sur des briques open source. Vous gardez la main sur vos données, vos coûts et votre conformité. »
- Points : « Déploiement en local : vos données ne quittent pas votre infrastructure. » · « Modèles open source, audités et maîtrisés — pas de boîte noire. » · « Automatisation n8n et agents métiers conçus pour durer. »
- Visuel flow (panneau verre givré) : **Vos données** (on-premise, chiffrées) → **Modèle IA local** (open source, audité) → **Agents & workflows n8n** → **Vos équipes** (autonomes, accompagnées).

**Bande CTA** : « Un projet d'IA ou d'automatisation en tête ? » + « Dites-nous où vous en êtes, on vous répond sous 48h. » + CTA `Parlons de votre projet`.

## Wizard de contact (`/contact`) — 5 étapes

Indicateur d'étapes : **Profil → Maturité → Besoins → Contact/Visio → Confirmation** (dots + barres ; étape faite = check lilas, active = graphite).

**Étape 1 — Profil** « Vous représentez… » (choix unique, cartes sélectionnables) :
`PME / indépendant` (`building-2`) · `École / institution` (`graduation-cap`) · `Secteur public` (`landmark`) · `ASBL / association` (`heart-handshake`).

**Étape 2 — Maturité IA** « Où en êtes-vous avec l'IA ? » (choix unique, cartes — niveau envoyé avec la demande, sert à préparer l'échange) :
- `Découverte` — « On commence à s'y intéresser. » (`sparkles`)
- `Premiers essais` — « Quelques outils testés, sans cadre. » (`flask-conical`)
- `En déploiement` — « Des cas d'usage en production. » (`rocket`)
- `Avancé` — « L'IA est intégrée à nos process. » (`trophy`)

**Étape 3 — Besoins** « De quoi avez-vous besoin ? » (choix **multiples**) :
`Conseil & stratégie` · `Formation` · `Automatisation n8n` · `IA locale & agents`.

**Étape 4 — Comment vous recontacter ?** (choix entre **deux voies**, segmented/cartes) :
- **A. Par message** → formulaire : Nom complet * · Organisation · E-mail professionnel * · Téléphone · Message (textarea). Bouton `Envoyer la demande`.
- **B. Prévoir une visio** *(recommandé)* → **Cal.com auto-hébergé embarqué**, **stylé aux couleurs/typo du site** : la personne choisit un créneau disponible, complète nom/e-mail, confirme. Le rendez-vous est créé dans Cal.com **et** la demande (avec Profil + Maturité + Besoins) est enregistrée. *(Voir ARCHITECTURE : intégration Cal.com.)*

**Étape 5 — Confirmation** : écran succès (« Merci, c'est noté ! » ou « Visio confirmée le … ») + récap (Profil, Maturité, Besoins, voie choisie). Bouton « Nouvelle demande ».

**Règles** : « Continuer » désactivé tant que l'étape n'est pas valide (1 : profil ; 2 : maturité ; 3 : ≥1 besoin ; 4A : nom + email valides / 4B : créneau choisi). Anti-spam : honeypot + Altcha + rate-limit. Soumission → insert `contact_submissions` (incl. `maturity`, `channel`) + notif email SMTP ; si Visio, création du rdv Cal.com. La DB reste la source de vérité.

## Calendrier / Agenda (`/calendrier`) — masquée par défaut

Page **conçue maintenant, activée plus tard** (toggle admin). Objectif : **regrouper les événements et formations à venir** (et, à terme, d'autres contenus datés). Design premium verre givré :
- En-tête de page (overline + titre + intro courte).
- **Liste/grille d'événements** : chaque carte = date (badge jour/mois), type (`Formation` / `Événement` — chip pastel), titre, lieu/format (présentiel/visio), courte description, lien « En savoir plus » / « S'inscrire ».
- Filtres simples (Tous · Formations · Événements). État vide soigné (« Aucun événement programmé pour l'instant »).
- Les événements sont **éditables dans l'admin** (table `events`). Tant que la page est masquée, elle n'apparaît ni en nav, ni au footer, ni au sitemap.

## Témoignages

> **Note** : les témoignages sont désormais de **vrais retours de formation** (voir seed) ; ne plus utiliser de personas fictifs.

**Section accueil** + **page dédiée** (`/temoignages`), **éditables dans l'admin**. Carte témoignage **premium** :
- **Photo ronde** (logo de l'entreprise **ou** photo de la personne) — petite, soignée.
- **Citation** (la phrase) en Manrope, taille lisible, `text-wrap: pretty`.
- **Nom + titre** de la personne, puis **entreprise**.
- Style : carte verre givré / surface, ombre douce, accent iridescent discret (guillemet ou filet). Sur l'accueil : 2–3 en avant (carrousel léger ou grille) ; page dédiée : grille complète.

## Pages — Méthodologie, Domaines, Légales (toggleables)

- **Méthodologie** (`/methodologie`) : page dédiée décrivant la démarche (étapes : cadrage → pilote → déploiement → autonomie), même système visuel.
- **Domaines** (`/domaines`) : page dédiée présentant les secteurs / cas d'usage servis.
- **Légales** : `/mentions-legales`, `/confidentialite` (RGPD), `/cookies`, `/cgv` — corps éditable (Tiptap).
- **Toutes ces pages** ont un état **visible/masqué** piloté en admin. Au lancement, on peut tout créer puis **n'afficher que celles dont le texte est prêt** (ex. masquer Confidentialité/Cookies tant que le texte manque).

## Footer (revu) — annuaire des pages

Footer repensé pour **lister toutes les pages du site, bien triées**, sans surcharge :
- Colonnes : **Offre** (Services, Formations, Souveraineté, Automatisation, IA locale) · **Approche** (Méthodologie, Domaines, Témoignages, Calendrier) · **Contact** (Demander un audit, e-mail, LinkedIn) · **Légal** (Mentions légales, Confidentialité, Cookies, CGV).
- **Seules les pages visibles** apparaissent (les pages masquées disparaissent automatiquement).
- L'**emplacement d'affichage** de chaque page (nav / footer / les deux / nulle part) est **configurable depuis l'admin** (voir §Admin → Pages). Garder le footer aéré, fidèle à l'esprit premium.

## Admin CMS (`/admin`)

**Navigation** (sidebar) : Tableau de bord · **Contenus** · **Pages** · **Témoignages** · **Calendrier** · **Demandes** · Médias · **Apparence** · Réglages · « Voir le site ».

**Tableau de bord** : cartes stats (Contenus, Vues/mois, Demandes, En revue).

**Contenus** : table (Titre, Section, Statut, actions). Statut = point coloré : **Publié** (vert), **Brouillon** (gris), **En revue** (pêche). Bouton « Nouveau ».
- **Tiroir d'édition** (drawer latéral, onglets **Contenu** / **SEO**) :
  - *Contenu* : Titre, Type (Page/Article), Section, Extrait, corps **Tiptap** (rich text), Statut (segmented).
  - *SEO* : Titre SEO, Slug, Meta description, OG image (picker médias).
- Actions : Enregistrer / Annuler.

**Demandes** : inbox des soumissions du formulaire (orgType, **maturité**, besoins, **voie : message/visio**, coordonnées, message, statut new/read/archived).

**Pages** (nouveau) : gestion de **toutes les pages du site** avec, par page : **Visible / Masqué** (toggle), **Emplacement** (Nav · Footer · Les deux · Aucun), **ordre**. Édition du corps en Tiptap (méthodologie, domaines, légales…). C'est ici qu'on **active une page** une fois son texte prêt (ex. RGPD, cookies). Une page masquée disparaît de la nav, du footer et du sitemap.

**Témoignages** (nouveau) : CRUD des témoignages — **photo (logo/personne)**, **citation**, **nom**, **titre**, **entreprise**, ordre, visible. Alimente la section accueil + la page `/temoignages`.

**Calendrier** (nouveau) : CRUD des **événements/formations** (titre, type, date(s), lieu/format, description, lien, visible) + le **toggle d'activation** de la page `/calendrier`.

**Médias** : upload (preview, optimisation auto côté backend), stockés sur **Garage S3**.

**Apparence** (éditeur de style — « thème ») : permet d'éditer **le style des éléments** du site, **strictement borné aux tokens du design system** (impossible de sortir de la charte). Contrôles (segmented + swatches), avec **aperçu en direct** (overline, titre, bouton, lien, chips) :
- **Couleur d'accent** : Lilas froid · Pêche douce · Rose brume · Graphite (chaque option = couple `ink` + `soft` issu de la palette). Pilote `--accent-ink` / `--accent-*`.
- **Style de bouton** : Plein (graphite) · Iridescent (dégradé pastel) · Contour. Ce sont les **recettes de bouton déjà définies sur le site** — on choisit la variante par défaut, on n'en invente pas.
- **Rayon des coins** : Doux (14) · Ample (20) · Pilule (999) — tokens `--radius-*`.
- **Graisse des titres** (Manrope) : SemiBold 600 · Bold 700 · ExtraBold 800.
- **Boutons individuels** : pour **chaque bouton/CTA du site** (Accueil — Demander un audit, Accueil — Réserver une démo, Header — Demander un audit, Bande CTA…), choix du style **Plein / Entouré / Transparent** (sans fond) — chaque variante reste une recette de la charte. Aperçu par bouton en direct. En prod, chaque bouton porte un champ `variant` (sur le contenu/CTA concerné) ; valeurs fermées.
- En production, ces réglages sont **persistés** (table `theme`/`settings`, jsonb) et injectés en **CSS variables sur `:root`** au rendu serveur (donc appliqués à tout le site, light + dark). **Ne jamais** permettre une valeur hors-tokens (couleur libre, rayon arbitraire) : les options sont des listes fermées.

> Important : l'**édition de texte** (titres, extraits, corps Tiptap, libellés) se fait dans **Contenus** ; l'**édition de style** (apparence des éléments) se fait dans **Apparence**. Les deux respectent le design system.

**Réglages** : coordonnées, réseaux, textes globaux (table `settings`).

> Le contenu marketing peut démarrer en pages statiques Next, **mais** les pages/articles éditables et les Demandes doivent venir de la DB via l'API. Câbler le CMS dès le départ pour Titre/Extrait/Body/SEO/Statut.
