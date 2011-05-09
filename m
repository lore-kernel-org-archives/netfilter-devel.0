From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 01/13] libxt_tos: add inversion support back again
Date: Mon,  9 May 2011 11:36:59 +0200
Message-ID: <1304933832-16412-2-git-send-email-jengelh@medozas.de>
References: <1304933832-16412-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51658 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205Ab1EIJhQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 05:37:16 -0400
In-Reply-To: <1304933832-16412-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It was unfortunately removed during the option parser switch.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_tos.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_tos.c b/extensions/libxt_tos.c
index 7646a4f..81c096f 100644
--- a/extensions/libxt_tos.c
+++ b/extensions/libxt_tos.c
@@ -26,13 +26,13 @@ enum {
 
 static const struct xt_option_entry tos_mt_opts_v0[] = {
 	{.name = "tos", .id = O_TOS, .type = XTTYPE_TOSMASK,
-	 .flags = XTOPT_MAND, .max = 0xFF},
+	 .flags = XTOPT_INVERT | XTOPT_MAND, .max = 0xFF},
 	XTOPT_TABLEEND,
 };
 
 static const struct xt_option_entry tos_mt_opts[] = {
 	{.name = "tos", .id = O_TOS, .type = XTTYPE_TOSMASK,
-	 .flags = XTOPT_MAND, .max = 0x3F},
+	 .flags = XTOPT_INVERT | XTOPT_MAND, .max = 0x3F},
 	XTOPT_TABLEEND,
 };
 
-- 
1.7.1

