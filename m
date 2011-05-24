From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 06/10] libxt_u32: --u32 option is required
Date: Tue, 24 May 2011 03:21:37 +0200
Message-ID: <1306200102-12148-7-git-send-email-jengelh@medozas.de>
References: <1306200102-12148-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:41747 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031092Ab1EXBVv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 May 2011 21:21:51 -0400
In-Reply-To: <1306200102-12148-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_u32.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_u32.c b/extensions/libxt_u32.c
index 9198edc..774d5ea 100644
--- a/extensions/libxt_u32.c
+++ b/extensions/libxt_u32.c
@@ -23,7 +23,8 @@ enum {
 };
 
 static const struct xt_option_entry u32_opts[] = {
-	{.name = "u32", .id = O_U32, .type = XTTYPE_STRING},
+	{.name = "u32", .id = O_U32, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND},
 	XTOPT_TABLEEND,
 };
 
-- 
1.7.3.4

