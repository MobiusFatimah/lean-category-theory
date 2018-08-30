import .cones

open category_theory

namespace category_theory.universal

universes u v

variables {J : Type v} [small_category J] {C : Type u} [𝒞 : category.{u v} C]
include 𝒞 

variable {F : J ↝ C}

def limit_cone_of_limit {t : cone F} (L : is_limit t) : is_terminal.{(max u v) v} t :=
{ lift := λ s, { hom := L.lift s, },
  uniq := begin tidy, apply L.uniq_lemma, tidy, end } -- uniq_lemma is marked @[back'], but the unifier fails to apply it

def limit_of_limit_cone {t : cone F} (L : is_terminal.{(max u v) v} t) : is_limit t :=
{ lift := λ s, (L.lift s).hom,
  uniq := begin tidy, have p := L.uniq_lemma s { hom := m }, rw ← p, end }

local attribute [extensionality] is_terminal.ext

def limits_are_limit_cones {t : cone F} : equiv (is_limit t) (is_terminal.{(max u v) v} t) :=
{ to_fun    := limit_cone_of_limit,
  inv_fun   := limit_of_limit_cone,
  left_inv  := by obviously,
  right_inv := by obviously }

end category_theory.universal
