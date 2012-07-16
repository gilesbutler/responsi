var argv = process.argv.slice(2);
var hem = require('hem-haml-coffee');
hem.compilers.less = require('hem-less').compiler;
hem.exec(argv[0]);