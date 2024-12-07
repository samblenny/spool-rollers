// SPDX-License-Identifier: CC-BY-SA-4.0
// SPDX-FileCopyrightText: Copyright 2024 Sam Blenny
use <press-fit-post.scad>

diameters = [7.78, 7.80, 7.82, 7.83];
chamfer = 1;
post_spacing = 18;

module posts() {
    translate([0,0,5])
    rotate([45,0,0])
    for(i=[0:len(diameters)-1]) {
        d = diameters[i];
        r = d / 2;
        translate([i*post_spacing,0,0])
        press_fit_post(
            diameter=d,
            height=6,
            chamfer=chamfer,
            label=true,
            $fn=40
        );
    }
}

// This extrudes a beam having a polygon cross section that's shaped
// like a truncated and chamfered right triangle, kinda like this:
//
//         C__
//        /   \
//       /     |
//      /      |
//    A/   B   |
//    |        |
//     \______/
//
// Inside of all the chamfering, there is a right triangle, ABC, with
// its long side at a 45 degree angle. That side, when extruded, makes
// the 45 degree plane that the posts attach to. Printing the posts at
// a 45 degree angle makes them much less likely to snap under load.
module base_bar() {
    translate([-10,-5,0.1])
    rotate([90,0,0])
    rotate([0,90,0])
    linear_extrude(4*post_spacing + 3)
    polygon([
        [0,-1], [1,-2],
        [10,-2], [11, -1],
        [11, 8], [10, 9], [9, 9], [0, 0]
    ]);
}

union() {
    posts();
    base_bar();
}
