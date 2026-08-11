#!/bin/zsh

ws_options_names=("${(f)$(hyprctl workspaces -j | jq -r '.[] | .name')}")
ws_options_ids=("${(f)$(hyprctl workspaces -j | jq -r '.[] | .id')}")

ws_selection=$(echo "${(j:\n:)ws_options_names}" | fuzzel --dmenu)

for ((i=1; i <=${#ws_options_names[@]}; i++)); do
    # echo "${ws_options_names[i]} : $ws_selection"
    if [[ $ws_options_names[i] == $ws_selection ]]; then
        echo "match found."
        ws_selection_id=i
        echo "switching to workspace {name=${ws_options_names[i]}, id=${ws_options_ids[i]}}"
        hyprctl dispatch "hl.dsp.focus({ workspace = '${ws_options_ids[i]}'})"
        exit 0
    fi
done
