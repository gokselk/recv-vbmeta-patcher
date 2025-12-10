#!/bin/bash

# List of vbmeta partitions to patch
VBMETA_PARTITIONS="vbmeta vbmeta_system vbmeta_samsung vbmeta_vendor"

for partition in $VBMETA_PARTITIONS; do
	img_file="${partition}.img"
	lz4_file="${partition}.img.lz4"

	# Check if lz4 compressed version exists
	if [ -f "$lz4_file" ]; then
		echo "Decompressing $lz4_file..."
		lz4 -B6 --content-size -f "$lz4_file" "$img_file"
		rm -rf "$lz4_file"
	fi

	# Patch the vbmeta image if it exists
	if [ -f "$img_file" ]; then
		echo "Patching $img_file to disable verification..."
		./vbmeta-disable-verification "$img_file"
	fi
done

echo "vbmeta patching complete!"
