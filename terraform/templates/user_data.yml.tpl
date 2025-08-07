#cloud-config
users:
  - name: ${ansible_user_name}
    groups: wheel, sudo
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      - ${public_key}

package_update: true
package_upgrade: true

packages:
  - epel-release
  - sudo

runcmd:
  - mkdir -p /etc/sudoers.d
  - echo "${ansible_user_name} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${ansible_user_name}
  - chmod 440 /etc/sudoers.d/${ansible_user_name}
