.SUBDIRS := $(wildcard packages/*/src/.)
SHELL := /bin/bash
FILENAME := $(shell sh curr.sh)
X = 0
MaxX = 450000
INTERVAL = 50000


deps:
	-cd run; git clone git@github.com:open-telemetry/opentelemetry-collector-contrib.git

all: build test

build: deps
	ncs-setup --dest ncs-run --generate-ssh-keys
	rm -rf ncs-run/packages
	cd ncs-run; ln -s ../packages
	cp -R ncs-cdb ncs-run/
	make make_packages
	make start_collector


build_nocompile: 
	ncs-setup --dest ncs-run --package packages/* --generate-ssh-keys
	cp -R ncs-cdb ncs-run/

start: start_nso start_collector

start_collector:
	cd run; docker compose up -d

start_nso:
	cd ncs-run;ncs --stop; ncs

start_frontend:
	cd nso; make start
	cd run; docker compose up


collect:
	nohup sh data_collect.sh ncs.smp 1 &> logs/collect.log &

test:
	sh trigger.sh $(MaxX) $(INTERVAL)

stop_collect:
	sh data_processing.sh $(X)
	
stop_collector:
	 cd run; docker compose down

stop_nso:
	-cd ncs-run; ncs --stop

stop: stop_nso stop_collector


clean_logs:
	rm -rf ncs-run/logs/*

clean_cdb:
	rm -rf ncs-run/ncs-cdb/*

clean_data:
	-rm -f data.dat
	-rm -f data/*.dat

clean: stop clean_data clean_cdb clean_logs
	-rm -rf lux_logs
	-rm -rf ncs-run
	-rm -rf cd run/opentelemetry-collector-contrib


reset: clean
	rm -rf packages/*
	rm -rf ncs-cdb/*
	rm -f test.lux
	cp lux_template/test.lux test.lux
	rm -f Tail-f-env/nso/download/*.bin
	rm -rf Tail-f-env/nso/nso_store/*
	rm -rf Tail-f-env/example/unzip/nso/*
	rm -rf Tail-f-env/example/unzip/confd/*


cli-c:
	cd ncs-run; ncs_cli -C -u admin --noaaa ; cd ..


cli-j:
	cd ncs-run ; ncs_cli -J -u admin --noaaa; cd ..

tar: reset
	rm ${FILENAME}.tar.gz
	cd ../; tar -czvf  ${FILENAME}.tar.gz ${FILENAME}; mv  ${FILENAME}.tar.gz  ${FILENAME}/



make_packages: $(SUBDIRS)
$(SUBDIRS):
	$(MAKE) clean all -C $@

.PHONY: make_packages $(SUBDIRS)

