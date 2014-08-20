From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: [[PATCH v3]] netfilter: nfnetlink_acct: add filter support to nfacct
 counter list/reset
Date: Wed, 20 Aug 2014 22:03:18 +0400
Message-ID: <1408557798-6455-1-git-send-email-a.perevalov@samsung.com>
References: <20140820133401.GA7422@salvia>
Cc: Alexey Perevalov <a.perevalov@samsung.com>,
	alexey.perevalov@hotmail.com, mathieu.poirier@linaro.org,
	netfilter-devel@vger.kernel.org, kyungmin.park@samsung.com,
	hs81.go@samsung.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:22612 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbaHTSDX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Aug 2014 14:03:23 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NAM006SAAAE2K80@mailout2.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Wed, 20 Aug 2014 19:06:14 +0100 (BST)
In-reply-to: <20140820133401.GA7422@salvia>
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
	Bit set for quota is't supported in this patch. NFACCT_F_QUOTA didn't
expose for user space program in public header as well. In case of
NFACCT_F_QUOTA two request is necessary, one for NFACCT_F_QUOTA_PKTS and another
one for NFACCT_F_QUOTA_BYTES.

Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
---
 include/uapi/linux/netfilter/nfnetlink_acct.h |    8 ++++
 net/netfilter/nfnetlink_acct.c                |   51 +++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/include/uapi/linux/netfilter/nfnetlink_acct.h b/include/uapi/linux/netfilter/nfnetlink_acct.h
index 51404ec..f3e34db 100644
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
+	NFACCT_FILTER_UNSPEC,
+	NFACCT_FILTER_MASK,
+	NFACCT_FILTER_VALUE,
+	__NFACCT_FILTER_MAX
+};
+#define NFACCT_FILTER_MAX (__NFACCT_FILTER_MAX - 1)
 
 #endif /* _UAPI_NFNL_ACCT_H_ */
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 3ea0eac..0f7159f 100644
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
@@ -212,6 +222,32 @@ nfnl_acct_dump(struct sk_buff *skb, struct netlink_callback *cb)
 }
 
 static int
+nfnl_acct_done(struct netlink_callback *cb)
+{
+	kfree(cb->data);
+	return 0;
+}
+
+static const struct nla_policy filter_policy[NFACCT_FILTER_MAX + 1] = {
+	[NFACCT_FILTER_MASK]	= { .type = NLA_U32 },
+	[NFACCT_FILTER_VALUE]	= { .type = NLA_U32 },
+};
+
+static struct nfacct_filter *
+nfacct_filter_alloc(struct nlattr *attrs[NFACCT_FILTER_MAX + 1])
+{
+	struct nfacct_filter *filter = kzalloc(sizeof(struct nfacct_filter),
+					       GFP_KERNEL);
+	if (!filter)
+		return ERR_PTR(-ENOMEM);
+
+	filter->mask = nla_get_be32(attrs[NFACCT_FILTER_MASK]);
+	filter->value = nla_get_be32(attrs[NFACCT_FILTER_VALUE]);
+
+	return filter;
+}
+
+static int
 nfnl_acct_get(struct sock *nfnl, struct sk_buff *skb,
 	     const struct nlmsghdr *nlh, const struct nlattr * const tb[])
 {
@@ -222,7 +258,21 @@ nfnl_acct_get(struct sock *nfnl, struct sk_buff *skb,
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.dump = nfnl_acct_dump,
+			.done = nfnl_acct_done,
 		};
+		if (tb[NFACCT_FILTER]) {
+			struct nlattr *attrs[NFACCT_FILTER_MAX + 1];
+			ret = nla_parse_nested(attrs, NFACCT_FILTER_MAX,
+					       tb[NFACCT_FILTER],
+					       filter_policy);
+			if (ret < 0)
+				return ret;
+
+			c.data = nfacct_filter_alloc(attrs);
+			if (IS_ERR(c.data))
+				return PTR_ERR(c.data);
+		}
+
 		return netlink_dump_start(nfnl, skb, nlh, &c);
 	}
 
@@ -314,6 +364,7 @@ static const struct nla_policy nfnl_acct_policy[NFACCT_MAX+1] = {
 	[NFACCT_PKTS] = { .type = NLA_U64 },
 	[NFACCT_FLAGS] = { .type = NLA_U32 },
 	[NFACCT_QUOTA] = { .type = NLA_U64 },
+	[NFACCT_FILTER] = {.type = NLA_NESTED },
 };
 
 static const struct nfnl_callback nfnl_acct_cb[NFNL_MSG_ACCT_MAX] = {
-- 
1.7.9.5

