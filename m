From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 04/26] libxtables: XTTYPE_UINT64 support
Date: Wed, 13 Apr 2011 18:13:25 +0200
Message-ID: <1302711228-15947-5-git-send-email-jengelh@medozas.de>
References: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42439 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933050Ab1DMQNy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:13:54 -0400
In-Reply-To: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |    2 ++
 xtoptions.c          |   12 ++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 2fa5977..c361bdb 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -56,6 +56,7 @@ enum xt_option_type {
 	XTTYPE_NONE,
 	XTTYPE_UINT8,
 	XTTYPE_UINT32,
+	XTTYPE_UINT64,
 	XTTYPE_UINT32RC,
 	XTTYPE_STRING,
 	XTTYPE_MARKMASK32,
@@ -115,6 +116,7 @@ struct xt_option_call {
 	union {
 		uint8_t u8;
 		uint32_t u32, u32_range[2];
+		uint64_t u64;
 		struct {
 			uint32_t mark, mask;
 		};
diff --git a/xtoptions.c b/xtoptions.c
index e9bcaa8..4206314 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -86,11 +86,13 @@ xtables_options_xfrm(struct option *orig_opts, struct option *oldopts,
 static void xtopt_parse_int(struct xt_option_call *cb)
 {
 	const struct xt_option_entry *entry = cb->entry;
-	unsigned int lmin = 0, lmax = UINT32_MAX;
+	unsigned long long lmin = 0, lmax = UINT32_MAX;
 	unsigned int value;
 
 	if (entry->type == XTTYPE_UINT8)
 		lmax = UINT8_MAX;
+	else if (entry->type == XTTYPE_UINT64)
+		lmax = UINT64_MAX;
 	if (cb->entry->min != 0)
 		lmin = cb->entry->min;
 	if (cb->entry->max != 0)
@@ -99,7 +101,7 @@ static void xtopt_parse_int(struct xt_option_call *cb)
 	if (!xtables_strtoui(cb->arg, NULL, &value, lmin, lmax))
 		xt_params->exit_err(PARAMETER_PROBLEM,
 			"%s: bad value for option \"--%s\", "
-			"or out of range (%u-%u).\n",
+			"or out of range (%llu-%llu).\n",
 			cb->ext_name, entry->name, lmin, lmax);
 
 	if (entry->type == XTTYPE_UINT8) {
@@ -110,6 +112,10 @@ static void xtopt_parse_int(struct xt_option_call *cb)
 		cb->val.u32 = value;
 		if (entry->flags & XTOPT_PUT)
 			*(uint32_t *)XTOPT_MKPTR(cb) = cb->val.u32;
+	} else if (entry->type == XTTYPE_UINT64) {
+		cb->val.u64 = value;
+		if (entry->flags & XTOPT_PUT)
+			*(uint64_t *)XTOPT_MKPTR(cb) = cb->val.u64;
 	}
 }
 
@@ -217,6 +223,7 @@ static void xtopt_parse_markmask(struct xt_option_call *cb)
 static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_UINT8]       = xtopt_parse_int,
 	[XTTYPE_UINT32]      = xtopt_parse_int,
+	[XTTYPE_UINT64]      = xtopt_parse_int,
 	[XTTYPE_UINT32RC]    = xtopt_parse_mint,
 	[XTTYPE_STRING]      = xtopt_parse_string,
 	[XTTYPE_MARKMASK32]  = xtopt_parse_markmask,
@@ -225,6 +232,7 @@ static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 static const size_t xtopt_psize[] = {
 	[XTTYPE_UINT8]       = sizeof(uint8_t),
 	[XTTYPE_UINT32]      = sizeof(uint32_t),
+	[XTTYPE_UINT64]      = sizeof(uint64_t),
 	[XTTYPE_UINT32RC]    = sizeof(uint32_t[2]),
 	[XTTYPE_STRING]      = -1,
 };
-- 
1.7.1

