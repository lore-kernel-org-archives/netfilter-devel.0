From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 21/26] libxtables: XTTYPE_SYSLOGLEVEL support
Date: Wed, 13 Apr 2011 18:13:42 +0200
Message-ID: <1302711228-15947-22-git-send-email-jengelh@medozas.de>
References: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42470 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933079Ab1DMQOM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:14:12 -0400
In-Reply-To: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |    4 +++-
 xtoptions.c          |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 1 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index afade14..afdac36 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -51,6 +51,7 @@ struct in_addr;
  * %XTTYPE_UINT*RC:	colon-separated range of standard integers
  * %XTTYPE_STRING:	arbitrary string
  * %XTTYPE_MARKMASK32:	32-bit mark with optional mask
+ * %XTTYPE_SYSLOGLEVEL:	syslog level by name or number
  */
 enum xt_option_type {
 	XTTYPE_NONE,
@@ -64,6 +65,7 @@ enum xt_option_type {
 	XTTYPE_UINT64RC,
 	XTTYPE_STRING,
 	XTTYPE_MARKMASK32,
+	XTTYPE_SYSLOGLEVEL,
 };
 
 /**
@@ -118,7 +120,7 @@ struct xt_option_call {
 	bool invert;
 	uint8_t nvals;
 	union {
-		uint8_t u8, u8_range[2];
+		uint8_t u8, u8_range[2], syslog_level;
 		uint16_t u16, u16_range[2];
 		uint32_t u32, u32_range[2];
 		uint64_t u64, u64_range[2];
diff --git a/xtoptions.c b/xtoptions.c
index b3acff9..a6738c1 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -17,6 +17,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <syslog.h>
 #include <arpa/inet.h>
 #include "xtables.h"
 #include "xshared.h"
@@ -25,6 +26,14 @@
 	((void *)((char *)(cb)->data + (cb)->entry->ptroff))
 
 /**
+ * Simple key-value pairs for syslog levels
+ */
+struct syslog_level {
+	char name[8];
+	uint8_t level;
+};
+
+/**
  * Creates getopt options from the x6-style option map, and assigns each a
  * getopt id.
  */
@@ -251,6 +260,43 @@ static void xtopt_parse_markmask(struct xt_option_call *cb)
 	cb->val.mask = mask;
 }
 
+static int xtopt_sysloglvl_compare(const void *a, const void *b)
+{
+	const char *name = a;
+	const struct syslog_level *entry = b;
+
+	return strcmp(name, entry->name);
+}
+
+static void xtopt_parse_sysloglevel(struct xt_option_call *cb)
+{
+	static const struct syslog_level log_names[] = { /* must be sorted */
+		{"alert",   LOG_ALERT},
+		{"crit",    LOG_CRIT},
+		{"debug",   LOG_DEBUG},
+		{"emerg",   LOG_EMERG},
+		{"error",   LOG_ERR}, /* deprecated */
+		{"info",    LOG_INFO},
+		{"notice",  LOG_NOTICE},
+		{"panic",   LOG_EMERG}, /* deprecated */
+		{"warning", LOG_WARNING},
+	};
+	const struct syslog_level *e;
+	unsigned int num = 0;
+
+	if (!xtables_strtoui(cb->arg, NULL, &num, 0, 7)) {
+		e = bsearch(cb->arg, log_names, ARRAY_SIZE(log_names),
+			    sizeof(*log_names), xtopt_sysloglvl_compare);
+		if (e == NULL)
+			xt_params->exit_err(PARAMETER_PROBLEM,
+				"log level \"%s\" unknown\n", cb->arg);
+		num = e->level;
+	}
+	cb->val.syslog_level = num;
+	if (cb->entry->flags & XTOPT_PUT)
+		*(uint8_t *)XTOPT_MKPTR(cb) = num;
+}
+
 static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_UINT8]       = xtopt_parse_int,
 	[XTTYPE_UINT16]      = xtopt_parse_int,
@@ -262,6 +308,7 @@ static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_UINT64RC]    = xtopt_parse_mint,
 	[XTTYPE_STRING]      = xtopt_parse_string,
 	[XTTYPE_MARKMASK32]  = xtopt_parse_markmask,
+	[XTTYPE_SYSLOGLEVEL] = xtopt_parse_sysloglevel,
 };
 
 static const size_t xtopt_psize[] = {
@@ -274,6 +321,7 @@ static const size_t xtopt_psize[] = {
 	[XTTYPE_UINT32RC]    = sizeof(uint32_t[2]),
 	[XTTYPE_UINT64RC]    = sizeof(uint64_t[2]),
 	[XTTYPE_STRING]      = -1,
+	[XTTYPE_SYSLOGLEVEL] = sizeof(uint8_t),
 };
 
 /**
-- 
1.7.1

