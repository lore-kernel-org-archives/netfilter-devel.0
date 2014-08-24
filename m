From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [[PATCH v3]] netfilter: nfnetlink_acct: add filter support to
 nfacct counter list/reset
Date: Sun, 24 Aug 2014 15:15:37 +0200
Message-ID: <20140824131537.GA8144@salvia>
References: <20140820133401.GA7422@salvia>
 <1408557798-6455-1-git-send-email-a.perevalov@samsung.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Kj7319i9nmIyA2yE"
Cc: alexey.perevalov@hotmail.com, mathieu.poirier@linaro.org,
	netfilter-devel@vger.kernel.org, kyungmin.park@samsung.com,
	hs81.go@samsung.com
To: Alexey Perevalov <a.perevalov@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60634 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650AbaHXNPJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Aug 2014 09:15:09 -0400
Content-Disposition: inline
In-Reply-To: <1408557798-6455-1-git-send-email-a.perevalov@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Wed, Aug 20, 2014 at 10:03:18PM +0400, Alexey Perevalov wrote:
> +static struct nfacct_filter *
> +nfacct_filter_alloc(struct nlattr *attrs[NFACCT_FILTER_MAX + 1])
> +{
> +	struct nfacct_filter *filter = kzalloc(sizeof(struct nfacct_filter),
> +					       GFP_KERNEL);
> +	if (!filter)
> +		return ERR_PTR(-ENOMEM);
> +
> +	filter->mask = nla_get_be32(attrs[NFACCT_FILTER_MASK]);
> +	filter->value = nla_get_be32(attrs[NFACCT_FILTER_VALUE]);

We have to use ntohl() here, it's the convention for nfnetlink.

I'm attaching a patch that resolves this plus some cleanups.

Please, let me know if you're OK with it. Thanks.

--Kj7319i9nmIyA2yE
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-nfnetlink_acct-add-filter-support-to-count.patch"

>From eff91543e49c2acb2844b263b59ea0b7cc94024d Mon Sep 17 00:00:00 2001
From: Alexey Perevalov <a.perevalov@samsung.com>
Date: Wed, 20 Aug 2014 22:03:18 +0400
Subject: [PATCH] netfilter: nfnetlink_acct: add filter support to counter
 list/reset

You can use this to skip accounting objects when listing/resetting
via NFNL_MSG_ACCT_GET/NFNL_MSG_ACCT_GET_CTRZERO messages with the
NLM_F_DUMP netlink flag. The filtering covers the following cases:

1. No filter specified. In this case, the client will get old behaviour,
2. List/reset counter object only: In this case, you have to use
   NFACCT_F_QUOTA as mask and value 0.
3. List/reset quota objects only: You have to use NFACCT_F_QUOTA_PKTS
   as mask and value - the same, for byte based quota mask should be
   NFACCT_F_QUOTA_BYTES and value - the same.

If you want to obtain the object with any quota type
(ie. NFACCT_F_QUOTA_PKTS|NFACCT_F_QUOTA_BYTES), you need to perform
two dump requests, one to obtain NFACCT_F_QUOTA_PKTS objects and
another for NFACCT_F_QUOTA_BYTES.

Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nfnetlink_acct.h |    8 ++++
 net/netfilter/nfnetlink_acct.c                |   54 +++++++++++++++++++++++++
 2 files changed, 62 insertions(+)

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
index 3ea0eac..c18af2f 100644
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
@@ -211,6 +221,38 @@ nfnl_acct_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+static int nfnl_acct_done(struct netlink_callback *cb)
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
+nfacct_filter_alloc(const struct nlattr * const attr)
+{
+	struct nfacct_filter *filter;
+	struct nlattr *tb[NFACCT_FILTER_MAX + 1];
+	int err;
+
+	err = nla_parse_nested(tb, NFACCT_FILTER_MAX, attr, filter_policy);
+	if (err < 0)
+		return ERR_PTR(err);
+
+	filter = kzalloc(sizeof(struct nfacct_filter), GFP_KERNEL);
+	if (!filter)
+		return ERR_PTR(-ENOMEM);
+
+	filter->mask = ntohl(nla_get_be32(tb[NFACCT_FILTER_MASK]));
+	filter->value = ntohl(nla_get_be32(tb[NFACCT_FILTER_VALUE]));
+
+	return filter;
+}
+
 static int
 nfnl_acct_get(struct sock *nfnl, struct sk_buff *skb,
 	     const struct nlmsghdr *nlh, const struct nlattr * const tb[])
@@ -222,7 +264,18 @@ nfnl_acct_get(struct sock *nfnl, struct sk_buff *skb,
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.dump = nfnl_acct_dump,
+			.done = nfnl_acct_done,
 		};
+
+		if (tb[NFACCT_FILTER]) {
+			struct nfacct_filter *filter;
+
+			filter = nfacct_filter_alloc(tb[NFACCT_FILTER]);
+			if (IS_ERR(filter))
+				return PTR_ERR(filter);
+
+			c.data = filter;
+		}
 		return netlink_dump_start(nfnl, skb, nlh, &c);
 	}
 
@@ -314,6 +367,7 @@ static const struct nla_policy nfnl_acct_policy[NFACCT_MAX+1] = {
 	[NFACCT_PKTS] = { .type = NLA_U64 },
 	[NFACCT_FLAGS] = { .type = NLA_U32 },
 	[NFACCT_QUOTA] = { .type = NLA_U64 },
+	[NFACCT_FILTER] = {.type = NLA_NESTED },
 };
 
 static const struct nfnl_callback nfnl_acct_cb[NFNL_MSG_ACCT_MAX] = {
-- 
1.7.10.4


--Kj7319i9nmIyA2yE--
