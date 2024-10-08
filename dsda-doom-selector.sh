#!/bin/bash

# go in the script directory so it can scan for pwads there
cd "$(dirname "$0")"

# idk prob should actually scan in the dsda iwad directory or smth
iwad_options=("doom.wad" "doom2.wad")
echo "Select an IWAD:"
select iwad in "${iwad_options[@]}"; do
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
