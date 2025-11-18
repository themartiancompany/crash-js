const
  _path =
    require(
      'path');
const
  _output_dir =
    _path.resolve(
      __dirname);
const
  _input_file_name =
    "crash-js";
const
  _output_file_name =
    `${_input_file_name}.js`;
const
  _output =
  { path:
      _output_dir,
    filename:
      _output_file_name };
module.exports = {
  entry:
    `./${_input_file_name}`,
  output:
    _output,
  optimization: {
    moduleIds: 'deterministic',
  },
  resolve: {
    fallback: {
      "fs":
        _path.resolve(
          __dirname,
          'node_modules/@themartiancompany/fs/fs'),
      "path":
        _path.resolve(
          __dirname,
          'node_modules/path/mod.js'),
      "web-worker":
        false
    },
  },
};
