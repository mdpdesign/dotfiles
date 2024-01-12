# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source "${HOME}/antigen.zsh"

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle ansible
antigen bundle docker
antigen bundle git
antigen bundle pip
antigen bundle sudo
antigen bundle kubectl
antigen bundle kubectx
antigen bundle command-not-found

antigen bundle djui/alias-tips

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
antigen theme romkatv/powerlevel10k

# Tell Antigen that you're done.
antigen apply

# Set KUBECONFIG
if [[ -d ~/.kube/configs ]]; then
    for conf in $(find ~/.kube/configs -type f -regex '\(.*.yml\|.*.yaml\)'); do
        export KUBECONFIG=${conf}:${KUBECONFIG}
    done
fi

# Completion
autoload bashcompinit && bashcompinit 
autoload -Uz compinit && compinit

command -v kubectl &> /dev/null && source <(kubectl completion zsh)
command -v helm &> /dev/null && source <(helm completion zsh)

# Aliases
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

alias kx="kubectx"
alias kn="kubens"

# Load Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Load FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# SSH Agent - Dev containers
if [ -z "SSH_AUTH_SOCK" ]; then
    # Check for a currently running instance of the agent
    RUNNING_AGENT="$(ps -ax | grep 'ssh-agent -s' | grep -v grep | wc -l | tr -d '[:space:]')"
    if [ "$RUNNING_AGENT" = "0" ]; then
        # Launch a new instance of the agent
        ssh-agent -s &> "${HOME}/.ssh/ssh-agent"
    fi
    eval "$(cat ${HOME}/.ssh/ssh-agent)" &> /dev/null
    ssh-add "${HOME}/.ssh/id_rsa" &> /dev/null
fi

# https://code.visualstudio.com/docs/terminal/shell-integration
# Not working with Powerlevel 10k
# [[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code -locate-shell-integration-path zsh)"
