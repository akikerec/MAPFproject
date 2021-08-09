dir(1,0). dir(-1,0). dir(0,1). dir(0,-1). dir(0,0).

hway(H,X,Y) :- init(object(highway,H),value(_,(X,Y))).
goal(X,Y)   :- init(object(shelf,_), value(at,(X,Y))).
robot(R) :- init(object(robot,R), _).
init(object(robot, R), value(dl, D)) :- init(object(robot,R), _), deadline(D).

%define edges
edge(X,Y, X+Dx,Y+Dy) :- hway(H,X,Y), hway(HH,X+Dx,Y+Dy), dir(Dx,Dy).
edge(X,Y,XX,YY) :- edge(XX,YY,X,Y). 

path(R,X,Y,0,D) :- init(object(robot,R), value(at,(X,Y))), init(object(robot, R), value(dl, D)).

%exists(R,X,Y,XX,YY) :- path(R,X,Y,_,_), edge(X,Y,XX,YY).

{path(R,XX,YY,S+1,D)}1 :- path(R,X,Y,S,D), edge(X,Y,XX,YY), S<D.

%robot cannot move in different directions at the same timestep
:- path(R,X,Y,S,_), path(R,XX,YY,S,_), (X,Y)!= (XX,YY).
%robot doesnt move after goal is reached
:- path(R,X,Y,S,_), goal(X,Y), path(R,_,_,S+1,_).
%two different robots cannot move along the same edge at the same time
:- path(R,X,Y,S,_), path(RR,X,Y,S,_), R != RR.
%two different robots cannot switch places
:- path(R,X,Y,S,_), path(R,XX,YY,S+1,_), R != RR , path(RR,XX,YY,S,_), path(RR,X,Y,S+1,_).


finish(R,S,X,Y) :- path(R,X,Y,S,_), goal(X,Y), robot(RR), not finish(RR,_,X,Y), R!=RR.

%once the goal is reached, it is not traversable by other robots
:- path(R,X,Y,S,_), finish(RR,SS,X,Y), S > SS.

%:- robot(R), not finish(R,_,_,_).



occurs(object(robot, R), action(move,(XX-X, YY-Y)),S) :- path(R,X,Y,S,_),path(R,XX,YY,S+1,_).

%#show path/5.
%#show exists/5.
%#show edge/4.
%#show hway/3.
#show occurs/3.


#maximize{ R : finish(R,S,_,_) }.