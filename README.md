# README: Teaching Assistant Scheduling System

## Overview
This Prolog-based scheduling system assigns Teaching Assistants (TAs) to proctor quizzes. The system ensures that TAs are available during their assigned slots, adheres to their teaching schedules and days off, and avoids conflicts in assignments.

### Key Features
- Dynamically generates schedules based on TAs' availability.
- Assigns proctors to quizzes while ensuring no conflicts.
- Uses recursive algorithms, backtracking, and list processing techniques to manage assignments efficiently.

## Core Concepts
### Data Structures
- **Quiz**: Represented as `quiz(_, Day, Slot, Count)`, where:
  - `Day`: Day of the quiz.
  - `Slot`: Time slot of the quiz.
  - `Count`: Number of TAs required.
- **FreeSchedule**: Represents the available TAs for each day and slot.
- **ProctoringSchedule**: The resulting assignment of TAs to quizzes.

### Functions
#### 1. `assign_quiz`
Assigns TAs to a specific quiz based on availability.

```prolog
assign_quiz(quiz(_, Day, Slot, Count), FreeSchedule, AssignedTAs) :-
    member(day(Day, L1), FreeSchedule),
    nth1(Slot, L1, FreeTAs),
    powerset(FreeTAs, P),
    length(P, Count),
    permutation(P, AssignedTAs).
```
**Details**:
- Filters available TAs for a specific day and slot.
- Generates combinations of available TAs matching the required count.

#### 2. `powerset`
Generates all subsets of a given list.

```prolog
powerset([], []).
powerset([H1|T1], [H1|T2]) :-
    powerset(T1, T2).
powerset([_|T1], T2) :-
    powerset(T1, T2).
```
**Details**:
- Used to find all possible assignments of TAs for a slot.

#### 3. `assign_quizzes`
Assigns TAs to multiple quizzes while avoiding conflicts.

```prolog
assign_quizzes(Quizzes, FreeSchedule, ProctoringSchedule) :-
    assign_quizzesH(Quizzes, FreeSchedule, ProctoringSchedule),
    \+ common(ProctoringSchedule).

assign_quizzesH([], _, []).
assign_quizzesH([H1|T1], FreeSchedule, [proctors(H1, AssignedTAs)|T2]) :-
    assign_quiz(H1, FreeSchedule, AssignedTAs),
    assign_quizzesH(T1, FreeSchedule, T2).
```
**Details**:
- Handles multiple quizzes recursively.
- Ensures no overlapping assignments for the same slot and day.

#### 4. `common`
Detects conflicts in the proctoring schedule.

```prolog
common(ProctoringSchedule) :-
    member(proctors(quiz(Q1, Day, Slot, _), L1), ProctoringSchedule),
    member(proctors(quiz(Q2, Day, Slot, _), L2), ProctoringSchedule),
    Q1 \= Q2,
    \+ intersection(L1, L2, []).
```
**Details**:
- Conflicts arise if two quizzes share the same slot and day but have overlapping TAs.

#### 5. `free_schedule`
Generates the free schedule for all TAs based on teaching schedules and days off.

```prolog
free_schedule(_, [], []).
free_schedule(AllTAs, [day(Day, L1)|T1], [L2|T2]) :-
    setFreee(AllTAs, day(Day, L1), day(Day, []), L2),
    free_schedule(AllTAs, T1, T2).
```
**Details**:
- Iteratively creates a schedule of available TAs for all slots.

#### 6. `setFreee`
Populates available TAs for a specific day and slot.

```prolog
setFreee(_, day(Day, []), D, D).
setFreee(AllTAs, day(Day, [H1|T1]), day(Day, H13), D) :-
    findall(Name, (member(ta(Name, Agaza), AllTAs), Agaza \= Day, \+ member(Name, H1)), Free1),
    permutation(Free1, Free),
    append(H13, [Free], H15),
    setFreee(AllTAs, day(Day, T1), day(Day, H15), D).
```
**Details**:
- Identifies TAs available for a specific day, excluding those already occupied or on leave.

#### 7. `assign_proctors`
Orchestrates the scheduling process.

```prolog
assign_proctors(AllTAs, Quizzes, TeachingSchedule, ProctoringSchedule) :-
    free_schedule(AllTAs, TeachingSchedule, FreeSchedule), !,
    assign_quizzes(Quizzes, FreeSchedule, ProctoringSchedule).
```
**Details**:
- Combines all steps to generate the final proctoring schedule.

## Technologies
- **Language**: Prolog
- **Programming Paradigm**: Logic Programming
- **Key Features**: Recursion, Backtracking, and Permutations

## How to Run
1. Install Prolog on your system.
2. Save the code to a file, e.g., `TAScheduler.pl`.
3. Load the file in your Prolog interpreter using the command:
   ```bash
   consult('TAScheduler.pl').
   ```
4. Define input data for TAs, quizzes, and teaching schedules, and run the scheduling functions.

## Example Usage
```prolog
% Define TAs with their leave days
AllTAs = [ta("Alice", "Monday"), ta("Bob", "Tuesday"), ta("Charlie", "Wednesday")].

% Define quizzes
Quizzes = [quiz(1, "Monday", 1, 2), quiz(2, "Monday", 2, 1)].

% Define teaching schedule
TeachingSchedule = [day("Monday", [["Bob"], ["Alice"]])].

% Generate proctoring schedule
assign_proctors(AllTAs, Quizzes, TeachingSchedule, ProctoringSchedule).
```

## Notes
- The scheduling process ensures fairness and avoids overburdening TAs.
- The system is highly customizable and can accommodate different constraints.

## Future Improvements
- Add support for priority-based TA assignments.
- Enhance conflict detection with detailed logs.
- Implement a graphical interface for better visualization of schedules.

