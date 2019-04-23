## bash settings


if [ -d "$HOME/rice-wine/bin" ] ; then
    echo "Add ~/rice-wine/bin dir to PATH"
    PATH="$HOME/rice-wine/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    echo "Add ~/bin to PATH"
    PATH="$HOME/bin:$PATH"
fi

# git flow completion
# echo "turn on git completion."
# source "$HOME/rice-wine/bash/git-completion"

# coq
if [ -d "$HOME/bin/Coq8.4/bin" ] ; then
    PATH="$HOME/bin/Coq8.4/bin:$PATH"
fi

# texlive for latex
PATH="c:/texlive/2018/bin/win32:$PATH"

# specify emacs server file manually, necessary on windows
export EMACS_SERVER_FILE="$HOME/rice-wine/server/server"

# specify editor used for git
export editor=et