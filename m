From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 10/10] libxtables: make multiint parser have greater range
Date: Tue, 24 May 2011 03:21:41 +0200
Message-ID: <1306200102-12148-11-git-send-email-jengelh@medozas.de>
References: <1306200102-12148-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:41771 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031105Ab1EXBVz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 May 2011 21:21:55 -0400
In-Reply-To: <1306200102-12148-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since parse_mint can handle XTTYPE_UINT64RC, it must allow numbers
larger than UINT32_MAX.

Cc: JP Abgrall <jpa@google.com>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 xtoptions.c |   38 +++++++++++++++++++++++++++-----------
 1 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/xtoptions.c b/xtoptions.c
index e9736a4..1fc90ee 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -98,21 +98,35 @@ xtables_options_xfrm(struct option *orig_opts, struct option *oldopts,
 	return merge;
 }
 
+static uintmax_t xtopt_max_by_type(enum xt_option_type type)
+{
+	switch (type) {
+	case XTTYPE_UINT8:
+	case XTTYPE_UINT8RC:
+		return UINT8_MAX;
+	case XTTYPE_UINT16:
+	case XTTYPE_UINT16RC:
+		return UINT16_MAX;
+	case XTTYPE_UINT32:
+	case XTTYPE_UINT32RC:
+		return UINT32_MAX;
+	case XTTYPE_UINT64:
+	case XTTYPE_UINT64RC:
+		return UINT64_MAX;
+	default:
+		return 0;
+	}
+}
+
 /**
  * Require a simple integer.
  */
 static void xtopt_parse_int(struct xt_option_call *cb)
 {
 	const struct xt_option_entry *entry = cb->entry;
-	uintmax_t lmin = 0, lmax = UINT32_MAX;
+	uintmax_t lmin = 0, lmax = xtopt_max_by_type(entry->type);
 	uintmax_t value;
 
-	if (entry->type == XTTYPE_UINT8)
-		lmax = UINT8_MAX;
-	else if (entry->type == XTTYPE_UINT16)
-		lmax = UINT16_MAX;
-	else if (entry->type == XTTYPE_UINT64)
-		lmax = UINT64_MAX;
 	if (cb->entry->min != 0)
 		lmin = cb->entry->min;
 	if (cb->entry->max != 0)
@@ -180,8 +194,10 @@ static void xtopt_parse_mint(struct xt_option_call *cb)
 	const struct xt_option_entry *entry = cb->entry;
 	const char *arg = cb->arg;
 	size_t esize = sizeof(uint32_t);
+	uintmax_t lmax = xtopt_max_by_type(entry->type);
 	char *put = XTOPT_MKPTR(cb);
-	unsigned int maxiter, value;
+	unsigned int maxiter;
+	uintmax_t value;
 	char *end = "";
 	char sep = ':';
 
@@ -204,11 +220,11 @@ static void xtopt_parse_mint(struct xt_option_call *cb)
 			xt_params->exit_err(PARAMETER_PROBLEM, "%s: Too many "
 				"components for option \"--%s\" (max: %u)\n",
 				cb->ext_name, entry->name, maxiter);
-		if (!xtables_strtoui(arg, &end, &value, 0, UINT32_MAX))
+		if (!xtables_strtoul(arg, &end, &value, 0, lmax))
 			xt_params->exit_err(PARAMETER_PROBLEM,
 				"%s: bad value for option \"--%s\" near "
-				"\"%s\", or out of range (0-%u).\n",
-				cb->ext_name, entry->name, arg, UINT32_MAX);
+				"\"%s\", or out of range (0-%ju).\n",
+				cb->ext_name, entry->name, arg, lmax);
 		if (*end != '\0' && *end != sep)
 			xt_params->exit_err(PARAMETER_PROBLEM,
 				"%s: Argument to \"--%s\" has unexpected "
-- 
1.7.3.4

