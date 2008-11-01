From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] netns ct: walk netns list under RTNL
Date: Sat, 1 Nov 2008 17:32:15 +0300
Message-ID: <20081101143215.GB23760@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:13380 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbYKAO3E (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 1 Nov 2008 10:29:04 -0400
Received: by nf-out-0910.google.com with SMTP id d3so730100nfc.21
        for <netfilter-devel@vger.kernel.org>; Sat, 01 Nov 2008 07:29:00 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As was suspected, it's oopsable:

BUG: unable to handle kernel paging request at 0000000000100100	<===
IP: [<ffffffffa00984bc>] nf_conntrack_helper_unregister+0x137/0x16c [nf_conntrack]
PGD 168b48067 PUD 168b47067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
last sysfs file: /sys/kernel/uevent_seqnum
CPU 0 
Modules linked in: nf_conntrack_pptp(-) nf_conntrack_proto_gre af_packet iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 sr_mod cdrom [last unloaded: nf_conntrack_pptp]
Pid: 9110, comm: rmmod Not tainted 2.6.28-rc2-netns-xfrm #2
RIP: 0010:[<ffffffffa00984bc>]  [<ffffffffa00984bc>] nf_conntrack_helper_unregister+0x137/0x16c [nf_conntrack]
RSP: 0018:ffff8801689dfea8  EFLAGS: 00010212
RAX: 0000000000004000 RBX: 0000000000000000 RCX: 0000000000000033
RDX: 0000000000003fff RSI: ffffffffa0648720 RDI: ffff88017fc2ced8
RBP: ffff8801689dfed8 R08: 0000000000000002 R09: 0000000000000000
R10: 0000000000000000 R11: ffff8801689dfd98 R12: 00000000001000f8
R13: ffffffffa0648720 R14: 0000000000004000 R15: 0000000000000880
FS:  00007f7ba894d6f0(0000) GS:ffffffff80521580(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000100100 CR3: 0000000168b45000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rmmod (pid: 9110, threadinfo ffff8801689de000, task ffff88017cd81218)
Stack:
 ffff8801689dfed8 ffffffffa06487c0 0000000000000000 0000000000000880
 00007fffb0955330 0000000000000880 ffff8801689dfee8 ffffffffa064771c
 ffff8801689dff78 ffffffff80253f87 746e6e6f635f666e 7470705f6b636172
Call Trace:
 [<ffffffffa064771c>] nf_conntrack_pptp_fini+0x10/0x1e [nf_conntrack_pptp]
 [<ffffffff80253f87>] sys_delete_module+0x19f/0x1fe
 [<ffffffff8024cac8>] ? trace_hardirqs_on_caller+0xf0/0x114
 [<ffffffff803ea8b0>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8020b52b>] system_call_fastpath+0x16/0x1b
Code: 48 89 df 4c 89 ee 0f 18 08 e8 64 fe ff ff 48 8b 1b eb e5 49 ff c6 44 3b 35 4a bc 00 00 44 89 f0 72 c8 4d 8b 64 24 08 49 83 ec 08 <49> 8b 44 24 08 0f 18 08 49 8d 44 24 08 48 3d 60 4f 50 80 74 08 
RIP  [<ffffffffa00984bc>] nf_conntrack_helper_unregister+0x137/0x16c [nf_conntrack]
 RSP <ffff8801689dfea8>
CR2: 0000000000100100
Kernel panic - not syncing: Fatal exception in interrupt


BUG: unable to handle kernel paging request at 0000000000100100	<===
IP: [<ffffffffa009890f>] nf_conntrack_l4proto_unregister+0x96/0xae [nf_conntrack]
PGD 15e300067 PUD 15e1d8067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
last sysfs file: /sys/kernel/uevent_seqnum
CPU 0 
Modules linked in: nf_conntrack_proto_sctp(-) nf_conntrack_proto_dccp(-) af_packet iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 sr_mod cdrom [last unloaded: nf_conntrack_proto_sctp]
Pid: 16758, comm: rmmod Not tainted 2.6.28-rc2-netns-xfrm #3
RIP: 0010:[<ffffffffa009890f>]  [<ffffffffa009890f>] nf_conntrack_l4proto_unregister+0x96/0xae [nf_conntrack]
RSP: 0018:ffff88015dc1fec8  EFLAGS: 00010212
RAX: 0000000000000000 RBX: 00000000001000f8 RCX: 0000000000000000
RDX: ffffffffa009575c RSI: 0000000000000003 RDI: ffffffffa00956b5
RBP: ffff88015dc1fed8 R08: 0000000000000002 R09: 0000000000000000
R10: 0000000000000000 R11: ffff88015dc1fe48 R12: ffffffffa0458f60
R13: 0000000000000880 R14: 00007fff4c361d30 R15: 0000000000000880
FS:  00007f624435a6f0(0000) GS:ffffffff80521580(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000100100 CR3: 0000000168969000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rmmod (pid: 16758, threadinfo ffff88015dc1e000, task ffff880179864218)
Stack:
 ffffffffa0459100 0000000000000000 ffff88015dc1fee8 ffffffffa0457934
 ffff88015dc1ff78 ffffffff80253fef 746e6e6f635f666e 6f72705f6b636172
 00707463735f6f74 ffffffff8024cb30 00000000023b8010 0000000000000000
Call Trace:
 [<ffffffffa0457934>] nf_conntrack_proto_sctp_fini+0x10/0x1e [nf_conntrack_proto_sctp]
 [<ffffffff80253fef>] sys_delete_module+0x19f/0x1fe
 [<ffffffff8024cb30>] ? trace_hardirqs_on_caller+0xf0/0x114
 [<ffffffff803ea9b2>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8020b52b>] system_call_fastpath+0x16/0x1b
Code: 13 35 e0 e8 c4 6c 1a e0 48 8b 1d 6d c6 46 e0 eb 16 48 89 df 4c 89 e2 48 c7 c6 fc 85 09 a0 e8 61 cd ff ff 48 8b 5b 08 48 83 eb 08 <48> 8b 43 08 0f 18 08 48 8d 43 08 48 3d 60 4f 50 80 75 d3 5b 41 
RIP  [<ffffffffa009890f>] nf_conntrack_l4proto_unregister+0x96/0xae [nf_conntrack]
 RSP <ffff88015dc1fec8>
CR2: 0000000000100100
---[ end trace bde8ac82debf7192 ]---

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/netfilter/nf_conntrack_helper.c |    3 +++
 net/netfilter/nf_conntrack_proto.c  |    5 +++++
 2 files changed, 8 insertions(+)

--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -21,6 +21,7 @@
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
 #include <linux/rculist.h>
+#include <linux/rtnetlink.h>
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_l3proto.h>
@@ -167,10 +168,12 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 	 */
 	synchronize_rcu();
 
+	rtnl_lock();
 	spin_lock_bh(&nf_conntrack_lock);
 	for_each_net(net)
 		__nf_conntrack_helper_unregister(me, net);
 	spin_unlock_bh(&nf_conntrack_lock);
+	rtnl_unlock();
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
 
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -22,6 +22,7 @@
 #include <linux/notifier.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/rtnetlink.h>
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_l3proto.h>
@@ -221,8 +222,10 @@ void nf_conntrack_l3proto_unregister(struct nf_conntrack_l3proto *proto)
 	synchronize_rcu();
 
 	/* Remove all contrack entries for this protocol */
+	rtnl_lock();
 	for_each_net(net)
 		nf_ct_iterate_cleanup(net, kill_l3proto, proto);
+	rtnl_unlock();
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_l3proto_unregister);
 
@@ -333,8 +336,10 @@ void nf_conntrack_l4proto_unregister(struct nf_conntrack_l4proto *l4proto)
 	synchronize_rcu();
 
 	/* Remove all contrack entries for this protocol */
+	rtnl_lock();
 	for_each_net(net)
 		nf_ct_iterate_cleanup(net, kill_l4proto, l4proto);
+	rtnl_unlock();
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_unregister);
 
