#!/bin/bash

set -ex

S3_URI=$1
RPM_URI=$S3_URI/rpms/$2
S3_ACCESS_KEY=$3
S3_SECRET_KEY=$4
S3_NOTEBOOK_BUCKET=$5
S3_NOTEBOOK_PREFIX=$6

# Parses a configuration file put in place by EMR to determine the role of this node
is_master() {
  if [ $(jq '.isMaster' /mnt/var/lib/info/instance.json) = 'true' ]; then
    return 0
  else
    return 1
  fi
}

if is_master; then

    # Download packages
    mkdir -p /tmp/blobs/
    aws s3 sync $RPM_URI /tmp/blobs/
    sudo yum install -y -q nodejs

    # Install binary packages
    (cd /tmp/blobs; sudo yum localinstall -y /tmp/blobs/*.rpm)

    # Linkage
    echo '/usr/local/lib' > /tmp/local.conf
    echo '/usr/local/lib64' >> /tmp/local.conf
    sudo cp /tmp/local.conf /etc/ld.so.conf.d/local.conf
    sudo ldconfig
    rm -f /tmp/local.conf

    # Environment setup
    cat <<EOF > /tmp/extra_profile.sh
export AWS_DNS_NAME=$(aws ec2 describe-network-interfaces --filters Name=private-ip-address,Values=$(hostname -i) | jq -r '.[] | .[] | .Association.PublicDnsName')
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
export SCALA_VERSION=2.12.10
export ALMOND_VERSION=0.9.1
EOF
    sudo mv /tmp/extra_profile.sh /etc/profile.d
    . /etc/profile.d/extra_profile.sh

    sudo pip-3.6 install --upgrade pip
    sudo pip3 install jupyter jupyterhub sudospawner s3contents wheel pandoc pyproj matplotlib
    sudo pip3 install --upgrade numpy

    sudo groupadd shadow
    sudo chgrp shadow /etc/shadow
    sudo chmod 640 /etc/shadow
    sudo useradd -G shadow -r hublauncher
    sudo groupadd jupyterhub
    echo 'hublauncher ALL=(%jupyterhub) NOPASSWD: /usr/local/bin/sudospawner' | sudo tee -a /etc/sudoers
    sudo adduser -G hadoop,jupyterhub user
    echo 'user:password' | sudo chpasswd

    cat <<EOF > /tmp/jupyterhub_config.py
c = get_config()
c.JupyterHub.spawner_class='sudospawner.SudoSpawner'
c.SudoSpawner.sudospawner_path='/usr/local/bin/sudospawner'
EOF

    cat <<EOF > /tmp/per_user_jupyter_notebook_config.py
from s3contents import S3ContentsManager
c = get_config()
c.NotebookApp.contents_manager_class = S3ContentsManager
c.S3ContentsManager.access_key_id = "$S3_ACCESS_KEY"
c.S3ContentsManager.secret_access_key = "$S3_SECRET_KEY"
c.S3ContentsManager.bucket = "$S3_NOTEBOOK_BUCKET"
c.S3ContentsManager.prefix = "$S3_NOTEBOOK_PREFIX"
EOF

    sudo -u user mkdir /home/user/.jupyter
    sudo -u user cp /tmp/per_user_jupyter_notebook_config.py /home/user/.jupyter/jupyter_notebook_config.py

    cat <<EOF > /tmp/jupyter_profile.sh
export AWS_DNS_NAME=$(aws ec2 describe-network-interfaces --filters Name=private-ip-address,Values=$(hostname -i) | jq -r '.[] | .[] | .Association.PublicDnsName')
alias launch_hub='sudo -u hublauncher -E env "PATH=/usr/local/bin:$PATH" jupyterhub -f /tmp/jupyterhub_config.py'
EOF
    sudo mv /tmp/jupyter_profile.sh /etc/profile.d
    . /etc/profile.d/jupyter_profile.sh

    curl -Lo /tmp/coursier https://git.io/coursier-cli
    chmod +x /tmp/coursier
    /tmp/coursier bootstrap -r jitpack -i user -I user:sh.almond:scala-kernel-api_$SCALA_VERSION:$ALMOND_VERSION sh.almond:scala-kernel_$SCALA_VERSION:$ALMOND_VERSION -o /tmp/almond-2.12.10
    sudo /tmp/almond-2.12.10 --install --force --id almond212 --display-name 'Scala (2.12.10)' --jupyter-path /usr/share/jupyter/kernels

    cd /tmp
    sudo -u hublauncher -E env "PATH=/usr/local/bin:$PATH" jupyterhub -f /tmp/jupyterhub_config.py

else

    # Download packages
    mkdir -p /tmp/blobs/
    aws s3 sync $RPM_URI /tmp/blobs/

    # Install binary packages
    (cd /tmp/blobs; sudo yum localinstall -y /tmp/blobs/*.rpm)

    # Linkage
    echo '/usr/local/lib' > /tmp/local.conf
    echo '/usr/local/lib64' >> /tmp/local.conf
    sudo cp /tmp/local.conf /etc/ld.so.conf.d/local.conf
    sudo ldconfig
    rm -f /tmp/local.conf
fi
