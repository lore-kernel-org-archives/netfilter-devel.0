From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 08/24] [NETFILTER]: rename NF_ARP to AF_ARP and assign a non-clashing value
Date: Wed,  2 Apr 2008 13:11:50 +0200
Message-ID: <846a3697441043b20a99abac8046aad205938256.1207134547.git.jengelh@computergmbh.de>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43155 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916AbYDBLMK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:12:10 -0400
In-Reply-To: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <455b3b0ee249d17dff621933f163b8d5e377eb8f.1207134547.git.jengelh@computergmbh.de>
References: <455b3b0ee249d17dff621933f163b8d5e377eb8f.1207134547.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

For coming Xtables patches, we want to use AF_UNSPEC, but NF_ARP
currently evaluates to the same value so it gets changed.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 include/linux/netfilter_arp.h        |    3 -
 include/linux/socket.h               |    2 +
 net/bridge/br_netfilter.c            |    2 +-
 net/ipv4/arp.c                       |    4 +-
 net/ipv4/netfilter/arp_tables.c      |   56 +++++++++++++-------------
 net/ipv4/netfilter/arpt_mangle.c     |    2 +-
 net/ipv4/netfilter/arptable_filter.c |    8 ++--
 net/ipv4/netfilter/ipt_CLUSTERIP.c   |    2 +-
 net/netfilter/x_tables.c             |    2 +-
 net/netfilter/xt_NFQUEUE.c           |    2 +-
 10 files changed, 41 insertions(+), 42 deletions(-)

diff --git a/include/linux/netfilter_arp.h b/include/linux/netfilter_arp.h
index 92bc6dd..ca3360a 100644
--- a/include/linux/netfilter_arp.h
+++ b/include/linux/netfilter_arp.h
@@ -7,9 +7,6 @@
 
 #include <linux/netfilter.h>
 
-/* There is no PF_ARP. */
-#define NF_ARP		0
-
 /* ARP Hooks */
 #define NF_ARP_IN	0
 #define NF_ARP_OUT	1
diff --git a/include/linux/socket.h b/include/linux/socket.h
index bd2b30a..ae4b4eb 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -179,6 +179,7 @@ struct ucred {
 #define AF_ASH		18	/* Ash				*/
 #define AF_ECONET	19	/* Acorn Econet			*/
 #define AF_ATMSVC	20	/* ATM SVCs			*/
+#define AF_ARP		21	/* Address Resolution for IPv4	*/
 #define AF_SNA		22	/* Linux SNA Project (nutters!) */
 #define AF_IRDA		23	/* IRDA sockets			*/
 #define AF_PPPOX	24	/* PPPoX sockets		*/
@@ -215,6 +216,7 @@ struct ucred {
 #define PF_ASH		AF_ASH
 #define PF_ECONET	AF_ECONET
 #define PF_ATMSVC	AF_ATMSVC
+#define PF_ARP		AF_ARP
 #define PF_SNA		AF_SNA
 #define PF_IRDA		AF_IRDA
 #define PF_PPPOX	AF_PPPOX
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 36fdfcb..9712304 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -711,7 +711,7 @@ static unsigned int br_nf_forward_arp(unsigned int hook, struct sk_buff *skb,
 		return NF_ACCEPT;
 	}
 	*d = (struct net_device *)in;
-	NF_HOOK(NF_ARP, NF_ARP_FORWARD, skb, (struct net_device *)in,
+	NF_HOOK(AF_ARP, NF_ARP_FORWARD, skb, (struct net_device *)in,
 		(struct net_device *)out, br_nf_forward_finish);
 
 	return NF_STOLEN;
diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 3ce2e13..633a77b 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -664,7 +664,7 @@ out:
 void arp_xmit(struct sk_buff *skb)
 {
 	/* Send it off, maybe filter it using firewalling first.  */
-	NF_HOOK(NF_ARP, NF_ARP_OUT, skb, NULL, skb->dev, dev_queue_xmit);
+	NF_HOOK(AF_ARP, NF_ARP_OUT, skb, NULL, skb->dev, dev_queue_xmit);
 }
 
 /*
@@ -929,7 +929,7 @@ static int arp_rcv(struct sk_buff *skb, struct net_device *dev,
 
 	memset(NEIGH_CB(skb), 0, sizeof(struct neighbour_cb));
 
-	return NF_HOOK(NF_ARP, NF_ARP_IN, skb, dev, NULL, arp_process);
+	return NF_HOOK(AF_ARP, NF_ARP_IN, skb, dev, NULL, arp_process);
 
 freeskb:
 	kfree_skb(skb);
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 056f0ff..18aa5ac 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -463,7 +463,7 @@ static inline int check_target(struct arpt_entry *e, const char *name)
 	t = arpt_get_target(e);
 	target = t->u.kernel.target;
 
-	ret = xt_check_target(target, NF_ARP, t->u.target_size - sizeof(*t),
+	ret = xt_check_target(target, AF_ARP, t->u.target_size - sizeof(*t),
 			      name, e->comefrom, 0, 0);
 	if (!ret && t->u.kernel.target->checkentry
 	    && !t->u.kernel.target->checkentry(name, e, target, t->data,
@@ -488,7 +488,7 @@ find_check_entry(struct arpt_entry *e, const char *name, unsigned int size,
 		return ret;
 
 	t = arpt_get_target(e);
-	target = try_then_request_module(xt_find_target(NF_ARP, t->u.user.name,
+	target = try_then_request_module(xt_find_target(AF_ARP, t->u.user.name,
 							t->u.user.revision),
 					 "arpt_%s", t->u.user.name);
 	if (IS_ERR(target) || !target) {
@@ -788,7 +788,7 @@ static void compat_standard_from_user(void *dst, void *src)
 	int v = *(compat_int_t *)src;
 
 	if (v > 0)
-		v += xt_compat_calc_jump(NF_ARP, v);
+		v += xt_compat_calc_jump(AF_ARP, v);
 	memcpy(dst, &v, sizeof(v));
 }
 
@@ -797,7 +797,7 @@ static int compat_standard_to_user(void __user *dst, void *src)
 	compat_int_t cv = *(int *)src;
 
 	if (cv > 0)
-		cv -= xt_compat_calc_jump(NF_ARP, cv);
+		cv -= xt_compat_calc_jump(AF_ARP, cv);
 	return copy_to_user(dst, &cv, sizeof(cv)) ? -EFAULT : 0;
 }
 
@@ -815,7 +815,7 @@ static int compat_calc_entry(struct arpt_entry *e,
 	t = arpt_get_target(e);
 	off += xt_compat_target_offset(t->u.kernel.target);
 	newinfo->size -= off;
-	ret = xt_compat_add_offset(NF_ARP, entry_offset, off);
+	ret = xt_compat_add_offset(AF_ARP, entry_offset, off);
 	if (ret)
 		return ret;
 
@@ -866,9 +866,9 @@ static int get_info(struct net *net, void __user *user, int *len, int compat)
 	name[ARPT_TABLE_MAXNAMELEN-1] = '\0';
 #ifdef CONFIG_COMPAT
 	if (compat)
-		xt_compat_lock(NF_ARP);
+		xt_compat_lock(AF_ARP);
 #endif
-	t = try_then_request_module(xt_find_table_lock(net, NF_ARP, name),
+	t = try_then_request_module(xt_find_table_lock(net, AF_ARP, name),
 				    "arptable_%s", name);
 	if (t && !IS_ERR(t)) {
 		struct arpt_getinfo info;
@@ -878,7 +878,7 @@ static int get_info(struct net *net, void __user *user, int *len, int compat)
 		if (compat) {
 			struct xt_table_info tmp;
 			ret = compat_table_info(private, &tmp);
-			xt_compat_flush_offsets(NF_ARP);
+			xt_compat_flush_offsets(AF_ARP);
 			private = &tmp;
 		}
 #endif
@@ -901,7 +901,7 @@ static int get_info(struct net *net, void __user *user, int *len, int compat)
 		ret = t ? PTR_ERR(t) : -ENOENT;
 #ifdef CONFIG_COMPAT
 	if (compat)
-		xt_compat_unlock(NF_ARP);
+		xt_compat_unlock(AF_ARP);
 #endif
 	return ret;
 }
@@ -925,7 +925,7 @@ static int get_entries(struct net *net, struct arpt_get_entries __user *uptr,
 		return -EINVAL;
 	}
 
-	t = xt_find_table_lock(net, NF_ARP, get.name);
+	t = xt_find_table_lock(net, AF_ARP, get.name);
 	if (t && !IS_ERR(t)) {
 		const struct xt_table_info *private = t->private;
 
@@ -967,7 +967,7 @@ static int __do_replace(struct net *net, const char *name,
 		goto out;
 	}
 
-	t = try_then_request_module(xt_find_table_lock(net, NF_ARP, name),
+	t = try_then_request_module(xt_find_table_lock(net, AF_ARP, name),
 				    "arptable_%s", name);
 	if (!t || IS_ERR(t)) {
 		ret = t ? PTR_ERR(t) : -ENOENT;
@@ -1134,7 +1134,7 @@ static int do_add_counters(struct net *net, void __user *user, unsigned int len,
 		goto free;
 	}
 
-	t = xt_find_table_lock(net, NF_ARP, name);
+	t = xt_find_table_lock(net, AF_ARP, name);
 	if (!t || IS_ERR(t)) {
 		ret = t ? PTR_ERR(t) : -ENOENT;
 		goto free;
@@ -1218,7 +1218,7 @@ check_compat_entry_size_and_hooks(struct compat_arpt_entry *e,
 	entry_offset = (void *)e - (void *)base;
 
 	t = compat_arpt_get_target(e);
-	target = try_then_request_module(xt_find_target(NF_ARP,
+	target = try_then_request_module(xt_find_target(AF_ARP,
 							t->u.user.name,
 							t->u.user.revision),
 					 "arpt_%s", t->u.user.name);
@@ -1232,7 +1232,7 @@ check_compat_entry_size_and_hooks(struct compat_arpt_entry *e,
 
 	off += xt_compat_target_offset(target);
 	*size += off;
-	ret = xt_compat_add_offset(NF_ARP, entry_offset, off);
+	ret = xt_compat_add_offset(AF_ARP, entry_offset, off);
 	if (ret)
 		goto release_target;
 
@@ -1333,7 +1333,7 @@ static int translate_compat_table(const char *name,
 
 	duprintf("translate_compat_table: size %u\n", info->size);
 	j = 0;
-	xt_compat_lock(NF_ARP);
+	xt_compat_lock(AF_ARP);
 	/* Walk through entries, checking offsets. */
 	ret = COMPAT_ARPT_ENTRY_ITERATE(entry0, total_size,
 					check_compat_entry_size_and_hooks,
@@ -1383,8 +1383,8 @@ static int translate_compat_table(const char *name,
 	ret = COMPAT_ARPT_ENTRY_ITERATE(entry0, total_size,
 					compat_copy_entry_from_user,
 					&pos, &size, name, newinfo, entry1);
-	xt_compat_flush_offsets(NF_ARP);
-	xt_compat_unlock(NF_ARP);
+	xt_compat_flush_offsets(AF_ARP);
+	xt_compat_unlock(AF_ARP);
 	if (ret)
 		goto free_newinfo;
 
@@ -1420,8 +1420,8 @@ out:
 	COMPAT_ARPT_ENTRY_ITERATE(entry0, total_size, compat_release_entry, &j);
 	return ret;
 out_unlock:
-	xt_compat_flush_offsets(NF_ARP);
-	xt_compat_unlock(NF_ARP);
+	xt_compat_flush_offsets(AF_ARP);
+	xt_compat_unlock(AF_ARP);
 	goto out;
 }
 
@@ -1607,8 +1607,8 @@ static int compat_get_entries(struct net *net,
 		return -EINVAL;
 	}
 
-	xt_compat_lock(NF_ARP);
-	t = xt_find_table_lock(net, NF_ARP, get.name);
+	xt_compat_lock(AF_ARP);
+	t = xt_find_table_lock(net, AF_ARP, get.name);
 	if (t && !IS_ERR(t)) {
 		const struct xt_table_info *private = t->private;
 		struct xt_table_info info;
@@ -1623,13 +1623,13 @@ static int compat_get_entries(struct net *net,
 				 private->size, get.size);
 			ret = -EINVAL;
 		}
-		xt_compat_flush_offsets(NF_ARP);
+		xt_compat_flush_offsets(AF_ARP);
 		module_put(t->me);
 		xt_table_unlock(t);
 	} else
 		ret = t ? PTR_ERR(t) : -ENOENT;
 
-	xt_compat_unlock(NF_ARP);
+	xt_compat_unlock(AF_ARP);
 	return ret;
 }
 
@@ -1709,7 +1709,7 @@ static int do_arpt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len
 			break;
 		}
 
-		try_then_request_module(xt_find_revision(NF_ARP, rev.name,
+		try_then_request_module(xt_find_revision(AF_ARP, rev.name,
 							 rev.revision, 1, &ret),
 					"arpt_%s", rev.name);
 		break;
@@ -1787,7 +1787,7 @@ void arpt_unregister_table(struct xt_table *table)
 static struct xt_target arpt_standard_target __read_mostly = {
 	.name		= XT_STANDARD_TARGET,
 	.targetsize	= sizeof(int),
-	.family		= NF_ARP,
+	.family		= AF_ARP,
 #ifdef CONFIG_COMPAT
 	.compatsize	= sizeof(compat_int_t),
 	.compat_from_user = compat_standard_from_user,
@@ -1799,7 +1799,7 @@ static struct xt_target arpt_error_target __read_mostly = {
 	.name		= XT_ERROR_TARGET,
 	.target		= arpt_error,
 	.targetsize	= ARPT_FUNCTION_MAXNAMELEN,
-	.family		= NF_ARP,
+	.family		= AF_ARP,
 };
 
 static struct nf_sockopt_ops arpt_sockopts = {
@@ -1821,12 +1821,12 @@ static struct nf_sockopt_ops arpt_sockopts = {
 
 static int __net_init arp_tables_net_init(struct net *net)
 {
-	return xt_proto_init(net, NF_ARP);
+	return xt_proto_init(net, AF_ARP);
 }
 
 static void __net_exit arp_tables_net_exit(struct net *net)
 {
-	xt_proto_fini(net, NF_ARP);
+	xt_proto_fini(net, AF_ARP);
 }
 
 static struct pernet_operations arp_tables_net_ops = {
diff --git a/net/ipv4/netfilter/arpt_mangle.c b/net/ipv4/netfilter/arpt_mangle.c
index 6cccaab..dabf45a 100644
--- a/net/ipv4/netfilter/arpt_mangle.c
+++ b/net/ipv4/netfilter/arpt_mangle.c
@@ -75,7 +75,7 @@ checkentry(const char *tablename, const void *e, const struct xt_target *target,
 
 static struct xt_target arpt_mangle_reg __read_mostly = {
 	.name		= "mangle",
-	.family		= NF_ARP,
+	.family		= AF_ARP,
 	.target		= target,
 	.targetsize	= sizeof(struct arpt_mangle),
 	.checkentry	= checkentry,
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 2ed7d72..56c8db9 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -51,7 +51,7 @@ static struct xt_table packet_filter = {
 	.lock		= RW_LOCK_UNLOCKED,
 	.private	= NULL,
 	.me		= THIS_MODULE,
-	.af		= NF_ARP,
+	.af		= AF_ARP,
 };
 
 /* The work comes in here from netfilter.c */
@@ -68,19 +68,19 @@ static struct nf_hook_ops arpt_ops[] __read_mostly = {
 	{
 		.hook		= arpt_hook,
 		.owner		= THIS_MODULE,
-		.pf		= NF_ARP,
+		.pf		= AF_ARP,
 		.hooknum	= NF_ARP_IN,
 	},
 	{
 		.hook		= arpt_hook,
 		.owner		= THIS_MODULE,
-		.pf		= NF_ARP,
+		.pf		= AF_ARP,
 		.hooknum	= NF_ARP_OUT,
 	},
 	{
 		.hook		= arpt_hook,
 		.owner		= THIS_MODULE,
-		.pf		= NF_ARP,
+		.pf		= AF_ARP,
 		.hooknum	= NF_ARP_FORWARD,
 	},
 };
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 2510d4f..64663e2 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -545,7 +545,7 @@ arp_mangle(unsigned int hook,
 
 static struct nf_hook_ops cip_arp_ops __read_mostly = {
 	.hook = arp_mangle,
-	.pf = NF_ARP,
+	.pf = AF_ARP,
 	.hooknum = NF_ARP_OUT,
 	.priority = -1
 };
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 9afec64..9dc1520 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -61,7 +61,7 @@ static struct xt_af *xt;
 static const char *const xt_prefix[NPROTO] = {
 	[AF_INET]	= "ip",
 	[AF_INET6]	= "ip6",
-	[NF_ARP]	= "arp",
+	[AF_ARP]	= "arp",
 };
 
 /* Registration hooks for targets. */
diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index beb24d1..e18ad69 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -50,7 +50,7 @@ static struct xt_target nfqueue_tg_reg[] __read_mostly = {
 	},
 	{
 		.name		= "NFQUEUE",
-		.family		= NF_ARP,
+		.family		= AF_ARP,
 		.target		= nfqueue_tg,
 		.targetsize	= sizeof(struct xt_NFQ_info),
 		.me		= THIS_MODULE,
-- 
1.5.4.4

