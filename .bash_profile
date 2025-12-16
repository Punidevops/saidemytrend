# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

export JAVA_HOME=/usr/lib/jvm/java-21-amazon-corretto.x86_64
export M2_HOME=/opt/maven
export M2=/opt/maven/bin
export PATH=$PATH:$HOME/bin:$JAVA_HOME/bin:$M2:$M2_HOME/bin

# User specific environment and startup programs
