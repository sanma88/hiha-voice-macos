# Releasing Hi-Ha Voice — procédure canonique

> **Ce repo est la source de vérité** : l'app se builde ici (`make release` →
> `build/HiHaVoice.dmg`, non versionné), l'appcast source vit ici
> (`appcast.xml`), et la procédure de publication est documentée ici.
> Le site (`hi-ha-be-website`) ne fait que **publier une copie** du DMG et de
> l'appcast sous `frontend/public/app/voice/`.

## État courant

- **Version publiée : 2.0.1 (build 201)** — 18/07/2026.
  DMG : 14 670 421 octets, sha256 `03efa5629a6f8cb69386c17fef765827df5732537c90350f4bb00de34b81b40c`.
- URLs publiques : DMG `https://hi-ha.be/app/voice/HiHaVoice-2.0.1.dmg` ·
  appcast canonique `https://hi-ha.be/app/voice/appcast.xml`
  (301 depuis `/voice/appcast.xml`, la SUFeedURL gravée) ·
  annonces `https://hi-ha.be/app/voice/announcements.json` (301 depuis `/voice/announcements.json`).

## Clé Sparkle (EdDSA) — lecture obligatoire

- Clé publique (Info.plist `SUPublicEDKey`) : `K4lmZ1Q9Am5hH8fU9tkjVDdP00TSJA9IbYALdREIP4Q=`
- La **clé privée vit dans le trousseau de session du Mac de build** (élément
  « Private key for signing Sparkle updates »). `sign_update` la lit tout seul.
- **Ne jamais** l'exporter en fichier sauf migration de machine (`generate_keys -x`),
  et détruire le fichier (`rm -P`) sitôt importé ailleurs (`generate_keys -f`).
  Le `.gitignore` bloque `sparkle_private_key*`, `*.pem`, `*ed25519*`.
- Contrôle rapide : `…/Sparkle/bin/generate_keys -p` doit imprimer `K4lmZ…`.

### Historique (ne pas répéter l'erreur)

La 2.0 (17/07/2026, jamais publiée dans l'appcast, brièvement téléchargeable)
embarquait la `SUPublicEDKey` **héritée du fork VoiceInk** (`rLRdZ…`) : privée
introuvable → ses installations ne pourront jamais s'auto-mettre à jour.
La 2.0.1 est le re-key sur la clé du trousseau. **À chaque release : vérifier
que la `SUPublicEDKey` du DMG monté est bien `K4lmZ…`.**

## Publier une version X.Y (checklist)

1. **Bump** : `HiHaVoice.xcodeproj/project.pbxproj`, cible app uniquement
   (4 lignes) : `MARKETING_VERSION` et `CURRENT_PROJECT_VERSION` (Debug + Release).
2. **Build** : `make release` (archive → export → notarisation → staple → DMG
   re-notarisé). Prérequis : cert « Developer ID Application: Pixinko », profil
   trousseau `hihavoice-notary` (cf. `notarytool.md`), repo HORS iCloud Drive.
3. **Vérifier le DMG** (`build/HiHaVoice.dmg`) : `hdiutil attach` → version,
   build, `SUPublicEDKey` = `K4lmZ…` ; `codesign --verify --deep --strict` ;
   `stapler validate` (app ET dmg) ; `spctl -a -t exec` = accepted.
4. **Signer** : `…/SourcePackages/artifacts/sparkle/Sparkle/bin/sign_update build/HiHaVoice.dmg`
   → noter `sparkle:edSignature` et `length` (doit égaler la taille exacte du fichier).
5. **Appcast** : ajouter l'`<item>` EN TÊTE du `<channel>` de `appcast.xml`
   (**dans ce repo d'abord** — source de vérité) : title, pubDate RFC 822
   (`date -R`), `sparkle:version`, `sparkle:shortVersionString`,
   `sparkle:minimumSystemVersion`, description CDATA, enclosure
   (url versionnée, length, edSignature). `xmllint --noout appcast.xml`.
6. **Publier sur le site** (`hi-ha-be-website`) : copier le DMG →
   `frontend/public/app/voice/HiHaVoice-X.Y.dmg` (nom versionné, jamais réécrit —
   cache immutable 1 an) ; copier `appcast.xml` → `frontend/public/app/voice/` ;
   mettre à jour la page `/app/voice` (`DMG_PATH`, `META_LINE`, JSON-LD) et la
   carte `frontend/components/site/apps/VoiceFeatureCard.tsx`.
7. **Commit + push — les DEUX repos, chacun sur ses DEUX remotes** :
   ce repo → `hiha` **et** `github-macos` ; le site → `origin` (GitLab, déploie)
   **et** `github` (mirror).
8. **Vérifier en prod** : `curl -sI` DMG → 200 + `Content-Length` exact ;
   `curl -s …/appcast.xml | xmllint --noout -` ; 301 des deux `/voice/*` ;
   re-vérification crypto de la signature sur le fichier réellement servi :
   `openssl pkeyutl -verify -pubin -inkey <pub.pem> -rawin -in <dmg téléchargé> -sigfile <sig.bin>`
   (OpenSSL ≥ 3 ; construire le PEM depuis `K4lmZ…` : préfixe DER
   `302a300506032b6570032100` + les 32 octets de la clé).
