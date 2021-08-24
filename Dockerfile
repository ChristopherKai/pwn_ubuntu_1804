FROM ubuntu:bionic-20180426
WORKDIR /opt
USER root
# pwndbg dependencies: libc6-dbg libc-dbg:i386 locales sudo
# c-jwt-cracker: libssl-dev
RUN dpkg --add-architecture i386 && apt update && apt install -y python-pip sudo openssh-server git  ruby tmux libc6:i386 libncurses5:i386 libstdc++6:i386 libc6-dbg libc-dbg:i386 locales ruby-dev libssl-dev hashcat&& rm -rf /var/lib/apt/lists/* \
    && sed -i "s|#PermitRootLogin prohibit-password|PermitRootLogin yes|g"  /etc/ssh/sshd_config && locale-gen en_US.UTF-8 
# pwntools==4.6.5 has tmux error
RUN pip install --no-cache-dir pwntools==4.0.1 capstone ropgadget formatStringExploiter ipython  && gem install one_gadget seccomp-tools
RUN git clone https://github.com/ChristopherKai/myLibcSearcher.git && cd myLibcSearcher && python setup.py develop && cd libc-database && ./add /lib/x86_64-linux-gnu/libc.so.6 && cd /opt \ 
    && git clone https://github.com/pwndbg/pwndbg.git && cd pwndbg && ./setup.sh && cd - \
    && git clone https://github.com/ChristopherKai/coolpwn.git && cd coolpwn && python setup.py install && cd -\
    && git clone https://github.com/ChristopherKai/mytools.git && ln /opt/mytools/gentemplate/gentemplate.py /usr/local/bin/gentemplate \
    && git clone https://github.com/shellphish/how2heap.git && cd how2heap && ./glibc_build.sh  -j 10 2.27
RUN echo "root:root" | chpasswd \
    # config pwndbg 
    && printf "set context-code-lines 5\nset context-sections regs disasm code ghidra stack  expressions" >>/root/.gdbinit \
    && printf "\nexport LC_ALL=en_US.UTF-8\nexport PYTHONIOENCODING=UTF-8" >> /etc/profile 

# Misc and Web tools
# Misc: pcapfix
# Web: c-jwt-cracker
RUN git clone https://github.com/Rup0rt/pcapfix.git && cd pcapfix && make && make install && cd -\
    && git clone https://github.com/brendan-rius/c-jwt-cracker.git && cd c-jwt-cracker && make
COPY entrypoint.sh /opt
RUN chmod +x /opt/entrypoint.sh
EXPOSE 22
ENTRYPOINT [ "/opt/entrypoint.sh" ]
