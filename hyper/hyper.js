"use strict";
// Future versions of Hyper may add additional config options,
// which will not automatically be merged into this file.
// See https://hyper.is//cfg for all currently supported options.
module.exports = {
    config: {
      updateChannel: 'canary',
      // omit or set true to show. set false to remove it
      wickedBorder: true,
      // change the colour here
      wickedBorderColor: '#ffc600',
      shell: '/bin/zsh',
      // Powerline fonts:
      fontFamily: '"Operator Mono", "Inconsolata for Powerline", monospace'
    },
    plugins: [
      'hyperterm-cobalt2-theme'
    ],
    // in development, you can create a directory under
    // `~/.hyper_plugins/local/` and include it here
    // to load it and avoid it being `npm install`ed
    localPlugins: [],

};
//// sourceMappingURL=config-default.js.map
