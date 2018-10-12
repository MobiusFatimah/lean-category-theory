-- Copyright (c) 2018 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Scott Morrison

import category_theory.functor_category
import category_theory.tactics.obviously

set_option trace.tidy true

namespace category_theory

universes u₁ v₁ u₂ v₂ u₃ v₃ u₄ v₄

variables (C : Type u₁) [𝒞 : category.{u₁ v₁} C] (D : Type u₂) [𝒟 : category.{u₂ v₂} D] (E : Type u₃) [ℰ : category.{u₃ v₃} E]
include 𝒞 𝒟 ℰ

def whiskering_on_left : (C ⥤ D) ⥤ ((D ⥤ E) ⥤ (C ⥤ E)) := 
{ obj := λ F, { obj := λ G, F ⋙ G,
                map' := λ _ _ α, (nat_trans.id _) ◫ α },
  map' := λ F G τ, 
  { app := λ H, 
    { app := λ c, H.map (τ c), 
      naturality' := begin intros X Y f, dsimp at *, erw [←functor.map_comp, ←functor.map_comp, ←nat_trans.naturality] end },
    naturality' := begin intros X Y f, ext1, dsimp at *, simp at *, erw [←nat_trans.naturality] end } }

def whiskering_on_right : (D ⥤ E) ⥤ ((C ⥤ D) ⥤ (C ⥤ E)) :=
{ obj := λ H, { obj := λ F, F ⋙ H,
                map' := λ _ _ α, α ◫ (nat_trans.id _) },
  map' := λ G H τ, 
  { app := λ F, 
    { app := λ c, τ (F c),
      naturality' := begin intros X Y f, dsimp at *, erw [nat_trans.naturality] end },
    naturality' := begin intros X Y f, ext1, dsimp at *, simp at *, erw [←nat_trans.naturality] end } }

variables {C} {D} {E}

def whisker_on_left (F : C ⥤ D) {G H : D ⥤ E} (α : G ⟹ H) : (F ⋙ G) ⟹ (F ⋙ H) :=
((whiskering_on_left C D E) F).map α

@[simp] lemma whisker_on_left.app (F : C ⥤ D) {G H : D ⥤ E} (α : G ⟹ H) (X : C) : (whisker_on_left F α) X = α (F X) := 
begin
  dsimp [whisker_on_left, whiskering_on_left],
  rw category_theory.functor.map_id,
  rw category.comp_id,
end

def whisker_on_right {G H : C ⥤ D} (α : G ⟹ H) (F : D ⥤ E) : (G ⋙ F) ⟹ (H ⋙ F) := 
((whiskering_on_right C D E) F).map α

@[simp] lemma whisker_on_right.app {G H : C ⥤ D} (α : G ⟹ H) (F : D ⥤ E) (X : C) : (whisker_on_right α F) X = F.map (α X) := 
begin
  dsimp [whisker_on_right, whiskering_on_right],
  rw category.id_comp,
end

@[simp] lemma whisker_on_left_vcomp (F : C ⥤ D) {G H K : D ⥤ E} (α : G ⟹ H) (β : H ⟹ K) : 
  whisker_on_left F (α ⊟ β) = ((whisker_on_left F α) ⊟ (whisker_on_left F β)) :=
((whiskering_on_left C D E) F).map_comp α β

@[simp] lemma whisker_on_right_vcomp {G H K : C ⥤ D} (α : G ⟹ H) (β : H ⟹ K) (F : D ⥤ E)  : 
  whisker_on_right (α ⊟ β) F = ((whisker_on_right α F) ⊟ (whisker_on_right β F)) :=
((whiskering_on_right C D E) F).map_comp α β

variables {B : Type u₄} [ℬ : category.{u₄ v₄} B]
include ℬ 

@[simp] lemma whisker_on_left_twice (F : B ⥤ C) (G : C ⥤ D) {H K : D ⥤ E} (α : H ⟹ K) :
  whisker_on_left F (whisker_on_left G α) = (@whisker_on_left _ _ _ _ _ _ (F ⋙ G) _ _ α) :=
by tidy

@[simp] lemma whisker_on_right_twice {H K : B ⥤ C} (F : C ⥤ D) (G : D ⥤ E) (α : H ⟹ K) :
  whisker_on_right (whisker_on_right α F) G = (@whisker_on_right _ _ _ _ _ _ _ _ α (F ⋙ G)) :=
by tidy

lemma whisker_on_right_left (F : B ⥤ C) {G H : C ⥤ D} (α : G ⟹ H) (K : D ⥤ E) :
  whisker_on_right (whisker_on_left F α) K = whisker_on_left F (whisker_on_right α K) :=
by tidy

end category_theory