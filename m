From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 11/28] libip6t_hbh: use guided option parser
Date: Tue, 12 Apr 2011 16:23:26 +0200
Message-ID: <1302618224-9449-12-git-send-email-jengelh@medozas.de>
References: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54652 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756321Ab1DLOX5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:23:57 -0400
In-Reply-To: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_hbh.c |   61 ++++++++++++++++-----------------------------
 1 files changed, 22 insertions(+), 39 deletions(-)

diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index b6a8e46..809e80d 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -1,19 +1,17 @@
-/* Shared library add-on to ip6tables to add Hop-by-Hop header support. */
 #include <stdio.h>
-#include <netdb.h>
 #include <string.h>
 #include <stdlib.h>
-#include <getopt.h>
 #include <errno.h>
 #include <xtables.h>
-/*#include <linux/in6.h>*/
 #include <linux/netfilter_ipv6/ip6t_opts.h>
-#include <sys/types.h>
-#include <sys/socket.h>
-#include <arpa/inet.h>
 
 #define DEBUG		0
 
+enum {
+	O_HBH_LEN = 0,
+	O_HBH_OPTS,
+};
+
 static void hbh_help(void)
 {
 	printf(
@@ -24,10 +22,12 @@ static void hbh_help(void)
 IP6T_OPTS_OPTSNR);
 }
 
-static const struct option hbh_opts[] = {
-	{.name = "hbh-len",        .has_arg = true, .val = '1'},
-	{.name = "hbh-opts",       .has_arg = true, .val = '2'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry hbh_opts[] = {
+	{.name = "hbh-len", .id = O_HBH_LEN, .type = XTTYPE_UINT32,
+	 .flags = XTOPT_INVERT | XTOPT_PUT,
+	 XTOPT_POINTER(struct ip6t_opts, hdrlen)},
+	{.name = "hbh-opts", .id = O_HBH_OPTS, .type = XTTYPE_STRING},
+	XTOPT_TABLEEND,
 };
 
 static uint32_t
@@ -99,38 +99,21 @@ parse_options(const char *optsstr, uint16_t *opts)
 	return i;
 }
 
-static int hbh_parse(int c, char **argv, int invert, unsigned int *flags,
-                     const void *entry, struct xt_entry_match **match)
+static void hbh_parse(struct xt_option_call *cb)
 {
-	struct ip6t_opts *optinfo = (struct ip6t_opts *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		if (*flags & IP6T_OPTS_LEN)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Only one `--hbh-len' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		optinfo->hdrlen = parse_opts_num(optarg, "length");
-		if (invert)
+	struct ip6t_opts *optinfo = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_HBH_LEN:
+		if (cb->invert)
 			optinfo->invflags |= IP6T_OPTS_INV_LEN;
-		optinfo->flags |= IP6T_OPTS_LEN;
-		*flags |= IP6T_OPTS_LEN;
 		break;
-	case '2':
-		if (*flags & IP6T_OPTS_OPTS)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Only one `--hbh-opts' allowed");
-                xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-                if (invert)
-			xtables_error(PARAMETER_PROBLEM,
-				" '!' not allowed with `--hbh-opts'");
-		optinfo->optsnr = parse_options(optarg, optinfo->opts);
+	case O_HBH_OPTS:
+		optinfo->optsnr = parse_options(cb->arg, optinfo->opts);
 		optinfo->flags |= IP6T_OPTS_OPTS;
-		*flags |= IP6T_OPTS_OPTS;
 		break;
 	}
-
-	return 1;
 }
 
 static void
@@ -187,10 +170,10 @@ static struct xtables_match hbh_mt6_reg = {
 	.size		= XT_ALIGN(sizeof(struct ip6t_opts)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ip6t_opts)),
 	.help		= hbh_help,
-	.parse		= hbh_parse,
 	.print		= hbh_print,
 	.save		= hbh_save,
-	.extra_opts	= hbh_opts,
+	.x6_parse	= hbh_parse,
+	.x6_options	= hbh_opts,
 };
 
 void
-- 
1.7.1

