From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 09/26] libxtables: XTTYPE_UINT16RC support
Date: Wed, 13 Apr 2011 18:13:30 +0200
Message-ID: <1302711228-15947-10-git-send-email-jengelh@medozas.de>
References: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42450 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932986Ab1DMQOA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:14:00 -0400
In-Reply-To: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |    2 ++
 xtoptions.c          |   28 +++++++++++++++++++++-------
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 30d9e73..ae76bb6 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -57,6 +57,7 @@ enum xt_option_type {
 	XTTYPE_UINT8,
 	XTTYPE_UINT32,
 	XTTYPE_UINT64,
+	XTTYPE_UINT16RC,
 	XTTYPE_UINT32RC,
 	XTTYPE_STRING,
 	XTTYPE_MARKMASK32,
@@ -115,6 +116,7 @@ struct xt_option_call {
 	uint8_t nvals;
 	union {
 		uint8_t u8;
+		uint16_t u16_range[2];
 		uint32_t u32, u32_range[2];
 		uint64_t u64;
 		struct {
diff --git a/xtoptions.c b/xtoptions.c
index f48c011..ca5bffa 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -133,15 +133,18 @@ static void xtopt_parse_mint(struct xt_option_call *cb)
 {
 	const struct xt_option_entry *entry = cb->entry;
 	const char *arg = cb->arg;
-	uint32_t *put = XTOPT_MKPTR(cb);
+	size_t esize = sizeof(uint32_t);
+	char *put = XTOPT_MKPTR(cb);
 	unsigned int maxiter, value;
 	char *end = "";
 	char sep = ':';
 
-	maxiter = entry->size / sizeof(uint32_t);
+	if (entry->type == XTTYPE_UINT16RC)
+		esize = sizeof(uint16_t);
+	maxiter = entry->size / esize;
 	if (maxiter == 0)
 		maxiter = 2; /* ARRAY_SIZE(cb->val.uXX_range) */
-	if (entry->size % sizeof(uint32_t) != 0)
+	if (entry->size % esize != 0)
 		xt_params->exit_err(OTHER_PROBLEM, "%s: memory block does "
 			"not have proper size\n", __func__);
 
@@ -161,10 +164,19 @@ static void xtopt_parse_mint(struct xt_option_call *cb)
 				"%s: Argument to \"--%s\" has unexpected "
 				"characters.\n", cb->ext_name, entry->name);
 		++cb->nvals;
-		if (cb->nvals < ARRAY_SIZE(cb->val.u32_range))
-			cb->val.u32_range[cb->nvals] = value;
-		if (entry->flags & XTOPT_PUT)
-			*put++ = value;
+		if (cb->nvals < ARRAY_SIZE(cb->val.u32_range)) {
+			if (entry->type == XTTYPE_UINT16RC)
+				cb->val.u16_range[cb->nvals] = value;
+			else if (entry->type == XTTYPE_UINT32RC)
+				cb->val.u32_range[cb->nvals] = value;
+		}
+		if (entry->flags & XTOPT_PUT) {
+			if (entry->type == XTTYPE_UINT16RC)
+				*(uint16_t *)put = value;
+			else if (entry->type == XTTYPE_UINT32RC)
+				*(uint32_t *)put = value;
+			put += esize;
+		}
 		if (*end == '\0')
 			break;
 	}
@@ -225,6 +237,7 @@ static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_UINT8]       = xtopt_parse_int,
 	[XTTYPE_UINT32]      = xtopt_parse_int,
 	[XTTYPE_UINT64]      = xtopt_parse_int,
+	[XTTYPE_UINT16RC]    = xtopt_parse_mint,
 	[XTTYPE_UINT32RC]    = xtopt_parse_mint,
 	[XTTYPE_STRING]      = xtopt_parse_string,
 	[XTTYPE_MARKMASK32]  = xtopt_parse_markmask,
@@ -234,6 +247,7 @@ static const size_t xtopt_psize[] = {
 	[XTTYPE_UINT8]       = sizeof(uint8_t),
 	[XTTYPE_UINT32]      = sizeof(uint32_t),
 	[XTTYPE_UINT64]      = sizeof(uint64_t),
+	[XTTYPE_UINT16RC]    = sizeof(uint16_t[2]),
 	[XTTYPE_UINT32RC]    = sizeof(uint32_t[2]),
 	[XTTYPE_STRING]      = -1,
 };
-- 
1.7.1

