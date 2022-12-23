## How should I mention you? He, she, or something else?
This mod is here to ask the user what their gender (identity) or the preferred pronoun is. It's important to ask before using any pronouns to avoid doubts, such as accidentally using the wrong one.

### API
In this section,

* `player` can either be a name or a player object.
* Unless otherwise specified, in case of failed calls, `false` will be returned.
#### `gender_select.get_gender(player)`
Ask for a player's preferred pronoun.

The first returned value can be `"M"` (Male), `"F"` (Female), or `"N"` (neutral pronouns preferred). If the player did not specify any, `"N"` will be returned as a fallback.

The second returned value can only be either `"M"` or `"F"`. This value is for situations that cannot make use of neutral pronouns, and modders should not use this method whenever possible. If the player did not specify any, `nil` will be returned. The mod has the responsibility to handle such an exception.

#### `gender_select.get_gender_MF(player)`
Return only the second returned value of `gender_select.get_gender`.

#### `gender_select.set_gender(player,genderMF[,neutral])`
Set a player's preferred pronoun. the `gender` field can either be `"M"`, `"F"`, or `nil`. If `nil`, the preferred gender of the player will be unset. If `neutral` is set, neutral pronoun will be used whenever possible.

#### `gender_select.open_gender_dialog(player)`
Allow the player to choose their preferred pronoun by using a formspec. This only works if the [`flow`](https://content.minetest.net/packages/luk3yx/flow/) mod is installed and the player specified is online.

If the dialogue is successfully opened, `true` is returned as the only returned value. If not, `false` is returned as the first value and one of the following is returned as the second:

* `"DEPENDENCY"`: The `flow` mod is not installed. This will always be returned even if the player is offline.
* `"OFFLINE"`: The player is offline, and so the dialogue cannot be opened. This also returns if the provided player field is not a valid one.

Because of the limitations of the API, we cannot notify other mods about the result of the dialogue.

### Variables
#### `gender_select.version`
The version ID indicating API features. This number is increased on every changes that touched the behaviour of the APIs. Mods can then check the compactibility by comparing this value to the target version.

Ideally, all changes should be backward-compactible, so mods should only check for a lower limit of this variable.

#### `gender_select.gui`
The `flow` GUI object of the dialog. Only present if `flow` is installed.

### Example usecases
#### In a dialogue
Let's see the following example:

> **\**A talking to B*\*:** __He__ is the person gave me an apple.

We, obviously, should not assume the player is a male, as well as a female. With this mod, checks can be done, and proper pronouns can be shown.

#### Player skin
In Genshin Impact, the [player](genshin-impact.fandom.com/wiki/Traveler)'s skin is determined by the user's choice. As the player's [in-game sibling](https://genshin-impact.fandom.com/wiki/Traveler%27s_Sibling) must not be the same gender as the player's, the choice also determines the gender of the sibling.

If a Minetest game is facing a similar situation, this mod can help to let the user choose the gender. The game can use `gender_select.get_gender_MF` (Male or Female) to determine the skin of the player and the gender of the sibling, and `gender_select.get_gender` (with the option to be neutral) to determine the pronoun.

### License
All the codes are under MIT License. The textures are under public domain.
