pragma Singleton
import QtQuick
import Quickshell 
import Quickshell.Io 

QtObject { 
    id: root
    
    // Static properties
    readonly property string fontFamily: "Fira Sans Semibold"
    
    // True while the loaded palette is a light one. Derived from the palette
    // itself rather than read from the GTK preference, so it updates atomically
    // with reloadTheme() and stays correct for any hand-written colors.json.
    readonly property bool isLight: background.hslLightness > 0.5

    // Dynamic color properties
    property color background: "#121417"
    property color error: "#ffb4ab"
    property color error_container: "#93000a"
    property color inverse_on_surface: "#2d3135"
    property color inverse_primary: "#256489"
    property color inverse_surface: "#dfe3e8"
    property color on_background: "#f8fafc"
    property color on_error: "#690005"
    property color on_error_container: "#ffdad6"
    property color on_primary: "#0f172a"
    property color on_primary_container: "#f8fafc"
    property color on_primary_fixed: "#001e2f"
    property color on_primary_fixed_variant: "#004c6e"
    property color on_secondary: "#0f172a"
    property color on_secondary_container: "#d3e5f5"
    property color on_secondary_fixed: "#0b1d29"
    property color on_secondary_fixed_variant: "#384956"
    property color on_surface: "#f8fafc"
    property color on_surface_variant: "#cbd5e1"
    property color on_tertiary: "#352b4b"
    property color on_tertiary_container: "#e9ddff"
    property color on_tertiary_fixed: "#1f1635"
    property color on_tertiary_fixed_variant: "#4b4163"
    property color outline: "#64748b"
    property color outline_variant: "#334155"
    property color primary: "#f1f5f9"
    property color primary_container: "#334155"
    property color primary_fixed: "#c8e6ff"
    property color primary_fixed_dim: "#94cdf7"
    property color scrim: "#000000"
    property color secondary: "#cbd5e1"
    property color secondary_container: "#384956"
    property color secondary_fixed: "#d3e5f5"
    property color secondary_fixed_dim: "#b7c9d9"
    property color shadow: "#000000"
    property color source_color: "#e5e7eb"
    property color surface: "#121417"
    property color surface_bright: "#353a3e"
    property color surface_container: "#1c2024"
    property color surface_container_high: "#282c32"
    property color surface_container_highest: "#343840"
    property color surface_container_low: "#181c20"
    property color surface_container_lowest: "#0a0f12"
    property color surface_dim: "#101417"
    property color surface_tint: "#94cdf7"
    property color surface_variant: "#41474d"
    property color tertiary: "#cec0e8"
    property color tertiary_container: "#4b4163"
    property color tertiary_fixed: "#e9ddff"
    property color tertiary_fixed_dim: "#cec0e8"

    property var themeReader: Process {
        id: reader
        command: ["cat", Quickshell.env("HOME") + "/.config/ml4w/colors/colors.json"]
        
        // REQUIRED: Quickshell needs this to parse the binary stream into text
        stdout: StdioCollector {
            onStreamFinished: {
                // "this.text" contains the full output of the cat command
                var output = this.text.trim();
                
                if (output !== "") {
                    try {
                        var newColors = JSON.parse(output);
                        for (var key in newColors) {
                            if (root.hasOwnProperty(key) && key !== "objectName") {
                                root[key] = newColors[key];
                            }
                        }
                        console.log("Theme colors loaded successfully!");
                    } catch (e) {
                        console.log("Failed to parse theme JSON: " + e);
                    }
                }
            }
        }
    }

    function reloadTheme() {
        // Toggle false then true to guarantee Quickshell restarts the cat process
        reader.running = false;
        reader.running = true;
    }

    // Load the JSON colors automatically when Quickshell starts
    Component.onCompleted: reloadTheme()
}