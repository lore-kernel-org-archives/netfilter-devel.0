From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 13/24] libxt_u32: --u32 option is required
Date: Wed, 25 May 2011 01:08:14 +0200
Message-ID: <1306278506-11463-14-git-send-email-jengelh@medozas.de>
References: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40955 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932831Ab1EXXIm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 19:08:42 -0400
In-Reply-To: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
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

