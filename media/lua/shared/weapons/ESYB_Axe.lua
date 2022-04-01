ESYB.Dict.Axe = {
    ["Base.Axe"] = {
        vanillaCMax = nil,
        bladeDurability = 1.4, -- abrasion chance
        bladeHardness = 1.2, -- bluntening chance
        equippedIconLeft = false,
        -- VANILLA
        -- MinDamage	=	0.8,
        -- MaxDamage	=	2,
        -- CriticalChance	=	20,
        -- CritDmgMultiplier = 5,
        -- DoorDamage	=	35,
        -- TreeDamage  =   35,
        levels = {
            [0] = {
                maxSharpness = 0,
                MinDamage = 0.3,
                MaxDamage = 1.0,
                CriticalChance = 4,
                CritDmgMultiplier = 2,
                TreeDamage = 5,
                DoorDamage = 5
            },
            [1] = {
                maxSharpness = 20,
                MinDamage = 0.5,
                MaxDamage = 1.3,
                CriticalChance = 8,
                CritDmgMultiplier = 2,
                TreeDamage = 15,
                DoorDamage = 15
            },
            [2] = {
                maxSharpness = 40,
                MinDamage = 0.6,
                MaxDamage = 1.5,
                CriticalChance = 12,
                CritDmgMultiplier = 3,
                TreeDamage = 25,
                DoorDamage = 25
            },
            [3] = {
                maxSharpness = 60,
                MinDamage = 0.7,
                MaxDamage = 1.8,
                CriticalChance = 16,
                CritDmgMultiplier = 4,
                TreeDamage = 30,
                DoorDamage = 30
            },
            -- VANILLA
            -- MinDamage	=	0.8,
            -- MaxDamage	=	2,
            -- CriticalChance	=	20,
            -- CritDmgMultiplier = 5,
            -- DoorDamage	=	35,
            -- TreeDamage  =   35,
            [4] = {
                maxSharpness = 80,
                MinDamage = 0.8,
                MaxDamage = 2,
                CriticalChance = 20,
                CritDmgMultiplier = 5,
                TreeDamage = 35,
                DoorDamage = 35
            },
            [5] = {
                maxSharpness = 100,
                MinDamage = 1.0,
                MaxDamage = 2.3,
                CriticalChance = 25,
                CritDmgMultiplier = 6,
                TreeDamage = 40,
                DoorDamage = 40
            }
        }
    }
}
