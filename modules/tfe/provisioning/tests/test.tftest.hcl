variables {
  config = [
    {
      org_name = "devtest-org-product"
      folders = ["./../../../modules/tfe/provisioning/devtest/dev", "./devtest/qa"]
      agent_id = "some-agent-id"
      variable_sets = ["some-variable-set"]
      admins = []
    },
    {
      org_name = "prod-org-product"
      folders = ["./devtest/prod"]
      agent_id = "some-other-agent-id"
      variable_sets = ["prod-variable-set"]
      admins = ["email1@org.net", "email2@org.net", "email3@org.net"]
    }
  ]
  
  vcs_config = {
    vcs_identifier = "org/Infrastructure/_git/infrastructure"
  }
  imports = { workspaces = {}}
  
  
}

run "setup" {
  command = plan
  variables {
    config = var.config
    vcs_config = var.vcs_config
    imports = var.imports
  }
  module {
    source = "./../provisioning"
  
  }
  
  assert {
    condition =  length(data.tfe_organization.org_name) > 0
    error_message = "Check to make sure that the syntax is correct"
  }
  
  assert {
    condition = length(local.stacks) == 3
    error_message = "Stacks shoudl be equal to 2"
  }
}


provider "tfe" {
  
}
