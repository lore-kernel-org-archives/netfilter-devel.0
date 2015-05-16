From: Felix Janda <felix.janda@posteo.de>
Subject: [ulogd2 PATCH 1/4] Sync with kernel headers
Date: Sat, 16 May 2015 15:01:30 +0200
Message-ID: <20150516130130.GB14201@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:47319 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbbEPNBs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2015 09:01:48 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id 7138825A3DEA
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 15:01:47 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3lpmvv22PHz5vN4
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 15:01:47 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 include/linux/netfilter/nfnetlink_acct.h | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux/netfilter/nfnetlink_acct.h
index 7c4279b..98b6286 100644
--- a/include/linux/netfilter/nfnetlink_acct.h
+++ b/include/linux/netfilter/nfnetlink_acct.h
@@ -10,27 +10,35 @@ enum nfnl_acct_msg_types {
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
+	NFACCT_FILTER,
 	__NFACCT_MAX
 };
 #define NFACCT_MAX (__NFACCT_MAX - 1)
 
-#ifdef __KERNEL__
-
-struct nf_acct;
-
-extern struct nf_acct *nfnl_acct_find_get(const char *filter_name);
-extern void nfnl_acct_put(struct nf_acct *acct);
-extern void nfnl_acct_update(const struct sk_buff *skb, struct nf_acct *nfacct);
-
-#endif /* __KERNEL__ */
+enum nfnl_attr_filter_type {
+	NFACCT_FILTER_UNSPEC,
+	NFACCT_FILTER_MASK,
+	NFACCT_FILTER_VALUE,
+	__NFACCT_FILTER_MAX
+};
+#define NFACCT_FILTER_MAX (__NFACCT_FILTER_MAX - 1)
 
-#endif /* _NFNL_ACCT_H */
+#endif /* _NFNL_ACCT_H_ */
-- 
2.3.6
