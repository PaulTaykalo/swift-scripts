# Unused
`unused.rb` Searches for unused swift functions, and variable at specified path

## Usage
```
cd <path-to-the-project>
<path-to-unused.sh>/unused.rb 
```

## Output
```
 Item< func loadWebViewTos [private] from:File.swift:23:0>
Total items to be checked 4276
Total unique items to be checked 1697
Starting searching globally it can take a while
 Item< func applicationHasUnitTestTargetInjected [] from:AnotherFile.swift:31:0>
 Item< func getSelectedIds [] from: AnotherFile.swift:82:0>
```

## Xcode integration
To integrate this into Xcode, simply add a "New Run Script Phase" and use the following code:
```
file="unused.rb"
if [ -f "$file" ]
then
echo "$file found."
ruby unused.rb xcode
else
echo "unused.rb doesn't exist"
fi
```
### Xcode ~/project/Build Phases:
<img width="500" alt="Screenshot 2024-02-08 at 12 05 28" src="https://github.com/paulmaxgithub/swift-scripts/assets/45998744/9098f9ce-34b2-4b77-91c2-f7308a9d4365">

### Code Example:
![](https://user-images.githubusercontent.com/119268/32348473-88080ed2-c01c-11e7-9de6-762aeb195156.png)


## Known issues:
- Fully text search (no fancy stuff)
- A lot of false-positives (protocols, functions, objc interoop, System delegate methods)
- A lot of false-negatives (text search, yep)
