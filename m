Return-Path: <SRS0=CFkq=5P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73BE8C43331
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Mar 2020 20:46:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36E4F20757
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Mar 2020 20:46:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgC3Uqv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Mar 2020 16:46:51 -0400
Received: from fourcot.fr ([217.70.191.14]:45918 "EHLO olfflo.fourcot.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728065AbgC3Uqv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Mar 2020 16:46:51 -0400
From:   Romain Bellan <romain.bellan@wifirst.fr>
To:     netfilter-devel@vger.kernel.org
Cc:     Romain Bellan <romain.bellan@wifirst.fr>,
        Florent Fourcot <florent.fourcot@wifirst.fr>
Subject: [PATCH nf-next v5 1/1] netfilter: ctnetlink: add kernel side filtering for dump
Date:   Mon, 30 Mar 2020 22:46:37 +0200
Message-Id: <20200330204637.11472-1-romain.bellan@wifirst.fr>
X-Mailer: git-send-email 2.11.0
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Conntrack dump does not support kernel side filtering (only get exists,
but it returns only one entry. And user has to give a full valid tuple)

It means that userspace has to implement filtering after receiving many
irrelevant entries, consuming resources (conntrack table is sometimes
very huge, much more than a routing table for example).

This patch adds filtering in kernel side. To achieve this goal, we:

 * Add a new CTA_FILTER netlink attributes, actually a flag list to
   parametize filtering
 * Convert some *nlattr_to_tuple() functions, to allow a partial parsing
   of CTA_TUPLE_ORIG and CTA_TUPLE_REPLY (so nf_conntrack_tuple it not
   fully set)

Filtering is now possible on:
 * IP SRC/DST values
 * Ports for TCP and UDP flows
 * IMCP(v6) codes types and IDs

Filtering is done as an "AND" operator. For example, when flags
PROTO_SRC_PORT, PROTO_NUM and IP_SRC are sets, only entries matching all
values are dumped.

Changes since v1:
  Set NLM_F_DUMP_FILTERED in nlm flags if entries are filtered

Changes since v2:
  Move several constants to nf_internals.h
  Move a fix on netlink values check in a separate patch
  Add a check on not-supported flags
  Return EOPNOTSUPP if CDA_FILTER is set in ctnetlink_flush_conntrack
  (not yet implemented)
  Code style issues

Changes since v3:
  Fix compilation warning reported by kbuild test robot

Changes since v4:
  Fix a regression introduced in v3 (returned EINVAL for valid netlink
  messages without CTA_MARK)

Signed-off-by: Romain Bellan <romain.bellan@wifirst.fr>
Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
---
 include/net/netfilter/nf_conntrack_l4proto.h  |   6 +-
 .../linux/netfilter/nfnetlink_conntrack.h     |   9 +
 net/netfilter/nf_conntrack_core.c             |  19 +-
 net/netfilter/nf_conntrack_netlink.c          | 341 ++++++++++++++++--
 net/netfilter/nf_conntrack_proto_icmp.c       |  43 ++-
 net/netfilter/nf_conntrack_proto_icmpv6.c     |  45 ++-
 net/netfilter/nf_internals.h                  |  16 +
 7 files changed, 406 insertions(+), 73 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 4cad1f0a327a..88186b95b3c2 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -42,7 +42,8 @@ struct nf_conntrack_l4proto {
 	/* Calculate tuple nlattr size */
 	unsigned int (*nlattr_tuple_size)(void);
 	int (*nlattr_to_tuple)(struct nlattr *tb[],
-			       struct nf_conntrack_tuple *t);
+			       struct nf_conntrack_tuple *t,
+			       u_int32_t flags);
 	const struct nla_policy *nla_policy;
 
 	struct {
@@ -152,7 +153,8 @@ const struct nf_conntrack_l4proto *nf_ct_l4proto_find(u8 l4proto);
 int nf_ct_port_tuple_to_nlattr(struct sk_buff *skb,
 			       const struct nf_conntrack_tuple *tuple);
 int nf_ct_port_nlattr_to_tuple(struct nlattr *tb[],
-			       struct nf_conntrack_tuple *t);
+			       struct nf_conntrack_tuple *t,
+			       u_int32_t flags);
 unsigned int nf_ct_port_nlattr_tuple_size(void);
 extern const struct nla_policy nf_ct_port_nla_policy[];
 
diff --git a/include/uapi/linux/netfilter/nfnetlink_conntrack.h b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
index 1d41810d17e2..262881792671 100644
--- a/include/uapi/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
@@ -55,6 +55,7 @@ enum ctattr_type {
 	CTA_LABELS,
 	CTA_LABELS_MASK,
 	CTA_SYNPROXY,
+	CTA_FILTER,
 	__CTA_MAX
 };
 #define CTA_MAX (__CTA_MAX - 1)
@@ -276,4 +277,12 @@ enum ctattr_expect_stats {
 };
 #define CTA_STATS_EXP_MAX (__CTA_STATS_EXP_MAX - 1)
 
+enum ctattr_filter {
+	CTA_FILTER_UNSPEC,
+	CTA_FILTER_ORIG_FLAGS,
+	CTA_FILTER_REPLY_FLAGS,
+	__CTA_FILTER_MAX
+};
+#define CTA_FILTER_MAX (__CTA_FILTER_MAX - 1)
+
 #endif /* _IPCONNTRACK_NETLINK_H */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index c4582eb71766..dbcabe12bb58 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1974,13 +1974,22 @@ const struct nla_policy nf_ct_port_nla_policy[CTA_PROTO_MAX+1] = {
 EXPORT_SYMBOL_GPL(nf_ct_port_nla_policy);
 
 int nf_ct_port_nlattr_to_tuple(struct nlattr *tb[],
-			       struct nf_conntrack_tuple *t)
+			       struct nf_conntrack_tuple *t,
+			       u_int32_t flags)
 {
-	if (!tb[CTA_PROTO_SRC_PORT] || !tb[CTA_PROTO_DST_PORT])
-		return -EINVAL;
+	if (flags & CTA_FILTER_FLAG(CTA_PROTO_SRC_PORT)) {
+		if (!tb[CTA_PROTO_SRC_PORT])
+			return -EINVAL;
+
+		t->src.u.tcp.port = nla_get_be16(tb[CTA_PROTO_SRC_PORT]);
+	}
 
-	t->src.u.tcp.port = nla_get_be16(tb[CTA_PROTO_SRC_PORT]);
-	t->dst.u.tcp.port = nla_get_be16(tb[CTA_PROTO_DST_PORT]);
+	if (flags & CTA_FILTER_FLAG(CTA_PROTO_DST_PORT)) {
+		if (!tb[CTA_PROTO_DST_PORT])
+			return -EINVAL;
+
+		t->dst.u.tcp.port = nla_get_be16(tb[CTA_PROTO_DST_PORT]);
+	}
 
 	return 0;
 }
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 9ddfcd002d3b..9c0364b49fc0 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -54,6 +54,8 @@
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_conntrack.h>
 
+#include "nf_internals.h"
+
 MODULE_LICENSE("GPL");
 
 static int ctnetlink_dump_tuples_proto(struct sk_buff *skb,
@@ -544,14 +546,16 @@ static int ctnetlink_dump_info(struct sk_buff *skb, struct nf_conn *ct)
 
 static int
 ctnetlink_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
-		    struct nf_conn *ct, bool extinfo)
+		    struct nf_conn *ct, bool extinfo, unsigned int flags)
 {
 	const struct nf_conntrack_zone *zone;
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
 	struct nlattr *nest_parms;
-	unsigned int flags = portid ? NLM_F_MULTI : 0, event;
+	unsigned int event;
 
+	if (portid)
+		flags |= NLM_F_MULTI;
 	event = nfnl_msg_type(NFNL_SUBSYS_CTNETLINK, IPCTNL_MSG_CT_NEW);
 	nlh = nlmsg_put(skb, portid, seq, event, sizeof(*nfmsg), flags);
 	if (nlh == NULL)
@@ -847,17 +851,72 @@ static int ctnetlink_done(struct netlink_callback *cb)
 }
 
 struct ctnetlink_filter {
+	u_int32_t cta_flags;
 	u8 family;
+
+	u_int32_t orig_flags;
+	u_int32_t reply_flags;
+
+	struct nf_conntrack_tuple orig;
+	struct nf_conntrack_tuple reply;
+	struct nf_conntrack_zone zone;
+
 	struct {
 		u_int32_t val;
 		u_int32_t mask;
 	} mark;
 };
 
+
+static const struct nla_policy cta_filter_nla_policy[CTA_FILTER_MAX + 1] = {
+	[CTA_FILTER_ORIG_FLAGS]		= { .type = NLA_U32 },
+	[CTA_FILTER_REPLY_FLAGS]	= { .type = NLA_U32 },
+};
+
+static int ctnetlink_parse_filter(const struct nlattr *attr,
+				  struct ctnetlink_filter *filter)
+{
+	struct nlattr *tb[CTA_FILTER_MAX+1];
+	int ret = 0;
+
+	ret = nla_parse_nested(tb, CTA_FILTER_MAX, attr, cta_filter_nla_policy, NULL);
+	if (ret)
+		return ret;
+
+	if (tb[CTA_FILTER_ORIG_FLAGS])
+	{
+		filter->orig_flags = nla_get_u32(tb[CTA_FILTER_ORIG_FLAGS]);
+		if (filter->orig_flags & ~(CTA_FILTER_F_ALL - 1))
+			return -EOPNOTSUPP;
+	}
+
+	if (tb[CTA_FILTER_REPLY_FLAGS])
+	{
+		filter->reply_flags = nla_get_u32(tb[CTA_FILTER_REPLY_FLAGS]);
+		if (filter->reply_flags & ~(CTA_FILTER_F_ALL - 1))
+			return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int ctnetlink_parse_zone(const struct nlattr *attr,
+				struct nf_conntrack_zone *zone);
+static int ctnetlink_parse_tuple_filter(const struct nlattr * const cda[],
+					 struct nf_conntrack_tuple *tuple,
+					 u32 type, u_int8_t l3num,
+					 struct nf_conntrack_zone *zone,
+					 u_int32_t flags);
+
+/* applied on filters */
+#define CTA_FILTER_F_CTA_MARK			(1 << 0)
+#define CTA_FILTER_F_CTA_MARK_MASK		(1 << 1)
+
 static struct ctnetlink_filter *
 ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 {
 	struct ctnetlink_filter *filter;
+	int err;
 
 #ifndef CONFIG_NF_CONNTRACK_MARK
 	if (cda[CTA_MARK] || cda[CTA_MARK_MASK])
@@ -871,14 +930,67 @@ ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 	filter->family = family;
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	if (cda[CTA_MARK] && cda[CTA_MARK_MASK]) {
+	if (cda[CTA_MARK]) {
 		filter->mark.val = ntohl(nla_get_be32(cda[CTA_MARK]));
-		filter->mark.mask = ntohl(nla_get_be32(cda[CTA_MARK_MASK]));
+		filter->cta_flags |= CTA_FILTER_FLAG(CTA_MARK);
+
+		if (cda[CTA_MARK_MASK]) {
+			filter->mark.mask = ntohl(nla_get_be32(cda[CTA_MARK_MASK]));
+			filter->cta_flags |= CTA_FILTER_FLAG(CTA_MARK_MASK);
+		}
+		else {
+			filter->mark.mask = 0xffffffff;
+		}
+	}
+	else if (cda[CTA_MARK_MASK]) {
+		return ERR_PTR(-EINVAL);
 	}
 #endif
+	if (!cda[CTA_FILTER])
+		return filter;
+
+	err = ctnetlink_parse_zone(cda[CTA_ZONE], &filter->zone);
+	if (err < 0)
+		return ERR_PTR(err);
+
+	err = ctnetlink_parse_filter(cda[CTA_FILTER], filter);
+	if (err < 0)
+		return ERR_PTR(err);
+
+	if (filter->orig_flags) {
+		if (!cda[CTA_TUPLE_ORIG])
+			return ERR_PTR(-EINVAL);
+
+		err = ctnetlink_parse_tuple_filter(cda, &filter->orig,
+						   CTA_TUPLE_ORIG,
+						   filter->family,
+						   &filter->zone,
+						   filter->orig_flags);
+		if (err < 0)
+			return ERR_PTR(err);
+	}
+
+	if (filter->reply_flags) {
+		if (!cda[CTA_TUPLE_REPLY])
+			return ERR_PTR(-EINVAL);
+
+		err = ctnetlink_parse_tuple_filter(cda, &filter->reply,
+						   CTA_TUPLE_REPLY,
+						   filter->family,
+						   &filter->zone,
+						   filter->orig_flags);
+		if (err < 0)
+			return ERR_PTR(err);
+	}
+
 	return filter;
 }
 
+static bool ctnetlink_needs_filter(u8 family, const struct nlattr * const *cda)
+{
+	return (family || cda[CTA_MARK] || cda[CTA_FILTER]);
+}
+
 static int ctnetlink_start(struct netlink_callback *cb)
 {
 	const struct nlattr * const *cda = cb->data;
@@ -886,7 +998,7 @@ static int ctnetlink_start(struct netlink_callback *cb)
 	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
 	u8 family = nfmsg->nfgen_family;
 
-	if (family || (cda[CTA_MARK] && cda[CTA_MARK_MASK])) {
+	if (ctnetlink_needs_filter(family, cda)) {
 		filter = ctnetlink_alloc_filter(cda, family);
 		if (IS_ERR(filter))
 			return PTR_ERR(filter);
@@ -896,9 +1008,82 @@ static int ctnetlink_start(struct netlink_callback *cb)
 	return 0;
 }
 
+static int ctnetlink_filter_match_tuple(struct nf_conntrack_tuple *filter_tuple,
+					struct nf_conntrack_tuple *ct_tuple,
+					u_int32_t flags, int family)
+{
+	switch (family) {
+	case NFPROTO_IPV4:
+		if (flags & CTA_FILTER_FLAG(CTA_IP_SRC) &&
+		    filter_tuple->src.u3.ip != ct_tuple->src.u3.ip)
+			return  0;
+
+		if (flags & CTA_FILTER_FLAG(CTA_IP_DST) &&
+		    filter_tuple->dst.u3.ip != ct_tuple->dst.u3.ip)
+			return  0;
+		break;
+
+	case NFPROTO_IPV6:
+		if (flags & CTA_FILTER_FLAG(CTA_IP_SRC) &&
+		    !ipv6_addr_cmp(&filter_tuple->src.u3.in6,
+				   &ct_tuple->src.u3.in6))
+			return 0;
+
+		if (flags & CTA_FILTER_FLAG(CTA_IP_DST) &&
+		    !ipv6_addr_cmp(&filter_tuple->dst.u3.in6,
+				   &ct_tuple->dst.u3.in6))
+			return 0;
+		break;
+	}
+
+	if (flags & CTA_FILTER_FLAG(CTA_PROTO_NUM) &&
+	    filter_tuple->dst.protonum != ct_tuple->dst.protonum)
+		return 0;
+
+	switch (ct_tuple->dst.protonum) {
+	case IPPROTO_TCP:
+	case IPPROTO_UDP:
+		if (flags & CTA_FILTER_FLAG(CTA_PROTO_SRC_PORT) &&
+		    filter_tuple->src.u.tcp.port != ct_tuple->src.u.tcp.port)
+			return 0;
+
+		if (flags & CTA_FILTER_FLAG(CTA_PROTO_DST_PORT) &&
+		    filter_tuple->dst.u.tcp.port != ct_tuple->dst.u.tcp.port)
+			return 0;
+		break;
+
+	case IPPROTO_ICMP:
+		if (flags & CTA_FILTER_FLAG(CTA_PROTO_ICMP_TYPE) &&
+		    filter_tuple->dst.u.icmp.type != ct_tuple->dst.u.icmp.type)
+			return 0;
+		if (flags & CTA_FILTER_FLAG(CTA_PROTO_ICMP_CODE) &&
+		    filter_tuple->dst.u.icmp.code != ct_tuple->dst.u.icmp.code)
+			return 0;
+		if (flags & CTA_FILTER_FLAG(CTA_PROTO_ICMP_ID) &&
+		    filter_tuple->src.u.icmp.id != ct_tuple->src.u.icmp.id)
+			return 0;
+		break;
+
+	case IPPROTO_ICMPV6:
+		if (flags & CTA_FILTER_FLAG(CTA_PROTO_ICMPV6_TYPE) &&
+		    filter_tuple->dst.u.icmp.type != ct_tuple->dst.u.icmp.type)
+			return 0;
+		if (flags & CTA_FILTER_FLAG(CTA_PROTO_ICMPV6_CODE) &&
+		    filter_tuple->dst.u.icmp.code != ct_tuple->dst.u.icmp.code)
+			return 0;
+		if (flags & CTA_FILTER_FLAG(CTA_PROTO_ICMPV6_ID) &&
+		    filter_tuple->src.u.icmp.id != ct_tuple->src.u.icmp.id)
+			return 0;
+		break;
+	}
+
+	return 1;
+}
+
 static int ctnetlink_filter_match(struct nf_conn *ct, void *data)
 {
 	struct ctnetlink_filter *filter = data;
+	struct nf_conntrack_tuple *tuple;
 
 	if (filter == NULL)
 		goto out;
@@ -910,8 +1095,29 @@ static int ctnetlink_filter_match(struct nf_conn *ct, void *data)
 	if (filter->family && nf_ct_l3num(ct) != filter->family)
 		goto ignore_entry;
 
+	if (filter->orig_flags) {
+		tuple = nf_ct_tuple(ct, IP_CT_DIR_ORIGINAL);
+		if (!ctnetlink_filter_match_tuple(&filter->orig, tuple,
+						  filter->orig_flags,
+						  filter->family))
+			goto ignore_entry;
+	}
+
+	if (filter->reply_flags) {
+		tuple = nf_ct_tuple(ct, IP_CT_DIR_REPLY);
+		if (!ctnetlink_filter_match_tuple(&filter->reply, tuple,
+						  filter->reply_flags,
+						  filter->family))
+			goto ignore_entry;
+	}
+
+
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	if ((ct->mark & filter->mark.mask) != filter->mark.val)
+	if ((filter->cta_flags & CTA_FILTER_FLAG(CTA_MARK_MASK)) &&
+	    (ct->mark & filter->mark.mask) != filter->mark.val)
+		goto ignore_entry;
+	else if ((filter->cta_flags & CTA_FILTER_FLAG(CTA_MARK)) &&
+		 ct->mark != filter->mark.val)
 		goto ignore_entry;
 #endif
 
@@ -930,6 +1136,7 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_node *n;
 	struct nf_conn *nf_ct_evict[8];
+	unsigned int flags = cb->data ? NLM_F_DUMP_FILTERED : 0;
 	int res, i;
 	spinlock_t *lockp;
 
@@ -979,7 +1186,7 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 			ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).portid,
 					    cb->nlh->nlmsg_seq,
 					    NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
-					    ct, true);
+					    ct, true, flags);
 			if (res < 0) {
 				nf_conntrack_get(&ct->ct_general);
 				cb->args[1] = (unsigned long)ct;
@@ -1014,31 +1221,50 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 }
 
 static int ipv4_nlattr_to_tuple(struct nlattr *tb[],
-				struct nf_conntrack_tuple *t)
+				struct nf_conntrack_tuple *t,
+				u_int32_t flags)
 {
-	if (!tb[CTA_IP_V4_SRC] || !tb[CTA_IP_V4_DST])
-		return -EINVAL;
+	if (flags & CTA_FILTER_FLAG(CTA_IP_SRC)) {
+		if (!tb[CTA_IP_V4_SRC])
+			return -EINVAL;
+
+		t->src.u3.ip = nla_get_in_addr(tb[CTA_IP_V4_SRC]);
+	}
 
-	t->src.u3.ip = nla_get_in_addr(tb[CTA_IP_V4_SRC]);
-	t->dst.u3.ip = nla_get_in_addr(tb[CTA_IP_V4_DST]);
+	if (flags & CTA_FILTER_FLAG(CTA_IP_DST)) {
+		if (!tb[CTA_IP_V4_DST])
+			return -EINVAL;
+
+		t->dst.u3.ip = nla_get_in_addr(tb[CTA_IP_V4_DST]);
+	}
 
 	return 0;
 }
 
 static int ipv6_nlattr_to_tuple(struct nlattr *tb[],
-				struct nf_conntrack_tuple *t)
+				struct nf_conntrack_tuple *t,
+				u_int32_t flags)
 {
-	if (!tb[CTA_IP_V6_SRC] || !tb[CTA_IP_V6_DST])
-		return -EINVAL;
+	if (flags & CTA_FILTER_FLAG(CTA_IP_SRC)) {
+		if (!tb[CTA_IP_V6_SRC])
+			return -EINVAL;
+
+		t->src.u3.in6 = nla_get_in6_addr(tb[CTA_IP_V6_SRC]);
+	}
 
-	t->src.u3.in6 = nla_get_in6_addr(tb[CTA_IP_V6_SRC]);
-	t->dst.u3.in6 = nla_get_in6_addr(tb[CTA_IP_V6_DST]);
+	if (flags & CTA_FILTER_FLAG(CTA_IP_DST)) {
+		if (!tb[CTA_IP_V6_DST])
+			return -EINVAL;
+
+		t->dst.u3.in6 = nla_get_in6_addr(tb[CTA_IP_V6_DST]);
+	}
 
 	return 0;
 }
 
 static int ctnetlink_parse_tuple_ip(struct nlattr *attr,
-				    struct nf_conntrack_tuple *tuple)
+				    struct nf_conntrack_tuple *tuple,
+				    u_int32_t flags)
 {
 	struct nlattr *tb[CTA_IP_MAX+1];
 	int ret = 0;
@@ -1054,10 +1280,10 @@ static int ctnetlink_parse_tuple_ip(struct nlattr *attr,
 
 	switch (tuple->src.l3num) {
 	case NFPROTO_IPV4:
-		ret = ipv4_nlattr_to_tuple(tb, tuple);
+		ret = ipv4_nlattr_to_tuple(tb, tuple, flags);
 		break;
 	case NFPROTO_IPV6:
-		ret = ipv6_nlattr_to_tuple(tb, tuple);
+		ret = ipv6_nlattr_to_tuple(tb, tuple, flags);
 		break;
 	}
 
@@ -1069,7 +1295,8 @@ static const struct nla_policy proto_nla_policy[CTA_PROTO_MAX+1] = {
 };
 
 static int ctnetlink_parse_tuple_proto(struct nlattr *attr,
-				       struct nf_conntrack_tuple *tuple)
+				       struct nf_conntrack_tuple *tuple,
+				       u_int32_t flags)
 {
 	const struct nf_conntrack_l4proto *l4proto;
 	struct nlattr *tb[CTA_PROTO_MAX+1];
@@ -1080,8 +1307,12 @@ static int ctnetlink_parse_tuple_proto(struct nlattr *attr,
 	if (ret < 0)
 		return ret;
 
+	if (!(flags & CTA_FILTER_FLAG(CTA_PROTO_NUM)))
+		return 0;
+
 	if (!tb[CTA_PROTO_NUM])
 		return -EINVAL;
+
 	tuple->dst.protonum = nla_get_u8(tb[CTA_PROTO_NUM]);
 
 	rcu_read_lock();
@@ -1092,7 +1323,7 @@ static int ctnetlink_parse_tuple_proto(struct nlattr *attr,
 						     l4proto->nla_policy,
 						     NULL);
 		if (ret == 0)
-			ret = l4proto->nlattr_to_tuple(tb, tuple);
+			ret = l4proto->nlattr_to_tuple(tb, tuple, flags);
 	}
 
 	rcu_read_unlock();
@@ -1143,10 +1374,21 @@ static const struct nla_policy tuple_nla_policy[CTA_TUPLE_MAX+1] = {
 	[CTA_TUPLE_ZONE]	= { .type = NLA_U16 },
 };
 
+#define CTA_FILTER_F_ALL_CTA_PROTO \
+  (CTA_FILTER_F_CTA_PROTO_SRC_PORT | \
+   CTA_FILTER_F_CTA_PROTO_DST_PORT | \
+   CTA_FILTER_F_CTA_PROTO_ICMP_TYPE | \
+   CTA_FILTER_F_CTA_PROTO_ICMP_CODE | \
+   CTA_FILTER_F_CTA_PROTO_ICMP_ID | \
+   CTA_FILTER_F_CTA_PROTO_ICMPV6_TYPE | \
+   CTA_FILTER_F_CTA_PROTO_ICMPV6_CODE | \
+   CTA_FILTER_F_CTA_PROTO_ICMPV6_ID)
+
 static int
-ctnetlink_parse_tuple(const struct nlattr * const cda[],
-		      struct nf_conntrack_tuple *tuple, u32 type,
-		      u_int8_t l3num, struct nf_conntrack_zone *zone)
+ctnetlink_parse_tuple_filter(const struct nlattr * const cda[],
+			      struct nf_conntrack_tuple *tuple, u32 type,
+			      u_int8_t l3num, struct nf_conntrack_zone *zone,
+			      u_int32_t flags)
 {
 	struct nlattr *tb[CTA_TUPLE_MAX+1];
 	int err;
@@ -1158,23 +1400,31 @@ ctnetlink_parse_tuple(const struct nlattr * const cda[],
 	if (err < 0)
 		return err;
 
-	if (!tb[CTA_TUPLE_IP])
-		return -EINVAL;
 
 	tuple->src.l3num = l3num;
 
-	err = ctnetlink_parse_tuple_ip(tb[CTA_TUPLE_IP], tuple);
-	if (err < 0)
-		return err;
+	if (flags & CTA_FILTER_FLAG(CTA_IP_DST) ||
+	    flags & CTA_FILTER_FLAG(CTA_IP_SRC)) {
+		if (!tb[CTA_TUPLE_IP])
+			return -EINVAL;
 
-	if (!tb[CTA_TUPLE_PROTO])
-		return -EINVAL;
+		err = ctnetlink_parse_tuple_ip(tb[CTA_TUPLE_IP], tuple, flags);
+		if (err < 0)
+			return err;
+	}
 
-	err = ctnetlink_parse_tuple_proto(tb[CTA_TUPLE_PROTO], tuple);
-	if (err < 0)
-		return err;
+	if (flags & CTA_FILTER_FLAG(CTA_PROTO_NUM)) {
+		if (!tb[CTA_TUPLE_PROTO])
+			return -EINVAL;
+		err = ctnetlink_parse_tuple_proto(tb[CTA_TUPLE_PROTO], tuple, flags);
+		if (err < 0)
+			return err;
+	} else if (flags & CTA_FILTER_FLAG(ALL_CTA_PROTO)) {
+		/* Can't manage proto flags without a protonum  */
+		return -EINVAL;
+	}
 
-	if (tb[CTA_TUPLE_ZONE]) {
+	if (flags & CTA_FILTER_FLAG(CTA_TUPLE_ZONE)) {
 		if (!zone)
 			return -EINVAL;
 
@@ -1193,6 +1443,15 @@ ctnetlink_parse_tuple(const struct nlattr * const cda[],
 	return 0;
 }
 
+static int
+ctnetlink_parse_tuple(const struct nlattr * const cda[],
+		      struct nf_conntrack_tuple *tuple, u32 type,
+		      u_int8_t l3num, struct nf_conntrack_zone *zone)
+{
+	return ctnetlink_parse_tuple_filter(cda, tuple, type, l3num, zone,
+					    CTA_FILTER_FLAG(ALL));
+}
+
 static const struct nla_policy help_nla_policy[CTA_HELP_MAX+1] = {
 	[CTA_HELP_NAME]		= { .type = NLA_NUL_STRING,
 				    .len = NF_CT_HELPER_NAME_LEN - 1 },
@@ -1240,6 +1499,7 @@ static const struct nla_policy ct_nla_policy[CTA_MAX+1] = {
 				    .len = NF_CT_LABELS_MAX_SIZE },
 	[CTA_LABELS_MASK]	= { .type = NLA_BINARY,
 				    .len = NF_CT_LABELS_MAX_SIZE },
+	[CTA_FILTER]		= { .type = NLA_NESTED },
 };
 
 static int ctnetlink_flush_iterate(struct nf_conn *ct, void *data)
@@ -1256,7 +1516,10 @@ static int ctnetlink_flush_conntrack(struct net *net,
 {
 	struct ctnetlink_filter *filter = NULL;
 
-	if (family || (cda[CTA_MARK] && cda[CTA_MARK_MASK])) {
+	if (ctnetlink_needs_filter(family, cda)) {
+		if (cda[CTA_FILTER])
+			return -EOPNOTSUPP;
+
 		filter = ctnetlink_alloc_filter(cda, family);
 		if (IS_ERR(filter))
 			return PTR_ERR(filter);
@@ -1385,7 +1648,7 @@ static int ctnetlink_get_conntrack(struct net *net, struct sock *ctnl,
 	}
 
 	err = ctnetlink_fill_info(skb2, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
-				  NFNL_MSG_TYPE(nlh->nlmsg_type), ct, true);
+				  NFNL_MSG_TYPE(nlh->nlmsg_type), ct, true, 0);
 	nf_ct_put(ct);
 	if (err <= 0)
 		goto free;
@@ -1458,7 +1721,7 @@ ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying
 			res = ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).portid,
 						  cb->nlh->nlmsg_seq,
 						  NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
-						  ct, dying ? true : false);
+						  ct, dying ? true : false, 0);
 			if (res < 0) {
 				if (!atomic_inc_not_zero(&ct->ct_general.use))
 					continue;
diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
index c2e3dff773bc..2efd9f50481e 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -20,6 +20,8 @@
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_log.h>
 
+#include "nf_internals.h"
+
 static const unsigned int nf_ct_icmp_timeout = 30*HZ;
 
 bool icmp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
@@ -271,20 +273,35 @@ static const struct nla_policy icmp_nla_policy[CTA_PROTO_MAX+1] = {
 };
 
 static int icmp_nlattr_to_tuple(struct nlattr *tb[],
-				struct nf_conntrack_tuple *tuple)
+				struct nf_conntrack_tuple *tuple,
+				u_int32_t flags)
 {
-	if (!tb[CTA_PROTO_ICMP_TYPE] ||
-	    !tb[CTA_PROTO_ICMP_CODE] ||
-	    !tb[CTA_PROTO_ICMP_ID])
-		return -EINVAL;
-
-	tuple->dst.u.icmp.type = nla_get_u8(tb[CTA_PROTO_ICMP_TYPE]);
-	tuple->dst.u.icmp.code = nla_get_u8(tb[CTA_PROTO_ICMP_CODE]);
-	tuple->src.u.icmp.id = nla_get_be16(tb[CTA_PROTO_ICMP_ID]);
-
-	if (tuple->dst.u.icmp.type >= sizeof(invmap) ||
-	    !invmap[tuple->dst.u.icmp.type])
-		return -EINVAL;
+	if (flags & CTA_FILTER_FLAG(CTA_PROTO_ICMP_TYPE)) {
+
+		if (!tb[CTA_PROTO_ICMP_TYPE])
+			return -EINVAL;
+
+		tuple->dst.u.icmp.type = nla_get_u8(tb[CTA_PROTO_ICMP_TYPE]);
+		if (tuple->dst.u.icmp.type >= sizeof(invmap) ||
+		    !invmap[tuple->dst.u.icmp.type])
+			return -EINVAL;
+	}
+
+	if (flags & CTA_FILTER_FLAG(CTA_PROTO_ICMP_CODE)) {
+
+		if (!tb[CTA_PROTO_ICMP_CODE])
+			return -EINVAL;
+
+		tuple->dst.u.icmp.code = nla_get_u8(tb[CTA_PROTO_ICMP_CODE]);
+	}
+
+	if (flags & CTA_FILTER_FLAG(CTA_PROTO_ICMP_ID)) {
+
+		if (!tb[CTA_PROTO_ICMP_ID])
+			return -EINVAL;
+
+		tuple->src.u.icmp.id = nla_get_be16(tb[CTA_PROTO_ICMP_ID]);
+	}
 
 	return 0;
 }
diff --git a/net/netfilter/nf_conntrack_proto_icmpv6.c b/net/netfilter/nf_conntrack_proto_icmpv6.c
index 6f9144e1f1c1..4a374b619421 100644
--- a/net/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/netfilter/nf_conntrack_proto_icmpv6.c
@@ -24,6 +24,8 @@
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_log.h>
 
+#include "nf_internals.h"
+
 static const unsigned int nf_ct_icmpv6_timeout = 30*HZ;
 
 bool icmpv6_pkt_to_tuple(const struct sk_buff *skb,
@@ -193,21 +195,36 @@ static const struct nla_policy icmpv6_nla_policy[CTA_PROTO_MAX+1] = {
 };
 
 static int icmpv6_nlattr_to_tuple(struct nlattr *tb[],
-				struct nf_conntrack_tuple *tuple)
+				struct nf_conntrack_tuple *tuple,
+				u_int32_t flags)
 {
-	if (!tb[CTA_PROTO_ICMPV6_TYPE] ||
-	    !tb[CTA_PROTO_ICMPV6_CODE] ||
-	    !tb[CTA_PROTO_ICMPV6_ID])
-		return -EINVAL;
-
-	tuple->dst.u.icmp.type = nla_get_u8(tb[CTA_PROTO_ICMPV6_TYPE]);
-	tuple->dst.u.icmp.code = nla_get_u8(tb[CTA_PROTO_ICMPV6_CODE]);
-	tuple->src.u.icmp.id = nla_get_be16(tb[CTA_PROTO_ICMPV6_ID]);
-
-	if (tuple->dst.u.icmp.type < 128 ||
-	    tuple->dst.u.icmp.type - 128 >= sizeof(invmap) ||
-	    !invmap[tuple->dst.u.icmp.type - 128])
-		return -EINVAL;
+	if (flags & CTA_FILTER_FLAG(CTA_PROTO_ICMPV6_TYPE)) {
+
+		if (!tb[CTA_PROTO_ICMPV6_TYPE])
+			return -EINVAL;
+
+		tuple->dst.u.icmp.type = nla_get_u8(tb[CTA_PROTO_ICMPV6_TYPE]);
+		if (tuple->dst.u.icmp.type < 128 ||
+		    tuple->dst.u.icmp.type - 128 >= sizeof(invmap) ||
+		    !invmap[tuple->dst.u.icmp.type - 128])
+			return -EINVAL;
+	}
+
+	if (flags & CTA_FILTER_FLAG(CTA_PROTO_ICMPV6_CODE)) {
+
+		if (!tb[CTA_PROTO_ICMPV6_CODE])
+			return -EINVAL;
+
+		tuple->dst.u.icmp.code = nla_get_u8(tb[CTA_PROTO_ICMPV6_CODE]);
+	}
+
+	if (flags & CTA_FILTER_FLAG(CTA_PROTO_ICMPV6_ID)) {
+
+		if (!tb[CTA_PROTO_ICMPV6_ID])
+			return -EINVAL;
+
+		tuple->src.u.icmp.id = nla_get_be16(tb[CTA_PROTO_ICMPV6_ID]);
+	}
 
 	return 0;
 }
diff --git a/net/netfilter/nf_internals.h b/net/netfilter/nf_internals.h
index d6c43902ebd7..92a406e06e13 100644
--- a/net/netfilter/nf_internals.h
+++ b/net/netfilter/nf_internals.h
@@ -6,6 +6,22 @@
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 
+/* applied on tuple filters */
+#define CTA_FILTER_F_CTA_IP_SRC			(1 << 0)
+#define CTA_FILTER_F_CTA_IP_DST			(1 << 1)
+#define CTA_FILTER_F_CTA_TUPLE_ZONE		(1 << 2)
+#define CTA_FILTER_F_CTA_PROTO_NUM		(1 << 3)
+#define CTA_FILTER_F_CTA_PROTO_SRC_PORT		(1 << 4)
+#define CTA_FILTER_F_CTA_PROTO_DST_PORT		(1 << 5)
+#define CTA_FILTER_F_CTA_PROTO_ICMP_TYPE	(1 << 6)
+#define CTA_FILTER_F_CTA_PROTO_ICMP_CODE	(1 << 7)
+#define CTA_FILTER_F_CTA_PROTO_ICMP_ID		(1 << 8)
+#define CTA_FILTER_F_CTA_PROTO_ICMPV6_TYPE	(1 << 9)
+#define CTA_FILTER_F_CTA_PROTO_ICMPV6_CODE	(1 << 10)
+#define CTA_FILTER_F_CTA_PROTO_ICMPV6_ID	(1 << 11)
+#define CTA_FILTER_F_ALL			(1 << 12)
+#define CTA_FILTER_FLAG(ctattr) CTA_FILTER_F_ ## ctattr
+
 /* nf_queue.c */
 void nf_queue_nf_hook_drop(struct net *net);
 
-- 
2.20.1

