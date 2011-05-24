From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 21/24] libxt_NFQUEUE: add mutual exclusion between qnum and qbal
Date: Wed, 25 May 2011 01:08:22 +0200
Message-ID: <1306278506-11463-22-git-send-email-jengelh@medozas.de>
References: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40996 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932838Ab1EXXIv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 19:08:51 -0400
In-Reply-To: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Only one is printed on save operation, which leads me to believe that
only one is meant to be used. The manpage seems to corroborate.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_NFQUEUE.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index 71ead8d..e47b586 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -13,6 +13,8 @@ enum {
 	O_QUEUE_NUM = 0,
 	O_QUEUE_BALANCE,
 	O_QUEUE_BYPASS,
+	F_QUEUE_NUM     = 1 << O_QUEUE_NUM,
+	F_QUEUE_BALANCE = 1 << O_QUEUE_BALANCE,
 };
 
 static void NFQUEUE_help(void)
@@ -41,9 +43,10 @@ static void NFQUEUE_help_v2(void)
 #define s struct xt_NFQ_info
 static const struct xt_option_entry NFQUEUE_opts[] = {
 	{.name = "queue-num", .id = O_QUEUE_NUM, .type = XTTYPE_UINT16,
-	 .flags = XTOPT_PUT, XTOPT_POINTER(s, queuenum)},
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, queuenum),
+	 .excl = F_QUEUE_BALANCE},
 	{.name = "queue-balance", .id = O_QUEUE_BALANCE,
-	 .type = XTTYPE_UINT16RC},
+	 .type = XTTYPE_UINT16RC, .excl = F_QUEUE_NUM},
 	{.name = "queue-bypass", .id = O_QUEUE_BYPASS, .type = XTTYPE_NONE},
 	XTOPT_TABLEEND,
 };
-- 
1.7.3.4

