From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 03/24] libxt_quota: readd missing XTOPT_PUT request
Date: Wed, 25 May 2011 01:08:04 +0200
Message-ID: <1306278506-11463-4-git-send-email-jengelh@medozas.de>
References: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40920 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932170Ab1EXXIb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 19:08:31 -0400
In-Reply-To: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
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

