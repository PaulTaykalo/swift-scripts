# Unused
`unused.sh` Searches for unused swift functions at specified path

## Usage
```
cd <path-to-the-project>
<path-to-unused.sh>/unused.sh 
```

## Generated files
- `raw_functions.txt` - a list of all found (declared) functions 
- `filtered_functions.txt`- a list of all found functions filtered by some euristics like (override, @IBAction, testXXX)
- `unique_functions.txt`- unique functions names
- `usage.txt` - functions usage (ATM only functions that appeared once are shown)
- `sorted_usage.txt` - functions sorted by the usage (and name) 
- `delete_me.txt` - file that contains information about the function and where it is used

## output
```
Gathering functions
There are     1898 potential functions found
Gathering usage information
There are       32 potential functions to be deleted found
Gathering usage per each of them
It took 197 seconds.
```

## delete_me.txt
This is an example of how outptut can look like
```
---- selectionColor ----
ProjectPath/UIColorExtensions.swift-        return UIColor(red: 220.0/255, green: 220.0/255, blue: 220.0/255, alpha: 1)
ProjectPath/UIColorExtensions.swift-    }
ProjectPath/UIColorExtensions.swift-    
ProjectPath/UIColorExtensions.swift:    static func selectionColor() -> UIColor {
ProjectPath/UIColorExtensions.swift-        return UIColor(red: 240.0/255, green: 240.0/255, blue: 240.0/255, alpha: 1)
ProjectPath/UIColorExtensions.swift-    }
ProjectPath/UIColorExtensions.swift-     
```

## Known issues:
- Fully text search (no fancy stuff)
- A lot of false-positives (protocol functions and overrides)
- A lot of false-negatives (text search, yep)
