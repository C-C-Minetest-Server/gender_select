## How should I mention you? He, she, or something else?
This mod is here to ask the user what their gender (identity) or the preferred pronoun is. It's important to ask before using any pronouns to avoid doubts, such as accidentally using the wrong one.

### API
In this section,
* `player` can either be a name or a player object.

#### `gender_select.get_gender(player)`
Ask for a player's preferred pronoun.

The first returned value can be `"M"` (Male), `"F"` (Female), or `"N"` (neutral pronouns preferred). If the player did not specified any, `"N"` will be returned as a fallback.

The second returned value can only be either `"M"` or `"F"`. This value is for situations that cannot make use of neutral pronouns, and modders should not use this method whenever possible. If the player did not specified any, `nil` will be returned. The mod has the responsiblity to handle such an exception.

#### `gender_select.get_gender_MF(player)`
Return only the second returned value of `gender_select.get_gender`.

#### `gender_select.set_gender(player,genderMF[,neutral])`
Set a player's preferred pronoun. the `genedr` field can either be `"M"`, `"F"`, or `nil`. If `nil`, the preferred gender of the player will be unset. If `neutral` is set, neutral pronoun will be used whenever possible.

#### `gender_select.open_gender_dialog(player)`
Allow the player to choose their preferred pronoun by using a formspec. This only works if the [`flow`](https://content.minetest.net/packages/luk3yx/flow/) mod is installed and the player specified is online.

If the dialog is successfully opened, `true` is returned as the only returned value. If not, `false` is returned as the first value and one of the following is returned as the second:
* `"DEPENDENCY"`: The `flow` mod is not installed. This will always be returned even if the player is offline.
* `"OFFLINE"`: The player is offline, and so the dialog cannot be opened. This also returns if the provided player field is not a valid one.

Because of the limitations of the API, we cannot notify other mods about the result of the dialog. Unless otherwise specified, in case of failed calls, `false` will be returned.

### Variables
#### `gender_select.version`
The version ID indicating API features. This number is increased on every changes that touched the behaviour of the APIs. Mods can then check the compactibility by comparing this value to the target version.

Ideally, all changes should be backward-compactible, so mods should only check for a lower limit of this variable.

#### `gender_select.gui`
The `flow` GUI object of the dialog. Only present if `flow` is installed.

### License
All the codes are under MIT License. The textures are under public domain.
