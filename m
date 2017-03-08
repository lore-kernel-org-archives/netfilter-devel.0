From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/2] netfilter: remove nf_ct_is_untracked
Date: Wed,  8 Mar 2017 13:49:50 +0100
Message-ID: <20170308124950.9369-3-fw@strlen.de>
References: <20170308124950.9369-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36716 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751336AbdCHMvd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2017 07:51:33 -0500
In-Reply-To: <20170308124950.9369-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This function is now obsolete and always returns false,
change has no effect on generated code.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/ip_vs.h                       |  4 ++--
 include/net/netfilter/nf_conntrack.h      |  5 -----
 include/net/netfilter/nf_conntrack_core.h |  2 +-
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c  |  4 ----
 net/ipv4/netfilter/nf_socket_ipv4.c       |  2 +-
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c  |  4 ----
 net/netfilter/ipvs/ip_vs_ftp.c            |  2 +-
 net/netfilter/ipvs/ip_vs_nfct.c           |  4 ++--
 net/netfilter/ipvs/ip_vs_xmit.c           |  8 ++++----
 net/netfilter/nf_conntrack_netlink.c      | 12 +-----------
 net/netfilter/xt_HMARK.c                  |  2 +-
 net/netfilter/xt_cluster.c                |  3 ---
 net/netfilter/xt_connlabel.c              |  2 +-
 net/netfilter/xt_connmark.c               |  4 ++--
 net/netfilter/xt_ipvs.c                   |  2 +-
 net/openvswitch/conntrack.c               |  5 -----
 16 files changed, 17 insertions(+), 48 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 4a8ec999b62e..ef4874af1d48 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1553,7 +1553,7 @@ static inline void ip_vs_notrack(struct sk_buff *skb)
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 
-	if (!ct || !nf_ct_is_untracked(ct)) {
+	if (ct) {
 		nf_conntrack_put(&ct->ct_general);
 		nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
 	}
@@ -1614,7 +1614,7 @@ static inline bool ip_vs_conn_uses_conntrack(struct ip_vs_conn *cp,
 	if (!(cp->flags & IP_VS_CONN_F_NFCT))
 		return false;
 	ct = nf_ct_get(skb, &ctinfo);
-	if (ct && !nf_ct_is_untracked(ct))
+	if (ct)
 		return true;
 #endif
 	return false;
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 012b99f563e5..4978a82b75fa 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -273,11 +273,6 @@ static inline int nf_ct_is_dying(const struct nf_conn *ct)
 	return test_bit(IPS_DYING_BIT, &ct->status);
 }
 
-static inline int nf_ct_is_untracked(const struct nf_conn *ct)
-{
-	return false;
-}
-
 /* Packet is received from loopback */
 static inline bool nf_is_loopback_packet(const struct sk_buff *skb)
 {
diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 84ec7ca5f195..81d7f8a30945 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -65,7 +65,7 @@ static inline int nf_conntrack_confirm(struct sk_buff *skb)
 	struct nf_conn *ct = (struct nf_conn *)skb_nfct(skb);
 	int ret = NF_ACCEPT;
 
-	if (ct && !nf_ct_is_untracked(ct)) {
+	if (ct) {
 		if (!nf_ct_is_confirmed(ct))
 			ret = __nf_conntrack_confirm(skb);
 		if (likely(ret == NF_ACCEPT))
diff --git a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
index f8aad03d674b..27bb5cf70131 100644
--- a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
@@ -269,10 +269,6 @@ nf_nat_ipv4_fn(void *priv, struct sk_buff *skb,
 	if (!ct)
 		return NF_ACCEPT;
 
-	/* Don't try to NAT if this packet is not conntracked */
-	if (nf_ct_is_untracked(ct))
-		return NF_ACCEPT;
-
 	nat = nf_ct_nat_ext_add(ct);
 	if (nat == NULL)
 		return NF_ACCEPT;
diff --git a/net/ipv4/netfilter/nf_socket_ipv4.c b/net/ipv4/netfilter/nf_socket_ipv4.c
index a83d558e1aae..e9293bdebba0 100644
--- a/net/ipv4/netfilter/nf_socket_ipv4.c
+++ b/net/ipv4/netfilter/nf_socket_ipv4.c
@@ -139,7 +139,7 @@ struct sock *nf_sk_lookup_slow_v4(struct net *net, const struct sk_buff *skb,
 	 * SNAT-ted connection.
 	 */
 	ct = nf_ct_get(skb, &ctinfo);
-	if (ct && !nf_ct_is_untracked(ct) &&
+	if (ct &&
 	    ((iph->protocol != IPPROTO_ICMP &&
 	      ctinfo == IP_CT_ESTABLISHED_REPLY) ||
 	     (iph->protocol == IPPROTO_ICMP &&
diff --git a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
index e0be97e636a4..922b5aef273c 100644
--- a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
@@ -273,10 +273,6 @@ nf_nat_ipv6_fn(void *priv, struct sk_buff *skb,
 	if (!ct)
 		return NF_ACCEPT;
 
-	/* Don't try to NAT if this packet is not conntracked */
-	if (nf_ct_is_untracked(ct))
-		return NF_ACCEPT;
-
 	nat = nf_ct_nat_ext_add(ct);
 	if (nat == NULL)
 		return NF_ACCEPT;
diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
index d30c327bb578..ad539e57eef1 100644
--- a/net/netfilter/ipvs/ip_vs_ftp.c
+++ b/net/netfilter/ipvs/ip_vs_ftp.c
@@ -260,7 +260,7 @@ static int ip_vs_ftp_out(struct ip_vs_app *app, struct ip_vs_conn *cp,
 		buf_len = strlen(buf);
 
 		ct = nf_ct_get(skb, &ctinfo);
-		if (ct && !nf_ct_is_untracked(ct) && nfct_nat(ct)) {
+		if (ct && nfct_nat(ct)) {
 			/* If mangling fails this function will return 0
 			 * which will cause the packet to be dropped.
 			 * Mangling can only fail under memory pressure,
diff --git a/net/netfilter/ipvs/ip_vs_nfct.c b/net/netfilter/ipvs/ip_vs_nfct.c
index fc230d99aa3b..6cf3fd81a5ec 100644
--- a/net/netfilter/ipvs/ip_vs_nfct.c
+++ b/net/netfilter/ipvs/ip_vs_nfct.c
@@ -85,7 +85,7 @@ ip_vs_update_conntrack(struct sk_buff *skb, struct ip_vs_conn *cp, int outin)
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 	struct nf_conntrack_tuple new_tuple;
 
-	if (ct == NULL || nf_ct_is_confirmed(ct) || nf_ct_is_untracked(ct) ||
+	if (ct == NULL || nf_ct_is_confirmed(ct) ||
 	    nf_ct_is_dying(ct))
 		return;
 
@@ -232,7 +232,7 @@ void ip_vs_nfct_expect_related(struct sk_buff *skb, struct nf_conn *ct,
 {
 	struct nf_conntrack_expect *exp;
 
-	if (ct == NULL || nf_ct_is_untracked(ct))
+	if (ct == NULL)
 		return;
 
 	exp = nf_ct_expect_alloc(ct);
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 4e1a98fcc8c3..2eab1e0400f4 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -775,7 +775,7 @@ ip_vs_nat_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 		enum ip_conntrack_info ctinfo;
 		struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 
-		if (ct && !nf_ct_is_untracked(ct)) {
+		if (ct) {
 			IP_VS_DBG_RL_PKT(10, AF_INET, pp, skb, ipvsh->off,
 					 "ip_vs_nat_xmit(): "
 					 "stopping DNAT to local address");
@@ -866,7 +866,7 @@ ip_vs_nat_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 		enum ip_conntrack_info ctinfo;
 		struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 
-		if (ct && !nf_ct_is_untracked(ct)) {
+		if (ct) {
 			IP_VS_DBG_RL_PKT(10, AF_INET6, pp, skb, ipvsh->off,
 					 "ip_vs_nat_xmit_v6(): "
 					 "stopping DNAT to local address");
@@ -1338,7 +1338,7 @@ ip_vs_icmp_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 		enum ip_conntrack_info ctinfo;
 		struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 
-		if (ct && !nf_ct_is_untracked(ct)) {
+		if (ct) {
 			IP_VS_DBG(10, "%s(): "
 				  "stopping DNAT to local address %pI4\n",
 				  __func__, &cp->daddr.ip);
@@ -1429,7 +1429,7 @@ ip_vs_icmp_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 		enum ip_conntrack_info ctinfo;
 		struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 
-		if (ct && !nf_ct_is_untracked(ct)) {
+		if (ct) {
 			IP_VS_DBG(10, "%s(): "
 				  "stopping DNAT to local address %pI6\n",
 				  __func__, &cp->daddr.in6);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 6806b5e73567..29265f412039 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -627,10 +627,6 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 	unsigned int flags = 0, group;
 	int err;
 
-	/* ignore our fake conntrack entry */
-	if (nf_ct_is_untracked(ct))
-		return 0;
-
 	if (events & (1 << IPCT_DESTROY)) {
 		type = IPCTNL_MSG_CT_DELETE;
 		group = NFNLGRP_CONNTRACK_DESTROY;
@@ -2172,13 +2168,7 @@ ctnetlink_glue_build_size(const struct nf_conn *ct)
 static struct nf_conn *ctnetlink_glue_get_ct(const struct sk_buff *skb,
 					     enum ip_conntrack_info *ctinfo)
 {
-	struct nf_conn *ct;
-
-	ct = nf_ct_get(skb, ctinfo);
-	if (ct && nf_ct_is_untracked(ct))
-		ct = NULL;
-
-	return ct;
+	return nf_ct_get(skb, ctinfo);
 }
 
 static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
diff --git a/net/netfilter/xt_HMARK.c b/net/netfilter/xt_HMARK.c
index 02afaf48a729..60e6dbe12460 100644
--- a/net/netfilter/xt_HMARK.c
+++ b/net/netfilter/xt_HMARK.c
@@ -84,7 +84,7 @@ hmark_ct_set_htuple(const struct sk_buff *skb, struct hmark_tuple *t,
 	struct nf_conntrack_tuple *otuple;
 	struct nf_conntrack_tuple *rtuple;
 
-	if (ct == NULL || nf_ct_is_untracked(ct))
+	if (ct == NULL)
 		return -1;
 
 	otuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
diff --git a/net/netfilter/xt_cluster.c b/net/netfilter/xt_cluster.c
index 9a9884a39c0e..57ef175dfbfa 100644
--- a/net/netfilter/xt_cluster.c
+++ b/net/netfilter/xt_cluster.c
@@ -121,9 +121,6 @@ xt_cluster_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	if (ct == NULL)
 		return false;
 
-	if (nf_ct_is_untracked(ct))
-		return false;
-
 	if (ct->master)
 		hash = xt_cluster_hash(ct->master, info);
 	else
diff --git a/net/netfilter/xt_connlabel.c b/net/netfilter/xt_connlabel.c
index 7827128d5a95..23372879e6e3 100644
--- a/net/netfilter/xt_connlabel.c
+++ b/net/netfilter/xt_connlabel.c
@@ -29,7 +29,7 @@ connlabel_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	bool invert = info->options & XT_CONNLABEL_OP_INVERT;
 
 	ct = nf_ct_get(skb, &ctinfo);
-	if (ct == NULL || nf_ct_is_untracked(ct))
+	if (ct == NULL)
 		return invert;
 
 	labels = nf_ct_labels_find(ct);
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 9935d5029b0e..ec377cc6a369 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -44,7 +44,7 @@ connmark_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	u_int32_t newmark;
 
 	ct = nf_ct_get(skb, &ctinfo);
-	if (ct == NULL || nf_ct_is_untracked(ct))
+	if (ct == NULL)
 		return XT_CONTINUE;
 
 	switch (info->mode) {
@@ -97,7 +97,7 @@ connmark_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	const struct nf_conn *ct;
 
 	ct = nf_ct_get(skb, &ctinfo);
-	if (ct == NULL || nf_ct_is_untracked(ct))
+	if (ct == NULL)
 		return false;
 
 	return ((ct->mark & info->mask) == info->mark) ^ info->invert;
diff --git a/net/netfilter/xt_ipvs.c b/net/netfilter/xt_ipvs.c
index 0fdc89064488..42540d26c2b8 100644
--- a/net/netfilter/xt_ipvs.c
+++ b/net/netfilter/xt_ipvs.c
@@ -116,7 +116,7 @@ ipvs_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		enum ip_conntrack_info ctinfo;
 		struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 
-		if (ct == NULL || nf_ct_is_untracked(ct)) {
+		if (ct == NULL) {
 			match = false;
 			goto out_put_cp;
 		}
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 85cd59526670..23aa2a185b95 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -796,11 +796,6 @@ static int ovs_ct_nat(struct net *net, struct sw_flow_key *key,
 	enum nf_nat_manip_type maniptype;
 	int err;
 
-	if (nf_ct_is_untracked(ct)) {
-		/* A NAT action may only be performed on tracked packets. */
-		return NF_ACCEPT;
-	}
-
 	/* Add NAT extension if not confirmed yet. */
 	if (!nf_ct_is_confirmed(ct) && !nf_ct_nat_ext_add(ct))
 		return NF_ACCEPT;   /* Can't NAT. */
-- 
2.10.2

