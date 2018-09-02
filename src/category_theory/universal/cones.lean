-- Copyright (c) 2017 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Stephen Morgan, Scott Morrison

import .limits.limits
import .limits
import .colimits

open category_theory

namespace category_theory.universal

universes u v
variables {J : Type v} [small_category J]
variables {C : Type u} [𝒞 : category.{u v} C]
include 𝒞 

variable {F : J ↝ C}

structure cone_morphism (A B : cone F) : Type v :=
(hom : A.X ⟶ B.X)
(w' : Π j : J, hom ≫ (B.π j) = (A.π j) . obviously)

restate_axiom cone_morphism.w'
attribute [simp,ematch] cone_morphism.w

namespace cone_morphism

@[extensionality] lemma ext {A B : cone F} {f g : cone_morphism A B} (w : f.hom = g.hom) : f = g :=
begin
  /- obviously' say: -/
  induction f,
  induction g,
  dsimp at w,
  induction w,
  refl,
end

end cone_morphism

instance cones (F : J ↝ C) : category.{(max u v) v} (cone F) :=
{ hom  := λ A B, cone_morphism A B,
  comp := λ _ _ _ f g, { hom := f.hom ≫ g.hom },
  id   := λ B, { hom := 𝟙 B.X } }

namespace cones
@[simp] lemma id.hom   {F : J ↝ C} (c : cone F) : (𝟙 c : cone_morphism c c).hom = 𝟙 (c.X) := rfl
@[simp] lemma comp.hom {F : J ↝ C} {c d e : cone F} (f : c ⟶ d) (g : d ⟶ e) : ((f ≫ g) : cone_morphism c e).hom = (f : cone_morphism c d).hom ≫ (g : cone_morphism d e).hom := rfl

section
variables {D : Type u} [𝒟 : category.{u v} D]
include 𝒟

def functoriality (F : J ↝ C) (G : C ↝ D) : (cone F) ↝ (cone (F ⋙ G)) := 
{ obj      := λ A, { X := G A.X,
                     π := λ j, G.map (A.π j), 
                     w := begin /- `obviously'` says: -/ intros, simp, erw [←functor.map_comp, cone.w] end },
  map'     := λ X Y f, { hom := G.map f.hom,
                         w' := begin /- `obviously'` says: -/ intros, dsimp, erw [←functor.map_comp, cone_morphism.w] end } }
end
end cones

structure cocone_morphism (A B : cocone F) :=
(hom : A.X ⟶ B.X)
(w'  : Π j : J, (A.ι j) ≫ hom = (B.ι j) . obviously)

restate_axiom cocone_morphism.w'
attribute [simp,ematch] cocone_morphism.w

namespace cocone_morphism
-- @[simp,ematch] def commutativity_lemma_assoc {A B : cocone F} (c : cocone_morphism A B) (j : J) {Z : C} (z : B.X ⟶ Z): (A.ι j) ≫ c.hom ≫ z = (B.ι j) ≫ z :=
-- begin
--   -- `obviously'` says:
--   erw [←category.assoc, cocone_morphism.w]
-- end

@[extensionality] lemma ext {A B : cocone F} {f g : cocone_morphism A B} (w : f.hom = g.hom) : f = g :=
begin 
  induction f,
  induction g,
  -- `obviously'` says:
  dsimp at *,
  induction w,
  refl,
end
end cocone_morphism

instance cocones (F : J ↝ C) : category.{(max u v) v} (cocone F) := 
{ hom  := λ A B, cocone_morphism A B,
  comp := λ _ _ _ f g, { hom := f.hom ≫ g.hom },
  id   := λ B,         { hom := 𝟙 B.X } }

namespace cocones
@[simp] lemma id.hom   {F : J ↝ C} (c : cocone F) : (𝟙 c : cocone_morphism c c).hom = 𝟙 (c.X) := rfl
@[simp] lemma comp.hom {F : J ↝ C} {c d e : cocone F} (f : c ⟶ d) (g : d ⟶ e) : ((f ≫ g) : cocone_morphism c e).hom = (f : cocone_morphism c d).hom ≫ (g : cocone_morphism d e).hom := rfl

section
variables {D : Type u} [𝒟 : category.{u v} D]
include 𝒟

def functoriality (F : J ↝ C) (G : C ↝ D) : (cocone F) ↝ (cocone (F ⋙ G)) := 
{ obj      := λ A,     { X    := G A.X,
                         ι     := λ j, G.map (A.ι j),
                         w   := begin /- `obviously'` says: -/ intros, simp, erw [←functor.map_comp, cocone.w] end },
  map'     := λ _ _ f, { hom := G.map f.hom,
                         w'  := begin /- `obviously'` says: -/ intros, dsimp, erw [←functor.map_comp, cocone_morphism.w] end } }
end
end cocones

section
variables [has_limits.{u v} C]
variables (F)

def limit.cone_morphism (c : cone F) : cone_morphism c (limit.cone F) := 
{ hom := (limit.universal_property F).lift c }

@[simp] lemma limit.cone_morphism_hom (c : cone F) : (limit.cone_morphism F c).hom = (limit.universal_property F).lift c := rfl
@[simp] lemma limit.cone_morphism_π (c : cone F) (j : J) : (limit.cone_morphism F c).hom ≫ (limit.π F j) = c.π j :=
(limit.universal_property F).fac c j

def limit.hom
  (X : C) (π : Π j : J, X ⟶ F j) 
  (w : Π (j j' : J) (f : j ⟶ j'), π j ≫ F.map f = π j') : 
  X ⟶ (limit F) :=
(limit.cone_morphism F { X := X, π := π, w := w }).hom
end

end category_theory.universal

namespace category_theory.functor

universes u v
variables {J : Type v} [small_category J]
variables {C : Type u} [category.{u v} C] {D : Type u} [category.{u v} D]
variables {F : J ↝ C} {G : J ↝ C}

open category_theory.universal

def map_cone   (H : C ↝ D) (c : cone F)   : cone (F ⋙ H)   := (cones.functoriality F H) c
def map_cocone (H : C ↝ D) (c : cocone F) : cocone (F ⋙ H) := (cocones.functoriality F H) c
def map_cone_morphism   (H : C ↝ D) {c c' : cone F}   (f : cone_morphism c c')   : cone_morphism   (H.map_cone c)   (H.map_cone c')   := (cones.functoriality F H).map f
def map_cocone_morphism (H : C ↝ D) {c c' : cocone F} (f : cocone_morphism c c') : cocone_morphism (H.map_cocone c) (H.map_cocone c') := (cocones.functoriality F H).map f

end category_theory.functor