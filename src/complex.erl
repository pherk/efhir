-module(complex).
-compile(export_all).
-include("primitives.hrl").
%%
%% API exports
%%
-export_type(['Address'/0, 'Annotation'/0, 'Attachment'/0]).
-export_type(['Coding'/0, 'CodeableConcept'/0]).
-export_type(['Identifier'/0]).
-export_type(['HumanName'/0, 'ContactPoint'/0]).
-export_type(['Quantity'/0, 'Range'/0, 'Ratio'/0]).
-export_type(['Period'/0, 'Repeat'/0, 'Timing'/0]).
-export_type(['Signature'/0]).


-record('Address', {
       use                    :: code()     %% home | work | temp | old
     , type                   :: code()     %% postal | physical | both
     , text                   :: binary()
     , line                   :: [binary()]
     , city                   :: binary()
     , district               :: binary()
     , state                  :: binary()
     , postalCode             :: binary()
     , country                :: binary()
     , period                 :: 'Period'()
}).
-opaque 'Address'() :: #'Address'{}.

-record('Annotation', {
      authorReference :: special:'Reference'()
    , time :: date()
    , text :: binary()
    }).
-type 'Annotation'() :: #'Annotation'{}.

-record('Attachment', { 
      contentType :: code()
    , language :: code()
    , data :: base64Binary()
    , url :: binary()
    , size :: integer()
    , hash :: base64Binary()
    , title :: binary()
    , creation :: date()
    }).
-opaque 'Attachment'() :: #'Attachment'{}.

-record('Coding', {
      system       :: uri()
    , version      :: binary()
    , code         :: binary()
    , display      :: binary()
    , userSelected :: boolean()
    }).
-opaque 'Coding'() :: #'Coding'{}.


-record('CodeableConcept', {
      coding       :: ['Coding'()]      %% Coding Code defined by a terminology system
    , text         :: binary()        %% Plain text representation of the concept
}).
-opaque 'CodeableConcept'() :: #'CodeableConcept'{}.

-record('ContactPoint', {
      use                    :: code()     %% home | work | temp | old | mobile
    , system                 :: code()     %% phone | fax | email | pager | other
    , value                  :: binary()
    , rank                   :: non_neg_integer()
    , period                 :: 'Period'()
}).
-opaque 'ContactPoint'() :: #'ContactPoint'{}.

-record('HumanName', {
       use       = <<"official">>   :: code()  %% usual | official | temp | nickname | anonymous | old | maiden
     , text                   :: binary()
     , family                 :: [binary()]
     , given                  :: [binary()]
     , prefix                 :: [binary()]
     , suffix                 :: [binary()]
     , period                 :: 'Period'()
}).
-opaque 'HumanName'() :: #'HumanName'{}.

-record('Identifier', {
       use = <<"official">> :: code()    %% usual | official | temp | secondary 
     , type           :: 'CodeableConcept'() %% Description of 'Identifier'
     , system         :: uri()             %% The namespace for the 'Identifier'
     , value          :: binary()          %% The value that is unique
     , period         :: 'Period'()          %% Time period when id is/was valid for use
     , assigner       :: special:'Reference'()  %% Organization that issued id (may be just text)
}).
-opaque 'Identifier'()   :: #'Identifier'{}.

-record('Period', {
       'start'      :: dateTime()
     , 'end'        :: dateTime()
}).
-opaque 'Period'() :: #'Period'{}.

-record('Quantity', {
      value :: float()
    , comparator :: binary()
    , unit :: binary()
    , system :: binary()
    , code :: binary()
    }).
-opaque 'Quantity'() :: #'Quantity'{}.

-record('Range', {
      low :: 'Quantity'()
    , high :: 'Quantity'()
    }).
-opaque 'Range'() :: #'Range'{}.

-record('Ratio', {
      numerator :: 'Quantity'()
    , denominator :: 'Quantity'()
    }).
-opaque 'Ratio'() :: #'Ratio'{}.

-record('Repeat', {
      boundsPeriod :: 'Period'()
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
-opaque 'Repeat'() :: #'Repeat'{}.

-record('Signature', {
      type :: ['Coding']
    , when_ :: binary()
    , whoReference :: special:'Reference'()
    , onBehalfOfReference :: special:'Reference'()
    , contentType :: binary()
    , blob :: base64Binary()
    }).
-opaque 'Signature'() :: #'Signature'{}.

-record('Timing', {
      event :: [binary()]
    , repeat :: 'Repeat'()
    , code :: 'CodeableConcept'()
    }).
-opaque 'Timing'() :: #'Timing'{}.

%%====================================================================
%% API functions
%%====================================================================
to_address({Props}) -> to_address(Props);
to_address(Props) -> 
    DT = decode:xsd_info(<<"Address">>),
    % io:format("~p~n~p~n",[Props,DT]),
    #'Address'{
      use        = decode:value(<<"use">>, Props, DT)
    , type       = decode:value(<<"type">>, Props, DT) 
    , text       = decode:value(<<"text">>, Props, DT)
    , line       = decode:value(<<"line">>, Props, DT)
    , city       = decode:value(<<"city">>, Props, DT) 
    , district   = decode:value(<<"district">>, Props, DT) 
    , state      = decode:value(<<"state">>, Props, DT) 
    , postalCode = decode:value(<<"postalCode">>, Props, DT) 
    , country    = decode:value(<<"country">>, Props, DT) 
    , period     = decode:value(<<"period">>, Props, DT)
    }.

to_annotation({Props}) -> to_annotation(Props);
to_annotation(Props) ->
    DT = decode:xsd_info(<<"Annotation">>),
    % io:format("~p~n~p~n",[Props,DT]),
    #'Annotation'{
      authorReference = decode:value(<<"authorReference">>, Props, DT)
    , time = decode:value(<<"time">>, Props, DT)
    , text = decode:value(<<"text">>, Props, DT)
    }.

to_attachment({Props}) -> to_attachment(Props);
to_attachment(Props) -> 
    DT = decode:xsd_info(<<"Attachment">>),
    % io:format("~p~n~p~n",[Props,DT]),
    #'Attachment'{
      contentType = decode:value(<<"contentType">>, Props, DT)
    , language    = decode:value(<<"language">>, Props, DT)
    , data        = decode:value(<<"data">>, Props, DT)
    , url         = decode:value(<<"url">>, Props, DT)
    , size        = decode:value(<<"size">>, Props, DT)
    , hash        = decode:value(<<"hash">>, Props, DT)
    , title       = decode:value(<<"title">>, Props, DT)
    , creation    = decode:value(<<"creation">>, Props, DT)
    }.

to_coding({Props}) -> to_coding(Props);
to_coding(Props) ->
    DT = decode:xsd_info(<<"Coding">>),
    % io:format("~p~n~p~n",[Props,DT]),
    #'Coding'{
        system  = decode:value(<<"system">>, Props, DT)
      , version = decode:value(<<"version">>, Props, DT)
      , code    = decode:value(<<"code">>, Props, DT)
      , display = decode:value(<<"display">>, Props, DT)
      , userSelected = decode:value(<<"userSelected">>, Props, DT)
      }.

to_codeableConcept({Props}) -> to_codeableConcept(Props);
to_codeableConcept(Props) ->
    DT = decode:xsd_info(<<"CodeableConcept">>),
    % io:format("~p~n~p~n",[Props,DT]),
    #'CodeableConcept'{
        coding  = decode:value(<<"coding">>, Props, DT)
      , text = decode:value(<<"text">>, Props, DT)
      }.

to_contactPoint({Props}) -> to_contactPoint(Props);
to_contactPoint(Props) -> 
    DT = decode:xsd_info(<<"ContactPoint">>),
    % io:format("~p~n~p~n",[Props,DT]),
    #'ContactPoint'{
      use    = decode:value(<<"use">>, Props, DT)
    , system = decode:value(<<"system">>, Props, DT)
    , value  = decode:value(<<"value">>, Props, DT)
    , rank   = decode:value(<<"rank">>, Props, DT)
    , period = decode:value(<<"period">>, Props, DT)
    }.

to_humanName({Props}) -> to_humanName(Props);
to_humanName(Props) ->
    DT = decode:xsd_info(<<"HumanName">>),
    #'HumanName'{
       use     = decode:value(<<"use">>, Props, DT) 
     , text    = decode:value(<<"text">>, Props, DT) 
     , family  = decode:value(<<"family">>, Props, DT) 
     , given   = decode:value(<<"given">>, Props, DT) 
     , prefix  = decode:value(<<"prefix">>, Props, DT) 
     , suffix  = decode:value(<<"suffix">>, Props, DT) 
     , period  = decode:value(<<"period">>, Props, DT)
    }.

to_identifier({Props}) -> to_identifier(Props);
to_identifier(Props) ->
    DT = decode:xsd_info(<<"Identifier">>),
    #'Identifier'{
        use  = decode:value(<<"use">>, Props, DT)
      , type = decode:value(<<"type">>, Props, DT)
      , system = decode:value(<<"system">>, Props, DT)
      , value  = decode:value(<<"value">>, Props, DT)
      , period   = decode:value(<<"period">>, Props, DT)
      , assigner = decode:value(<<"assigner">>, Props, DT)
      }.

to_period({Props}) -> to_period(Props);
to_period(Props) ->
    DT = decode:xsd_info(<<"Period">>),
    #'Period'{
        'start'  = decode:value(<<"start">>, Props, DT)
      , 'end'    = decode:value(<<"end">>, Props, DT)
      }.

to_quantity({Props}) -> to_quantity(Props);
to_quantity(Props) ->
    DT = decode:xsd_info(<<"Quantity">>),
    #'Quantity'{
        value = decode:value(<<"value">>, Props, DT)
      , comparator = decode:value(<<"comparator">>, Props, DT)
      , unit = decode:value(<<"unit">>, Props, DT)
      , system = decode:value(<<"system">>, Props, DT)
      , code = decode:value(<<"code">>, Props, DT)
      }.

to_range({Props}) -> to_range(Props);
to_range(Props) ->
    DT = decode:xsd_info(<<"Range">>),
    #'Range'{
      low = decode:value(<<"low">>, Props, DT)
    , high = decode:value(<<"high">>, Props, DT)
    }.

to_ratio({Props}) -> to_ratio(Props);
to_ratio(Props) ->
    DT = decode:xsd_info(<<"Ratio">>),
    #'Ratio'{
      numerator = decode:value(<<"numerator">>, Props, DT)
    , denominator = decode:value(<<"denominator">>, Props, DT)
    }.

to_repeat({Props}) -> to_repeat(Props);
to_repeat(Props) ->
    DT = decode:xsd_info(<<"Repeat">>),
    #'Repeat'{
      boundsPeriod = decode:value(<<"boundsPeriod">>, Props, DT)
    , count = decode:value(<<"count">>, Props, DT)
    , countMax = decode:value(<<"countMax">>, Props, DT)
    , duration = decode:value(<<"duration">>, Props, DT)
    , durationMax = decode:value(<<"durationMax">>, Props, DT)
    , durationUnit = decode:value(<<"durationUnit">>, Props, DT)
    , frequency = decode:value(<<"frequency">>, Props, DT)
    , frequencyMax = decode:value(<<"frequencyMax">>, Props, DT)
    , period = decode:value(<<"period">>, Props, DT)
    , periodMax = decode:value(<<"periodMax">>, Props, DT)
    , periodUnit = decode:value(<<"periodUnit">>, Props, DT)
    , dayOfWeek = decode:value(<<"dayOfWeek">>, Props, DT)
    , timeOfDay = decode:value(<<"timeOfDay">>, Props, DT)
    , when_ = decode:value(<<"when_">>, Props, DT)
    , offset = decode:value(<<"offset">>, Props, DT)
    }.

to_signature({Props}) -> to_signature(Props);
to_signature(Props) ->
    DT = decode:xsd_info(<<"Signature">>),
    #'Signature'{
      type = decode:value(<<"type">>, Props, DT)
    , when_ = decode:value(<<"when_">>, Props, DT)
    , whoReference = decode:value(<<"whoReference">>, Props, DT)
    , onBehalfOfReference = decode:value(<<"onBehalfOfReference">>, Props, DT)
    , contentType = decode:value(<<"contentType">>, Props, DT)
    , blob = decode:value(<<"blob">>, Props, DT)
    }.

to_timing({Props}) -> to_timing(Props);
to_timing(Props) ->
    DT = decode:xsd_info(<<"Timing">>),
    #'Timing'{
      event = decode:value(<<"event">>, Props, DT)
    , repeat = decode:value(<<"repeat">>, Props, DT)
    , code = decode:value(<<"code">>, Props, DT)
    }.


%%%
%%% EUnit
%%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

-define(asrtto(A, B), ?assertEqual(B, A)).
-define(asrtpr(A, B), ?assertEqual(B, utils:rec_to_prop(A))).

complex_to_test() ->
    ?asrtto(complex:to_coding({[{<<"code">>, <<"test">>}]}),
            {'Coding',undefined,undefined,<<"test">>,undefined,undefined}),
    ?asrtto(complex:to_coding({[{<<"userSelected">>, <<"false">>}]}),
            {'Coding',undefined,undefined,undefined,undefined, false}),
    ?asrtto(complex:to_coding({[{<<"system">>,<<"http://eNahar.org/test">>}, {<<"code">>, <<"test">>},{<<"display">>,<<"test">>}]}),
            {'Coding',<<"http://eNahar.org/test">>,undefined,<<"test">>,<<"test">>,undefined}),
    ?asrtto(complex:to_humanName({[{<<"use">>, <<"official">>}]}),
            {'HumanName',<<"official">>,undefined,undefined,[],[],[],undefined}),
    ?asrtto(complex:to_humanName({[{<<"use">>, <<"official">>},{<<"family">>,<<"Sokolow">>},{<<"given">>,[<<"Nicolai">>]}]}),
            {'HumanName',<<"official">>,undefined,<<"Sokolow">>,[<<"Nicolai">>],[],[],undefined}).

complex_timing_test() ->
    ?asrtto(complex:to_timing({[{<<"event">>, [<<"2019-07-15T12:00:00">>]}]}),
            {'Timing',[<<"2019-07-15T12:00:00">>], undefined, undefined}).

-endif.

