#!/usr/bin/env fish

argparse --name=rasmus-trix 'c/credentials=' 's/store=' 'f/folder=' 'r/room=' 'u/user=' -- $argv
or return
set mc_args --credentials $_flag_c --store $_flag_s

while true
    for message in $(matrix-commander $mc_args --listen once --output json-spec)
        set sender $(echo $message | jq --raw-output ".sender")
        set room $(echo $message | jq --raw-output ".room_id")
        set type $(echo $message | jq --raw-output ".type")
        if test "$sender" = "$_flag_u"
            if test "$room" = "$_flag_r"
                if test "$type" = "m.room.message"
                    set body $(echo $message | jq --raw-output ".content | .body")
                    if string match --quiet --regex '^[a-zA-Z0-9]+$' $body
                        set command "$_flag_f/$body"
                        if test -f "$command"
                            $command | matrix-commander $mc_args -m -
                        else
                            matrix-commander $mc_args -m "Could not find any command $body"
                        end
                    else
                        matrix-commander $mc_args -m "Could not find any command $body"
                    end
                end
            end
        end
    end
end
