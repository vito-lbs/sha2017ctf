module.exports = function (grunt) {
    'use strict';
    require('shelljs/global');
    const path = require('path');
    
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json')
    });

    grunt.registerTask('lispy', 'Compile lispyscript.', function () {
       let scripts = grunt.file.expand('./src/*.ls'),
           outDir = './lib';
       scripts.forEach(f => {
           let basename = path.basename(f, '.ls'),
               output = [outDir, basename + '.js'].join('/'),
               command = ['lispy', f, output].join(' ');
           exec(command, {silent: false});
       });
    });
    grunt.registerTask('default', 'lispy');
}