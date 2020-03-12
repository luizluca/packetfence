#!/bin/bash
set -o nounset -o pipefail -o errexit

# Script to run 'test' stage of pipeline

ANSIBLE_FORCE_COLOR=${ANSIBLE_FORCE_COLOR:-true}
ANSIBLE_SKIP_TAGS=${ANSIBLE_SKIP_TAGS:-}
ANSIBLE_STDOUT_CALLBACK=${ANSIBLE_STDOUT_CALLBACK:-yaml}
VAGRANT_FORCE_COLOR=${VAGRANT_FORCE_COLOR:-true}
VAGRANT_ANSIBLE_VERBOSE=${VAGRANT_ANSIBLE_VERBOSE:-false}
VAGRANT_DIR='../../../addons/vagrant'
CI_COMMIT_TAG=${CI_COMMIT_TAG:-}

# set to yes when testing new features on collections
LOCAL_COLLECTIONS=${LOCAL_COLLECTIONS:-no}

delete_dir_if_exists() {
    local dir=${1}
    if [ -d "${dir}" ]; then
        rm -r ${dir}
        echo "Directory ${dir} removed"
    else
        echo "No ${dir} directory to remove"
    fi
}

setup() {
    declare -p ANSIBLE_SKIP_TAGS VAGRANT_DIR VAGRANT_ANSIBLE_VERBOSE VM_NAMES
    declare -p CI_COMMIT_TAG
    declare -p LOCAL_COLLECTIONS
    
    # export because ansible is run through vagrant and this variable will
    # not be visible without
    export ANSIBLE_SKIP_TAGS

    if [ "$LOCAL_COLLECTIONS" = "no" ]; then
        ansible-galaxy collection install -r ${VAGRANT_DIR}/requirements.yml -p ${VAGRANT_DIR}/collections
    else
        echo "Using local collections"
    fi
    
    cd ${VAGRANT_DIR}

    # always try to upgrade box before start
    vagrant box update ${VM_NAMES}
    vagrant up ${VM_NAMES} --destroy-on-error --no-parallel

    vagrant halt ${VM_NAMES}
}

teardown() {
    delete_dir_if_exists ${VAGRANT_DIR}/roles
    delete_dir_if_exists ${VAGRANT_DIR}/collections

    if [ -z "${VM_NAMES}" ]; then
        # destroy all VM
        # using "|| true" as a workaround to unusual behavior
        # see https://github.com/hashicorp/vagrant/issues/10024#issuecomment-404965057
        ( cd $VAGRANT_DIR ; vagrant destroy -f || true )
        delete_dir_if_exists ${VAGRANT_DIR}/.vagrant
    else
        ( cd $VAGRANT_DIR ; vagrant destroy -f ${VM_NAMES} )
        for vm in ${VM_NAMES}; do
            delete_dir_if_exists ${VAGRANT_DIR}/.vagrant/machines/${vm}
        done
    fi
}

case $1 in
    setup) setup ;;
    teardown) teardown ;;
    *)   die "Wrong argument"
esac
