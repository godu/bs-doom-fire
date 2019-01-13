open Tea
open Chess

type model =
  { position : position
  ; orientation: color
  }

type msg =
  | Flip_board
  | Random_button
  | Random_move of move

let init () =
  { position = init_position
  ; orientation = White
  }, Cmd.none

let update model = function
  | Flip_board ->
    { model with
      orientation = opposite_color model.orientation },
    Cmd.none
  | _ -> model, Cmd.none

let board_view model =
  let open Html in
  let files, ranks =
    match model.orientation with
    | White -> [0; 1; 2; 3; 4; 5; 6; 7], [7; 6; 5; 4; 3; 2; 1; 0]
    | Black -> [7; 6; 5; 4; 3; 2; 1; 0], [0; 1; 2; 3; 4; 5; 6; 7] in

  let rank_view rank =

    let square_view rank file =
      let piece_view =
        match model.position.ar.(file).(rank) with
        | Piece (piece_type, color) ->
          node "cb-piece"
            [ classList
                [ string_of_color color, true
                ; string_of_piece_type piece_type, true
                ]
            ] []
        | Empty -> noNode in
      node "cb-square" [] [piece_view] in

    List.map (square_view rank) files
    |> node "cb-row" [] in

  List.map rank_view ranks
  |> node "cb-board" []

let view model =
  let open Html in
  div []
    [ board_view model
    ; p [] [ Printf.sprintf "Move %d.  It is %s's move."
               model.position.number
               (match model.position.turn with | Black -> "Black"
                                               | White -> "White")
             |> text
           ]
    ; p [] [ button
               [ onClick Flip_board ]
               [ text "Flip board" ]
           ; button
               [ onClick Random_button ]
               [ text "Make a random move!" ]
           ]
    ]

let main =
  App.standardProgram
    { init
    ; update
    ; view
    ; subscriptions = (fun _ -> Sub.none)
    }
