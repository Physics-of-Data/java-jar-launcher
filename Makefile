# =============================================================================
# Java JAR Launcher - Makefile
# =============================================================================
# This Makefile installs a generic JAR file launcher for Linux desktop
# environments (GNOME, Cinnamon, Nemo, etc.)
#
# Targets:
#   make install        - Install the generic JAR launcher
#   make install-ejs    - Install EJS Console launcher (optional)
#   make uninstall      - Remove all installed files
#   make clean          - Clean temporary files
# =============================================================================

# Installation directories
BIN_DIR = $(HOME)/.local/bin
APPS_DIR = $(HOME)/.local/share/applications
ICONS_DIR = $(HOME)/.icons

# EJS Console installation path (override with: make install-ejs EJS_PATH=/your/path)
EJS_PATH ?= /storage/develop/opensourcephysics/01-ejs/EJS

# Source files
JAR_RUNNER_SCRIPT = java-jar-runner.sh
JAR_LAUNCHER_DESKTOP = java-jar-launcher.desktop
EJS_DESKTOP = ejs/EjsConsole.desktop
EJS_ICON = ejs/EjsSLogo.png

# Installed files (for uninstall)
INSTALLED_SCRIPT = $(BIN_DIR)/$(JAR_RUNNER_SCRIPT)
INSTALLED_DESKTOP = $(APPS_DIR)/java-jar-launcher.desktop
INSTALLED_EJS_DESKTOP = $(APPS_DIR)/EjsConsole.desktop
INSTALLED_EJS_ICON = $(ICONS_DIR)/EjsSLogo.png

.PHONY: all install install-ejs uninstall clean help

# Default target
all: help

help:
	@echo "Java JAR Launcher - Installation"
	@echo "=================================="
	@echo ""
	@echo "Available targets:"
	@echo "  make install        - Install generic JAR launcher (works with any JAR)"
	@echo "  make install-ejs    - Install EJS Console launcher (requires EJS installed)"
	@echo "  make uninstall      - Remove all installed files"
	@echo "  make clean          - Clean temporary files"
	@echo ""
	@echo "Installation directories:"
	@echo "  Scripts:       $(BIN_DIR)"
	@echo "  Applications:  $(APPS_DIR)"
	@echo "  Icons:         $(ICONS_DIR)"
	@echo ""
	@echo "Customization:"
	@echo "  EJS_PATH       - EJS installation path (default: $(EJS_PATH))"
	@echo "  Example: make install-ejs EJS_PATH=/opt/EJS"

install:
	@echo "Installing Java JAR Launcher..."
	@# Create directories if they don't exist
	@mkdir -p $(BIN_DIR)
	@mkdir -p $(APPS_DIR)
	@# Install the shell script
	@install -m 755 $(JAR_RUNNER_SCRIPT) $(INSTALLED_SCRIPT)
	@echo "  ✓ Installed $(JAR_RUNNER_SCRIPT) to $(BIN_DIR)"
	@# Process and install the desktop file (replace HOME_PLACEHOLDER)
	@sed 's|HOME_PLACEHOLDER|$(HOME)|g' $(JAR_LAUNCHER_DESKTOP) > $(INSTALLED_DESKTOP)
	@chmod 644 $(INSTALLED_DESKTOP)
	@echo "  ✓ Installed java-jar-launcher.desktop to $(APPS_DIR)"
	@# Update desktop database
	@update-desktop-database $(APPS_DIR) 2>/dev/null || true
	@echo "  ✓ Updated desktop database"
	@# Set as default JAR handler
	@xdg-mime default java-jar-launcher.desktop application/x-java-archive 2>/dev/null || true
	@echo "  ✓ Set as default JAR file handler"
	@echo ""
	@echo "Installation complete! You can now double-click JAR files in your file manager."

install-ejs:
	@echo "Installing EJS Console launcher..."
	@# Check if EJS directory exists
	@if [ ! -d "$(EJS_PATH)" ]; then \
		echo "  ⚠ Warning: EJS directory not found at $(EJS_PATH)"; \
		echo "  Override with: make install-ejs EJS_PATH=/your/path"; \
		exit 1; \
	fi
	@# Create directories
	@mkdir -p $(APPS_DIR)
	@mkdir -p $(ICONS_DIR)
	@# Process and install EJS desktop file (replace placeholders)
	@sed -e 's|HOME_PLACEHOLDER|$(HOME)|g' \
	     -e 's|EJS_INSTALL_PATH|$(EJS_PATH)|g' \
	     $(EJS_DESKTOP) > $(INSTALLED_EJS_DESKTOP)
	@chmod 644 $(INSTALLED_EJS_DESKTOP)
	@echo "  ✓ Installed EjsConsole.desktop to $(APPS_DIR)"
	@echo "  ✓ Using EJS path: $(EJS_PATH)"
	@# Install EJS icon
	@install -m 644 $(EJS_ICON) $(INSTALLED_EJS_ICON)
	@echo "  ✓ Installed EjsSLogo.png to $(ICONS_DIR)"
	@# Update desktop database
	@update-desktop-database $(APPS_DIR) 2>/dev/null || true
	@echo "  ✓ Updated desktop database"
	@echo ""
	@echo "EJS Console launcher installed! Look for 'EJS Console' in your applications menu."

uninstall:
	@echo "Uninstalling Java JAR Launcher..."
	@# Remove installed files
	@rm -f $(INSTALLED_SCRIPT) && echo "  ✓ Removed $(JAR_RUNNER_SCRIPT)" || true
	@rm -f $(INSTALLED_DESKTOP) && echo "  ✓ Removed java-jar-launcher.desktop" || true
	@rm -f $(INSTALLED_EJS_DESKTOP) && echo "  ✓ Removed EjsConsole.desktop" || true
	@rm -f $(INSTALLED_EJS_ICON) && echo "  ✓ Removed EjsSLogo.png" || true
	@# Update desktop database
	@update-desktop-database $(APPS_DIR) 2>/dev/null || true
	@echo "  ✓ Updated desktop database"
	@echo ""
	@echo "Uninstallation complete."

clean:
	@echo "Cleaning temporary files..."
	@rm -f *~ ejs/*~
	@echo "Done."
