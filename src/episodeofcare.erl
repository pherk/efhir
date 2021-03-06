-module(episodeofcare).
-compile(export_all).

-include("fhir.hrl").
-include("primitives.hrl").

-record('EpisodeOfCare.Diagnosis', {anyAttribs :: anyAttribs(),
	id :: string() | undefined,
	extension :: [extensions:'Extension'()] | undefined,
	modifierExtension :: [extensions:'Extension'()] | undefined,
	condition :: special:'Reference'(),
	role :: complex:'CodeableConcept'() | undefined,
	rank :: positiveInt() | undefined}).

-type 'EpisodeOfCare.Diagnosis'() :: #'EpisodeOfCare.Diagnosis'{}.


-record('EpisodeOfCare.StatusHistory', {anyAttribs :: anyAttribs(),
	id :: string() | undefined,
	extension :: [extensions:'Extension'()] | undefined,
	modifierExtension :: [extensions:'Extension'()] | undefined,
	status :: complex:'EpisodeOfCareStatus'(),
	period :: complex:'Period'()}).

-type 'EpisodeOfCare.StatusHistory'() :: #'EpisodeOfCare.StatusHistory'{}.


-record('EpisodeOfCare', {anyAttribs :: anyAttribs(),
	id :: id() | undefined,
	meta :: special:'Meta'() | undefined,
	implicitRules :: uri() | undefined,
	language :: code() | undefined,
	text :: special:'Narrative'() | undefined,
	contained :: [resource:'ResourceContainer'()] | undefined,
	extension :: [extensions:'Extension'()] | undefined,
	modifierExtension :: [extensions:'Extension'()] | undefined,
	identifier :: [complex:'Identifier'()] | undefined,
	status :: code(),
	statusHistory :: ['EpisodeOfCare.StatusHistory'()] | undefined,
	type :: [complex:'CodeableConcept'()] | undefined,
	diagnosis :: ['EpisodeOfCare.Diagnosis'()] | undefined,
	patient :: special:'Reference'(),
	managingOrganization :: special:'Reference'() | undefined,
	period :: complex:'Period'() | undefined,
	referralRequest :: [special:'Reference'()] | undefined,
	careManager :: special:'Reference'() | undefined,
	team :: [special:'Reference'()] | undefined,
	account :: [special:'Reference'()] | undefined}).

-type 'EpisodeOfCare'() :: #'EpisodeOfCare'{}.


%%
%% API exports
%%-export([]).

%%====================================================================
%% API functions
%%====================================================================


to_episodeOfCare({Props}) -> to_episodeOfCare(Props);
to_episodeOfCare(Props) ->
  DT = decode:xsd_info(<<"EpisodeOfCare">>),
  #'EpisodeOfCare'{ 
      anyAttribs = decode:attrs(Props, DT) 
    , id               = decode:value(<<"id">>, Props, DT)
    , meta             = decode:value(<<"meta">>, Props, DT)
    , implicitRules    = decode:value(<<"implicitRules">>, Props, DT)
    , language         = decode:value(<<"language">>, Props, DT)
    , text             = decode:value(<<"text">>, Props, DT)
    , contained        = decode:value(<<"contained">>, Props, DT)
    , extension        = decode:value(<<"extension">>, Props, DT)
    , modifierExtension = decode:value(<<"modifierExtension">>, Props, DT)
    , 'identifier'      = decode:value(<<"identifier">>, Props, DT)
    , status  = decode:value(<<"status">>, Props, DT)
    , statusHistory  = decode:value(<<"statusHistory">>, Props, DT)
    , type  = decode:value(<<"type">>, Props, DT)
    , diagnosis  = decode:value(<<"diagnosis">>, Props, DT)
    , patient  = decode:value(<<"patient">>, Props, DT)
    , managingOrganization  = decode:value(<<"managingOrganization">>, Props, DT)
    , period  = decode:value(<<"period">>, Props, DT)
    , referralRequest  = decode:value(<<"referralRequest">>, Props, DT)
    , careManager  = decode:value(<<"careManager">>, Props, DT)
    , team  = decode:value(<<"team">>, Props, DT)
    , account  = decode:value(<<"account">>, Props, DT)
    }.


%%====================================================================
%% Internal functions
%%====================================================================
to_episodeOfCare_diagnosis({Props}) -> to_episodeOfCare_diagnosis({Props});
to_episodeOfCare_diagnosis(Props) ->
  DT = decode:xsd_info(<<"EpisodeOfCare.Diagnosis">>),
  #'EpisodeOfCare.Diagnosis'{ 
      anyAttribs  = decode:attrs(Props, DT)
    , id  = decode:value(<<"id">>, Props, DT)
    , extension  = decode:value(<<"extension">>, Props, DT)
    , modifierExtension  = decode:value(<<"modifierExtension">>, Props, DT)
    , condition  = decode:value(<<"condition">>, Props, DT)
    , role  = decode:value(<<"role">>, Props, DT)
    , rank  = decode:value(<<"rank">>, Props, DT)
    }.


to_episodeOfCare_statusHistory({Props}) -> to_episodeOfCare_statusHistory({Props});
to_episodeOfCare_statusHistory(Props) ->
  DT = decode:xsd_info(<<"EpisodeOfCare.StatusHistory">>),
  #'EpisodeOfCare.StatusHistory'{ 
      anyAttribs  = decode:attrs(Props, DT)
    , id  = decode:value(<<"id">>, Props, DT)
    , extension  = decode:value(<<"extension">>, Props, DT)
    , modifierExtension  = decode:value(<<"modifierExtension">>, Props, DT)
    , status  = decode:value(<<"status">>, Props, DT)
    , period  = decode:value(<<"period">>, Props, DT)
    }.



text(#'EpisodeOfCare'{text=N}) -> 
    special:narrative(N).

%%
%% EUnit Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

-define(asrtto(A, B), ?assertEqual(B, episodeofcare:to_episodeOfCare(A))).
-define(asrtp(A, B), ?assertEqual(B, encode:to_proplist(A))).
-define(asrtjson(A, B), ?assertEqual(B, jiffy:encode(encode:to_proplist(A)))).

episodeOfCare_to_test() ->
    ?asrtto([{<<"id">>, <<"p-21666">>}, {<<"status">>, <<"active">>},
             {<<"patient">>, {[{<<"reference">>, <<"nabu/Patient/p-21666">>}]}}
            ],
            {'EpisodeOfCare',[],<<"p-21666">>,undefined,undefined, undefined,undefined,[],[],[],
             [],<<"active">>,[],[],[],
             {'Reference',[],undefined,[],<<"nabu/Patient/p-21666">>, undefined,undefined,undefined},
             undefined,undefined,[],undefined,[],[]}
           ).

episodeOfCare_toprop_test() ->
    ?asrtp(
            {'EpisodeOfCare',[],<<"p-21666">>,undefined,undefined, undefined,undefined,[],[],[],
             [],<<"active">>,[],[],[],
             {'Reference',[],undefined,[],<<"nabu/Patient/p-21666">>, undefined,undefined,undefined},
             undefined,undefined,[],undefined,[],[]},
           {[{<<"resourceType">>,<<"EpisodeOfCare">>},
              {<<"id">>,<<"p-21666">>},
              {<<"status">>,<<"active">>},
                   {<<"patient">>,
                    {[{<<"reference">>,<<"nabu/Patient/p-21666">>}]}}]}
            ).

episodeOfCare_json_test() ->
    ?asrtjson(
            {'EpisodeOfCare',[],<<"p-21666">>,undefined,undefined, undefined,undefined,[],[],[],
             [],<<"active">>,[],[],[],
             {'Reference',[],undefined,[],<<"nabu/Patient/p-21666">>, undefined,undefined,undefined},
             undefined,undefined,[],undefined,[],[]},
            <<"{\"resourceType\":\"EpisodeOfCare\",\"id\":\"p-21666\",\"status\":\"active\",\"patient\":{\"reference\":\"nabu/Patient/p-21666\"}}">>
      ).

-endif.


