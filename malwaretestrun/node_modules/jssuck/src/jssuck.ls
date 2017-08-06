;;;; src/jssuck.ls
;;; Main script of JSSuck.

((function ()
  (var path (require 'path')
       fs (require 'fs')
       decode (require './unfuck.js')
       encode (require './fuck.js'))

  (var print_or_save
   (function (data filepath pretty save fuck_or_unfuck)
    (if save
     (do
      (var dirname (path.dirname filepath)
           basename (path.basename filepath '.js')
           extname (path.extname filepath)
           newpath (+ dirname '/' basename '.' fuck_or_unfuck extname))
      (fs.writeFile newpath data
       (function (err)
        (console.log (+ 'Writing ' newpath))
        (when err
         (console.error (+ "ERROR: Couldn't save " newpath '\n'))))))
     (do
      (console.log data)
      (console.log '\n')))))

  (var autorun
   (function (argv)
    (when (< argv.length 3)
     (var message (+ "Usage: jssuck [OPTION]... [FILE]...\n\n"
                   "JSSuck takes multiple files and both directions at once.\n"
                   "Just put the files that you want to do encode or decode.\n\n"
                   "Encoding:\n"
                   "  -1: Process jsfuck [DEFAULT]\n"
                   "  -2: Process uglified jsfuck.\n"
                   "Decoding:\n"
                   "  -p: Enable pretty print. This option is unactivated in default.\n"
                   "Output:\n"
                   "-s: Store the result in each files. Default is stdout."))
     (console.error message)
     (process.exit -2))
     
    ;; Parse options
    (var options {pretty: false, lv1: true, lv2: false, save: false, files: []})
    (argv.shift) (argv.shift)
    (each argv
     (function (arg index list)
      (cond (= '-1' arg) (set options['lv1'] true)
            (= '-2' arg) (set options['lv2'] true)
            (= '-p' arg) (set options['pretty'] true)
            (= '-s' arg) (set options['save'] true)
            true (do
                  (var stat (fs.statSync arg))
                  (when (stat.isFile)
                   (options['files'].push arg))))))

    (each options['files']
     (function (file index list)
      (var data (fs.readFileSync(file, 'utf8')))
      (if (= -1 (-> (data.replace /\s+/g '') (.search /[^()\[\]+!]/)))
       (print_or_save
        (decode data options['pretty'])
        file options['pretty'] options['save'] 'unfuck')
       (print_or_save
        (encode data (= options['lv1'] options['lv2']))
        file false options['save'] 'fuck'))))))

  (var jssuck
   {encode: encode,
    decode: decode,
    autorun: autorun})
  (set module.exports jssuck)))