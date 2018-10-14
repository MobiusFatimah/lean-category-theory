import category_theory.limits

universes u v

open category_theory
open category_theory.limits

namespace category_theory.universal.types

local attribute [forward] fork.w square.w

instance : has_terminal_object.{u+1 u} (Type u) :=
{ terminal := punit }

@[simp] lemma types_terminal : (terminal (Type u)) = punit := rfl
@[simp] lemma types_terminal_π (α : Type u) : (terminal.π α) = λ a, punit.star := by obviously

instance : has_binary_products.{u+1 u} (Type u) :=
{ prod := λ Y Z, { X := Y × Z, π₁ := prod.fst, π₂ := prod.snd } }

@[simp] lemma types_prod (Y Z : Type u) : limits.prod Y Z = (Y × Z) := rfl
@[simp] lemma types_prod_π₁ (Y Z : Type u) : limits.prod.π₁ Y Z = prod.fst := rfl.
@[simp] lemma types_prod_π₂ (Y Z : Type u) : limits.prod.π₂ Y Z = prod.snd := rfl.
@[simp] lemma types_prod_swap (Y Z : Type u) : limits.prod.swap Y Z = λ p : Y × Z, (p.2, p.1) := rfl
@[simp] lemma types_prod_map {Y Y' Z Z' : Type u} (f : Y ⟶ Y') (g : Z ⟶ Z') : limits.prod.map f g = λ p : Y × Z, (f p.1, g p.2) := rfl
@[simp] lemma types_prod_lift {X Y Z : Type u} (f : X ⟶ Y) (g : X ⟶ Z):
  limits.prod.lift f g = λ x, (f x, g x) := rfl

instance : has_products.{u+1 u} (Type u) :=
{ prod := λ β f, { X := Π b, f b, π := λ b x, x b } }.

@[simp] lemma types_pi {β : Type u} (f : β → Type u) : pi f = Π b, f b := rfl
@[simp] lemma types_pi_π {β : Type u} (f : β → Type u) (b : β) : pi.π f b = λ (g : Π b, f b), g b := rfl.
@[simp] lemma types_pi_pre {β α : Type u} (f : α → Type u) (g : β → Type u) (h : β → α) :
  pi.pre f h = λ (d : Π a, f a), λ b, d (h b) := rfl
@[simp] lemma types_pi_map {β : Type u} (f : β → Type u) (g : β → Type u) (k : Π b, f b ⟶ g b) :
  pi.map k = λ (d : Π a, f a), (λ (b : β), k b (d b)) := rfl
@[simp] lemma types_pi_lift {β : Type u} (f : β → Type u) {P : Type u} (p : Π b, P ⟶ f b) :
  pi.lift p = λ q b, p b q := rfl

set_option trace.tidy true
attribute [extensionality] subtype.eq

instance : has_equalizers.{u+1 u} (Type u) :=
{ equalizer := λ Y Z f g, { X := { y : Y // f y = g y }, ι := subtype.val } }

instance : has_pullbacks.{u+1 u} (Type u) :=
{ pullback := λ Y₁ Y₂ Z r₁ r₂,
  { X := { z : Y₁ × Y₂ // r₁ z.1 = r₂ z.2 },
    π₁ := λ z, z.val.1,
    π₂ := λ z, z.val.2 } }

instance : has_initial_object.{u+1 u} (Type u) :=
{ initial := pempty }

@[simp] lemma types_initial : (initial (Type u)) = pempty := rfl
@[simp] lemma types_initial_ι (α : Type u) : (initial.ι α) = pempty.rec _ := rfl

instance : has_binary_coproducts.{u+1 u} (Type u) :=
{ coprod := λ Y Z, { X := Y ⊕ Z, ι₁ := sum.inl, ι₂ := sum.inr } }

@[simp] lemma types_coprod (Y Z : Type u) : limits.coprod Y Z = (Y ⊕ Z) := rfl
@[simp] lemma types_coprod_ι₁ (Y Z : Type u) : limits.coprod.ι₁ Y Z = sum.inl := rfl.
@[simp] lemma types_coprod_ι₂ (Y Z : Type u) : limits.coprod.ι₂ Y Z = sum.inr := rfl.
@[simp] lemma types_coprod_swap (Y Z : Type u) : limits.coprod.swap Y Z = sum.swap := by obviously
@[simp] lemma types_coprod_map {Y Y' Z Z' : Type u} (f : Y ⟶ Y') (g : Z ⟶ Z') :
  limits.coprod.map f g = sum.map f g := by obviously
@[simp] lemma types_coprod_desc {X Y Z : Type u} (f : X ⟶ Z) (g : Y ⟶ Z):
  limits.coprod.desc f g = λ p, sum.rec f g p := rfl

instance : has_coproducts.{u+1 u} (Type u) :=
{ coprod := λ β f, { X := Σ b, f b, ι := λ b x, ⟨b, x⟩ } }.

@[simp] lemma types_Sigma {β : Type u} (f : β → Type u) : limits.Sigma f = Σ b, f b := rfl
@[simp] lemma types_Sigma_ι {β : Type u} (f : β → Type u) (b : β) : limits.Sigma.ι f b = λ p : f b, (⟨b, p⟩ : Σ b, f b) := rfl
@[simp] lemma types_Sigma_pre {β α : Type u} (f : α → Type u) (h : β → α) :
  limits.Sigma.pre f h = λ (d : Σ b, f (h b)), (⟨h d.1, d.2⟩ : Σ a, f a) := by obviously
@[simp] lemma types_sigma_map {β : Type u} (f : β → Type u) (g : β → Type u) (k : Π b, f b ⟶ g b) :
  limits.Sigma.map k = λ (d : Σ b, f b), ⟨d.1, k d.1 d.2⟩ := by obviously
@[simp] lemma types_sigma_desc {β : Type u} (f : β → Type u) {P : Type u} (p : Π b, f b ⟶ P) :
  limits.Sigma.desc p = (λ d : Σ b, f b, p d.1 d.2) := by obviously

local attribute [elab_with_expected_type] quot.lift

def pushout {Y₁ Y₂ Z : Type u} (r₁ : Z ⟶ Y₁) (r₂ : Z ⟶ Y₂) : cosquare r₁ r₂ :=
{ X := @quot (Y₁ ⊕ Y₂) (λ p p', ∃ z : Z, p = sum.inl (r₁ z) ∧ p' = sum.inr (r₂ z) ),
  ι₁ := λ o, quot.mk _ (sum.inl o),
  ι₂ := λ o, quot.mk _ (sum.inr o),
  w' := funext $ λ z, quot.sound ⟨ z, by tidy ⟩, }.

def pushout_is_pushout {Y₁ Y₂ Z : Type u} (r₁ : Z ⟶ Y₁) (r₂ : Z ⟶ Y₂) : is_pushout (pushout r₁ r₂) :=
{ desc := λ s, quot.lift (λ o, sum.cases_on o s.ι₁ s.ι₂)
            (assume o o' ⟨z, hz⟩, begin rw hz.left, rw hz.right, dsimp, exact congr_fun s.w z end) }

instance : has_pushouts.{u+1 u} (Type u) :=
{ pushout := @pushout, is_pushout := @pushout_is_pushout }

def coequalizer {Y Z : Type u} (f g : Y ⟶ Z) : cofork f g :=
{ X := @quot Z (λ z z', ∃ y : Y, z = f y ∧ z' = g y),
  π := λ z, quot.mk _ z,
  w' := funext $ λ x, quot.sound ⟨ x, by tidy ⟩ }.

def coequalizer_is_coequalizer {Y Z : Type u} (f g : Y ⟶ Z) : is_coequalizer (coequalizer f g) :=
{ desc := λ s, quot.lift (λ (z : Z), s.π z)
    (assume z z' ⟨y, hy⟩, begin rw hy.left, rw hy.right, exact congr_fun s.w y, end) }

instance : has_coequalizers.{u+1 u} (Type u) :=
{ coequalizer := @coequalizer, is_coequalizer := @coequalizer_is_coequalizer }

variables {J : Type u} [𝒥 : small_category J]
include 𝒥

def limit (F : J ⥤ Type u) : cone F :=
{ X := {u : Π j, F j // ∀ (j j' : J) (f : j ⟶ j'), F.map f (u j) = u j'},
  π := λ j u, u.val j }

set_option trace.tidy true

def limit_is_limit (F : J ⥤ Type u) : is_limit (limit F) :=
{ lift := λ s v, ⟨λ j, s.π j v, λ j j' f, congr_fun (s.w f) _⟩,
  uniq' := by obviously }

instance : has_limits.{u+1 u} (Type u) :=
{ limit := @limit, is_limit := @limit_is_limit }

@[simp] lemma types_limit (F : J ⥤ Type u) :
  limits.limit F = {u : Π j, F j // ∀ j j' f, F.map f (u j) = u j'} := rfl
@[simp] lemma types_limit_π (F : J ⥤ Type u) (j : J) :
  limit.π F j = λ g : (limit F).X, g.val j := rfl.
@[simp] lemma types_limit_pre (F : J ⥤ Type u) {K : Type u} [𝒦 : small_category K] (E : K ⥤ J) :
  limit.pre F E = λ g : (limit F).X, (⟨ λ k, g.val (E k), by obviously ⟩ : (limit (E ⋙ F)).X) := rfl
@[simp] lemma types_limit_map {F G : J ⥤ Type u} (α : F ⟹ G) :
  lim.map α = λ g : (limit F).X, (⟨ λ j, (α j) (g.val j), by obviously ⟩ : (limit G).X) := rfl
@[simp] lemma types_limit_lift (F : J ⥤ Type u) (c : cone F) :
  limit.lift F c = λ x, (⟨ λ j, c.π j x, λ j j' f, congr_fun (c.w f) x ⟩ : (limit F).X) := rfl

def colimit (F : J ⥤ Type u) : cocone F :=
{ X := @quot (Σ j, F j) (λ p p', ∃ f : p.1 ⟶ p'.1, p'.2 = F.map f p.2),
  ι := λ j x, quot.mk _ ⟨j, x⟩,
  w' := λ j j' f, funext $ λ x, eq.symm (quot.sound ⟨f, rfl⟩) }

def colimit_is_colimit (F : J ⥤ Type u) : is_colimit (colimit F) :=
{ desc := λ s, quot.lift (λ (p : Σ j, F j), s.ι p.1 p.2)
    (assume ⟨j, x⟩ ⟨j', x'⟩ ⟨f, hf⟩,
      by rw hf; exact (congr_fun (s.w f) x).symm) }

instance : has_colimits.{u+1 u} (Type u) :=
{ colimit := @colimit, is_colimit := @colimit_is_colimit }

@[simp] lemma types_colimit (F : J ⥤ Type u) : limits.colimit F = @quot (Σ j, F j) (λ p p', ∃ f : p.1 ⟶ p'.1, p'.2 = F.map f p.2) := rfl
@[simp] lemma types_colimit_ι (F : J ⥤ Type u) (j : J) : colimit.ι F j = λ x, quot.mk _ (⟨j, x⟩ : (Σ j, F j)) := rfl.
-- TODO remaining lemmas:
-- @[simp] lemma types_colimit_pre (F : J ⥤ Type u) {K : Type u} [𝒦 : small_category K] (E : K ⥤ J) :
--   colimit.pre F E = λ g : (colimit (E ⋙ F)).X, sorry := sorry
-- @[simp] lemma types_colimit_map {F G : J ⥤ Type u} (α : F ⟹ G) :
--   colim.map α = λ g : (colimit F).X, sorry := sorry
-- @[simp] lemma types_colimit_lift (F : J ⥤ Type u) (c : cocone F) :
--   colimit.desc F c = λ x, sorry := sorry

end category_theory.universal.types
