# misc commands that parse external tool output into Nushell structures.

def "rails routes" [] {
  ^rails routes | detect columns --guess
}

def "terraform output" [] {
  ^terraform output -json | from json
}
