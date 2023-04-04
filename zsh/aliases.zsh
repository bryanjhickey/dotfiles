# ALIASES ---------------------------------------------------------------------
alias c='clear'
alias s='source ~/.zshrc'
alias rm=trash
alias trim="awk '{\$1=\$1;print}'"
alias pn=pnpm

# GIT ALIASES -----------------------------------------------------------------
alias gc='git commit'
alias gco='git checkout'
alias ga='git add'
alias gb='git branch'
alias gba='git branch --all'
alias gbd='git branch -D'
alias gcp='git cherry-pick'
alias gd='git diff -w'
alias gds='git diff -w --staged'
alias grs='git restore --staged'
alias gst='git rev-parse --git-dir > /dev/null 2>&1 && git status || exa'
alias gu='git reset --soft HEAD~1'
alias gpr='git remote prune origin'
alias ff='gpr && git pull --ff-only'
alias grd='git fetch origin && git rebase origin/master'
alias gbb='git-switchbranch'
alias gbf='git branch | head -1 | xargs' # top branch
alias gl=pretty_git_log
alias gla=pretty_git_log_all
#alias gl="git log --graph --format=format:'%C(bold blue)%h%C(reset) - %C(white)%s%C(reset) %C(green)%an %ar %C(reset) %C(bold magenta)%d%C(reset)'"
#alias gla="git log --all --graph --format=format:'%C(bold blue)%h%C(reset) - %C(white)%s%C(reset) %C(bold magenta)%d%C(reset)'"
alias git-current-branch="git branch | grep \* | cut -d ' ' -f2"
alias grc='git rebase --continue'
alias gra='git rebase --abort'
alias gec='git status | grep "both modified:" | cut -d ":" -f 2 | trim | xargs nvim -'
alias gcan='gc --amend --no-edit'

alias gp="git push -u 2>&1 | tee >(cat) | grep \"pull/new\" | awk '{print \$2}' | xargs open"
alias gpf='git push --force-with-lease'

alias gbdd='git-branch-utils -d'
alias gbuu='git-branch-utils -u'
alias gbrr='git-branch-utils -r -b develop'
alias gg='git branch | fzf | xargs git checkout'
alias gup='git branch --set-upstream-to=origin/$(git-current-branch) $(git-current-branch)'

alias gnext='git log --ancestry-path --format=%H ${commit}..master | tail -1 | xargs git checkout'
alias gprev='git checkout HEAD^'

# FUNCTIONS -------------------------------------------------------------------
# function gg {
#     git branch | grep "$1" | head -1 | xargs git checkout
# }

function take {
    mkdir -p $1
    cd $1
}

note() {
    echo "date: $(date)" >> $HOME/drafts.txt
    echo "$@" >> $HOME/drafts.txt
    echo "" >> $HOME/drafts.txt
}

function unmount_all {
    diskutil list |
    grep external |
    cut -d ' ' -f 1 |
    while read file
    do
        diskutil unmountDisk "$file"
    done
}

mff ()
{
    local curr_branch=`git-current-branch`
    gco master
    ff
    gco $curr_branch
}



JOBFILE="$DOTFILES/job-specific.sh"
if [ -f "$JOBFILE" ]; then
    source "$JOBFILE"
fi


extract-audio-and-video () {
    ffmpeg -i "$1" -c:a copy obs-audio.aac
    ffmpeg -i "$1" -c:v copy obs-video.mp4
}

alias epdir='cd `epdir.sh`'


hs () {
 curl https://httpstat.us/$1
}

# alias dp='displayplacer "id:83F2F7DC-590D-6294-B7FB-521754A2A693 res:3840x2160 hz:60 color_depth:8 scaling:off origin:(0,0) degree:0" "id:BD0804E4-6EAA-1C8D-1CFB-D6B734DE10A5 res:3840x2160 hz:60 color_depth:8 scaling:off origin:(3840,0) degree:0"'
# alias mirror-displays='displayplacer "id:C3F5FA73-E883-4B6D-88B3-DA6D6A8192B3+7ECC0B33-A07B-46A6-AFB8-565FEFE68216 res:3840x2160 hz:60 color_depth:8 scaling:off origin:(0,0) degree:0"'

copy-line () {
  rg --line-number "${1:-.}" | sk --delimiter ':' --preview 'bat --color=always --highlight-line {2} {1}' | awk -F ':' '{print $3}' | sed 's/^\s+//' | pbcopy
}

open-at-line () {
  vim $(rg --line-number "${1:-.}" | sk --delimiter ':' --preview 'bat --color=always --highlight-line {2} {1}' | awk -F ':' '{print "+"$2" "$1}')
}
