From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: ctnetlink: fix dumping of dying/unconfirmed conntracks
Date: Thu,  5 Jun 2014 14:28:44 +0200
Message-ID: <1401971324-9469-1-git-send-email-pablo@netfilter.org>
Cc: jbrouer@redhat.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55497 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbaFEM2w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jun 2014 08:28:52 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The dumping prematurely stops, it seems the callback argument that
indicates that all entries have been dumped is set after iterating
on the first cpu list. The dumping also may stop before the entire
per-cpu list content is also dumped.

With this patch, conntrack -L dying now shows the dying list content
again.

This problem was introduced in b7779d0 ("netfilter: conntrack: spinlock
per cpu to protect special lists.").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 15d8d52..0f480f8 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1165,9 +1165,6 @@ ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying
 	if (cb->args[2])
 		return 0;
 
-	if (cb->args[0] == nr_cpu_ids)
-		return 0;
-
 	for (cpu = cb->args[0]; cpu < nr_cpu_ids; cpu++) {
 		struct ct_pcpu *pcpu;
 
@@ -1196,6 +1193,7 @@ restart:
 			rcu_read_unlock();
 			if (res < 0) {
 				nf_conntrack_get(&ct->ct_general);
+				cb->args[0] = cpu;
 				cb->args[1] = (unsigned long)ct;
 				spin_unlock_bh(&pcpu->lock);
 				goto out;
@@ -1204,10 +1202,10 @@ restart:
 		if (cb->args[1]) {
 			cb->args[1] = 0;
 			goto restart;
-		} else
-			cb->args[2] = 1;
+		}
 		spin_unlock_bh(&pcpu->lock);
 	}
+	cb->args[2] = 1;
 out:
 	if (last)
 		nf_ct_put(last);
-- 
1.7.10.4

