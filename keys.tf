# Public key to use as an authorized key in the instances
# that we provision such that we can SSH into them if needed.
resource "aws_key_pair" "mainkey" {  
  key_name   = "aws_key"
  public_key = file("./keys/circleci.pub")
}
