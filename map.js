var mapping_1 = [
    [2, 0],
    [111.2752, 702.925232],
];

var mapping_2 = [
    [6, 0],
    [312.594971, 702.925232],
];

var mapping_3 = [
    [7, 5],
    [338.620758, 462.924042],
];

var mapping_4 = [
    [11, 5],
    [548.495422, 462.997681],
];

var mapping_5 = [
    [12, 8],
    [581.971741, 318.925262],
];

var mapping_6 = [
    [14, 8],
    [707.144226, 318.925262],
];

function get_converters(mapping_1, mapping_6) {
    mapping_1[1][1] *= -1;
    mapping_6[1][1] *= -1;

    var dx_excel = mapping_6[0][0] - mapping_1[0][0]
    var dx_godot = mapping_6[1][0] - mapping_1[1][0]

    var dy_excel = mapping_6[0][1] - mapping_1[0][1]
    var dy_godot = mapping_6[1][1] - mapping_1[1][1]

    var godot_x_multiplier = dx_godot/dx_excel
    var godot_y_multiplier = dy_godot/dy_excel

    var godot_x1_simulated = godot_x_multiplier * mapping_1[0][0]
    var godot_y1_simulated = godot_y_multiplier * mapping_1[0][1]

    var godot_x1_diversion = godot_x1_simulated - mapping_1[1][0]
    var godot_y1_diversion = godot_y1_simulated - mapping_1[1][1]

    function formula_translate_x_from_excel(x) {
        return godot_x_multiplier * x - godot_x1_diversion
    }
    function formula_translate_y_from_excel(y) {
        return godot_y_multiplier * y - godot_y1_diversion
    }
    return {
        formula_translate_x_from_excel,
        formula_translate_y_from_excel
    }
}

const converters = get_converters(mapping_1, mapping_6)
console.log(mapping_1[0][0], converters.formula_translate_x_from_excel(mapping_1[0][0]), mapping_1[1][0])
console.log(mapping_1[0][1], converters.formula_translate_y_from_excel(mapping_1[0][1]), mapping_1[1][1])

