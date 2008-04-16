From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 07/13] [NETFILTER]: Use NFPROTO_* in extensions
Date: Wed, 16 Apr 2008 17:30:59 +0200
Message-ID: <b659184f68c8150b6a035a9de8694fe22e79b8c6.1208359825.git.jengelh@computergmbh.de>
References: <1208359865-3022-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38086 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760945AbYDPPbJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Apr 2008 11:31:09 -0400
In-Reply-To: <1208359865-3022-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <540dfb29c6c573830cbde9bf579ddef33657ed20.1208359825.git.jengelh@computergmbh.de>
References: <540dfb29c6c573830cbde9bf579ddef33657ed20.1208359825.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 net/bridge/netfilter/ebt_log.c       |    6 +-
 net/bridge/netfilter/ebt_ulog.c      |    2 +-
 net/ipv4/netfilter/arp_tables.c      |   58 +++++++++++++------------
 net/ipv4/netfilter/arpt_mangle.c     |    2 +-
 net/ipv4/netfilter/arptable_filter.c |    8 ++--
 net/ipv4/netfilter/ipt_CLUSTERIP.c   |    4 +-
 net/ipv4/netfilter/ipt_ECN.c         |    2 +-
 net/ipv4/netfilter/ipt_LOG.c         |    6 +-
 net/ipv4/netfilter/ipt_MASQUERADE.c  |    2 +-
 net/ipv4/netfilter/ipt_NETMAP.c      |    2 +-
 net/ipv4/netfilter/ipt_REDIRECT.c    |    2 +-
 net/ipv4/netfilter/ipt_REJECT.c      |    2 +-
 net/ipv4/netfilter/ipt_TTL.c         |    2 +-
 net/ipv4/netfilter/ipt_ULOG.c        |    4 +-
 net/ipv4/netfilter/ipt_addrtype.c    |    4 +-
 net/ipv4/netfilter/ipt_ah.c          |    2 +-
 net/ipv4/netfilter/ipt_ecn.c         |    2 +-
 net/ipv4/netfilter/ipt_ttl.c         |    2 +-
 net/ipv6/netfilter/ip6t_HL.c         |    2 +-
 net/ipv6/netfilter/ip6t_LOG.c        |    7 ++-
 net/ipv6/netfilter/ip6t_REJECT.c     |    2 +-
 net/ipv6/netfilter/ip6t_ah.c         |    2 +-
 net/ipv6/netfilter/ip6t_eui64.c      |    2 +-
 net/ipv6/netfilter/ip6t_frag.c       |    2 +-
 net/ipv6/netfilter/ip6t_hbh.c        |    4 +-
 net/ipv6/netfilter/ip6t_hl.c         |    2 +-
 net/ipv6/netfilter/ip6t_ipv6header.c |    2 +-
 net/ipv6/netfilter/ip6t_mh.c         |    2 +-
 net/ipv6/netfilter/ip6t_rt.c         |    2 +-
 net/netfilter/xt_CLASSIFY.c          |    4 +-
 net/netfilter/xt_CONNMARK.c          |    8 ++--
 net/netfilter/xt_CONNSECMARK.c       |    4 +-
 net/netfilter/xt_DSCP.c              |   10 ++--
 net/netfilter/xt_MARK.c              |   12 +++---
 net/netfilter/xt_NFLOG.c             |    4 +-
 net/netfilter/xt_NFQUEUE.c           |    4 +-
 net/netfilter/xt_NOTRACK.c           |    4 +-
 net/netfilter/xt_RATEEST.c           |    4 +-
 net/netfilter/xt_SECMARK.c           |    4 +-
 net/netfilter/xt_TCPMSS.c            |    4 +-
 net/netfilter/xt_TCPOPTSTRIP.c       |    4 +-
 net/netfilter/xt_TRACE.c             |    4 +-
 net/netfilter/xt_comment.c           |    4 +-
 net/netfilter/xt_connbytes.c         |    4 +-
 net/netfilter/xt_connlimit.c         |   10 ++--
 net/netfilter/xt_connmark.c          |    8 ++--
 net/netfilter/xt_conntrack.c         |   10 ++--
 net/netfilter/xt_dccp.c              |    4 +-
 net/netfilter/xt_dscp.c              |   12 +++---
 net/netfilter/xt_esp.c               |    4 +-
 net/netfilter/xt_hashlimit.c         |   26 ++++++------
 net/netfilter/xt_helper.c            |    4 +-
 net/netfilter/xt_iprange.c           |    6 +-
 net/netfilter/xt_length.c            |    8 ++--
 net/netfilter/xt_limit.c             |    4 +-
 net/netfilter/xt_mac.c               |    4 +-
 net/netfilter/xt_mark.c              |    8 ++--
 net/netfilter/xt_multiport.c         |    8 ++--
 net/netfilter/xt_owner.c             |    8 ++--
 net/netfilter/xt_physdev.c           |    4 +-
 net/netfilter/xt_pkttype.c           |    8 ++--
 net/netfilter/xt_policy.c            |    8 ++--
 net/netfilter/xt_quota.c             |    4 +-
 net/netfilter/xt_rateest.c           |    4 +-
 net/netfilter/xt_realm.c             |    2 +-
 net/netfilter/xt_recent.c            |   21 +++++----
 net/netfilter/xt_sctp.c              |    4 +-
 net/netfilter/xt_state.c             |    4 +-
 net/netfilter/xt_statistic.c         |    4 +-
 net/netfilter/xt_string.c            |    4 +-
 net/netfilter/xt_tcpmss.c            |    4 +-
 net/netfilter/xt_tcpudp.c            |   12 +++---
 net/netfilter/xt_time.c              |    4 +-
 net/netfilter/xt_u32.c               |    4 +-
 74 files changed, 219 insertions(+), 215 deletions(-)

diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index 9e9bcd2..bc19d65 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -172,10 +172,10 @@ static void ebt_log(const struct sk_buff *skb, unsigned int hooknr,
 	li.u.log.logflags = info->bitmask;
 
 	if (info->bitmask & EBT_LOG_NFLOG)
-		nf_log_packet(PF_BRIDGE, hooknr, skb, in, out, &li,
+		nf_log_packet(NFPROTO_BRIDGE, hooknr, skb, in, out, &li,
 			      "%s", info->prefix);
 	else
-		ebt_log_packet(PF_BRIDGE, hooknr, skb, in, out, &li,
+		ebt_log_packet(NFPROTO_BRIDGE, hooknr, skb, in, out, &li,
 			       info->prefix);
 }
 
@@ -200,7 +200,7 @@ static int __init ebt_log_init(void)
 	ret = ebt_register_watcher(&log);
 	if (ret < 0)
 		return ret;
-	nf_log_register(PF_BRIDGE, &ebt_log_logger);
+	nf_log_register(NFPROTO_BRIDGE, &ebt_log_logger);
 	return 0;
 }
 
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index c84bda6..3b1678c 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -310,7 +310,7 @@ static int __init ebt_ulog_init(void)
 		netlink_kernel_release(ebtulognl);
 
 	if (ret == 0)
-		nf_log_register(PF_BRIDGE, &ebt_ulog_logger);
+		nf_log_register(NFPROTO_BRIDGE, &ebt_ulog_logger);
 
 	return ret;
 }
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 03e83a6..b4a9a17 100644
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
index 22d8e7c..8b32d90 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -445,7 +445,7 @@ struct compat_ipt_clusterip_tgt_info
 
 static struct xt_target clusterip_tg_reg __read_mostly = {
 	.name		= "CLUSTERIP",
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.target		= clusterip_tg,
 	.checkentry	= clusterip_tg_check,
 	.destroy	= clusterip_tg_destroy,
@@ -547,7 +547,7 @@ arp_mangle(unsigned int hook,
 
 static struct nf_hook_ops cip_arp_ops __read_mostly = {
 	.hook = arp_mangle,
-	.pf = NF_ARP,
+	.pf = NFPROTO_ARP,
 	.hooknum = NF_ARP_OUT,
 	.priority = -1
 };
diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
index d60139c..aee2364 100644
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -124,7 +124,7 @@ ecn_tg_check(const char *tablename, const void *e_void,
 
 static struct xt_target ecn_tg_reg __read_mostly = {
 	.name		= "ECN",
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.target		= ecn_tg,
 	.targetsize	= sizeof(struct ipt_ECN_info),
 	.table		= "mangle",
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index 9330ba3..1c9785d 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -437,7 +437,7 @@ log_tg(struct sk_buff *skb, const struct net_device *in,
 	li.u.log.level = loginfo->level;
 	li.u.log.logflags = loginfo->logflags;
 
-	ipt_log_packet(PF_INET, hooknum, skb, in, out, &li,
+	ipt_log_packet(NFPROTO_IPV4, hooknum, skb, in, out, &li,
 		       loginfo->prefix);
 	return XT_CONTINUE;
 }
@@ -463,7 +463,7 @@ log_tg_check(const char *tablename, const void *e,
 
 static struct xt_target log_tg_reg __read_mostly = {
 	.name		= "LOG",
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.target		= log_tg,
 	.targetsize	= sizeof(struct ipt_log_info),
 	.checkentry	= log_tg_check,
@@ -483,7 +483,7 @@ static int __init log_tg_init(void)
 	ret = xt_register_target(&log_tg_reg);
 	if (ret < 0)
 		return ret;
-	nf_log_register(PF_INET, &ipt_log_logger);
+	nf_log_register(NFPROTO_IPV4, &ipt_log_logger);
 	return 0;
 }
 
diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
index 84c26dd..2bed01c 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -153,7 +153,7 @@ static struct notifier_block masq_inet_notifier = {
 
 static struct xt_target masquerade_tg_reg __read_mostly = {
 	.name		= "MASQUERADE",
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.target		= masquerade_tg,
 	.targetsize	= sizeof(struct nf_nat_multi_range_compat),
 	.table		= "nat",
diff --git a/net/ipv4/netfilter/ipt_NETMAP.c b/net/ipv4/netfilter/ipt_NETMAP.c
index 6739abf..f281500 100644
--- a/net/ipv4/netfilter/ipt_NETMAP.c
+++ b/net/ipv4/netfilter/ipt_NETMAP.c
@@ -75,7 +75,7 @@ netmap_tg(struct sk_buff *skb, const struct net_device *in,
 
 static struct xt_target netmap_tg_reg __read_mostly = {
 	.name 		= "NETMAP",
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.target 	= netmap_tg,
 	.targetsize	= sizeof(struct nf_nat_multi_range_compat),
 	.table		= "nat",
diff --git a/net/ipv4/netfilter/ipt_REDIRECT.c b/net/ipv4/netfilter/ipt_REDIRECT.c
index 5c62924..ef49610 100644
--- a/net/ipv4/netfilter/ipt_REDIRECT.c
+++ b/net/ipv4/netfilter/ipt_REDIRECT.c
@@ -92,7 +92,7 @@ redirect_tg(struct sk_buff *skb, const struct net_device *in,
 
 static struct xt_target redirect_tg_reg __read_mostly = {
 	.name		= "REDIRECT",
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.target		= redirect_tg,
 	.targetsize	= sizeof(struct nf_nat_multi_range_compat),
 	.table		= "nat",
diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index 2639872..9f5da0c 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -201,7 +201,7 @@ reject_tg_check(const char *tablename, const void *e_void,
 
 static struct xt_target reject_tg_reg __read_mostly = {
 	.name		= "REJECT",
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.target		= reject_tg,
 	.targetsize	= sizeof(struct ipt_reject_info),
 	.table		= "filter",
diff --git a/net/ipv4/netfilter/ipt_TTL.c b/net/ipv4/netfilter/ipt_TTL.c
index 30eed65..7d01d42 100644
--- a/net/ipv4/netfilter/ipt_TTL.c
+++ b/net/ipv4/netfilter/ipt_TTL.c
@@ -80,7 +80,7 @@ ttl_tg_check(const char *tablename, const void *e,
 
 static struct xt_target ttl_tg_reg __read_mostly = {
 	.name 		= "TTL",
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.target 	= ttl_tg,
 	.targetsize	= sizeof(struct ipt_TTL_info),
 	.table		= "mangle",
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index d8241e6..9065e4a 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -374,7 +374,7 @@ static int ulog_tg_compat_to_user(void __user *dst, void *src)
 
 static struct xt_target ulog_tg_reg __read_mostly = {
 	.name		= "ULOG",
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.target		= ulog_tg,
 	.targetsize	= sizeof(struct ipt_ulog_info),
 	.checkentry	= ulog_tg_check,
@@ -419,7 +419,7 @@ static int __init ulog_tg_init(void)
 		return ret;
 	}
 	if (nflog)
-		nf_log_register(PF_INET, &ipt_ulog_logger);
+		nf_log_register(NFPROTO_IPV4, &ipt_ulog_logger);
 
 	return 0;
 }
diff --git a/net/ipv4/netfilter/ipt_addrtype.c b/net/ipv4/netfilter/ipt_addrtype.c
index 49587a4..608313c 100644
--- a/net/ipv4/netfilter/ipt_addrtype.c
+++ b/net/ipv4/netfilter/ipt_addrtype.c
@@ -108,14 +108,14 @@ addrtype_mt_checkentry_v1(const char *tablename, const void *ip_void,
 static struct xt_match addrtype_mt_reg[] __read_mostly = {
 	{
 		.name		= "addrtype",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.match		= addrtype_mt_v0,
 		.matchsize	= sizeof(struct ipt_addrtype_info),
 		.me		= THIS_MODULE
 	},
 	{
 		.name		= "addrtype",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.revision	= 1,
 		.match		= addrtype_mt_v1,
 		.checkentry	= addrtype_mt_checkentry_v1,
diff --git a/net/ipv4/netfilter/ipt_ah.c b/net/ipv4/netfilter/ipt_ah.c
index e977989..e2e993e 100644
--- a/net/ipv4/netfilter/ipt_ah.c
+++ b/net/ipv4/netfilter/ipt_ah.c
@@ -83,7 +83,7 @@ ah_mt_check(const char *tablename, const void *ip_void,
 
 static struct xt_match ah_mt_reg __read_mostly = {
 	.name		= "ah",
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.match		= ah_mt,
 	.matchsize	= sizeof(struct ipt_ah),
 	.proto		= IPPROTO_AH,
diff --git a/net/ipv4/netfilter/ipt_ecn.c b/net/ipv4/netfilter/ipt_ecn.c
index 749de82..2c45b4b 100644
--- a/net/ipv4/netfilter/ipt_ecn.c
+++ b/net/ipv4/netfilter/ipt_ecn.c
@@ -114,7 +114,7 @@ ecn_mt_check(const char *tablename, const void *ip_void,
 
 static struct xt_match ecn_mt_reg __read_mostly = {
 	.name		= "ecn",
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.match		= ecn_mt,
 	.matchsize	= sizeof(struct ipt_ecn_info),
 	.checkentry	= ecn_mt_check,
diff --git a/net/ipv4/netfilter/ipt_ttl.c b/net/ipv4/netfilter/ipt_ttl.c
index e0b8cae..d4c3fdc 100644
--- a/net/ipv4/netfilter/ipt_ttl.c
+++ b/net/ipv4/netfilter/ipt_ttl.c
@@ -46,7 +46,7 @@ ttl_mt(const struct sk_buff *skb, const struct net_device *in,
 
 static struct xt_match ttl_mt_reg __read_mostly = {
 	.name		= "ttl",
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.match		= ttl_mt,
 	.matchsize	= sizeof(struct ipt_ttl_info),
 	.me		= THIS_MODULE,
diff --git a/net/ipv6/netfilter/ip6t_HL.c b/net/ipv6/netfilter/ip6t_HL.c
index d5f8fd5..7eebd35 100644
--- a/net/ipv6/netfilter/ip6t_HL.c
+++ b/net/ipv6/netfilter/ip6t_HL.c
@@ -78,7 +78,7 @@ hl_tg6_check(const char *tablename, const void *entry,
 
 static struct xt_target hl_tg6_reg __read_mostly = {
 	.name 		= "HL",
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.target		= hl_tg6,
 	.targetsize	= sizeof(struct ip6t_HL_info),
 	.table		= "mangle",
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index 0716f8a..fd148f3 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -449,7 +449,8 @@ log_tg6(struct sk_buff *skb, const struct net_device *in,
 	li.u.log.level = loginfo->level;
 	li.u.log.logflags = loginfo->logflags;
 
-	ip6t_log_packet(PF_INET6, hooknum, skb, in, out, &li, loginfo->prefix);
+	ip6t_log_packet(NFPROTO_IPV6, hooknum, skb, in, out,
+			&li, loginfo->prefix);
 	return XT_CONTINUE;
 }
 
@@ -475,7 +476,7 @@ log_tg6_check(const char *tablename, const void *entry,
 
 static struct xt_target log_tg6_reg __read_mostly = {
 	.name 		= "LOG",
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.target 	= log_tg6,
 	.targetsize	= sizeof(struct ip6t_log_info),
 	.checkentry	= log_tg6_check,
@@ -495,7 +496,7 @@ static int __init log_tg6_init(void)
 	ret = xt_register_target(&log_tg6_reg);
 	if (ret < 0)
 		return ret;
-	nf_log_register(PF_INET6, &ip6t_logger);
+	nf_log_register(NFPROTO_IPV6, &ip6t_logger);
 	return 0;
 }
 
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index 44c8d65..672ad9f 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -237,7 +237,7 @@ reject_tg6_check(const char *tablename, const void *entry,
 
 static struct xt_target reject_tg6_reg __read_mostly = {
 	.name		= "REJECT",
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.target		= reject_tg6,
 	.targetsize	= sizeof(struct ip6t_reject_info),
 	.table		= "filter",
diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
index 429629f..061f89b 100644
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -110,7 +110,7 @@ ah_mt6_check(const char *tablename, const void *entry,
 
 static struct xt_match ah_mt6_reg __read_mostly = {
 	.name		= "ah",
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.match		= ah_mt6,
 	.matchsize	= sizeof(struct ip6t_ah),
 	.checkentry	= ah_mt6_check,
diff --git a/net/ipv6/netfilter/ip6t_eui64.c b/net/ipv6/netfilter/ip6t_eui64.c
index 8f331f1..ba38df1 100644
--- a/net/ipv6/netfilter/ip6t_eui64.c
+++ b/net/ipv6/netfilter/ip6t_eui64.c
@@ -60,7 +60,7 @@ eui64_mt6(const struct sk_buff *skb, const struct net_device *in,
 
 static struct xt_match eui64_mt6_reg __read_mostly = {
 	.name		= "eui64",
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.match		= eui64_mt6,
 	.matchsize	= sizeof(int),
 	.hooks		= (1 << NF_INET_PRE_ROUTING) | (1 << NF_INET_LOCAL_IN) |
diff --git a/net/ipv6/netfilter/ip6t_frag.c b/net/ipv6/netfilter/ip6t_frag.c
index e2bbc63..972f699 100644
--- a/net/ipv6/netfilter/ip6t_frag.c
+++ b/net/ipv6/netfilter/ip6t_frag.c
@@ -127,7 +127,7 @@ frag_mt6_check(const char *tablename, const void *ip,
 
 static struct xt_match frag_mt6_reg __read_mostly = {
 	.name		= "frag",
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.match		= frag_mt6,
 	.matchsize	= sizeof(struct ip6t_frag),
 	.checkentry	= frag_mt6_check,
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index 62e39ac..85ff370 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -183,7 +183,7 @@ hbh_mt6_check(const char *tablename, const void *entry,
 static struct xt_match hbh_mt6_reg[] __read_mostly = {
 	{
 		.name		= "hbh",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.match		= hbh_mt6,
 		.matchsize	= sizeof(struct ip6t_opts),
 		.checkentry	= hbh_mt6_check,
@@ -192,7 +192,7 @@ static struct xt_match hbh_mt6_reg[] __read_mostly = {
 	},
 	{
 		.name		= "dst",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.match		= hbh_mt6,
 		.matchsize	= sizeof(struct ip6t_opts),
 		.checkentry	= hbh_mt6_check,
diff --git a/net/ipv6/netfilter/ip6t_hl.c b/net/ipv6/netfilter/ip6t_hl.c
index 3456716..25c1eb9 100644
--- a/net/ipv6/netfilter/ip6t_hl.c
+++ b/net/ipv6/netfilter/ip6t_hl.c
@@ -51,7 +51,7 @@ hl_mt6(const struct sk_buff *skb, const struct net_device *in,
 
 static struct xt_match hl_mt6_reg __read_mostly = {
 	.name		= "hl",
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.match		= hl_mt6,
 	.matchsize	= sizeof(struct ip6t_hl_info),
 	.me		= THIS_MODULE,
diff --git a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t_ipv6header.c
index 317a896..ef0661a 100644
--- a/net/ipv6/netfilter/ip6t_ipv6header.c
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -138,7 +138,7 @@ ipv6header_mt6_check(const char *tablename, const void *ip,
 
 static struct xt_match ipv6header_mt6_reg __read_mostly = {
 	.name		= "ipv6header",
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.match		= ipv6header_mt6,
 	.matchsize	= sizeof(struct ip6t_ipv6header_info),
 	.checkentry	= ipv6header_mt6_check,
diff --git a/net/ipv6/netfilter/ip6t_mh.c b/net/ipv6/netfilter/ip6t_mh.c
index e06678d..dd87627 100644
--- a/net/ipv6/netfilter/ip6t_mh.c
+++ b/net/ipv6/netfilter/ip6t_mh.c
@@ -84,7 +84,7 @@ mh_mt6_check(const char *tablename, const void *entry,
 
 static struct xt_match mh_mt6_reg __read_mostly = {
 	.name		= "mh",
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.checkentry	= mh_mt6_check,
 	.match		= mh_mt6,
 	.matchsize	= sizeof(struct ip6t_mh),
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index 81aaf7a..7c544ae 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -214,7 +214,7 @@ rt_mt6_check(const char *tablename, const void *entry,
 
 static struct xt_match rt_mt6_reg __read_mostly = {
 	.name		= "rt",
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.match		= rt_mt6,
 	.matchsize	= sizeof(struct ip6t_rt),
 	.checkentry	= rt_mt6_check,
diff --git a/net/netfilter/xt_CLASSIFY.c b/net/netfilter/xt_CLASSIFY.c
index 77a52bf..9d68da1 100644
--- a/net/netfilter/xt_CLASSIFY.c
+++ b/net/netfilter/xt_CLASSIFY.c
@@ -39,7 +39,7 @@ classify_tg(struct sk_buff *skb, const struct net_device *in,
 
 static struct xt_target classify_tg_reg[] __read_mostly = {
 	{
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.name 		= "CLASSIFY",
 		.target 	= classify_tg,
 		.targetsize	= sizeof(struct xt_classify_target_info),
@@ -51,7 +51,7 @@ static struct xt_target classify_tg_reg[] __read_mostly = {
 	},
 	{
 		.name 		= "CLASSIFY",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.target 	= classify_tg,
 		.targetsize	= sizeof(struct xt_classify_target_info),
 		.table		= "mangle",
diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index 5fecfb4..e72e5d0 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -197,7 +197,7 @@ static struct xt_target connmark_tg_reg[] __read_mostly = {
 	{
 		.name		= "CONNMARK",
 		.revision	= 0,
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.checkentry	= connmark_tg_check_v0,
 		.destroy	= connmark_tg_destroy,
 		.target		= connmark_tg_v0,
@@ -212,7 +212,7 @@ static struct xt_target connmark_tg_reg[] __read_mostly = {
 	{
 		.name		= "CONNMARK",
 		.revision	= 0,
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.checkentry	= connmark_tg_check_v0,
 		.destroy	= connmark_tg_destroy,
 		.target		= connmark_tg_v0,
@@ -227,7 +227,7 @@ static struct xt_target connmark_tg_reg[] __read_mostly = {
 	{
 		.name           = "CONNMARK",
 		.revision       = 1,
-		.family         = AF_INET,
+		.family         = NFPROTO_IPV4,
 		.checkentry     = connmark_tg_check,
 		.target         = connmark_tg,
 		.targetsize     = sizeof(struct xt_connmark_tginfo1),
@@ -237,7 +237,7 @@ static struct xt_target connmark_tg_reg[] __read_mostly = {
 	{
 		.name           = "CONNMARK",
 		.revision       = 1,
-		.family         = AF_INET6,
+		.family         = NFPROTO_IPV6,
 		.checkentry     = connmark_tg_check,
 		.target         = connmark_tg,
 		.targetsize     = sizeof(struct xt_connmark_tginfo1),
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index 211189e..14fe83f 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -121,7 +121,7 @@ connsecmark_tg_destroy(const struct xt_target *target, void *targinfo)
 static struct xt_target connsecmark_tg_reg[] __read_mostly = {
 	{
 		.name		= "CONNSECMARK",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.checkentry	= connsecmark_tg_check,
 		.destroy	= connsecmark_tg_destroy,
 		.target		= connsecmark_tg,
@@ -131,7 +131,7 @@ static struct xt_target connsecmark_tg_reg[] __read_mostly = {
 	},
 	{
 		.name		= "CONNSECMARK",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.checkentry	= connsecmark_tg_check,
 		.destroy	= connsecmark_tg_destroy,
 		.target		= connsecmark_tg,
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index 97efd74..f0b4958 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -165,7 +165,7 @@ tos_tg6(struct sk_buff *skb, const struct net_device *in,
 static struct xt_target dscp_tg_reg[] __read_mostly = {
 	{
 		.name		= "DSCP",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.checkentry	= dscp_tg_check,
 		.target		= dscp_tg,
 		.targetsize	= sizeof(struct xt_DSCP_info),
@@ -174,7 +174,7 @@ static struct xt_target dscp_tg_reg[] __read_mostly = {
 	},
 	{
 		.name		= "DSCP",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.checkentry	= dscp_tg_check,
 		.target		= dscp_tg6,
 		.targetsize	= sizeof(struct xt_DSCP_info),
@@ -184,7 +184,7 @@ static struct xt_target dscp_tg_reg[] __read_mostly = {
 	{
 		.name		= "TOS",
 		.revision	= 0,
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.table		= "mangle",
 		.target		= tos_tg_v0,
 		.targetsize	= sizeof(struct ipt_tos_target_info),
@@ -194,7 +194,7 @@ static struct xt_target dscp_tg_reg[] __read_mostly = {
 	{
 		.name		= "TOS",
 		.revision	= 1,
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.table		= "mangle",
 		.target		= tos_tg,
 		.targetsize	= sizeof(struct xt_tos_target_info),
@@ -203,7 +203,7 @@ static struct xt_target dscp_tg_reg[] __read_mostly = {
 	{
 		.name		= "TOS",
 		.revision	= 1,
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.table		= "mangle",
 		.target		= tos_tg6,
 		.targetsize	= sizeof(struct xt_tos_target_info),
diff --git a/net/netfilter/xt_MARK.c b/net/netfilter/xt_MARK.c
index f9ce20b..55ef079 100644
--- a/net/netfilter/xt_MARK.c
+++ b/net/netfilter/xt_MARK.c
@@ -161,7 +161,7 @@ static int mark_tg_compat_to_user_v1(void __user *dst, void *src)
 static struct xt_target mark_tg_reg[] __read_mostly = {
 	{
 		.name		= "MARK",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.revision	= 0,
 		.checkentry	= mark_tg_check_v0,
 		.target		= mark_tg_v0,
@@ -176,7 +176,7 @@ static struct xt_target mark_tg_reg[] __read_mostly = {
 	},
 	{
 		.name		= "MARK",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.revision	= 1,
 		.checkentry	= mark_tg_check_v1,
 		.target		= mark_tg_v1,
@@ -191,7 +191,7 @@ static struct xt_target mark_tg_reg[] __read_mostly = {
 	},
 	{
 		.name		= "MARK",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.revision	= 0,
 		.checkentry	= mark_tg_check_v0,
 		.target		= mark_tg_v0,
@@ -206,7 +206,7 @@ static struct xt_target mark_tg_reg[] __read_mostly = {
 	},
 	{
 		.name		= "MARK",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.revision	= 1,
 		.checkentry	= mark_tg_check_v1,
 		.target		= mark_tg_v1,
@@ -222,7 +222,7 @@ static struct xt_target mark_tg_reg[] __read_mostly = {
 	{
 		.name           = "MARK",
 		.revision       = 2,
-		.family         = AF_INET,
+		.family         = NFPROTO_IPV4,
 		.target         = mark_tg,
 		.targetsize     = sizeof(struct xt_mark_tginfo2),
 		.me             = THIS_MODULE,
@@ -230,7 +230,7 @@ static struct xt_target mark_tg_reg[] __read_mostly = {
 	{
 		.name           = "MARK",
 		.revision       = 2,
-		.family         = AF_INET6,
+		.family         = NFPROTO_IPV6,
 		.target         = mark_tg,
 		.targetsize     = sizeof(struct xt_mark_tginfo2),
 		.me             = THIS_MODULE,
diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
index 19ae8ef..9b09552 100644
--- a/net/netfilter/xt_NFLOG.c
+++ b/net/netfilter/xt_NFLOG.c
@@ -55,7 +55,7 @@ nflog_tg_check(const char *tablename, const void *entry,
 static struct xt_target nflog_tg_reg[] __read_mostly = {
 	{
 		.name		= "NFLOG",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.checkentry	= nflog_tg_check,
 		.target		= nflog_tg,
 		.targetsize	= sizeof(struct xt_nflog_info),
@@ -63,7 +63,7 @@ static struct xt_target nflog_tg_reg[] __read_mostly = {
 	},
 	{
 		.name		= "NFLOG",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.checkentry	= nflog_tg_check,
 		.target		= nflog_tg,
 		.targetsize	= sizeof(struct xt_nflog_info),
diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index beb24d1..c03c2e8 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -36,14 +36,14 @@ nfqueue_tg(struct sk_buff *skb, const struct net_device *in,
 static struct xt_target nfqueue_tg_reg[] __read_mostly = {
 	{
 		.name		= "NFQUEUE",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.target		= nfqueue_tg,
 		.targetsize	= sizeof(struct xt_NFQ_info),
 		.me		= THIS_MODULE,
 	},
 	{
 		.name		= "NFQUEUE",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.target		= nfqueue_tg,
 		.targetsize	= sizeof(struct xt_NFQ_info),
 		.me		= THIS_MODULE,
diff --git a/net/netfilter/xt_NOTRACK.c b/net/netfilter/xt_NOTRACK.c
index 6c9de61..b9ee268 100644
--- a/net/netfilter/xt_NOTRACK.c
+++ b/net/netfilter/xt_NOTRACK.c
@@ -35,14 +35,14 @@ notrack_tg(struct sk_buff *skb, const struct net_device *in,
 static struct xt_target notrack_tg_reg[] __read_mostly = {
 	{
 		.name		= "NOTRACK",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.target		= notrack_tg,
 		.table		= "raw",
 		.me		= THIS_MODULE,
 	},
 	{
 		.name		= "NOTRACK",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.target		= notrack_tg,
 		.table		= "raw",
 		.me		= THIS_MODULE,
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index 64d6ad3..f7114fc 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -159,7 +159,7 @@ static void xt_rateest_tg_destroy(const struct xt_target *target,
 
 static struct xt_target xt_rateest_target[] __read_mostly = {
 	{
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.name		= "RATEEST",
 		.target		= xt_rateest_tg,
 		.checkentry	= xt_rateest_tg_checkentry,
@@ -168,7 +168,7 @@ static struct xt_target xt_rateest_target[] __read_mostly = {
 		.me		= THIS_MODULE,
 	},
 	{
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.name		= "RATEEST",
 		.target		= xt_rateest_tg,
 		.checkentry	= xt_rateest_tg_checkentry,
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index c028485..9995380 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -122,7 +122,7 @@ static void secmark_tg_destroy(const struct xt_target *target, void *targinfo)
 static struct xt_target secmark_tg_reg[] __read_mostly = {
 	{
 		.name		= "SECMARK",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.checkentry	= secmark_tg_check,
 		.destroy	= secmark_tg_destroy,
 		.target		= secmark_tg,
@@ -132,7 +132,7 @@ static struct xt_target secmark_tg_reg[] __read_mostly = {
 	},
 	{
 		.name		= "SECMARK",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.checkentry	= secmark_tg_check,
 		.destroy	= secmark_tg_destroy,
 		.target		= secmark_tg,
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index beede49..8770948 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -289,7 +289,7 @@ tcpmss_tg6_check(const char *tablename, const void *entry,
 
 static struct xt_target tcpmss_tg_reg[] __read_mostly = {
 	{
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.name		= "TCPMSS",
 		.checkentry	= tcpmss_tg4_check,
 		.target		= tcpmss_tg4,
@@ -299,7 +299,7 @@ static struct xt_target tcpmss_tg_reg[] __read_mostly = {
 	},
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
 	{
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.name		= "TCPMSS",
 		.checkentry	= tcpmss_tg6_check,
 		.target		= tcpmss_tg6,
diff --git a/net/netfilter/xt_TCPOPTSTRIP.c b/net/netfilter/xt_TCPOPTSTRIP.c
index 3b2aa56..a9eb1bb 100644
--- a/net/netfilter/xt_TCPOPTSTRIP.c
+++ b/net/netfilter/xt_TCPOPTSTRIP.c
@@ -106,7 +106,7 @@ tcpoptstrip_tg6(struct sk_buff *skb, const struct net_device *in,
 static struct xt_target tcpoptstrip_tg_reg[] __read_mostly = {
 	{
 		.name       = "TCPOPTSTRIP",
-		.family     = AF_INET,
+		.family     = NFPROTO_IPV4,
 		.table      = "mangle",
 		.proto      = IPPROTO_TCP,
 		.target     = tcpoptstrip_tg4,
@@ -116,7 +116,7 @@ static struct xt_target tcpoptstrip_tg_reg[] __read_mostly = {
 #if defined(CONFIG_IP6_NF_MANGLE) || defined(CONFIG_IP6_NF_MANGLE_MODULE)
 	{
 		.name       = "TCPOPTSTRIP",
-		.family     = AF_INET6,
+		.family     = NFPROTO_IPV6,
 		.table      = "mangle",
 		.proto      = IPPROTO_TCP,
 		.target     = tcpoptstrip_tg6,
diff --git a/net/netfilter/xt_TRACE.c b/net/netfilter/xt_TRACE.c
index 30dab79..e1bcad5 100644
--- a/net/netfilter/xt_TRACE.c
+++ b/net/netfilter/xt_TRACE.c
@@ -22,14 +22,14 @@ trace_tg(struct sk_buff *skb, const struct net_device *in,
 static struct xt_target trace_tg_reg[] __read_mostly = {
 	{
 		.name		= "TRACE",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.target		= trace_tg,
 		.table		= "raw",
 		.me		= THIS_MODULE,
 	},
 	{
 		.name		= "TRACE",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.target		= trace_tg,
 		.table		= "raw",
 		.me		= THIS_MODULE,
diff --git a/net/netfilter/xt_comment.c b/net/netfilter/xt_comment.c
index 89f4736..fa211b2 100644
--- a/net/netfilter/xt_comment.c
+++ b/net/netfilter/xt_comment.c
@@ -28,14 +28,14 @@ comment_mt(const struct sk_buff *skb, const struct net_device *in,
 static struct xt_match comment_mt_reg[] __read_mostly = {
 	{
 		.name		= "comment",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.match		= comment_mt,
 		.matchsize	= sizeof(struct xt_comment_info),
 		.me		= THIS_MODULE
 	},
 	{
 		.name		= "comment",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.match		= comment_mt,
 		.matchsize	= sizeof(struct xt_comment_info),
 		.me		= THIS_MODULE
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index b15e7e2..2e91fe0 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -127,7 +127,7 @@ connbytes_mt_destroy(const struct xt_match *match, void *matchinfo)
 static struct xt_match connbytes_mt_reg[] __read_mostly = {
 	{
 		.name		= "connbytes",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.checkentry	= connbytes_mt_check,
 		.match		= connbytes_mt,
 		.destroy	= connbytes_mt_destroy,
@@ -136,7 +136,7 @@ static struct xt_match connbytes_mt_reg[] __read_mostly = {
 	},
 	{
 		.name		= "connbytes",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.checkentry	= connbytes_mt_check,
 		.match		= connbytes_mt,
 		.destroy	= connbytes_mt_destroy,
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 340c2cb..827143c 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -83,7 +83,7 @@ same_source_net(const union nf_inet_addr *addr,
 		const union nf_inet_addr *mask,
 		const union nf_inet_addr *u3, u_int8_t family)
 {
-	if (family == AF_INET) {
+	if (family == NFPROTO_IPV4) {
 		return (addr->ip & mask->ip) == (u3->ip & mask->ip);
 	} else {
 		union nf_inet_addr lh, rh;
@@ -113,7 +113,7 @@ static int count_them(struct xt_connlimit_data *data,
 	int matches = 0;
 
 
-	if (match->family == AF_INET6)
+	if (match->family == NFPROTO_IPV6)
 		hash = &data->iphash[connlimit_iphash6(addr, mask)];
 	else
 		hash = &data->iphash[connlimit_iphash(addr->ip & mask->ip)];
@@ -197,7 +197,7 @@ connlimit_mt(const struct sk_buff *skb, const struct net_device *in,
 				    match->family, &tuple))
 		goto hotdrop;
 
-	if (match->family == AF_INET6) {
+	if (match->family == NFPROTO_IPV6) {
 		const struct ipv6hdr *iph = ipv6_hdr(skb);
 		memcpy(&addr.ip6, &iph->saddr, sizeof(iph->saddr));
 	} else {
@@ -275,7 +275,7 @@ connlimit_mt_destroy(const struct xt_match *match, void *matchinfo)
 static struct xt_match connlimit_mt_reg[] __read_mostly = {
 	{
 		.name       = "connlimit",
-		.family     = AF_INET,
+		.family     = NFPROTO_IPV4,
 		.checkentry = connlimit_mt_check,
 		.match      = connlimit_mt,
 		.matchsize  = sizeof(struct xt_connlimit_info),
@@ -284,7 +284,7 @@ static struct xt_match connlimit_mt_reg[] __read_mostly = {
 	},
 	{
 		.name       = "connlimit",
-		.family     = AF_INET6,
+		.family     = NFPROTO_IPV6,
 		.checkentry = connlimit_mt_check,
 		.match      = connlimit_mt,
 		.matchsize  = sizeof(struct xt_connlimit_info),
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index aaa1b96..0577b8f 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -140,7 +140,7 @@ static struct xt_match connmark_mt_reg[] __read_mostly = {
 	{
 		.name		= "connmark",
 		.revision	= 0,
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.checkentry	= connmark_mt_check_v0,
 		.match		= connmark_mt_v0,
 		.destroy	= connmark_mt_destroy,
@@ -155,7 +155,7 @@ static struct xt_match connmark_mt_reg[] __read_mostly = {
 	{
 		.name		= "connmark",
 		.revision	= 0,
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.checkentry	= connmark_mt_check_v0,
 		.match		= connmark_mt_v0,
 		.destroy	= connmark_mt_destroy,
@@ -170,7 +170,7 @@ static struct xt_match connmark_mt_reg[] __read_mostly = {
 	{
 		.name           = "connmark",
 		.revision       = 1,
-		.family         = AF_INET,
+		.family         = NFPROTO_IPV4,
 		.checkentry     = connmark_mt_check,
 		.match          = connmark_mt,
 		.matchsize      = sizeof(struct xt_connmark_mtinfo1),
@@ -180,7 +180,7 @@ static struct xt_match connmark_mt_reg[] __read_mostly = {
 	{
 		.name           = "connmark",
 		.revision       = 1,
-		.family         = AF_INET6,
+		.family         = NFPROTO_IPV6,
 		.checkentry     = connmark_mt_check,
 		.match          = connmark_mt,
 		.matchsize      = sizeof(struct xt_connmark_mtinfo1),
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 28a42a3..392b457 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -121,9 +121,9 @@ conntrack_addrcmp(const union nf_inet_addr *kaddr,
                   const union nf_inet_addr *uaddr,
                   const union nf_inet_addr *umask, unsigned int l3proto)
 {
-	if (l3proto == AF_INET)
+	if (l3proto == NFPROTO_IPV4)
 		return ((kaddr->ip ^ uaddr->ip) & umask->ip) == 0;
-	else if (l3proto == AF_INET6)
+	else if (l3proto == NFPROTO_IPV6)
 		return ipv6_masked_addr_cmp(&kaddr->in6, &umask->in6,
 		       &uaddr->in6) == 0;
 	else
@@ -356,7 +356,7 @@ static struct xt_match conntrack_mt_reg[] __read_mostly = {
 	{
 		.name       = "conntrack",
 		.revision   = 0,
-		.family     = AF_INET,
+		.family     = NFPROTO_IPV4,
 		.match      = conntrack_mt_v0,
 		.checkentry = conntrack_mt_check,
 		.destroy    = conntrack_mt_destroy,
@@ -371,7 +371,7 @@ static struct xt_match conntrack_mt_reg[] __read_mostly = {
 	{
 		.name       = "conntrack",
 		.revision   = 1,
-		.family     = AF_INET,
+		.family     = NFPROTO_IPV4,
 		.matchsize  = sizeof(struct xt_conntrack_mtinfo1),
 		.match      = conntrack_mt,
 		.checkentry = conntrack_mt_check,
@@ -381,7 +381,7 @@ static struct xt_match conntrack_mt_reg[] __read_mostly = {
 	{
 		.name       = "conntrack",
 		.revision   = 1,
-		.family     = AF_INET6,
+		.family     = NFPROTO_IPV6,
 		.matchsize  = sizeof(struct xt_conntrack_mtinfo1),
 		.match      = conntrack_mt,
 		.checkentry = conntrack_mt_check,
diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index 8b65221..87971f4 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -138,7 +138,7 @@ dccp_mt_check(const char *tablename, const void *inf,
 static struct xt_match dccp_mt_reg[] __read_mostly = {
 	{
 		.name 		= "dccp",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.checkentry	= dccp_mt_check,
 		.match		= dccp_mt,
 		.matchsize	= sizeof(struct xt_dccp_info),
@@ -147,7 +147,7 @@ static struct xt_match dccp_mt_reg[] __read_mostly = {
 	},
 	{
 		.name 		= "dccp",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.checkentry	= dccp_mt_check,
 		.match		= dccp_mt,
 		.matchsize	= sizeof(struct xt_dccp_info),
diff --git a/net/netfilter/xt_dscp.c b/net/netfilter/xt_dscp.c
index 26f4aab..7f03aa1 100644
--- a/net/netfilter/xt_dscp.c
+++ b/net/netfilter/xt_dscp.c
@@ -80,7 +80,7 @@ static bool tos_mt(const struct sk_buff *skb, const struct net_device *in,
 {
 	const struct xt_tos_match_info *info = matchinfo;
 
-	if (match->family == AF_INET)
+	if (match->family == NFPROTO_IPV4)
 		return ((ip_hdr(skb)->tos & info->tos_mask) ==
 		       info->tos_value) ^ !!info->invert;
 	else
@@ -91,7 +91,7 @@ static bool tos_mt(const struct sk_buff *skb, const struct net_device *in,
 static struct xt_match dscp_mt_reg[] __read_mostly = {
 	{
 		.name		= "dscp",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.checkentry	= dscp_mt_check,
 		.match		= dscp_mt,
 		.matchsize	= sizeof(struct xt_dscp_info),
@@ -99,7 +99,7 @@ static struct xt_match dscp_mt_reg[] __read_mostly = {
 	},
 	{
 		.name		= "dscp",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.checkentry	= dscp_mt_check,
 		.match		= dscp_mt6,
 		.matchsize	= sizeof(struct xt_dscp_info),
@@ -108,7 +108,7 @@ static struct xt_match dscp_mt_reg[] __read_mostly = {
 	{
 		.name		= "tos",
 		.revision	= 0,
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.match		= tos_mt_v0,
 		.matchsize	= sizeof(struct ipt_tos_info),
 		.me		= THIS_MODULE,
@@ -116,7 +116,7 @@ static struct xt_match dscp_mt_reg[] __read_mostly = {
 	{
 		.name		= "tos",
 		.revision	= 1,
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.match		= tos_mt,
 		.matchsize	= sizeof(struct xt_tos_match_info),
 		.me		= THIS_MODULE,
@@ -124,7 +124,7 @@ static struct xt_match dscp_mt_reg[] __read_mostly = {
 	{
 		.name		= "tos",
 		.revision	= 1,
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.match		= tos_mt,
 		.matchsize	= sizeof(struct xt_tos_match_info),
 		.me		= THIS_MODULE,
diff --git a/net/netfilter/xt_esp.c b/net/netfilter/xt_esp.c
index a133eb9..045c4de 100644
--- a/net/netfilter/xt_esp.c
+++ b/net/netfilter/xt_esp.c
@@ -88,7 +88,7 @@ esp_mt_check(const char *tablename, const void *ip_void,
 static struct xt_match esp_mt_reg[] __read_mostly = {
 	{
 		.name		= "esp",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.checkentry	= esp_mt_check,
 		.match		= esp_mt,
 		.matchsize	= sizeof(struct xt_esp),
@@ -97,7 +97,7 @@ static struct xt_match esp_mt_reg[] __read_mostly = {
 	},
 	{
 		.name		= "esp",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.checkentry	= esp_mt_check,
 		.match		= esp_mt,
 		.matchsize	= sizeof(struct xt_esp),
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index bfd4423..33c200f 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -218,7 +218,7 @@ static int htable_create_v0(struct xt_hashlimit_info *minfo, u_int8_t family)
 	hinfo->cfg.gc_interval = minfo->cfg.gc_interval;
 	hinfo->cfg.expire      = minfo->cfg.expire;
 
-	if (family == AF_INET)
+	if (family == NFPROTO_IPV4)
 		hinfo->cfg.srcmask = hinfo->cfg.dstmask = 32;
 	else
 		hinfo->cfg.srcmask = hinfo->cfg.dstmask = 128;
@@ -238,7 +238,7 @@ static int htable_create_v0(struct xt_hashlimit_info *minfo, u_int8_t family)
 	hinfo->rnd_initialized = 0;
 	spin_lock_init(&hinfo->lock);
 	hinfo->pde = proc_create(minfo->name, 0,
-				 family == AF_INET ? hashlimit_procdir4 :
+				 family == NFPROTO_IPV4 ? hashlimit_procdir4 :
 						     hashlimit_procdir6,
 				 &dl_file_ops);
 	if (!hinfo->pde) {
@@ -301,7 +301,7 @@ static int htable_create(struct xt_hashlimit_mtinfo1 *minfo, u_int8_t family)
 	spin_lock_init(&hinfo->lock);
 
 	hinfo->pde = proc_create(minfo->name, 0,
-				 family == AF_INET ? hashlimit_procdir4 :
+				 family == NFPROTO_IPV4 ? hashlimit_procdir4 :
 						     hashlimit_procdir6,
 				 &dl_file_ops);
 	if (hinfo->pde == NULL) {
@@ -372,7 +372,7 @@ static void htable_destroy(struct xt_hashlimit_htable *hinfo)
 
 	/* remove proc entry */
 	remove_proc_entry(hinfo->pde->name,
-			  hinfo->family == AF_INET ? hashlimit_procdir4 :
+			  hinfo->family == NFPROTO_IPV4 ? hashlimit_procdir4 :
 						     hashlimit_procdir6);
 	htable_selective_cleanup(hinfo, select_all);
 	vfree(hinfo);
@@ -503,7 +503,7 @@ hashlimit_init_dst(const struct xt_hashlimit_htable *hinfo,
 	memset(dst, 0, sizeof(*dst));
 
 	switch (hinfo->family) {
-	case AF_INET:
+	case NFPROTO_IPV4:
 		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_DIP)
 			dst->ip.dst = maskl(ip_hdr(skb)->daddr,
 			              hinfo->cfg.dstmask);
@@ -517,7 +517,7 @@ hashlimit_init_dst(const struct xt_hashlimit_htable *hinfo,
 		nexthdr = ip_hdr(skb)->protocol;
 		break;
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
-	case AF_INET6:
+	case NFPROTO_IPV6:
 		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_DIP) {
 			memcpy(&dst->ip6.dst, &ipv6_hdr(skb)->daddr,
 			       sizeof(dst->ip6.dst));
@@ -739,7 +739,7 @@ hashlimit_mt_check(const char *tablename, const void *inf,
 		return false;
 	if (info->name[sizeof(info->name)-1] != '\0')
 		return false;
-	if (match->family == AF_INET) {
+	if (match->family == NFPROTO_IPV4) {
 		if (info->cfg.srcmask > 32 || info->cfg.dstmask > 32)
 			return false;
 	} else {
@@ -807,7 +807,7 @@ static struct xt_match hashlimit_mt_reg[] __read_mostly = {
 	{
 		.name		= "hashlimit",
 		.revision	= 0,
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.match		= hashlimit_mt_v0,
 		.matchsize	= sizeof(struct xt_hashlimit_info),
 #ifdef CONFIG_COMPAT
@@ -822,7 +822,7 @@ static struct xt_match hashlimit_mt_reg[] __read_mostly = {
 	{
 		.name           = "hashlimit",
 		.revision       = 1,
-		.family         = AF_INET,
+		.family         = NFPROTO_IPV4,
 		.match          = hashlimit_mt,
 		.matchsize      = sizeof(struct xt_hashlimit_mtinfo1),
 		.checkentry     = hashlimit_mt_check,
@@ -832,7 +832,7 @@ static struct xt_match hashlimit_mt_reg[] __read_mostly = {
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
 	{
 		.name		= "hashlimit",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.match		= hashlimit_mt_v0,
 		.matchsize	= sizeof(struct xt_hashlimit_info),
 #ifdef CONFIG_COMPAT
@@ -847,7 +847,7 @@ static struct xt_match hashlimit_mt_reg[] __read_mostly = {
 	{
 		.name           = "hashlimit",
 		.revision       = 1,
-		.family         = AF_INET6,
+		.family         = NFPROTO_IPV6,
 		.match          = hashlimit_mt,
 		.matchsize      = sizeof(struct xt_hashlimit_mtinfo1),
 		.checkentry     = hashlimit_mt_check,
@@ -909,7 +909,7 @@ static int dl_seq_real_show(struct dsthash_ent *ent, u_int8_t family,
 	rateinfo_recalc(ent, jiffies);
 
 	switch (family) {
-	case AF_INET:
+	case NFPROTO_IPV4:
 		return seq_printf(s, "%ld %u.%u.%u.%u:%u->"
 				     "%u.%u.%u.%u:%u %u %u %u\n",
 				 (long)(ent->expires - jiffies)/HZ,
@@ -920,7 +920,7 @@ static int dl_seq_real_show(struct dsthash_ent *ent, u_int8_t family,
 				 ent->rateinfo.credit, ent->rateinfo.credit_cap,
 				 ent->rateinfo.cost);
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
-	case AF_INET6:
+	case NFPROTO_IPV6:
 		return seq_printf(s, "%ld " NIP6_FMT ":%u->"
 				     NIP6_FMT ":%u %u %u %u\n",
 				 (long)(ent->expires - jiffies)/HZ,
diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index dada290..134d943 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -81,7 +81,7 @@ static void helper_mt_destroy(const struct xt_match *match, void *matchinfo)
 static struct xt_match helper_mt_reg[] __read_mostly = {
 	{
 		.name		= "helper",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.checkentry	= helper_mt_check,
 		.match		= helper_mt,
 		.destroy	= helper_mt_destroy,
@@ -90,7 +90,7 @@ static struct xt_match helper_mt_reg[] __read_mostly = {
 	},
 	{
 		.name		= "helper",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.checkentry	= helper_mt_check,
 		.match		= helper_mt,
 		.destroy	= helper_mt_destroy,
diff --git a/net/netfilter/xt_iprange.c b/net/netfilter/xt_iprange.c
index 500528d..1774062 100644
--- a/net/netfilter/xt_iprange.c
+++ b/net/netfilter/xt_iprange.c
@@ -141,7 +141,7 @@ static struct xt_match iprange_mt_reg[] __read_mostly = {
 	{
 		.name      = "iprange",
 		.revision  = 0,
-		.family    = AF_INET,
+		.family    = NFPROTO_IPV4,
 		.match     = iprange_mt_v0,
 		.matchsize = sizeof(struct ipt_iprange_info),
 		.me        = THIS_MODULE,
@@ -149,7 +149,7 @@ static struct xt_match iprange_mt_reg[] __read_mostly = {
 	{
 		.name      = "iprange",
 		.revision  = 1,
-		.family    = AF_INET,
+		.family    = NFPROTO_IPV4,
 		.match     = iprange_mt4,
 		.matchsize = sizeof(struct xt_iprange_mtinfo),
 		.me        = THIS_MODULE,
@@ -157,7 +157,7 @@ static struct xt_match iprange_mt_reg[] __read_mostly = {
 	{
 		.name      = "iprange",
 		.revision  = 1,
-		.family    = AF_INET6,
+		.family    = NFPROTO_IPV6,
 		.match     = iprange_mt6,
 		.matchsize = sizeof(struct xt_iprange_mtinfo),
 		.me        = THIS_MODULE,
diff --git a/net/netfilter/xt_length.c b/net/netfilter/xt_length.c
index d874fa2..ea6a42c 100644
--- a/net/netfilter/xt_length.c
+++ b/net/netfilter/xt_length.c
@@ -260,7 +260,7 @@ static struct xt_match length_mt_reg[] __read_mostly = {
 	{
 		.name		= "length",
 		.revision	= 0,
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.match		= length_mt_v0,
 		.matchsize	= sizeof(struct xt_length_info),
 		.me		= THIS_MODULE,
@@ -268,7 +268,7 @@ static struct xt_match length_mt_reg[] __read_mostly = {
 	{
 		.name		= "length",
 		.revision	= 0,
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.match		= length_mt6_v0,
 		.matchsize	= sizeof(struct xt_length_info),
 		.me		= THIS_MODULE,
@@ -276,7 +276,7 @@ static struct xt_match length_mt_reg[] __read_mostly = {
 	{
 		.name           = "length",
 		.revision       = 1,
-		.family         = AF_INET,
+		.family         = NFPROTO_IPV4,
 		.match          = length_mt4,
 		.matchsize      = sizeof(struct xt_length_mtinfo1),
 		.me             = THIS_MODULE,
@@ -285,7 +285,7 @@ static struct xt_match length_mt_reg[] __read_mostly = {
 	{
 		.name           = "length",
 		.revision       = 1,
-		.family         = AF_INET6,
+		.family         = NFPROTO_IPV6,
 		.match          = length_mt6,
 		.matchsize      = sizeof(struct xt_length_mtinfo1),
 		.me             = THIS_MODULE,
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index aad9ab8..584d668 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -170,7 +170,7 @@ static int limit_mt_compat_to_user(void __user *dst, void *src)
 static struct xt_match limit_mt_reg[] __read_mostly = {
 	{
 		.name		= "limit",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.checkentry	= limit_mt_check,
 		.match		= limit_mt,
 		.matchsize	= sizeof(struct xt_rateinfo),
@@ -183,7 +183,7 @@ static struct xt_match limit_mt_reg[] __read_mostly = {
 	},
 	{
 		.name		= "limit",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.checkentry	= limit_mt_check,
 		.match		= limit_mt,
 		.matchsize	= sizeof(struct xt_rateinfo),
diff --git a/net/netfilter/xt_mac.c b/net/netfilter/xt_mac.c
index b3e96a0..60db240 100644
--- a/net/netfilter/xt_mac.c
+++ b/net/netfilter/xt_mac.c
@@ -42,7 +42,7 @@ mac_mt(const struct sk_buff *skb, const struct net_device *in,
 static struct xt_match mac_mt_reg[] __read_mostly = {
 	{
 		.name		= "mac",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.match		= mac_mt,
 		.matchsize	= sizeof(struct xt_mac_info),
 		.hooks		= (1 << NF_INET_PRE_ROUTING) |
@@ -52,7 +52,7 @@ static struct xt_match mac_mt_reg[] __read_mostly = {
 	},
 	{
 		.name		= "mac",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.match		= mac_mt,
 		.matchsize	= sizeof(struct xt_mac_info),
 		.hooks		= (1 << NF_INET_PRE_ROUTING) |
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index 9f78f61..c66affd 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -92,7 +92,7 @@ static struct xt_match mark_mt_reg[] __read_mostly = {
 	{
 		.name		= "mark",
 		.revision	= 0,
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.checkentry	= mark_mt_check_v0,
 		.match		= mark_mt_v0,
 		.matchsize	= sizeof(struct xt_mark_info),
@@ -106,7 +106,7 @@ static struct xt_match mark_mt_reg[] __read_mostly = {
 	{
 		.name		= "mark",
 		.revision	= 0,
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.checkentry	= mark_mt_check_v0,
 		.match		= mark_mt_v0,
 		.matchsize	= sizeof(struct xt_mark_info),
@@ -120,7 +120,7 @@ static struct xt_match mark_mt_reg[] __read_mostly = {
 	{
 		.name           = "mark",
 		.revision       = 1,
-		.family         = AF_INET,
+		.family         = NFPROTO_IPV4,
 		.match          = mark_mt,
 		.matchsize      = sizeof(struct xt_mark_mtinfo1),
 		.me             = THIS_MODULE,
@@ -128,7 +128,7 @@ static struct xt_match mark_mt_reg[] __read_mostly = {
 	{
 		.name           = "mark",
 		.revision       = 1,
-		.family         = AF_INET6,
+		.family         = NFPROTO_IPV6,
 		.match          = mark_mt,
 		.matchsize      = sizeof(struct xt_mark_mtinfo1),
 		.me             = THIS_MODULE,
diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index fd88c48..f6fe008 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -216,7 +216,7 @@ multiport_mt6_check(const char *tablename, const void *info,
 static struct xt_match multiport_mt_reg[] __read_mostly = {
 	{
 		.name		= "multiport",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.revision	= 0,
 		.checkentry	= multiport_mt_check_v0,
 		.match		= multiport_mt_v0,
@@ -225,7 +225,7 @@ static struct xt_match multiport_mt_reg[] __read_mostly = {
 	},
 	{
 		.name		= "multiport",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.revision	= 1,
 		.checkentry	= multiport_mt_check,
 		.match		= multiport_mt,
@@ -234,7 +234,7 @@ static struct xt_match multiport_mt_reg[] __read_mostly = {
 	},
 	{
 		.name		= "multiport",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.revision	= 0,
 		.checkentry	= multiport_mt6_check_v0,
 		.match		= multiport_mt_v0,
@@ -243,7 +243,7 @@ static struct xt_match multiport_mt_reg[] __read_mostly = {
 	},
 	{
 		.name		= "multiport",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.revision	= 1,
 		.checkentry	= multiport_mt6_check,
 		.match		= multiport_mt,
diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
index 9059c16..d1c3b7a 100644
--- a/net/netfilter/xt_owner.c
+++ b/net/netfilter/xt_owner.c
@@ -153,7 +153,7 @@ static struct xt_match owner_mt_reg[] __read_mostly = {
 	{
 		.name       = "owner",
 		.revision   = 0,
-		.family     = AF_INET,
+		.family     = NFPROTO_IPV4,
 		.match      = owner_mt_v0,
 		.matchsize  = sizeof(struct ipt_owner_info),
 		.checkentry = owner_mt_check_v0,
@@ -164,7 +164,7 @@ static struct xt_match owner_mt_reg[] __read_mostly = {
 	{
 		.name       = "owner",
 		.revision   = 0,
-		.family     = AF_INET6,
+		.family     = NFPROTO_IPV6,
 		.match      = owner_mt6_v0,
 		.matchsize  = sizeof(struct ip6t_owner_info),
 		.checkentry = owner_mt6_check_v0,
@@ -175,7 +175,7 @@ static struct xt_match owner_mt_reg[] __read_mostly = {
 	{
 		.name       = "owner",
 		.revision   = 1,
-		.family     = AF_INET,
+		.family     = NFPROTO_IPV4,
 		.match      = owner_mt,
 		.matchsize  = sizeof(struct xt_owner_match_info),
 		.hooks      = (1 << NF_INET_LOCAL_OUT) |
@@ -185,7 +185,7 @@ static struct xt_match owner_mt_reg[] __read_mostly = {
 	{
 		.name       = "owner",
 		.revision   = 1,
-		.family     = AF_INET6,
+		.family     = NFPROTO_IPV6,
 		.match      = owner_mt,
 		.matchsize  = sizeof(struct xt_owner_match_info),
 		.hooks      = (1 << NF_INET_LOCAL_OUT) |
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index 4ec1094..72a0bdd 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -121,7 +121,7 @@ physdev_mt_check(const char *tablename, const void *ip,
 static struct xt_match physdev_mt_reg[] __read_mostly = {
 	{
 		.name		= "physdev",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.checkentry	= physdev_mt_check,
 		.match		= physdev_mt,
 		.matchsize	= sizeof(struct xt_physdev_info),
@@ -129,7 +129,7 @@ static struct xt_match physdev_mt_reg[] __read_mostly = {
 	},
 	{
 		.name		= "physdev",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.checkentry	= physdev_mt_check,
 		.match		= physdev_mt,
 		.matchsize	= sizeof(struct xt_physdev_info),
diff --git a/net/netfilter/xt_pkttype.c b/net/netfilter/xt_pkttype.c
index 7936f7e..81e86d3 100644
--- a/net/netfilter/xt_pkttype.c
+++ b/net/netfilter/xt_pkttype.c
@@ -33,10 +33,10 @@ pkttype_mt(const struct sk_buff *skb, const struct net_device *in,
 
 	if (skb->pkt_type != PACKET_LOOPBACK)
 		type = skb->pkt_type;
-	else if (match->family == AF_INET &&
+	else if (match->family == NFPROTO_IPV4 &&
 	    ipv4_is_multicast(ip_hdr(skb)->daddr))
 		type = PACKET_MULTICAST;
-	else if (match->family == AF_INET6 &&
+	else if (match->family == NFPROTO_IPV6 &&
 	    ipv6_hdr(skb)->daddr.s6_addr[0] == 0xFF)
 		type = PACKET_MULTICAST;
 	else
@@ -48,14 +48,14 @@ pkttype_mt(const struct sk_buff *skb, const struct net_device *in,
 static struct xt_match pkttype_mt_reg[] __read_mostly = {
 	{
 		.name		= "pkttype",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.match		= pkttype_mt,
 		.matchsize	= sizeof(struct xt_pkttype_info),
 		.me		= THIS_MODULE,
 	},
 	{
 		.name		= "pkttype",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.match		= pkttype_mt,
 		.matchsize	= sizeof(struct xt_pkttype_info),
 		.me		= THIS_MODULE,
diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
index d351582..f1d514e 100644
--- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -26,9 +26,9 @@ xt_addr_cmp(const union nf_inet_addr *a1, const union nf_inet_addr *m,
 	    const union nf_inet_addr *a2, unsigned short family)
 {
 	switch (family) {
-	case AF_INET:
+	case NFPROTO_IPV4:
 		return ((a1->ip ^ a2->ip) & m->ip) == 0;
-	case AF_INET6:
+	case NFPROTO_IPV6:
 		return ipv6_masked_addr_cmp(&a1->in6, &m->in6, &a2->in6) == 0;
 	}
 	return false;
@@ -165,7 +165,7 @@ policy_mt_check(const char *tablename, const void *ip_void,
 static struct xt_match policy_mt_reg[] __read_mostly = {
 	{
 		.name		= "policy",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.checkentry 	= policy_mt_check,
 		.match		= policy_mt,
 		.matchsize	= sizeof(struct xt_policy_info),
@@ -173,7 +173,7 @@ static struct xt_match policy_mt_reg[] __read_mostly = {
 	},
 	{
 		.name		= "policy",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.checkentry	= policy_mt_check,
 		.match		= policy_mt,
 		.matchsize	= sizeof(struct xt_policy_info),
diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
index 3b021d0..59f61e3 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -57,7 +57,7 @@ quota_mt_check(const char *tablename, const void *entry,
 static struct xt_match quota_mt_reg[] __read_mostly = {
 	{
 		.name		= "quota",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.checkentry	= quota_mt_check,
 		.match		= quota_mt,
 		.matchsize	= sizeof(struct xt_quota_info),
@@ -65,7 +65,7 @@ static struct xt_match quota_mt_reg[] __read_mostly = {
 	},
 	{
 		.name		= "quota",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.checkentry	= quota_mt_check,
 		.match		= quota_mt,
 		.matchsize	= sizeof(struct xt_quota_info),
diff --git a/net/netfilter/xt_rateest.c b/net/netfilter/xt_rateest.c
index ebd84f1..ba1cb57 100644
--- a/net/netfilter/xt_rateest.c
+++ b/net/netfilter/xt_rateest.c
@@ -139,7 +139,7 @@ static void xt_rateest_mt_destroy(const struct xt_match *match,
 
 static struct xt_match xt_rateest_match[] __read_mostly = {
 	{
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.name		= "rateest",
 		.match		= xt_rateest_mt,
 		.checkentry	= xt_rateest_mt_checkentry,
@@ -148,7 +148,7 @@ static struct xt_match xt_rateest_match[] __read_mostly = {
 		.me		= THIS_MODULE,
 	},
 	{
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.name		= "rateest",
 		.match		= xt_rateest_mt,
 		.checkentry	= xt_rateest_mt_checkentry,
diff --git a/net/netfilter/xt_realm.c b/net/netfilter/xt_realm.c
index 7df1627..ef65756 100644
--- a/net/netfilter/xt_realm.c
+++ b/net/netfilter/xt_realm.c
@@ -39,7 +39,7 @@ static struct xt_match realm_mt_reg __read_mostly = {
 	.matchsize	= sizeof(struct xt_realm_info),
 	.hooks		= (1 << NF_INET_POST_ROUTING) | (1 << NF_INET_FORWARD) |
 			  (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_LOCAL_IN),
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.me		= THIS_MODULE
 };
 
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 43d9926..9351d58 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -127,7 +127,7 @@ recent_entry_lookup(const struct recent_table *table,
 	struct recent_entry *e;
 	unsigned int h;
 
-	if (family == AF_INET)
+	if (family == NFPROTO_IPV4)
 		h = recent_entry_hash4(addrp);
 	else
 		h = recent_entry_hash6(addrp);
@@ -168,7 +168,7 @@ recent_entry_init(struct recent_table *t, const union nf_inet_addr *addr,
 	e->nstamps   = 1;
 	e->index     = 1;
 	e->family    = family;
-	if (family == AF_INET)
+	if (family == NFPROTO_IPV4)
 		list_add_tail(&e->list, &t->iphash[recent_entry_hash4(addr)]);
 	else
 		list_add_tail(&e->list, &t->iphash[recent_entry_hash6(addr)]);
@@ -219,7 +219,7 @@ recent_mt(const struct sk_buff *skb, const struct net_device *in,
 	u_int8_t ttl;
 	bool ret = info->invert;
 
-	if (match->family == AF_INET) {
+	if (match->family == NFPROTO_IPV4) {
 		const struct iphdr *iph = ip_hdr(skb);
 
 		if (info->side == XT_RECENT_DEST)
@@ -432,7 +432,7 @@ static int recent_seq_show(struct seq_file *seq, void *v)
 	unsigned int i;
 
 	i = (e->index - 1) % ip_pkt_list_tot;
-	if (e->family == AF_INET)
+	if (e->family == NFPROTO_IPV4)
 		seq_printf(seq, "src=" NIPQUAD_FMT " ttl: %u last_seen: %lu "
 			   "oldest_pkt: %u", NIPQUAD(e->addr.ip), e->ttl,
 			   e->stamps[i], e->index);
@@ -522,10 +522,11 @@ static ssize_t recent_old_proc_write(struct file *file,
 	addr = in_aton(c);
 
 	spin_lock_bh(&recent_lock);
-	e = recent_entry_lookup(t, (const void *)&addr, PF_INET, 0);
+	e = recent_entry_lookup(t, (const void *)&addr, NFPROTO_IPV4, 0);
 	if (e == NULL) {
 		if (add)
-			recent_entry_init(t, (const void *)&addr, PF_INET, 0);
+			recent_entry_init(t, (const void *)&addr,
+					  NFPROTO_IPV4, 0);
 	} else {
 		if (add)
 			recent_entry_update(t, e);
@@ -588,10 +589,10 @@ recent_mt_proc_write(struct file *file, const char __user *input,
 	++c;
 	--size;
 	if (strnchr(c, size, ':') != NULL) {
-		family = AF_INET6;
+		family = NFPROTO_IPV6;
 		succ   = in6_pton(c, size, (void *)&addr, '\n', NULL);
 	} else {
-		family = AF_INET;
+		family = NFPROTO_IPV4;
 		succ   = in4_pton(c, size, (void *)&addr, '\n', NULL);
 	}
 
@@ -631,7 +632,7 @@ static struct xt_match recent_mt_reg[] __read_mostly = {
 	{
 		.name       = "recent",
 		.revision   = 0,
-		.family     = AF_INET,
+		.family     = NFPROTO_IPV4,
 		.match      = recent_mt,
 		.matchsize  = sizeof(struct xt_recent_mtinfo),
 		.checkentry = recent_mt_check,
@@ -641,7 +642,7 @@ static struct xt_match recent_mt_reg[] __read_mostly = {
 	{
 		.name       = "recent",
 		.revision   = 0,
-		.family     = AF_INET6,
+		.family     = NFPROTO_IPV6,
 		.match      = recent_mt,
 		.matchsize  = sizeof(struct xt_recent_mtinfo),
 		.checkentry = recent_mt_check,
diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index e6e4681..ab67aca 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -169,7 +169,7 @@ sctp_mt_check(const char *tablename, const void *inf,
 static struct xt_match sctp_mt_reg[] __read_mostly = {
 	{
 		.name		= "sctp",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.checkentry	= sctp_mt_check,
 		.match		= sctp_mt,
 		.matchsize	= sizeof(struct xt_sctp_info),
@@ -178,7 +178,7 @@ static struct xt_match sctp_mt_reg[] __read_mostly = {
 	},
 	{
 		.name		= "sctp",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.checkentry	= sctp_mt_check,
 		.match		= sctp_mt,
 		.matchsize	= sizeof(struct xt_sctp_info),
diff --git a/net/netfilter/xt_state.c b/net/netfilter/xt_state.c
index a776dc3..f92f8bc 100644
--- a/net/netfilter/xt_state.c
+++ b/net/netfilter/xt_state.c
@@ -61,7 +61,7 @@ static void state_mt_destroy(const struct xt_match *match, void *matchinfo)
 static struct xt_match state_mt_reg[] __read_mostly = {
 	{
 		.name		= "state",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.checkentry	= state_mt_check,
 		.match		= state_mt,
 		.destroy	= state_mt_destroy,
@@ -70,7 +70,7 @@ static struct xt_match state_mt_reg[] __read_mostly = {
 	},
 	{
 		.name		= "state",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.checkentry	= state_mt_check,
 		.match		= state_mt,
 		.destroy	= state_mt_destroy,
diff --git a/net/netfilter/xt_statistic.c b/net/netfilter/xt_statistic.c
index 4313308..fd3bb14 100644
--- a/net/netfilter/xt_statistic.c
+++ b/net/netfilter/xt_statistic.c
@@ -69,7 +69,7 @@ statistic_mt_check(const char *tablename, const void *entry,
 static struct xt_match statistic_mt_reg[] __read_mostly = {
 	{
 		.name		= "statistic",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.checkentry	= statistic_mt_check,
 		.match		= statistic_mt,
 		.matchsize	= sizeof(struct xt_statistic_info),
@@ -77,7 +77,7 @@ static struct xt_match statistic_mt_reg[] __read_mostly = {
 	},
 	{
 		.name		= "statistic",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.checkentry	= statistic_mt_check,
 		.match		= statistic_mt,
 		.matchsize	= sizeof(struct xt_statistic_info),
diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index 72f694d..ccab407 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -72,7 +72,7 @@ static void string_mt_destroy(const struct xt_match *match, void *matchinfo)
 static struct xt_match string_mt_reg[] __read_mostly = {
 	{
 		.name 		= "string",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.checkentry	= string_mt_check,
 		.match 		= string_mt,
 		.destroy 	= string_mt_destroy,
@@ -81,7 +81,7 @@ static struct xt_match string_mt_reg[] __read_mostly = {
 	},
 	{
 		.name 		= "string",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.checkentry	= string_mt_check,
 		.match 		= string_mt,
 		.destroy 	= string_mt_destroy,
diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index 6771bf0..4791c7c 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -83,7 +83,7 @@ dropit:
 static struct xt_match tcpmss_mt_reg[] __read_mostly = {
 	{
 		.name		= "tcpmss",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.match		= tcpmss_mt,
 		.matchsize	= sizeof(struct xt_tcpmss_match_info),
 		.proto		= IPPROTO_TCP,
@@ -91,7 +91,7 @@ static struct xt_match tcpmss_mt_reg[] __read_mostly = {
 	},
 	{
 		.name		= "tcpmss",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.match		= tcpmss_mt,
 		.matchsize	= sizeof(struct xt_tcpmss_match_info),
 		.proto		= IPPROTO_TCP,
diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c
index 951b06b..5a6268c 100644
--- a/net/netfilter/xt_tcpudp.c
+++ b/net/netfilter/xt_tcpudp.c
@@ -186,7 +186,7 @@ udp_mt_check(const char *tablename, const void *info,
 static struct xt_match tcpudp_mt_reg[] __read_mostly = {
 	{
 		.name		= "tcp",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.checkentry	= tcp_mt_check,
 		.match		= tcp_mt,
 		.matchsize	= sizeof(struct xt_tcp),
@@ -195,7 +195,7 @@ static struct xt_match tcpudp_mt_reg[] __read_mostly = {
 	},
 	{
 		.name		= "tcp",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.checkentry	= tcp_mt_check,
 		.match		= tcp_mt,
 		.matchsize	= sizeof(struct xt_tcp),
@@ -204,7 +204,7 @@ static struct xt_match tcpudp_mt_reg[] __read_mostly = {
 	},
 	{
 		.name		= "udp",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.checkentry	= udp_mt_check,
 		.match		= udp_mt,
 		.matchsize	= sizeof(struct xt_udp),
@@ -213,7 +213,7 @@ static struct xt_match tcpudp_mt_reg[] __read_mostly = {
 	},
 	{
 		.name		= "udp",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.checkentry	= udp_mt_check,
 		.match		= udp_mt,
 		.matchsize	= sizeof(struct xt_udp),
@@ -222,7 +222,7 @@ static struct xt_match tcpudp_mt_reg[] __read_mostly = {
 	},
 	{
 		.name		= "udplite",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.checkentry	= udp_mt_check,
 		.match		= udp_mt,
 		.matchsize	= sizeof(struct xt_udp),
@@ -231,7 +231,7 @@ static struct xt_match tcpudp_mt_reg[] __read_mostly = {
 	},
 	{
 		.name		= "udplite",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.checkentry	= udp_mt_check,
 		.match		= udp_mt,
 		.matchsize	= sizeof(struct xt_udp),
diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index ed76baa..008f2b2 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -238,7 +238,7 @@ time_mt_check(const char *tablename, const void *ip,
 static struct xt_match time_mt_reg[] __read_mostly = {
 	{
 		.name       = "time",
-		.family     = AF_INET,
+		.family     = NFPROTO_IPV4,
 		.match      = time_mt,
 		.matchsize  = sizeof(struct xt_time_info),
 		.checkentry = time_mt_check,
@@ -246,7 +246,7 @@ static struct xt_match time_mt_reg[] __read_mostly = {
 	},
 	{
 		.name       = "time",
-		.family     = AF_INET6,
+		.family     = NFPROTO_IPV6,
 		.match      = time_mt,
 		.matchsize  = sizeof(struct xt_time_info),
 		.checkentry = time_mt_check,
diff --git a/net/netfilter/xt_u32.c b/net/netfilter/xt_u32.c
index 627e0f3..ed9f834 100644
--- a/net/netfilter/xt_u32.c
+++ b/net/netfilter/xt_u32.c
@@ -102,14 +102,14 @@ u32_mt(const struct sk_buff *skb, const struct net_device *in,
 static struct xt_match u32_mt_reg[] __read_mostly = {
 	{
 		.name       = "u32",
-		.family     = AF_INET,
+		.family     = NFPROTO_IPV4,
 		.match      = u32_mt,
 		.matchsize  = sizeof(struct xt_u32),
 		.me         = THIS_MODULE,
 	},
 	{
 		.name       = "u32",
-		.family     = AF_INET6,
+		.family     = NFPROTO_IPV6,
 		.match      = u32_mt,
 		.matchsize  = sizeof(struct xt_u32),
 		.me         = THIS_MODULE,
-- 
1.5.5

