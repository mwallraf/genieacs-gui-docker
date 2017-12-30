FROM ruby:2.2
MAINTAINER Maarten Wallraf <maarten@2nms.com>

WORKDIR /usr/src

RUN git clone https://github.com/mwallraf/genieacs-gui.git
RUN ln -s /usr/src/genieacs-gui /app

RUN echo 'for f in /app/config/*-sample.yml; do mv "$f" "${f/-sample.yml/.yml}"; done' | bash -

WORKDIR /app

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
	apt-get install -y nodejs && \
	cd /app && \
	RAILS_ENV=production bundle && \
	RAILS_ENV=production bundle exec rake assets:precompile

RUN if [ -f /app/tmp/pids/server.pid ]; then rm /app/tmp/pids/server.pid; fi

RUN mv /app/config/graphs-sample.json.erb /app/config/graphs.json.erb

CMD ["rails", "s"]
