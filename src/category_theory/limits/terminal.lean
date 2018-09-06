-- Copyright (c) 2018 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Scott Morrison, Reid Barton, Mario Carneiro

import category_theory.limits.shape
import category_theory.filtered

open category_theory

namespace category_theory.limits

universes u v w

variables {C : Type u} [𝒞 : category.{u v} C]
include 𝒞

section terminal
structure is_terminal (t : C) :=
(lift : ∀ (s : C), s ⟶ t)
(uniq' : ∀ (s : C) (m : s ⟶ t), m = lift s . obviously)

restate_axiom is_terminal.uniq'
attribute [search,back'] is_terminal.uniq

@[extensionality] lemma is_terminal.ext {X : C} (P Q : is_terminal.{u v} X) : P = Q := 
begin tactic.unfreeze_local_instances, cases P, cases Q, congr, obviously, end

instance hom_to_terminal_subsingleton (X' : C) (X : C) (h : is_terminal.{u v} X) : subsingleton (X' ⟶ X) :=
begin
  fsplit, intros f g,
  rw h.uniq X' f,
  rw h.uniq X' g,
end

end terminal

section initial
structure is_initial (t : C) :=
(desc : ∀ (s : C), t ⟶ s)
(uniq' : ∀ (s : C) (m : t ⟶ s), m = desc s . obviously)

attribute [class] is_initial

restate_axiom is_initial.uniq'
attribute [search,back'] is_initial.uniq

@[extensionality] lemma is_initial.ext {X : C} (P Q : is_initial.{u v} X) : P = Q := 
begin tactic.unfreeze_local_instances, cases P, cases Q, congr, obviously, end

instance hom_from_initial_subsingleton (X' : C) (X : C) (h : is_initial.{u v} X') : subsingleton (X' ⟶ X) :=
begin
  fsplit, intros f g,
  rw h.uniq X f,
  rw h.uniq X g,
end

end initial

variable (C)

class has_terminal_object :=
(terminal    : C)
(is_terminal : is_terminal.{u v} terminal . obviously)

class has_initial_object :=
(initial    : C)
(is_initial : is_initial.{u v} initial . obviously)

def terminal_object [has_terminal_object.{u v} C] : C := has_terminal_object.terminal.{u v} C
def initial_object  [has_initial_object.{u v} C]  : C := has_initial_object.initial.{u v} C

variable {C}
section
variables [has_terminal_object.{u v} C] 

def terminal_object.universal_property : is_terminal.{u v} (terminal_object.{u v} C) := 
has_terminal_object.is_terminal.{u v} C
def terminal_object.hom (X : C) : (X ⟶ terminal_object.{u v} C) := 
terminal_object.universal_property.lift.{u v} X

@[extensionality] lemma terminal.hom_ext {X' : C} (f g : X' ⟶ terminal_object.{u v} C) : f = g :=
begin
  rw (terminal_object.universal_property).uniq _ f,
  rw (terminal_object.universal_property).uniq _ g,
end
end

section
variables [has_initial_object.{u v} C] 

def initial_object.universal_property : is_initial.{u v} (initial_object.{u v} C) := 
has_initial_object.is_initial.{u v} C
def initial_object.hom (X : C) : (initial_object.{u v} C ⟶ X) := 
initial_object.universal_property.desc.{u v} X

@[extensionality] lemma initial.hom_ext {X' : C} (f g : initial_object.{u v} C ⟶ X') : f = g :=
begin
  rw (initial_object.universal_property).uniq _ f,
  rw (initial_object.universal_property).uniq _ g,
end
end

end category_theory.limits
