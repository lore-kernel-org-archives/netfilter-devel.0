From: mathieu.poirier@linaro.org
Subject: [RFC PATCH 1/2] netfilter: nfnetlink_acct: Adding quota support to nf_acct objects
Date: Sun, 30 Mar 2014 15:10:43 -0600
Message-ID: <1396213844-10528-2-git-send-email-mathieu.poirier@linaro.org>
References: <1396213844-10528-1-git-send-email-mathieu.poirier@linaro.org>
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	mathieu.poirier@linaro.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:48424 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaC3VK6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Mar 2014 17:10:58 -0400
Received: by mail-pa0-f43.google.com with SMTP id bj1so7284970pad.16
        for <netfilter-devel@vger.kernel.org>; Sun, 30 Mar 2014 14:10:57 -0700 (PDT)
In-Reply-To: <1396213844-10528-1-git-send-email-mathieu.poirier@linaro.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

The nf_acct objects already support accounting at the byte and
packet level.  As such it is a natural extention to add the
capability to define a ceiling limit for both metrics.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 include/uapi/linux/netfilter/nfnetlink.h      |  2 +
 include/uapi/linux/netfilter/nfnetlink_acct.h |  9 +++
 net/netfilter/nfnetlink_acct.c                | 79 +++++++++++++++++++++++++++
 3 files changed, 90 insertions(+)

diff --git a/include/uapi/linux/netfilter/nfnetlink.h b/include/uapi/linux/netfilter/nfnetlink.h
index 596ddd4..354a7e5 100644
--- a/include/uapi/linux/netfilter/nfnetlink.h
+++ b/include/uapi/linux/netfilter/nfnetlink.h
@@ -20,6 +20,8 @@ enum nfnetlink_groups {
 #define NFNLGRP_CONNTRACK_EXP_DESTROY	NFNLGRP_CONNTRACK_EXP_DESTROY
 	NFNLGRP_NFTABLES,
 #define NFNLGRP_NFTABLES                NFNLGRP_NFTABLES
+	NFNLGRP_ACCT_QUOTA,
+#define NFNLGRP_ACCT_QUOTA		NFNLGRP_ACCT_QUOTA
 	__NFNLGRP_MAX,
 };
 #define NFNLGRP_MAX	(__NFNLGRP_MAX - 1)
diff --git a/include/uapi/linux/netfilter/nfnetlink_acct.h b/include/uapi/linux/netfilter/nfnetlink_acct.h
index c7b6269..51404ec 100644
--- a/include/uapi/linux/netfilter/nfnetlink_acct.h
+++ b/include/uapi/linux/netfilter/nfnetlink_acct.h
@@ -10,15 +10,24 @@ enum nfnl_acct_msg_types {
 	NFNL_MSG_ACCT_GET,
 	NFNL_MSG_ACCT_GET_CTRZERO,
 	NFNL_MSG_ACCT_DEL,
+	NFNL_MSG_ACCT_OVERQUOTA,
 	NFNL_MSG_ACCT_MAX
 };
 
+enum nfnl_acct_flags {
+	NFACCT_F_QUOTA_PKTS	= (1 << 0),
+	NFACCT_F_QUOTA_BYTES	= (1 << 1),
+	NFACCT_F_OVERQUOTA	= (1 << 2), /* can't be set from userspace */
+};
+
 enum nfnl_acct_type {
 	NFACCT_UNSPEC,
 	NFACCT_NAME,
 	NFACCT_PKTS,
 	NFACCT_BYTES,
 	NFACCT_USE,
+	NFACCT_FLAGS,
+	NFACCT_QUOTA,
 	__NFACCT_MAX
 };
 #define NFACCT_MAX (__NFACCT_MAX - 1)
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index c7b6d46..25afecf 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -32,18 +32,24 @@ static LIST_HEAD(nfnl_acct_list);
 struct nf_acct {
 	atomic64_t		pkts;
 	atomic64_t		bytes;
+	unsigned long		flags;
 	struct list_head	head;
 	atomic_t		refcnt;
 	char			name[NFACCT_NAME_MAX];
 	struct rcu_head		rcu_head;
+	char			data[0];
 };
 
+#define NFACCT_F_QUOTA (NFACCT_F_QUOTA_PKTS | NFACCT_F_QUOTA_BYTES)
+
 static int
 nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
 	     const struct nlmsghdr *nlh, const struct nlattr * const tb[])
 {
 	struct nf_acct *nfacct, *matching = NULL;
 	char *acct_name;
+	unsigned int size = 0;
+	u32 flags = 0;
 
 	if (!tb[NFACCT_NAME])
 		return -EINVAL;
@@ -68,15 +74,39 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
 			/* reset counters if you request a replacement. */
 			atomic64_set(&matching->pkts, 0);
 			atomic64_set(&matching->bytes, 0);
+			smp_mb__before_clear_bit();
+			/* reset overquota flag if quota is enabled. */
+			if ((matching->flags & NFACCT_F_QUOTA))
+				clear_bit(NFACCT_F_OVERQUOTA, &matching->flags);
 			return 0;
 		}
 		return -EBUSY;
 	}
 
 	nfacct = kzalloc(sizeof(struct nf_acct), GFP_KERNEL);
+	if (tb[NFACCT_FLAGS]) {
+		flags = ntohl(nla_get_be32(tb[NFACCT_FLAGS]));
+		if (flags & ~NFACCT_F_QUOTA)
+			return -EOPNOTSUPP;
+		if ((flags & NFACCT_F_QUOTA) == NFACCT_F_QUOTA)
+			return -EINVAL;
+		if (flags & NFACCT_F_OVERQUOTA)
+			return -EINVAL;
+
+		size += sizeof(u64);
+	}
+
+	nfacct = kzalloc(sizeof(struct nf_acct) + size, GFP_KERNEL);
 	if (nfacct == NULL)
 		return -ENOMEM;
 
+	if (flags & NFACCT_F_QUOTA) {
+		u64 *quota = (u64 *)nfacct->data;
+
+		*quota = be64_to_cpu(nla_get_be64(tb[NFACCT_QUOTA]));
+		nfacct->flags = flags;
+	}
+
 	strncpy(nfacct->name, nla_data(tb[NFACCT_NAME]), NFACCT_NAME_MAX);
 
 	if (tb[NFACCT_BYTES]) {
@@ -125,7 +155,13 @@ nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	    nla_put_be64(skb, NFACCT_BYTES, cpu_to_be64(bytes)) ||
 	    nla_put_be32(skb, NFACCT_USE, htonl(atomic_read(&acct->refcnt))))
 		goto nla_put_failure;
+	if (acct->flags & NFACCT_F_QUOTA) {
+		u64 *quota = (u64 *)acct->data;
 
+		if (nla_put_be32(skb, NFACCT_FLAGS, htonl(acct->flags)) ||
+		    nla_put_be64(skb, NFACCT_QUOTA, cpu_to_be64(*quota)))
+			goto nla_put_failure;
+	}
 	nlmsg_end(skb, nlh);
 	return skb->len;
 
@@ -270,6 +306,8 @@ static const struct nla_policy nfnl_acct_policy[NFACCT_MAX+1] = {
 	[NFACCT_NAME] = { .type = NLA_NUL_STRING, .len = NFACCT_NAME_MAX-1 },
 	[NFACCT_BYTES] = { .type = NLA_U64 },
 	[NFACCT_PKTS] = { .type = NLA_U64 },
+	[NFACCT_FLAGS] = { .type = NLA_U32 },
+	[NFACCT_QUOTA] = { .type = NLA_U64 },
 };
 
 static const struct nfnl_callback nfnl_acct_cb[NFNL_MSG_ACCT_MAX] = {
@@ -336,6 +374,47 @@ void nfnl_acct_update(const struct sk_buff *skb, struct nf_acct *nfacct)
 }
 EXPORT_SYMBOL_GPL(nfnl_acct_update);
 
+static void nfnl_overquota_report(struct nf_acct *nfacct)
+{
+	int ret;
+	struct sk_buff *skb;
+
+	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	if (skb == NULL)
+		return;
+
+	ret = nfnl_acct_fill_info(skb, 0, 0, NFNL_MSG_ACCT_OVERQUOTA, 0,
+				  nfacct);
+	if (ret <= 0) {
+		kfree_skb(skb);
+		return;
+	}
+	netlink_broadcast(init_net.nfnl, skb, 0, NFNLGRP_ACCT_QUOTA,
+			  GFP_ATOMIC);
+}
+
+bool nfnl_acct_overquota(const struct sk_buff *skb, struct nf_acct *nfacct)
+{
+	u64 *quota;
+	bool ret = false;
+
+	if (nfacct->flags & NFACCT_F_QUOTA_PKTS) {
+		quota = (u64 *)nfacct->data;
+		ret = atomic64_read(&nfacct->pkts) >= *quota &&
+		      !test_and_set_bit(NFACCT_F_OVERQUOTA, &nfacct->flags);
+	}
+	if (nfacct->flags & NFACCT_F_QUOTA_BYTES) {
+		quota = (u64 *)nfacct->data;
+		ret = atomic64_read(&nfacct->bytes) >= *quota &&
+		      !test_and_set_bit(NFACCT_F_OVERQUOTA, &nfacct->flags);
+	}
+	if (ret)
+		nfnl_overquota_report(nfacct);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nfnl_acct_overquota);
+
 static int __init nfnl_acct_init(void)
 {
 	int ret;
-- 
1.8.3.2

