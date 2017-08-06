;;;; src/unfuck.ls
;;; JsFuck decoder.

((function ()
  (var jsfuck (require 'jsfuck')
       encode jsfuck.JSFuck.encode)
       
  ;; TODO: Add more possible patterns.

  ;; Elements that should fucked by jsfuck.
  (var CHARS
   ['false', 'true', 'undefined', 'NaN', 'Infinity',
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
    ' ', '!', "'", "\"", '#', '$', '%', '&', '\\', '(', ')', '*', '+', ',', '-', '.', '/', ':', ';', '<', '=',
    '>', '?', '@', '[', '\\', ']', '^', '_', '`', '{', '|', '}', '~'])
    
  (var NUMBERS
   ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'])

  (var MAPPING
   ;; Storage for real patterns.
   [])

  (var makePattern
   (function (pattern)
    (var escaped (pattern.replace /(\(|\)|\[|\]|\!|\+)/g '\\$1'))
    (+ escaped '\\+?')))

  (var fillDigits
   (function ()
    (each NUMBERS
     (function (source index list)
      (var encoded (encode source false)
           pattern (makePattern (encoded.replace /\+\[\]$/ '')))
      (MAPPING.push [source, pattern])))))

  (var fillChars
   (function ()
    (each CHARS
     (function (source index list)
      (var encoded (encode source false)
           pattern (makePattern encoded))
      (MAPPING.push [source, pattern])))))

  (var initPatterns
   (function ()
    (fillDigits)
    (fillChars)
    (MAPPING.sort (function (a b) (- b[1].length a[1].length)))))

  ;; Decode jsfucked input string to normal js.
  ;; Static pattern definition is not necessary here, just simply run jsfuck
  ;; itself to find the patterns exactly same as jsfuck it does.
  ;;
  ;; This could be slower than solid pattern matching.
  (var decode
   (function (fucked pretty)
    (var output fucked)
    (each MAPPING
     (function (m)
      (var pattern (new RegExp m[1] 'g'))
      (set output (output.replace pattern m[0]))))
    (if pretty
     (do
      (var beautify (require 'js-beautify'))
      (beautify.js_beautify output {indent_size: 2}))
     output)))

  (initPatterns)

  ;; Exports
  (set module.exports decode)
))