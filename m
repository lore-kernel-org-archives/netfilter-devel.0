From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 03/17] libxt_recent: use guided option parser
Date: Mon,  9 May 2011 21:54:57 +0200
Message-ID: <1304970912-11520-4-git-send-email-jengelh@medozas.de>
References: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49335 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585Ab1EITzT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 15:55:19 -0400
In-Reply-To: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_recent.c |  186 +++++++++++++++++++--------------------------
 1 files changed, 79 insertions(+), 107 deletions(-)

diff --git a/extensions/libxt_recent.c b/extensions/libxt_recent.c
index f8a5a18..1e1a111 100644
--- a/extensions/libxt_recent.c
+++ b/extensions/libxt_recent.c
@@ -1,27 +1,50 @@
-/* Shared library add-on to iptables to add recent matching support. */
 #include <stdbool.h>
 #include <stdio.h>
-#include <netdb.h>
 #include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
 #include <xtables.h>
 #include <linux/netfilter/xt_recent.h>
 
-static const struct option recent_opts[] = {
-	{.name = "set",      .has_arg = false, .val = 201},
-	{.name = "rcheck",   .has_arg = false, .val = 202},
-	{.name = "update",   .has_arg = false, .val = 203},
-	{.name = "seconds",  .has_arg = true,  .val = 204},
-	{.name = "hitcount", .has_arg = true,  .val = 205},
-	{.name = "remove",   .has_arg = false, .val = 206},
-	{.name = "rttl",     .has_arg = false, .val = 207},
-	{.name = "name",     .has_arg = true,  .val = 208},
-	{.name = "rsource",  .has_arg = false, .val = 209},
-	{.name = "rdest",    .has_arg = false, .val = 210},
-	XT_GETOPT_TABLEEND,
+enum {
+	O_SET = 0,
+	O_RCHECK,
+	O_UPDATE,
+	O_REMOVE,
+	O_SECONDS,
+	O_HITCOUNT,
+	O_RTTL,
+	O_NAME,
+	O_RSOURCE,
+	O_RDEST,
+	F_SET    = 1 << O_SET,
+	F_RCHECK = 1 << O_RCHECK,
+	F_UPDATE = 1 << O_UPDATE,
+	F_REMOVE = 1 << O_REMOVE,
+	F_ANY_OP = F_SET | F_RCHECK | F_UPDATE | F_REMOVE,
+};
+
+#define s struct xt_recent_mtinfo
+static const struct xt_option_entry recent_opts[] = {
+	{.name = "set", .id = O_SET, .type = XTTYPE_NONE,
+	 .excl = F_ANY_OP, .flags = XTOPT_INVERT},
+	{.name = "rcheck", .id = O_RCHECK, .type = XTTYPE_NONE,
+	 .excl = F_ANY_OP, .flags = XTOPT_INVERT},
+	{.name = "update", .id = O_UPDATE, .type = XTTYPE_NONE,
+	 .excl = F_ANY_OP, .flags = XTOPT_INVERT},
+	{.name = "remove", .id = O_REMOVE, .type = XTTYPE_NONE,
+	 .excl = F_ANY_OP, .flags = XTOPT_INVERT},
+	{.name = "seconds", .id = O_SECONDS, .type = XTTYPE_UINT32,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, seconds)},
+	{.name = "hitcount", .id = O_HITCOUNT, .type = XTTYPE_UINT32,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, hit_count)},
+	{.name = "rttl", .id = O_RTTL, .type = XTTYPE_NONE,
+	 .excl = F_SET | F_REMOVE},
+	{.name = "name", .id = O_NAME, .type = XTTYPE_STRING,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, name)},
+	{.name = "rsource", .id = O_RSOURCE, .type = XTTYPE_NONE},
+	{.name = "rdest", .id = O_RDEST, .type = XTTYPE_NONE},
+	XTOPT_TABLEEND,
 };
+#undef s
 
 static void recent_help(void)
 {
@@ -59,101 +82,50 @@ static void recent_init(struct xt_entry_match *match)
 	info->side = XT_RECENT_SOURCE;
 }
 
-#define RECENT_CMDS \
-	(XT_RECENT_SET | XT_RECENT_CHECK | \
-	XT_RECENT_UPDATE | XT_RECENT_REMOVE)
-
-static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
-                        const void *entry, struct xt_entry_match **match)
+static void recent_parse(struct xt_option_call *cb)
 {
-	struct xt_recent_mtinfo *info = (void *)(*match)->data;
-
-	switch (c) {
-		case 201:
-			if (*flags & RECENT_CMDS)
-				xtables_error(PARAMETER_PROBLEM,
-					"recent: only one of `--set', `--rcheck' "
-					"`--update' or `--remove' may be set");
-			xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-			info->check_set |= XT_RECENT_SET;
-			if (invert) info->invert = 1;
-			*flags |= XT_RECENT_SET;
-			break;
-
-		case 202:
-			if (*flags & RECENT_CMDS)
-				xtables_error(PARAMETER_PROBLEM,
-					"recent: only one of `--set', `--rcheck' "
-					"`--update' or `--remove' may be set");
-			xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-			info->check_set |= XT_RECENT_CHECK;
-			if(invert) info->invert = 1;
-			*flags |= XT_RECENT_CHECK;
-			break;
-
-		case 203:
-			if (*flags & RECENT_CMDS)
-				xtables_error(PARAMETER_PROBLEM,
-					"recent: only one of `--set', `--rcheck' "
-					"`--update' or `--remove' may be set");
-			xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-			info->check_set |= XT_RECENT_UPDATE;
-			if (invert) info->invert = 1;
-			*flags |= XT_RECENT_UPDATE;
-			break;
-
-		case 204:
-			info->seconds = atoi(optarg);
-			break;
-
-		case 205:
-			info->hit_count = atoi(optarg);
-			break;
-
-		case 206:
-			if (*flags & RECENT_CMDS)
-				xtables_error(PARAMETER_PROBLEM,
-					"recent: only one of `--set', `--rcheck' "
-					"`--update' or `--remove' may be set");
-			xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-			info->check_set |= XT_RECENT_REMOVE;
-			if (invert) info->invert = 1;
-			*flags |= XT_RECENT_REMOVE;
-			break;
-
-		case 207:
-			info->check_set |= XT_RECENT_TTL;
-			*flags |= XT_RECENT_TTL;
-			break;
-
-		case 208:
-			strncpy(info->name,optarg, XT_RECENT_NAME_LEN);
-			info->name[XT_RECENT_NAME_LEN-1] = '\0';
-			break;
-
-		case 209:
-			info->side = XT_RECENT_SOURCE;
-			break;
-
-		case 210:
-			info->side = XT_RECENT_DEST;
-			break;
+	struct xt_recent_mtinfo *info = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_SET:
+		info->check_set |= XT_RECENT_SET;
+		if (cb->invert)
+			info->invert = true;
+		break;
+	case O_RCHECK:
+		info->check_set |= XT_RECENT_CHECK;
+		if (cb->invert)
+			info->invert = true;
+		break;
+	case O_UPDATE:
+		info->check_set |= XT_RECENT_UPDATE;
+		if (cb->invert)
+			info->invert = true;
+		break;
+	case O_REMOVE:
+		info->check_set |= XT_RECENT_REMOVE;
+		if (cb->invert)
+			info->invert = true;
+		break;
+	case O_RTTL:
+		info->check_set |= XT_RECENT_TTL;
+		break;
+	case O_RSOURCE:
+		info->side = XT_RECENT_SOURCE;
+		break;
+	case O_RDEST:
+		info->side = XT_RECENT_DEST;
+		break;
 	}
-
-	return 1;
 }
 
-static void recent_check(unsigned int flags)
+static void recent_check(struct xt_fcheck_call *cb)
 {
-	if (!(flags & RECENT_CMDS))
+	if (!(cb->xflags & F_ANY_OP))
 		xtables_error(PARAMETER_PROBLEM,
 			"recent: you must specify one of `--set', `--rcheck' "
 			"`--update' or `--remove'");
-	if ((flags & XT_RECENT_TTL) &&
-	    (flags & (XT_RECENT_SET | XT_RECENT_REMOVE)))
-		xtables_error(PARAMETER_PROBLEM,
-		           "recent: --rttl may only be used with --rcheck or "
-		           "--update");
 }
 
 static void recent_print(const void *ip, const struct xt_entry_match *match,
@@ -218,11 +190,11 @@ static struct xtables_match recent_mt_reg = {
 	.userspacesize = XT_ALIGN(sizeof(struct xt_recent_mtinfo)),
 	.help          = recent_help,
 	.init          = recent_init,
-	.parse         = recent_parse,
-	.final_check   = recent_check,
+	.x6_parse      = recent_parse,
+	.x6_fcheck     = recent_check,
 	.print         = recent_print,
 	.save          = recent_save,
-	.extra_opts    = recent_opts,
+	.x6_options    = recent_opts,
 };
 
 void _init(void)
-- 
1.7.1

