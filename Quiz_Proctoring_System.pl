assign_quiz(quiz(_,Day , Slot, Count), FreeSchedule, AssignedTAs):-
    member(day(Day,L1),FreeSchedule),
    nth1(Slot,L1,FreeTAs),
    powerset(FreeTAs, P),
    length(P, Count),
    permutation(P, AssignedTAs).

powerset([],[]).
powerset([H1|T1],[H1|T2]):-
    powerset(T1,T2).
powerset([_|T1],T2):-
    powerset(T1,T2).


assign_quizzes(Quizzes, FreeSchedule, ProctoringSchedule):-
    assign_quizzesH(Quizzes, FreeSchedule, ProctoringSchedule),
    \+ common(ProctoringSchedule).

assign_quizzesH([],_,[]).
assign_quizzesH([H1|T1], FreeSchedule, [proctors(H1, AssignedTAs)|T2]):-
    assign_quiz(H1, FreeSchedule, AssignedTAs),
    assign_quizzesH(T1, FreeSchedule, T2).

common(ProctoringSchedule):-
        member(proctors(quiz(Q1, Day, Slot, _), L1), ProctoringSchedule),
        member(proctors(quiz(Q2, Day, Slot, _), L2), ProctoringSchedule),
        Q1 \= Q2,
        \+ intersection(L1,L2,[]).


free_schedule(_,[],[]).
free_schedule(AllTAs, [day(Day, L1)|T1], [L2|T2]):-
    setFreee(AllTAs, day(Day, L1), day(Day, []), L2),
    free_schedule(AllTAs, T1, T2).

setFreee(_,day(Day,[]),D, D).
setFreee(AllTAs, day(Day, [H1|T1]), day(Day, H13), D):-
    findall(Name, (member(ta(Name, Agaza), AllTAs),Agaza \= Day,\+ member(Name, H1)), Free1),
    permutation(Free1, Free),
    append(H13, [Free], H15),
    setFreee(AllTAs, day(Day, T1), day(Day, H15), D).


assign_proctors(AllTAs, Quizzes, TeachingSchedule, ProctoringSchedule):-
    free_schedule(AllTAs, TeachingSchedule, FreeSchedule),!,
    assign_quizzes(Quizzes, FreeSchedule, ProctoringSchedule).