FROM  ubuntu:18.04
WORKDIR /opt
USER root
RUN apt update && apt install python-pip -y && apt install openssh-server -y && sed -i "s|#PermitRootLogin prohibit-password|PermitRootLogin yes|g" /etc/ssh/sshd_config && service ssh restart\
    &&  apt-get install -y locales && locale-gen en_US.UTF-8 
ENV LC_ALL=en_US.UTF-8 
ENV PYTHONIOENCODING=UTF-8
RUN pip install pwntools &&  pip install capstone && pip install ropgadget && apt install ruby -y && gem install one_gadget
RUN apt-get install -y git &&  pip install formatStringExploiter && pip install ipython
RUN apt-get install -y sudo 
RUN git clone https://github.com/ChristopherKai/myLibcSearcher.git && cd myLibcSearcher && python setup.py develop && cd - \ 
    && git clone https://github.com/ChristopherKai/mypwndbg.git && cd mypwndbg && ./setup.sh && cd - \
    && git clone https://github.com/ChristopherKai/coolpwn.git && cd coolpwn && python setup.py install && cd -
RUN apt-get install -y tmux 
RUN git clone https://github.com/ChristopherKai/mytools.git && ln /opt/mytools/gentemplate/gentemplate.py /usr/local/bin/gentemplate
RUN echo "root:root" | chpasswd
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 22
ENTRYPOINT [ "/entrypoint.sh" ]
