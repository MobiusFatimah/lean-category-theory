import ring_theory.subring
import tactic.subtype_instance
import category_theory.examples.rings
import category_theory.limits.equalizers

universes u v w

namespace category_theory.examples

open category_theory
open category_theory.limits

variables {α : Type v}

-- @[simp] def bundled_hom_coe {c : Type u → Type v} (hom : ∀{α β : Type u}, c α → c β → (α → β) → Prop)
--   [h : concrete_category @hom] {R S : bundled c} (f : R ⟶ S) (r : R) : f r = f.val r := rfl
local attribute [extensionality] subtype.eq

def CommRing.equalizer {R S : CommRing} (f g : R ⟶ S) : CommRing :=
{ α := { r : R | f r = g r },
  str :=
  begin
    have h : is_subring { r : R | f r = g r } :=
    { one_mem := begin sorry end,
      zero_mem := begin sorry, end,
      mul_mem := begin sorry, end,
      add_mem := begin sorry, end,
      neg_mem := begin sorry, end },
    sorry, -- by subtype_instance, -- why doesn't this work?
  end }

@[simp] def CommRing.equalizer_ι {R S : CommRing} (f g : R ⟶ S) : CommRing.equalizer f g ⟶ R :=
{ val := λ x, x.val,
  property := begin tidy, sorry, sorry, sorry, end }

-- Is this kosher? Why isn't it already a simp lemma?
@[simp] lemma subtype.val_simp {α : Type u} {p : α → Prop} (a1 a2 : {x // p x}) : a1 = a2 ↔ a1.val = a2.val := by tidy


instance CommRing_has_equalizers : has_equalizers.{v+1 v} CommRing :=
{ equalizer := λ X Y f g,
  { X := CommRing.equalizer f g,
    ι := CommRing.equalizer_ι f g },
  is_equalizer := λ X Y f g,
  { lift := λ s, ⟨ λ x, ⟨ s.ι x, begin have h := congr_fun (congr_arg subtype.val s.w) x, exact h, end ⟩,
                   begin
                     tidy,
                     erw [is_ring_hom.map_one (s.ι)], sorry,
                     erw [is_ring_hom.map_mul (s.ι)], sorry,
                     erw [is_ring_hom.map_add (s.ι)], sorry
                   end ⟩,
    uniq' := begin tidy, end } }


end category_theory.examples