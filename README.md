# Java JAR Launcher for Linux

A generic solution for launching Java JAR files from file managers (Nemo, Nautilus, etc.) on Linux desktop environments.

## The Problem

On many Linux systems, double-clicking a JAR file from a file manager doesn't work properly because:

1. The system's default Java handler is often misconfigured (missing the `%f` parameter)
2. JAR files are launched from the wrong working directory, breaking applications that use relative paths

This results in JAR applications either not launching at all, or starting and immediately crashing.

## The Solution

This project provides a **generic JAR launcher** that:

- ✅ Works with **any** JAR file, not just specific applications
- ✅ Automatically changes to the JAR's directory before launching
- ✅ Preserves relative paths within the JAR application
- ✅ Integrates seamlessly with GNOME, Cinnamon, and other desktop environments
- ✅ Makes JAR files double-clickable in Nemo, Nautilus, and other file managers

## Project Structure

```
java-jar-launcher/
├── java-jar-runner.sh           # Generic script that launches any JAR from its directory
├── java-jar-launcher.desktop    # MIME handler for all JAR files
├── ejs/                          # Optional: EJS Console specific files
│   ├── EjsConsole.desktop       # Desktop entry for EJS Console application
│   ├── EjsSLogo.png             # EJS Console icon
│   ├── EjsIcon.gif              # Additional EJS icons
│   └── EjsLogo.gif
├── Makefile                      # Installation automation
└── README.md                     # This file
```

## Installation

### Quick Install

Install the generic JAR launcher (works with all JAR files):

```bash
make install
```

This will:
1. Copy `java-jar-runner.sh` to `$HOME/.local/bin/`
2. Install `java-jar-launcher.desktop` to `$HOME/.local/share/applications/`
3. Set it as the default handler for JAR files
4. Update the desktop database

### Optional: Install EJS Console Launcher

If you have EJS Console installed, you can also install its specific launcher:

```bash
make install-ejs
```

This adds a menu entry for "EJS Console" in your applications menu.

**Custom EJS Installation Path:**

If EJS is installed in a different location, specify the path:

```bash
make install-ejs EJS_PATH=/your/custom/path/to/EJS
```

Default path: `/storage/develop/opensourcephysics/EJS`

### Uninstall

To remove all installed files:

```bash
make uninstall
```

## How It Works

### The Magic Behind the Scenes

When you double-click `MyApp.jar` in your file manager:

1. **File manager** detects the MIME type: `application/x-java-archive`
2. **Desktop system** finds the handler: `java-jar-launcher.desktop`
3. **Desktop file** has: `Exec=/home/user/.local/bin/java-jar-runner.sh %f`
4. **The `%f` placeholder** gets replaced with: `/path/to/MyApp.jar`
5. **The wrapper script** runs:
   ```bash
   JAR_FILE="/path/to/MyApp.jar"
   JAR_DIR="/path/to"              # Extracted with dirname
   cd "/path/to"                    # Change to JAR's directory
   java -jar "MyApp.jar"            # Launch from correct location
   ```

### Why This Works

Most Java applications use relative paths like:
- `./config/settings.xml`
- `./lib/dependencies.jar`
- `./resources/images/`

If you run `java -jar /path/to/MyApp.jar` from your home directory, these relative paths break. This launcher solves that by always running the JAR from its own directory.

## Requirements

- Linux with a desktop environment (GNOME, Cinnamon, KDE, XFCE, etc.)
- Java Runtime Environment (JRE) installed
- File manager that respects XDG MIME types (Nemo, Nautilus, Thunar, etc.)

## Files Explained

### `java-jar-runner.sh`

Generic wrapper script that:
- Receives the JAR file path as argument
- Extracts the directory path
- Changes to that directory
- Launches the JAR with Java

**Installed to:** `$HOME/.local/bin/java-jar-runner.sh`

### `java-jar-launcher.desktop`

Desktop entry file that:
- Declares it can handle JAR files (MIME type association)
- Specifies the command to run when a JAR is opened
- Uses `%f` placeholder for the file path

**Installed to:** `$HOME/.local/share/applications/java-jar-launcher.desktop`

### `ejs/EjsConsole.desktop` (Optional)

Specific desktop entry for the EJS Console application:
- Adds "EJS Console" to your applications menu
- Points to the EJS installation directory
- Uses a custom icon

**Installed to:** `$HOME/.local/share/applications/EjsConsole.desktop`

## Testing

After installation, test with any JAR file:

1. Open your file manager (Nemo, Nautilus, etc.)
2. Navigate to any directory containing a JAR file
3. Double-click the JAR file
4. It should launch properly!

## Troubleshooting

### JAR doesn't launch

Check that Java is installed:
```bash
java -version
```

### Wrong application opens

Verify the MIME association:
```bash
xdg-mime query default application/x-java-archive
```

Should output: `java-jar-launcher.desktop`

If not, run:
```bash
xdg-mime default java-jar-launcher.desktop application/x-java-archive
```

### Desktop file not found

Make sure the desktop database is updated:
```bash
update-desktop-database ~/.local/share/applications/
```

## Customization

### For Specific Applications

You can create custom desktop files for specific JAR applications (like the EJS example):

1. Create a `.desktop` file in `~/.local/share/applications/`
2. Point `Exec=` to a wrapper script that sets the working directory
3. Add an icon and appropriate metadata
4. Run `update-desktop-database ~/.local/share/applications/`

### For Different Java Versions

If you need a specific Java version, modify `java-jar-runner.sh` to use the full path:

```bash
/usr/lib/jvm/java-11-openjdk/bin/java -jar "$(basename "$JAR_FILE")" "${@:2}"
```

## Contributing

This is a simple, universal solution. Suggestions and improvements welcome!

## License

Public domain / MIT / Your choice. Use freely!

## Credits

Created to solve the common problem of JAR files not launching properly from Linux file managers.

---

**Now you can double-click JAR files like they're supposed to work!** 🎉
