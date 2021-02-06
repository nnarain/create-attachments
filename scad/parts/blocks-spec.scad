include <../vitamins/deco-cover-spec.scad>

mounting_block_spec = [
    // Deco cover mounting holes                   (0)
    deco_mounting_holes(),
    // Padding bettwen the mounting holes and the edge of the block
    10,
    // Column height
    25,
    // Underside thickness
    3,
    // Fastener thickness
    25 + 10,
];

function mounting_block_holes() = mounting_block_spec[0];
function mounting_block_hole_padding() = mounting_block_spec[1];
function mounting_block_column_height() = mounting_block_spec[2];
function underside_thickness() = mounting_block_spec[3];
function fastener_thickness() = mounting_block_spec[4];
