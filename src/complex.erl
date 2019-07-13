-module(complex).
-compile(export_all).
-include("primitives.hrl").
-include("complex.hrl").
%%
%% API exports
%%-export([]).
%%
-export_type([decimal/0,uri/0,url/0,canonical/0,base64Binary/0]).
-export_type([instant/0,date/0,dateTime/0,yearMonth/0,year/0,dow/0,time/0]).
-export_type([code/0,oid/0,id/0,markdown/0,positiveInt/0,unsignedInt/0,uuid/0,ucum/0]).
-export_type([coding/0,codeableConcept/0]).
-export_type([fhir_identifier/0,reference_/0]).
-export_type([humanName/0,address/0,contactPoint/0]).
-export_type([relatedArtifact/0,attachment/0]).
-export_type([quantity/0,range/0,ratio/0]).
-export_type([period/0,repeat/0,timing/0]).
-export_type([annotation/0,signature/0]).
-export_type([narrative/0]).
-export_type([meta/0]).


-record(coding, {
      system       :: uri()
    , version      :: binary()
    , code         :: binary()
    , display      :: binary()
    , userSelected :: boolean()
    }).
-opaque coding() :: #coding{}.


-record(codeableConcept, {
      coding       :: [coding()]      %% Coding Code defined by a terminology system
    , text         :: binary()        %% Plain text representation of the concept
}).
-opaque codeableConcept() :: #codeableConcept{}.


-record(identifier, {
       use = <<"official">> :: binary()    %% usual | official | temp | secondary 
     , type           :: codeableConcept() %% Description of fhir_identifier
     , system         :: uri()             %% The namespace for the fhir_identifier
     , value          :: binary()          %% The value that is unique
     , period         :: period()          %% Time period when id is/was valid for use
     , assigner       :: reference_()             %% Organization that issued id (may be just text)
}).
-opaque fhir_identifier()   :: #identifier{}.

-record(period, {
       start_      :: dateTime()
     , end_        :: dateTime()
}).
-opaque period() :: #period{}.

-record(reference, {
       reference_ :: binary()
     , display   :: binary()
}).
-opaque reference_()    :: #reference{}.

-record(humanName, {
       use       = <<"official">>   :: binary()  %% usual | official | temp | nickname | anonymous | old | maiden
     , text                   :: binary()
     , family                 :: [binary()]
     , given                  :: [binary()]
     , prefix                 :: [binary()]
     , suffix                 :: [binary()]
     , period                 :: period()
}).
-opaque humanName() :: #humanName{}.


-record(address, {
       use                    :: binary()     %% home | work | temp | old
     , type                   :: binary()     %% postal | physical | both
     , text                   :: binary()
     , line                   :: [binary()]
     , city                   :: binary()
     , district               :: binary()
     , state                  :: binary()
     , postalCode             :: binary()
     , country                :: binary()
     , period                 :: period()
}).
-opaque address() :: #address{}.


-record(contactPoint, {
      use                    :: binary()     %% home | work | temp | old | mobile
    , system                 :: binary()     %% phone | fax | email | pager | other
    , value                  :: binary()
    , rank                   :: non_neg_integer()
    , period                 :: period()
}).
-opaque contactPoint() :: #contactPoint{}.


-record(relatedArtifact, {
     type :: binary()
    , display :: binary()
    , citation :: binary()
    , url :: binary()
    , document :: attachment()
    , resource :: reference_()
    }).
-opaque relatedArtifact() :: #relatedArtifact{}.


-record(attachment, { 
      contentType :: binary()
    , language :: binary()
    , data :: base64Binary()
    , url :: binary()
    , size :: integer()
    , hash :: base64Binary()
    , title :: binary()
    , creation :: date()
    }).
-opaque attachment() :: #attachment{}.


-record(quantity, {
      value :: float()
    , comparator :: binary()
    , unit :: binary()
    , system :: binary()
    , code :: binary()
    }).
-opaque quantity() :: #quantity{}.


-record(range, {
      low :: quantity()
    , high :: quantity()
    }).
-opaque range() :: #range{}.


-record(ratio, {
      numerator :: quantity()
    , denominator :: quantity()
    }).
-opaque ratio() :: #ratio{}.


-record(timing, {
      event :: [binary()]
    , repeat :: repeat()
    , code :: codeableConcept()
    }).
-opaque timing() :: #timing{}.


-record(repeat, {
      boundsPeriod :: period()
    , count :: integer()
    , countMax :: integer()
    , duration :: float()
    , durationMax :: float()
    , durationUnit :: ucum()
    , frequency :: integer()
    , frequencyMax :: integer()
    , period :: float()
    , periodMax :: float()
    , periodUnit :: binary()
    , dayOfWeek :: [binary()]
    , timeOfDay :: [binary()]
    , when_ :: [binary()]
    , offset :: integer()
    }).
-opaque repeat() :: #repeat{}.


-record(annotation, {
      authorReference :: reference_()
    , time :: date()
    , text :: binary()
    }).
-type annotation() :: #annotation{}.


-record(signature, {
      type :: [coding]
    , when_ :: binary()
    , whoReference :: reference_()
    , onBehalfOfReference :: reference_()
    , contentType :: binary()
    , blob :: base64Binary()
    }).
-opaque signature() :: #signature{}.


%%
%%   - Special Datatypes
%%


-record(narrative, {
      status :: binary()
    , div_ :: binary()
    }).
-opaque narrative() :: #narrative{}.


-record(meta, {
       versionId = 0 :: positiveInt()
     , lastUpdated   :: dateTime()
     , source        :: binary()
     , profile       :: [uri()]
     , security      :: [coding()]
     , tag           :: [coding()]
     , extension     :: [extensions:extension()]
}).
-opaque meta()   :: #meta{}.


%%====================================================================
%% API functions
%%====================================================================
to_reference_list(Key, Props) ->
    List = proplists:get_value(Key, Props),
    case List of
        undefined -> [];
        _         -> lists:map(fun to_reference/1,List)
    end.

to_reference(Key, Props) ->
    RefProps = proplists:get_value(Key, Props),
    case RefProps of
        undefined -> undefined;
        _         -> to_reference(RefProps)
    end.

to_reference({Props}) -> to_reference(Props);
to_reference(Props) ->
    DT = maps:get(<<"reference">>,?ct_info),
    io:format("~p~n~p~n",[Props,DT]),
    #reference{
        reference_ = proplists:get_value(<<"reference">>, Props)
      , display    = proplists:get_value(<<"display">>, Props)
      }.

to_humanName_list(Key, Props) ->
    List = proplists:get_value(Key, Props),
    case List of
        undefined -> [];
        _         -> lists:map(fun to_humanName/1,List)
    end.

to_humanName({Props}) -> to_humanName(Props);
to_humanName(Props) ->
    DT = maps:get(<<"humanName">>,?ct_info),
    io:format("~p~n~p~n",[Props,DT]),
    #humanName{
       use     = get_value(<<"use">>, Props, DT) 
     , text    = get_value(<<"text">>, Props, DT) 
     , family  = get_value(<<"family">>, Props, DT) 
     , given   = get_value(<<"given">>, Props, DT) 
     , prefix  = get_value(<<"prefix">>, Props, DT) 
     , suffix  = get_value(<<"suffix">>, Props, DT) 
     , period  = get_value(<<"period">>, Props, DT)
    }.

to_address_list(Key, Props) ->
    List = proplists:get_value(Key, Props),
    case List of
        undefined -> [];
        _         -> lists:map(fun to_address/1,List)
    end.

to_address({Props}) -> to_address(Props);
to_address(Props) -> 
    DT = maps:get(<<"address">>,?ct_info),
    io:format("~p~n~p~n",[Props,DT]),
    #address{
      use        = proplists:get_value(<<"use">>, Props) 
    , type       = proplists:get_value(<<"type">>, Props) 
    , text       = proplists:get_value(<<"text">>, Props) 
    , line       = get_value(<<"line">>, Props, [])
    , city       = proplists:get_value(<<"city">>, Props) 
    , district   = proplists:get_value(<<"distrinct">>, Props) 
    , state      = proplists:get_value(<<"state">>, Props) 
    , postalCode = proplists:get_value(<<"postalCode">>, Props) 
    , country    = proplists:get_value(<<"country">>, Props) 
    , period     = to_period(<<"period">>, Props)
    }.

to_contactPoint_list(Key, Props) ->
    List = proplists:get_value(Key, Props),
    case List of
        undefined -> [];
        _         -> lists:map(fun to_contactPoint/1,List)
    end.

to_contactPoint({Props}) -> to_contactPoint(Props);
to_contactPoint(Props) -> 
    DT = maps:get(<<"contactPoint">>,?ct_info),
    io:format("~p~n~p~n",[Props,DT]),
    #contactPoint{
      use    = proplists:get_value(<<"use">>, Props)
    , system = proplists:get_value(<<"system">>, Props)
    , value  = proplists:get_value(<<"value">>, Props)
    , rank   = proplists:get_value(<<"rank">>, Props)
    , period = to_period(<<"period">>, Props)
    }.

to_attachment_list(Key, Props) ->
    List = proplists:get_value(Key, Props),
    case List of
        undefined -> [];
        _         -> lists:map(fun to_attachment/1,List)
    end.

to_attachment({Props}) -> to_attachment(Props);
to_attachment(Props) -> 
    DT = maps:get(<<"attachment">>,?ct_info),
    io:format("~p~n~p~n",[Props,DT]),
    #attachment{
      contentType = proplists:get_value(<<"contentType">>, Props) 
    , language    = proplists:get_value(<<"language">>, Props) 
    , data        = proplists:get_value(<<"data">>, Props) 
    , url         = proplists:get_value(<<"url">>, Props) 
    , size        = proplists:get_value(<<"size">>, Props) 
    , hash        = proplists:get_value(<<"hash">>, Props) 
    , title       = proplists:get_value(<<"title">>, Props) 
    , creation    = proplists:get_value(<<"creation">>, Props) 
    }.

to_annotation({Props}) -> to_annotation(Props);
to_annotation(Props) ->
    DT = maps:get(<<"annotation">>,?ct_info),
    io:format("~p~n~p~n",[Props,DT]),
    #annotation{
      authorReference = to_reference(<<"authorReference">>, Props)
    , time = proplists:get_value(<<"time">>, Props) 
    , text = proplists:get_value(<<"text">>, Props)
    }.


to_coding_list(Key, Props) ->
    List = proplists:get_value(Key, Props),
    case List of
        undefined -> [];
        _         -> lists:map(fun to_coding/1,List)
    end.

to_coding(Key, Props) ->
    RefProps = proplists:get_value(Key, Props),
    case RefProps of
        undefined -> undefined;
        _         -> to_coding(RefProps)
    end.

to_coding({Props}) -> to_coding(Props);
to_coding(Props) ->
    DT = maps:get(<<"coding">>,?ct_info),
    io:format("~p~n~p~n",[Props,DT]),
    #coding{
        system  = get_value(<<"system">>, Props, DT)
      , version = get_value(<<"version">>, Props, DT)
      , code    = get_value(<<"code">>, Props, DT)
      , display = get_value(<<"display">>, Props, DT)
      , userSelected = get_value(<<"userSelected">>, Props, DT)
      }.

to_codeableConcept_list(Key, Props) ->
    List = proplists:get_value(Key, Props),
    case List of
        undefined -> [];
        _         -> lists:map(fun to_codeableConcept/1,List)
    end.

to_codeableConcept(Key, Props) ->
    RefProps = proplists:get_value(Key, Props),
    case RefProps of
        undefined -> undefined;
        _         -> to_codeableConcept(RefProps)
    end.

to_codeableConcept({Props}) -> to_codeableConcept(Props);
to_codeableConcept(Props) ->
    DT = maps:get(<<"codeableConcept">>,?ct_info),
    io:format("~p~n~p~n",[Props,DT]),
    #codeableConcept{
        coding  = to_coding_list(<<"coding">>, Props)
      , text = proplists:get_value(<<"text">>, Props)
      }.


to_identifier_list(Key, Props) ->
    List = proplists:get_value(Key, Props),
    case List of
        undefined -> [];
        _         -> lists:map(fun to_identifier/1,List)
    end.

to_identifier({Props}) -> to_identifier(Props);
to_identifier(Props) ->
    DT = maps:get(<<"identifier">>,?ct_info),
    io:format("~p~n~p~n",[Props,DT]),
    #identifier{
        use  = proplists:get_value(<<"use">>, Props)
      , type = to_codeableConcept(<<"type">>, Props)
      , system = proplists:get_value(<<"system">>, Props)
      , value  = proplists:get_value(<<"value">>, Props)
      , period   = to_period(<<"period">>, Props)
      , assigner = to_reference(<<"assigner">>, Props)
      }.

to_period(Key, Props) -> 
    RefProps = proplists:get_value(Key, Props),
    case RefProps of
        undefined -> undefined;
        _         -> to_period(RefProps)
    end.

to_period({Props}) -> to_period(Props);
to_period(Props) ->
    DT = maps:get(<<"period">>,?ct_info),
    io:format("~p~n~p~n",[Props,DT]),
    #period{
        start_  = proplists:get_value(<<"start">>, Props)
      , end_    = proplists:get_value(<<"end">>, Props)
      }.

%%
%%====================================================================
%% Primitive Data Types
%%====================================================================
%%
to_uri_list(Key,Props) ->
    List = proplists:get_value(Key, Props),
    case List of
        undefined -> [];
        _         -> lists:map(fun to_uri/1,List)
    end.

to_uri({Props}) -> to_uri(Props);
to_uri(Props) ->
    proplists:get_value(<<"uri">>, Props).


to_uri(Key, Props) ->
    Value = proplists:get_value(Key, Props),
    case Value of
        undefined -> undefined;
        _         -> Value
    end.

to_boolean(Key, Props) ->
    Value = proplists:get_value(Key, Props),
    case Value of
        undefined -> undefined;
        _         -> Value
    end.

to_boolean({Props}) -> to_boolean(Props);
to_boolean(Props) ->
    proplists:get_value(<<"uri">>, Props).

to_binary({Bin}) -> Bin;
to_binary(Bin) -> Bin.

%%
%%====================================================================
%% Special data types
%%====================================================================
%%
to_narrative(Key, Props) ->
    RefProps = proplists:get_value(Key, Props),
    case RefProps of
        undefined -> undefined;
        _         -> to_narrative(RefProps)
    end.

to_narrative({Props}) -> to_narrative(Props);
to_narrative(Props) ->
    DT = maps:get(<<"narrative">>,?ct_info),
    io:format("~p~n~p~n",[Props,DT]),
    #narrative{
        status = proplists:get_value(<<"status">>, Props)
      , div_   = proplists:get_value(<<"div">>, Props)
      }.

to_meta(Key, Props) ->
    RefProps = proplists:get_value(Key, Props),
    case RefProps of
        undefined -> undefined;
        _         -> to_meta(RefProps)
    end.

to_meta({Props}) -> to_meta(Props);
to_meta(Props) ->
    DT = maps:get(<<"meta">>,?ct_info),
    io:format("~p~n~p~n",[Props,DT]),
    #meta{
        versionId    = proplists:get_value(<<"versionId">>, Props)
      , lastUpdated  = proplists:get_value(<<"lastUpdated">>, Props)
      , source       = proplists:get_value(<<"source">>, Props)
      , profile      = to_uri_list(<<"profile">>, Props) 
      , security     = to_coding_list(<<"security">>, Props)
      , tag          = to_coding_list(<<"tag">>, Props)
      , extension    = extensions:to_extension_list(Props)
      }.
%%====================================================================
%% Internal functions
%%====================================================================
get_value(Key, Props, DT) ->
    {Type,Occurs} = proplists:get_value(Key, DT),
    io:format("get_value: ~s: ~p~n",[Key, {Type,Occurs}]),
    Value = proplists:get_value(Key, Props),
    io:format("get_value: ~p~n",[Value]),
    case {Value,Occurs} of
        {undefined, optional}       -> undefined;
        {undefined, required}       -> error;
        {undefined, list}           -> [];
        {undefined, non_empty_list} -> error;
        {Value,     optional}       -> validate(Type,Value);
        {Value,     required}       -> validate(Type,Value);
        {Value,     list}           -> Fun = get_fun(Type), lists:map(Fun, Value);
        {Value,     non_empty_list} -> Fun = get_fun(Type), lists:map(Fun, Value)
    end.

validate(binary,  Value) -> Value;
validate(boolean, Value) -> utils:binary_to_boolean(Value,error);
validate(coding,  Value) -> Value;
validate(period,  Value) -> Value;
validate(uri,     Value) -> Value.


get_fun(binary) -> fun to_binary/1;
get_fun(coding) -> fun to_coding/1.


%%%
%%% EUnit
%%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

-define(asrtto(A, B), ?assertEqual(B, A)).
-define(asrtpr(A, B), ?assertEqual(B, utils:rec_to_prop(A))).

complex_to_test() ->
    ?asrtto(complex:to_coding({[{<<"code">>, <<"test">>}]}),
            {coding,undefined,undefined,<<"test">>,undefined,undefined}),
    ?asrtto(complex:to_coding({[{<<"userSelected">>, <<"false">>}]}),
            {coding,undefined,undefined,undefined,undefined, false}),
    ?asrtto(complex:to_coding({[{<<"system">>,<<"http://eNahar.org/test">>}, {<<"code">>, <<"test">>},{<<"display">>,<<"test">>}]}),
            {coding,<<"http://eNahar.org/test">>,undefined,<<"test">>,<<"test">>,undefined}),
    ?asrtto(complex:to_humanName({[{<<"use">>, <<"official">>}]}),
            {humanName,<<"official">>,undefined,undefined,[],[],[],undefined}),
    ?asrtto(complex:to_humanName({[{<<"use">>, <<"official">>},{<<"family">>,<<"Sokolow">>},{<<"given">>,[<<"Nicolai">>]}]}),
            {humanName,<<"official">>,undefined,<<"Sokolow">>,[<<"Nicolai">>],[],[],undefined}).


-endif.
