locals {
  #Reads dataform.json file
  dataform_config = jsondecode(file(var.dataform_params))

  /* Create datasets defined via dataform.json variables if any, it should include 3 variables for each dataset with next format:
      "dataset_id_<DATASET_IDENTIFIER>":"<YOUR_DATASET_NAME>",
      "dataset_projectid_<DATASET_IDENTIFIER>":"<YOUR_DATASET_PROJECT>",
      "dataset_location_<DATASET_IDENTIFIER>":"<YOUR_DATASET_LOCATION>",
  */
  variables = ({
    for k, v in local.dataform_config.vars : split("_", k)[2] => {
      (split("_", k)[1]) = v
    }...
    if substr(k, 0, 8) == "dataset_"
  })
  datasets = {
    for dataset_name, attribute_list in local.variables : dataset_name => merge(attribute_list...)
  }

  connection_name = ([
    for k, v in local.dataform_config.vars :  v
    if k == "connection_name"
  ])

}