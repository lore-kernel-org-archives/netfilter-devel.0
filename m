From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH] netfilter: nfnetlink_acct: add filter support to nfacct
 counter list/reset
Date: Mon, 04 Aug 2014 19:52:28 +0400
Message-ID: <1407167548-2883-2-git-send-email-a.perevalov@samsung.com>
References: <1407167548-2883-1-git-send-email-a.perevalov@samsung.com>
Cc: Alexey Perevalov <a.perevalov@samsung.com>,
	alexey.perevalov@hotmail.com, mathieu.poirier@linaro.org,
	netfilter-devel@vger.kernel.org, kyungmin.park@samsung.com,
	hs81.go@samsung.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:41458 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaHDPww (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Aug 2014 11:52:52 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9S00GBNHG0XE90@mailout3.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Mon, 04 Aug 2014 16:52:48 +0100 (BST)
In-reply-to: <1407167548-2883-1-git-send-email-a.perevalov@samsung.com>
In-reply-to: <20140729163208.GA3739@salvia>
References: <20140729163208.GA3739@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Filtering covers following cases:
	1. no filter specified. In this case client will get old
behaviour
	2. filter is specified for getting just counters:
		in this case mask should be NFACCT_F_QUOTAS and value 0
	3. filter is specified for getting quotas:
		for packet based quota mask should be
NFACCT_F_QUOTA_PKTS and value - the same as mask,
		for byte based quota mask should be
NFACCT_F_QUOTA_BYTES and value - the same as mask.
	There is no support for listening/reseting quota of any available type
per one request. In case of NFACCT_F_QUOTA two list/reset request is necessary.

Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
---
 include/uapi/linux/netfilter/nfnetlink_acct.h |   12 +++++
 net/netfilter/Kconfig                         |    9 ++++
 net/netfilter/nfnetlink_acct.c                |   61 +++++++++++++++++++++++++
 3 files changed, 82 insertions(+)

diff --git a/include/uapi/linux/netfilter/nfnetlink_acct.h b/include/uapi/linux/netfilter/nfnetlink_acct.h
index 51404ec..1683edb 100644
--- a/include/uapi/linux/netfilter/nfnetlink_acct.h
+++ b/include/uapi/linux/netfilter/nfnetlink_acct.h
@@ -28,9 +28,21 @@ enum nfnl_acct_type {
 	NFACCT_USE,
 	NFACCT_FLAGS,
 	NFACCT_QUOTA,
+#ifdef CONFIG_NF_ACCT_FILTER
+	NFACCT_FILTER,
+#endif
 	__NFACCT_MAX
 };
 #define NFACCT_MAX (__NFACCT_MAX - 1)
 
+#ifdef CONFIG_NF_ACCT_FILTER
+enum nfnl_attr_filter_type {
+	NFACCT_FILTER_ATTR_UNSPEC,
+	NFACCT_FILTER_ATTR_MASK,
+	NFACCT_FILTER_ATTR_VALUE,
+	__NFACCT_FILTER_ATTR_MAX
+};
+#define NFACCT_FILTER_ATTR_MAX (__NFACCT_FILTER_ATTR_MAX - 1)
+#endif /* CONFIG_NF_ACCT_FILTER */
 
 #endif /* _UAPI_NFNL_ACCT_H_ */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index ad751fe..8e3f882 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -12,6 +12,15 @@ tristate "Netfilter NFACCT over NFNETLINK interface"
 	  If this option is enabled, the kernel will include support
 	  for extended accounting via NFNETLINK.
 
+if NETFILTER_NETLINK_ACCT
+config NF_ACCT_FILTER
+	bool  'Filter support for nfacct netlink protocol'
+	depends on NETFILTER_ADVANCED
+	help
+	 If this option is enabled, nfacct framework will be able to list
+	 counters by filter.
+endif
+
 config NETFILTER_NETLINK_QUEUE
 	tristate "Netfilter NFQUEUE over NFNETLINK interface"
 	depends on NETFILTER_ADVANCED
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 3ea0eac..53293a4 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -40,6 +40,13 @@ struct nf_acct {
 	char			data[0];
 };
 
+#ifdef CONFIG_NF_ACCT_FILTER
+struct nfacct_filter {
+	u32 value;
+	u32 mask;
+};
+#endif
+
 #define NFACCT_F_QUOTA (NFACCT_F_QUOTA_PKTS | NFACCT_F_QUOTA_BYTES)
 #define NFACCT_OVERQUOTA_BIT	2	/* NFACCT_F_OVERQUOTA */
 
@@ -181,6 +188,9 @@ static int
 nfnl_acct_dump(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct nf_acct *cur, *last;
+#ifdef CONFIG_NF_ACCT_FILTER
+	const struct nfacct_filter *filter = cb->data;
+#endif
 
 	if (cb->args[2])
 		return 0;
@@ -197,6 +207,12 @@ nfnl_acct_dump(struct sk_buff *skb, struct netlink_callback *cb)
 
 			last = NULL;
 		}
+
+#ifdef CONFIG_NF_ACCT_FILTER
+		if (filter && (cur->flags & filter->mask) != filter->value)
+			continue;
+#endif
+
 		if (nfnl_acct_fill_info(skb, NETLINK_CB(cb->skb).portid,
 				       cb->nlh->nlmsg_seq,
 				       NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
@@ -211,6 +227,44 @@ nfnl_acct_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+#ifdef CONFIG_NF_ACCT_FILTER
+static int
+nfnl_acct_done(struct netlink_callback *cb)
+{
+	if (cb->data)
+		kfree(cb->data);
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
+#endif /* CONFIG_NF_ACCT_FILTER */
+
 static int
 nfnl_acct_get(struct sock *nfnl, struct sk_buff *skb,
 	     const struct nlmsghdr *nlh, const struct nlattr * const tb[])
@@ -220,9 +274,15 @@ nfnl_acct_get(struct sock *nfnl, struct sk_buff *skb,
 	char *acct_name;
 
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
+		/* using filters only for dump/list operation */
 		struct netlink_dump_control c = {
 			.dump = nfnl_acct_dump,
 		};
+#ifdef CONFIG_NF_ACCT_FILTER
+		c.data = init_filter(tb[NFACCT_FILTER]);
+		c.done = nfnl_acct_done;
+#endif /* CONFIG_NF_ACCT_FILTER */
+
 		return netlink_dump_start(nfnl, skb, nlh, &c);
 	}
 
@@ -314,6 +374,7 @@ static const struct nla_policy nfnl_acct_policy[NFACCT_MAX+1] = {
 	[NFACCT_PKTS] = { .type = NLA_U64 },
 	[NFACCT_FLAGS] = { .type = NLA_U32 },
 	[NFACCT_QUOTA] = { .type = NLA_U64 },
+	[NFACCT_FILTER] = {.type = NLA_NESTED },
 };
 
 static const struct nfnl_callback nfnl_acct_cb[NFNL_MSG_ACCT_MAX] = {
-- 
1.7.9.5

