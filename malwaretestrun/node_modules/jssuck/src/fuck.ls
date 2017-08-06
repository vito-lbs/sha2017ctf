;;;; src/fuck.ls
;;; JsFuck encoder.

((function ()
  (var jsfuck (require 'jsfuck')
       fuckcode jsfuck.JSFuck.encode)

  (var encode
   (function (data ugly)
    (if ugly
     (do
      (var uglify (require 'uglify-js')
           uglified (uglify.minify data {fromString: true}))
      (fuckcode uglified.code false))
     (fuckcode data false))))

  ;; Exports
  (set module.exports encode)
))