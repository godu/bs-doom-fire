open Webapi.Canvas.CanvasElement
open Webapi.Canvas.Canvas2d
open Webapi.Dom

let main root =
  let canvas = root |> getContext2d in
  let color = canvas
    |> getImageData 
      ~sx:0.
      ~sy:0.
      ~sw:(Webapi.Dom.Element.clientWidth root |> float_of_int)
      ~sh:(Webapi.Dom.Element.clientHeight root |> float_of_int) in
  
  let data = Image.data color in

  Js_typed_array.Uint8ClampedArray.setArrayOffset
