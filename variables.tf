
variable "regions"{
  type=list(string)
}

variable "az"{
  type = list(string)
}

variable "cidr_blocks"{
  type = list(object({
    cidr_block = string
    name = string
  }))
}

/* variable env_prefix{} */

variable myip_ubuntu{}
variable instance_type{}
variable public_key_location{}
variable key_location{}
variable entry_script{}

variable EC2_PVT_KEY{}