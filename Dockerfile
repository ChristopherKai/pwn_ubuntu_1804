FROM  ubuntu:18.04
WORKDIR /opt
USER root
# pwndbg dependencies: libc6-dbg libc-dbg:i386 locales
RUN dpkg --add-architecture i386 && apt update && apt install -y python-pip openssh-server git  ruby tmux libc6:i386 libncurses5:i386 libstdc++6:i386 libc6-dbg libc-dbg:i386 ruby-dev && rm -rf /var/lib/apt/lists/* \
    && sed -i "s|#PermitRootLogin prohibit-password|PermitRootLogin yes|g"  /etc/ssh/sshd_config && locale-gen en_US.UTF-8 
RUN pip install --no-cache-dir pwntools capstone ropgadget formatStringExploiter ipython  && gem install one_gadget seccomp-tools
RUN git clone https://github.com/ChristopherKai/myLibcSearcher.git && cd myLibcSearcher && python setup.py develop && cd libc-database && ./add /lib/x86_64-linux-gnu/libc.so.6 && cd /opt \ 
    && git clone https://github.com/pwndbg/pwndbg.git && cd pwndbg && ./setup.sh && cd - \
    && git clone https://github.com/ChristopherKai/coolpwn.git && cd coolpwn && python setup.py install && cd -\
    && git clone https://github.com/ChristopherKai/mytools.git && ln /opt/mytools/gentemplate/gentemplate.py /usr/local/bin/gentemplate
RUN echo "root:root" | chpasswd && \
    # config pwndbg 
    && echo "set context-code-lines 5"  >> /root/.gdbinit \
    && echo "set context-sections regs disasm code ghidra stack  expressions" >>/root/.gdbinit
COPY entrypoint.sh /opt
RUN chmod +x /opt/entrypoint.sh
EXPOSE 22
ENTRYPOINT [ "/opt/entrypoint.sh" ]
