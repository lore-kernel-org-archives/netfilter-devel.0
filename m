From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 nf-next 09/12] nfnetlink: add nfnl_dereference_protected helper
Date: Thu,  3 Dec 2015 10:49:42 +0100
Message-ID: <1449136185-4165-10-git-send-email-fw@strlen.de>
References: <1449136185-4165-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52610 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759429AbbLCJuZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Dec 2015 04:50:25 -0500
In-Reply-To: <1449136185-4165-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

to avoid overly long line in followup patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 not part of v2 series.

 net/netfilter/nfnetlink.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 46453ab..197b2c6 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -33,6 +33,10 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_ALIAS_NET_PF_PROTO(PF_NETLINK, NETLINK_NETFILTER);
 
+#define nfnl_dereference_protected(id) \
+	rcu_dereference_protected(table[(id)].subsys, \
+				  lockdep_nfnl_is_held((id)))
+
 static char __initdata nfversion[] = "0.30";
 
 static struct {
@@ -207,8 +211,7 @@ replay:
 		} else {
 			rcu_read_unlock();
 			nfnl_lock(subsys_id);
-			if (rcu_dereference_protected(table[subsys_id].subsys,
-				lockdep_is_held(&table[subsys_id].mutex)) != ss ||
+			if (nfnl_dereference_protected(subsys_id) != ss ||
 			    nfnetlink_find_client(type, ss) != nc)
 				err = -EAGAIN;
 			else if (nc->call)
@@ -298,15 +301,13 @@ replay:
 	skb->sk = oskb->sk;
 
 	nfnl_lock(subsys_id);
-	ss = rcu_dereference_protected(table[subsys_id].subsys,
-				       lockdep_is_held(&table[subsys_id].mutex));
+	ss = nfnl_dereference_protected(subsys_id);
 	if (!ss) {
 #ifdef CONFIG_MODULES
 		nfnl_unlock(subsys_id);
 		request_module("nfnetlink-subsys-%d", subsys_id);
 		nfnl_lock(subsys_id);
-		ss = rcu_dereference_protected(table[subsys_id].subsys,
-					       lockdep_is_held(&table[subsys_id].mutex));
+		ss = nfnl_dereference_protected(subsys_id);
 		if (!ss)
 #endif
 		{
-- 
2.4.10

