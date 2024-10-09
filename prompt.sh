#!/bin/bash
cat <<EOF
I am building a development docker container.
This container should meet the following requirements:

\`\`\`bash
> cat -n README.md
$(cat -n README.md)
\`\`\`


I have the following dockerfile:

\`\`\`bash
> cat -n Dockerfile
$(cat -n Dockerfile)
\`\`\`

I have a bunch of config files as well, stored in a conf directory

\`\`\`bash
> ls -a conf
$(ls -a conf)
\`\`\`

Modify the Dockerfile to do the following:

  1. Copy over files from my \`conf\` folder to the image
  2. Using GNU Stow (or some other tool), link the conf folder
     in the appropriate way so tools use the files from \`conf\`
	 for configuration

EOF
