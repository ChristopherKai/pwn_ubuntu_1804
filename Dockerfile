FROM  ubuntu:18.04
WORKDIR /opt
USER root
RUN apt update && apt install python-pip -y 
RUN pip install pwntools &&  pip install capstone && pip install ropgadget && apt install ruby -y && gem install one_gadget
RUN apt-get install -y git &&  pip install formatStringExploiter && pip install ipython 
RUN git clone https://github.com/ChristopherKai/myLibcSearcher.git && cd myLibcSearcher && python setup.py develop && cd - \ 
    && git clone https://github.com/ChristopherKai/mypwndbg.git && cd mypwndbg && ./setup.sh && cd - \
    && git clone https://github.com/ChristopherKai/coolpwn.git && cd coolpwn && python setup.py install && cd -\
