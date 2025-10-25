#!/bin/bash
# setup-custom-keyboard-layout-graphite.sh
# Script to add Graphite keyboard layout to XKB configuration
set -euo pipefail

echo "Setting up Graphite keyboard layout..."

# Backup original files if not already backed up
if [ ! -f /usr/share/X11/xkb/rules/evdev.xml.backup ]; then
    cp /usr/share/X11/xkb/rules/evdev.xml /usr/share/X11/xkb/rules/evdev.xml.backup
fi
if [ ! -f /usr/share/X11/xkb/rules/evdev.lst.backup ]; then
    cp /usr/share/X11/xkb/rules/evdev.lst /usr/share/X11/xkb/rules/evdev.lst.backup
fi

# Add Graphite layout to evdev.xml using Python
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

# Check if graphite already exists
existing = layout_list.find(".//layout/configItem/[name='graphite']/..")
if existing is not None:
    print("Graphite layout already exists in evdev.xml, skipping...")
    exit(0)

# Create new layout element
layout = ET.SubElement(layout_list, 'layout')
config_item = ET.SubElement(layout, 'configItem')

# Add layout details
name = ET.SubElement(config_item, 'name')
name.text = 'graphite'

short_desc = ET.SubElement(config_item, 'shortDescription')
short_desc.text = 'gr'

description = ET.SubElement(config_item, 'description')
description.text = 'English (Graphite)'

language_list = ET.SubElement(config_item, 'languageList')
iso639_id = ET.SubElement(language_list, 'iso639Id')
iso639_id.text = 'eng'

# Write back to file
tree.write('/usr/share/X11/xkb/rules/evdev.xml', encoding='utf-8', xml_declaration=True)
print("Successfully added Graphite layout to evdev.xml")
EOF

# Add entry to evdev.lst if not already present
if ! grep -q "graphite" /usr/share/X11/xkb/rules/evdev.lst; then
    echo "  graphite		English (Graphite)" >> /usr/share/X11/xkb/rules/evdev.lst
fi

echo "Graphite keyboard layout setup complete!"
echo ""
echo "To use the layout, run:"
echo "  setxkbmap graphite"
echo ""
