#!/usr/bin/env zsh
# ~/.zsh/zsh_breathe.zsh
# Breathing/pulsing zsh prompt via zle -F async fd handler.
# Must be `source`d into an interactive zsh session — running it
# standalone (./zsh_breathe.zsh) will NOT animate your real prompt.

autoload -Uz add-zsh-hook

typeset -g _breath_level=40
typeset -g _breath_dir=6
typeset -g _breath_active=1

typeset -g _breath_fifo="/tmp/zsh_breathe_$$"
[[ -p $_breath_fifo ]] || mkfifo "$_breath_fifo"

# Open the fifo for read+write, bind it to an fd number.
# zle -F requires a numeric fd, not a path — this is the fix.
typeset -g _breath_fd
exec {_breath_fd}<>"$_breath_fifo"

_breathe_tick() {
  (( _breath_level += _breath_dir ))
  if (( _breath_level >= 220 )); then
    _breath_level=220; _breath_dir=-6
  elif (( _breath_level <= 120 )); then
    _breath_level=120; _breath_dir=6
  fi

  local hex=$(printf '%02x' $_breath_level)
  # %n = username, %m = hostname, %~ = full path (home shown as ~)
  PROMPT="%F{#${hex}${hex}${hex}}%n@%m%f %F{#0D9B0D}%~%f
❯ "
  zle && zle reset-prompt
}

_breathe_handler() {
  local _junk
  read -r -u $_breath_fd _junk
  _breathe_tick
}

zle -F "$_breath_fd" _breathe_handler

_breathe_bg() {
  while (( _breath_active )); do
    echo tick > "$_breath_fifo" 2>/dev/null
    sleep 0.16
  done
}
_breathe_bg &>/dev/null &!
typeset -g _breath_pid=$!

_breathe_cleanup() {
  _breath_active=0
  kill -9 "$_breath_pid" 2>/dev/null
  wait "$_breath_pid" 2>/dev/null
  exec {_breath_fd}>&-
  rm -f "$_breath_fifo"
}
add-zsh-hook zshexit _breathe_cleanup
