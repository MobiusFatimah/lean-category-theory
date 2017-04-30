-- Copyright (c) 2017 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Scott Morrison

import .natural_transformation
import .isomorphism
import .opposites
import .equivalence
import .products.products
import .products.switch
import .examples.types.types

open tqft.categories
open tqft.categories.functor
open tqft.categories.natural_transformation
open tqft.categories.isomorphism
open tqft.categories.equivalence
open tqft.categories.examples.types
open tqft.categories.products

namespace tqft.categories.yoneda

definition {u v} Yoneda ( C : Category.{u v} ) : Functor C (FunctorCategory (Opposite C) CategoryOfTypes.{v}) :=
{
    onObjects := λ X, {
        onObjects     := λ Y, C.Hom Y X,
        onMorphisms   := λ Y Y' f, λ g, C.compose f g,
        identities    := ♯,
        functoriality := ♯ 
    },
    onMorphisms   := λ X X' f, {
        components := λ Y, λ g, C.compose g f,
        naturality := ♯
    },
    identities    := ♯,
    functoriality := ♯
}

-- PROJECT set up the Yoneda lemma as a natural isomorphism
-- between evaluation : Fun(C^op → Type) × C^op → Type
--     and    pairing : Fun(C^op → Type) × C^op → Fun(C^op → Type) × Fun(C^op → Type)^op  → Type
@[reducible] definition {v} YonedaEvaluation ( C : Category.{v v} )
  : Functor (ProductCategory (FunctorCategory (Opposite C) CategoryOfTypes.{v}) (Opposite C)) CategoryOfTypes.{v}
  := Evaluation (Opposite C) CategoryOfTypes.{v}
@[reducible] definition {v} YonedaPairing ( C : Category.{v v} ) 
  : Functor (ProductCategory (FunctorCategory (Opposite C) CategoryOfTypes.{v}) (Opposite C)) CategoryOfTypes.{v}
  := FunctorComposition
      (FunctorComposition
        (ProductFunctor (IdentityFunctor _) (OppositeFunctor (Yoneda C)))
        (SwitchProductCategory _ _))
      (HomPairing (FunctorCategory (Opposite C) CategoryOfTypes.{v})) 

private lemma {u v w} composition {α : Sort u} {β : Sort v} {γ : Sort w} {f : α → β} {g : β → γ} (a : α) : (g ∘ f) a = g (f a) := ♯

theorem {v} YonedaLemma ( C : Category.{v v} ) : NaturalIsomorphism (YonedaPairing C) (YonedaEvaluation C) := 
begin
  unfold NaturalIsomorphism,
  fsplit,
  {
    unfold FunctorCategory,
    dsimp,
    fsplit,
    {
      tidy,
      exact ((a.components X_2) (C.identity X_2))
    },
    {
      tidy,
      pose p := x.naturality f_2,
      unfold_projections at p,
      simp at p,
      pose q := congr_fun p (C.identity X_2),
      rewrite composition at q,
      simp at q,
      tidy,
      rewrite q
    }
  },
  {
    tidy,
    admit
  },
  {
    tidy,
    admit
  },
  {
    tidy,
    admit
  }
end


theorem {u v} YonedaEmbedding ( C : Category.{u v} ) : Embedding (Yoneda C) :=
begin
  tidy,
  {
    -- Show it is full
    fsplit,
    {
        intros,
        exact (f.components X) (C.identity X)
    },
    {
        tidy,
        pose p := f.naturality x,
        tidy,
        simp at p,
        pose q := congr_fun p (C.identity X),
        rewrite composition at q,
        rewrite C.right_identity at q,
        exact (eq.symm q)
    }
  },
  {
    -- Show it is faithful
    fsplit,
    tidy,
    pose q := congr_arg NaturalTransformation.components p,
    simp at q,
    pose q' := congr_fun q X,
    simp at q',
    pose q'' := congr_fun q' (C.identity X),
    simp at q'',
    exact q''
  }
end

end tqft.categories.yoneda