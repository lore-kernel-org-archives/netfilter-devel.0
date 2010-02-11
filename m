From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH v0] netns NOTRACK
Date: Thu, 11 Feb 2010 19:31:17 +0200
Message-ID: <20100211173117.GD4099@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:36721 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311Ab0BKRbW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 12:31:22 -0500
Received: by fg-out-1718.google.com with SMTP id e21so18191fga.1
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Feb 2010 09:31:20 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is netns NOTRACK fix we discussed earlier.

The idea was to remove nf_conntrack_untracked and
declare that ->nfct=NULL and ->nfctinfo=IP_CT_UNTRACKED are untracked
connections.

It wasn't tested more than "it boots, no conntracks are created"
but so far so good.



diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index c608677..2613d89 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -19,7 +19,9 @@ enum ip_conntrack_info {
 	IP_CT_IS_REPLY,
 
 	/* Number of distinct IP_CT types (no NEW in reply dirn). */
-	IP_CT_NUMBER = IP_CT_IS_REPLY * 2 - 1
+	IP_CT_NUMBER = IP_CT_IS_REPLY * 2 - 1,
+
+	IP_CT_UNTRACKED,
 };
 
 /* Bitset representing status of connection. */
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 5043d61..ecf4e0a 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -259,9 +259,6 @@ extern s16 (*nf_ct_nat_offset)(const struct nf_conn *ct,
 			       enum ip_conntrack_dir dir,
 			       u32 seq);
 
-/* Fake conntrack entry for untracked connections */
-extern struct nf_conn nf_conntrack_untracked;
-
 /* Iterate over all conntracks: if iter returns true, it's deleted. */
 extern void
 nf_ct_iterate_cleanup(struct net *net, int (*iter)(struct nf_conn *i, void *data), void *data);
@@ -290,7 +287,7 @@ static inline int nf_ct_is_dying(struct nf_conn *ct)
 
 static inline int nf_ct_is_untracked(const struct sk_buff *skb)
 {
-	return (skb->nfct == &nf_conntrack_untracked.ct_general);
+	return !skb->nfct && skb->nfctinfo == IP_CT_UNTRACKED;
 }
 
 extern int nf_conntrack_set_hashsize(const char *val, struct kernel_param *kp);
diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 5a449b4..171481b 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -59,7 +59,7 @@ static inline int nf_conntrack_confirm(struct sk_buff *skb)
 	struct nf_conn *ct = (struct nf_conn *)skb->nfct;
 	int ret = NF_ACCEPT;
 
-	if (ct && ct != &nf_conntrack_untracked) {
+	if (ct) {
 		if (!nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct))
 			ret = __nf_conntrack_confirm(skb);
 		if (likely(ret == NF_ACCEPT))
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 268e2e7..66af0b9 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -792,9 +792,11 @@ static unsigned int br_nf_local_out(unsigned int hook, struct sk_buff *skb,
 }
 
 #if defined(CONFIG_NF_CONNTRACK_IPV4) || defined(CONFIG_NF_CONNTRACK_IPV4_MODULE)
+#include <net/netfilter/nf_conntrack.h>
+
 static int br_nf_dev_queue_xmit(struct sk_buff *skb)
 {
-	if (skb->nfct != NULL &&
+	if ((skb->nfct != NULL || nf_ct_is_untracked(skb)) &&
 	    (skb->protocol == htons(ETH_P_IP) || IS_VLAN_IP(skb)) &&
 	    skb->len > skb->dev->mtu &&
 	    !skb_is_gso(skb))
diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
index f6f4668..c22277d 100644
--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -17,7 +17,9 @@
 #include <linux/netfilter_bridge.h>
 #include <linux/netfilter_ipv4.h>
 #include <net/netfilter/ipv4/nf_defrag_ipv4.h>
+#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 #include <net/netfilter/nf_conntrack.h>
+#endif
 
 /* Returns new sk_buff, or NULL */
 static int nf_ct_ipv4_gather_frags(struct sk_buff *skb, u_int32_t user)
@@ -62,6 +64,8 @@ static unsigned int ipv4_conntrack_defrag(unsigned int hooknum,
 	   fragment check. */
 	if (skb->nfct && !nf_ct_is_template((struct nf_conn *)skb->nfct))
 		return NF_ACCEPT;
+	if (nf_ct_is_untracked(skb))
+		return NF_ACCEPT;
 #endif
 #endif
 	/* Gather fragments. */
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 921ba00..307d9ef 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -736,9 +736,6 @@ static int __init nf_nat_init(void)
 	rcu_assign_pointer(nf_nat_protos[IPPROTO_ICMP], &nf_nat_protocol_icmp);
 	spin_unlock_bh(&nf_nat_lock);
 
-	/* Initialize fake conntrack so that NAT will skip it */
-	nf_conntrack_untracked.status |= IPS_NAT_DONE_MASK;
-
 	l3proto = nf_ct_l3proto_find_get((u_int16_t)AF_INET);
 
 	BUG_ON(nf_nat_seq_adjust_hook != NULL);
diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index 5678e95..1df7d5f 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -93,11 +93,8 @@ nf_nat_fn(unsigned int hooknum,
 	   have dropped it.  Hence it's the user's responsibilty to
 	   packet filter it out, or implement conntrack/NAT for that
 	   protocol. 8) --RR */
-	if (!ct)
-		return NF_ACCEPT;
-
 	/* Don't try to NAT if this packet is not conntracked */
-	if (ct == &nf_conntrack_untracked)
+	if (!ct)
 		return NF_ACCEPT;
 
 	nat = nfct_nat(ct);
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 55ce22e..1e506ec 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -214,6 +214,8 @@ static unsigned int ipv6_defrag(unsigned int hooknum,
 	/* Previously seen (loopback)?  */
 	if (skb->nfct && !nf_ct_is_template((struct nf_conn *)skb->nfct))
 		return NF_ACCEPT;
+	if (nf_ct_is_untracked(skb))
+		return NF_ACCEPT;
 
 	reasm = nf_ct_frag6_gather(skb, nf_ct6_defrag_user(hooknum, skb));
 	/* queued */
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index c7b8bd1..3d8ec10 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -205,9 +205,8 @@ icmpv6_error(struct net *net, struct sk_buff *skb, unsigned int dataoff,
 	type = icmp6h->icmp6_type - 130;
 	if (type >= 0 && type < sizeof(noct_valid_new) &&
 	    noct_valid_new[type]) {
-		skb->nfct = &nf_conntrack_untracked.ct_general;
-		skb->nfctinfo = IP_CT_NEW;
-		nf_conntrack_get(skb->nfct);
+		skb->nfct = NULL;
+		skb->nfctinfo = IP_CT_UNTRACKED;
 		return NF_ACCEPT;
 	}
 
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 60ec4e4..fea43ee 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -210,6 +210,8 @@ int skb_make_writable(struct sk_buff *skb, unsigned int writable_len)
 EXPORT_SYMBOL(skb_make_writable);
 
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
+#include <net/netfilter/nf_conntrack.h>
+
 /* This does not belong here, but locally generated errors need it if connection
    tracking in use: without this, connection may not be in hash table, and hence
    manufactured ICMP or RST packets will not be associated with it. */
@@ -220,7 +222,7 @@ void nf_ct_attach(struct sk_buff *new, struct sk_buff *skb)
 {
 	void (*attach)(struct sk_buff *, struct sk_buff *);
 
-	if (skb->nfct) {
+	if (skb->nfct || nf_ct_is_untracked(skb)) {
 		rcu_read_lock();
 		attach = rcu_dereference(ip_ct_attach);
 		if (attach)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 90de6c5..c1ebe94 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -61,9 +60,6 @@ EXPORT_SYMBOL_GPL(nf_conntrack_htable_size);
 unsigned int nf_conntrack_max __read_mostly;
 EXPORT_SYMBOL_GPL(nf_conntrack_max);
 
-struct nf_conn nf_conntrack_untracked __read_mostly;
-EXPORT_SYMBOL_GPL(nf_conntrack_untracked);
-
 static int nf_conntrack_hash_rnd_initted;
 static unsigned int nf_conntrack_hash_rnd;
 
@@ -779,7 +775,8 @@ nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
 			return NF_ACCEPT;
 		}
 		skb->nfct = NULL;
-	}
+	} else if (nf_ct_is_untracked(skb))
+		return NF_ACCEPT;
 
 	/* rcu_read_lock()ed by nf_hook_slow */
 	l3proto = __nf_ct_l3proto_find(pf);
@@ -1012,6 +1009,11 @@ static void nf_conntrack_attach(struct sk_buff *nskb, struct sk_buff *skb)
 
 	/* This ICMP is in reverse direction to the packet which caused it */
 	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct && ctinfo == IP_CT_UNTRACKED) {
+		nskb->nfct = NULL;
+		nskb->nfctinfo = IP_CT_UNTRACKED;
+		return;
+	}
 	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL)
 		ctinfo = IP_CT_RELATED + IP_CT_IS_REPLY;
 	else
@@ -1132,10 +1134,6 @@ static void nf_ct_release_dying_list(struct net *net)
 
 static void nf_conntrack_cleanup_init_net(void)
 {
-	/* wait until all references to nf_conntrack_untracked are dropped */
-	while (atomic_read(&nf_conntrack_untracked.ct_general.use) > 1)
-		schedule();
-
 	nf_conntrack_helper_fini();
 	nf_conntrack_proto_fini();
 }
@@ -1298,14 +1296,6 @@ static int nf_conntrack_init_init_net(void)
 	if (ret < 0)
 		goto err_helper;
 
-	/* Set up fake conntrack: to never be deleted, not in any hashes */
-#ifdef CONFIG_NET_NS
-	nf_conntrack_untracked.ct_net = &init_net;
-#endif
-	atomic_set(&nf_conntrack_untracked.ct_general.use, 1);
-	/*  - and look it like as a confirmed connection */
-	set_bit(IPS_CONFIRMED_BIT, &nf_conntrack_untracked.status);
-
 	return 0;
 
 err_helper:
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 5c103b8..67b2afd 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -457,20 +457,16 @@ ctnetlink_nlmsg_size(const struct nf_conn *ct)
 static int
 ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 {
-	struct net *net;
+	struct nf_conn *ct = item->ct;
+	struct net *net = nf_ct_net(ct);
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
 	struct nlattr *nest_parms;
-	struct nf_conn *ct = item->ct;
 	struct sk_buff *skb;
 	unsigned int type;
 	unsigned int flags = 0, group;
 	int err;
 
-	/* ignore our fake conntrack entry */
-	if (ct == &nf_conntrack_untracked)
-		return 0;
-
 	if (events & (1 << IPCT_DESTROY)) {
 		type = IPCTNL_MSG_CT_DELETE;
 		group = NFNLGRP_CONNTRACK_DESTROY;
@@ -484,7 +480,6 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 	} else
 		return 0;
 
-	net = nf_ct_net(ct);
 	if (!item->report && !nfnetlink_has_listeners(net, group))
 		return 0;
 
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 8183a05..fd5209c 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -27,9 +27,14 @@ static unsigned int xt_ct_target(struct sk_buff *skb,
 	if (skb->nfct != NULL)
 		return XT_CONTINUE;
 
-	atomic_inc(&ct->ct_general.use);
-	skb->nfct = &ct->ct_general;
-	skb->nfctinfo = IP_CT_NEW;
+	if (ct) {
+		atomic_inc(&ct->ct_general.use);
+		skb->nfct = &ct->ct_general;
+		skb->nfctinfo = IP_CT_NEW;
+	} else {
+		skb->nfct = NULL;
+		skb->nfctinfo = IP_CT_UNTRACKED;
+	}
 
 	return XT_CONTINUE;
 }
@@ -64,8 +69,7 @@ static bool xt_ct_tg_check(const struct xt_tgchk_param *par)
 		return false;
 
 	if (info->flags & XT_CT_NOTRACK) {
-		ct = &nf_conntrack_untracked;
-		atomic_inc(&ct->ct_general.use);
+		ct = NULL;
 		goto out;
 	}
 
@@ -118,14 +122,14 @@ static void xt_ct_tg_destroy(const struct xt_tgdtor_param *par)
 	struct nf_conn *ct = info->ct;
 	struct nf_conn_help *help;
 
-	if (ct != &nf_conntrack_untracked) {
+	if (ct) {
 		help = nfct_help(ct);
 		if (help)
 			module_put(help->helper->me);
 
 		nf_ct_l3proto_module_put(par->family);
+		nf_ct_put(info->ct);
 	}
-	nf_ct_put(info->ct);
 }
 
 static struct xt_target xt_ct_tg __read_mostly = {
diff --git a/net/netfilter/xt_NOTRACK.c b/net/netfilter/xt_NOTRACK.c
index e7a0a54..cc4d9cf 100644
--- a/net/netfilter/xt_NOTRACK.c
+++ b/net/netfilter/xt_NOTRACK.c
@@ -19,13 +19,12 @@ notrack_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	if (skb->nfct != NULL)
 		return XT_CONTINUE;
 
-	/* Attach fake conntrack entry.
+	/* "Attach" fake conntrack entry.
 	   If there is a real ct entry correspondig to this packet,
 	   it'll hang aroun till timing out. We don't deal with it
 	   for performance reasons. JK */
-	skb->nfct = &nf_conntrack_untracked.ct_general;
-	skb->nfctinfo = IP_CT_NEW;
-	nf_conntrack_get(skb->nfct);
+	skb->nfct = NULL;
+	skb->nfctinfo = IP_CT_UNTRACKED;
 
 	return XT_CONTINUE;
 }
diff --git a/net/netfilter/xt_cluster.c b/net/netfilter/xt_cluster.c
index 225ee3e..cf1bd98 100644
--- a/net/netfilter/xt_cluster.c
+++ b/net/netfilter/xt_cluster.c
@@ -119,9 +119,6 @@ xt_cluster_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	if (ct == NULL)
 		return false;
 
-	if (ct == &nf_conntrack_untracked)
-		return false;
-
 	if (ct->master)
 		hash = xt_cluster_hash(ct->master, info);
 	else
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index ae66305..4b9044a 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -123,7 +123,7 @@ conntrack_mt(const struct sk_buff *skb, const struct xt_match_param *par,
 
 	ct = nf_ct_get(skb, &ctinfo);
 
-	if (ct == &nf_conntrack_untracked)
+	if (!ct && ctinfo == IP_CT_UNTRACKED)
 		statebit = XT_CONNTRACK_STATE_UNTRACKED;
 	else if (ct != NULL)
 		statebit = XT_CONNTRACK_STATE_BIT(ctinfo);
diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index 6a90256..756dae8 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -127,7 +127,7 @@ socket_match(const struct sk_buff *skb, const struct xt_match_param *par,
 	 * reply packet of an established SNAT-ted connection. */
 
 	ct = nf_ct_get(skb, &ctinfo);
-	if (ct && (ct != &nf_conntrack_untracked) &&
+	if (ct &&
 	    ((iph->protocol != IPPROTO_ICMP &&
 	      ctinfo == IP_CT_IS_REPLY + IP_CT_ESTABLISHED) ||
 	     (iph->protocol == IPPROTO_ICMP &&
