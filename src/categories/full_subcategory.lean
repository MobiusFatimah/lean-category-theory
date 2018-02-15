-- Copyright (c) 2017 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Scott Morrison

import .functor

open categories.functor

namespace categories

universes u₁ u₂ v₁ v₂ w wc wd

local attribute [applicable] category.identity -- This says that whenever there is a goal of the form C.Hom X X, we can safely complete it with the identity morphism. This isn't universally true.

variable {C : Type u₁}
variable [category C]
variable {D : Type u₂}
variable [category D]

-- TODO consider changing Sort to Type here, and making people put in their own plifts.

instance FullSubcategory (Z : C → Sort u₁) : category (Σ X : C, plift (Z X)) := {
  Hom := λ X Y, Hom X.1 Y.1,
  identity       := by tidy,
  compose        := λ _ _ _ f g, f >> g
}

definition FullSubcategoryInclusion {Z : C → Sort u₁} : Functor (Σ X : C, plift (Z X)) C := {
  onObjects := λ X, X.1,
  onMorphisms := λ _ _ f, f
}

definition Functor_restricts_to_FullSubcategory 
  (F : Functor C D) 
  (ZC : C → Sort u₁)
  (ZD : D → Sort u₂)
  (w : ∀ {X : C} (z : ZC X), ZD (F.onObjects X)) : Functor (Σ X : C, plift (ZC X)) (Σ Y : D, plift (ZD Y)) := {
    onObjects     := λ X, ⟨ F.onObjects X.1, ⟨ w X.2.down ⟩  ⟩,
    onMorphisms   := λ _ _ f, F.onMorphisms f
 }

end categories
