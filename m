From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 1/2] netfilter: if set per-rule qthreshold overrides per-instance
Date: Fri, 30 Jan 2009 23:31:46 +0100
Message-ID: <1233354708-22009-2-git-send-email-eric@inl.fr>
References: <1233354708-22009-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:51955 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754122AbZA3Wbw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Jan 2009 17:31:52 -0500
In-Reply-To: <1233354708-22009-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In NFLOG the per-rule qthreshold should overrides per-instance only
it is set. With current code, the per-rule qthreshold is 1 if not set
and it overrides the per-instance qthreshold.

This patch modifies the default xt_NFLOG threshold from 1 to
0. Thus a value of 0 means there is no per-rule setting and the instance
parameter has to apply.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 include/linux/netfilter/xt_NFLOG.h |    2 +-
 net/netfilter/nfnetlink_log.c      |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter/xt_NFLOG.h b/include/linux/netfilter/xt_NFLOG.h
index cdcd0ed..4b36aeb 100644
--- a/include/linux/netfilter/xt_NFLOG.h
+++ b/include/linux/netfilter/xt_NFLOG.h
@@ -2,7 +2,7 @@
 #define _XT_NFLOG_TARGET
 
 #define XT_NFLOG_DEFAULT_GROUP		0x1
-#define XT_NFLOG_DEFAULT_THRESHOLD	1
+#define XT_NFLOG_DEFAULT_THRESHOLD	0
 
 #define XT_NFLOG_MASK			0x0
 
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index fe52265..88b455e 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -590,8 +590,10 @@ nfulnl_log_packet(u_int8_t pf,
 
 	qthreshold = inst->qthreshold;
 	/* per-rule qthreshold overrides per-instance */
-	if (qthreshold > li->u.ulog.qthreshold)
-		qthreshold = li->u.ulog.qthreshold;
+	if (li->u.ulog.qthreshold)
+		if (qthreshold > li->u.ulog.qthreshold)
+			qthreshold = li->u.ulog.qthreshold;
+
 
 	switch (inst->copy_mode) {
 	case NFULNL_COPY_META:
-- 
1.6.1

