#!/bin/bash

# Script to fix typos in jmkettle.com content files
echo "Starting typo corrections..."

# 1. Fix "wrorte" -> "wrote" in Kick Drums and Vsco Girls
sed -i.bak 's/I wrorte this/I wrote this/g' "content/writing/Kick Drums and Vsco Girls.md"

# 2. Fix "In outside of" -> "Outside of" in about.md
sed -i.bak 's/In outside of the classroom/Outside of the classroom/g' "content/about.md"

# 3. Fix "phase" -> "phrase" in Kick Drums and Vsco Girls
sed -i.bak 's/The phase has been included/The phrase has been included/g' "content/writing/Kick Drums and Vsco Girls.md"

# 4. Fix "dominate" -> "dominant" in Kick Drums and Vsco Girls
sed -i.bak 's/dominate social class/dominant social class/g' "content/writing/Kick Drums and Vsco Girls.md"

# 5. Fix "thougths" -> "thoughts" in reflections-on-georgia
sed -i.bak 's/Final thougths/Final thoughts/g' "content/writing/reflections-on-georgia.md"

# 6. Fix "wont" -> "won't" in daily haikus
sed -i.bak 's/new coffee stain wont come out/new coffee stain won'\''t come out/g' "content/writing/daily haikus.md"

# 7. Fix "august" -> "August" in father_and_son
sed -i.bak 's/month in august/month in August/g' "content/photos/father_and_son.md"

# 8. Fix tense inconsistency in about.md (Upfront section)
sed -i.bak 's/I'\''m the 2nd hire and I do sales and product/I was the 2nd hire and did sales and product/g' "content/about.md"

# 9. Fix "whenew" typo in music.md
sed -i.bak 's/whenew they wouldn/when they wouldn/g' "content/projects/music.md"

# 10. Fix "Me and the founders" grammar
sed -i.bak 's/Me and the founders had different visions/The founders and I had different visions/g' "content/about.md"

# 11. Comment out outdated event date in stop1.md
sed -i.bak 's/\*\*Next event\*\*: July 19th at Hellphone/<!-- **Next event**: July 19th at Hellphone -->/g' "content/projects/stop1.md"

echo "All typos fixed!"
