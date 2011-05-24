From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 18/24] libxtables: unclutter xtopt_parse_mint
Date: Wed, 25 May 2011 01:08:19 +0200
Message-ID: <1306278506-11463-19-git-send-email-jengelh@medozas.de>
References: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40979 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab1EXXIr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 19:08:47 -0400
In-Reply-To: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

..by moving type-based actions into their own function.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 xtoptions.c |  148 +++++++++++++++++++++++++++++++++++++---------------------
 1 files changed, 94 insertions(+), 54 deletions(-)

diff --git a/xtoptions.c b/xtoptions.c
index 1fc90ee..30d70b0 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -41,6 +41,31 @@ struct tos_value_mask {
 	uint8_t value, mask;
 };
 
+static const size_t xtopt_psize[] = {
+	/*
+	 * All types not listed here, and thus essentially being initialized to
+	 * zero have zero on purpose.
+	 */
+	[XTTYPE_UINT8]       = sizeof(uint8_t),
+	[XTTYPE_UINT16]      = sizeof(uint16_t),
+	[XTTYPE_UINT32]      = sizeof(uint32_t),
+	[XTTYPE_UINT64]      = sizeof(uint64_t),
+	[XTTYPE_UINT8RC]     = sizeof(uint8_t[2]),
+	[XTTYPE_UINT16RC]    = sizeof(uint16_t[2]),
+	[XTTYPE_UINT32RC]    = sizeof(uint32_t[2]),
+	[XTTYPE_UINT64RC]    = sizeof(uint64_t[2]),
+	[XTTYPE_DOUBLE]      = sizeof(double),
+	[XTTYPE_STRING]      = -1,
+	[XTTYPE_SYSLOGLEVEL] = sizeof(uint8_t),
+	[XTTYPE_HOST]        = sizeof(union nf_inet_addr),
+	[XTTYPE_HOSTMASK]    = sizeof(union nf_inet_addr),
+	[XTTYPE_PROTOCOL]    = sizeof(uint8_t),
+	[XTTYPE_PORT]        = sizeof(uint16_t),
+	[XTTYPE_PORTRC]      = sizeof(uint16_t[2]),
+	[XTTYPE_PLENMASK]    = sizeof(union nf_inet_addr),
+	[XTTYPE_ETHERMAC]    = sizeof(uint8_t[6]),
+};
+
 /**
  * Creates getopt options from the x6-style option map, and assigns each a
  * getopt id.
@@ -98,6 +123,9 @@ xtables_options_xfrm(struct option *orig_opts, struct option *oldopts,
 	return merge;
 }
 
+/**
+ * Give the upper limit for a certain type.
+ */
 static uintmax_t xtopt_max_by_type(enum xt_option_type type)
 {
 	switch (type) {
@@ -119,6 +147,26 @@ static uintmax_t xtopt_max_by_type(enum xt_option_type type)
 }
 
 /**
+ * Return the size of a single entity based upon a type - predominantly an
+ * XTTYPE_UINT*RC type.
+ */
+static size_t xtopt_esize_by_type(enum xt_option_type type)
+{
+	switch (type) {
+	case XTTYPE_UINT8RC:
+		return xtopt_psize[XTTYPE_UINT8];
+	case XTTYPE_UINT16RC:
+		return xtopt_psize[XTTYPE_UINT16];
+	case XTTYPE_UINT32RC:
+		return xtopt_psize[XTTYPE_UINT32];
+	case XTTYPE_UINT64RC:
+		return xtopt_psize[XTTYPE_UINT64];
+	default:
+		return xtopt_psize[type];
+	}
+}
+
+/**
  * Require a simple integer.
  */
 static void xtopt_parse_int(struct xt_option_call *cb)
@@ -181,6 +229,48 @@ static void xtopt_parse_float(struct xt_option_call *cb)
 }
 
 /**
+ * Copy the parsed value to the appropriate entry in cb->val.
+ */
+static void xtopt_mint_value_to_cb(struct xt_option_call *cb, uintmax_t value)
+{
+	const struct xt_option_entry *entry = cb->entry;
+
+	if (cb->nvals >= ARRAY_SIZE(cb->val.u32_range))
+		return;
+	if (entry->type == XTTYPE_UINT8RC)
+		cb->val.u8_range[cb->nvals] = value;
+	else if (entry->type == XTTYPE_UINT16RC)
+		cb->val.u16_range[cb->nvals] = value;
+	else if (entry->type == XTTYPE_UINT32RC)
+		cb->val.u32_range[cb->nvals] = value;
+	else if (entry->type == XTTYPE_UINT64RC)
+		cb->val.u64_range[cb->nvals] = value;
+}
+
+/**
+ * Copy the parsed value to the data area, using appropriate type access.
+ */
+static void xtopt_mint_value_to_ptr(struct xt_option_call *cb, void **datap,
+				    uintmax_t value)
+{
+	const struct xt_option_entry *entry = cb->entry;
+	void *data = *datap;
+
+	if (!(entry->flags & XTOPT_PUT))
+		return;
+	if (entry->type == XTTYPE_UINT8RC)
+		*(uint8_t *)data = value;
+	else if (entry->type == XTTYPE_UINT16RC)
+		*(uint16_t *)data = value;
+	else if (entry->type == XTTYPE_UINT32RC)
+		*(uint32_t *)data = value;
+	else if (entry->type == XTTYPE_UINT64RC)
+		*(uint64_t *)data = value;
+	data += xtopt_esize_by_type(entry->type);
+	*datap = data;
+}
+
+/**
  * Multiple integer parse routine.
  *
  * This function is capable of parsing any number of fields. Only the first
@@ -193,20 +283,14 @@ static void xtopt_parse_mint(struct xt_option_call *cb)
 {
 	const struct xt_option_entry *entry = cb->entry;
 	const char *arg = cb->arg;
-	size_t esize = sizeof(uint32_t);
+	size_t esize = xtopt_esize_by_type(entry->type);
 	uintmax_t lmax = xtopt_max_by_type(entry->type);
-	char *put = XTOPT_MKPTR(cb);
+	void *put = XTOPT_MKPTR(cb);
 	unsigned int maxiter;
 	uintmax_t value;
 	char *end = "";
 	char sep = ':';
 
-	if (entry->type == XTTYPE_UINT8RC)
-		esize = sizeof(uint8_t);
-	else if (entry->type == XTTYPE_UINT16RC)
-		esize = sizeof(uint16_t);
-	else if (entry->type == XTTYPE_UINT64RC)
-		esize = sizeof(uint64_t);
 	maxiter = entry->size / esize;
 	if (maxiter == 0)
 		maxiter = 2; /* ARRAY_SIZE(cb->val.uXX_range) */
@@ -230,28 +314,9 @@ static void xtopt_parse_mint(struct xt_option_call *cb)
 				"%s: Argument to \"--%s\" has unexpected "
 				"characters near \"%s\".\n",
 				cb->ext_name, entry->name, end);
-		if (cb->nvals < ARRAY_SIZE(cb->val.u32_range)) {
-			if (entry->type == XTTYPE_UINT8RC)
-				cb->val.u8_range[cb->nvals] = value;
-			else if (entry->type == XTTYPE_UINT16RC)
-				cb->val.u16_range[cb->nvals] = value;
-			else if (entry->type == XTTYPE_UINT32RC)
-				cb->val.u32_range[cb->nvals] = value;
-			else if (entry->type == XTTYPE_UINT64RC)
-				cb->val.u64_range[cb->nvals] = value;
-		}
+		xtopt_mint_value_to_cb(cb, value);
 		++cb->nvals;
-		if (entry->flags & XTOPT_PUT) {
-			if (entry->type == XTTYPE_UINT8RC)
-				*(uint8_t *)put = value;
-			else if (entry->type == XTTYPE_UINT16RC)
-				*(uint16_t *)put = value;
-			else if (entry->type == XTTYPE_UINT32RC)
-				*(uint32_t *)put = value;
-			else if (entry->type == XTTYPE_UINT64RC)
-				*(uint64_t *)put = value;
-			put += esize;
-		}
+		xtopt_mint_value_to_ptr(cb, &put, value);
 		if (*end == '\0')
 			break;
 	}
@@ -726,31 +791,6 @@ static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_ETHERMAC]    = xtopt_parse_ethermac,
 };
 
-static const size_t xtopt_psize[] = {
-	/*
-	 * All types not listed here, and thus essentially being initialized to
-	 * zero have zero on purpose.
-	 */
-	[XTTYPE_UINT8]       = sizeof(uint8_t),
-	[XTTYPE_UINT16]      = sizeof(uint16_t),
-	[XTTYPE_UINT32]      = sizeof(uint32_t),
-	[XTTYPE_UINT64]      = sizeof(uint64_t),
-	[XTTYPE_UINT8RC]     = sizeof(uint8_t[2]),
-	[XTTYPE_UINT16RC]    = sizeof(uint16_t[2]),
-	[XTTYPE_UINT32RC]    = sizeof(uint32_t[2]),
-	[XTTYPE_UINT64RC]    = sizeof(uint64_t[2]),
-	[XTTYPE_DOUBLE]      = sizeof(double),
-	[XTTYPE_STRING]      = -1,
-	[XTTYPE_SYSLOGLEVEL] = sizeof(uint8_t),
-	[XTTYPE_HOST]        = sizeof(union nf_inet_addr),
-	[XTTYPE_HOSTMASK]    = sizeof(union nf_inet_addr),
-	[XTTYPE_PROTOCOL]    = sizeof(uint8_t),
-	[XTTYPE_PORT]        = sizeof(uint16_t),
-	[XTTYPE_PORTRC]      = sizeof(uint16_t[2]),
-	[XTTYPE_PLENMASK]    = sizeof(union nf_inet_addr),
-	[XTTYPE_ETHERMAC]    = sizeof(uint8_t[6]),
-};
-
 /**
  * The master option parsing routine. May be used for the ".x6_parse"
  * function pointer in extensions if fully automatic parsing is desired.
-- 
1.7.3.4

