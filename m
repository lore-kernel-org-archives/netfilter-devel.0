From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 13/26] libxtables: XTTYPE_UINT64RC support
Date: Wed, 13 Apr 2011 18:13:34 +0200
Message-ID: <1302711228-15947-14-git-send-email-jengelh@medozas.de>
References: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42459 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933064Ab1DMQOE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:14:04 -0400
In-Reply-To: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |    3 ++-
 xtoptions.c          |    8 ++++++++
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 8f65b05..325c04c 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -60,6 +60,7 @@ enum xt_option_type {
 	XTTYPE_UINT8RC,
 	XTTYPE_UINT16RC,
 	XTTYPE_UINT32RC,
+	XTTYPE_UINT64RC,
 	XTTYPE_STRING,
 	XTTYPE_MARKMASK32,
 };
@@ -119,7 +120,7 @@ struct xt_option_call {
 		uint8_t u8, u8_range[2];
 		uint16_t u16_range[2];
 		uint32_t u32, u32_range[2];
-		uint64_t u64;
+		uint64_t u64, u64_range[2];
 		struct {
 			uint32_t mark, mask;
 		};
diff --git a/xtoptions.c b/xtoptions.c
index babc827..a74938f 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -143,6 +143,8 @@ static void xtopt_parse_mint(struct xt_option_call *cb)
 		esize = sizeof(uint8_t);
 	else if (entry->type == XTTYPE_UINT16RC)
 		esize = sizeof(uint16_t);
+	else if (entry->type == XTTYPE_UINT64RC)
+		esize = sizeof(uint64_t);
 	maxiter = entry->size / esize;
 	if (maxiter == 0)
 		maxiter = 2; /* ARRAY_SIZE(cb->val.uXX_range) */
@@ -173,6 +175,8 @@ static void xtopt_parse_mint(struct xt_option_call *cb)
 				cb->val.u16_range[cb->nvals] = value;
 			else if (entry->type == XTTYPE_UINT32RC)
 				cb->val.u32_range[cb->nvals] = value;
+			else if (entry->type == XTTYPE_UINT64RC)
+				cb->val.u64_range[cb->nvals] = value;
 		}
 		if (entry->flags & XTOPT_PUT) {
 			if (entry->type == XTTYPE_UINT8RC)
@@ -181,6 +185,8 @@ static void xtopt_parse_mint(struct xt_option_call *cb)
 				*(uint16_t *)put = value;
 			else if (entry->type == XTTYPE_UINT32RC)
 				*(uint32_t *)put = value;
+			else if (entry->type == XTTYPE_UINT64RC)
+				*(uint64_t *)put = value;
 			put += esize;
 		}
 		if (*end == '\0')
@@ -246,6 +252,7 @@ static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_UINT8RC]     = xtopt_parse_mint,
 	[XTTYPE_UINT16RC]    = xtopt_parse_mint,
 	[XTTYPE_UINT32RC]    = xtopt_parse_mint,
+	[XTTYPE_UINT64RC]    = xtopt_parse_mint,
 	[XTTYPE_STRING]      = xtopt_parse_string,
 	[XTTYPE_MARKMASK32]  = xtopt_parse_markmask,
 };
@@ -257,6 +264,7 @@ static const size_t xtopt_psize[] = {
 	[XTTYPE_UINT8RC]     = sizeof(uint8_t[2]),
 	[XTTYPE_UINT16RC]    = sizeof(uint16_t[2]),
 	[XTTYPE_UINT32RC]    = sizeof(uint32_t[2]),
+	[XTTYPE_UINT64RC]    = sizeof(uint64_t[2]),
 	[XTTYPE_STRING]      = -1,
 };
 
-- 
1.7.1

