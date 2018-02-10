-- Copyright (c) 2017 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Tim Baumann, Stephen Morgan, Scott Morrison

import .category

open categories

namespace categories.isomorphism
universes u v

variable {C : Type u}
variables {X Y Z : C}

structure Isomorphism [category.{u v} C] (X Y : C) :=
(morphism : Hom X Y)
(inverse : Hom Y X)
(witness_1 : morphism >> inverse = 𝟙 X . tidy')
(witness_2 : inverse >> morphism = 𝟙 Y . tidy')

make_lemma Isomorphism.witness_1
make_lemma Isomorphism.witness_2
attribute [simp,ematch] Isomorphism.witness_1_lemma Isomorphism.witness_2_lemma

instance Isomorphism_coercion_to_morphism [category.{u v} C] : has_coe (Isomorphism X Y) (Hom X Y) :=
  {coe := Isomorphism.morphism}

definition IsomorphismComposition [category.{u v} C] (α : Isomorphism X Y) (β : Isomorphism Y Z) : Isomorphism X Z :=
{
  morphism := α.morphism >> β.morphism,
  inverse := β.inverse >> α.inverse
}

@[applicable] lemma Isomorphism_pointwise_equal
  [category.{u v} C]
  (α β : Isomorphism.{u v} X Y)
  (w : α.morphism = β.morphism) : α = β :=
  begin
    induction α with f g wα1 wα2,
    induction β with h k wβ1 wβ2,
    simp at w,    
    have p : g = k,
      begin
        -- PROJECT why can't we automate this?
        tidy,
        resetI,
        rewrite ← category.left_identity k,
        rewrite ← wα2,
        rewrite category.associativity,
        simp *,
      end,
    smt_eblast
  end

definition Isomorphism.reverse [category C] (I : Isomorphism X Y) : Isomorphism Y X := {
  morphism  := I.inverse,
  inverse   := I.morphism
}

structure is_Isomorphism [category C] (morphism : Hom X Y) :=
(inverse : Hom Y X)
(witness_1 : morphism >> inverse = 𝟙 X . tidy')
(witness_2 : inverse >> morphism = 𝟙 Y . tidy')

make_lemma is_Isomorphism.witness_1
make_lemma is_Isomorphism.witness_2
attribute [simp,ematch] is_Isomorphism.witness_1_lemma is_Isomorphism.witness_2_lemma

instance is_Isomorphism_coercion_to_morphism [category C] (f : Hom X Y): has_coe (is_Isomorphism f) (Hom X Y) :=
  {coe := λ _, f}

definition Epimorphism [category C] (f : Hom X Y) := Π (g h : Hom Y Z) (w : f >> g = f >> h), g = h
definition Monomorphism [category C] (f : Hom X Y) := Π (g h : Hom Z X) (w : g >> f = h >> f), g = h

end categories.isomorphism
