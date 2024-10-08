#!/bin/bash

# go in the script directory so it can scan for pwads there
cd "$(dirname "$0")"

# scan for IWADs in dsda-path
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

# if theres no IWADs bail outta here
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

# idk what that even is but it makes shit not think ".wad" is a valid selection when it cant find pwads in the dir
shopt -s nullglob
pwad_files=(*.wad)

# make sure theres pwads in the directory
if [ ${#pwad_files[@]} -eq 0 ]; then
  echo "No PWAD files found in the current directory. Only IWAD will be used."
  dsda-doom -iwad "$iwad"
  exit 0
fi

selected_pwads=()
while true; do
  echo "Select a PWAD:"
  select pwad_file in "Done" "${pwad_files[@]}"; do
    if [[ "$REPLY" == "1" ]]; then
      break 2
    elif [ -n "$pwad_file" ]; then
      # add the selected PWAD to the list
      selected_pwads+=("$pwad_file")
      echo -e "Selected PWADs: ${selected_pwads[*]}\n"
      break
    else
      echo "Invalid selection."
    fi
  done
done

# run dsda with the selected wads
if [ ${#selected_pwads[@]} -eq 0 ]; then
  dsda-doom -iwad "$iwad" # well just run the iwad if you didnt select any pwad lmao
else
  dsda-doom -file "${selected_pwads[@]}" -iwad "$iwad"
fi
