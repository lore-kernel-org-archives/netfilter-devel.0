From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH V2] netfilter: nfnetlink_acct: avoid using NFACCT_F_OVERQUOTA
 with bit helper funcitons
Date: Thu, 31 Jul 2014 17:14:05 +0400
Message-ID: <1406812445-2973-1-git-send-email-a.perevalov@samsung.com>
References: <20140730163133.GB6018@salvia>
Cc: Alexey Perevalov <a.perevalov@samsung.com>,
	alexey.perevalov@hotmail.com, mathieu.poirier@linaro.org,
	netfilter-devel@vger.kernel.org, kyungmin.park@samsung.com,
	hs81.go@samsung.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:63712 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaGaNOK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:14:10 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9K003GMVFAZX70@mailout4.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Thu, 31 Jul 2014 14:13:58 +0100 (BST)
In-reply-to: <20140730163133.GB6018@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bit helper functions were used for manipulation with NFACCT_F_OVERQUOTA,
but they are accepting pit position, but not a bit mask. As a result
not a third bit for NFACCT_F_OVERQUOTA was set, but forth. Such
behaviour was dangarous and could lead to unexpected overquota report
result.

Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
---
 include/uapi/linux/netfilter/nfnetlink_acct.h |    5 ++++-
 net/netfilter/nfnetlink_acct.c                |    7 ++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/netfilter/nfnetlink_acct.h b/include/uapi/linux/netfilter/nfnetlink_acct.h
index 51404ec..81410b7 100644
--- a/include/uapi/linux/netfilter/nfnetlink_acct.h
+++ b/include/uapi/linux/netfilter/nfnetlink_acct.h
@@ -14,10 +14,13 @@ enum nfnl_acct_msg_types {
 	NFNL_MSG_ACCT_MAX
 };
 
+#define NFACCT_OVERQUOTA_BIT 2
+
 enum nfnl_acct_flags {
 	NFACCT_F_QUOTA_PKTS	= (1 << 0),
 	NFACCT_F_QUOTA_BYTES	= (1 << 1),
-	NFACCT_F_OVERQUOTA	= (1 << 2), /* can't be set from userspace */
+	NFACCT_F_OVERQUOTA	= (1 << NFACCT_OVERQUOTA_BIT), /* can't be
+		 set from userspace */
 };
 
 enum nfnl_acct_type {
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 11d863c..5f6b1fb 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -77,7 +77,8 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
 			smp_mb__before_atomic();
 			/* reset overquota flag if quota is enabled. */
 			if ((matching->flags & NFACCT_F_QUOTA))
-				clear_bit(NFACCT_F_OVERQUOTA, &matching->flags);
+				clear_bit(NFACCT_OVERQUOTA_BIT,
+					   &matching->flags);
 			return 0;
 		}
 		return -EBUSY;
@@ -150,7 +151,7 @@ nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 		bytes = atomic64_xchg(&acct->bytes, 0);
 		smp_mb__before_atomic();
 		if (acct->flags & NFACCT_F_QUOTA)
-			clear_bit(NFACCT_F_OVERQUOTA, &acct->flags);
+			clear_bit(NFACCT_OVERQUOTA_BIT, &acct->flags);
 	} else {
 		pkts = atomic64_read(&acct->pkts);
 		bytes = atomic64_read(&acct->bytes);
@@ -414,7 +415,7 @@ int nfnl_acct_overquota(const struct sk_buff *skb, struct nf_acct *nfacct)
 	ret = now > *quota;
 
 	if (now >= *quota &&
-	    !test_and_set_bit(NFACCT_F_OVERQUOTA, &nfacct->flags)) {
+	    !test_and_set_bit(NFACCT_OVERQUOTA_BIT, &nfacct->flags)) {
 		nfnl_overquota_report(nfacct);
 	}
 
-- 
1.7.9.5

