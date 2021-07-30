FROM  ubuntu:18.04
WORKDIR /opt
USER root
RUN dpkg --add-architecture i386 && apt update && apt install -y python-pip openssh-server git locales ruby tmux sudo  libc6:i386 libncurses5:i386 libstdc++6:i386 && rm -rf /var/lib/apt/lists/* \
    && sed -i "s|#PermitRootLogin prohibit-password|PermitRootLogin yes|g"  /etc/ssh/sshd_config && locale-gen en_US.UTF-8 
RUN pip install --no-cache-dir pwntools capstone ropgadget formatStringExploiter ipython  && gem install one_gadget seccomp-tools
RUN git clone https://github.com/ChristopherKai/myLibcSearcher.git && cd myLibcSearcher && python setup.py develop && cd libc-database && ./add /lib/x86_64-linux-gnu/libc.so.6 && cd /opt \ 
    && git clone https://github.com/pwndbg/pwndbg.git && cd pwndbg && ./setup.sh && cd - \
    && git clone https://github.com/ChristopherKai/coolpwn.git && cd coolpwn && python setup.py install && cd -\
    && git clone https://github.com/ChristopherKai/mytools.git && ln /opt/mytools/gentemplate/gentemplate.py /usr/local/bin/gentemplate
RUN echo "root:root" | chpasswd && echo "nameserver 114.114.114.114" >> /etc/resolv.conf && echo "nameserver 8.8.8.8" >> /etc/resolv.conf
COPY entrypoint.sh /opt
RUN chmod +x /opt/entrypoint.sh
EXPOSE 22
ENTRYPOINT [ "/opt/entrypoint.sh" ]
