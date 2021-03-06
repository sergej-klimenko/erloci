
-define(CONN_CONF,
(fun() ->
         case file:get_cwd() of
             {ok, Cwd} ->
                 ConnectConfigFile =
                 filename:join(
                   lists:reverse(
                     ["connect.config", "test"
                      | case lists:reverse(filename:split(Cwd)) of
                            [".eunit" | Rest] -> Rest;
                            Error ->
                                ?ELog("~p", [Error]),
                                error(Error)
                        end])),
                 case file:consult(ConnectConfigFile) of
                     {ok, Params} ->
                         {proplists:get_value(tns, Params),
                          proplists:get_value(user, Params),
                          proplists:get_value(password, Params)};
                     {error, Reason} ->
                         ?ELog("~p", [Reason]),
                         error(Reason)
                 end;
             {error, Reason} ->
                 ?ELog("~p", [Reason]),
                 error(Reason)
         end
 end)()).

-ifdef(debugFmt).
    -define(ELog(__Fmt,__Args),
    (fun(__F,__A) ->
        {_,_,__McS} = __Now = erlang:now(),
        {_,{_,__Min,__S}} = calendar:now_to_datetime(__Now),
        ok = ?debugFmt("~2..0B:~2..0B.~6..0B "++__F, [__Min,__S,__McS rem 1000000 | __A])
    end)(__Fmt,__Args)).
-else.
    -define(ELog(__Fmt,__Args),
    (fun(__A) ->
        {_,_,__McS} = __Now = erlang:now(),
        {_,{_,__Min,__S}} = calendar:now_to_datetime(__Now),
        io:format(user, "~2..0B:~2..0B.~6..0B "__Fmt"~n", [__Min,__S,__McS rem 1000000 | __A])
    end)(__Args)).
-endif.

-define(ELog(__F), ?ELog(__F,[])).
