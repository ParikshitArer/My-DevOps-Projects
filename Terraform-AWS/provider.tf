provider "aws" {
  region = "ap-south-1"
  alias  = "primary"
}

provider "aws" {

  region = "ap-southeast-1"
  alias  = "secondary"

}
