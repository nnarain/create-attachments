// Measurements of the Deco Cover

deco_cover_spec = [
    // Radius
    147.5,
    // Center hole radius
    73.5,
    // Thickness
    2,
    // Mounting holes (four hole cluster, centered on the origin)
    [
                  [0,  25],
        [-25, 0], [0,   0],
                  [0, -25]
    ],
    // Mounting hole radius
    2,
    // Offset of the mounting holes from the center of the plate
    [
        // Left
        [-90, -70],
        // Right
        [90, -70]
    ]
];

function deco_radius() = deco_cover_spec[0];
function deco_center_hole_radius() = deco_cover_spec[1];
function deco_thickness() = deco_cover_spec[2];
function deco_mounting_holes() = deco_cover_spec[3];
function deco_mounting_holes_length_y() = deco_mounting_holes()[0][1] + abs(deco_mounting_holes()[3][1]);
function deco_mounting_holes_length_x() = deco_mounting_holes()[2][0] + abs(deco_mounting_holes()[1][0]);
function deco_mounting_hole_radius() = deco_cover_spec[4];
function deco_mounting_hole_offset() = deco_cover_spec[5];
function deco_mounting_hole_offset_left() = deco_mounting_hole_offset()[0];
function deco_mounting_hole_offset_right() = deco_mounting_hole_offset()[1];
