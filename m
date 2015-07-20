From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next] netfilter: nf_queue: fix deadlock in nf_queue_nf_hook_drop()
Date: Mon, 20 Jul 2015 13:17:03 +0200
Message-ID: <1437391024-3141-1-git-send-email-pablo@netfilter.org>
Cc: ebiederm@xmission.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51659 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667AbbGTLLX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jul 2015 07:11:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This function reacquires the rtnl_lock() which is already held by
nf_unregister_hook().

This can be triggered via:

[  720.628746] INFO: task rmmod:3578 blocked for more than 120 seconds.
[  720.628749]       Not tainted 4.2.0-rc2+ #113
[  720.628752] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  720.628754] rmmod           D ffff8800ca46fd58     0  3578   3571 0x00000080
[  720.628761]  ffff8800ca46fd58 0000000000000000 0000000000000246 ffff8801183d6380
[  720.628769]  ffff8800c901e5c0 0000000000000000 ffff8800ca470000 0000000000000246
[  720.628776]  ffffffff81ab3c68 ffff8800c901e5c0 00000000ffffffff ffff8800ca46fd78
[  720.628783] Call Trace:
[  720.628790]  [<ffffffff8152ea0b>] schedule+0x6b/0x90
[  720.628795]  [<ffffffff8152ecb3>] schedule_preempt_disabled+0x13/0x20
[  720.628799]  [<ffffffff8152ff55>] mutex_lock_nested+0x1f5/0x380
[  720.628803]  [<ffffffff81462622>] ? rtnl_lock+0x12/0x20
[  720.628807]  [<ffffffff81462622>] ? rtnl_lock+0x12/0x20
[  720.628812]  [<ffffffff81462622>] rtnl_lock+0x12/0x20
[  720.628817]  [<ffffffff8148ab25>] nf_queue_nf_hook_drop+0x15/0x160
[  720.628825]  [<ffffffff81488d48>] nf_unregister_net_hook+0x168/0x190
[  720.628831]  [<ffffffff81488e24>] nf_unregister_hook+0x64/0x80
[  720.628837]  [<ffffffff81488e60>] nf_unregister_hooks+0x20/0x30
[  720.628844]  [<ffffffffa07e4b59>] nf_conntrack_l3proto_ipv4_fini+0x4f/0x4f6 [nf_conntrack_ipv4]
[  720.628851]  [<ffffffff810ec3cd>] SyS_delete_module+0x18d/0x230
[  720.628856]  [<ffffffff81534857>] entry_SYSCALL_64_fastpath+0x12/0x6f

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Fixes: 085db2c04557 ("netfilter: Per network namespace netfilter hooks.")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_queue.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 8a8b2ab..4ab2568 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -110,16 +110,14 @@ void nf_queue_nf_hook_drop(struct nf_hook_ops *ops)
 	const struct nf_queue_handler *qh;
 	struct net *net;
 
-	rtnl_lock();
 	rcu_read_lock();
 	qh = rcu_dereference(queue_handler);
 	if (qh) {
-		for_each_net(net) {
+		/* nf_hook_unregister() holds rtnl_lock() */
+		for_each_net(net)
 			qh->nf_hook_drop(net, ops);
-		}
 	}
 	rcu_read_unlock();
-	rtnl_unlock();
 }
 
 /*
-- 
1.7.10.4

