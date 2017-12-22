#!/usr/bin/env escript
%% -*- erlang -*-

%% * slurp in terms using inlined version of kernels file:consult/1
%% * convert to abstract syntax tree
%% * annotate all tuples
%% * pretty print using a hook to prefix the annotated nodes with newline

main([]) ->
    io:format("%% -*-erlang-*-~n"),
    {ok, Terms} = consult_stream(),
    [pretty_term(Term) || Term <- Terms],
    ok.

pretty_term(Term) ->
    Abstract = erl_syntax:abstract(Term),
    AnnF = fun(Node) -> annotate_tuple(Node) end,
    AnnAbstract = postorder(AnnF, Abstract),
    HookF = fun(Node, Ctxt, Cont) ->
                    Doc = Cont(Node, Ctxt),
                    prettypr:above(prettypr:empty(), Doc)
            end,
    Io = erl_prettypr:format(AnnAbstract, [{hook, HookF}]),
    io:put_chars(Io),
    io:format(".~n").

annotate_tuple(Node) ->
    case erl_syntax:type(Node) of
        tuple -> erl_syntax:add_ann(tuple, Node);
        _ -> Node
    end.

%% from the erl_syntax manpage
postorder(F, Tree) ->
    F(case erl_syntax:subtrees(Tree) of
          [] -> Tree;
          List -> erl_syntax:update_tree(Tree,
                                         [[postorder(F, Subtree)
                                           || Subtree <- Group]
                                          || Group <- List])
      end).

%% specialized from kernel/file.erl
consult_stream() -> consult_stream([]).
consult_stream(Acc) ->
    case io:read('') of
        {ok, Term}     -> consult_stream([Term|Acc]);
        {error, Error} -> {error, Error};
        eof            -> {ok, lists:reverse(Acc)}
    end.
