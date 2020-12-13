antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh
source ~/.zsh_plugins.sh # point to the plugins file

# use with a bundle name to add it to the txt file
function antibody_new {
  if ! [[ $# -eq 0 ]]; then
    printf '%s\n%s\n' "$1" "$(cat ~/.zsh_plugins.txt)" >~/.zsh_plugins.txt
    echo "added '$1' to ~/.zsh_plugins.txt"
  fi # use without bundle name to just update your bundle list
  antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh
  antibody update
}

# Options
setopt hist_ignore_all_dups # remove older duplicate entries from history
setopt inc_append_history # save history entries as soon as they are entered
setopt hist_reduce_blanks # remove superfluous blanks from history items
setopt share_history # share history between different instances
setopt always_to_end # move cursor to end if word had one match
setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt auto_cd # cd by typing directory name if it's not a command

# Enable autocompletions
autoload -Uz compinit
typeset -i updated_at=$(
  date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null
)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi
zmodload -i zsh/complist

# Improve autocompletion style
zstyle ':completion:*' menu select # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # approximate matches
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=247' # color fitting my terminal bg, using 256 color code

# Save history for auto suggestions
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=$HISTSIZE

# Keybindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

if command -v starship &> /dev/null
then
  eval $(starship init zsh)
fi