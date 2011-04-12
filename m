From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 04/28] libxtables: XTTYPE_UINT32RC support
Date: Tue, 12 Apr 2011 16:23:19 +0200
Message-ID: <1302618224-9449-5-git-send-email-jengelh@medozas.de>
References: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51082 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755899Ab1DLOXu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:23:50 -0400
In-Reply-To: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |    6 ++++-
 xtoptions.c          |   55 +++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index dc074bc..3e596e0 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -48,11 +48,13 @@ struct in_addr;
 /**
  * %XTTYPE_NONE:	option takes no argument
  * %XTTYPE_UINT*:	standard integer
+ * %XTTYPE_UINT*RC:	colon-separated range of standard integers
  */
 enum xt_option_type {
 	XTTYPE_NONE,
 	XTTYPE_UINT8,
 	XTTYPE_UINT32,
+	XTTYPE_UINT32RC,
 };
 
 /**
@@ -96,6 +98,7 @@ struct xt_option_entry {
  * @data:	per-extension data block
  * @xflags:	options of the extension that have been used
  * @invert:	whether option was used with !
+ * @nvals:	number of results in uXX_multi
  * @val:	parsed result
  */
 struct xt_option_call {
@@ -104,9 +107,10 @@ struct xt_option_call {
 	void *data;
 	unsigned int xflags;
 	bool invert;
+	uint8_t nvals;
 	union {
 		uint8_t u8;
-		uint32_t u32;
+		uint32_t u32, u32_range[2];
 	} val;
 };
 
diff --git a/xtoptions.c b/xtoptions.c
index 693c06d..03c629e 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -113,14 +113,66 @@ static void xtopt_parse_int(struct xt_option_call *cb)
 	}
 }
 
+/**
+ * Multiple integer parse routine.
+ *
+ * This function is capable of parsing any number of fields. Only the first
+ * two values from the string will be put into @cb however (and as such,
+ * @cb->val.uXX_range is just that large) to cater for the few extensions that
+ * do not have a range[2] field, but {min, max}, and which cannot use
+ * XTOPT_POINTER.
+ */
+static void xtopt_parse_mint(struct xt_option_call *cb)
+{
+	const struct xt_option_entry *entry = cb->entry;
+	const char *arg = cb->arg;
+	uint32_t *put = XTOPT_MKPTR(cb);
+	unsigned int maxiter, value;
+	char *end = "";
+	char sep = ':';
+
+	maxiter = entry->size / sizeof(uint32_t);
+	if (maxiter == 0)
+		maxiter = 2; /* ARRAY_SIZE(cb->val.uXX_range) */
+	if (entry->size % sizeof(uint32_t) != 0)
+		xt_params->exit_err(OTHER_PROBLEM, "%s: memory block does "
+			"not have proper size\n", __func__);
+
+	cb->nvals = 0;
+	for (arg = cb->arg; ; arg = end + 1) {
+		if (cb->nvals == maxiter)
+			xt_params->exit_err(PARAMETER_PROBLEM, "%s: Too many "
+				"components for option \"--%s\" (max: %u)\n",
+				cb->ext_name, entry->name, maxiter);
+		if (!xtables_strtoui(arg, &end, &value, 0, UINT32_MAX))
+			xt_params->exit_err(PARAMETER_PROBLEM,
+				"%s: bad value for option \"--%s\", "
+				"or out of range (0-%u).\n",
+				cb->ext_name, entry->name, UINT32_MAX);
+		if (*end != '\0' && *end != sep)
+			xt_params->exit_err(PARAMETER_PROBLEM,
+				"%s: Argument to \"--%s\" has unexpected "
+				"characters.\n", cb->ext_name, entry->name);
+		++cb->nvals;
+		if (cb->nvals < ARRAY_SIZE(cb->val.u32_range))
+			cb->val.u32_range[cb->nvals] = value;
+		if (entry->flags & XTOPT_PUT)
+			*put++ = value;
+		if (*end == '\0')
+			break;
+	}
+}
+
 static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_UINT8]       = xtopt_parse_int,
 	[XTTYPE_UINT32]      = xtopt_parse_int,
+	[XTTYPE_UINT32RC]    = xtopt_parse_mint,
 };
 
 static const size_t xtopt_psize[] = {
 	[XTTYPE_UINT8]       = sizeof(uint8_t),
 	[XTTYPE_UINT32]      = sizeof(uint32_t),
+	[XTTYPE_UINT32RC]    = sizeof(uint32_t[2]),
 };
 
 /**
@@ -180,7 +232,8 @@ void xtables_option_metavalidate(const char *name,
 				"%s: entry type of option \"--%s\" cannot be "
 				"combined with XTOPT_PUT\n",
 				name, entry->name);
-		if (xtopt_psize[entry->type] != entry->size)
+		if (xtopt_psize[entry->type] != -1 &&
+		    xtopt_psize[entry->type] != entry->size)
 			xt_params->exit_err(OTHER_PROBLEM,
 				"%s: option \"--%s\" points to a memory block "
 				"of wrong size (expected %zu, got %zu)\n",
-- 
1.7.1

