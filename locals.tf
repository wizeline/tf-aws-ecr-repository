locals {
  // Get the sub levels to monitor given a starting level
  severity_levels = [
    "LOW",
    "MEDIUM",
    "HIGH",
    "CRITICAL"
  ]
  starting_index      = index(local.severity_levels, var.image_severity_level)
  sub_severity_levels = slice(local.severity_levels, local.starting_index, length(local.severity_levels))

  // Define event_targets map from the cartesian product of severity levels and ARNs.
  event_targets = {
    for pair in setproduct(var.sns_topics_arns, local.sub_severity_levels) : "${pair[0]}.${pair[1]}" => {
      arn   = pair[0]
      level = pair[1]
    }
  }
}
