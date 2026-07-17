# Hi-Ha Voice — Makefile

DEPS_DIR := $(HOME)/HiHaVoice-Dependencies
WHISPER_CPP_DIR := $(DEPS_DIR)/whisper.cpp
FRAMEWORK_PATH := $(WHISPER_CPP_DIR)/build-apple/whisper.xcframework
LOCAL_DERIVED_DATA := $(CURDIR)/.local-build
BUILD_DIR := $(CURDIR)/build
ARCHIVE_PATH := $(BUILD_DIR)/HiHaVoice.xcarchive
EXPORT_PATH := $(BUILD_DIR)/export
APP_PATH := $(EXPORT_PATH)/Hi-Ha Voice.app
APP_NAME := Hi-Ha Voice
DMG_NAME := HiHaVoice.dmg
TEAM_ID := 85RMV67598
NOTARY_PROFILE := hihavoice-notary
SIGNING_IDENTITY := Developer ID Application: Pixinko (85RMV67598)

.PHONY: all clean whisper setup build local check healthcheck help dev run \
        archive export notarize staple dmg release install uninstall verify

# Default target
all: check build

# Development workflow
dev: build run

# ============================================================
# Prerequisites
# ============================================================
check:
	@echo "Checking prerequisites..."
	@command -v git >/dev/null 2>&1 || { echo "git is not installed"; exit 1; }
	@command -v xcodebuild >/dev/null 2>&1 || { echo "xcodebuild is not installed (need Xcode)"; exit 1; }
	@command -v swift >/dev/null 2>&1 || { echo "swift is not installed"; exit 1; }
	@echo "Prerequisites OK"

healthcheck: check

# ============================================================
# Whisper framework
# ============================================================
whisper:
	@mkdir -p $(DEPS_DIR)
	@if [ ! -d "$(FRAMEWORK_PATH)" ]; then \
		echo "Building whisper.xcframework in $(DEPS_DIR)..."; \
		if [ ! -d "$(WHISPER_CPP_DIR)" ]; then \
			git clone https://github.com/ggerganov/whisper.cpp.git $(WHISPER_CPP_DIR); \
		else \
			(cd $(WHISPER_CPP_DIR) && git pull); \
		fi; \
		cd $(WHISPER_CPP_DIR) && ./build-xcframework.sh; \
	else \
		echo "whisper.xcframework already built"; \
	fi

setup: whisper
	@echo "Whisper framework ready at $(FRAMEWORK_PATH)"

# ============================================================
# Debug build (ad-hoc local signing, no Apple Developer needed)
# ============================================================
build: setup
	xcodebuild -project HiHaVoice.xcodeproj -scheme HiHaVoice -configuration Debug CODE_SIGN_IDENTITY="" build

local: check setup
	@echo "Building Hi-Ha Voice for local use (no Apple Developer cert needed)..."
	@rm -rf "$(LOCAL_DERIVED_DATA)"
	xcodebuild -project HiHaVoice.xcodeproj -scheme HiHaVoice -configuration Debug \
		-derivedDataPath "$(LOCAL_DERIVED_DATA)" \
		-xcconfig LocalBuild.xcconfig \
		CODE_SIGN_IDENTITY="-" \
		CODE_SIGNING_REQUIRED=NO \
		CODE_SIGNING_ALLOWED=YES \
		DEVELOPMENT_TEAM="" \
		CODE_SIGN_ENTITLEMENTS=$(CURDIR)/HiHaVoice/HiHaVoice.local.entitlements \
		SWIFT_ACTIVE_COMPILATION_CONDITIONS='$$(inherited) LOCAL_BUILD' \
		build
	@APP="$(LOCAL_DERIVED_DATA)/Build/Products/Debug/Hi-Ha Voice.app"; \
	if [ -d "$$APP" ]; then \
		rm -rf "$$HOME/Downloads/Hi-Ha Voice.app"; \
		ditto "$$APP" "$$HOME/Downloads/Hi-Ha Voice.app"; \
		xattr -cr "$$HOME/Downloads/Hi-Ha Voice.app"; \
		echo ""; echo "✅ App saved to: ~/Downloads/Hi-Ha Voice.app"; \
	else \
		echo "❌ Could not find built app at $$APP"; exit 1; \
	fi

# ============================================================
# Release pipeline (Developer ID signed + notarized + DMG)
# ============================================================
archive: setup
	@echo "📦 Archiving Release (signed Developer ID)..."
	@rm -rf "$(ARCHIVE_PATH)" "$(EXPORT_PATH)"
	@mkdir -p "$(BUILD_DIR)"
	xcodebuild archive \
		-project HiHaVoice.xcodeproj \
		-scheme HiHaVoice \
		-configuration Release \
		-destination 'generic/platform=macOS' \
		-archivePath "$(ARCHIVE_PATH)" \
		| xcbeautify --quiet 2>/dev/null || xcodebuild archive \
		-project HiHaVoice.xcodeproj \
		-scheme HiHaVoice \
		-configuration Release \
		-destination 'generic/platform=macOS' \
		-archivePath "$(ARCHIVE_PATH)" | tail -5
	@test -d "$(ARCHIVE_PATH)" || { echo "❌ Archive failed"; exit 1; }

export: archive
	@echo "📤 Exporting signed .app..."
	@test -f "$(BUILD_DIR)/ExportOptions.plist" || $(MAKE) _export-options
	xcodebuild -exportArchive \
		-archivePath "$(ARCHIVE_PATH)" \
		-exportPath "$(EXPORT_PATH)" \
		-exportOptionsPlist "$(BUILD_DIR)/ExportOptions.plist"
	@test -d "$(APP_PATH)" || { echo "❌ Export failed"; exit 1; }
	@echo "🧹 Purge xattrs iCloud (FinderInfo) qui bloquent le notary..."
	@xattr -cr "$(APP_PATH)"
	@echo "✅ Signed app at: $(APP_PATH)"

verify: export
	@echo "🔍 codesign --verify --strict (doit passer sans 'Disallowed xattr')..."
	codesign --verify --deep --strict --verbose=2 "$(APP_PATH)"
	@echo "🔍 spctl Gatekeeper assessment (pre-staple = rejected est normal)..."
	-spctl -a -vvv -t exec "$(APP_PATH)"
	@echo "✅ Verify OK — prêt pour notarize"

notarize: export verify
	@echo "🍎 Submitting to Apple notary..."
	@xattr -cr "$(APP_PATH)"
	@cd "$(EXPORT_PATH)" && rm -f "$(APP_NAME)-notarize.zip" \
		&& /usr/bin/ditto -c -k --keepParent --norsrc --noextattr --noacl \
			"$(APP_NAME).app" "$(APP_NAME)-notarize.zip"
	xcrun notarytool submit "$(EXPORT_PATH)/$(APP_NAME)-notarize.zip" \
		--keychain-profile $(NOTARY_PROFILE) \
		--wait
	@echo "✅ Notarization accepted"

staple: notarize
	@echo "📎 Stapling notarization ticket..."
	xcrun stapler staple "$(APP_PATH)"
	@xcrun stapler validate "$(APP_PATH)"
	@echo "✅ Ticket stapled"

dmg: staple
	@echo "💿 Creating DMG..."
	@cd "$(BUILD_DIR)" && rm -rf dmg-staging "$(DMG_NAME)" \
		&& mkdir -p dmg-staging \
		&& cp -R "$(APP_PATH)" dmg-staging/ \
		&& xattr -cr dmg-staging \
		&& ln -s /Applications dmg-staging/Applications \
		&& hdiutil create \
			-volname "$(APP_NAME)" \
			-srcfolder dmg-staging \
			-ov -format UDZO \
			-fs HFS+ \
			"$(DMG_NAME)" \
		&& rm -rf dmg-staging \
		&& codesign --sign "$(SIGNING_IDENTITY)" --timestamp "$(DMG_NAME)"
	@echo "✅ DMG created: $(BUILD_DIR)/$(DMG_NAME)"
	@echo "🍎 Submitting DMG to Apple notary..."
	xcrun notarytool submit "$(BUILD_DIR)/$(DMG_NAME)" \
		--keychain-profile $(NOTARY_PROFILE) \
		--wait
	@echo "📎 Stapling DMG notarization ticket..."
	xcrun stapler staple "$(BUILD_DIR)/$(DMG_NAME)"
	xcrun stapler validate "$(BUILD_DIR)/$(DMG_NAME)"
	@echo "✅ DMG notarized & stapled"

release: dmg
	@echo ""
	@echo "🎉 Release complet !"
	@echo "   App : $(APP_PATH)"
	@echo "   DMG : $(BUILD_DIR)/$(DMG_NAME)"
	@du -h "$(BUILD_DIR)/$(DMG_NAME)"

install: export
	@echo "📥 Installing to /Applications..."
	@killall "$(APP_NAME)" 2>/dev/null || true
	@rm -rf "/Applications/$(APP_NAME).app"
	@cp -R "$(APP_PATH)" /Applications/
	@echo "✅ Installed at /Applications/$(APP_NAME).app"

uninstall:
	@echo "🗑️  Uninstalling..."
	@killall "$(APP_NAME)" 2>/dev/null || true
	@rm -rf "/Applications/$(APP_NAME).app"
	@echo "✅ Removed from /Applications"

# ============================================================
# Export options plist (auto-generated if missing)
# ============================================================
_export-options:
	@mkdir -p "$(BUILD_DIR)"
	@printf '%s\n' \
		'<?xml version="1.0" encoding="UTF-8"?>' \
		'<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' \
		'<plist version="1.0">' \
		'<dict>' \
		'    <key>method</key>' \
		'    <string>developer-id</string>' \
		'    <key>teamID</key>' \
		'    <string>$(TEAM_ID)</string>' \
		'    <key>signingStyle</key>' \
		'    <string>manual</string>' \
		'    <key>signingCertificate</key>' \
		'    <string>Developer ID Application</string>' \
		'    <key>provisioningProfiles</key>' \
		'    <dict>' \
		'        <key>be.hiha.voice</key>' \
		'        <string>Hi-Ha Voice Developer ID</string>' \
		'    </dict>' \
		'</dict>' \
		'</plist>' > "$(BUILD_DIR)/ExportOptions.plist"

# ============================================================
# Run / cleanup
# ============================================================
run:
	@if [ -d "/Applications/$(APP_NAME).app" ]; then \
		open "/Applications/$(APP_NAME).app"; \
	elif [ -d "$(APP_PATH)" ]; then \
		open "$(APP_PATH)"; \
	elif [ -d "$$HOME/Downloads/$(APP_NAME).app" ]; then \
		open "$$HOME/Downloads/$(APP_NAME).app"; \
	else \
		APP=$$(find "$$HOME/Library/Developer/Xcode/DerivedData" -name "$(APP_NAME).app" -type d | head -1); \
		if [ -n "$$APP" ]; then open "$$APP"; \
		else echo "❌ App introuvable. Lance 'make local' ou 'make release' d'abord."; exit 1; fi; \
	fi

clean:
	@echo "🧹 Cleaning build artifacts..."
	@rm -rf "$(BUILD_DIR)" "$(LOCAL_DERIVED_DATA)"
	@echo "✅ Cleaned"

clean-all: clean
	@echo "🧹 Wiping dependencies + DerivedData..."
	@rm -rf "$(DEPS_DIR)"
	@rm -rf "$$HOME/Library/Developer/Xcode/DerivedData/HiHaVoice-"*
	@echo "✅ Full clean (dependencies gone — 'make setup' les reconstruira)"

help:
	@echo "Hi-Ha Voice — Makefile"
	@echo ""
	@echo "Développement :"
	@echo "  make local         Build Debug ad-hoc (pas besoin de compte Apple) → ~/Downloads/Hi-Ha Voice.app"
	@echo "  make dev           Build + lance l'app"
	@echo "  make run           Lance la dernière app buildée"
	@echo ""
	@echo "Release (signée Developer ID Pixinko) :"
	@echo "  make archive       Archive Release signée"
	@echo "  make export        → Export .app signée dans build/export/"
	@echo "  make install       → Installe dans /Applications/"
	@echo "  make notarize      → Submit à Apple Notary (attend l'approbation)"
	@echo "  make staple        → Attache le ticket au .app"
	@echo "  make dmg           → Crée le DMG signé"
	@echo "  make release       = archive + export + notarize + staple + dmg (one-shot)"
	@echo ""
	@echo "Maintenance :"
	@echo "  make check         Vérifie les outils requis"
	@echo "  make whisper       Build whisper.xcframework si absent"
	@echo "  make clean         Supprime build/"
	@echo "  make clean-all     + supprime DerivedData + HiHaVoice-Dependencies"
	@echo "  make uninstall     Retire /Applications/Hi-Ha Voice.app"
