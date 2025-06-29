module Icosahedron

using SpaceGroups, StaticArrays

export PI, PIh, PI_n, PIh_n, τ, epar;

# Golden mean
const τ=(sqrt(5)+1)/2

# Parallel space
const epar=(SA[1 τ 0 -1 τ 0; τ 0 1 τ 0 -1; 0 1 τ 0 -1 τ])/sqrt(1+τ^2)
# Perp space
const eper=(SA[-τ 1 0 τ 1 0; 1 0 -τ 1 0 τ; 0 -τ 1 0 τ 1])/sqrt(1+τ^2)

# Three-fold rotation
r3=[0 0 1 0 0 0;
    1 0 0 0 0 0;
    0 1 0 0 0 0;
    0 0 0 0 0 1;
    0 0 0 1 0 0;
    0 0 0 0 1 0]

# Five fold rotation
r5=[1 0 0 0 0 0;
    0 0 0 0 1 0;
    0 1 0 0 0 0;
    0 0 1 0 0 0;
    0 0 0 0 0 -1;
    0 0 0 -1 0 0]

# Central symmetry
c=[-1 0 0 0 0 0;
    0 -1 0 0 0 0;
    0 0 -1 0 0 0;
    0 0 0 -1 0 0;
    0 0 0 0 -1 0;
    0 0 0 0 0 -1]

# Translations for non-symmorphic icosahedral groups
t1=[1//5, 0//1, -1//5, 0//1, 0//1, -1//5]
t2=[0//1, 0//1, 0//1, 0//1, 1//2, -1//2]

# Rotations
s3=@SGE(r3)
s5=@SGE(r5)

# Central symmetry
sc=@SGE(c)

# Non-symmorphic operations
s5_1=@SGE(r5,t1)
s5_2=@SGE(r5,t2)

const PI=SpaceGroupQuotient([s3,s5])
const PIh=SpaceGroupQuotient([s3,s5,sc])
const PI_n=SpaceGroupQuotient([s3,s5_1])
const PIh_n=SpaceGroupQuotient([s3, s5_2, sc])

end
