From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 31/34] netfilter: ipset: Make sure dumping can't grab set being just destroyed
Date: Sat,  2 May 2015 19:28:20 +0200
Message-ID: <1430587703-3387-32-git-send-email-kadlec@blackhole.kfki.hu>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:36729 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbbEBR2L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2015 13:28:11 -0400
In-Reply-To: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use the proper is_destroyed value and set the pointer to NULL under
the ip_set_ref_lock.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_core.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index eeaa9a0..4061557 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -957,12 +957,9 @@ ip_set_setname_policy[IPSET_ATTR_CMD_MAX + 1] = {
 };
 
 static void
-ip_set_destroy_set(struct ip_set_net *inst, ip_set_id_t index)
+ip_set_destroy_set(struct ip_set *set)
 {
-	struct ip_set *set = ip_set(inst, index);
-
 	pr_debug("set: %s\n",  set->name);
-	ip_set(inst, index) = NULL;
 
 	/* Must call it without holding any lock */
 	set->variant->destroy(set);
@@ -1006,8 +1003,10 @@ ip_set_destroy(struct sock *ctnl, struct sk_buff *skb,
 		read_unlock_bh(&ip_set_ref_lock);
 		for (i = 0; i < inst->ip_set_max; i++) {
 			s = ip_set(inst, i);
-			if (s != NULL)
-				ip_set_destroy_set(inst, i);
+			if (s != NULL) {
+				ip_set(inst, i) = NULL;
+				ip_set_destroy_set(s);
+			}
 		}
 		/* Modified by ip_set_destroy() only, which is serialized */
 		inst->is_destroyed = false;
@@ -1021,9 +1020,10 @@ ip_set_destroy(struct sock *ctnl, struct sk_buff *skb,
 			ret = -IPSET_ERR_BUSY;
 			goto out;
 		}
+		ip_set(inst, i) = NULL;
 		read_unlock_bh(&ip_set_ref_lock);
 
-		ip_set_destroy_set(inst, i);
+		ip_set_destroy_set(s);
 	}
 	return 0;
 out:
@@ -1263,6 +1263,7 @@ ip_set_dump_start(struct sk_buff *skb, struct netlink_callback *cb)
 	unsigned int flags = NETLINK_CB(cb->skb).portid ? NLM_F_MULTI : 0;
 	struct ip_set_net *inst = ip_set_pernet(sock_net(skb->sk));
 	u32 dump_type, dump_flags;
+	bool is_destroyed;
 	int ret = 0;
 
 	if (!cb->args[IPSET_CB_DUMP]) {
@@ -1291,13 +1292,14 @@ dump_last:
 		index = (ip_set_id_t) cb->args[IPSET_CB_INDEX];
 		write_lock_bh(&ip_set_ref_lock);
 		set = ip_set(inst, index);
-		if (set == NULL || inst->is_destroyed) {
+		is_destroyed = inst->is_destroyed;
+		if (set == NULL || is_destroyed) {
 			write_unlock_bh(&ip_set_ref_lock);
 			if (dump_type == DUMP_ONE) {
 				ret = -ENOENT;
 				goto out;
 			}
-			if (inst->is_destroyed) {
+			if (is_destroyed) {
 				/* All sets are just being destroyed */
 				ret = 0;
 				goto out;
@@ -2020,8 +2022,10 @@ ip_set_net_exit(struct net *net)
 
 	for (i = 0; i < inst->ip_set_max; i++) {
 		set = ip_set(inst, i);
-		if (set != NULL)
-			ip_set_destroy_set(inst, i);
+		if (set != NULL) {
+			ip_set(inst, i) = NULL;
+			ip_set_destroy_set(set);
+		}
 	}
 	kfree(rcu_dereference_protected(inst->ip_set_list, 1));
 }
-- 
1.8.5.1

