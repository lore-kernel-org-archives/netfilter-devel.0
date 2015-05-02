From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 11/34] netfilter: ipset: Make sure listing doesn't grab a set which is just being destroyed.
Date: Sat,  2 May 2015 19:28:00 +0200
Message-ID: <1430587703-3387-12-git-send-email-kadlec@blackhole.kfki.hu>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:51349 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbbEBR2F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2015 13:28:05 -0400
In-Reply-To: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There was a small window when all sets are destroyed and a concurrent
listing of all sets could grab a set which is just being destroyed.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_core.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 5f801b3..b00dd23 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -32,7 +32,8 @@ static DEFINE_RWLOCK(ip_set_ref_lock);		/* protects the set refs */
 struct ip_set_net {
 	struct ip_set * __rcu *ip_set_list;	/* all individual sets */
 	ip_set_id_t	ip_set_max;	/* max number of sets */
-	int		is_deleted;	/* deleted by ip_set_net_exit */
+	bool		is_deleted;	/* deleted by ip_set_net_exit */
+	bool		is_destroyed;	/* all sets are destroyed */
 };
 static int ip_set_net_id __read_mostly;
 
@@ -991,12 +992,15 @@ ip_set_destroy(struct sock *ctnl, struct sk_buff *skb,
 				goto out;
 			}
 		}
+		inst->is_destroyed = true;
 		read_unlock_bh(&ip_set_ref_lock);
 		for (i = 0; i < inst->ip_set_max; i++) {
 			s = ip_set(inst, i);
 			if (s != NULL)
 				ip_set_destroy_set(inst, i);
 		}
+		/* Modified by ip_set_destroy() only, which is serialized */
+		inst->is_destroyed = false;
 	} else {
 		s = find_set_and_id(inst, nla_data(attr[IPSET_ATTR_SETNAME]),
 				    &i);
@@ -1275,12 +1279,19 @@ dump_last:
 		 dump_type, dump_flags, cb->args[IPSET_CB_INDEX]);
 	for (; cb->args[IPSET_CB_INDEX] < max; cb->args[IPSET_CB_INDEX]++) {
 		index = (ip_set_id_t) cb->args[IPSET_CB_INDEX];
+		write_lock_bh(&ip_set_ref_lock);
 		set = ip_set(inst, index);
-		if (set == NULL) {
+		if (set == NULL || inst->is_destroyed) {
+			write_unlock_bh(&ip_set_ref_lock);
 			if (dump_type == DUMP_ONE) {
 				ret = -ENOENT;
 				goto out;
 			}
+			if (inst->is_destroyed) {
+				/* All sets are just being destroyed */
+				ret = 0;
+				goto out;
+			}
 			continue;
 		}
 		/* When dumping all sets, we must dump "sorted"
@@ -1288,14 +1299,17 @@ dump_last:
 		 */
 		if (dump_type != DUMP_ONE &&
 		    ((dump_type == DUMP_ALL) ==
-		     !!(set->type->features & IPSET_DUMP_LAST)))
+		     !!(set->type->features & IPSET_DUMP_LAST))) {
+			write_unlock_bh(&ip_set_ref_lock);
 			continue;
+		}
 		pr_debug("List set: %s\n", set->name);
 		if (!cb->args[IPSET_CB_ARG0]) {
 			/* Start listing: make sure set won't be destroyed */
 			pr_debug("reference set\n");
-			__ip_set_get(set);
+			set->ref++;
 		}
+		write_unlock_bh(&ip_set_ref_lock);
 		nlh = start_msg(skb, NETLINK_CB(cb->skb).portid,
 				cb->nlh->nlmsg_seq, flags,
 				IPSET_CMD_LIST);
@@ -1978,7 +1992,8 @@ ip_set_net_init(struct net *net)
 	list = kzalloc(sizeof(struct ip_set *) * inst->ip_set_max, GFP_KERNEL);
 	if (!list)
 		return -ENOMEM;
-	inst->is_deleted = 0;
+	inst->is_deleted = false;
+	inst->is_destroyed = false;
 	rcu_assign_pointer(inst->ip_set_list, list);
 	return 0;
 }
@@ -1991,7 +2006,7 @@ ip_set_net_exit(struct net *net)
 	struct ip_set *set = NULL;
 	ip_set_id_t i;
 
-	inst->is_deleted = 1; /* flag for ip_set_nfnl_put */
+	inst->is_deleted = true; /* flag for ip_set_nfnl_put */
 
 	for (i = 0; i < inst->ip_set_max; i++) {
 		set = ip_set(inst, i);
-- 
1.8.5.1

