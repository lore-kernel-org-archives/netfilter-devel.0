From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH 1/2] netfilter: nfnetlink_acct: avoid using NFACCT_F_OVERQUOTA
 with bit helper funcitons
Date: Wed, 30 Jul 2014 19:17:54 +0400
Message-ID: <1406733475-5222-2-git-send-email-a.perevalov@samsung.com>
References: <1406733475-5222-1-git-send-email-a.perevalov@samsung.com>
Cc: Alexey Perevalov <a.perevalov@samsung.com>,
	alexey.perevalov@hotmail.com, mathieu.poirier@linaro.org,
	netfilter-devel@vger.kernel.org, kyungmin.park@samsung.com,
	hs81.go@samsung.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20858 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbaG3PSO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jul 2014 11:18:14 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9J003OB6HUJU60@mailout2.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Wed, 30 Jul 2014 16:17:54 +0100 (BST)
In-reply-to: <1406733475-5222-1-git-send-email-a.perevalov@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bit helper functions were used for manipulation with NFACCT_F_OVERQUOTA,
but they are accepting pit position, but not a bit mask. As a result
not a third bit for NFACCT_F_OVERQUOTA was set, but forth. Such
behaviour was dangarous and could lead to unexpected overquota report
result.

Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
---
 net/netfilter/nfnetlink_acct.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 2baa125..127d24e 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -77,7 +77,7 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
 			smp_mb__before_atomic();
 			/* reset overquota flag if quota is enabled. */
 			if ((matching->flags & NFACCT_F_QUOTA))
-				clear_bit(NFACCT_F_OVERQUOTA, &matching->flags);
+				matching->flags &= ~NFACCT_F_OVERQUOTA;
 			return 0;
 		}
 		return -EBUSY;
@@ -148,7 +148,7 @@ nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 		bytes = atomic64_xchg(&acct->bytes, 0);
 		smp_mb__before_atomic();
 		if (acct->flags & NFACCT_F_QUOTA)
-			clear_bit(NFACCT_F_OVERQUOTA, &acct->flags);
+			acct->flags &= ~NFACCT_F_OVERQUOTA;
 	} else {
 		pkts = atomic64_read(&acct->pkts);
 		bytes = atomic64_read(&acct->bytes);
@@ -411,8 +411,8 @@ int nfnl_acct_overquota(const struct sk_buff *skb, struct nf_acct *nfacct)
 
 	ret = now > *quota;
 
-	if (now >= *quota &&
-	    !test_and_set_bit(NFACCT_F_OVERQUOTA, &nfacct->flags)) {
+	if (now >= *quota) {
+		nfacct->flags |= NFACCT_F_OVERQUOTA;
 		nfnl_overquota_report(nfacct);
 	}
 
-- 
1.7.9.5

