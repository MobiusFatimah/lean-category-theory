-- Copyright (c) 2017 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Scott Morrison

import .currying_2

open tqft.categories
open tqft.categories.isomorphism
open tqft.categories.functor
open tqft.categories.equivalence

namespace tqft.categories.natural_transformation

theorem {u1 v1 u2 v2 u3 v3} Currying_for_functors
  ( C : Category.{u1 v1} )
  ( D : Category.{u2 v2} )
  ( E : Category.{u3 v3} ) :
  Equivalence (FunctorCategory C (FunctorCategory D E)) (FunctorCategory (C × D) E) := 
  {
    functor := Uncurry_Functors C D E,
    inverse := Curry_Functors C D E,
    isomorphism_1 := {
     morphism  := Curry_Uncurry_to_identity C D E,
     inverse   := identity_to_Curry_Uncurry C D E,
     witness_1 := begin
                    repeat { pointwise, intros, unfold_projections, dsimp },
                    simp
                  end,
     witness_2 := begin
                    repeat { pointwise, intros, unfold_projections, dsimp },
                    simp
                  end
    },
    isomorphism_2 := {
     morphism  := Uncurry_Curry_to_identity C D E,
     inverse   := identity_to_Uncurry_Curry C D E,
     witness_1 := begin
                    pointwise, intros F, unfold_projections, dsimp,
                    pointwise, intros X, unfold_projections, dsimp,
                    induction X with X_1 X_2,
                    unfold Uncurry_Curry_to_identity._proof_1,
                    unfold Uncurry_Curry_to_identity._proof_2,
                    unfold identity_to_Uncurry_Curry._proof_1,
                    unfold identity_to_Uncurry_Curry._proof_2,
                    unfold pair_equality,
                    unfold_projections,
                    dsimp,
                    repeat { rewrite congr_arg_refl },
                    repeat { rewrite congr_refl_refl },
                    repeat { rewrite mpr_refl },
                    simp
                  end,
     witness_2 := begin
                    pointwise, intros F, unfold_projections, dsimp,
                    pointwise, intros X, unfold_projections, dsimp,
                    induction X with X_1 X_2,
                    unfold Uncurry_Curry_to_identity._proof_1,
                    unfold Uncurry_Curry_to_identity._proof_2,
                    unfold identity_to_Uncurry_Curry._proof_1,
                    unfold identity_to_Uncurry_Curry._proof_2,
                    unfold pair_equality,
                    unfold_projections,
                    dsimp,
                    repeat { rewrite congr_arg_refl },
                    repeat { rewrite congr_refl_refl },
                    repeat { rewrite mpr_refl },
                    simp
                  end   
    },
  }

end tqft.categories.natural_transformation