-- Copyright (c) 2017 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Stephen Morgan, Scott Morrison
import ..products

--set_option pp.universes true

open tqft.categories
open tqft.categories.functor
open tqft.categories.products
open tqft.categories.natural_transformation

namespace tqft.categories.monoidal_category

universe variables u v

@[reducible] definition TensorProduct ( C: Category ) := Functor ( C × C ) C

structure PreMonoidalCategory
  -- this is only for internal use: it has a tensor product, but no associator at all
  -- it's not interesting mathematically, but may allow us to introduce usable notation for the tensor product
  extends carrier : Category :=
  (tensor : TensorProduct carrier)
  (tensor_unit : Obj)

instance PreMonoidalCategory_coercion : has_coe PreMonoidalCategory Category := 
  ⟨PreMonoidalCategory.to_Category⟩

definition left_associated_triple_tensor ( C : PreMonoidalCategory ) : Functor ((C × C) × C) C :=
  FunctorComposition (C^.tensor × IdentityFunctor C) C^.tensor
definition right_associated_triple_tensor ( C : PreMonoidalCategory ) : Functor (C × (C × C)) C :=
  FunctorComposition (IdentityFunctor C × C^.tensor) C^.tensor

@[reducible] definition Associator ( C : PreMonoidalCategory ) := 
  NaturalTransformation 
    (left_associated_triple_tensor C) 
    (FunctorComposition (ProductCategoryAssociator C C C) (right_associated_triple_tensor C))

definition left_associated_quadruple_tensor ( C : PreMonoidalCategory ) :
  Functor (((C × C) × C) × C) C :=
  FunctorComposition
    (FunctorComposition
      ((C^.tensor × IdentityFunctor C) × IdentityFunctor C)
      (C^.tensor × IdentityFunctor C))
    C^.tensor

definition right_associated_quadruple_tensor ( C : PreMonoidalCategory ) :
  Functor (C × (C × (C × C))) C :=
  FunctorComposition
    (FunctorComposition
      (IdentityFunctor C × (IdentityFunctor C  × C^.tensor))
      (IdentityFunctor C × C^.tensor))
    C^.tensor

definition pentagon_3step_1 { C : PreMonoidalCategory } ( α : Associator C ) :=
  whisker_on_right
    (α × IdentityNaturalTransformation (IdentityFunctor C))
    C^.tensor

definition pentagon_3step_2 { C : PreMonoidalCategory } ( α : Associator C ) :=
  whisker_on_left
    (FunctorComposition
      (ProductCategoryAssociator C C C × IdentityFunctor C)
      ((IdentityFunctor C × C^.tensor) × IdentityFunctor C))
    α

definition pentagon_3step_3 { C : PreMonoidalCategory } ( α : Associator C ) :=
  whisker_on_left
    (FunctorComposition
      (ProductCategoryAssociator C C C × IdentityFunctor C)
      (ProductCategoryAssociator C (↑C × ↑C) C))
    (whisker_on_right
      (IdentityNaturalTransformation (IdentityFunctor C) × α)
      C^.tensor)

definition pentagon_3step { C : PreMonoidalCategory } ( α : Associator C ) :=
  vertical_composition_of_NaturalTransformations
    (vertical_composition_of_NaturalTransformations
      (pentagon_3step_1 α)
      (pentagon_3step_2 α))
    (pentagon_3step_3 α)

definition pentagon_2step_1 { C : PreMonoidalCategory } ( α : Associator C ) :=
  whisker_on_left
    ((C^.tensor × IdentityFunctor C) × IdentityFunctor C)
    α

definition pentagon_2step_2 { C : PreMonoidalCategory } ( α : Associator C ) :=
  whisker_on_left
    (FunctorComposition
      (ProductCategoryAssociator (↑C × ↑C) C C)
      (IdentityFunctor (↑C × ↑C) × C^.tensor))
    α

definition pentagon_2step { C : PreMonoidalCategory } ( α : Associator C ) :=
  vertical_composition_of_NaturalTransformations
    (pentagon_2step_1 α)
    (pentagon_2step_2 α)

end tqft.categories.monoidal_category    