# git commands that return structured data instead of text.

def "git histogram" [n: int = 50] {
  ^git log --pretty=%h»¦«%aN»¦«%s»¦«%aD -n $n | lines | split column "»¦«" sha1 committer desc merged_at | histogram committer merger | sort-by merger | reverse
}

def "git log" [n: int = 50] {
  ^git log --pretty=%h»¦«%s»¦«%aN»¦«%aE»¦«%aD -n $n | lines | split column "»¦«" commit subject name email date | upsert date {|d| $d.date | into datetime}
}

def "git reflog" [n: int = 50] {
  ^git reflog -n $n | parse "{commit} {branch}: {action}: {description}"
}
