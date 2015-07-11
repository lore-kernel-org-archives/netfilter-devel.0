From: Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH nf-next v2 3/3] netfilter: nf_conntrack: add efficient mark to zone mapping
Date: Sat, 11 Jul 2015 03:14:07 +0200
Message-ID: <8b1e8907e8dd9a51f2e40b39cd5f5c2b0eae94fd.1436574843.git.daniel@iogearbox.net>
References: <cover.1436574843.git.daniel@iogearbox.net>
Cc: tgraf@suug.ch, challa@noironetworks.com,
	netfilter-devel@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:41800 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbbGKGNp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Jul 2015 02:13:45 -0400
In-Reply-To: <cover.1436574843.git.daniel@iogearbox.net>
In-Reply-To: <cover.1436574843.git.daniel@iogearbox.net>
References: <cover.1436574843.git.daniel@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This work adds the possibility of deriving the zone id from the skb->mark
field in a scalable manner. This allows for having only a single template
serving 100s .. 1000s of different zones, for example, instead of needing
to have one match for each zone as an extra CT jump target. Note that we'd
need to have this information attached to the template as at the time when
we're trying to lookup a possible ct object, we already need to know zone
information for a possible match when going into __nf_conntrack_find_get().
This work provides a minimal implementation for a possible mapping.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 include/net/netfilter/nf_conntrack_zones.h         | 14 ++++++++++++--
 include/uapi/linux/netfilter/nf_conntrack_common.h |  4 ++++
 include/uapi/linux/netfilter/xt_CT.h               |  4 +++-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c       |  2 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c     |  3 ++-
 net/netfilter/nf_conntrack_core.c                  |  4 ++--
 net/netfilter/xt_CT.c                              |  8 ++++++--
 7 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_zones.h b/include/net/netfilter/nf_conntrack_zones.h
index 9e1351b..52242fb 100644
--- a/include/net/netfilter/nf_conntrack_zones.h
+++ b/include/net/netfilter/nf_conntrack_zones.h
@@ -48,9 +48,19 @@ nf_ct_zone(const struct nf_conn *ct, struct nf_conntrack_zone *ptr)
 }
 
 static inline struct nf_conntrack_zone *
-nf_ct_zone_tmpl(const struct nf_conn *tmpl, struct nf_conntrack_zone *ptr)
+nf_ct_zone_tmpl(const struct nf_conn *tmpl, const struct sk_buff *skb,
+		struct nf_conntrack_zone *ptr)
 {
-	return tmpl ? nf_ct_zone(tmpl, ptr) : nf_ct_zone_dflt(ptr);
+	struct nf_conntrack_zone *zone;
+
+	if (!tmpl)
+		return nf_ct_zone_dflt(ptr);
+
+	zone = nf_ct_zone(tmpl, ptr);
+	if (tmpl->status & IPS_TEMPLATE_MARK)
+		zone->id = skb->mark;
+
+	return zone;
 }
 
 static inline bool nf_ct_zone_matches_dir(const struct nf_conntrack_zone *zone,
diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
index 319f471..918c6bd 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
@@ -91,6 +91,10 @@ enum ip_conntrack_status {
 	/* Conntrack got a helper explicitly attached via CT target. */
 	IPS_HELPER_BIT = 13,
 	IPS_HELPER = (1 << IPS_HELPER_BIT),
+
+	/* Template is marked dynamically. */
+	IPS_TEMPLATE_MARK_BIT = 14,
+	IPS_TEMPLATE_MARK = (1 << IPS_TEMPLATE_MARK_BIT),
 };
 
 /* Connection tracking event types */
diff --git a/include/uapi/linux/netfilter/xt_CT.h b/include/uapi/linux/netfilter/xt_CT.h
index 452005f..9e52041 100644
--- a/include/uapi/linux/netfilter/xt_CT.h
+++ b/include/uapi/linux/netfilter/xt_CT.h
@@ -8,9 +8,11 @@ enum {
 	XT_CT_NOTRACK_ALIAS	= 1 << 1,
 	XT_CT_ZONE_DIR_ORIG	= 1 << 2,
 	XT_CT_ZONE_DIR_REPL	= 1 << 3,
+	XT_CT_ZONE_MARK		= 1 << 4,
 
 	XT_CT_MASK		= XT_CT_NOTRACK | XT_CT_NOTRACK_ALIAS |
-				  XT_CT_ZONE_DIR_ORIG | XT_CT_ZONE_DIR_REPL,
+				  XT_CT_ZONE_DIR_ORIG | XT_CT_ZONE_DIR_REPL |
+				  XT_CT_ZONE_MARK,
 };
 
 struct xt_ct_target_info {
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 75f7860..0ddd915 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -137,7 +137,7 @@ icmp_error_message(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
 	struct nf_conntrack_zone *zone, __zone;
 
 	NF_CT_ASSERT(skb->nfct == NULL);
-	zone = nf_ct_zone_tmpl(tmpl, &__zone);
+	zone = nf_ct_zone_tmpl(tmpl, skb, &__zone);
 
 	/* Are they talking about one of our connections? */
 	if (!nf_ct_get_tuplepr(skb,
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index d5ad71f..1c9a4c7 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -177,7 +177,8 @@ icmpv6_error_message(struct net *net, struct nf_conn *tmpl,
 
 	*ctinfo = IP_CT_RELATED;
 
-	h = nf_conntrack_find_get(net, nf_ct_zone_tmpl(tmpl, &zone), &intuple);
+	h = nf_conntrack_find_get(net, nf_ct_zone_tmpl(tmpl, skb, &zone),
+				  &intuple);
 	if (!h) {
 		pr_debug("icmpv6_error: no match\n");
 		return -NF_ACCEPT;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index cf7c15a..7d89529 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -919,7 +919,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 		return NULL;
 	}
 
-	zone = nf_ct_zone_tmpl(tmpl, &__zone);
+	zone = nf_ct_zone_tmpl(tmpl, skb, &__zone);
 	ct = __nf_conntrack_alloc(net, zone, tuple, &repl_tuple, GFP_ATOMIC,
 				  hash);
 	if (IS_ERR(ct))
@@ -1028,7 +1028,7 @@ resolve_normal_ct(struct net *net, struct nf_conn *tmpl,
 	}
 
 	/* look for tuple match */
-	zone = nf_ct_zone_tmpl(tmpl, &__zone);
+	zone = nf_ct_zone_tmpl(tmpl, skb, &__zone);
 	hash = hash_conntrack_raw(&tuple);
 	h = __nf_conntrack_find_get(net, zone, &tuple, hash);
 	if (!h) {
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 8646075..f92cbe9 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -20,6 +20,8 @@
 #include <net/netfilter/nf_conntrack_timeout.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 
+#define XT_CT_ZONE_FLAGS (XT_CT_ZONE_DIR_ORIG | XT_CT_ZONE_DIR_REPL | XT_CT_ZONE_MARK)
+
 static inline int xt_ct_target(struct sk_buff *skb, struct nf_conn *ct)
 {
 	/* Previously seen (loopback)? Ignore. */
@@ -207,8 +209,7 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 	}
 
 #ifndef CONFIG_NF_CONNTRACK_ZONES
-	if (info->zone || info->flags & (XT_CT_ZONE_DIR_ORIG |
-					 XT_CT_ZONE_DIR_REPL))
+	if (info->zone || info->flags & XT_CT_ZONE_FLAGS)
 		goto err1;
 #endif
 
@@ -225,6 +226,9 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 	if (IS_ERR(ct))
 		goto err2;
 
+	if (info->flags & XT_CT_ZONE_MARK)
+		ct->status |= IPS_TEMPLATE_MARK;
+
 	ret = 0;
 	if ((info->ct_events || info->exp_events) &&
 	    !nf_ct_ecache_ext_add(ct, info->ct_events, info->exp_events,
-- 
1.9.3

