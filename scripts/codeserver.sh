# Contains all arguments that are passed
CODE_SERVER_ARGS=($@)

# Number of arguments that are given
NUMBER_OF_ARG=${#CODE_SERVER_ARGS[@]}

# Prepare the variables for installing specific Code Server version
if [[ $NUMBER_OF_ARG -eq 1 ]]; then
    CODE_SERVER_VERSION=${CODE_SERVER_ARGS[0]}
    CODE_SERVER_DOWNLOAD_URL="https://github.com/cdr/code-server/releases/download/${CODE_SERVER_VERSION}/code-server${CODE_SERVER_VERSION}-linux-x64.tar.gz"
fi

# Check if a directory does not exist
if [[ ! -d "/home/vagrant/code-server" ]]; then
    echo ">>> Installing Code Server ${CODE_SERVER_VERSION}"
    wget --quiet "${CODE_SERVER_DOWNLOAD_URL}"
    tar xzf code-server${CODE_SERVER_VERSION}-linux-x64.tar.gz
    mv code-server${CODE_SERVER_VERSION}-linux-x64 code-server
    rm -f code-server${CODE_SERVER_VERSION}-linux-x64.tar.gz
else
    echo "Code Server is already installed."
fi

if [[ ! -d "/home/vagrant/.code-server-data" ]]; then
    mkdir /home/vagrant/.code-server-data
fi

if [[ ! -d "/home/vagrant/.code-server-extensions" ]]; then
    mkdir /home/vagrant/.code-server-extensions
fi

# Start Code-Server
cd /home/vagrant/projects
/home/vagrant/code-server/code-server \
    --cert=/etc/ssl/xip.io/xip.io.crt \
    --cert-key=/etc/ssl/xip.io/xip.io.key \
    --no-auth \
    --disable-telemetry \
    --user-data-dir=/home/vagrant/.code-server-data \
    --extensions-dir=/home/vagrant/.code-server-extensions \
    &>/vagrant/logs/code-server.log &disown
cd ~
