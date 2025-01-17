
# 🗓️ Teaching Assistant Scheduling System 📚

## 🚀 Overview

This Prolog-based **Scheduling System** is designed to assign Teaching Assistants (TAs) to proctor quizzes. The system ensures TAs are available during their assigned slots, while considering their teaching schedules and days off. The goal is to avoid any scheduling conflicts while distributing tasks fairly. 🎓

### 🎯 Key Features
- **Dynamic Scheduling**: Generates schedules based on TAs' availability.
- **Conflict-Free Assignments**: Ensures no overlaps in assignments.
- **Recursive Algorithms**: Utilizes backtracking, recursion, and list processing for efficient scheduling.

---

## 🧠 Core Concepts

### 📚 Data Structures
- **Quiz**: Represented as `quiz(_, Day, Slot, Count)`:
  - `Day`: Day of the quiz.
  - `Slot`: Time slot for the quiz.
  - `Count`: Number of TAs needed for the quiz.
  
- **FreeSchedule**: Represents available TAs for each day and slot.
- **ProctoringSchedule**: Final assignment of TAs to quizzes.

---

## 🛠️ Functions

### 1. `assign_quiz`
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
- Generates all possible combinations of available TAs to meet the required count.

### 2. `powerset`
Generates all subsets of a given list.

```prolog
powerset([], []).
powerset([H1|T1], [H1|T2]) :-
    powerset(T1, T2).
powerset([_|T1], T2) :-
    powerset(T1, T2).
```
**Details**:
- This function is used to generate possible assignments of TAs for each quiz.

### 3. `assign_quizzes`
Assigns TAs to multiple quizzes while avoiding conflicts.

```prolog
assign_quizzes(Quizzes, FreeSchedule, ProctoringSchedule) :-
    assign_quizzesH(Quizzes, FreeSchedule, ProctoringSchedule),
    \+ common(ProctoringSchedule).
```
**Details**:
- Handles multiple quizzes recursively.
- Ensures no overlapping assignments for the same slot and day.

### 4. `common`
Detects conflicts in the proctoring schedule.

```prolog
common(ProctoringSchedule) :-
    member(proctors(quiz(Q1, Day, Slot, _), L1), ProctoringSchedule),
    member(proctors(quiz(Q2, Day, Slot, _), L2), ProctoringSchedule),
    Q1 \= Q2,
    \+ intersection(L1, L2, []).
```
**Details**:
- Detects conflicts if two quizzes share the same time slot and day but have overlapping TAs.

### 5. `free_schedule`
Generates the free schedule for all TAs based on teaching schedules and days off.

```prolog
free_schedule(_, [], []).
free_schedule(AllTAs, [day(Day, L1)|T1], [L2|T2]) :-
    setFreee(AllTAs, day(Day, L1), day(Day, []), L2),
    free_schedule(AllTAs, T1, T2).
```
**Details**:
- Creates a list of available TAs for each day and time slot, considering their teaching schedules and days off.

### 6. `setFreee`
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
- Determines the TAs that are free for a specific day and slot by filtering out those already scheduled or on leave.

### 7. `assign_proctors`
Orchestrates the scheduling process.

```prolog
assign_proctors(AllTAs, Quizzes, TeachingSchedule, ProctoringSchedule) :-
    free_schedule(AllTAs, TeachingSchedule, FreeSchedule), !,
    assign_quizzes(Quizzes, FreeSchedule, ProctoringSchedule).
```
**Details**:
- Combines all the steps to generate the final proctoring schedule.

---

## 💻 Technologies
- **Language**: Prolog
- **Programming Paradigm**: Logic Programming
- **Key Features**: Recursion, Backtracking, and Permutations

---

## 🚀 How to Run

1. **Install Prolog** on your system.
2. **Save the Code** to a file, e.g., `TAScheduler.pl`.
3. **Load the file** in your Prolog interpreter:
   ```bash
   consult('TAScheduler.pl').
   ```
4. **Define Input Data** for TAs, quizzes, and teaching schedules, then run the scheduling functions.

---

## 📋 Example Usage

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

---

## ⚠️ Notes
- The system ensures fairness and prevents overburdening any individual TA.
- The approach is flexible and can handle various constraints, making it highly adaptable.

---

## 🌱 Future Improvements

- **Priority-based Assignments**: Add support for assigning higher-priority TAs to quizzes.
- **Conflict Detection**: Enhance the system with more detailed logs for conflict identification.
- **Graphical Interface**: Implement a user-friendly interface to visualize schedules.

---
