From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 02/13] libxtables: fix assignment in wrong offset (XTTYPE_UINT*RC)
Date: Mon,  9 May 2011 11:37:00 +0200
Message-ID: <1304933832-16412-3-git-send-email-jengelh@medozas.de>
References: <1304933832-16412-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51660 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205Ab1EIJhR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 05:37:17 -0400
In-Reply-To: <1304933832-16412-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 xtoptions.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/xtoptions.c b/xtoptions.c
index 5b1df88..1cfc844 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -190,7 +190,6 @@ static void xtopt_parse_mint(struct xt_option_call *cb)
 			xt_params->exit_err(PARAMETER_PROBLEM,
 				"%s: Argument to \"--%s\" has unexpected "
 				"characters.\n", cb->ext_name, entry->name);
-		++cb->nvals;
 		if (cb->nvals < ARRAY_SIZE(cb->val.u32_range)) {
 			if (entry->type == XTTYPE_UINT8RC)
 				cb->val.u8_range[cb->nvals] = value;
@@ -201,6 +200,7 @@ static void xtopt_parse_mint(struct xt_option_call *cb)
 			else if (entry->type == XTTYPE_UINT64RC)
 				cb->val.u64_range[cb->nvals] = value;
 		}
+		++cb->nvals;
 		if (entry->flags & XTOPT_PUT) {
 			if (entry->type == XTTYPE_UINT8RC)
 				*(uint8_t *)put = value;
-- 
1.7.1

