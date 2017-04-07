## Requirements

* ansible 2.2 or newer

## Set up a microboard image based on a fresh ubuntu image:

* Get a fresh Ubuntu Xenial image from `http://de.eu.odroid.in/ubuntu_16.04lts/`:

   ```
   curl 'http://de.eu.odroid.in/ubuntu_16.04lts/ubuntu64-16.04-minimal-odroid-c2-20160815.img.xz' | xzcat > ubuntu64-16.04-minimal-odroid-c2-20160815.img
   curl 'http://de.eu.odroid.in/ubuntu_16.04lts/ubuntu64-16.04-minimal-odroid-c2-20160815.img.md5sum' | md5sum -c -
   mv ubuntu64-16.04-minimal-odroid-c2-20160815.img liquid.img
   ```

* Enlarge the image, we need at least 2GB to be safe:

   ```
   truncate liquid.img --size=2G
   fdisk liquid.img
   ```

  In the interactive shell of fdisk, run these commands:

   ```
   d
   2
   n
   p
   2
   <enter>
   <enter>
   ```

* Calculate the offset of the root filesystem and mount it:

   ```
   fdisk -lu liquid.img
   # e.g. sector size 512
   # 1st partition starts at 2048, offset is 2048 * 512 = 1048576
   # 2nd partition starts at 264192, offset is 264192 * 512 = 135266304
   losetup /dev/loop0 liquid.img -o 1048576
   losetup /dev/loop1 liquid.img -o 135266304
   mount /dev/loop1 /var/local/liquid/target
   mount /dev/loop0 /var/local/liquid/target/media/boot
   mount --bind /proc /var/local/liquid/target/proc
   resize2fs /dev/loop1
   ```

* Upgrade the base packages, because `bootini` displays an interactive message,
  and blocks when upgraded from ansible. Also, install python 2.7:

   ```
   chroot /var/local/liquid/target
   apt-get update -y
   apt-get upgrade -y
   apt-get install -y python2.7
   exit
   ```

* Run the ansible playbook:

   ```
   cd liquid-setup/ansible
   sudo ansible-playbook board_chroot.yml
   ```

## Upgrade an existing installation on a microboard:
```
cd liquid-setup/ansible
sudo ansible-playbook board_local.yml
```

## Set up the bundle on a cloud server:
```
cd liquid-setup/ansible
sudo ansible-playbook server.yml
```

Note: `non-free` package sources must be used for Debian.
