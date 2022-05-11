
resource "aws_key_pair" "ssh-key" {  
  key_name   = "aws_key"
  public_key = file("./keys/circleci.pub")
}
