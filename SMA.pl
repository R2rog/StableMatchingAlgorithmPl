%The following code is the implementation of the stable matching algorithm in Prolog
%Copyright (C) 2018  Arturo Guevara Chávez.

%This program is free software: you can redistribute it and/or modify
%it under the terms of the GNU General Public License as published by
%the Free Software Foundation, either version 3 of the License, or
%(at your option) any later version.

%but WITHOUT ANY WARRANTY; without even the implied warranty of
%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%GNU General Public License for more details.

%You should have received a copy of the GNU General Public License
%along with this program.  If not, see <https://www.gnu.org/licenses/>.

%Insert Knowledge base here.
%Knowledge base Test case 1.===================================================
choice(rob,lisa,1).
choice(rob,mary,2).
choice(mark,lisa,1).
choice(mark,mary,2).
choice(lisa,rob,1).
choice(lisa,mark,2).
choice(mary,mark,1).
choice(mary,rob,2).
%Hellper Functions==============================================================
%--Function member determines if one element belongs to a list.
member2(X,[X|T]):-!.
member2(X,[H|T]):-
      member2(X,T).
%--Function that allows to remove an element from the list======================
remove(X,[X|T],T).
remove(X,[H|T],[Head,NewTail]):-
  remove(X,T,NewTail).

%--Function that finds an element in a List=====================================
fnd(Item,[Item|Rest],Item).
fnd(Item,[DisregardHead|Tail],Op2):-
  fnd(Item, Tail,Op2).

%This one compares the preference level of two options. Op refers to the current pair X has.
comp(Op1,pair(Y,X),X):-
  choice(X,Op1,PrefLev1),
  choice(X,Y,PrefLev2),
  PrefLev1<PrefLev2.

%The actual algorithm===========================================================
%stable_matching simply serves as a mask to get matching started.
stable_matching([],Pool2,Pairs).
stable_matching(Pool1,Pool2,Pairs):-
  matching(Pool1,Pool2,[],1,[]).
%Matching base case when there are no more elements in Pool1====================
matching([],Pool2,Tentative,1,Pairs):-
  format('This are the pairs: ~wiw ',[Pairs]),!.

%Case 1 The pair of choice is available=========================================
matching([H|T],Pool2,Tentative,Count,Pairs):-
  choice(H,X,Count),
  \+member2(X,Tentative),
  NPairs=[pair(H,X)|Pairs],
  NTentative=[X|Tentative],
  matching(T,Pool2,NTentative,1,NPairs).
%Case 2: w prefers the contender================================================
matching([H|T],Pool2,Tentative,Count,Pairs):-
  choice(H,X,Count),
  member2(X,Tentative),
  fnd(pair(Op,X),Pairs,Op2),
  comp(H,Op2,X),
  remove(Op2,Pairs,NPairs),
  append(T,[Op],NPool1),
  NewPairs=[pair(H,X)|NPairs],
  matching(NPool1,Pool2,Tentative,1,NewPairs).
%Case 3 prefers actual pair=====================================================
matching([H|T],Pool2,Tentative,Count,Pairs):-
  choice(H,X,Count),
  member2(X,Tentative),
  fnd(pair(Op,X),Pairs,Op2),
  \+comp(H,Op2,X),
  NCount is Count + 1,
  NPool1=[H|T],
  matching(NPool1,Pool2,Tentative,NCount,Pairs).
