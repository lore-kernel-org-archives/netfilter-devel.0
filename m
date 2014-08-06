From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH v2] netfilter: nfnetlink_acct: add filter support to nfacct
 counter list/reset
Date: Wed, 06 Aug 2014 14:41:02 +0400
Message-ID: <1407321662-4536-1-git-send-email-a.perevalov@samsung.com>
References: <20140805155135.GA3666@salvia>
Cc: Alexey Perevalov <a.perevalov@samsung.com>,
	alexey.perevalov@hotmail.com, mathieu.poirier@linaro.org,
	netfilter-devel@vger.kernel.org, kyungmin.park@samsung.com,
	hs81.go@samsung.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60495 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbaHFKlI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Aug 2014 06:41:08 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9V008TCSBZ8B80@mailout2.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Wed, 06 Aug 2014 11:40:47 +0100 (BST)
In-reply-to: <20140805155135.GA3666@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Filtering covers following cases:
	1. no filter specified. In this case client will get old
behaviour
	2. filter specified for getting only counters:
		in this case marks should be NFACCT_F_QUOTAS and value 0
	3. filter specified for getting quotas:
		for packet based quota mask should be
NFACCT_F_QUOTA_PKTS and value - the same,
		for byte based quota mask should be
NFACCT_F_QUOTA_BYTES and value - the same.
	Bit set for quota is't supported. NFACCT_F_QUOTA didn't expose
to user space program in public header as well. In case of NFACCT_F_QUOTA two
request is necessary, one for NFACCT_F_QUOTA_PKTS and another one for
NFACCT_F_QUOTA_BYTES.

Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
---
 include/uapi/linux/netfilter/nfnetlink_acct.h |    8 ++++
 net/netfilter/nfnetlink_acct.c                |   50 +++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/include/uapi/linux/netfilter/nfnetlink_acct.h b/include/uapi/linux/netfilter/nfnetlink_acct.h
index 51404ec..3ebc813 100644
--- a/include/uapi/linux/netfilter/nfnetlink_acct.h
+++ b/include/uapi/linux/netfilter/nfnetlink_acct.h
@@ -28,9 +28,17 @@ enum nfnl_acct_type {
 	NFACCT_USE,
 	NFACCT_FLAGS,
 	NFACCT_QUOTA,
+	NFACCT_FILTER,
 	__NFACCT_MAX
 };
 #define NFACCT_MAX (__NFACCT_MAX - 1)
 
+enum nfnl_attr_filter_type {
+	NFACCT_FILTER_ATTR_UNSPEC,
+	NFACCT_FILTER_ATTR_MASK,
+	NFACCT_FILTER_ATTR_VALUE,
+	__NFACCT_FILTER_ATTR_MAX
+};
+#define NFACCT_FILTER_ATTR_MAX (__NFACCT_FILTER_ATTR_MAX - 1)
 
 #endif /* _UAPI_NFNL_ACCT_H_ */
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 3ea0eac..94a47c4 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -40,6 +40,11 @@ struct nf_acct {
 	char			data[0];
 };
 
+struct nfacct_filter {
+	u32 value;
+	u32 mask;
+};
+
 #define NFACCT_F_QUOTA (NFACCT_F_QUOTA_PKTS | NFACCT_F_QUOTA_BYTES)
 #define NFACCT_OVERQUOTA_BIT	2	/* NFACCT_F_OVERQUOTA */
 
@@ -181,6 +186,7 @@ static int
 nfnl_acct_dump(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct nf_acct *cur, *last;
+	const struct nfacct_filter *filter = cb->data;
 
 	if (cb->args[2])
 		return 0;
@@ -197,6 +203,10 @@ nfnl_acct_dump(struct sk_buff *skb, struct netlink_callback *cb)
 
 			last = NULL;
 		}
+
+		if (filter && (cur->flags & filter->mask) != filter->value)
+			continue;
+
 		if (nfnl_acct_fill_info(skb, NETLINK_CB(cb->skb).portid,
 				       cb->nlh->nlmsg_seq,
 				       NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
@@ -212,6 +222,41 @@ nfnl_acct_dump(struct sk_buff *skb, struct netlink_callback *cb)
 }
 
 static int
+nfnl_acct_done(struct netlink_callback *cb)
+{
+	kfree(cb->data);
+	return 0;
+}
+
+static const struct nla_policy filter_policy[NFACCT_FILTER_ATTR_MAX + 1] = {
+	[NFACCT_FILTER_ATTR_MASK]	= { .type = NLA_U32 },
+	[NFACCT_FILTER_ATTR_VALUE]	= { .type = NLA_U32 },
+};
+
+static struct nfacct_filter *
+init_filter(const struct nlattr * const nla)
+{
+	struct nfacct_filter *filter = NULL;
+	struct nlattr *attrs[NFACCT_FILTER_ATTR_MAX + 1];
+
+	if (!nla)
+		return NULL;
+
+	if (nla_parse_nested(attrs, NFACCT_FILTER_ATTR_MAX,
+			nla, filter_policy) != 0)
+		return NULL;
+
+	filter = kzalloc(sizeof(struct nfacct_filter), GFP_KERNEL);
+	if (!filter)
+		return NULL;
+
+	filter->mask = nla_get_be32(attrs[NFACCT_FILTER_ATTR_MASK]);
+	filter->value = nla_get_be32(attrs[NFACCT_FILTER_ATTR_VALUE]);
+
+	return filter;
+}
+
+static int
 nfnl_acct_get(struct sock *nfnl, struct sk_buff *skb,
 	     const struct nlmsghdr *nlh, const struct nlattr * const tb[])
 {
@@ -220,9 +265,13 @@ nfnl_acct_get(struct sock *nfnl, struct sk_buff *skb,
 	char *acct_name;
 
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
+		/* using filters only for dump/list operation */
 		struct netlink_dump_control c = {
 			.dump = nfnl_acct_dump,
+			.done = nfnl_acct_done,
 		};
+		c.data = init_filter(tb[NFACCT_FILTER]);
+
 		return netlink_dump_start(nfnl, skb, nlh, &c);
 	}
 
@@ -314,6 +363,7 @@ static const struct nla_policy nfnl_acct_policy[NFACCT_MAX+1] = {
 	[NFACCT_PKTS] = { .type = NLA_U64 },
 	[NFACCT_FLAGS] = { .type = NLA_U32 },
 	[NFACCT_QUOTA] = { .type = NLA_U64 },
+	[NFACCT_FILTER] = {.type = NLA_NESTED },
 };
 
 static const struct nfnl_callback nfnl_acct_cb[NFNL_MSG_ACCT_MAX] = {
-- 
1.7.9.5

