From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 2/2] netfilter: ipt_CLUSTERIP: put config instead of freeing it
Date: Fri, 16 Feb 2018 12:49:33 +0100
Message-ID: <20180216114933.23667-3-fw@strlen.de>
References: <20180216114933.23667-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50908 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965371AbeBPLvi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Feb 2018 06:51:38 -0500
In-Reply-To: <20180216114933.23667-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Once struct is added to per-netns list it becomes visible to other cpus,
so we cannot use kfree().

Also delay setting entries refcount to 1 until after everything is
initialised so that when we call clusterip_config_put() in this spot
entries is still zero.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 4c8cfd352687..8a8ae61cea71 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -232,7 +232,6 @@ clusterip_config_init(struct net *net, const struct ipt_clusterip_tgt_info *i,
 	c->hash_mode = i->hash_mode;
 	c->hash_initval = i->hash_initval;
 	refcount_set(&c->refcount, 1);
-	refcount_set(&c->entries, 1);
 
 	spin_lock_bh(&cn->lock);
 	if (__clusterip_config_find(net, ip)) {
@@ -263,8 +262,10 @@ clusterip_config_init(struct net *net, const struct ipt_clusterip_tgt_info *i,
 
 	c->notifier.notifier_call = clusterip_netdev_event;
 	err = register_netdevice_notifier(&c->notifier);
-	if (!err)
+	if (!err) {
+		refcount_set(&c->entries, 1);
 		return c;
+	}
 
 #ifdef CONFIG_PROC_FS
 	proc_remove(c->pde);
@@ -273,7 +274,7 @@ clusterip_config_init(struct net *net, const struct ipt_clusterip_tgt_info *i,
 	spin_lock_bh(&cn->lock);
 	list_del_rcu(&c->list);
 	spin_unlock_bh(&cn->lock);
-	kfree(c);
+	clusterip_config_put(c);
 
 	return ERR_PTR(err);
 }
-- 
2.16.1

