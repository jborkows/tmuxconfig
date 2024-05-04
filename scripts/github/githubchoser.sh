
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
export FZF_DEFAULT_OPTS="--preview '{}' --bind 'f1:toggle-preview' --preview-window=hidden --ansi --reverse"
echo -e "runs\npulls\nissues\ncreate issue\n" | fzf --bind "enter:become(bash ${DIR}/become.sh {})"
