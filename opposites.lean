-- Copyright (c) 2017 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Stephen Morgan, Scott Morrison

import .category

open tqft.categories

namespace tqft.categories

definition Opposite ( C : Category ) : Category :=
{
    Obj := C^.Obj,
    Hom := λ X Y, C Y X,
    compose  := λ _ _ _ f g, C^.compose g f,
    identity := λ X, C^.identity X,
    left_identity  := ♮,
    right_identity := ♮,
    associativity  := begin blast, begin[smt] eblast_using [ Category.associativity ] end end
}

end tqft.categories