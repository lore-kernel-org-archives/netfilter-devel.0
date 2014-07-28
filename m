From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH] netfilter: nfnetlink_acct: use flag to reset counters
Date: Mon, 28 Jul 2014 21:57:51 +0400
Message-ID: <1406570272-3704-2-git-send-email-a.perevalov@samsung.com>
References: <1406570272-3704-1-git-send-email-a.perevalov@samsung.com>
Cc: Alexey Perevalov <a.perevalov@samsung.com>,
	kyungmin.park@samsung.com, hs81.go@samsung.com,
	netfilter-devel@vger.kernel.org, alexey.perevalov@hotmail.com,
	mathieu.poirier@linaro.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:42747 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaG1R57 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:57:59 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9F00N7IOKK1P10@mailout3.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Mon, 28 Jul 2014 18:57:56 +0100 (BST)
In-reply-to: <1406570272-3704-1-git-send-email-a.perevalov@samsung.com>
In-reply-to: <20140725160123.GA20548@salvia>
References: <20140725160123.GA20548@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Two additional NFACCT_F* was introduced for ability to reset
counters with and without quota separately.

It could be useful when client has to reset counters and wants to keep
quotas untouched or vice versa without flushing and renewing.

Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
---
 include/uapi/linux/netfilter/nfnetlink_acct.h |    2 ++
 net/netfilter/nfnetlink_acct.c                |   30 ++++++++++++++++++++-----
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/netfilter/nfnetlink_acct.h b/include/uapi/linux/netfilter/nfnetlink_acct.h
index 51404ec..1181c8e 100644
--- a/include/uapi/linux/netfilter/nfnetlink_acct.h
+++ b/include/uapi/linux/netfilter/nfnetlink_acct.h
@@ -18,6 +18,8 @@ enum nfnl_acct_flags {
 	NFACCT_F_QUOTA_PKTS	= (1 << 0),
 	NFACCT_F_QUOTA_BYTES	= (1 << 1),
 	NFACCT_F_OVERQUOTA	= (1 << 2), /* can't be set from userspace */
+	NFACCT_F_RESET_COUNTERS = (1 << 3),
+	NFACCT_F_RESET_QUOTAS   = (1 << 4),
 };
 
 enum nfnl_acct_type {
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 2baa125..1f47503 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -121,9 +121,23 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
 	return 0;
 }
 
+static inline bool
+is_counters_reset(u32 nfacct_flags, unsigned long counter_flags)
+{
+	return nfacct_flags & NFACCT_F_RESET_COUNTERS &&
+		!(counter_flags & NFACCT_F_QUOTA);
+}
+
+static inline bool
+is_quotas_reset(u32 nfacct_flags, unsigned long counter_flags)
+{
+	return nfacct_flags & NFACCT_F_RESET_QUOTAS &&
+		counter_flags & NFACCT_F_QUOTA;
+}
+
 static int
 nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
-		   int event, struct nf_acct *acct)
+		   int event, struct nf_acct *acct, u32 nfacct_flags)
 {
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
@@ -143,7 +157,9 @@ nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	if (nla_put_string(skb, NFACCT_NAME, acct->name))
 		goto nla_put_failure;
 
-	if (type == NFNL_MSG_ACCT_GET_CTRZERO) {
+	if (type == NFNL_MSG_ACCT_GET_CTRZERO &&
+		(!nfacct_flags || is_counters_reset(nfacct_flags, acct->flags) ||
+		is_quotas_reset(nfacct_flags, acct->flags))) {
 		pkts = atomic64_xchg(&acct->pkts, 0);
 		bytes = atomic64_xchg(&acct->bytes, 0);
 		smp_mb__before_atomic();
@@ -177,6 +193,7 @@ static int
 nfnl_acct_dump(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct nf_acct *cur, *last;
+	u32 flags = cb->data ? *(u32 *)cb->data : 0;
 
 	if (cb->args[2])
 		return 0;
@@ -196,7 +213,7 @@ nfnl_acct_dump(struct sk_buff *skb, struct netlink_callback *cb)
 		if (nfnl_acct_fill_info(skb, NETLINK_CB(cb->skb).portid,
 				       cb->nlh->nlmsg_seq,
 				       NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
-				       NFNL_MSG_ACCT_NEW, cur) < 0) {
+				       NFNL_MSG_ACCT_NEW, cur, flags) < 0) {
 			cb->args[1] = (unsigned long)cur;
 			break;
 		}
@@ -214,10 +231,13 @@ nfnl_acct_get(struct sock *nfnl, struct sk_buff *skb,
 	int ret = -ENOENT;
 	struct nf_acct *cur;
 	char *acct_name;
+	u32 flags = tb[NFACCT_FLAGS] ?
+		ntohl(nla_get_u32(tb[NFACCT_FLAGS])) : 0;
 
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.dump = nfnl_acct_dump,
+			.data = &flags,
 		};
 		return netlink_dump_start(nfnl, skb, nlh, &c);
 	}
@@ -241,7 +261,7 @@ nfnl_acct_get(struct sock *nfnl, struct sk_buff *skb,
 		ret = nfnl_acct_fill_info(skb2, NETLINK_CB(skb).portid,
 					 nlh->nlmsg_seq,
 					 NFNL_MSG_TYPE(nlh->nlmsg_type),
-					 NFNL_MSG_ACCT_NEW, cur);
+					 NFNL_MSG_ACCT_NEW, cur, flags);
 		if (ret <= 0) {
 			kfree_skb(skb2);
 			break;
@@ -386,7 +406,7 @@ static void nfnl_overquota_report(struct nf_acct *nfacct)
 		return;
 
 	ret = nfnl_acct_fill_info(skb, 0, 0, NFNL_MSG_ACCT_OVERQUOTA, 0,
-				  nfacct);
+				  nfacct, 0);
 	if (ret <= 0) {
 		kfree_skb(skb);
 		return;
-- 
1.7.9.5

