# CB Filter — Colorblind Accessibility Module for Roblox

A Roblox in-experience accessibility module that applies colorblind simulation filters to help players with color vision deficiencies enjoy games more comfortably.

I built this project to make gaming more accessible, productive, and enjoyable for players with color vision deficiencies. This was heavily motivated by my own experience as a Roblox player. I love the platform, but game creators often do not include accessibility settings, partly because Roblox Studio's built-in tools make it difficult to implement them.

CB Filter aims to lower that barrier by giving any Roblox developer a ready-made accessibility module they can drop into their game with minimal setup, so players who need colorblind support do not have to go without it.

---

## Features

- 6 colorblind filter modes:
  - None — default, no filter
  - Deuteranopia — red-green color blindness (green deficiency)
  - Protanopia — red-green color blindness (red deficiency)
  - Tritanopia — blue-yellow color blindness
  - Achromatopsia — full color blindness (greyscale)
  - Anomalous Trichromacy — mild color deficiency
- Adjustable filter strength via vertical slider (0-100%)
- Persistent preferences — settings save on respawn via Roblox DataStore
- Clean, semi-transparent dark teal UI with rounded corners
- Toggle menu via a CB button on the left side of the screen

---

## How to Install

1. Open Roblox Studio
2. Copy the AccessibilityModule folder into your game's ReplicatedStorage
3. Copy AccessibilityClient into StarterPlayer > StarterPlayerScripts
4. Copy DataManager into ServerScriptService
5. Enable API Services under File > Game Settings > Security
6. Publish your game and play

---

## How to Use

1. Join the game
2. Click the CB button on the left side of the screen
3. Select a colorblind filter from the menu
4. Use the Strength slider to adjust the intensity
5. Your settings will be remembered even when your character respawns

---

## The Science Behind It

Color blindness affects approximately 8% of men and 0.5% of women worldwide. It is caused by missing or malfunctioning cone cells in the eye that detect red, green, or blue light.

This module simulates the visual experience of different types of color blindness using Roblox's ColorCorrectionEffect, adjusting:
- TintColor — shifts the overall color temperature
- Saturation — reduces color vividness
- Contrast — adjusts color distinction
- Brightness — compensates for perceived lightness changes

The color values are inspired by research from:
- Brettel, Vienot and Mollon (1997) — Computerized simulation of color appearance for dichromats
- Vienot, Brettel and Mollon (1999) — Digital video colourmaps for checking the legibility of displays by dichromats
- Machado, Oliveira and Fernandes (2009) — A Physiologically-based Model for Simulation of Color Vision Deficiency

---

## Known Limitations and Future Work

### Current Limitations
- Unlike Unity where we have access to devloping custom shaders, Roblox processess everything through its own render, meaning developers cannot manipulate how the pixels are represented on the screen. Roblox's ColorCorrectionEffect does not support full RGB color transformation matrices, limiting simulation accuracy.
- A truly accurate colorblind simulation requires per-pixel color transformation, for example Deuteranopia's transformation matrix is:
  - R' = 0.625R + 0.375G + 0.000B
  - G' = 0.700R + 0.300G + 0.000B
  - B' = 0.000R + 0.300G + 0.700B
- Settings currently only persist on respawn, not between separate game sessions

### Future Work
- Implement proper RGB transformation matrices via custom shaders when Roblox expands its PostEffect API
- Add full cross-session DataStore persistence
- Add texture pattern overlays as a secondary accessibility layer so color is not the only visual signal

---

## References

- Brettel, H., Vienot, F., and Mollon, J. D. (1997). Computerized simulation of color appearance for dichromats. Journal of the Optical Society of America A, 14(10), 2647-2655.
- Machado, G. M., Oliveira, M. M., and Fernandes, L. A. (2009). A physiologically-based model for simulation of color vision deficiency. IEEE Transactions on Visualization and Computer Graphics, 15(6), 1291-1298.
- Coblis Color Blindness Simulator: https://www.color-blindness.com/coblis-color-blindness-simulator/