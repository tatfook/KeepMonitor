FROM jenkins/jenkins

USER root
# docker need libltdl package
RUN apt update && apt install -y libltdl7 make gettext-base subversion

ADD git-lfs-linux-amd64-2.3.4.tar.gz /root
RUN bash /root/git-lfs-2.3.4/install.sh

