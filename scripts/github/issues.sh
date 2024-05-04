DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "${DIR}/common.sh"
export FZF_DEFAULT_OPTS="--preview 'batcat -n --color=always {}' --bind 'f1:toggle-preview' --preview-window=right:40% --ansi --reverse"

header=$(echo -e "enter to open\nctrl+a to self assign\nctrl+e to edit\nF4 to add comment\nctrl+q to close")
echo "${repo}" | xargs -I {}  gh issue list --json id,labels,state,url,milestone,createdAt,updatedAt,assignees,author,title,number --repo {} --limit 100 |
        jq -r '.[] | "\(.updatedAt) -> \(.title) \(.author.login) \(.labels)\t\(.| @base64)"' | fzf --delimiter='\t' \
        --header="${header}" \
        --preview='echo {2} | base64 --decode | jq -r '\''"Name \(.title) \(.number) \nCreated At \(.createdAt) Updated \(.updatedAt)\nState \(.state)\n\(.url)\nlabels \(.labels)\nassignees \(.assignees)"'\'''  \
	--bind="ctrl-a:abort+execute:echo {}|cut -d$'\t' -f2|base64 --decode|jq -r '.number'|xargs -I % gh issue edit --repo ${repo} --add-assignee \"@me\" %" \
	--bind="ctrl-e:abort+become:echo {}|cut -d$'\t' -f2|base64 --decode|jq -r '.number'|xargs -I % echo edit % " \
	--bind="F4:abort+become:echo {}|cut -d$'\t' -f2|base64 --decode|jq -r '.number'|xargs -I % echo comment % " \
	--bind="ctrl-q:abort+become:echo {}|cut -d$'\t' -f2|base64 --decode|jq -r '.number'|xargs -I % echo close % " \
        --bind="enter:abort+become:echo {}|cut -d$'\t' -f2 |base64 --decode| jq -r '.url' | xargs -I % firefox % ";

