#!/bin/bash
# setup-shavian-layout.sh
# Script to add Shavian keyboard layout to XKB configuration

set -euo pipefail

echo "Setting up Shavian keyboard layout..."

# Backup original files
cp /usr/share/X11/xkb/rules/evdev.xml /usr/share/X11/xkb/rules/evdev.xml.backup
cp /usr/share/X11/xkb/rules/evdev.lst /usr/share/X11/xkb/rules/evdev.lst.backup

# Add Shavian layout to evdev.xml using Python
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

# Create new layout element
layout = ET.SubElement(layout_list, 'layout')
config_item = ET.SubElement(layout, 'configItem')

# Add layout details
name = ET.SubElement(config_item, 'name')
name.text = 'shavian'

short_desc = ET.SubElement(config_item, 'shortDescription')
short_desc.text = 'Shaw'

description = ET.SubElement(config_item, 'description')
description.text = 'Shavian alphabet'

language_list = ET.SubElement(config_item, 'languageList')
iso639_id = ET.SubElement(language_list, 'iso639Id')
iso639_id.text = 'eng'

# Write back to file
tree.write('/usr/share/X11/xkb/rules/evdev.xml', encoding='utf-8', xml_declaration=True)
print("Successfully added Shavian layout to evdev.xml")
EOF

# Add entry to evdev.lst
echo "  shavian         Shavian alphabet" >> /usr/share/X11/xkb/rules/evdev.lst

echo "Shavian keyboard layout setup complete!"