(define (FU-meme
    img
    drawable
    merge-flag)
    
  ; get current layer
  ;(define image (gimp-image-get-active-drawable))
  ;(define layer (gimp-image-get-active-layer image))   

  ; check if text, otherwise bail
  (if (not (gimp-item-is-text-layer drawable))
    (gimp-message "Not a text layer")) ; throw

  ; set font "Impact Condensed"
  ; set font-size 86
  ; set font-color #fffff
  ; "path from text"
  ; select from path
  ; select grow 4pt
  ; create layer with size of picture, name "BG <layer>"
  ; fill selection black
  ; move below text
)
(script-fu-register "FU-meme"
    "<Image>/Script-Fu/Artistic/Meme"
    "Make the text layer use a meme-font style (Impact Condensed + Background)"
    "Maciej Krüger"
    "Maciej Krüger"
    "2019"
    "*"
    SF-IMAGE    "Image"         0
    SF-DRAWABLE "Current Layer" 0
)
