From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 03/13] libxt_quota: readd missing XTOPT_PUT request
Date: Mon, 23 May 2011 16:39:13 +0200
Message-ID: <1306161564-4370-4-git-send-email-jengelh@medozas.de>
References: <1306161564-4370-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:44611 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441Ab1EWOj3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 May 2011 10:39:29 -0400
In-Reply-To: <1306161564-4370-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_quota.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_quota.c b/extensions/libxt_quota.c
index 988f404..ff498da 100644
--- a/extensions/libxt_quota.c
+++ b/extensions/libxt_quota.c
@@ -13,7 +13,8 @@ enum {
 
 static const struct xt_option_entry quota_opts[] = {
 	{.name = "quota", .id = O_QUOTA, .type = XTTYPE_UINT64,
-	 .flags = XTOPT_MAND | XTOPT_INVERT},
+	 .flags = XTOPT_MAND | XTOPT_INVERT | XTOPT_PUT,
+	 XTOPT_POINTER(struct xt_quota_info, quota)},
 	XTOPT_TABLEEND,
 };
 
-- 
1.7.3.4

