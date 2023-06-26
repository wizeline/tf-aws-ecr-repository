locals {
  severity_levels = [
    "LOW",
    "MEDIUM",
    "HIGH",
    "CRITICAL"
  ]
  starting_index      = index(local.severity_levels, var.image_severity_level)
  sub_severity_levels = slice(local.severity_levels, local.starting_index, length(local.severity_levels))
}
