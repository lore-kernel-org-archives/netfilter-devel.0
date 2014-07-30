From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH 2/2] netfilter: nfnetlink_acct: dump unmodified nfacct flags
Date: Wed, 30 Jul 2014 19:17:55 +0400
Message-ID: <1406733475-5222-3-git-send-email-a.perevalov@samsung.com>
References: <1406733475-5222-1-git-send-email-a.perevalov@samsung.com>
Cc: Alexey Perevalov <a.perevalov@samsung.com>,
	alexey.perevalov@hotmail.com, mathieu.poirier@linaro.org,
	netfilter-devel@vger.kernel.org, kyungmin.park@samsung.com,
	hs81.go@samsung.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58504 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbaG3PSQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jul 2014 11:18:16 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9J00K0C6I8TUA0@mailout1.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Wed, 30 Jul 2014 16:18:08 +0100 (BST)
In-reply-to: <1406733475-5222-1-git-send-email-a.perevalov@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

NFNL_MSG_ACCT_GET_CTRZERO modifies dumped flags, in this case
client see unmodified (uncleared) counter value and cleared
overquota state - end user doesn't know anything about overquota state,
unless end user subscribed on overquota report.

Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
---
 net/netfilter/nfnetlink_acct.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 127d24e..ab2e89d 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -129,6 +129,7 @@ nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	struct nfgenmsg *nfmsg;
 	unsigned int flags = portid ? NLM_F_MULTI : 0;
 	u64 pkts, bytes;
+	u32 old_flags;
 
 	event |= NFNL_SUBSYS_ACCT << 8;
 	nlh = nlmsg_put(skb, portid, seq, event, sizeof(*nfmsg), flags);
@@ -143,6 +144,7 @@ nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	if (nla_put_string(skb, NFACCT_NAME, acct->name))
 		goto nla_put_failure;
 
+	old_flags = acct->flags;
 	if (type == NFNL_MSG_ACCT_GET_CTRZERO) {
 		pkts = atomic64_xchg(&acct->pkts, 0);
 		bytes = atomic64_xchg(&acct->bytes, 0);
@@ -160,7 +162,7 @@ nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	if (acct->flags & NFACCT_F_QUOTA) {
 		u64 *quota = (u64 *)acct->data;
 
-		if (nla_put_be32(skb, NFACCT_FLAGS, htonl(acct->flags)) ||
+		if (nla_put_be32(skb, NFACCT_FLAGS, htonl(old_flags)) ||
 		    nla_put_be64(skb, NFACCT_QUOTA, cpu_to_be64(*quota)))
 			goto nla_put_failure;
 	}
-- 
1.7.9.5

