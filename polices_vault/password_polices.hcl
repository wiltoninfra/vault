length = 20
rule "charset" {
  charset = "abcdefghijklmnopqrstuvwxyz"
}

length = 20
rule "charset" {
  charset = "abcdefghijklmnopqrstuvwxyz"
  min-chars = 1
}
rule "charset" {
  charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  min-chars = 1
}
rule "charset" {
  charset = "0123456789"
  min-chars = 1
}
rule "charset" {
  charset = "!@#$%^&*"
  min-chars = 1
}

length = 20
rule "charset" {
  charset = "abcde"
  min-chars = 1
}
rule "charset" {
  charset = "01234"
  min-chars = 1
}

length = 8
rule "charset" {
  charset = "abcde"
}
rule "charset" {
  charset = "01234"
  min-chars = 1
}

Ian Buchanan 
Engineer for DevOps at Atlassian 
https://www.atlassian.com/br/agile/devops