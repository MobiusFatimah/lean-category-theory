-- Copyright (c) 2018 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Scott Morrison

import category_theory.products
import ..tactics.obviously

open category_theory

namespace category_theory

universes u₁ v₁ u₂ v₂

variables (C : Type u₁) [𝒞 : category.{u₁ v₁} C] (D : Type u₂) [𝒟 : category.{u₂ v₂} D]
include 𝒞 𝒟 

def evaluation : ((C ↝ D) × C) ↝ D := 
{ obj := λ p, p.1 p.2,
  map := λ x y f, (x.1.map f.2) ≫ (f.1 y.2) , map_comp := begin tidy,rename Z_fst H, rename Z_snd Z, rename Y_fst G, rename Y_snd Y, rename g_fst b, rename g_snd g, rename X_fst F, rename X_snd X, rename f_fst a, rename f_snd f,  obviously_vis end }

end category_theory