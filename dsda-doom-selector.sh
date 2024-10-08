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
wad_files=(*.wad)

echo "Select a PWAD:"
select wad_file in "None" "${wad_files[@]}"; do
  if [[ "$REPLY" == "1" ]]; then
    wad_file="$iwad"  # if "None" is selected, use the iwad only, pretty dumb but idk how bash works and dsda is fine with being passed an iwad for -file lmao
                      # psure i could somehow just exclude the -file param but no idea kek
    break
  elif [ -n "$wad_file" ]; then
    break
  else
    echo "Invalid selection."
  fi
done

# run dsda with the selected wads
dsda-doom -file "$wad_file" -iwad "$iwad"
