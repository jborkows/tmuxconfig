DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

if [ "$1" = "runs" ]; then
	bash "${DIR}/fetcher.sh"
fi

if [ "$1" = "pulls" ]; then
	bash "${DIR}/pulls.sh"
fi

