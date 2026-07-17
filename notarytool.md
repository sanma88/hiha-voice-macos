# Notarytool — aide-mémoire Hi-Ha Voice

## Identifiants du compte (équipe Pixinko)

| Champ | Valeur |
|---|---|
| Apple ID | `mariano@hi-ha.be` |
| Team ID | `85RMV67598` |
| Team Name | Pixinko |
| Signing identity | `Developer ID Application: Pixinko (85RMV67598)` |
| Profil keychain notarytool | `hihavoice-notary` (nom attendu par le Makefile) |
| Mot de passe spécifique app | à générer sur https://appleid.apple.com → *Sign-In and Security* → *App-Specific Passwords* |

> Ne jamais commiter le mot de passe. Il est stocké dans le trousseau via `xcrun notarytool store-credentials`.

---

## ⚠️ Règle d'or : ne JAMAIS mettre ce repo dans iCloud Drive

Le projet vit dans `~/Developer/Hi-Ha-Voice` — **pas** dans `~/Documents` ni `~/Desktop`. iCloud Drive stampe les bundles avec `com.apple.FinderInfo`, ce qui :

1. Fait échouer `codesign --verify --strict` avec `Disallowed xattr com.apple.FinderInfo found on ...`
2. Fait **figer** les soumissions `notarytool` en `In Progress` pour toujours (le service accepte l'upload puis bloque silencieusement sur l'inspection du bundle).

**Symptôme diagnostic** si ça se reproduit :
```bash
find "build/export/Hi-Ha Voice.app" -exec xattr -l {} \; 2>/dev/null | grep -i finderinfo
```
Si ça retourne quoi que ce soit → le repo est de nouveau dans iCloud, sortir immédiatement.

Le Makefile purge les xattrs automatiquement via `xattr -cr` dans `export` et `notarize`, mais c'est une ceinture-et-bretelles : si le repo retourne dans iCloud, les xattrs sont re-stampés **entre** la purge et le zip, et notarytool bloque.

---

## Setup initial (à faire une seule fois par machine)

### 1. Générer un mot de passe d'app Apple

https://appleid.apple.com → *Sign-In and Security* → *App-Specific Passwords* → créer `hihavoice-notary`.
Format : `xxxx-xxxx-xxxx-xxxx`.

### 2. Stocker dans le trousseau

```bash
xcrun notarytool store-credentials hihavoice-notary \
  --apple-id "mariano@hi-ha.be" \
  --team-id "85RMV67598" \
  --password "xxxx-xxxx-xxxx-xxxx"
```

Tester :
```bash
xcrun notarytool history --keychain-profile hihavoice-notary
```

---

## Workflow normal — une seule commande

```bash
make release
```

Enchaîne automatiquement : `archive` → `export` (+ `xattr -cr`) → `verify` (`codesign --verify --strict` + `spctl`) → `notarize` (zip propre + submit + wait) → `staple` → `dmg` signé.

Pour itérer manuellement :

| Étape | Commande | Durée |
|---|---|---|
| Archive Release | `make archive` | ~1-2 min |
| Export .app signée | `make export` | ~10 s (inclut purge xattrs) |
| Vérifier signature | `make verify` | ~2 s |
| Soumettre au notary | `make notarize` | ~2-10 min |
| Agrafer ticket | `make staple` | ~1 s |
| Créer DMG | `make dmg` | ~30 s |

---

## Suivi d'une soumission

### Statut de la dernière

```bash
xcrun notarytool history --keychain-profile hihavoice-notary | head
```

### Statut d'une soumission précise

```bash
xcrun notarytool info <UUID> --keychain-profile hihavoice-notary
```

Statuts possibles :
- `In Progress` — Apple traite (normal < 10 min, anormal > 30 min)
- `Accepted` — OK, il faut agrafer
- `Invalid` — refus, lire le log
- `Rejected` — rare

### Log détaillé (si `Invalid`)

```bash
xcrun notarytool log <UUID> --keychain-profile hihavoice-notary notarization.log
cat notarization.log | jq .
```

Le JSON liste chaque binaire problématique (`path`, `message`, `docUrl`).

### Attendre en ligne de commande

```bash
xcrun notarytool wait <UUID> --keychain-profile hihavoice-notary
```

---

## Vérification finale Gatekeeper

Après `make staple` :

```bash
spctl -a -vvv -t exec "build/export/Hi-Ha Voice.app"
# Doit afficher : source=Notarized Developer ID
```

Et sur le DMG :
```bash
spctl -a -vvv -t install "build/HiHaVoice.dmg"
```

---

## Dépannage

| Symptôme | Cause probable | Fix |
|---|---|---|
| `notarytool submit` retourne OK mais `info` reste `In Progress` > 30 min | Bundle a des xattrs `com.apple.FinderInfo` (iCloud) | Vérifier le chemin du repo, purger `xattr -cr`, re-soumettre |
| `codesign --verify --strict` : `Disallowed xattr com.apple.FinderInfo` | Bundle dans iCloud Drive | Sortir le repo de `~/Documents` vers `~/Developer` |
| `status: Invalid` avec `The binary is not signed with a valid Developer ID certificate` | Certificat `Apple Development` au lieu de `Developer ID Application` | Vérifier `ExportOptions.plist` + cert dans trousseau |
| `status: Invalid` avec `The signature of the binary is invalid` | Hardened runtime absent | S'assurer que `ENABLE_HARDENED_RUNTIME=YES` dans xcconfig Release |
| HTTP 401 Invalid credentials | Apple ID, mdp ou Team ID erroné | Régénérer mdp app + relancer `store-credentials` |
| `No Keychain password item found` | Profil trousseau absent ou supprimé | Relancer `store-credentials` (section Setup) |

---

## Historique / Leçons apprises (2026-04)

- **2026-04-21** : 2 soumissions Accepted réussies (`905501c4...`, `37ca97b6...`). Le repo était probablement propre à ce moment ou les xattrs avaient été purgés juste avant.
- **2026-04-21 → 04-23** : 5 soumissions bloquées en `In Progress` pour toujours (`d2d30823`, `c0bfe21f`, `81a8550a`, `4c3c6c85`, `c13331d5`). Cause identifiée : le repo était dans `~/Documents/GitHub/` synchronisé par iCloud Drive (`FXICloudDriveDocuments = 1` dans les prefs Finder), qui re-stampait `com.apple.FinderInfo` entre chaque build.
- **2026-04-25** : repo déplacé vers `~/Developer/Hi-Ha-Voice`, fixes appliqués (entitlements nettoyés, `SUEnableInstallerLauncherService=false`, Makefile purge xattrs automatiquement). `codesign --verify --strict` passe de nouveau.

### Bon à savoir

- Apple Developer Portal et App Store Connect n'affichent **pas** le statut des notarisations Developer ID (contrairement aux apps MAS). Seul `notarytool` voit l'historique.
- Apple envoie un email à `mariano@hi-ha.be` à chaque sortie de `In Progress`. Patient → pas besoin de poller.
- `--deep` est déprécié pour la signature depuis 2022. À utiliser **uniquement** pour `codesign --verify`, jamais pour signer. Le Makefile signe correctement (bottom-up via `xcodebuild archive`).
