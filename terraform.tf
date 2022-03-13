#################
#   TERRAFORM   #
#################

terraform {
  required_version = "~> 1.0"

  cloud {
    organization = "brutalismbot"

    workspaces { name = "functions" }
  }

  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

###########
#   AWS   #
###########

provider "aws" {
  region = "us-west-2"
  assume_role { role_arn = var.AWS_ROLE_ARN }
  default_tags { tags = local.tags }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

#################
#   VARIABLES   #
#################

variable "AWS_ROLE_ARN" {}
variable "MAIL_TO" {}

##############
#   LOCALS   #
##############

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name

  tags = {
    App  = "Brutalismbot"
    Name = "Brutalismbot"
    Repo = "https://github.com/brutalismbot/functions"
  }
}

###############
#   MODULES   #
###############

module "api_slack" { source = "./functions/api-slack" }

module "api_slack_beta" { source = "./functions/api-slack-beta" }

module "array" { source = "./functions/array" }

module "http" { source = "./functions/http" }

module "mail" {
  source  = "./functions/mail"
  MAIL_TO = var.MAIL_TO
}

module "slack_transform" { source = "./functions/slack-transform" }

module "reddit_dequeue" { source = "./functions/reddit-dequeue" }

module "twitter_post" { source = "./functions/twitter-post" }

module "twitter_transform" { source = "./functions/twitter-transform" }

###############
#   OUTPUTS   #
###############

output "functions" {
  value = {
    api_slack         = { arn = module.api_slack.lambda_function.arn }
    api_slack_beta    = { arn = module.api_slack_beta.lambda_function.arn }
    array             = { arn = module.array.lambda_function.arn }
    http              = { arn = module.http.lambda_function.arn }
    mail              = { arn = module.mail.lambda_function.arn }
    reddit_dequeue    = { arn = module.reddit_dequeue.lambda_function.arn }
    slack_transform   = { arn = module.slack_transform.lambda_function.arn }
    twitter_post      = { arn = module.twitter_post.lambda_function.arn }
    twitter_transform = { arn = module.twitter_transform.lambda_function.arn }
  }
}

output "roles" {
  value = {
    api_slack         = { arn = module.api_slack.iam_role.arn }
    api_slack_beta    = { arn = module.api_slack_beta.iam_role.arn }
    array             = { arn = module.array.iam_role.arn }
    http              = { arn = module.http.iam_role.arn }
    mail              = { arn = module.mail.iam_role.arn }
    reddit_dequeue    = { arn = module.reddit_dequeue.iam_role.arn }
    slack_transform   = { arn = module.slack_transform.iam_role.arn }
    twitter_post      = { arn = module.twitter_post.iam_role.arn }
    twitter_transform = { arn = module.twitter_transform.iam_role.arn }
  }
}
