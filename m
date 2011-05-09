From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 10/13] libxtables: XTTYPE_DOUBLE support
Date: Mon,  9 May 2011 11:37:08 +0200
Message-ID: <1304933832-16412-11-git-send-email-jengelh@medozas.de>
References: <1304933832-16412-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51681 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab1EIJhZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 05:37:25 -0400
In-Reply-To: <1304933832-16412-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |    3 +++
 xtoptions.c          |   25 +++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index da8d84c..47f797b 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -49,6 +49,7 @@ struct in_addr;
  * %XTTYPE_NONE:	option takes no argument
  * %XTTYPE_UINT*:	standard integer
  * %XTTYPE_UINT*RC:	colon-separated range of standard integers
+ * %XTTYPE_DOUBLE:	double-precision floating point number
  * %XTTYPE_STRING:	arbitrary string
  * %XTTYPE_TOSMASK:	8-bit TOS value with optional mask
  * %XTTYPE_MARKMASK32:	32-bit mark with optional mask
@@ -69,6 +70,7 @@ enum xt_option_type {
 	XTTYPE_UINT16RC,
 	XTTYPE_UINT32RC,
 	XTTYPE_UINT64RC,
+	XTTYPE_DOUBLE,
 	XTTYPE_STRING,
 	XTTYPE_TOSMASK,
 	XTTYPE_MARKMASK32,
@@ -136,6 +138,7 @@ struct xt_option_call {
 		uint16_t u16, u16_range[2], port, port_range[2];
 		uint32_t u32, u32_range[2];
 		uint64_t u64, u64_range[2];
+		double dbl;
 		union nf_inet_addr inetaddr;
 		struct {
 			uint8_t tos_value, tos_mask;
diff --git a/xtoptions.c b/xtoptions.c
index 1cfc844..86498a9 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -144,6 +144,29 @@ static void xtopt_parse_int(struct xt_option_call *cb)
 }
 
 /**
+ * Require a simple floating point number.
+ */
+static void xtopt_parse_float(struct xt_option_call *cb)
+{
+	const struct xt_option_entry *entry = cb->entry;
+	double value;
+	char *end;
+
+	value = strtod(cb->arg, &end);
+	if (end == cb->arg || *end != '\0' ||
+	    (entry->min != entry->max &&
+	    (value < entry->min || value > entry->max)))
+		xt_params->exit_err(PARAMETER_PROBLEM,
+			"%s: bad value for option \"--%s\", "
+			"or out of range (%u-%u).\n",
+			cb->ext_name, entry->name, entry->min, entry->max);
+
+	cb->val.dbl = value;
+	if (entry->flags & XTOPT_PUT)
+		*(double *)XTOPT_MKPTR(cb) = cb->val.dbl;
+}
+
+/**
  * Multiple integer parse routine.
  *
  * This function is capable of parsing any number of fields. Only the first
@@ -547,6 +570,7 @@ static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_UINT16RC]    = xtopt_parse_mint,
 	[XTTYPE_UINT32RC]    = xtopt_parse_mint,
 	[XTTYPE_UINT64RC]    = xtopt_parse_mint,
+	[XTTYPE_DOUBLE]      = xtopt_parse_float,
 	[XTTYPE_STRING]      = xtopt_parse_string,
 	[XTTYPE_TOSMASK]     = xtopt_parse_tosmask,
 	[XTTYPE_MARKMASK32]  = xtopt_parse_markmask,
@@ -567,6 +591,7 @@ static const size_t xtopt_psize[] = {
 	[XTTYPE_UINT16RC]    = sizeof(uint16_t[2]),
 	[XTTYPE_UINT32RC]    = sizeof(uint32_t[2]),
 	[XTTYPE_UINT64RC]    = sizeof(uint64_t[2]),
+	[XTTYPE_DOUBLE]      = sizeof(double),
 	[XTTYPE_STRING]      = -1,
 	[XTTYPE_SYSLOGLEVEL] = sizeof(uint8_t),
 	[XTTYPE_ONEHOST]     = sizeof(union nf_inet_addr),
-- 
1.7.1

