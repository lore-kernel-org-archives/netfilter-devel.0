From: Thierry Du Tre <thierry@dtsystems.be>
Subject: [PATCH v4] netfilter : add NAT support for shifted portmap ranges
Date: Tue, 30 Jan 2018 14:02:16 +0100
Message-ID: <f0c9bd53-ab79-9df0-394f-5d612600ee21@dtsystems.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:46770 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751873AbeA3N0X (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Jan 2018 08:26:23 -0500
Received: by mail-wr0-f193.google.com with SMTP id g21so11133824wrb.13
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jan 2018 05:26:22 -0800 (PST)
Content-Language: nl
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a patch proposal to support shifted ranges in portmaps.
(i.e. tcp/udp incoming port 5000-5100 on WAN redirected to LAN 192.168.1.5:2000-2100)

Currently DNAT only works for single port or identical port ranges.
(i.e. ports 5000-5100 on WAN interface redirected to a LAN host while original destination port is not altered)
When different port ranges are configured, either 'random' mode should be used, or else all incoming connections are mapped onto the first port in the redirect range. (in described example WAN:5000-5100 will all be mapped to 192.168.1.5:2000)

This patch introduces a new mode indicated by flag NF_NAT_RANGE_PROTO_OFFSET which uses a base port value to calculate an offset with the destination port present in the incoming stream. That offset is then applied as index within the redirect port range (index modulo rangewidth to handle range overflow).

In described example the base port would be 5000. An incoming stream with destination port 5004 would result in an offset value 4 which means that the NAT'ed stream will be using destination port 2004.

Other possibilities include deterministic mapping of larger or multiple ranges to a smaller range : WAN:5000-5999 -> LAN:5000-5099 (maps WAN port 5*xx to port 51xx)

This patch does not change any current behavior. It just adds new NAT proto range functionality which must be selected via the specific flag when intended to use.

A patch for iptables (libipt_DNAT.c + libip6t_DNAT.c) will also be proposed which makes this functionality immediately available.

Signed-off-by: Thierry Du Tre <thierry@dtsystems.be>

---
Changes in v4:
    - renamed nf_nat_range1 to nf_nat_range_v1

Changes in v3:
    - use nf_nat_range as name for updated struct, renamed existing nf_nat_range to nf_nat_range1
    - reverted all nf_nat_range2 occurences

Changes in v2:
    - added new revision for SNAT and DNAT targets to support the new base port variable in struct nf_nat_range2
    - replaced all occurences of struct nf_nat_range with struct nf_nat_range2

 include/uapi/linux/netfilter/nf_nat.h | 12 ++++++-
 net/netfilter/nf_nat_core.c           |  9 +++---
 net/netfilter/nf_nat_proto_common.c   |  5 ++-
 net/netfilter/xt_nat.c                | 60 +++++++++++++++++++++++++++++++++--
 4 files changed, 78 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_nat.h b/include/uapi/linux/netfilter/nf_nat.h
index a33000d..5d919c7 100644
--- a/include/uapi/linux/netfilter/nf_nat.h
+++ b/include/uapi/linux/netfilter/nf_nat.h
@@ -10,6 +10,7 @@
 #define NF_NAT_RANGE_PROTO_RANDOM		(1 << 2)
 #define NF_NAT_RANGE_PERSISTENT			(1 << 3)
 #define NF_NAT_RANGE_PROTO_RANDOM_FULLY		(1 << 4)
+#define NF_NAT_RANGE_PROTO_OFFSET		(1 << 5)
 
 #define NF_NAT_RANGE_PROTO_RANDOM_ALL		\
 	(NF_NAT_RANGE_PROTO_RANDOM | NF_NAT_RANGE_PROTO_RANDOM_FULLY)
@@ -17,7 +18,7 @@
 #define NF_NAT_RANGE_MASK					\
 	(NF_NAT_RANGE_MAP_IPS | NF_NAT_RANGE_PROTO_SPECIFIED |	\
 	 NF_NAT_RANGE_PROTO_RANDOM | NF_NAT_RANGE_PERSISTENT |	\
-	 NF_NAT_RANGE_PROTO_RANDOM_FULLY)
+	 NF_NAT_RANGE_PROTO_RANDOM_FULLY | NF_NAT_RANGE_PROTO_OFFSET)
 
 struct nf_nat_ipv4_range {
 	unsigned int			flags;
@@ -32,12 +33,21 @@ struct nf_nat_ipv4_multi_range_compat {
 	struct nf_nat_ipv4_range	range[1];
 };
 
+struct nf_nat_range_v1 {
+	unsigned int			flags;
+	union nf_inet_addr		min_addr;
+	union nf_inet_addr		max_addr;
+	union nf_conntrack_man_proto	min_proto;
+	union nf_conntrack_man_proto	max_proto;
+};
+
 struct nf_nat_range {
 	unsigned int			flags;
 	union nf_inet_addr		min_addr;
 	union nf_inet_addr		max_addr;
 	union nf_conntrack_man_proto	min_proto;
 	union nf_conntrack_man_proto	max_proto;
+	union nf_conntrack_man_proto	base_proto;
 };
 
 #endif /* _NETFILTER_NF_NAT_H */
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index af8345f..de5c327 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -347,9 +347,10 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 	/* Only bother mapping if it's not already in range and unique */
 	if (!(range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL)) {
 		if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
-			if (l4proto->in_range(tuple, maniptype,
-					      &range->min_proto,
-					      &range->max_proto) &&
+			if (!(range->flags & NF_NAT_RANGE_PROTO_OFFSET) &&
+			    l4proto->in_range(tuple, maniptype,
+			          &range->min_proto,
+			          &range->max_proto) &&
 			    (range->min_proto.all == range->max_proto.all ||
 			     !nf_nat_used_tuple(tuple, ct)))
 				goto out;
@@ -358,7 +359,7 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 		}
 	}
 
-	/* Last change: get protocol to try to obtain unique tuple. */
+	/* Last chance: get protocol to try to obtain unique tuple. */
 	l4proto->unique_tuple(l3proto, tuple, range, maniptype, ct);
 out:
 	rcu_read_unlock();
diff --git a/net/netfilter/nf_nat_proto_common.c b/net/netfilter/nf_nat_proto_common.c
index fbce552..2c30eca 100644
--- a/net/netfilter/nf_nat_proto_common.c
+++ b/net/netfilter/nf_nat_proto_common.c
@@ -80,6 +80,8 @@ void nf_nat_l4proto_unique_tuple(const struct nf_nat_l3proto *l3proto,
 						  : tuple->src.u.all);
 	} else if (range->flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY) {
 		off = prandom_u32();
+	} else if (range->flags & NF_NAT_RANGE_PROTO_OFFSET) {
+		off = (ntohs(*portptr) - ntohs(range->base_proto.all));
 	} else {
 		off = *rover;
 	}
@@ -88,7 +90,8 @@ void nf_nat_l4proto_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		*portptr = htons(min + off % range_size);
 		if (++i != range_size && nf_nat_used_tuple(tuple, ct))
 			continue;
-		if (!(range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL))
+		if (!(range->flags & (NF_NAT_RANGE_PROTO_RANDOM_ALL|
+					NF_NAT_RANGE_PROTO_OFFSET)))
 			*rover = off;
 		return;
 	}
diff --git a/net/netfilter/xt_nat.c b/net/netfilter/xt_nat.c
index 0fd14d1..cff9a67 100644
--- a/net/netfilter/xt_nat.c
+++ b/net/netfilter/xt_nat.c
@@ -41,6 +41,7 @@ static void xt_nat_convert_range(struct nf_nat_range *dst,
 {
 	memset(&dst->min_addr, 0, sizeof(dst->min_addr));
 	memset(&dst->max_addr, 0, sizeof(dst->max_addr));
+	memset(&dst->base_proto, 0, sizeof(dst->base_proto));
 
 	dst->flags	 = src->flags;
 	dst->min_addr.ip = src->min_ip;
@@ -85,6 +86,39 @@ xt_dnat_target_v0(struct sk_buff *skb, const struct xt_action_param *par)
 static unsigned int
 xt_snat_target_v1(struct sk_buff *skb, const struct xt_action_param *par)
 {
+	const struct nf_nat_range_v1 *range_v1 = par->targinfo;
+	struct nf_nat_range range = {};
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	WARN_ON(!(ct != NULL &&
+		 (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
+		  ctinfo == IP_CT_RELATED_REPLY)));
+
+	memcpy(&range, range_v1, sizeof(*range_v1));
+	return nf_nat_setup_info(ct, &range, NF_NAT_MANIP_SRC);
+}
+
+static unsigned int
+xt_dnat_target_v1(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct nf_nat_range_v1 *range_v1 = par->targinfo;
+	struct nf_nat_range range = {};
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	WARN_ON(!(ct != NULL &&
+		 (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED)));
+
+	memcpy(&range, range_v1, sizeof(*range_v1));
+	return nf_nat_setup_info(ct, &range, NF_NAT_MANIP_DST);
+}
+
+static unsigned int
+xt_snat_target_v2(struct sk_buff *skb, const struct xt_action_param *par)
+{
 	const struct nf_nat_range *range = par->targinfo;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct;
@@ -98,7 +132,7 @@ xt_snat_target_v1(struct sk_buff *skb, const struct xt_action_param *par)
 }
 
 static unsigned int
-xt_dnat_target_v1(struct sk_buff *skb, const struct xt_action_param *par)
+xt_dnat_target_v2(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct nf_nat_range *range = par->targinfo;
 	enum ip_conntrack_info ctinfo;
@@ -144,7 +178,7 @@ static struct xt_target xt_nat_target_reg[] __read_mostly = {
 		.checkentry	= xt_nat_checkentry,
 		.destroy	= xt_nat_destroy,
 		.target		= xt_snat_target_v1,
-		.targetsize	= sizeof(struct nf_nat_range),
+		.targetsize	= sizeof(struct nf_nat_range_v1),
 		.table		= "nat",
 		.hooks		= (1 << NF_INET_POST_ROUTING) |
 				  (1 << NF_INET_LOCAL_IN),
@@ -156,6 +190,28 @@ static struct xt_target xt_nat_target_reg[] __read_mostly = {
 		.checkentry	= xt_nat_checkentry,
 		.destroy	= xt_nat_destroy,
 		.target		= xt_dnat_target_v1,
+		.targetsize	= sizeof(struct nf_nat_range_v1),
+		.table		= "nat",
+		.hooks		= (1 << NF_INET_PRE_ROUTING) |
+				  (1 << NF_INET_LOCAL_OUT),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "SNAT",
+		.revision	= 2,
+		.checkentry	= xt_nat_checkentry,
+		.destroy	= xt_nat_destroy,
+		.target		= xt_snat_target_v2,
+		.targetsize	= sizeof(struct nf_nat_range),
+		.table		= "nat",
+		.hooks		= (1 << NF_INET_POST_ROUTING) |
+				  (1 << NF_INET_LOCAL_IN),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "DNAT",
+		.revision	= 2,
+		.target		= xt_dnat_target_v2,
 		.targetsize	= sizeof(struct nf_nat_range),
 		.table		= "nat",
 		.hooks		= (1 << NF_INET_PRE_ROUTING) |
-- 
2.7.4
