From: Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH nf-next v3 3/3] netfilter: nf_conntrack: add efficient mark to zone mapping
Date: Wed, 22 Jul 2015 12:54:48 +0200
Message-ID: <08281d65fcc8f2a3249a542cf5071cdbc10cf8d2.1437561897.git.daniel@iogearbox.net>
References: <cover.1437561897.git.daniel@iogearbox.net>
Cc: tgraf@suug.ch, challa@noironetworks.com,
	netfilter-devel@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:41631 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933779AbbGVKyy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jul 2015 06:54:54 -0400
In-Reply-To: <cover.1437561897.git.daniel@iogearbox.net>
In-Reply-To: <cover.1437561897.git.daniel@iogearbox.net>
References: <cover.1437561897.git.daniel@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This work adds the possibility of deriving the zone id from the skb->mark
field in a scalable manner. This allows for having only a single template
serving hundreds/thousands of different zones, for example, instead of the
need to have one match for each zone as an extra CT jump target.

Note that we'd need to have this information attached to the template as at
the time when we're trying to lookup a possible ct object, we already need
to know zone information for a possible match when going into
__nf_conntrack_find_get(). This work provides a minimal implementation for
a possible mapping.

In order to not add/expose an extra ct->status bit, the zone structure has
been extended to carry a flag for deriving the mark.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 include/net/netfilter/nf_conntrack_zones.h     | 29 +++++++++++++++++++++++---
 include/uapi/linux/netfilter/xt_CT.h           |  4 +++-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |  3 ++-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |  4 +++-
 net/netfilter/nf_conntrack_core.c              | 10 +++++----
 net/netfilter/nf_conntrack_netlink.c           |  1 +
 net/netfilter/xt_CT.c                          |  9 ++++++--
 7 files changed, 48 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_zones.h b/include/net/netfilter/nf_conntrack_zones.h
index bef0539..4ab835f6 100644
--- a/include/net/netfilter/nf_conntrack_zones.h
+++ b/include/net/netfilter/nf_conntrack_zones.h
@@ -9,9 +9,12 @@
 #define NF_CT_REPL_DIR		(1 << IP_CT_DIR_REPLY)
 #define NF_CT_DEFAULT_DIR	(NF_CT_ORIG_DIR | NF_CT_REPL_DIR)
 
+#define NF_CT_FLAG_MARK		1
+
 struct nf_conntrack_zone {
 	u16	id;
-	u16	dir;
+	u8	flags;
+	u8	dir;
 };
 
 extern const struct nf_conntrack_zone nf_ct_zone_dflt;
@@ -31,9 +34,29 @@ nf_ct_zone(const struct nf_conn *ct)
 }
 
 static inline const struct nf_conntrack_zone *
-nf_ct_zone_tmpl(const struct nf_conn *tmpl)
+nf_ct_zone_init(struct nf_conntrack_zone *zone, u16 id, u8 dir, u8 flags)
 {
-	return tmpl ? nf_ct_zone(tmpl) : &nf_ct_zone_dflt;
+	zone->id = id;
+	zone->flags = flags;
+	zone->dir = dir;
+
+	return zone;
+}
+
+static inline const struct nf_conntrack_zone *
+nf_ct_zone_tmpl(const struct nf_conn *tmpl, const struct sk_buff *skb,
+		struct nf_conntrack_zone *tmp)
+{
+	const struct nf_conntrack_zone *zone;
+
+	if (!tmpl)
+		return &nf_ct_zone_dflt;
+
+	zone = nf_ct_zone(tmpl);
+	if (zone->flags & NF_CT_FLAG_MARK)
+		zone = nf_ct_zone_init(tmp, skb->mark, zone->dir, 0);
+
+	return zone;
 }
 
 static inline bool nf_ct_zone_matches_dir(const struct nf_conntrack_zone *zone,
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
index 8a2f41c..cdde3ec 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -135,9 +135,10 @@ icmp_error_message(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
 	const struct nf_conntrack_l4proto *innerproto;
 	const struct nf_conntrack_tuple_hash *h;
 	const struct nf_conntrack_zone *zone;
+	struct nf_conntrack_zone tmp;
 
 	NF_CT_ASSERT(skb->nfct == NULL);
-	zone = nf_ct_zone_tmpl(tmpl);
+	zone = nf_ct_zone_tmpl(tmpl, skb, &tmp);
 
 	/* Are they talking about one of our connections? */
 	if (!nf_ct_get_tuplepr(skb,
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 2029141..0e6fae1 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -150,6 +150,7 @@ icmpv6_error_message(struct net *net, struct nf_conn *tmpl,
 	struct nf_conntrack_tuple intuple, origtuple;
 	const struct nf_conntrack_tuple_hash *h;
 	const struct nf_conntrack_l4proto *inproto;
+	struct nf_conntrack_zone tmp;
 
 	NF_CT_ASSERT(skb->nfct == NULL);
 
@@ -176,7 +177,8 @@ icmpv6_error_message(struct net *net, struct nf_conn *tmpl,
 
 	*ctinfo = IP_CT_RELATED;
 
-	h = nf_conntrack_find_get(net, nf_ct_zone_tmpl(tmpl), &intuple);
+	h = nf_conntrack_find_get(net, nf_ct_zone_tmpl(tmpl, skb, &tmp),
+				  &intuple);
 	if (!h) {
 		pr_debug("icmpv6_error: no match\n");
 		return -NF_ACCEPT;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 8f8e842..e0ef80a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -849,8 +849,8 @@ __nf_conntrack_alloc(struct net *net,
 		nf_ct_zone = nf_ct_ext_add(ct, NF_CT_EXT_ZONE, GFP_ATOMIC);
 		if (!nf_ct_zone)
 			goto out_free;
-		nf_ct_zone->id = zone->id;
-		nf_ct_zone->dir = zone->dir;
+
+		nf_ct_zone_init(nf_ct_zone, zone->id, zone->dir, zone->flags);
 	}
 #endif
 	/* Because we use RCU lookups, we set ct_general.use to zero before
@@ -912,6 +912,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 	struct nf_conntrack_expect *exp = NULL;
 	const struct nf_conntrack_zone *zone;
 	struct nf_conn_timeout *timeout_ext;
+	struct nf_conntrack_zone tmp;
 	unsigned int *timeouts;
 
 	if (!nf_ct_invert_tuple(&repl_tuple, tuple, l3proto, l4proto)) {
@@ -919,7 +920,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 		return NULL;
 	}
 
-	zone = nf_ct_zone_tmpl(tmpl);
+	zone = nf_ct_zone_tmpl(tmpl, skb, &tmp);
 	ct = __nf_conntrack_alloc(net, zone, tuple, &repl_tuple, GFP_ATOMIC,
 				  hash);
 	if (IS_ERR(ct))
@@ -1017,6 +1018,7 @@ resolve_normal_ct(struct net *net, struct nf_conn *tmpl,
 	const struct nf_conntrack_zone *zone;
 	struct nf_conntrack_tuple tuple;
 	struct nf_conntrack_tuple_hash *h;
+	struct nf_conntrack_zone tmp;
 	struct nf_conn *ct;
 	u32 hash;
 
@@ -1028,7 +1030,7 @@ resolve_normal_ct(struct net *net, struct nf_conn *tmpl,
 	}
 
 	/* look for tuple match */
-	zone = nf_ct_zone_tmpl(tmpl);
+	zone = nf_ct_zone_tmpl(tmpl, skb, &tmp);
 	hash = hash_conntrack_raw(&tuple);
 	h = __nf_conntrack_find_get(net, zone, &tuple, hash);
 	if (!h) {
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 0d389ec..b53d425 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1008,6 +1008,7 @@ ctnetlink_parse_zone(const struct nlattr *zattr,
 {
 	zone->id = NF_CT_DEFAULT_ZONE_ID;
 	zone->dir = NF_CT_DEFAULT_DIR;
+	zone->flags = 0;
 
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 	if (zattr)
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 8646075..df4e9ad 100644
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
 
@@ -217,8 +218,12 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 		goto err1;
 
 	memset(&t, 0, sizeof(t));
+
 	zone.id = info->zone;
 	zone.dir = xt_ct_flags_to_dir(info);
+	zone.flags = 0;
+	if (info->flags & XT_CT_ZONE_MARK)
+		zone.flags |= NF_CT_FLAG_MARK;
 
 	ct = nf_conntrack_alloc(par->net, &zone, &t, &t, GFP_KERNEL);
 	ret = PTR_ERR(ct);
-- 
1.9.3

