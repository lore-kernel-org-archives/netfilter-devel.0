From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH COLO-Frame v5 00/29] COarse-grain LOck-stepping(COLO)
 Virtual Machines for Non-stop Service
Date: Thu, 28 May 2015 17:24:02 +0100
Message-ID: <20150528162402.GE2127@work-vm>
References: <1432196001-10352-1-git-send-email-zhang.zhanghailiang@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="3V7upXqbjpZ4EhLz"
Cc: qemu-devel@nongnu.org, quintela@redhat.com, amit.shah@redhat.com,
	eblake@redhat.com, berrange@redhat.com, peter.huangpeng@huawei.com,
	eddie.dong@intel.com, yunhong.jiang@intel.com,
	wency@cn.fujitsu.com, lizhijian@cn.fujitsu.com,
	arei.gonglei@huawei.com, david@gibson.dropbear.id.au,
	netfilter-devel@vger.kernel.org
To: zhanghailiang <zhang.zhanghailiang@huawei.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbbE1QYJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 May 2015 12:24:09 -0400
Content-Disposition: inline
In-Reply-To: <1432196001-10352-1-git-send-email-zhang.zhanghailiang@huawei.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* zhanghailiang (zhang.zhanghailiang@huawei.com) wrote:
> This is the 5th version of COLO, here is only COLO frame part, include: VM checkpoint,
> failover, proxy API, block replication API, not include block replication.
> The block part has been sent by wencongyang:
> "[Qemu-devel] [PATCH COLO-Block v5 00/15] Block replication for continuous checkpoints"
> 
> we have finished some new features and optimization on COLO (As a development branch in github),
> but for easy of review, it is better to keep it simple now, so we will not add too much new 
> codes into this frame patch set before it been totally reviewed. 
> 
> You can get the latest integrated qemu colo patches from github (Include Block part):
> https://github.com/coloft/qemu/commits/colo-v1.2-basic
> https://github.com/coloft/qemu/commits/colo-v1.2-developing (more features)
> 
> Please NOTE the difference between these two branch.
> colo-v1.2-basic is exactly same with this patch series, which has basic features of COLO.
> Compared with colo-v1.2-basic, colo-v1.2-developing has some optimization in the 
> process of checkpoint, including: 
>    1) separate ram and device save/load process to reduce size of extra memory
>       used during checkpoint
>    2) live migrate part of dirty pages to slave during sleep time.
> Besides, we add some statistic info in colo-v1.2-developing, which you can get these stat
> info by using command 'info migrate'.


Hi,
  I have that running now.

Some notes:
  1) The colo-proxy is working OK until qemu quits, and then it gets an RCU problem; see below
  2) I've attached some minor tweaks that were needed to build with the 4.1rc kernel I'm using;
     they're very minor changes and I don't think related to (1).
  3) I've also included some minor fixups I needed to get the -developing world
     to build;  my compiler is fussy about unused variables etc - but I think the code
     in ram_save_complete in your -developing patch is wrong because there are two
     'pages' variables and the one in the inner loop is the only one changed.
  4) I've started trying simple benchmarks and tests now:
    a) With a simple web server most requests have very little overhead, the comparison
       matches most of the time;  I do get quite large spikes (0.04s->1.05s) which I guess
       corresponds to when a checkpoint happens, but I'm not sure why the spike is so big,
       since the downtime isn't that big.
    b) I tried something with more dynamic pages - the front page of a simple bugzilla
       install;  it failed the comparison every time; it took me a while to figure out
       why, but it generates a unique token in it's javascript each time (for a password reset
       link), and I guess the randomness used by that doesn't match on the two hosts.
       It surprised me, because I didn't expect this page to have much randomness
       in.

  4a is really nice - it shows the benefit of COLO over the simple checkpointing;
checkpoints happen very rarely.

The colo-proxy rcu problem I hit shows as rcu-stalls in both primary and secondary
after the qemu quits; the backtrace of the qemu stack is:

[<ffffffff810d8c0c>] wait_rcu_gp+0x5c/0x80
[<ffffffff810ddb05>] synchronize_rcu+0x45/0xd0
[<ffffffffa0a251e5>] colo_node_release+0x35/0x50 [nfnetlink_colo]
[<ffffffffa0a25795>] colonl_close_event+0xe5/0x160 [nfnetlink_colo]
[<ffffffff81090c96>] notifier_call_chain+0x66/0x90
[<ffffffff8109154c>] atomic_notifier_call_chain+0x6c/0x110
[<ffffffff815eee07>] netlink_release+0x5b7/0x7f0
[<ffffffff815878bf>] sock_release+0x1f/0x90
[<ffffffff81587942>] sock_close+0x12/0x20
[<ffffffff812193c3>] __fput+0xd3/0x210
[<ffffffff8121954e>] ____fput+0xe/0x10
[<ffffffff8108d9f7>] task_work_run+0xb7/0xf0
[<ffffffff81002d4d>] do_notify_resume+0x8d/0xa0
[<ffffffff81722b66>] int_signal+0x12/0x17
[<ffffffffffffffff>] 0xffffffffffffffff

that's with both the 423a8e268acbe3e644a16c15bc79603cfe9eb084 from yesterday and 
older e58e5152b74945871b00a88164901c0d46e6365e tags on colo-proxy.
I'm not sure of the right fix; perhaps it might be possible to replace the 
synchronize_rcu in colo_node_release by a call_rcu that does the kfree later?

Thanks,

Dave

> 
> You can test any branch of the above, 
> about how to test COLO, Please reference to the follow link.
> http://wiki.qemu.org/Features/COLO.
> 
> COLO is still in early stage, 
> your comments and feedback are warmly welcomed.
> 
> Cc: netfilter-devel@vger.kernel.org
> 
> TODO:
> 1. Strengthen failover
> 2. COLO function switch on/off
> 2. Optimize proxy part, include proxy script.
>   1) Remove the limitation of forward network link.
>   2) Reuse the nfqueue_entry and NF_STOLEN to enqueue skb
> 3. The capability of continuous FT
> 
> v5:
> - Replace the previous communication way between proxy and qemu with nfnetlink
> - Remove the 'forward device'parameter of xt_PMYCOLO, and now we use iptables command
> to set the 'forward device'
> - Turn DPRINTF into trace_ calls as Dave's suggestion
> 
> v4:
> - New block replication scheme (use image-fleecing for sencondary side)
> - Adress some comments from Eric Blake and Dave
> - Add commmand colo-set-checkpoint-period to set the time of periodic checkpoint
> - Add a delay (100ms) between continuous checkpoint requests to ensure VM
>   run 100ms at least since last pause.
> v3:
> - use proxy instead of colo agent to compare network packets
> - add block replication
> - Optimize failover disposal
> - handle shutdown
> 
> v2:
> - use QEMUSizedBuffer/QEMUFile as COLO buffer
> - colo support is enabled by default
> - add nic replication support
> - addressed comments from Eric Blake and Dr. David Alan Gilbert
> 
> v1:
> - implement the frame of colo
> 
> Wen Congyang (1):
>   COLO: Add block replication into colo process
> 
> zhanghailiang (28):
>   configure: Add parameter for configure to enable/disable COLO support
>   migration: Introduce capability 'colo' to migration
>   COLO: migrate colo related info to slave
>   migration: Integrate COLO checkpoint process into migration
>   migration: Integrate COLO checkpoint process into loadvm
>   COLO: Implement colo checkpoint protocol
>   COLO: Add a new RunState RUN_STATE_COLO
>   QEMUSizedBuffer: Introduce two help functions for qsb
>   COLO: Save VM state to slave when do checkpoint
>   COLO RAM: Load PVM's dirty page into SVM's RAM cache temporarily
>   COLO VMstate: Load VM state into qsb before restore it
>   arch_init: Start to trace dirty pages of SVM
>   COLO RAM: Flush cached RAM into SVM's memory
>   COLO failover: Introduce a new command to trigger a failover
>   COLO failover: Implement COLO master/slave failover work
>   COLO failover: Don't do failover during loading VM's state
>   COLO: Add new command parameter 'colo_nicname' 'colo_script' for net
>   COLO NIC: Init/remove colo nic devices when add/cleanup tap devices
>   COLO NIC: Implement colo nic device interface configure()
>   COLO NIC : Implement colo nic init/destroy function
>   COLO NIC: Some init work related with proxy module
>   COLO: Handle nfnetlink message from proxy module
>   COLO: Do checkpoint according to the result of packets comparation
>   COLO: Improve checkpoint efficiency by do additional periodic
>     checkpoint
>   COLO: Add colo-set-checkpoint-period command
>   COLO NIC: Implement NIC checkpoint and failover
>   COLO: Disable qdev hotplug when VM is in COLO mode
>   COLO: Implement shutdown checkpoint
> 
>  arch_init.c                            | 243 +++++++++-
>  configure                              |  36 +-
>  hmp-commands.hx                        |  30 ++
>  hmp.c                                  |  14 +
>  hmp.h                                  |   2 +
>  include/exec/cpu-all.h                 |   1 +
>  include/migration/migration-colo.h     |  57 +++
>  include/migration/migration-failover.h |  22 +
>  include/migration/migration.h          |   3 +
>  include/migration/qemu-file.h          |   3 +-
>  include/net/colo-nic.h                 |  27 ++
>  include/net/net.h                      |   3 +
>  include/sysemu/sysemu.h                |   3 +
>  migration/Makefile.objs                |   2 +
>  migration/colo-comm.c                  |  68 +++
>  migration/colo-failover.c              |  48 ++
>  migration/colo.c                       | 836 +++++++++++++++++++++++++++++++++
>  migration/migration.c                  |  60 ++-
>  migration/qemu-file-buf.c              |  58 +++
>  net/Makefile.objs                      |   1 +
>  net/colo-nic.c                         | 420 +++++++++++++++++
>  net/tap.c                              |  45 +-
>  qapi-schema.json                       |  42 +-
>  qemu-options.hx                        |  10 +-
>  qmp-commands.hx                        |  41 ++
>  savevm.c                               |   2 +-
>  scripts/colo-proxy-script.sh           |  88 ++++
>  stubs/Makefile.objs                    |   1 +
>  stubs/migration-colo.c                 |  58 +++
>  trace-events                           |  11 +
>  vl.c                                   |  39 +-
>  31 files changed, 2235 insertions(+), 39 deletions(-)
>  create mode 100644 include/migration/migration-colo.h
>  create mode 100644 include/migration/migration-failover.h
>  create mode 100644 include/net/colo-nic.h
>  create mode 100644 migration/colo-comm.c
>  create mode 100644 migration/colo-failover.c
>  create mode 100644 migration/colo.c
>  create mode 100644 net/colo-nic.c
>  create mode 100755 scripts/colo-proxy-script.sh
>  create mode 100644 stubs/migration-colo.c
> 
> -- 
> 1.7.12.4
> 
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="colo-proxy-4.1build.diff"

commit 06f74102be1aa0e5c4a8ca523ac23dad3aa3e282
Author: Dr. David Alan Gilbert (git/414) <dgilbert@redhat.com>
Date:   Wed May 27 14:53:55 2015 -0400

    Hacks to build with 4.1
    
    Changes needed due to:
    238e54c9   David S. Miller      2015-04-03   Make nf_hookfn use nf_hook_state.
    1d1de89b   David S. Miller      2015-04-03   Use nf_hook_state in nf_queue_entry.
    
    Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

diff --git a/xt_PMYCOLO.c b/xt_PMYCOLO.c
index f5d7cda..626e170 100644
--- a/xt_PMYCOLO.c
+++ b/xt_PMYCOLO.c
@@ -829,7 +829,7 @@ static int colo_enqueue_packet(struct nf_queue_entry *entry, unsigned int ptr)
 		pr_dbg("master: gso again???!!!\n");
 	}
 
-	if (entry->hook != NF_INET_PRE_ROUTING) {
+	if (entry->state.hook != NF_INET_PRE_ROUTING) {
 		pr_dbg("packet is not on pre routing chain\n");
 		return -1;
 	}
@@ -839,7 +839,7 @@ static int colo_enqueue_packet(struct nf_queue_entry *entry, unsigned int ptr)
 		pr_dbg("%s: Could not find node: %d\n",__func__, conn->vm_pid);
 		return -1;
 	}
-	switch (entry->pf) {
+	switch (entry->state.pf) {
 	case NFPROTO_IPV4:
 		skb->protocol = htons(ETH_P_IP);
 		break;
@@ -1133,8 +1133,7 @@ out:
 
 static unsigned int
 colo_slaver_queue_hook(const struct nf_hook_ops *ops, struct sk_buff *skb,
-		       const struct net_device *in, const struct net_device *out,
-		       int (*okfn)(struct sk_buff *))
+                       const struct nf_hook_state *state)
 {
 	struct nf_conn *ct;
 	struct nf_conn_colo *conn;
@@ -1193,8 +1192,7 @@ out_unlock:
 
 static unsigned int
 colo_slaver_arp_hook(const struct nf_hook_ops *ops, struct sk_buff *skb,
-		     const struct net_device *in, const struct net_device *out,
-		     int (*okfn)(struct sk_buff *))
+                     const struct nf_hook_state *state)
 {
 	unsigned int ret = NF_ACCEPT;
 	const struct arphdr *arp;
diff --git a/xt_SECCOLO.c b/xt_SECCOLO.c
index fe8b4da..8bdef15 100644
--- a/xt_SECCOLO.c
+++ b/xt_SECCOLO.c
@@ -28,8 +28,7 @@ MODULE_DESCRIPTION("Xtables: secondary proxy module for colo.");
 
 static unsigned int
 colo_secondary_hook(const struct nf_hook_ops *ops, struct sk_buff *skb,
-		    const struct net_device *in, const struct net_device *out,
-		    int (*okfn)(struct sk_buff *))
+		    const struct nf_hook_state *hook_state)
 {
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn_colo *conn;

--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="colo-may-build.patches"

diff --git a/arch_init.c b/arch_init.c
index b7ce63a..564d87c 100644
--- a/arch_init.c
+++ b/arch_init.c
@@ -1359,7 +1359,7 @@ static int ram_save_iterate(QEMUFile *f, void *opaque)
 /* Called with iothread lock */
 static int ram_save_complete(QEMUFile *f, void *opaque)
 {
-    int pages;
+    int pages = 0;
 
     rcu_read_lock();
 
diff --git a/migration/colo.c b/migration/colo.c
index dd6aef1..1ce9793 100644
--- a/migration/colo.c
+++ b/migration/colo.c
@@ -725,7 +725,7 @@ void *colo_process_incoming_checkpoints(void *opaque)
     int ret;
     uint64_t total_size;
     Error *local_err = NULL;
-    static int init_once;
+    //static int init_once;
 
     qdev_hotplug = 0;
 
diff --git a/savevm.c b/savevm.c
index 0c45387..873169d 100644
--- a/savevm.c
+++ b/savevm.c
@@ -877,7 +877,7 @@ int qemu_save_ram_state(QEMUFile *f, bool complete)
     SaveStateEntry *se;
     int section = complete ? QEMU_VM_SECTION_END : QEMU_VM_SECTION_PART;
     int (*save_state)(QEMUFile *f, void *opaque);
-    int ret;
+    int ret = 0;
 
     QTAILQ_FOREACH(se, &savevm_handlers, entry) {
         if (!se->ops) {

--3V7upXqbjpZ4EhLz--
