FROM ubuntu:latest

#####################################################
# Install required dependencies
#####################################################

# update apt and unminimize
RUN apt update -y && apt install unminimize
RUN yes | unminimize

# install basic networking utilities we need
# for installing other packages
RUN apt install curl wget -y

# install programming languages: python and go
# along with utilities which work with them
RUN apt install software-properties-common -y
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt install python3.11 golang -y
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# install basic dev utilities
RUN apt install git jq less ssh sudo tmux unzip zip zsh -y

# install basic network utilities
RUN apt install dnsutils lsof netcat-openbsd nmap net-tools iputils-ping socat tcpdump telnet traceroute -y

# install yq from source
RUN cd /tmp && wget https://github.com/mikefarah/yq/releases/download/v4.41.1/yq_linux_amd64.tar.gz -O - |  tar xz && mv yq_linux_amd64 /usr/bin/yq

# install mitmproxy. this requires pipx
RUN apt install pipx -y
RUN pipx ensurepath && pipx install mitmproxy

# install neovim from source
RUN cd /tmp && wget "https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz" -O - | tar xz && ln -s $(pwd)/nvim-linux64/bin/nvim /usr/bin/nvim

# install packages needed to plugins
# this list might grow
RUN apt install cmake libx11-dev libxkbfile-dev npm ripgrep fd-find -y
RUN cd /tmp && git clone https://github.com/grwlf/xkb-switch && cd xkb-switch && mkdir build && cd build && cmake .. && make && ln -s $(pwd)/xkb-switch /usr/bin/xkb-switch

# install packages used for X11 forwarding
# not sure if i'll ever use this, but it's a useful feature to have nonetheless
RUN apt install xclip xsel

# install k8s
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

#####################################################
# Config stuff
#####################################################

# make zsh the default shell
RUN chsh -s $(which zsh)

# this is to fix a problem with oh-my-zsh
RUN apt install locales
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8    

# copy over config files
ARG CACHEBUST=1
WORKDIR /root/
RUN apt install stow -y
RUN git clone https://github.com/WillChangeThisLater/dotfiles
RUN cd dotfiles && chmod +x install.sh && rm /root/.zshrc && ./install.sh

# set up neovim and install packages
#RUN mkdir -p /root/.config && mv /root/nvim /root/.config/nvim
RUN nvim --headless "+Lazy! install" +qall

#####################################################
# Install my personal scripts
#####################################################

# lm
RUN cd /tmp && git clone https://github.com/WillChangeThisLater/go-llm && cd go-llm && go build && cp go-llm /bin/lm && rm -rf /tmp/go-llm

# misc shell scripts
RUN cd /root && git clone https://github.com/WillChangeThisLater/shell-scripts && stow -t /bin shell-scripts

CMD ["/bin/tmux"]
