(define (script-fu-meme img
                             drawable
                             thickness
                             keep-border-layer)

  (let* (
        (index 1)
        (greyness 0)
        (thickness (abs thickness))
        (oversize (* thickness 2))
        (type (car (gimp-drawable-type-with-alpha drawable)))
        (image img)
        (pic-layer (car (gimp-image-get-active-drawable image)))
        (offsets (gimp-drawable-offsets pic-layer))
        (width (car (gimp-drawable-width pic-layer)))
        (height (car (gimp-drawable-height pic-layer)))

        ; Bumpmap has a one pixel border on each side
        (border-layer (car (gimp-layer-new image
                                         (+ width oversize) ; make twice as big as border, so we're just "$thickness" over both edges
                                         (+ height oversize)
                                         RGB-IMAGE
                                         _"Meme Border"
                                         100
                                         LAYER-MODE-NORMAL)))

        (selection-exists (car (gimp-selection-bounds image)))
        (selection 0)
        )

    (gimp-context-push)
    (gimp-context-set-defaults)

    ; start undo group
    (gimp-image-undo-group-start image)
    
    ; check if text, otherwise bail
    (if (not (gimp-item-is-text-layer pic-layer))
      (gimp-message "Not a text layer") ; bail
    )

    ; set font "Impact Condensed"
    ; set font-size 86
    ; set font-color #fffff
    ; "path from text"
    ; select from path
    ; select grow 4pt
    ; create layer with size of picture, name "BG <layer>"
    ; fill selection black
    ; move below text

    (gimp-image-insert-layer image border-layer 0 1)

    ; If the layer we're bevelling is offset from the image's origin, we
    ; have to do the same to the bumpmap
    (gimp-layer-set-offsets border-layer (- (car offsets) thickness)
                                       (- (cadr offsets) thickness))

    ;------------------------------------------------------------
    ;
    ; Restore things
    ;
    (if (= selection-exists 0)
        (gimp-selection-none image)        ; No selection to start with
        (gimp-image-select-item image CHANNEL-OP-REPLACE selection)
    )
    ; If they started with a selection, they can Select->Invert then
    ; Edit->Clear for a cutout.

    ; clean up
    (gimp-image-remove-channel image selection)
    (if (= keep-border-layer TRUE)
        (gimp-item-set-visible border-layer 0)
        (gimp-image-remove-layer image border-layer)
    )

    (gimp-image-set-active-layer image pic-layer)

    ; end undo group
    (gimp-image-undo-group-end image)

    (gimp-displays-flush)

    (gimp-context-pop)
  )
)

(script-fu-register "script-fu-meme"
  _"MemeFu"
  _"Apply the impact condensed font as well as the typical meme border to a text field"
  "Maciej Krüger <mkg20001@gmail.com>"
  "Maciej Krüger"
  "2019"
  "RGB*"
  SF-IMAGE       "Image"           0
  SF-DRAWABLE    "Drawable"        0
  SF-ADJUSTMENT _"Border-Thickness"       '(4 0 30 1 2 0 0)
  SF-TOGGLE     _"Keep border layer" FALSE
)

(script-fu-menu-register "script-fu-meme" "<Image>/Filters/Render")
