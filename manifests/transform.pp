# vector::transform
#
# @summary
#   Creates a Vector transform
#
# @param type
#   Transform type. Consult vector documentation for available types.
# @param inputs
#   Array of inputs (source or transform)
# @param parameters
#   Hash of additional parameters for this source (besides type and inputs)
# @param format
#   File format to save as, default toml
# @param condition
#   Condition to apply to the transform
define vector::transform (
  String                    $type,
  Array[String]             $inputs,
  Vector::ValidConfigFormat $format     = 'toml',
  Optional[Hash]            $condition  = undef,
  Optional[Hash]            $parameters = undef,
) {
  # $transform_hash = {
  #   'transforms' => {
  #     $title => $parameters + { 'type' => $type, 'inputs' => $inputs },
  #   },
  # }

  if $type == 'filter' {
    $transform_hash = { 'type' => $type, 'inputs' => $inputs, 'condition' => $condition }
  } else {
    $transform_hash = $parameters + { 'type' => $type, 'inputs' => $inputs }
  }

  $transform_file_name = "${vector::setup::transforms_dir}/${title}.${format}"

  file { $transform_file_name:
    ensure  => file,
    content => vector::dump_config($transform_hash, $format),
    mode    => '0644',
  }
}
