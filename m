From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 06/11] libxt_iprange: use guided option parser
Date: Wed, 11 May 2011 15:52:51 +0200
Message-ID: <1305121977-4361-7-git-send-email-jengelh@medozas.de>
References: <1305121977-4361-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:60364 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219Ab1EKPsS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 May 2011 11:48:18 -0400
In-Reply-To: <1305121977-4361-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_iprange.c |  144 ++++++++++++++++---------------------------
 1 files changed, 54 insertions(+), 90 deletions(-)

diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index 2a91416..2c9ea99 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -1,12 +1,7 @@
-/* Shared library add-on to iptables to add IP range matching support. */
-#include <stdbool.h>
+#include <stdint.h>
 #include <stdio.h>
-#include <netdb.h>
 #include <string.h>
 #include <stdlib.h>
-#include <getopt.h>
-
-#include <netinet/in.h>
 #include <xtables.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/xt_iprange.h>
@@ -25,8 +20,8 @@ struct ipt_iprange_info {
 };
 
 enum {
-	F_SRCIP = 1 << 0,
-	F_DSTIP = 1 << 1,
+	O_SRC_RANGE = 0,
+	O_DST_RANGE,
 };
 
 static void iprange_mt_help(void)
@@ -37,10 +32,12 @@ static void iprange_mt_help(void)
 "[!] --dst-range ip[-ip]    Match destination IP in the specified range\n");
 }
 
-static const struct option iprange_mt_opts[] = {
-	{.name = "src-range", .has_arg = true, .val = '1'},
-	{.name = "dst-range", .has_arg = true, .val = '2'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry iprange_mt_opts[] = {
+	{.name = "src-range", .id = O_SRC_RANGE, .type = XTTYPE_STRING,
+	 .flags = XTOPT_INVERT},
+	{.name = "dst-range", .id = O_DST_RANGE, .type = XTTYPE_STRING,
+	 .flags = XTOPT_INVERT},
+	XTOPT_TABLEEND,
 };
 
 static void
@@ -73,14 +70,18 @@ iprange_parse_spec(const char *from, const char *to, union nf_inet_addr *range,
 	}
 }
 
-static void iprange_parse_range(char *arg, union nf_inet_addr *range,
+static void iprange_parse_range(const char *oarg, union nf_inet_addr *range,
 				uint8_t family, const char *optname)
 {
+	char *arg = strdup(oarg);
 	char *dash;
 
+	if (arg == NULL)
+		xtables_error(RESOURCE_PROBLEM, "strdup");
 	dash = strchr(arg, '-');
 	if (dash == NULL) {
 		iprange_parse_spec(arg, arg, range, family, optname);
+		free(arg);
 		return;
 	}
 
@@ -89,108 +90,71 @@ static void iprange_parse_range(char *arg, union nf_inet_addr *range,
 	if (memcmp(&range[0], &range[1], sizeof(*range)) > 0)
 		fprintf(stderr, "xt_iprange: range %s-%s is reversed and "
 			"will never match\n", arg, dash + 1);
+	free(arg);
 }
 
-static int iprange_parse(int c, char **argv, int invert, unsigned int *flags,
-                         const void *entry, struct xt_entry_match **match)
+static void iprange_parse(struct xt_option_call *cb)
 {
-	struct ipt_iprange_info *info = (struct ipt_iprange_info *)(*match)->data;
+	struct ipt_iprange_info *info = cb->data;
 	union nf_inet_addr range[2];
 
-	switch (c) {
-	case '1':
-		if (*flags & IPRANGE_SRC)
-			xtables_error(PARAMETER_PROBLEM,
-				   "iprange match: Only use --src-range ONCE!");
-		*flags |= IPRANGE_SRC;
-
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_SRC_RANGE:
 		info->flags |= IPRANGE_SRC;
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		if (invert)
+		if (cb->invert)
 			info->flags |= IPRANGE_SRC_INV;
-		iprange_parse_range(optarg, range, NFPROTO_IPV4, "--src-range");
+		iprange_parse_range(cb->arg, range, NFPROTO_IPV4, "--src-range");
 		info->src.min_ip = range[0].ip;
 		info->src.max_ip = range[1].ip;
 		break;
-
-	case '2':
-		if (*flags & IPRANGE_DST)
-			xtables_error(PARAMETER_PROBLEM,
-				   "iprange match: Only use --dst-range ONCE!");
-		*flags |= IPRANGE_DST;
-
+	case O_DST_RANGE:
 		info->flags |= IPRANGE_DST;
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		if (invert)
+		if (cb->invert)
 			info->flags |= IPRANGE_DST_INV;
-
-		iprange_parse_range(optarg, range, NFPROTO_IPV4, "--dst-range");
+		iprange_parse_range(cb->arg, range, NFPROTO_IPV4, "--dst-range");
 		info->dst.min_ip = range[0].ip;
 		info->dst.max_ip = range[1].ip;
 		break;
 	}
-	return 1;
 }
 
-static int
-iprange_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
-                  const void *entry, struct xt_entry_match **match)
+static void iprange_mt_parse(struct xt_option_call *cb, uint8_t nfproto)
 {
-	struct xt_iprange_mtinfo *info = (void *)(*match)->data;
+	struct xt_iprange_mtinfo *info = cb->data;
 
-	switch (c) {
-	case '1': /* --src-range */
-		iprange_parse_range(optarg, &info->src_min, NFPROTO_IPV4,
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_SRC_RANGE:
+		iprange_parse_range(cb->arg, &info->src_min, nfproto,
 			"--src-range");
 		info->flags |= IPRANGE_SRC;
-		if (invert)
+		if (cb->invert)
 			info->flags |= IPRANGE_SRC_INV;
-		*flags |= F_SRCIP;
-		return true;
-
-	case '2': /* --dst-range */
-		iprange_parse_range(optarg, &info->dst_min, NFPROTO_IPV4,
+		break;
+	case O_DST_RANGE:
+		iprange_parse_range(cb->arg, &info->dst_min, nfproto,
 			"--dst-range");
 		info->flags |= IPRANGE_DST;
-		if (invert)
+		if (cb->invert)
 			info->flags |= IPRANGE_DST_INV;
-		*flags |= F_DSTIP;
-		return true;
+		break;
 	}
-	return false;
 }
 
-static int
-iprange_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
-                  const void *entry, struct xt_entry_match **match)
+static void iprange_mt4_parse(struct xt_option_call *cb)
 {
-	struct xt_iprange_mtinfo *info = (void *)(*match)->data;
-
-	switch (c) {
-	case '1': /* --src-range */
-		iprange_parse_range(optarg, &info->src_min, NFPROTO_IPV6,
-			"--src-range");
-		info->flags |= IPRANGE_SRC;
-		if (invert)
-			info->flags |= IPRANGE_SRC_INV;
-		*flags |= F_SRCIP;
-		return true;
+	iprange_mt_parse(cb, NFPROTO_IPV4);
+}
 
-	case '2': /* --dst-range */
-		iprange_parse_range(optarg, &info->dst_min, NFPROTO_IPV6,
-			"--dst-range");
-		info->flags |= IPRANGE_DST;
-		if (invert)
-			info->flags |= IPRANGE_DST_INV;
-		*flags |= F_DSTIP;
-		return true;
-	}
-	return false;
+static void iprange_mt6_parse(struct xt_option_call *cb)
+{
+	iprange_mt_parse(cb, NFPROTO_IPV6);
 }
 
-static void iprange_mt_check(unsigned int flags)
+static void iprange_mt_check(struct xt_fcheck_call *cb)
 {
-	if (flags == 0)
+	if (cb->xflags == 0)
 		xtables_error(PARAMETER_PROBLEM,
 			   "iprange match: You must specify `--src-range' or `--dst-range'");
 }
@@ -341,11 +305,11 @@ static struct xtables_match iprange_mt_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct ipt_iprange_info)),
 		.userspacesize = XT_ALIGN(sizeof(struct ipt_iprange_info)),
 		.help          = iprange_mt_help,
-		.parse         = iprange_parse,
-		.final_check   = iprange_mt_check,
+		.x6_parse      = iprange_parse,
+		.x6_fcheck     = iprange_mt_check,
 		.print         = iprange_print,
 		.save          = iprange_save,
-		.extra_opts    = iprange_mt_opts,
+		.x6_options    = iprange_mt_opts,
 	},
 	{
 		.version       = XTABLES_VERSION,
@@ -355,11 +319,11 @@ static struct xtables_match iprange_mt_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct xt_iprange_mtinfo)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_iprange_mtinfo)),
 		.help          = iprange_mt_help,
-		.parse         = iprange_mt4_parse,
-		.final_check   = iprange_mt_check,
+		.x6_parse      = iprange_mt4_parse,
+		.x6_fcheck     = iprange_mt_check,
 		.print         = iprange_mt4_print,
 		.save          = iprange_mt4_save,
-		.extra_opts    = iprange_mt_opts,
+		.x6_options    = iprange_mt_opts,
 	},
 	{
 		.version       = XTABLES_VERSION,
@@ -369,11 +333,11 @@ static struct xtables_match iprange_mt_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct xt_iprange_mtinfo)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_iprange_mtinfo)),
 		.help          = iprange_mt_help,
-		.parse         = iprange_mt6_parse,
-		.final_check   = iprange_mt_check,
+		.x6_parse      = iprange_mt6_parse,
+		.x6_fcheck     = iprange_mt_check,
 		.print         = iprange_mt6_print,
 		.save          = iprange_mt6_save,
-		.extra_opts    = iprange_mt_opts,
+		.x6_options    = iprange_mt_opts,
 	},
 };
 
-- 
1.7.1

