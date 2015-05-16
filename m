From: Felix Janda <felix.janda@posteo.de>
Subject: [libnetfilter_acct PATCH] Sync with kernel headers
Date: Sat, 16 May 2015 12:56:31 +0200
Message-ID: <20150516104121.GM14201@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:42266 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbbEPK4q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2015 06:56:46 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id 3123825B17C9
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 12:56:45 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3lpk7d0NW4z5vN4
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 12:56:44 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 include/linux/netfilter/nfnetlink.h      | 16 +++++++++++-----
 include/linux/netfilter/nfnetlink_acct.h | 20 ++++++++++++++------
 2 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index d3e0ea8..c755646 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -1,5 +1,5 @@
-#ifndef _UAPI_NFNETLINK_H
-#define _UAPI_NFNETLINK_H
+#ifndef _NFNETLINK_H
+#define _NFNETLINK_H
 #include <linux/types.h>
 #include <linux/netfilter/nfnetlink_compat.h>
 
@@ -19,7 +19,7 @@ enum nfnetlink_groups {
 	NFNLGRP_CONNTRACK_EXP_DESTROY,
 #define NFNLGRP_CONNTRACK_EXP_DESTROY	NFNLGRP_CONNTRACK_EXP_DESTROY
 	NFNLGRP_NFTABLES,
-#define NFNLGRP_NFTABLES		NFNLGRP_NFTABLES
+#define NFNLGRP_NFTABLES                NFNLGRP_NFTABLES
 	NFNLGRP_ACCT_QUOTA,
 #define NFNLGRP_ACCT_QUOTA		NFNLGRP_ACCT_QUOTA
 	__NFNLGRP_MAX,
@@ -55,6 +55,12 @@ struct nfgenmsg {
 #define NFNL_SUBSYS_ACCT		7
 #define NFNL_SUBSYS_CTNETLINK_TIMEOUT	8
 #define NFNL_SUBSYS_CTHELPER		9
-#define NFNL_SUBSYS_COUNT		10
+#define NFNL_SUBSYS_NFTABLES		10
+#define NFNL_SUBSYS_NFT_COMPAT		11
+#define NFNL_SUBSYS_COUNT		12
 
-#endif /* _UAPI_NFNETLINK_H */
+/* Reserved control nfnetlink messages */
+#define NFNL_MSG_BATCH_BEGIN		NLMSG_MIN_TYPE
+#define NFNL_MSG_BATCH_END		NLMSG_MIN_TYPE+1
+
+#endif /* _NFNETLINK_H */
diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux/netfilter/nfnetlink_acct.h
index 6b8c935..98b6286 100644
--- a/include/linux/netfilter/nfnetlink_acct.h
+++ b/include/linux/netfilter/nfnetlink_acct.h
@@ -1,5 +1,5 @@
-#ifndef _UAPI_NFNL_ACCT_H_
-#define _UAPI_NFNL_ACCT_H_
+#ifndef _NFNL_ACCT_H_
+#define _NFNL_ACCT_H_
 
 #ifndef NFACCT_NAME_MAX
 #define NFACCT_NAME_MAX		32
@@ -15,9 +15,9 @@ enum nfnl_acct_msg_types {
 };
 
 enum nfnl_acct_flags {
-	NFACCT_F_QUOTA_PKTS     = (1 << 0),
-	NFACCT_F_QUOTA_BYTES    = (1 << 1),
-	NFACCT_F_OVERQUOTA      = (1 << 2), /* can't be set from userspace */
+	NFACCT_F_QUOTA_PKTS	= (1 << 0),
+	NFACCT_F_QUOTA_BYTES	= (1 << 1),
+	NFACCT_F_OVERQUOTA	= (1 << 2), /* can't be set from userspace */
 };
 
 enum nfnl_acct_type {
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
 
-#endif /* _UAPI_NFNL_ACCT_H_ */
+#endif /* _NFNL_ACCT_H_ */
-- 
2.3.6
