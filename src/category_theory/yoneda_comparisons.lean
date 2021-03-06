import category_theory.yoneda
import category_theory.follow_your_nose

universes v₁ u₁

open category_theory
open opposite

-- Unimath, Coq
-- https://github.com/UniMath/UniMath/blob/master/UniMath/CategoryTheory/yoneda.v
-- Greg O'Keefe, Isabelle
-- https://www.isa-afp.org/browser_info/current/AFP/Category/document.pdf
-- Alexander Katovsky, Isabelle
-- https://www.isa-afp.org/browser_info/current/AFP/Category2/document.pdf
-- Gross, Chlipala, Spivak, Coq
-- https://arxiv.org/src/1401.7694v2/anc/HoTT/theories/categories/Yoneda.v

variables (C : Type u₁) [𝒞 : category.{v₁+1} C]
include 𝒞

def yoneda_0 : C ⥤ ((Cᵒᵖ) ⥤ Type v₁) :=
{ obj := λ X,
  { obj := λ Y, (unop Y) ⟶ X,
    map := λ Y Y' f g, f.unop ≫ g,
    map_comp' := begin intros, ext1, dsimp, erw [category.assoc] end,
    map_id' := begin intros, ext1, dsimp, erw [category.id_comp] end },
  map := λ X X' f,
    { app := λ Y g, g ≫ f,
      naturality' := begin intros, ext1, dsimp, simp end },
  map_comp' := begin intros, ext1, ext1, dsimp, simp end,
  map_id' := begin intros, ext1, ext1, dsimp, simp end }.

def yoneda_1 : C ⥤ ((Cᵒᵖ) ⥤ Type v₁) :=
{ obj := λ X,
  { obj := λ Y, (unop Y) ⟶ X,
    map := λ Y Y' f g, f.unop ≫ g,
    map_comp' := begin intros, ext1, dsimp, erw [category.assoc] end,
    map_id' := begin intros, ext1, dsimp, erw [category.id_comp] end },
  map := λ X X' f, { app := λ Y g, g ≫ f } }.

def yoneda_2 : C ⥤ ((Cᵒᵖ) ⥤ Type v₁) :=
{ obj := λ X,
  { obj := λ Y, (unop Y) ⟶ X,
    map := λ Y Y' f g, f.unop ≫ g },
  map := λ X X' f, { app := λ Y g, g ≫ f } }.

def yoneda_3 : C ⥤ ((Cᵒᵖ) ⥤ Type v₁) := ƛ X, ƛ Y, (unop Y) ⟶ X.

def yoneda_lemma' : (yoneda_pairing C) ≅ (yoneda_evaluation C) :=
{ hom := { app := λ F x, ulift.up ((x.app F.1) (𝟙 (unop F.1))) },
  inv := { app := λ F x, { app := λ X a, (F.2.map a.op) x.down } } }.
