From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 12/26] libxtables: XTTYPE_UINT8RC support
Date: Wed, 13 Apr 2011 18:13:33 +0200
Message-ID: <1302711228-15947-13-git-send-email-jengelh@medozas.de>
References: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42457 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933063Ab1DMQOD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:14:03 -0400
In-Reply-To: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |    3 ++-
 xtoptions.c          |   14 +++++++++++---
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index ae76bb6..8f65b05 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -57,6 +57,7 @@ enum xt_option_type {
 	XTTYPE_UINT8,
 	XTTYPE_UINT32,
 	XTTYPE_UINT64,
+	XTTYPE_UINT8RC,
 	XTTYPE_UINT16RC,
 	XTTYPE_UINT32RC,
 	XTTYPE_STRING,
@@ -115,7 +116,7 @@ struct xt_option_call {
 	bool invert;
 	uint8_t nvals;
 	union {
-		uint8_t u8;
+		uint8_t u8, u8_range[2];
 		uint16_t u16_range[2];
 		uint32_t u32, u32_range[2];
 		uint64_t u64;
diff --git a/xtoptions.c b/xtoptions.c
index ca5bffa..babc827 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -139,7 +139,9 @@ static void xtopt_parse_mint(struct xt_option_call *cb)
 	char *end = "";
 	char sep = ':';
 
-	if (entry->type == XTTYPE_UINT16RC)
+	if (entry->type == XTTYPE_UINT8RC)
+		esize = sizeof(uint8_t);
+	else if (entry->type == XTTYPE_UINT16RC)
 		esize = sizeof(uint16_t);
 	maxiter = entry->size / esize;
 	if (maxiter == 0)
@@ -165,13 +167,17 @@ static void xtopt_parse_mint(struct xt_option_call *cb)
 				"characters.\n", cb->ext_name, entry->name);
 		++cb->nvals;
 		if (cb->nvals < ARRAY_SIZE(cb->val.u32_range)) {
-			if (entry->type == XTTYPE_UINT16RC)
+			if (entry->type == XTTYPE_UINT8RC)
+				cb->val.u8_range[cb->nvals] = value;
+			else if (entry->type == XTTYPE_UINT16RC)
 				cb->val.u16_range[cb->nvals] = value;
 			else if (entry->type == XTTYPE_UINT32RC)
 				cb->val.u32_range[cb->nvals] = value;
 		}
 		if (entry->flags & XTOPT_PUT) {
-			if (entry->type == XTTYPE_UINT16RC)
+			if (entry->type == XTTYPE_UINT8RC)
+				*(uint8_t *)put = value;
+			else if (entry->type == XTTYPE_UINT16RC)
 				*(uint16_t *)put = value;
 			else if (entry->type == XTTYPE_UINT32RC)
 				*(uint32_t *)put = value;
@@ -237,6 +243,7 @@ static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_UINT8]       = xtopt_parse_int,
 	[XTTYPE_UINT32]      = xtopt_parse_int,
 	[XTTYPE_UINT64]      = xtopt_parse_int,
+	[XTTYPE_UINT8RC]     = xtopt_parse_mint,
 	[XTTYPE_UINT16RC]    = xtopt_parse_mint,
 	[XTTYPE_UINT32RC]    = xtopt_parse_mint,
 	[XTTYPE_STRING]      = xtopt_parse_string,
@@ -247,6 +254,7 @@ static const size_t xtopt_psize[] = {
 	[XTTYPE_UINT8]       = sizeof(uint8_t),
 	[XTTYPE_UINT32]      = sizeof(uint32_t),
 	[XTTYPE_UINT64]      = sizeof(uint64_t),
+	[XTTYPE_UINT8RC]     = sizeof(uint8_t[2]),
 	[XTTYPE_UINT16RC]    = sizeof(uint16_t[2]),
 	[XTTYPE_UINT32RC]    = sizeof(uint32_t[2]),
 	[XTTYPE_STRING]      = -1,
-- 
1.7.1

