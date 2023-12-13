#!/usr/bin/env bash

set -x

# Dump disk information to text files in the current directory

zfs list > zfs-list.txt

zpool status > zpool-status.txt

mdadm --misc --detail /dev/md127 > mdadm-misc-detail-dev-md127.txt

rm partitions-dump.txt

DISK_1=/dev/disk/by-id/nvme-CT4000P3PSSD8_2242E67C4B28
DISK_0=/dev/disk/by-id/nvme-CT4000P3PSSD8_2236E6628157
DISK_SLOW=/dev/disk/by-id/ata-Samsung_SSD_860_QVO_4TB_S4CXNF0N206602W

sgdisk -p $DISK_1 >> partitions-dump.txt
sfdisk --dump $DISK_1 >> partitions-dump.txt

sgdisk -p $DISK_0 >> partitions-dump.txt
sfdisk --dump $DISK_0 >> partitions-dump.txt

sgdisk -p $DISK_SLOW  >> partitions-dump.txt
sfdisk --dump $DISK_SLOW >> partitions-dump.txt

cp /etc/fstab .
