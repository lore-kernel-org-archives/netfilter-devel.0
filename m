From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 16/19]: nfnetlink_log: fix instance_create() failure path
Date: Fri, 28 Sep 2007 18:30:59 +0200 (MEST)
Message-ID: <20070928163059.8394.12223.sendpatchset@localhost.localdomain>
References: <20070928163036.8394.36374.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55967 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757019AbXI1QbA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:31:00 -0400
In-Reply-To: <20070928163036.8394.36374.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nfnetlink_log: fix instance_create() failure path

Fix memory leak on instance_create() while module is being unloaded.

Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 57a86b3a876463c836eff7cd75c77fef5f16c773
tree 27c2ce3e65b9b86d621f090b98e852c637eeb432
parent d18594f2d34d0751245bfbfec7e5f6d742775774
author Michal Miroslaw <mirq-linux@rere.qmqm.pl> Fri, 28 Sep 2007 18:09:17 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 28 Sep 2007 18:09:17 +0200

 net/netfilter/nfnetlink_log.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index d2e811f..16ae539 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -152,6 +152,11 @@ instance_create(u_int16_t group_num, int pid)
 	if (!inst)
 		goto out_unlock;
 
+	if (!try_module_get(THIS_MODULE)) {
+		kfree(inst);
+		goto out_unlock;
+	}
+
 	INIT_HLIST_NODE(&inst->hlist);
 	spin_lock_init(&inst->lock);
 	/* needs to be two, since we _put() after creation */
@@ -168,9 +173,6 @@ instance_create(u_int16_t group_num, int pid)
 	inst->copy_mode 	= NFULNL_COPY_PACKET;
 	inst->copy_range 	= 0xffff;
 
-	if (!try_module_get(THIS_MODULE))
-		goto out_free;
-
 	hlist_add_head(&inst->hlist,
 		       &instance_table[instance_hashfn(group_num)]);
 
@@ -181,8 +183,6 @@ instance_create(u_int16_t group_num, int pid)
 
 	return inst;
 
-out_free:
-	instance_put(inst);
 out_unlock:
 	write_unlock_bh(&instances_lock);
 	return NULL;
