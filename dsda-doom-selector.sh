#!/bin/bash

# go in the script directory so it can scan for pwads there
cd "$(dirname "$0")"

# Scan for IWADs in dsda-path
dsda_dir="/usr/local/share/games/doom" #thats where the iwads should be placed ideally per install instructions
iwad_files=()

for wad in "$dsda_dir"/*.wad; do
  if [[ ! -e "$wad" ]]; then
    break
  fi

  # Skip "dsda-doom.wad"
  if [[ "$(basename "$wad")" != "dsda-doom.wad" ]]; then
    iwad_files+=("$wad")
  fi
done

if [ ${#iwad_files[@]} -eq 0 ]; then
  echo "No valid IWAD files found in $dsda_dir. Exiting."
  exit 1
fi

echo "Select an IWAD:"
select iwad in "${iwad_files[@]}"; do
  if [ -n "$iwad" ]; then
    break
  else
    echo "Invalid selection."
  fi
done

shopt -s nullglob # idk what that even is but it makes shit not think ".wad" is a valid selection when it cant find pwads in the dir
pwad_files=(*.wad)

echo "Select a PWAD:"
select pwad_file in "None" "${pwad_files[@]}"; do
  if [[ "$REPLY" == "1" ]]; then
    dsda-doom -iwad "$iwad"
    exit 1 #exit out here if we just want to play an IWAD
  elif [ -n "$pwad_file" ]; then
    break
  else
    echo "Invalid selection."
  fi
done

# run dsda with the selected wads
dsda-doom -file "$pwad_file" -iwad "$iwad"
