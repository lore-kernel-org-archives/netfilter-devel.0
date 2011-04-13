From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 01/26] libxtables: XTTYPE_MARKMASK32 support
Date: Wed, 13 Apr 2011 18:13:22 +0200
Message-ID: <1302711228-15947-2-git-send-email-jengelh@medozas.de>
References: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42509 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933047Ab1DMQNx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:13:53 -0400
In-Reply-To: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |    5 +++++
 xtoptions.c          |   29 +++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index c3c8da9..2fa5977 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -50,6 +50,7 @@ struct in_addr;
  * %XTTYPE_UINT*:	standard integer
  * %XTTYPE_UINT*RC:	colon-separated range of standard integers
  * %XTTYPE_STRING:	arbitrary string
+ * %XTTYPE_MARKMASK32:	32-bit mark with optional mask
  */
 enum xt_option_type {
 	XTTYPE_NONE,
@@ -57,6 +58,7 @@ enum xt_option_type {
 	XTTYPE_UINT32,
 	XTTYPE_UINT32RC,
 	XTTYPE_STRING,
+	XTTYPE_MARKMASK32,
 };
 
 /**
@@ -113,6 +115,9 @@ struct xt_option_call {
 	union {
 		uint8_t u8;
 		uint32_t u32, u32_range[2];
+		struct {
+			uint32_t mark, mask;
+		};
 	} val;
 };
 
diff --git a/xtoptions.c b/xtoptions.c
index 631e7a3..e9bcaa8 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -186,11 +186,40 @@ static void xtopt_parse_string(struct xt_option_call *cb)
 	p[z] = '\0';
 }
 
+/**
+ * Validate the input for being conformant to "mark[/mask]".
+ */
+static void xtopt_parse_markmask(struct xt_option_call *cb)
+{
+	unsigned int mark = 0, mask = ~0U;
+	char *end;
+
+	if (!xtables_strtoui(cb->arg, &end, &mark, 0, UINT32_MAX))
+		xt_params->exit_err(PARAMETER_PROBLEM,
+			"%s: bad mark value for option \"--%s\", "
+			"or out of range.\n",
+			cb->ext_name, cb->entry->name);
+	if (*end == '/' &&
+	    !xtables_strtoui(end + 1, &end, &mask, 0, UINT32_MAX))
+		xt_params->exit_err(PARAMETER_PROBLEM,
+			"%s: bad mask value for option \"--%s\", "
+			"or out of range.\n",
+			cb->ext_name, cb->entry->name);
+	if (*end != '\0')
+		xt_params->exit_err(PARAMETER_PROBLEM,
+			"%s: trailing garbage after value "
+			"for option \"--%s\".\n",
+			cb->ext_name, cb->entry->name);
+	cb->val.mark = mark;
+	cb->val.mask = mask;
+}
+
 static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_UINT8]       = xtopt_parse_int,
 	[XTTYPE_UINT32]      = xtopt_parse_int,
 	[XTTYPE_UINT32RC]    = xtopt_parse_mint,
 	[XTTYPE_STRING]      = xtopt_parse_string,
+	[XTTYPE_MARKMASK32]  = xtopt_parse_markmask,
 };
 
 static const size_t xtopt_psize[] = {
-- 
1.7.1

