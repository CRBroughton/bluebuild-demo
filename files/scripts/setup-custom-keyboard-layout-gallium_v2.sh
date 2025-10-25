#!/bin/bash
# setup-custom-keyboard-layout-gallium_v2.sh
# Script to add Gallium v2 keyboard layout to XKB configuration
set -euo pipefail

echo "Setting up Gallium v2 keyboard layout..."

# Backup original files if not already backed up
if [ ! -f /usr/share/X11/xkb/rules/evdev.xml.backup ]; then
    cp /usr/share/X11/xkb/rules/evdev.xml /usr/share/X11/xkb/rules/evdev.xml.backup
fi
if [ ! -f /usr/share/X11/xkb/rules/evdev.lst.backup ]; then
    cp /usr/share/X11/xkb/rules/evdev.lst /usr/share/X11/xkb/rules/evdev.lst.backup
fi

# Add Gallium v2 layout to evdev.xml using Python
python3 << 'EOF'
import xml.etree.ElementTree as ET

# Parse the XML file
tree = ET.parse('/usr/share/X11/xkb/rules/evdev.xml')
root = tree.getroot()

# Find the layoutList element
layout_list = root.find('.//layoutList')
if layout_list is None:
    print("Error: layoutList not found in evdev.xml")
    exit(1)

# Check if gallium_v2 already exists
existing = layout_list.find(".//layout/configItem/[name='gallium_v2']/..")
if existing is not None:
    print("Gallium v2 layout already exists in evdev.xml, skipping...")
    exit(0)

# Create new layout element
layout = ET.SubElement(layout_list, 'layout')
config_item = ET.SubElement(layout, 'configItem')

# Add layout details
name = ET.SubElement(config_item, 'name')
name.text = 'gallium_v2'

short_desc = ET.SubElement(config_item, 'shortDescription')
short_desc.text = 'gv2'

description = ET.SubElement(config_item, 'description')
description.text = 'English (Gallium v2)'

language_list = ET.SubElement(config_item, 'languageList')
iso639_id = ET.SubElement(language_list, 'iso639Id')
iso639_id.text = 'eng'

# Write back to file
tree.write('/usr/share/X11/xkb/rules/evdev.xml', encoding='utf-8', xml_declaration=True)
print("Successfully added Gallium v2 layout to evdev.xml")
EOF

# Add entry to evdev.lst if not already present
if ! grep -q "gallium_v2" /usr/share/X11/xkb/rules/evdev.lst; then
    echo "  gallium_v2		English (Gallium v2)" >> /usr/share/X11/xkb/rules/evdev.lst
fi

echo "Gallium v2 keyboard layout setup complete!"
echo ""
echo "To use the layout, run:"
echo "  setxkbmap gallium_v2"
echo ""
