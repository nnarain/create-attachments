//
// iRobot Create 2 Deco Cover
//
// @author Natesh Narain
//
include <deco-cover-spec.scad>

bind = 0.01;

module plate() {
    difference() {
        cylinder(r=deco_radius(), h=deco_thickness(), center=true);
        // Center hole
        cylinder(r=deco_center_hole_radius(), h=deco_thickness() + bind, center=true);
        // Left mounting holes
        translate([deco_mounting_hole_offset_left()[0], deco_mounting_hole_offset_left()[1], 0])
            mounting_holes(deco_mounting_holes(), 0);
        // Right mounting holes
        translate([deco_mounting_hole_offset_right()[0], deco_mounting_hole_offset_right()[1], 0])
            mounting_holes(deco_mounting_holes(), 180);
    }
}

module mounting_holes(positions, z_rot) {
    rotate([0, 0, z_rot])
    union() {
        for (p = positions) {
            translate([p[0], p[1], 0])
                cylinder(r=deco_mounting_hole_radius(), h=deco_thickness() + bind, center=true);
        }
    }
}

module deco_cover() {
    color([0/255, 255/255, 0/255])
        plate();
}

// if ($preview)
//     deco_cover();
