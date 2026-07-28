[ "$TERM" = "xterm-kitty" ] && export TERM=xterm-256color


# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
[[ ":$PATH:" != *":$BUN_INSTALL/bin:"* ]] && export PATH="$BUN_INSTALL/bin:$PATH"

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion



# Shell integrations
eval "$(zoxide init zsh)"

export PATH=$PATH:$HOME/go/bin
export MANPAGER="nvim +Man!"
export EDITOR=nvim 
export DOCKER_HOST=unix:///var/run/docker.sock


# zsh plugins
fpath+=(~/.zsh/plugins/zsh-completions/src)
autoload -Uz compinit
compinit -C

source "$HOME/.zsh_functions"

zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "Aloxaf/fzf-tab"

# Load fzf keybindings 
source <(fzf --zsh)

bindkey -v          # Enable Vim mode
export KEYTIMEOUT=1

# Keybindings
bindkey '^E' autosuggest-accept
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
bindkey '^A' beginning-of-line
bindkey '^?' backward-delete-char
bindkey "^[[3~" delete-char
bindkey '^[[D' backward-char
bindkey '^[[C' forward-char

setopt PROMPT_SUBST
PROMPT='%F{#a0a0a0}%n%f@%m %F{#e3e3e3}%~%f %F{#7da1a6}$(git_status)%f %F{#78dce8}%f '
# PROMPT='%F{#66FF7E}%n%f@%m %F{#43C0FE}%~%f %F{#C39AFF}$(git_status)%f %B%F{#FF00E4}%f%b '


alias dsa='docker stop $(docker ps -q)'
alias dra='docker rm $(docker ps -a -q)'
# alias note='nvim "$HOME/notes.md"'
alias swag=${HOME}/go/bin/swag

# opencode
export PATH=/home/avisek/.opencode/bin:$PATH
# echo "Swami Vivekananda read 4 books in a day before his geometry exam" 
# fastfetch


mdn_logic() {
    (
        cd ~/mdn/files/en-us || return
        fileName=$(fzf --prompt="mdn doc> " --preview="bat --color=always --style=numbers,changes --line-range :500 {}" < /dev/tty)
        if [ -n "$fileName" ]; then
            nvim -M -c "set nonumber norelativenumber wrap" -c "nnoremap q :quit<CR>" "$fileName" < /dev/tty
        fi
    )
}

mdn_widget() {
    zle -I           
    mdn_logic        
    zle reset-prompt 
}

zle -N mdn_widget
bindkey '^O' mdn_widget

alias mdn=mdn_logic

. "$HOME/.local/bin/env"


note_logic(){
	cd ~/notes || return
	nvim -c "set wrap linebreak" "$(date +%Y/%b-%d | tr 'A-Z' 'a-z').md"
	cd - > /dev/null
}

notes_logic() { 
	cd ~/notes || return 
	local count=$(ls -1 **/*.md | wc -l | tr -d ' ')
	fileName=$(fzf --prompt="~/notes [$count]> " --border=rounded \
		--margin=1,2 \
		--no-sort \
		--preview-window="right:60%:border-left" \
		--preview="bat --color=always --style=numbers,changes --line-range :500 {}" < /dev/tty)
		if [ -n "$fileName" ]; then
		nvim $fileName
		fi
		cd - > /dev/null
}
alias notes=notes_logic
alias note=note_logic



d_logic(){
	cd ~/diary || return
	nvim -c "set wrap linebreak" "$(date +%Y/%b-%d | tr 'A-Z' 'a-z').md"
	rm ~/.cache/diary_md_files 2> /dev/null
	cd - > /dev/null
}

ds_logic() {
	cd ~/diary || return
	cache="$HOME/.cache/diary_md_files"
	if [ ! -f "$cache" ]; then
		mkdir -p ~/.cache
		fd -e md . \
			| sort -t/ -k1,1 -k2,2M -k3,3n -r \
			> "$cache"
	fi
	count=$(wc -l < "$cache")
	fileName=$(fzf < "$cache" \
		--prompt="~/diary [$count]> " \
		--border=rounded \
		--margin=1,2 \
		--no-sort \
		--preview-window="right:60%:border-left" \
		--preview='sleep 0.1; bat --color=always --style=numbers --line-range :200 {}')

	[ -n "$fileName" ] && nvim "$fileName"

	cd - > /dev/null
}

obs() {
	cd "$HOME/Documents/Obsidian Vault" || return
	nvim -c "set wrap linebreak" -c "CodeiumDisable" -c "Telescope find_files"  
	cd - > /dev/null
}

alias ds=ds_logic
alias d=d_logic
alias p="nvim ~/pending.md"
alias q="~/.scripts/search-ai.sh"
alias ls='ls --color=auto'
alias cd=z


export HOMEBREW_NO_AUTO_UPDATE=1

# RowSQL
export PATH="/Users/avisek/.rowsql/bin:$PATH"


ec(){
	echo "$*" | openssl enc -aes-256-cbc -a
}
dc (){
	 echo "$*" | openssl enc -d -aes-256-cbc -a
}


relaod(){
	source "$HOME/.secrets.sh"
}

alias reload=relaod
source "$HOME/.secrets.sh"

# alias ip='echo "Local: $(ipconfig getifaddr $(route get default | grep interface | awk '\''{print $2}'\''))"; echo "Public: $(curl -s https://ifconfig.me)"'
alias tunnel='cloudflared tunnel run enhancci'
eval "$(ty generate-shell-completion zsh)"
alias grb="git ls-remote --heads origin"

# Tipp
export PATH="/Users/avisek/.tipp/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@18/bin:$PATH"

# Godo
export PATH="/Users/avisek/.godo/bin:$PATH"

# cargo
. $HOME/.cargo/env

# pnpm
export PNPM_HOME="/Users/avisek/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac;

HISTFILE="$HOME/.zsh_history"
HISTSIZE=5000
SAVEHIST=5000
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS

source <(docker completion zsh)

# Added by Antigravity IDE
export PATH="/Users/avisek/.antigravity-ide/antigravity-ide/bin:$PATH"


# Added by Antigravity CLI installer
export PATH="/Users/avisek/.local/bin:$PATH"

# Added by Antigravity IDE
export PATH="/Users/avisek/.antigravity-ide/antigravity-ide/bin:$PATH"

alias agy=agy-ide




export NVM_DIR="$HOME/.nvm"
load_nvm() {
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
}
lazy_load_node() {
    unalias nvm node npm npx pnpm yarn 2>/dev/null || true
    load_nvm
}

alias nvm='lazy_load_node && nvm'
alias node='lazy_load_node && node'
alias npm='lazy_load_node && npm'
alias npx='lazy_load_node && npx'
alias pnpm='lazy_load_node && pnpm'
alias yarn='lazy_load_node && yarn'

# opencode
export PATH=/Users/avisek/.opencode/bin:$PATH

# mimocode
export PATH=/Users/avisek/.mimocode/bin:$PATH


fpath=(~/.stripe $fpath)
autoload -Uz compinit && compinit -i

# proto
export PROTO_HOME="$HOME/.proto";
export PATH="$PROTO_HOME/shims:$PROTO_HOME/bin:$PATH";
