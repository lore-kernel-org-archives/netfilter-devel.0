From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 3/8] [NETFILTER]: rename NF_ARP to NFPROTO_ARP and assign a non-clashing value
Date: Tue,  8 Apr 2008 17:31:34 +0200
Message-ID: <2a75525ff0d60f2e71df2c9c3d040d3a76451713.1207668694.git.jengelh@computergmbh.de>
References: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37102 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbYDHPbl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2008 11:31:41 -0400
In-Reply-To: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de>
In-Reply-To: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de>
References: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

For coming Xtables patches, we want to use PF_UNSPEC, but NF_ARP
currently evaluates to the same value so it gets changed. The
constant is renamed to NFPROTO_ARP, in the naming spirit of
IPPROTO_*.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 include/linux/netfilter.h            |   10 ++++-
 include/linux/netfilter_arp.h        |    3 -
 net/bridge/br_netfilter.c            |    2 +-
 net/ipv4/arp.c                       |    4 +-
 net/ipv4/netfilter/arp_tables.c      |   58 +++++++++++++------------
 net/ipv4/netfilter/arpt_mangle.c     |    2 +-
 net/ipv4/netfilter/arptable_filter.c |    8 ++--
 net/ipv4/netfilter/ipt_CLUSTERIP.c   |    2 +-
 net/netfilter/core.c                 |    6 +-
 net/netfilter/nf_log.c               |   12 +++---
 net/netfilter/nf_queue.c             |   12 +++---
 net/netfilter/x_tables.c             |   12 +++---
 net/netfilter/xt_NFQUEUE.c           |    2 +-
 13 files changed, 69 insertions(+), 64 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index d76a65b..b915f60 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -63,6 +63,12 @@ union nf_inet_addr {
 #ifdef __KERNEL__
 #ifdef CONFIG_NETFILTER
 
+enum {
+	__NFPROTO_MIN = AF_MAX,
+	NFPROTO_ARP,
+	__NFPROTO_MAX,
+};
+
 static inline int nf_inet_addr_cmp(const union nf_inet_addr *a1,
 				   const union nf_inet_addr *a2)
 {
@@ -138,7 +144,7 @@ extern struct ctl_path nf_net_netfilter_sysctl_path[];
 extern struct ctl_path nf_net_ipv4_netfilter_sysctl_path[];
 #endif /* CONFIG_SYSCTL */
 
-extern struct list_head nf_hooks[NPROTO][NF_MAX_HOOKS];
+extern struct list_head nf_hooks[][NF_MAX_HOOKS];
 
 int nf_hook_slow(u_int16_t pf, unsigned int hook, struct sk_buff *skb,
 		 struct net_device *indev, struct net_device *outdev,
@@ -247,7 +253,7 @@ struct nf_afinfo {
 	int		route_key_size;
 };
 
-extern const struct nf_afinfo *nf_afinfo[NPROTO];
+extern const struct nf_afinfo *nf_afinfo[];
 static inline const struct nf_afinfo *nf_get_afinfo(unsigned short family)
 {
 	return rcu_dereference(nf_afinfo[family]);
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
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 98ce388..7dd5f60 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -711,7 +711,7 @@ static unsigned int br_nf_forward_arp(unsigned int hook, struct sk_buff *skb,
 		return NF_ACCEPT;
 	}
 	*d = (struct net_device *)in;
-	NF_HOOK(NF_ARP, NF_ARP_FORWARD, skb, (struct net_device *)in,
+	NF_HOOK(NFPROTO_ARP, NF_ARP_FORWARD, skb, (struct net_device *)in,
 		(struct net_device *)out, br_nf_forward_finish);
 
 	return NF_STOLEN;
diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 3ce2e13..d37ebd6 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -664,7 +664,7 @@ out:
 void arp_xmit(struct sk_buff *skb)
 {
 	/* Send it off, maybe filter it using firewalling first.  */
-	NF_HOOK(NF_ARP, NF_ARP_OUT, skb, NULL, skb->dev, dev_queue_xmit);
+	NF_HOOK(NFPROTO_ARP, NF_ARP_OUT, skb, NULL, skb->dev, dev_queue_xmit);
 }
 
 /*
@@ -929,7 +929,7 @@ static int arp_rcv(struct sk_buff *skb, struct net_device *dev,
 
 	memset(NEIGH_CB(skb), 0, sizeof(struct neighbour_cb));
 
-	return NF_HOOK(NF_ARP, NF_ARP_IN, skb, dev, NULL, arp_process);
+	return NF_HOOK(NFPROTO_ARP, NF_ARP_IN, skb, dev, NULL, arp_process);
 
 freeskb:
 	kfree_skb(skb);
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 851c4f4..5f47d3a 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -463,7 +463,8 @@ static inline int check_target(struct arpt_entry *e, const char *name)
 	t = arpt_get_target(e);
 	target = t->u.kernel.target;
 
-	ret = xt_check_target(target, NF_ARP, t->u.target_size - sizeof(*t),
+	ret = xt_check_target(target, NFPROTO_ARP,
+			      t->u.target_size - sizeof(*t),
 			      name, e->comefrom, 0, 0);
 	if (!ret && t->u.kernel.target->checkentry
 	    && !t->u.kernel.target->checkentry(name, e, target, t->data,
@@ -488,7 +489,8 @@ find_check_entry(struct arpt_entry *e, const char *name, unsigned int size,
 		return ret;
 
 	t = arpt_get_target(e);
-	target = try_then_request_module(xt_find_target(NF_ARP, t->u.user.name,
+	target = try_then_request_module(xt_find_target(NFPROTO_ARP,
+							t->u.user.name,
 							t->u.user.revision),
 					 "arpt_%s", t->u.user.name);
 	if (IS_ERR(target) || !target) {
@@ -788,7 +790,7 @@ static void compat_standard_from_user(void *dst, void *src)
 	int v = *(compat_int_t *)src;
 
 	if (v > 0)
-		v += xt_compat_calc_jump(NF_ARP, v);
+		v += xt_compat_calc_jump(NFPROTO_ARP, v);
 	memcpy(dst, &v, sizeof(v));
 }
 
@@ -797,7 +799,7 @@ static int compat_standard_to_user(void __user *dst, void *src)
 	compat_int_t cv = *(int *)src;
 
 	if (cv > 0)
-		cv -= xt_compat_calc_jump(NF_ARP, cv);
+		cv -= xt_compat_calc_jump(NFPROTO_ARP, cv);
 	return copy_to_user(dst, &cv, sizeof(cv)) ? -EFAULT : 0;
 }
 
@@ -815,7 +817,7 @@ static int compat_calc_entry(struct arpt_entry *e,
 	t = arpt_get_target(e);
 	off += xt_compat_target_offset(t->u.kernel.target);
 	newinfo->size -= off;
-	ret = xt_compat_add_offset(NF_ARP, entry_offset, off);
+	ret = xt_compat_add_offset(NFPROTO_ARP, entry_offset, off);
 	if (ret)
 		return ret;
 
@@ -866,9 +868,9 @@ static int get_info(struct net *net, void __user *user, int *len, int compat)
 	name[ARPT_TABLE_MAXNAMELEN-1] = '\0';
 #ifdef CONFIG_COMPAT
 	if (compat)
-		xt_compat_lock(NF_ARP);
+		xt_compat_lock(NFPROTO_ARP);
 #endif
-	t = try_then_request_module(xt_find_table_lock(net, NF_ARP, name),
+	t = try_then_request_module(xt_find_table_lock(net, NFPROTO_ARP, name),
 				    "arptable_%s", name);
 	if (t && !IS_ERR(t)) {
 		struct arpt_getinfo info;
@@ -878,7 +880,7 @@ static int get_info(struct net *net, void __user *user, int *len, int compat)
 		if (compat) {
 			struct xt_table_info tmp;
 			ret = compat_table_info(private, &tmp);
-			xt_compat_flush_offsets(NF_ARP);
+			xt_compat_flush_offsets(NFPROTO_ARP);
 			private = &tmp;
 		}
 #endif
@@ -901,7 +903,7 @@ static int get_info(struct net *net, void __user *user, int *len, int compat)
 		ret = t ? PTR_ERR(t) : -ENOENT;
 #ifdef CONFIG_COMPAT
 	if (compat)
-		xt_compat_unlock(NF_ARP);
+		xt_compat_unlock(NFPROTO_ARP);
 #endif
 	return ret;
 }
@@ -925,7 +927,7 @@ static int get_entries(struct net *net, struct arpt_get_entries __user *uptr,
 		return -EINVAL;
 	}
 
-	t = xt_find_table_lock(net, NF_ARP, get.name);
+	t = xt_find_table_lock(net, NFPROTO_ARP, get.name);
 	if (t && !IS_ERR(t)) {
 		const struct xt_table_info *private = t->private;
 
@@ -967,7 +969,7 @@ static int __do_replace(struct net *net, const char *name,
 		goto out;
 	}
 
-	t = try_then_request_module(xt_find_table_lock(net, NF_ARP, name),
+	t = try_then_request_module(xt_find_table_lock(net, NFPROTO_ARP, name),
 				    "arptable_%s", name);
 	if (!t || IS_ERR(t)) {
 		ret = t ? PTR_ERR(t) : -ENOENT;
@@ -1134,7 +1136,7 @@ static int do_add_counters(struct net *net, void __user *user, unsigned int len,
 		goto free;
 	}
 
-	t = xt_find_table_lock(net, NF_ARP, name);
+	t = xt_find_table_lock(net, NFPROTO_ARP, name);
 	if (!t || IS_ERR(t)) {
 		ret = t ? PTR_ERR(t) : -ENOENT;
 		goto free;
@@ -1218,7 +1220,7 @@ check_compat_entry_size_and_hooks(struct compat_arpt_entry *e,
 	entry_offset = (void *)e - (void *)base;
 
 	t = compat_arpt_get_target(e);
-	target = try_then_request_module(xt_find_target(NF_ARP,
+	target = try_then_request_module(xt_find_target(NFPROTO_ARP,
 							t->u.user.name,
 							t->u.user.revision),
 					 "arpt_%s", t->u.user.name);
@@ -1232,7 +1234,7 @@ check_compat_entry_size_and_hooks(struct compat_arpt_entry *e,
 
 	off += xt_compat_target_offset(target);
 	*size += off;
-	ret = xt_compat_add_offset(NF_ARP, entry_offset, off);
+	ret = xt_compat_add_offset(NFPROTO_ARP, entry_offset, off);
 	if (ret)
 		goto release_target;
 
@@ -1333,7 +1335,7 @@ static int translate_compat_table(const char *name,
 
 	duprintf("translate_compat_table: size %u\n", info->size);
 	j = 0;
-	xt_compat_lock(NF_ARP);
+	xt_compat_lock(NFPROTO_ARP);
 	/* Walk through entries, checking offsets. */
 	ret = COMPAT_ARPT_ENTRY_ITERATE(entry0, total_size,
 					check_compat_entry_size_and_hooks,
@@ -1383,8 +1385,8 @@ static int translate_compat_table(const char *name,
 	ret = COMPAT_ARPT_ENTRY_ITERATE(entry0, total_size,
 					compat_copy_entry_from_user,
 					&pos, &size, name, newinfo, entry1);
-	xt_compat_flush_offsets(NF_ARP);
-	xt_compat_unlock(NF_ARP);
+	xt_compat_flush_offsets(NFPROTO_ARP);
+	xt_compat_unlock(NFPROTO_ARP);
 	if (ret)
 		goto free_newinfo;
 
@@ -1420,8 +1422,8 @@ out:
 	COMPAT_ARPT_ENTRY_ITERATE(entry0, total_size, compat_release_entry, &j);
 	return ret;
 out_unlock:
-	xt_compat_flush_offsets(NF_ARP);
-	xt_compat_unlock(NF_ARP);
+	xt_compat_flush_offsets(NFPROTO_ARP);
+	xt_compat_unlock(NFPROTO_ARP);
 	goto out;
 }
 
@@ -1607,8 +1609,8 @@ static int compat_get_entries(struct net *net,
 		return -EINVAL;
 	}
 
-	xt_compat_lock(NF_ARP);
-	t = xt_find_table_lock(net, NF_ARP, get.name);
+	xt_compat_lock(NFPROTO_ARP);
+	t = xt_find_table_lock(net, NFPROTO_ARP, get.name);
 	if (t && !IS_ERR(t)) {
 		const struct xt_table_info *private = t->private;
 		struct xt_table_info info;
@@ -1623,13 +1625,13 @@ static int compat_get_entries(struct net *net,
 				 private->size, get.size);
 			ret = -EAGAIN;
 		}
-		xt_compat_flush_offsets(NF_ARP);
+		xt_compat_flush_offsets(NFPROTO_ARP);
 		module_put(t->me);
 		xt_table_unlock(t);
 	} else
 		ret = t ? PTR_ERR(t) : -ENOENT;
 
-	xt_compat_unlock(NF_ARP);
+	xt_compat_unlock(NFPROTO_ARP);
 	return ret;
 }
 
@@ -1709,7 +1711,7 @@ static int do_arpt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len
 			break;
 		}
 
-		try_then_request_module(xt_find_revision(NF_ARP, rev.name,
+		try_then_request_module(xt_find_revision(NFPROTO_ARP, rev.name,
 							 rev.revision, 1, &ret),
 					"arpt_%s", rev.name);
 		break;
@@ -1787,7 +1789,7 @@ void arpt_unregister_table(struct xt_table *table)
 static struct xt_target arpt_standard_target __read_mostly = {
 	.name		= ARPT_STANDARD_TARGET,
 	.targetsize	= sizeof(int),
-	.family		= NF_ARP,
+	.family		= NFPROTO_ARP,
 #ifdef CONFIG_COMPAT
 	.compatsize	= sizeof(compat_int_t),
 	.compat_from_user = compat_standard_from_user,
@@ -1799,7 +1801,7 @@ static struct xt_target arpt_error_target __read_mostly = {
 	.name		= ARPT_ERROR_TARGET,
 	.target		= arpt_error,
 	.targetsize	= ARPT_FUNCTION_MAXNAMELEN,
-	.family		= NF_ARP,
+	.family		= NFPROTO_ARP,
 };
 
 static struct nf_sockopt_ops arpt_sockopts = {
@@ -1821,12 +1823,12 @@ static struct nf_sockopt_ops arpt_sockopts = {
 
 static int __net_init arp_tables_net_init(struct net *net)
 {
-	return xt_proto_init(net, NF_ARP);
+	return xt_proto_init(net, NFPROTO_ARP);
 }
 
 static void __net_exit arp_tables_net_exit(struct net *net)
 {
-	xt_proto_fini(net, NF_ARP);
+	xt_proto_fini(net, NFPROTO_ARP);
 }
 
 static struct pernet_operations arp_tables_net_ops = {
diff --git a/net/ipv4/netfilter/arpt_mangle.c b/net/ipv4/netfilter/arpt_mangle.c
index a385959..3f9e4cc 100644
--- a/net/ipv4/netfilter/arpt_mangle.c
+++ b/net/ipv4/netfilter/arpt_mangle.c
@@ -75,7 +75,7 @@ checkentry(const char *tablename, const void *e, const struct xt_target *target,
 
 static struct xt_target arpt_mangle_reg __read_mostly = {
 	.name		= "mangle",
-	.family		= NF_ARP,
+	.family		= NFPROTO_ARP,
 	.target		= target,
 	.targetsize	= sizeof(struct arpt_mangle),
 	.checkentry	= checkentry,
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 3be4d07..bbf7535 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -51,7 +51,7 @@ static struct xt_table packet_filter = {
 	.lock		= __RW_LOCK_UNLOCKED(packet_filter.lock),
 	.private	= NULL,
 	.me		= THIS_MODULE,
-	.af		= NF_ARP,
+	.af		= NFPROTO_ARP,
 };
 
 /* The work comes in here from netfilter.c */
@@ -68,21 +68,21 @@ static struct nf_hook_ops arpt_ops[] __read_mostly = {
 	{
 		.hook		= arpt_hook,
 		.owner		= THIS_MODULE,
-		.pf		= NF_ARP,
+		.pf		= NFPROTO_ARP,
 		.hooknum	= NF_ARP_IN,
 		.priority	= NF_IP_PRI_FILTER,
 	},
 	{
 		.hook		= arpt_hook,
 		.owner		= THIS_MODULE,
-		.pf		= NF_ARP,
+		.pf		= NFPROTO_ARP,
 		.hooknum	= NF_ARP_OUT,
 		.priority	= NF_IP_PRI_FILTER,
 	},
 	{
 		.hook		= arpt_hook,
 		.owner		= THIS_MODULE,
-		.pf		= NF_ARP,
+		.pf		= NFPROTO_ARP,
 		.hooknum	= NF_ARP_FORWARD,
 		.priority	= NF_IP_PRI_FILTER,
 	},
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index c1f970c..a889269 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -545,7 +545,7 @@ arp_mangle(unsigned int hook,
 
 static struct nf_hook_ops cip_arp_ops __read_mostly = {
 	.hook = arp_mangle,
-	.pf = NF_ARP,
+	.pf = NFPROTO_ARP,
 	.hooknum = NF_ARP_OUT,
 	.priority = -1
 };
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 354c85a..914cbeb 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -26,7 +26,7 @@
 
 static DEFINE_MUTEX(afinfo_mutex);
 
-const struct nf_afinfo *nf_afinfo[NPROTO] __read_mostly;
+const struct nf_afinfo *nf_afinfo[__NFPROTO_MAX] __read_mostly;
 EXPORT_SYMBOL(nf_afinfo);
 
 int nf_register_afinfo(const struct nf_afinfo *afinfo)
@@ -51,7 +51,7 @@ void nf_unregister_afinfo(const struct nf_afinfo *afinfo)
 }
 EXPORT_SYMBOL_GPL(nf_unregister_afinfo);
 
-struct list_head nf_hooks[NPROTO][NF_MAX_HOOKS] __read_mostly;
+struct list_head nf_hooks[__NFPROTO_MAX][NF_MAX_HOOKS] __read_mostly;
 EXPORT_SYMBOL(nf_hooks);
 static DEFINE_MUTEX(nf_hook_mutex);
 
@@ -264,7 +264,7 @@ EXPORT_SYMBOL(proc_net_netfilter);
 void __init netfilter_init(void)
 {
 	int i, h;
-	for (i = 0; i < NPROTO; i++) {
+	for (i = 0; i < __NFPROTO_MAX; i++) {
 		for (h = 0; h < NF_MAX_HOOKS; h++)
 			INIT_LIST_HEAD(&nf_hooks[i][h]);
 	}
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index c3fcd65..a654831 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -15,7 +15,7 @@
 
 #define NF_LOG_PREFIXLEN		128
 
-static const struct nf_logger *nf_loggers[NPROTO] __read_mostly;
+static const struct nf_logger *nf_loggers[__NFPROTO_MAX] __read_mostly;
 static DEFINE_MUTEX(nf_log_mutex);
 
 /* return EBUSY if somebody else is registered, EEXIST if the same logger
@@ -24,7 +24,7 @@ int nf_log_register(u_int16_t pf, const struct nf_logger *logger)
 {
 	int ret;
 
-	if (pf >= NPROTO)
+	if (pf >= __NFPROTO_MAX)
 		return -EINVAL;
 
 	/* Any setup of logging members must be done before
@@ -47,7 +47,7 @@ EXPORT_SYMBOL(nf_log_register);
 
 void nf_log_unregister_pf(u_int16_t pf)
 {
-	if (pf >= NPROTO)
+	if (pf >= __NFPROTO_MAX)
 		return;
 	mutex_lock(&nf_log_mutex);
 	rcu_assign_pointer(nf_loggers[pf], NULL);
@@ -63,7 +63,7 @@ void nf_log_unregister(const struct nf_logger *logger)
 	int i;
 
 	mutex_lock(&nf_log_mutex);
-	for (i = 0; i < NPROTO; i++) {
+	for (i = 0; i < __NFPROTO_MAX; i++) {
 		if (nf_loggers[i] == logger)
 			rcu_assign_pointer(nf_loggers[i], NULL);
 	}
@@ -107,7 +107,7 @@ static void *seq_start(struct seq_file *seq, loff_t *pos)
 {
 	rcu_read_lock();
 
-	if (*pos >= NPROTO)
+	if (*pos >= __NFPROTO_MAX)
 		return NULL;
 
 	return pos;
@@ -117,7 +117,7 @@ static void *seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
 	(*pos)++;
 
-	if (*pos >= NPROTO)
+	if (*pos >= __NFPROTO_MAX)
 		return NULL;
 
 	return pos;
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index da95283..425f606 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -16,7 +16,7 @@
  * long term mutex.  The handler must provide an an outfn() to accept packets
  * for queueing and must reinject all packets it receives, no matter what.
  */
-static const struct nf_queue_handler *queue_handler[NPROTO];
+static const struct nf_queue_handler *queue_handler[__NFPROTO_MAX];
 
 static DEFINE_MUTEX(queue_handler_mutex);
 
@@ -26,7 +26,7 @@ int nf_register_queue_handler(u_int16_t pf, const struct nf_queue_handler *qh)
 {
 	int ret;
 
-	if (pf >= NPROTO)
+	if (pf >= __NFPROTO_MAX)
 		return -EINVAL;
 
 	mutex_lock(&queue_handler_mutex);
@@ -47,7 +47,7 @@ EXPORT_SYMBOL(nf_register_queue_handler);
 /* The caller must flush their queue before this */
 int nf_unregister_queue_handler(u_int16_t pf, const struct nf_queue_handler *qh)
 {
-	if (pf >= NPROTO)
+	if (pf >= __NFPROTO_MAX)
 		return -EINVAL;
 
 	mutex_lock(&queue_handler_mutex);
@@ -70,7 +70,7 @@ void nf_unregister_queue_handlers(const struct nf_queue_handler *qh)
 	u_int16_t pf;
 
 	mutex_lock(&queue_handler_mutex);
-	for (pf = 0; pf < NPROTO; pf++)  {
+	for (pf = 0; pf < __NFPROTO_MAX; pf++)  {
 		if (queue_handler[pf] == qh)
 			rcu_assign_pointer(queue_handler[pf], NULL);
 	}
@@ -285,7 +285,7 @@ EXPORT_SYMBOL(nf_reinject);
 #ifdef CONFIG_PROC_FS
 static void *seq_start(struct seq_file *seq, loff_t *pos)
 {
-	if (*pos >= NPROTO)
+	if (*pos >= __NFPROTO_MAX)
 		return NULL;
 
 	return pos;
@@ -295,7 +295,7 @@ static void *seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
 	(*pos)++;
 
-	if (*pos >= NPROTO)
+	if (*pos >= __NFPROTO_MAX)
 		return NULL;
 
 	return pos;
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index d461c17..51c1c03 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -58,10 +58,10 @@ static struct xt_af *xt;
 #define duprintf(format, args...)
 #endif
 
-static const char *const xt_prefix[NPROTO] = {
+static const char *const xt_prefix[__NFPROTO_MAX] = {
 	[AF_INET]	= "ip",
 	[AF_INET6]	= "ip6",
-	[NF_ARP]	= "arp",
+	[NFPROTO_ARP]	= "arp",
 };
 
 /* Registration hooks for targets. */
@@ -933,7 +933,7 @@ int xt_proto_init(struct net *net, u_int16_t af)
 	struct proc_dir_entry *proc;
 #endif
 
-	if (af >= NPROTO)
+	if (af >= __NFPROTO_MAX)
 		return -EINVAL;
 
 
@@ -1003,7 +1003,7 @@ static int __net_init xt_net_init(struct net *net)
 {
 	int i;
 
-	for (i = 0; i < NPROTO; i++)
+	for (i = 0; i < __NFPROTO_MAX; i++)
 		INIT_LIST_HEAD(&net->xt.tables[i]);
 	return 0;
 }
@@ -1016,11 +1016,11 @@ static int __init xt_init(void)
 {
 	int i, rv;
 
-	xt = kmalloc(sizeof(struct xt_af) * NPROTO, GFP_KERNEL);
+	xt = kmalloc(sizeof(struct xt_af) * __NFPROTO_MAX, GFP_KERNEL);
 	if (!xt)
 		return -ENOMEM;
 
-	for (i = 0; i < NPROTO; i++) {
+	for (i = 0; i < __NFPROTO_MAX; i++) {
 		mutex_init(&xt[i].mutex);
 #ifdef CONFIG_COMPAT
 		mutex_init(&xt[i].compat_mutex);
diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index beb24d1..fb3d639 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -50,7 +50,7 @@ static struct xt_target nfqueue_tg_reg[] __read_mostly = {
 	},
 	{
 		.name		= "NFQUEUE",
-		.family		= NF_ARP,
+		.family		= NFPROTO_ARP,
 		.target		= nfqueue_tg,
 		.targetsize	= sizeof(struct xt_NFQ_info),
 		.me		= THIS_MODULE,
-- 
1.5.5.rc3

