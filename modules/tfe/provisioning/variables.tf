variable "config" {
  description = <<EOT
    This will create the config object and store it for use the parameters are as follows
    
    **org_name**: Org name is the desired name of for the organization, all workspaces discovered will be created here
    **folders**: These are the folders to add as workspaces to the projects organization
    **agent_id**: This is the agent that we will use to run the plan and applies
    **variable_sets**: These are the variable sets that are already configured for use
    **admins**: These are the admins to add to the team
  EOT
  type = list(object({
    org_name      = string
    folders       = set(string)
    agent_id      = string
    variable_sets = set(string)
    admins        = set(string)
  }))
}

variable "vcs_config" {
  description = <<EOT
    This will create the `vcs_config` to use with the workspaces

    **vcs_identifier**: The identifier to use for all discovered workspaces.  
  EOT
  type = object({
    vcs_identifier = string
  })
}

