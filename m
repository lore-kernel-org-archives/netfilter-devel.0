From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 02/17] libxt_connlimit: use guided option parser
Date: Mon,  9 May 2011 21:54:56 +0200
Message-ID: <1304970912-11520-3-git-send-email-jengelh@medozas.de>
References: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49333 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223Ab1EITzS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 15:55:18 -0400
In-Reply-To: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_connlimit.c |  176 +++++++++++++++--------------------------
 1 files changed, 65 insertions(+), 111 deletions(-)

diff --git a/extensions/libxt_connlimit.c b/extensions/libxt_connlimit.c
index badf68c..a569f86 100644
--- a/extensions/libxt_connlimit.c
+++ b/extensions/libxt_connlimit.c
@@ -1,18 +1,20 @@
-/* Shared library add-on to iptables to add connection limit support. */
-#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
-#include <stdlib.h>
-#include <stddef.h>
-#include <getopt.h>
 #include <xtables.h>
 #include <linux/netfilter/xt_connlimit.h>
 
 enum {
-	FL_LIMIT = 1 << 0,
-	FL_MASK  = 1 << 1,
-	FL_ADDR  = 1 << 2,
+	O_UPTO = 0,
+	O_ABOVE,
+	O_MASK,
+	O_SADDR,
+	O_DADDR,
+	F_UPTO  = 1 << O_UPTO,
+	F_ABOVE = 1 << O_ABOVE,
+	F_MASK  = 1 << O_MASK,
+	F_SADDR = 1 << O_SADDR,
+	F_DADDR = 1 << O_DADDR,
 };
 
 static void connlimit_help(void)
@@ -26,14 +28,23 @@ static void connlimit_help(void)
 "  --connlimit-daddr      select destination addresses for grouping\n");
 }
 
-static const struct option connlimit_opts[] = {
-	{.name = "connlimit-upto",  .has_arg = true, .val = 'U'},
-	{.name = "connlimit-above", .has_arg = true, .val = 'A'},
-	{.name = "connlimit-mask",  .has_arg = true, .val = 'M'},
-	{.name = "connlimit-saddr", .has_arg = false, .val = 's'},
-	{.name = "connlimit-daddr", .has_arg = false, .val = 'd'},
-	XT_GETOPT_TABLEEND,
+#define s struct xt_connlimit_info
+static const struct xt_option_entry connlimit_opts[] = {
+	{.name = "connlimit-upto", .id = O_UPTO, .excl = F_ABOVE,
+	 .type = XTTYPE_UINT32, .flags = XTOPT_INVERT | XTOPT_PUT,
+	 XTOPT_POINTER(s, limit)},
+	{.name = "connlimit-above", .id = O_ABOVE, .excl = F_UPTO,
+	 .type = XTTYPE_UINT32, .flags = XTOPT_INVERT | XTOPT_PUT,
+	 XTOPT_POINTER(s, limit)},
+	{.name = "connlimit-mask", .id = O_MASK, .type = XTTYPE_PLENMASK,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, mask)},
+	{.name = "connlimit-saddr", .id = O_SADDR, .excl = F_DADDR,
+	 .type = XTTYPE_NONE},
+	{.name = "connlimit-daddr", .id = O_DADDR, .excl = F_SADDR,
+	 .type = XTTYPE_NONE},
+	XTOPT_TABLEEND,
 };
+#undef s
 
 static void connlimit_init(struct xt_entry_match *match)
 {
@@ -43,111 +54,54 @@ static void connlimit_init(struct xt_entry_match *match)
 	memset(info->v6_mask, 0xFF, sizeof(info->v6_mask));
 }
 
-static void prefix_to_netmask(uint32_t *mask, unsigned int prefix_len)
+static void connlimit_parse(struct xt_option_call *cb, uint8_t family)
 {
-	if (prefix_len == 0) {
-		mask[0] = mask[1] = mask[2] = mask[3] = 0;
-	} else if (prefix_len <= 32) {
-		mask[0] <<= 32 - prefix_len;
-		mask[1] = mask[2] = mask[3] = 0;
-	} else if (prefix_len <= 64) {
-		mask[1] <<= 32 - (prefix_len - 32);
-		mask[2] = mask[3] = 0;
-	} else if (prefix_len <= 96) {
-		mask[2] <<= 32 - (prefix_len - 64);
-		mask[3] = 0;
-	} else if (prefix_len <= 128) {
-		mask[3] <<= 32 - (prefix_len - 96);
-	}
-	mask[0] = htonl(mask[0]);
-	mask[1] = htonl(mask[1]);
-	mask[2] = htonl(mask[2]);
-	mask[3] = htonl(mask[3]);
-}
-
-static int
-connlimit_parse(int c, char **argv, int invert, unsigned int *flags,
-                struct xt_entry_match **match, unsigned int family)
-{
-	struct xt_connlimit_info *info = (void *)(*match)->data;
-	const unsigned int revision = (*match)->u.user.revision;
-	char *err;
-	int i;
+	struct xt_connlimit_info *info = cb->data;
+	const unsigned int revision = (*cb->match)->u.user.revision;
 
-	switch (c) {
-	case 'A': /* --connlimit-above */
-		xtables_param_act(XTF_ONLY_ONCE, "connlimit",
-			"--connlimit-{upto,above}", *flags & FL_LIMIT);
-		*flags |= FL_LIMIT;
-		if (invert)
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_ABOVE:
+		if (cb->invert)
 			info->flags |= XT_CONNLIMIT_INVERT;
-		info->limit = strtoul(optarg, NULL, 0);
-		return true;
-	case 'U': /* --connlimit-upto */
-		xtables_param_act(XTF_ONLY_ONCE, "connlimit",
-			"--connlimit-{upto,above}", *flags & FL_LIMIT);
-		*flags |= FL_LIMIT;
-		if (!invert)
+		break;
+	case O_UPTO:
+		if (!cb->invert)
 			info->flags |= XT_CONNLIMIT_INVERT;
-		info->limit = strtoul(optarg, NULL, 0);
-		return true;
-	case 'M': /* --connlimit-mask */
-		xtables_param_act(XTF_NO_INVERT, "connlimit",
-			"--connlimit-mask", invert);
-		xtables_param_act(XTF_ONLY_ONCE, "connlimit",
-			"--connlimit-mask", *flags & FL_MASK);
-		*flags |= FL_MASK;
-		i = strtoul(optarg, &err, 0);
-		if (family == NFPROTO_IPV6) {
-			if (i > 128 || *err != '\0')
-				xtables_error(PARAMETER_PROBLEM,
-					"--connlimit-mask must be between "
-					"0 and 128");
-			prefix_to_netmask(info->v6_mask, i);
-		} else {
-			if (i > 32 || *err != '\0')
-				xtables_error(PARAMETER_PROBLEM,
-					"--connlimit-mask must be between "
-					"0 and 32");
-			if (i == 0)
-				info->v4_mask = 0;
-			else
-				info->v4_mask = htonl(0xFFFFFFFF << (32 - i));
-		}
-		return true;
-	case 's': /* --connlimit-saddr */
+		break;
+	case O_SADDR:
+		if (revision < 1)
+			xtables_error(PARAMETER_PROBLEM,
+				"xt_connlimit.0 does not support "
+				"--connlimit-daddr");
 		info->flags &= ~XT_CONNLIMIT_DADDR;
-		return true;
-	case 'd': /* --connlimit-daddr */
+		break;
+	case O_DADDR:
 		if (revision < 1)
 			xtables_error(PARAMETER_PROBLEM,
 				"xt_connlimit.0 does not support "
 				"--connlimit-daddr");
 		info->flags |= XT_CONNLIMIT_DADDR;
-		return true;
+		break;
 	}
-	return false;
 }
 
-static int connlimit_parse4(int c, char **argv, int invert,
-                            unsigned int *flags, const void *entry,
-                            struct xt_entry_match **match)
+static void connlimit_parse4(struct xt_option_call *cb)
 {
-	return connlimit_parse(c, argv, invert, flags, match, NFPROTO_IPV4);
+	return connlimit_parse(cb, NFPROTO_IPV4);
 }
 
-static int connlimit_parse6(int c, char **argv, int invert,
-                            unsigned int *flags, const void *entry,
-                            struct xt_entry_match **match)
+static void connlimit_parse6(struct xt_option_call *cb)
 {
-	return connlimit_parse(c, argv, invert, flags, match, NFPROTO_IPV6);
+	return connlimit_parse(cb, NFPROTO_IPV6);
 }
 
-static void connlimit_check(unsigned int flags)
+static void connlimit_check(struct xt_fcheck_call *cb)
 {
-	if (!(flags & 0x1))
+	if ((cb->xflags & (F_UPTO | F_ABOVE)) == 0)
 		xtables_error(PARAMETER_PROBLEM,
-			"You must specify \"--connlimit-above\"");
+			"You must specify \"--connlimit-above\" or "
+			"\"--connlimit-upto\".");
 }
 
 static unsigned int count_bits4(uint32_t mask)
@@ -239,11 +193,11 @@ static struct xtables_match connlimit_mt_reg[] = {
 		.userspacesize = offsetof(struct xt_connlimit_info, data),
 		.help          = connlimit_help,
 		.init          = connlimit_init,
-		.parse         = connlimit_parse4,
-		.final_check   = connlimit_check,
+		.x6_parse      = connlimit_parse4,
+		.x6_fcheck     = connlimit_check,
 		.print         = connlimit_print4,
 		.save          = connlimit_save4,
-		.extra_opts    = connlimit_opts,
+		.x6_options    = connlimit_opts,
 	},
 	{
 		.name          = "connlimit",
@@ -254,11 +208,11 @@ static struct xtables_match connlimit_mt_reg[] = {
 		.userspacesize = offsetof(struct xt_connlimit_info, data),
 		.help          = connlimit_help,
 		.init          = connlimit_init,
-		.parse         = connlimit_parse6,
-		.final_check   = connlimit_check,
+		.x6_parse      = connlimit_parse6,
+		.x6_fcheck     = connlimit_check,
 		.print         = connlimit_print6,
 		.save          = connlimit_save6,
-		.extra_opts    = connlimit_opts,
+		.x6_options    = connlimit_opts,
 	},
 	{
 		.name          = "connlimit",
@@ -269,11 +223,11 @@ static struct xtables_match connlimit_mt_reg[] = {
 		.userspacesize = offsetof(struct xt_connlimit_info, data),
 		.help          = connlimit_help,
 		.init          = connlimit_init,
-		.parse         = connlimit_parse4,
-		.final_check   = connlimit_check,
+		.x6_parse      = connlimit_parse4,
+		.x6_fcheck     = connlimit_check,
 		.print         = connlimit_print4,
 		.save          = connlimit_save4,
-		.extra_opts    = connlimit_opts,
+		.x6_options    = connlimit_opts,
 	},
 	{
 		.name          = "connlimit",
@@ -284,11 +238,11 @@ static struct xtables_match connlimit_mt_reg[] = {
 		.userspacesize = offsetof(struct xt_connlimit_info, data),
 		.help          = connlimit_help,
 		.init          = connlimit_init,
-		.parse         = connlimit_parse6,
-		.final_check   = connlimit_check,
+		.x6_parse      = connlimit_parse6,
+		.x6_fcheck     = connlimit_check,
 		.print         = connlimit_print6,
 		.save          = connlimit_save6,
-		.extra_opts    = connlimit_opts,
+		.x6_options    = connlimit_opts,
 	},
 };
 
-- 
1.7.1

