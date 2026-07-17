# Hi-Ha.be — Pack icônes services premium

Contenu par icône :

- `png/` : PNG transparent en 256, 512, 1024 et 2048 px + version print 300 dpi.
- `svg/` : SVG prêt web contenant le PNG transparent haute résolution intégré.
- `eps/` : EPS raster clippé via contour alpha, utilisable en print/PAO.
- `web/` : versions site web optimisées en PNG et WebP.
- `preview/` : prévisualisations sur fond clair, foncé et damier.
- `source/` : PNG transparent au format source généré.

Structure :

- `roadmap-ia`
- `comite-ia`
- `agents-assistants`
- `automatisation-n8n`
- `ia-locale-souveraine`
- `formations`
- `website/` : mini-démo HTML + assets prêts à intégrer.

Note technique : ces icônes ont un rendu verre/frosted 3D avec irisations, reflets et transparences. Un SVG/EPS pur vectoriel éditable ne reproduirait pas fidèlement ce rendu sans le dégrader. Les SVG fournis sont donc des conteneurs propres avec PNG alpha intégré. Les EPS sont des exports raster clippés, à valider dans Illustrator, Affinity Designer ou InDesign selon le flux imprimeur.

Pour le site : privilégier WebP, puis PNG comme fallback. Voir `website/index.html` et `website/integration-snippet.html`.
