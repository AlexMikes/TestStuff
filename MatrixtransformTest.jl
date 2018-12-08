using Rotations, StaticArrays

n1 = [0 -(3/5) (4/5)]

n2 = [1 0 0]

n3 = [0 (4/5) (3/5)]

r = [n1; n2; n3].'

r_xyz = RotXYZ(r)

r_ang = RotXYZ{r_xyz}

r_rot = RotXYZ(-0.9279725, 0.0, -1.5708)

r_x = RotX(-0.927295)

r_x = RotX(-0.927295)

aa = AngleAxis(r)
rv = RodriguesVec(r)
ϕ = rotation_angle(r)
v = rotation_axis(r)

id = RotMatrix{3, Float64}

RotX(r)
