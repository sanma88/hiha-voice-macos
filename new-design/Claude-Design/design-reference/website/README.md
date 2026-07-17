# UI Kit — Site web hi-ha.be

Recréation haute fidélité du site web premium hi-ha.be : pages marketing, page contact à formulaire dynamique par étapes, et panneau d'administration de contenu léger. Mobile-first, responsive, clair + sombre.

## Lancer
Ouvrez `index.html`. Un sélecteur flottant (en bas) bascule entre quatre surfaces :
- **Site** — page d'accueil marketing (header verre givré, hero, services, souveraineté, **témoignages**, CTA, footer).
- **Calendrier** — agenda des événements et formations (page masquable en admin).
- **Contact** — assistant en **5 étapes** (Profil → Maturité → Besoins → Message ou Visio Cal.com → Confirmation).
- **Admin** — CMS léger (contenus, Pages visible/masqué, Témoignages, Calendrier, Demandes, Apparence).

Le thème (clair/sombre) se bascule via l'icône lune/soleil et est persisté.

## Fichiers
| Fichier | Rôle |
|---|---|
| `index.html` | App React (Babel in-browser) + sélecteur de vue + gestion du thème. |
| `kit.css` | Tous les styles composants (s'appuie sur les tokens racine `colors_and_type.css`). |
| `Shared.jsx` | `Icon` (Lucide), `useTheme`, `Brand`, `ThemeToggle`, `Header`, `Footer`. |
| `HomePage.jsx` | `Hero`, `Services`, `Feature` (souveraineté), `CtaBand`, `HomePage`. |
| `ContactPage.jsx` | Assistant multi-étapes `ContactPage` + `StepIndicator`. |
| `AdminPage.jsx` | `AdminPage` (sidebar, stats, table) + `Editor` (tiroir). |
| `assets/` | Symbole givré + logos monochromes utilisés par le kit. |

## Composants réutilisables
Boutons (`.btn` + variantes `-primary/-accent/-secondary/-ghost`, tailles `-sm/-lg`), cartes service (`.scard`), carte verre givré (`.panel`), champs (`.field`), options sélectionnables (`.opt`), badges/chips, indicateur d'étapes (`.steps`), tableau CMS (`.trow`), tiroir (`.drawer`), header/footer flottants en verre givré.

## Notes
- **Icônes** : Lucide via CDN (`stroke-width: 1.75`, grille 24) — substitution signalée, faute d'icônes natives fournies.
- **Fonts** : Manrope / Inter / IBM Plex Mono chargées via Google Fonts (preconnect + `<link>` dans le `<head>`).
- **Animations** : entrées en transition douce, désactivées sous `prefers-reduced-motion` (et toujours visibles en capture/impression).
- Ce sont des recréations cosmétiques : la logique est simplifiée (pas de backend réel).
