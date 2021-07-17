resource "tfe_workspace" "workspace" {
  for_each = toset(local.projects)
  name         = each.value
  organization = "tecnoly"
  auto_apply   = true
}
