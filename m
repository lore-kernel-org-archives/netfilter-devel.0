From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 39/64]: ctnetlink: use netlink attribute helpers
Date: Tue, 18 Dec 2007 00:47:06 +0100 (MET)
Message-ID: <20071217234706.23601.7366.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39001 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898AbXLQXrH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:07 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ctnetlink: use netlink attribute helpers

Use NLA_PUT_BE32, nla_get_be32() etc.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 94c79530c678600dc80eb1ce09df60e6b059cddd
tree 00fd8691b85bf6f35808159b7bffc2f4e35ae22a
parent 114dd2440180d6f7ffc861b75ea0b0f09441b7e2
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:26 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:57 +0100

 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   10 +--
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |   18 ++---
 net/ipv4/netfilter/nf_nat_core.c               |   12 +--
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   18 ++---
 net/netfilter/nf_conntrack_core.c              |   10 +--
 net/netfilter/nf_conntrack_netlink.c           |   87 ++++++++++--------------
 net/netfilter/nf_conntrack_proto_tcp.c         |   22 +++---
 7 files changed, 70 insertions(+), 107 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index e0e09f5..6574f00 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -363,10 +363,8 @@ getorigdst(struct sock *sk, int optval, void __user *user, int *len)
 static int ipv4_tuple_to_nlattr(struct sk_buff *skb,
 				const struct nf_conntrack_tuple *tuple)
 {
-	NLA_PUT(skb, CTA_IP_V4_SRC, sizeof(u_int32_t),
-		&tuple->src.u3.ip);
-	NLA_PUT(skb, CTA_IP_V4_DST, sizeof(u_int32_t),
-		&tuple->dst.u3.ip);
+	NLA_PUT_BE32(skb, CTA_IP_V4_SRC, tuple->src.u3.ip);
+	NLA_PUT_BE32(skb, CTA_IP_V4_DST, tuple->dst.u3.ip);
 	return 0;
 
 nla_put_failure:
@@ -384,8 +382,8 @@ static int ipv4_nlattr_to_tuple(struct nlattr *tb[],
 	if (!tb[CTA_IP_V4_SRC] || !tb[CTA_IP_V4_DST])
 		return -EINVAL;
 
-	t->src.u3.ip = *(__be32 *)nla_data(tb[CTA_IP_V4_SRC]);
-	t->dst.u3.ip = *(__be32 *)nla_data(tb[CTA_IP_V4_DST]);
+	t->src.u3.ip = nla_get_be32(tb[CTA_IP_V4_SRC]);
+	t->dst.u3.ip = nla_get_be32(tb[CTA_IP_V4_DST]);
 
 	return 0;
 }
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 4153e04..3e2e5cd 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -234,12 +234,9 @@ icmp_error(struct sk_buff *skb, unsigned int dataoff,
 static int icmp_tuple_to_nlattr(struct sk_buff *skb,
 				const struct nf_conntrack_tuple *t)
 {
-	NLA_PUT(skb, CTA_PROTO_ICMP_ID, sizeof(u_int16_t),
-		&t->src.u.icmp.id);
-	NLA_PUT(skb, CTA_PROTO_ICMP_TYPE, sizeof(u_int8_t),
-		&t->dst.u.icmp.type);
-	NLA_PUT(skb, CTA_PROTO_ICMP_CODE, sizeof(u_int8_t),
-		&t->dst.u.icmp.code);
+	NLA_PUT_BE16(skb, CTA_PROTO_ICMP_ID, t->src.u.icmp.id);
+	NLA_PUT_U8(skb, CTA_PROTO_ICMP_TYPE, t->dst.u.icmp.type);
+	NLA_PUT_U8(skb, CTA_PROTO_ICMP_CODE, t->dst.u.icmp.code);
 
 	return 0;
 
@@ -261,12 +258,9 @@ static int icmp_nlattr_to_tuple(struct nlattr *tb[],
 	    || !tb[CTA_PROTO_ICMP_ID])
 		return -EINVAL;
 
-	tuple->dst.u.icmp.type =
-			*(u_int8_t *)nla_data(tb[CTA_PROTO_ICMP_TYPE]);
-	tuple->dst.u.icmp.code =
-			*(u_int8_t *)nla_data(tb[CTA_PROTO_ICMP_CODE]);
-	tuple->src.u.icmp.id =
-			*(__be16 *)nla_data(tb[CTA_PROTO_ICMP_ID]);
+	tuple->dst.u.icmp.type = nla_get_u8(tb[CTA_PROTO_ICMP_TYPE]);
+	tuple->dst.u.icmp.code = nla_get_u8(tb[CTA_PROTO_ICMP_CODE]);
+	tuple->src.u.icmp.id = nla_get_be16(tb[CTA_PROTO_ICMP_ID]);
 
 	if (tuple->dst.u.icmp.type >= sizeof(invmap)
 	    || !invmap[tuple->dst.u.icmp.type])
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 746c2ef..4ee67e9 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -547,10 +547,8 @@ int
 nf_nat_port_range_to_nlattr(struct sk_buff *skb,
 			    const struct nf_nat_range *range)
 {
-	NLA_PUT(skb, CTA_PROTONAT_PORT_MIN, sizeof(__be16),
-		&range->min.tcp.port);
-	NLA_PUT(skb, CTA_PROTONAT_PORT_MAX, sizeof(__be16),
-		&range->max.tcp.port);
+	NLA_PUT_BE16(skb, CTA_PROTONAT_PORT_MIN, range->min.tcp.port);
+	NLA_PUT_BE16(skb, CTA_PROTONAT_PORT_MAX, range->max.tcp.port);
 
 	return 0;
 
@@ -568,8 +566,7 @@ nf_nat_port_nlattr_to_range(struct nlattr *tb[], struct nf_nat_range *range)
 
 	if (tb[CTA_PROTONAT_PORT_MIN]) {
 		ret = 1;
-		range->min.tcp.port =
-			*(__be16 *)nla_data(tb[CTA_PROTONAT_PORT_MIN]);
+		range->min.tcp.port = nla_get_be16(tb[CTA_PROTONAT_PORT_MIN]);
 	}
 
 	if (!tb[CTA_PROTONAT_PORT_MAX]) {
@@ -577,8 +574,7 @@ nf_nat_port_nlattr_to_range(struct nlattr *tb[], struct nf_nat_range *range)
 			range->max.tcp.port = range->min.tcp.port;
 	} else {
 		ret = 1;
-		range->max.tcp.port =
-			*(__be16 *)nla_data(tb[CTA_PROTONAT_PORT_MAX]);
+		range->max.tcp.port = nla_get_be16(tb[CTA_PROTONAT_PORT_MAX]);
 	}
 
 	return ret;
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index e99384f..44689d4 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -213,12 +213,9 @@ icmpv6_error(struct sk_buff *skb, unsigned int dataoff,
 static int icmpv6_tuple_to_nlattr(struct sk_buff *skb,
 				  const struct nf_conntrack_tuple *t)
 {
-	NLA_PUT(skb, CTA_PROTO_ICMPV6_ID, sizeof(u_int16_t),
-		&t->src.u.icmp.id);
-	NLA_PUT(skb, CTA_PROTO_ICMPV6_TYPE, sizeof(u_int8_t),
-		&t->dst.u.icmp.type);
-	NLA_PUT(skb, CTA_PROTO_ICMPV6_CODE, sizeof(u_int8_t),
-		&t->dst.u.icmp.code);
+	NLA_PUT_BE16(skb, CTA_PROTO_ICMPV6_ID, t->src.u.icmp.id);
+	NLA_PUT_U8(skb, CTA_PROTO_ICMPV6_TYPE, t->dst.u.icmp.type);
+	NLA_PUT_U8(skb, CTA_PROTO_ICMPV6_CODE, t->dst.u.icmp.code);
 
 	return 0;
 
@@ -240,12 +237,9 @@ static int icmpv6_nlattr_to_tuple(struct nlattr *tb[],
 	    || !tb[CTA_PROTO_ICMPV6_ID])
 		return -EINVAL;
 
-	tuple->dst.u.icmp.type =
-			*(u_int8_t *)nla_data(tb[CTA_PROTO_ICMPV6_TYPE]);
-	tuple->dst.u.icmp.code =
-			*(u_int8_t *)nla_data(tb[CTA_PROTO_ICMPV6_CODE]);
-	tuple->src.u.icmp.id =
-			*(__be16 *)nla_data(tb[CTA_PROTO_ICMPV6_ID]);
+	tuple->dst.u.icmp.type = nla_get_u8(tb[CTA_PROTO_ICMPV6_TYPE]);
+	tuple->dst.u.icmp.code = nla_get_u8(tb[CTA_PROTO_ICMPV6_CODE]);
+	tuple->src.u.icmp.id = nla_get_be16(tb[CTA_PROTO_ICMPV6_ID]);
 
 	if (tuple->dst.u.icmp.type < 128
 	    || tuple->dst.u.icmp.type - 128 >= sizeof(invmap)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 000c2fb..b63b09a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -831,10 +831,8 @@ EXPORT_SYMBOL_GPL(__nf_ct_refresh_acct);
 int nf_ct_port_tuple_to_nlattr(struct sk_buff *skb,
 			       const struct nf_conntrack_tuple *tuple)
 {
-	NLA_PUT(skb, CTA_PROTO_SRC_PORT, sizeof(u_int16_t),
-		&tuple->src.u.tcp.port);
-	NLA_PUT(skb, CTA_PROTO_DST_PORT, sizeof(u_int16_t),
-		&tuple->dst.u.tcp.port);
+	NLA_PUT_BE16(skb, CTA_PROTO_SRC_PORT, tuple->src.u.tcp.port);
+	NLA_PUT_BE16(skb, CTA_PROTO_DST_PORT, tuple->dst.u.tcp.port);
 	return 0;
 
 nla_put_failure:
@@ -854,8 +852,8 @@ int nf_ct_port_nlattr_to_tuple(struct nlattr *tb[],
 	if (!tb[CTA_PROTO_SRC_PORT] || !tb[CTA_PROTO_DST_PORT])
 		return -EINVAL;
 
-	t->src.u.tcp.port = *(__be16 *)nla_data(tb[CTA_PROTO_SRC_PORT]);
-	t->dst.u.tcp.port = *(__be16 *)nla_data(tb[CTA_PROTO_DST_PORT]);
+	t->src.u.tcp.port = nla_get_be16(tb[CTA_PROTO_SRC_PORT]);
+	t->dst.u.tcp.port = nla_get_be16(tb[CTA_PROTO_DST_PORT]);
 
 	return 0;
 }
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d4eedc6..dcd0c9a 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -59,7 +59,7 @@ ctnetlink_dump_tuples_proto(struct sk_buff *skb,
 	nest_parms = nla_nest_start(skb, CTA_TUPLE_PROTO | NLA_F_NESTED);
 	if (!nest_parms)
 		goto nla_put_failure;
-	NLA_PUT(skb, CTA_PROTO_NUM, sizeof(u_int8_t), &tuple->dst.protonum);
+	NLA_PUT_U8(skb, CTA_PROTO_NUM, tuple->dst.protonum);
 
 	if (likely(l4proto->tuple_to_nlattr))
 		ret = l4proto->tuple_to_nlattr(skb, tuple);
@@ -120,8 +120,7 @@ ctnetlink_dump_tuples(struct sk_buff *skb,
 static inline int
 ctnetlink_dump_status(struct sk_buff *skb, const struct nf_conn *ct)
 {
-	__be32 status = htonl((u_int32_t) ct->status);
-	NLA_PUT(skb, CTA_STATUS, sizeof(status), &status);
+	NLA_PUT_BE32(skb, CTA_STATUS, htonl(ct->status));
 	return 0;
 
 nla_put_failure:
@@ -131,15 +130,12 @@ nla_put_failure:
 static inline int
 ctnetlink_dump_timeout(struct sk_buff *skb, const struct nf_conn *ct)
 {
-	long timeout_l = ct->timeout.expires - jiffies;
-	__be32 timeout;
+	long timeout = (ct->timeout.expires - jiffies) / HZ;
 
-	if (timeout_l < 0)
+	if (timeout < 0)
 		timeout = 0;
-	else
-		timeout = htonl(timeout_l / HZ);
 
-	NLA_PUT(skb, CTA_TIMEOUT, sizeof(timeout), &timeout);
+	NLA_PUT_BE32(skb, CTA_TIMEOUT, htonl(timeout));
 	return 0;
 
 nla_put_failure:
@@ -193,7 +189,7 @@ ctnetlink_dump_helpinfo(struct sk_buff *skb, const struct nf_conn *ct)
 	nest_helper = nla_nest_start(skb, CTA_HELP | NLA_F_NESTED);
 	if (!nest_helper)
 		goto nla_put_failure;
-	NLA_PUT(skb, CTA_HELP_NAME, strlen(helper->name), helper->name);
+	NLA_PUT_STRING(skb, CTA_HELP_NAME, helper->name);
 
 	if (helper->to_nlattr)
 		helper->to_nlattr(skb, ct);
@@ -215,17 +211,15 @@ ctnetlink_dump_counters(struct sk_buff *skb, const struct nf_conn *ct,
 {
 	enum ctattr_type type = dir ? CTA_COUNTERS_REPLY: CTA_COUNTERS_ORIG;
 	struct nlattr *nest_count;
-	__be32 tmp;
 
 	nest_count = nla_nest_start(skb, type | NLA_F_NESTED);
 	if (!nest_count)
 		goto nla_put_failure;
 
-	tmp = htonl(ct->counters[dir].packets);
-	NLA_PUT(skb, CTA_COUNTERS32_PACKETS, sizeof(u_int32_t), &tmp);
-
-	tmp = htonl(ct->counters[dir].bytes);
-	NLA_PUT(skb, CTA_COUNTERS32_BYTES, sizeof(u_int32_t), &tmp);
+	NLA_PUT_BE32(skb, CTA_COUNTERS32_PACKETS,
+		     htonl(ct->counters[dir].packets));
+	NLA_PUT_BE32(skb, CTA_COUNTERS32_BYTES,
+		     htonl(ct->counters[dir].bytes));
 
 	nla_nest_end(skb, nest_count);
 
@@ -242,9 +236,7 @@ nla_put_failure:
 static inline int
 ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct)
 {
-	__be32 mark = htonl(ct->mark);
-
-	NLA_PUT(skb, CTA_MARK, sizeof(u_int32_t), &mark);
+	NLA_PUT_BE32(skb, CTA_MARK, htonl(ct->mark));
 	return 0;
 
 nla_put_failure:
@@ -258,9 +250,7 @@ nla_put_failure:
 static inline int
 ctnetlink_dump_secmark(struct sk_buff *skb, const struct nf_conn *ct)
 {
-	__be32 mark = htonl(ct->secmark);
-
-	NLA_PUT(skb, CTA_SECMARK, sizeof(u_int32_t), &mark);
+	NLA_PUT_BE32(skb, CTA_SECMARK, htonl(ct->secmark));
 	return 0;
 
 nla_put_failure:
@@ -297,19 +287,18 @@ nla_put_failure:
 static inline int
 dump_nat_seq_adj(struct sk_buff *skb, const struct nf_nat_seq *natseq, int type)
 {
-	__be32 tmp;
 	struct nlattr *nest_parms;
 
 	nest_parms = nla_nest_start(skb, type | NLA_F_NESTED);
 	if (!nest_parms)
 		goto nla_put_failure;
 
-	tmp = htonl(natseq->correction_pos);
-	NLA_PUT(skb, CTA_NAT_SEQ_CORRECTION_POS, sizeof(tmp), &tmp);
-	tmp = htonl(natseq->offset_before);
-	NLA_PUT(skb, CTA_NAT_SEQ_OFFSET_BEFORE, sizeof(tmp), &tmp);
-	tmp = htonl(natseq->offset_after);
-	NLA_PUT(skb, CTA_NAT_SEQ_OFFSET_AFTER, sizeof(tmp), &tmp);
+	NLA_PUT_BE32(skb, CTA_NAT_SEQ_CORRECTION_POS,
+		     htonl(natseq->correction_pos));
+	NLA_PUT_BE32(skb, CTA_NAT_SEQ_OFFSET_BEFORE,
+		     htonl(natseq->offset_before));
+	NLA_PUT_BE32(skb, CTA_NAT_SEQ_OFFSET_AFTER,
+		     htonl(natseq->offset_after));
 
 	nla_nest_end(skb, nest_parms);
 
@@ -345,8 +334,7 @@ ctnetlink_dump_nat_seq_adj(struct sk_buff *skb, const struct nf_conn *ct)
 static inline int
 ctnetlink_dump_id(struct sk_buff *skb, const struct nf_conn *ct)
 {
-	__be32 id = htonl((unsigned long)ct);
-	NLA_PUT(skb, CTA_ID, sizeof(u_int32_t), &id);
+	NLA_PUT_BE32(skb, CTA_ID, htonl((unsigned long)ct));
 	return 0;
 
 nla_put_failure:
@@ -356,9 +344,7 @@ nla_put_failure:
 static inline int
 ctnetlink_dump_use(struct sk_buff *skb, const struct nf_conn *ct)
 {
-	__be32 use = htonl(atomic_read(&ct->ct_general.use));
-
-	NLA_PUT(skb, CTA_USE, sizeof(u_int32_t), &use);
+	NLA_PUT_BE32(skb, CTA_USE, htonl(atomic_read(&ct->ct_general.use)));
 	return 0;
 
 nla_put_failure:
@@ -646,7 +632,7 @@ ctnetlink_parse_tuple_proto(struct nlattr *attr,
 
 	if (!tb[CTA_PROTO_NUM])
 		return -EINVAL;
-	tuple->dst.protonum = *(u_int8_t *)nla_data(tb[CTA_PROTO_NUM]);
+	tuple->dst.protonum = nla_get_u8(tb[CTA_PROTO_NUM]);
 
 	l4proto = nf_ct_l4proto_find_get(tuple->src.l3num, tuple->dst.protonum);
 
@@ -751,12 +737,12 @@ nfnetlink_parse_nat(struct nlattr *nat,
 		return err;
 
 	if (tb[CTA_NAT_MINIP])
-		range->min_ip = *(__be32 *)nla_data(tb[CTA_NAT_MINIP]);
+		range->min_ip = nla_get_be32(tb[CTA_NAT_MINIP]);
 
 	if (!tb[CTA_NAT_MAXIP])
 		range->max_ip = range->min_ip;
 	else
-		range->max_ip = *(__be32 *)nla_data(tb[CTA_NAT_MAXIP]);
+		range->max_ip = nla_get_be32(tb[CTA_NAT_MAXIP]);
 
 	if (range->min_ip)
 		range->flags |= IP_NAT_RANGE_MAP_IPS;
@@ -826,7 +812,7 @@ ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	ct = nf_ct_tuplehash_to_ctrack(h);
 
 	if (cda[CTA_ID]) {
-		u_int32_t id = ntohl(*(__be32 *)nla_data(cda[CTA_ID]));
+		u_int32_t id = ntohl(nla_get_be32(cda[CTA_ID]));
 		if (id != (u32)(unsigned long)ct) {
 			nf_ct_put(ct);
 			return -ENOENT;
@@ -906,7 +892,7 @@ static inline int
 ctnetlink_change_status(struct nf_conn *ct, struct nlattr *cda[])
 {
 	unsigned long d;
-	unsigned int status = ntohl(*(__be32 *)nla_data(cda[CTA_STATUS]));
+	unsigned int status = ntohl(nla_get_be32(cda[CTA_STATUS]));
 	d = ct->status ^ status;
 
 	if (d & (IPS_EXPECTED|IPS_CONFIRMED|IPS_DYING))
@@ -1008,7 +994,7 @@ ctnetlink_change_helper(struct nf_conn *ct, struct nlattr *cda[])
 static inline int
 ctnetlink_change_timeout(struct nf_conn *ct, struct nlattr *cda[])
 {
-	u_int32_t timeout = ntohl(*(__be32 *)nla_data(cda[CTA_TIMEOUT]));
+	u_int32_t timeout = ntohl(nla_get_be32(cda[CTA_TIMEOUT]));
 
 	if (!del_timer(&ct->timeout))
 		return -ETIME;
@@ -1051,19 +1037,19 @@ change_nat_seq_adj(struct nf_nat_seq *natseq, struct nlattr *attr)
 		return -EINVAL;
 
 	natseq->correction_pos =
-		ntohl(*(__be32 *)nla_data(cda[CTA_NAT_SEQ_CORRECTION_POS]));
+		ntohl(nla_get_be32(cda[CTA_NAT_SEQ_CORRECTION_POS]));
 
 	if (!cda[CTA_NAT_SEQ_OFFSET_BEFORE])
 		return -EINVAL;
 
 	natseq->offset_before =
-		ntohl(*(__be32 *)nla_data(cda[CTA_NAT_SEQ_OFFSET_BEFORE]));
+		ntohl(nla_get_be32(cda[CTA_NAT_SEQ_OFFSET_BEFORE]));
 
 	if (!cda[CTA_NAT_SEQ_OFFSET_AFTER])
 		return -EINVAL;
 
 	natseq->offset_after =
-		ntohl(*(__be32 *)nla_data(cda[CTA_NAT_SEQ_OFFSET_AFTER]));
+		ntohl(nla_get_be32(cda[CTA_NAT_SEQ_OFFSET_AFTER]));
 
 	return 0;
 }
@@ -1130,7 +1116,7 @@ ctnetlink_change_conntrack(struct nf_conn *ct, struct nlattr *cda[])
 
 #if defined(CONFIG_NF_CONNTRACK_MARK)
 	if (cda[CTA_MARK])
-		ct->mark = ntohl(*(__be32 *)nla_data(cda[CTA_MARK]));
+		ct->mark = ntohl(nla_get_be32(cda[CTA_MARK]));
 #endif
 
 #ifdef CONFIG_NF_NAT_NEEDED
@@ -1161,7 +1147,7 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 
 	if (!cda[CTA_TIMEOUT])
 		goto err;
-	ct->timeout.expires = ntohl(*(__be32 *)nla_data(cda[CTA_TIMEOUT]));
+	ct->timeout.expires = ntohl(nla_get_be32(cda[CTA_TIMEOUT]));
 
 	ct->timeout.expires = jiffies + ct->timeout.expires * HZ;
 	ct->status |= IPS_CONFIRMED;
@@ -1180,7 +1166,7 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 
 #if defined(CONFIG_NF_CONNTRACK_MARK)
 	if (cda[CTA_MARK])
-		ct->mark = ntohl(*(__be32 *)nla_data(cda[CTA_MARK]));
+		ct->mark = ntohl(nla_get_be32(cda[CTA_MARK]));
 #endif
 
 	helper = nf_ct_helper_find_get(rtuple);
@@ -1371,7 +1357,6 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 {
 	struct nf_conn *master = exp->master;
 	__be32 timeout = htonl((exp->timeout.expires - jiffies) / HZ);
-	__be32 id = htonl((unsigned long)exp);
 
 	if (ctnetlink_exp_dump_tuple(skb, &exp->tuple, CTA_EXPECT_TUPLE) < 0)
 		goto nla_put_failure;
@@ -1382,8 +1367,8 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 				 CTA_EXPECT_MASTER) < 0)
 		goto nla_put_failure;
 
-	NLA_PUT(skb, CTA_EXPECT_TIMEOUT, sizeof(timeout), &timeout);
-	NLA_PUT(skb, CTA_EXPECT_ID, sizeof(u_int32_t), &id);
+	NLA_PUT_BE32(skb, CTA_EXPECT_TIMEOUT, timeout);
+	NLA_PUT_BE32(skb, CTA_EXPECT_ID, htonl((unsigned long)exp));
 
 	return 0;
 
@@ -1556,7 +1541,7 @@ ctnetlink_get_expect(struct sock *ctnl, struct sk_buff *skb,
 		return -ENOENT;
 
 	if (cda[CTA_EXPECT_ID]) {
-		__be32 id = *(__be32 *)nla_data(cda[CTA_EXPECT_ID]);
+		__be32 id = nla_get_be32(cda[CTA_EXPECT_ID]);
 		if (ntohl(id) != (u32)(unsigned long)exp) {
 			nf_ct_expect_put(exp);
 			return -ENOENT;
@@ -1610,7 +1595,7 @@ ctnetlink_del_expect(struct sock *ctnl, struct sk_buff *skb,
 			return -ENOENT;
 
 		if (cda[CTA_EXPECT_ID]) {
-			__be32 id = *(__be32 *)nla_data(cda[CTA_EXPECT_ID]);
+			__be32 id = nla_get_be32(cda[CTA_EXPECT_ID]);
 			if (ntohl(id) != (u32)(unsigned long)exp) {
 				nf_ct_expect_put(exp);
 				return -ENOENT;
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index d96f188..600b476 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1072,14 +1072,13 @@ static int tcp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
 	if (!nest_parms)
 		goto nla_put_failure;
 
-	NLA_PUT(skb, CTA_PROTOINFO_TCP_STATE, sizeof(u_int8_t),
-		&ct->proto.tcp.state);
+	NLA_PUT_U8(skb, CTA_PROTOINFO_TCP_STATE, ct->proto.tcp.state);
 
-	NLA_PUT(skb, CTA_PROTOINFO_TCP_WSCALE_ORIGINAL, sizeof(u_int8_t),
-		&ct->proto.tcp.seen[0].td_scale);
+	NLA_PUT_U8(skb, CTA_PROTOINFO_TCP_WSCALE_ORIGINAL,
+		   ct->proto.tcp.seen[0].td_scale);
 
-	NLA_PUT(skb, CTA_PROTOINFO_TCP_WSCALE_REPLY, sizeof(u_int8_t),
-		&ct->proto.tcp.seen[1].td_scale);
+	NLA_PUT_U8(skb, CTA_PROTOINFO_TCP_WSCALE_REPLY,
+		   ct->proto.tcp.seen[1].td_scale);
 
 	tmp.flags = ct->proto.tcp.seen[0].flags;
 	NLA_PUT(skb, CTA_PROTOINFO_TCP_FLAGS_ORIGINAL,
@@ -1126,8 +1125,7 @@ static int nlattr_to_tcp(struct nlattr *cda[], struct nf_conn *ct)
 		return -EINVAL;
 
 	write_lock_bh(&tcp_lock);
-	ct->proto.tcp.state =
-		*(u_int8_t *)nla_data(tb[CTA_PROTOINFO_TCP_STATE]);
+	ct->proto.tcp.state = nla_get_u8(tb[CTA_PROTOINFO_TCP_STATE]);
 
 	if (tb[CTA_PROTOINFO_TCP_FLAGS_ORIGINAL]) {
 		struct nf_ct_tcp_flags *attr =
@@ -1147,10 +1145,10 @@ static int nlattr_to_tcp(struct nlattr *cda[], struct nf_conn *ct)
 	    tb[CTA_PROTOINFO_TCP_WSCALE_REPLY] &&
 	    ct->proto.tcp.seen[0].flags & IP_CT_TCP_FLAG_WINDOW_SCALE &&
 	    ct->proto.tcp.seen[1].flags & IP_CT_TCP_FLAG_WINDOW_SCALE) {
-		ct->proto.tcp.seen[0].td_scale = *(u_int8_t *)
-			nla_data(tb[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL]);
-		ct->proto.tcp.seen[1].td_scale = *(u_int8_t *)
-			nla_data(tb[CTA_PROTOINFO_TCP_WSCALE_REPLY]);
+		ct->proto.tcp.seen[0].td_scale =
+			nla_get_u8(tb[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL]);
+		ct->proto.tcp.seen[1].td_scale =
+			nla_get_u8(tb[CTA_PROTOINFO_TCP_WSCALE_REPLY]);
 	}
 	write_unlock_bh(&tcp_lock);
 
