locals {
  config_set = { for name, value in var.config : value.org_name => value }

  stacks = flatten([
    for config_key, config_value in local.config_set : [
      for folder_key, folder_value in config_value.folders : [
        for file in fileset(folder_key, "**/stack.tm.hcl") : {
          file_name     = file
          org_name      = config_key
          folder_key    = folder_key
          config_key    = config_key
          full_path     = dirname(format("%s/%s", folder_key, file))
          stack_env     = reverse(split("/", folder_key))[0]
          stack_purpose = split("/", file)[0]
          stack_name    = format("%s-%s",
            reverse(split("/", folder_key))[0],
            reverse(split("/", dirname(file)))[0]
          )
        }
      ]
    ]
  ])
}


output "test_var" {
  value = path.module
}


data "tfe_organization" "org_name" {
  for_each = local.config_set
  name     = each.value.org_name
}

data "tfe_oauth_client" "client" {
  for_each         = local.config_set
  service_provider = "ado_services"
  organization     = each.key
}


resource "tfe_workspace" "workspace" {
  for_each          = { for item_key, item_value in local.stacks : "${item_value.org_name}:${item_value.stack_name}" => item_value }
  organization      = data.tfe_organization.org_name[each.value.org_name].name
  name              = each.value.stack_name
  working_directory = replace(each.value.full_path, "../", "")
  auto_apply        = true
  vcs_repo {
    identifier     = var.vcs_config.vcs_identifier
    oauth_token_id = data.tfe_oauth_client.client[each.value.org_name].oauth_token_id
  }
}



