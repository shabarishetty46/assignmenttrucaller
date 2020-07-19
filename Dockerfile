FROM centos:latest
# RUBY, java , yorn ,rails , cassandra

RUN yum -y install  curl  wget gpg gcc gcc-c++ make patch autoconf automake bison libffi-devel nodejs java-1.8.0-openjdk-devel libtool patch readline-devel sqlite-devel zlib-devel openssl-devel \
  && wget --no-check-certificate https://cache.ruby-lang.org/pub/ruby/2.7/ruby-2.7.0.tar.gz \
 && tar zxvf ruby-2.7.0.tar.gz \
 && cd ruby-2.7.0 \
 && ./configure && make && make install  \
 && cd ..  \
  && rm -f ruby-2.7.0.tar.gz  \
  && rm -rf ruby-2.7.0 \
  && gem install bundler \
  &&  gem install rails
COPY  cass.repo /etc/yum.repos.d
RUN yum -y update && yum -y install cassandra
COPY cassandra-env.sh /etc/cassandra/default.conf/
RUN systemctl enable cassandra
RUN wget https://www.sqlite.org/2019/sqlite-autoconf-3290000.tar.gz
RUN tar xzvf sqlite-autoconf-3290000.tar.gz
RUN cd sqlite-autoconf-3290000 && ./configure --prefix=/opt/sqlite/sqlite3 &&  make && make install && gem install sqlite3 -- --with-sqlite3-include=/opt/sqlite/sqlite3/include --with-sqlite3-lib=/opt/sqlite/sqlite3/lib && cd .. && rm -rf sqlite-autoconf-3290000.tar.gz
RUN curl -sL https://dl.yarnpkg.com/rpm/yarn.repo -o /etc/yum.repos.d/yarn.repo && yum install -y yarn
RUN rails new blog ---skip-active-record --skip-active-storage -T && cd blog && bundle add cequel && bundle add activemodel-serializers-xml && rails g scaffold post title body
WORKDIR blog
COPY routes.rb config
COPY post.rb   app/models
RUN rails g cequel:configuration
RUN cassandra -R  && sleep 30 && nodetool status && rails cequel:keyspace:create && rails cequel:migrate
EXPOSE 3000
CMD ["rails", "s"]
