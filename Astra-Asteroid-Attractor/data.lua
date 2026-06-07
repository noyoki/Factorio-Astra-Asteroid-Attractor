
local asteroidbeacontech = {
	type = "technology",
	name = "astra-asteroid-attractor",
	icon = "__Astra-Asteroid-Attractor/graphics/FFF339BeaconGraphics.png",
	effects ={{type="unlock-recipe",recipe="astra-asteroid-attractor"}},
    prerequisites={"effect-transmission","asteroid-collector"},
	unit ={count = 500,ingredients ={{"automation-science-pack", 1},{"logistic-science-pack",1},{"chemical-science-pack",1}
    ,{"production-science-pack",1},{"space-science-pack",1}},time = 30}
}


local asteroidbeaconitem = table.deepcopy(data.raw.item["beacon"])
asteroidbeaconitem.name = "astra-asteroid-attractor"
asteroidbeaconitem.type = "item"
asteroidbeaconitem.icon = "__Astra-Asteroid-Attractor/graphics/FFF339BeaconGraphics.png"
asteroidbeaconitem.stack_size = 5
asteroidbeaconitem.subgroup = "space-platform"
asteroidbeaconitem.order = "zzzzz"


local asteroidbeaconentity = table.deepcopy(data.raw.entity["beacon"])
asteroidbeaconentity.name="astra-asteroid-attractor"
asteroidbeaconentity.icon = "__Astra-Asteroid-Attractor/graphics/FFF339BeaconGraphics.png"
asteroidbeaconentity.energy_usage = "20MW"
asteroidbeaconentity.allowed_effects = {}
asteroidbeaconentity.module_slots = 0
asteroidbeaconentity.distribution_effectivity = 0
asteroidbeaconentity.supply_area_distance = 0
asteroidbeaconentity.minable.results = {{type="item", name="astra-asteroid-attractor",amount=1}}
asteroidbeaconentity.surface_conditions = {{property = "gravity", min=0, max=0}}


local asteroidbeaconrecipe = table.deepcopy(data.raw.recipe["asteroid-collector"])
asteroidbeaconrecipe.name = "astra-simple-asteroid-collector"
asteroidbeaconrecipe.icon = "__space-age__/graphics/icons/FFF339BeaconGraphics.png"
asteroidbeaconrecipe.results = {{type="item",name="astra-asteroid-attractor",amount=1}}
asteroidbeaconrecipe.ingredients ={{type="item",name="processing-unit",amount=20},{type="item",name="advanced-circuit",amount=20},
{type="item",name="electric-engine-unit", amount=10},{type="item",name="low-density-structure", amount=10}}



data:extend({asteroidbeacontech, asteroidbeaconitem, asteroidbeaconentity, asteroidbeaconrecipe})




