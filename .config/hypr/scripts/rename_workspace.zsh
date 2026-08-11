#!/bin/zsh

curr_ws_id=$(hyprctl activeworkspace -j | jq -r .id)
nu_ws_name=$(fuzzel --config="$HOME/.config/hypr/scripts/rename_workspace_fcfg.ini" \
                    --dmenu --prompt='nu workspace name:')

if [[ $nu_ws_name == 'default' ]]; then
    hyprctl dispatch "hl.dsp.workspace.rename({workspace='$curr_ws_id', name='$curr_ws_id'})"
else
    hyprctl dispatch "hl.dsp.workspace.rename({workspace='$curr_ws_id', name='$nu_ws_name'})"
fi
