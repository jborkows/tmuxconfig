DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "${DIR}/common.sh"
if [ "$1" = "runs" ]; then
	bash "${DIR}/fetcher.sh"
fi

if [ "$1" = "pulls" ]; then
	bash "${DIR}/pulls.sh"
fi

if [ "$1" = "create issue" ]; then
	bash "${DIR}/createissue.sh"
fi
if [ "$1" = "issues" ]; then
	id=$(bash  "${DIR}/issues.sh")

	if [ -n "$id" ]; then
		gh issue edit ${id} --repo ${repo} 
	fi
fi
