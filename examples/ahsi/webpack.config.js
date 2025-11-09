let
  _file_name,
  _output,
  _output_dir,
  _path;
_path =
  require(
    'path');
_output_dir =
  _path.resolve(
    __dirname);
_file_name =
  "ahsi.js";

_output = {
  path:
    _output_dir,
  filename:
    _file_name
}

module.exports = {
  entry:
    './ahsi',
  output:
    _output,
  },
};
