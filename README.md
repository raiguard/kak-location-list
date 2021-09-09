# location-list.kak

In kakoune, there is no standard for location lists. Many scripts / plugins (including the built-in `grep.kak`) implement a goto kind of functionality, but it is not standardized whatsoever and is easily prone to breakage. `location-list.kak` aims to standardize these lists and provide a common interface for navigating and manipulating location lists.

## What is a location list?

A location list is a list of positions in files. These positions can be jumped to by pressing `enter` on the corresponding line in the location list buffer, or iterated with the various available commands.

Similar to vim, there will be a global location list and window location lists. The global location list spans the entire project, whereas a window list is specific to a window. They are iterated via commands with the `lg` and `lw` prefixes, respectively.

## How will they work?

Each location list is kept in a `range-specs` option and is formatted as `linestart.columnstart,lineend.columnend|FILENAME⤬⤬⤬preview` (e.g. `1.1,1.7|src/main.rs⤬⤬⤬kakoune`). Some tools might only output lines, in which case the ranges are defined as starting at column zero with a length equal to the line length. Kakoune automatically adjusts these ranges based on edits made, which will work to ensure that locations are not invalidated when file contents change.

Each location list also has an `index` option that corresponds to the current index the user has selected in the list.

### Example of options

If a list is created in `client0`, the following options are created:

```
lw_client0_index: 0
lw_client0_list: 1.1,1.7|src/main.rs⤬⤬⤬kakoune 2.6,2.12|src/main.rs⤬⤬⤬lorem kakoune ipsum
```

If those locations are added to the global list, it will look like this:

```
lg_index: 0
lw_list: 1.1,1.7|src/main.rs⤬⤬⤬kakoune 2.6,2.12|src/main.rs⤬⤬⤬lorem kakoune ipsum
```

### The buffer

You can open a location list in a special buffer. This buffer attempts to open in the toolsclient, but falls back to the current client if that does not exist. You may search and filter this buffer however you wish, but it is read-only in order to preserve line numbers (they correspond with the indices in the list). Pressing enter on a line will jump you to that location in the jumpclient.

For our above example, the buffer will look like this:

```
> src/main.rs:1:1 | kakoune
  src/main.rs:2:6 | lorem kakoune ipsum
```

By default, the preview includes the entire line. There might be options to change this in the future. The `>` in the buffer denotes the currently selected entry.

This buffer updates whenever the list does, so you always have the latest information.
