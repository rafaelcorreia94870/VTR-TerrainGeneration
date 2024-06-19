uniform sampler2D biome_map;
uniform float biome_scale_on_terrain;
vec4 biomePicker(vec3 p) {

    /*
    dry
    tundra:    (0.7, 0.7, 1.0)
    grassland: (0.6, 0.8, 0.1)
    desert:    (1.0, 1.0, 0.0)

    moderate
    ocean:     (0.0, 0.0, 0.6)
    forest:    (0.1, 0.6, 0.1)
    savanna:   (1.0, 0.7, 0.0)

    wet
    jungle:    (0.3, 0.4, 0.1)
    ocean:     (0.0, 0.0, 0.6)
    */
    vec4 water = vec4(0.0, 0.0, 1.0, 1.0);
	vec4 sand = vec4(0.93, 0.79, 0.69, 1.0);
	vec4 grass = vec4(0.188, 0.388, 0.165, 1.0);
    vec4 jungle_grass = vec4(0.204, 0.486, 0.173,1.0);
    vec4 tundra_grass = vec4(0.612, 0.506, 0.188, 1.0);
    vec4 savanna_grass = vec4(0.8, 0.6, 0.2, 1.0);
	vec4 rock = vec4(0.176, 0.173, 0.173,1.0);
	vec4 snow = vec4(1.0, 1.0, 1.0, 1.0);
	vec4 dirt = vec4(0.522, 0.31, 0.149, 1.0);

	// get biome color from biome map
	vec4 biomeColor = biomeColor(p, biome_map, biome_scale_on_terrain);

	float terrainHeight = p.y;
	float maxHeight = heightmult * initAmplitude;
	float waterHeight = height;
	float normalizedHeight = clamp((terrainHeight - waterHeight) / maxHeight, 0.0, 1.0);

    // if biomeColor z is 0.6 then it is ocean and the biome color is sand
    if (biomeColor.z == 0.6) {
        return sand;
    }
    // tundra
    else if (biomeColor.z == 1.0) {
        if (normalizedHeight < 0.2) {
            return mix(sand, dirt, normalizedHeight * 5.0);
        } else if (normalizedHeight < 0.4) {
            return mix(dirt, grass, (normalizedHeight - 0.2) * 5.0);
        } else if (normalizedHeight < 0.9) {
            return mix(grass, rock, (normalizedHeight - 0.4) * 2.5);
        } else {
            return mix(rock, snow, (normalizedHeight - 0.9) * 10.0);
        }
    }
    //grassland
    else if (biomeColor.y == 0.8) {
        return grass;
    }
    //desert
    else if (biomeColor.y == 1.0) {
        return sand;
    }
    //forest
    else if(biomeColor.y == 0.6) {
        if (normalizedHeight < 0.2) {
            return mix(sand, dirt, normalizedHeight * 5.0);
        } else if (normalizedHeight < 0.4) {
            return mix(dirt, grass, (normalizedHeight - 0.2) * 5.0);
        } else if (normalizedHeight < 0.9) {
            return mix(grass, rock, (normalizedHeight - 0.4) * 2.5);
        } else {
            return mix(rock, snow, (normalizedHeight - 0.99) * 10.0);
        }
    }
    //savanna
    else if (biomeColor.z == 0.0 && biomeColor.x == 1.0) {
        if (terrainHeight < waterHeight) {
	    	return mix(sand, dirt, smoothstep(waterHeight , waterHeight + 0.1* maxHeight, terrainHeight));
	    }
	    else if (terrainHeight < waterHeight + 0.2* maxHeight) {
	    	return mix(dirt, tundra_grass, smoothstep(waterHeight - 0.01* maxHeight, waterHeight + 0.2* maxHeight, terrainHeight));
	    }
	    else {
	    	return mix(tundra_grass, rock, smoothstep(waterHeight + 0.2* maxHeight, waterHeight + 0.4*maxHeight, terrainHeight));
	    }
    }
    //jungle
    else if (biomeColor.y == 0.4) {
        if (terrainHeight < waterHeight) {
        	return mix(sand, dirt, smoothstep(waterHeight , waterHeight + 0.1* maxHeight, terrainHeight));
        }
        else if (terrainHeight < waterHeight + 0.2* maxHeight) {
        	return mix(dirt, jungle_grass, smoothstep(waterHeight - 0.01* maxHeight, waterHeight + 0.2* maxHeight, terrainHeight));
        }
        else {
        	return mix(jungle_grass, rock, smoothstep(waterHeight + 0.2* maxHeight, waterHeight + 0.4*maxHeight, terrainHeight));
        }
    }
    

    return vec4(1.0, 0.0, 0.0, 1.0);
	return biomeColor;
	/*
    // Interpolate colors based on normalized height
    if (normalizedHeight < 0.2) {
        return mix(sand, dirt, normalizedHeight * 5.0);
    } else if (normalizedHeight < 0.4) {
        return mix(dirt, grass, (normalizedHeight - 0.2) * 5.0);
    } else if (normalizedHeight < 0.9) {
        return mix(grass, rock, (normalizedHeight - 0.4) * 2.5);
    } else {
        return mix(rock, snow, (normalizedHeight - 0.99) * 10.0);
    }
	*/
	/* old one
	if (terrainHeight < waterHeight) {
		return mix(sand, dirt, smoothstep(waterHeight , waterHeight + 0.1* maxHeight, terrainHeight));
	}
	else if (terrainHeight < waterHeight + 0.2* maxHeight) {
		return mix(dirt, grass, smoothstep(waterHeight - 0.01* maxHeight, waterHeight + 0.2* maxHeight, terrainHeight));
	}
	else if (terrainHeight < waterHeight + 0.4*maxHeight) {
		return mix(grass, rock, smoothstep(waterHeight + 0.2* maxHeight, waterHeight + 0.4*maxHeight, terrainHeight));
	}
	else if (terrainHeight < waterHeight + 0.9* maxHeight) {
		return mix(rock, snow, smoothstep(waterHeight + 0.6*maxHeight, waterHeight + 0.9* maxHeight, terrainHeight));
	}
	else {
		return snow;
	}*/
}