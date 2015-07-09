From: zhanghailiang <zhang.zhanghailiang@huawei.com>
Subject: [PATCH COLO-Frame v7 00/34] COarse-grain LOck-stepping(COLO) Virtual Machines for Non-stop Service (FT)
Date: Thu, 9 Jul 2015 11:16:08 +0800
Message-ID: <1436411802-181876-1-git-send-email-zhang.zhanghailiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <quintela@redhat.com>, <dgilbert@redhat.com>,
	<amit.shah@redhat.com>, <eblake@redhat.com>, <berrange@redhat.com>,
	<peter.huangpeng@huawei.com>, <eddie.dong@intel.com>,
	<yunhong.jiang@intel.com>, <wency@cn.fujitsu.com>,
	<lizhijian@cn.fujitsu.com>, <arei.gonglei@huawei.com>,
	zhanghailiang <zhang.zhanghailiang@huawei.com>,
	<netfilter-devel@vger.kernel.org>
To: <qemu-devel@nongnu.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [119.145.14.66] ([119.145.14.66]:20695 "EHLO
	szxga03-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbbGIDTd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jul 2015 23:19:33 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is the 7th version of COLO.

Here is only COLO frame part, include: VM checkpoint,
failover, proxy API, block replication API, not include block replication.
The block part is sent as a separate series.

As usuall, we provide two branch which one is 'colo-v1.4-basic', 
and the other is 'colo-v1.4-developing'.

The 'basic' branch is exactly the same with this patch series (basic features of COLO).
We will keep this series simple as possible, just for easy review.

You can get the newest integrated qemu colo patches from github (Include Block part):
https://github.com/coloft/qemu/commits/colo-v1.4-basic
https://github.com/coloft/qemu/commits/colo-v1.4-developing (more features)

Please NOTE the difference between these two branch.
Colo-v1.4-developing has some optimization in the process of checkpoint, including: 
   1) separate ram and device save/load process to reduce size of extra memory
      used during checkpoint
   2) live migrate part of dirty pages to slave during sleep time.
Besides, we add some statistic info in 'developing' branch, which you can get these stat
info by using command 'info migrate'.

About how to test COLO, Please reference to the follow link.
http://wiki.qemu.org/Features/COLO.

COLO is a totally new feature which is still in early stage, 
your comments and feedback are warmly welcomed.

Cc: netfilter-devel@vger.kernel.org

TODO:
1. COLO function switch on/off
2. Optimize proxy part, include proxy script.
  1) Remove the limitation of forward network link.
  2) Reuse the nfqueue_entry and NF_STOLEN to enqueue skb
3. The capability of continuous FT

v7:
- Remove the configuration limit for qemu-ifup script in slave
- Rework colo-comm.c to use VMState instead of legacy way (saving/loading)
- Only migrate colo state when enable colo capability, which also be
  compatible with older machine (Dave's suggestion)
- Rework colo-failover.c, using state to record failover's different stage,
  which can also fix possible deadlock bug which could trigged during failover 
  for secondary VM.
- Rename migration-colo.h to colo.h, migration-failover.h to failover.h

zhanghailiang (34):
  configure: Add parameter for configure to enable/disable COLO support
  migration: Introduce capability 'colo' to migration
  COLO: migrate colo related info to slave
  colo-comm/migration: skip colo info section for special cases
  migration: Integrate COLO checkpoint process into migration
  migration: Integrate COLO checkpoint process into loadvm
  COLO: Implement colo checkpoint protocol
  COLO: Add a new RunState RUN_STATE_COLO
  QEMUSizedBuffer: Introduce two help functions for qsb
  COLO: Save VM state to slave when do checkpoint
  COLO RAM: Load PVM's dirty page into SVM's RAM cache temporarily
  COLO VMstate: Load VM state into qsb before restore it
  arch_init: Start to trace dirty pages of SVM
  COLO RAM: Flush cached RAM into SVM's memory
  COLO failover: Introduce a new command to trigger a failover
  COLO failover: Introduce state to record failover process
  COLO failover: Implement COLO primary/secondary vm failover work
  qmp event: Add event notification for COLO error
  COLO failover: Don't do failover during loading VM's state
  COLO: Add new command parameter 'forward_nic' 'colo_script' for net
  COLO NIC: Init/remove colo nic devices when add/cleanup tap devices
  tap: Make launch_script() public
  COLO NIC: Implement colo nic device interface configure()
  colo-nic: Handle secondary VM's original net device configure
  COLO NIC: Implement colo nic init/destroy function
  COLO NIC: Some init work related with proxy module
  COLO: Handle nfnetlink message from proxy module
  COLO: Do checkpoint according to the result of packets comparation
  COLO: Improve checkpoint efficiency by do additional periodic
    checkpoint
  COLO: Add colo-set-checkpoint-period command
  COLO NIC: Implement NIC checkpoint and failover
  COLO: Disable qdev hotplug when VM is in COLO mode
  COLO: Implement shutdown checkpoint
  COLO: Add block replication into colo process

 configure                     |  33 +-
 docs/qmp/qmp-events.txt       |  16 +
 hmp-commands.hx               |  30 ++
 hmp.c                         |  15 +
 hmp.h                         |   2 +
 hw/i386/pc_piix.c             |   1 +
 hw/i386/pc_q35.c              |   1 +
 hw/ppc/spapr.c                |   1 +
 include/exec/cpu-all.h        |   1 +
 include/migration/colo.h      |  50 +++
 include/migration/failover.h  |  32 ++
 include/migration/migration.h |   4 +
 include/migration/qemu-file.h |   3 +-
 include/net/colo-nic.h        |  37 ++
 include/net/net.h             |   2 +
 include/net/tap.h             |  19 +
 include/sysemu/sysemu.h       |   3 +
 migration/Makefile.objs       |   2 +
 migration/colo-comm.c         |  84 +++++
 migration/colo-failover.c     |  78 ++++
 migration/colo.c              | 811 ++++++++++++++++++++++++++++++++++++++++++
 migration/migration.c         |  86 ++++-
 migration/qemu-file-buf.c     |  58 +++
 migration/ram.c               | 248 ++++++++++++-
 migration/savevm.c            |   2 +-
 net/Makefile.objs             |   1 +
 net/colo-nic.c                | 457 ++++++++++++++++++++++++
 net/net.c                     |   2 +
 net/tap.c                     |  90 +++--
 qapi-schema.json              |  58 ++-
 qapi/event.json               |  15 +
 qemu-options.hx               |   7 +
 qmp-commands.hx               |  42 +++
 scripts/colo-proxy-script.sh  | 145 ++++++++
 stubs/Makefile.objs           |   1 +
 stubs/migration-colo.c        |  58 +++
 trace-events                  |   8 +
 vl.c                          |  37 +-
 38 files changed, 2464 insertions(+), 76 deletions(-)
 create mode 100644 include/migration/colo.h
 create mode 100644 include/migration/failover.h
 create mode 100644 include/net/colo-nic.h
 create mode 100644 migration/colo-comm.c
 create mode 100644 migration/colo-failover.c
 create mode 100644 migration/colo.c
 create mode 100644 net/colo-nic.c
 create mode 100755 scripts/colo-proxy-script.sh
 create mode 100644 stubs/migration-colo.c

-- 
1.7.12.4


