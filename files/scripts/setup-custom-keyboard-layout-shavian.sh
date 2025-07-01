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
short_desc.text = 'sh'

description = ET.SubElement(config_item, 'description')
description.text = 'English (Shavian)'

language_list = ET.SubElement(config_item, 'languageList')
iso639_id = ET.SubElement(language_list, 'iso639Id')
iso639_id.text = 'eng'

# Create variant list
variant_list = ET.SubElement(layout, 'variantList')

# Add Iykury variant
variant_iykury = ET.SubElement(variant_list, 'variant')
config_item_iykury = ET.SubElement(variant_iykury, 'configItem')
name_iykury = ET.SubElement(config_item_iykury, 'name')
name_iykury.text = 'iykury'
desc_iykury = ET.SubElement(config_item_iykury, 'description')
desc_iykury.text = 'English (Shavian, Iykury)'

# Add Imperial variant
variant_igc = ET.SubElement(variant_list, 'variant')
config_item_igc = ET.SubElement(variant_igc, 'configItem')
name_igc = ET.SubElement(config_item_igc, 'name')
name_igc.text = 'igc'
desc_igc = ET.SubElement(config_item_igc, 'description')
desc_igc.text = 'English (Shavian, Imperial)'

# Add QWERTY variant
variant_qwerty = ET.SubElement(variant_list, 'variant')
config_item_qwerty = ET.SubElement(variant_qwerty, 'configItem')
name_qwerty = ET.SubElement(config_item_qwerty, 'name')
name_qwerty.text = 'qwerty'
desc_qwerty = ET.SubElement(config_item_qwerty, 'description')
desc_qwerty.text = 'English (Shavian, QWERTY)'

# Write back to file
tree.write('/usr/share/X11/xkb/rules/evdev.xml', encoding='utf-8', xml_declaration=True)
print("Successfully added Shavian layout with variants to evdev.xml")
EOF

# Add entries to evdev.lst
echo " shavian English (Shavian)" >> /usr/share/X11/xkb/rules/evdev.lst
echo "  iykury shavian: English (Shavian, Iykury)" >> /usr/share/X11/xkb/rules/evdev.lst
echo "  igc shavian: English (Shavian, Imperial)" >> /usr/share/X11/xkb/rules/evdev.lst
echo "  qwerty shavian: English (Shavian, QWERTY)" >> /usr/share/X11/xkb/rules/evdev.lst

echo "Shavian keyboard layout setup complete!"
echo "Available variants:"
echo "  setxkbmap shavian iykury"
echo "  setxkbmap shavian igc" 
echo "  setxkbmap shavian qwerty"