From: Felix Janda <felix.janda@posteo.de>
Subject: [libnetfilter_conntrack PATCH 1/2] Sync with kernel headers
Date: Sat, 16 May 2015 13:02:27 +0200
Message-ID: <20150516105656.GN14201@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:49590 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbbEPLDN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2015 07:03:13 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id 3058625AF536
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 13:03:12 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3lpkH404f2z5vN5
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 13:03:11 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 .../linux_nfnetlink_conntrack.h                    | 31 +++++++++++++---------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h b/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
index 5812595..55de033 100644
--- a/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
+++ b/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
@@ -2,10 +2,6 @@
 #define _IPCONNTRACK_NETLINK_H
 #include <libnfnetlink/linux_nfnetlink.h>
 
-#ifdef __cplusplus
-extern "C" {
-#endif
-
 enum cntl_msg_types {
 	IPCTNL_MSG_CT_NEW,
 	IPCTNL_MSG_CT_GET,
@@ -46,8 +42,10 @@ enum ctattr_type {
 	CTA_ID,
 	CTA_NAT_DST,
 	CTA_TUPLE_MASTER,
-	CTA_NAT_SEQ_ADJ_ORIG,
-	CTA_NAT_SEQ_ADJ_REPLY,
+	CTA_SEQ_ADJ_ORIG,
+	CTA_NAT_SEQ_ADJ_ORIG	= CTA_SEQ_ADJ_ORIG,
+	CTA_SEQ_ADJ_REPLY,
+	CTA_NAT_SEQ_ADJ_REPLY	= CTA_SEQ_ADJ_REPLY,
 	CTA_SECMARK,		/* obsolete */
 	CTA_ZONE,
 	CTA_SECCTX,
@@ -150,9 +148,13 @@ enum ctattr_tstamp {
 
 enum ctattr_nat {
 	CTA_NAT_UNSPEC,
-	CTA_NAT_MINIP,
-	CTA_NAT_MAXIP,
+	CTA_NAT_V4_MINIP,
+#define CTA_NAT_MINIP CTA_NAT_V4_MINIP
+	CTA_NAT_V4_MAXIP,
+#define CTA_NAT_MAXIP CTA_NAT_V4_MAXIP
 	CTA_NAT_PROTO,
+	CTA_NAT_V6_MINIP,
+	CTA_NAT_V6_MAXIP,
 	__CTA_NAT_MAX
 };
 #define CTA_NAT_MAX (__CTA_NAT_MAX - 1)
@@ -165,6 +167,15 @@ enum ctattr_protonat {
 };
 #define CTA_PROTONAT_MAX (__CTA_PROTONAT_MAX - 1)
 
+enum ctattr_seqadj {
+	CTA_SEQADJ_UNSPEC,
+	CTA_SEQADJ_CORRECTION_POS,
+	CTA_SEQADJ_OFFSET_BEFORE,
+	CTA_SEQADJ_OFFSET_AFTER,
+	__CTA_SEQADJ_MAX
+};
+#define CTA_SEQADJ_MAX (__CTA_SEQADJ_MAX - 1)
+
 enum ctattr_natseq {
 	CTA_NAT_SEQ_UNSPEC,
 	CTA_NAT_SEQ_CORRECTION_POS,
@@ -249,8 +260,4 @@ enum ctattr_expect_stats {
 };
 #define CTA_STATS_EXP_MAX (__CTA_STATS_EXP_MAX - 1)
 
-#ifdef __cplusplus
-}
-#endif
-
 #endif /* _IPCONNTRACK_NETLINK_H */
-- 
2.3.6
