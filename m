From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH] xt_quota: also document negation
Date: Fri,  2 Jul 2010 12:15:02 +0200
Message-ID: <1278065703-22170-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38119 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875Ab0GBKPE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Jul 2010 06:15:04 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_quota.c   |    2 +-
 extensions/libxt_quota.man |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/extensions/libxt_quota.c b/extensions/libxt_quota.c
index bdfc92a..ac7c686 100644
--- a/extensions/libxt_quota.c
+++ b/extensions/libxt_quota.c
@@ -19,7 +19,7 @@ static const struct option quota_opts[] = {
 static void quota_help(void)
 {
 	printf("quota match options:\n"
-	       " --quota quota			quota (bytes)\n");
+	       "[!] --quota quota		quota (bytes)\n");
 }
 
 static void
diff --git a/extensions/libxt_quota.man b/extensions/libxt_quota.man
index f8bf77b..8d9e18b 100644
--- a/extensions/libxt_quota.man
+++ b/extensions/libxt_quota.man
@@ -1,6 +1,5 @@
 Implements network quotas by decrementing a byte counter with each
 packet.
 .TP
-\fB\-\-quota\fP \fIbytes\fP
+[\fB!\fP] \fB\-\-quota\fP \fIbytes\fP
 The quota in bytes.
-.P
-- 
1.7.1

