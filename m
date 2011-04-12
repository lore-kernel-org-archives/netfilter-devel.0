From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 10/28] libip6t_dst: use guided option parser
Date: Tue, 12 Apr 2011 16:23:25 +0200
Message-ID: <1302618224-9449-11-git-send-email-jengelh@medozas.de>
References: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54649 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756120Ab1DLOX5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:23:57 -0400
In-Reply-To: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_dst.c |   61 +++++++++++++++-------------------------------
 1 files changed, 20 insertions(+), 41 deletions(-)

diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index 74f6029..4125bd3 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -1,16 +1,14 @@
-/* Shared library add-on to ip6tables to add Dst header support. */
-#include <stdbool.h>
 #include <stdio.h>
-#include <netdb.h>
 #include <string.h>
 #include <stdlib.h>
-#include <getopt.h>
 #include <errno.h>
 #include <xtables.h>
 #include <linux/netfilter_ipv6/ip6t_opts.h>
-#include <sys/types.h>
-#include <sys/socket.h>
-#include <arpa/inet.h>
+
+enum {
+	O_DSTLEN = 0,
+	O_DSTOPTS,
+};
 
 static void dst_help(void)
 {
@@ -22,10 +20,12 @@ static void dst_help(void)
 IP6T_OPTS_OPTSNR);
 }
 
-static const struct option dst_opts[] = {
-	{.name = "dst-len",        .has_arg = true, .val = '1'},
-	{.name = "dst-opts",       .has_arg = true, .val = '2'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry dst_opts[] = {
+	{.name = "dst-len", .id = O_DSTLEN, .type = XTTYPE_UINT32,
+	 .flags = XTOPT_INVERT | XTOPT_PUT,
+	 XTOPT_POINTER(struct ip6t_opts, hdrlen)},
+	{.name = "dst-opts", .id = O_DSTOPTS, .type = XTTYPE_STRING},
+	XTOPT_TABLEEND,
 };
 
 static uint32_t
@@ -105,38 +105,17 @@ parse_options(const char *optsstr, uint16_t *opts)
 	return i;
 }
 
-static int dst_parse(int c, char **argv, int invert, unsigned int *flags,
-                     const void *entry, struct xt_entry_match **match)
+static void dst_parse(struct xt_option_call *cb)
 {
-	struct ip6t_opts *optinfo = (struct ip6t_opts *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		if (*flags & IP6T_OPTS_LEN)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Only one `--dst-len' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		optinfo->hdrlen = parse_opts_num(optarg, "length");
-		if (invert)
-			optinfo->invflags |= IP6T_OPTS_INV_LEN;
-		optinfo->flags |= IP6T_OPTS_LEN;
-		*flags |= IP6T_OPTS_LEN;
-		break;
-	case '2':
-		if (*flags & IP6T_OPTS_OPTS)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Only one `--dst-opts' allowed");
-                xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-                if (invert)
-			xtables_error(PARAMETER_PROBLEM,
-				" '!' not allowed with `--dst-opts'");
-		optinfo->optsnr = parse_options(optarg, optinfo->opts);
+	struct ip6t_opts *optinfo = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_DSTOPTS:
+		optinfo->optsnr = parse_options(cb->arg, optinfo->opts);
 		optinfo->flags |= IP6T_OPTS_OPTS;
-		*flags |= IP6T_OPTS_OPTS;
 		break;
 	}
-
-	return 1;
 }
 
 static void
@@ -199,10 +178,10 @@ static struct xtables_match dst_mt6_reg = {
 	.size          = XT_ALIGN(sizeof(struct ip6t_opts)),
 	.userspacesize = XT_ALIGN(sizeof(struct ip6t_opts)),
 	.help          = dst_help,
-	.parse         = dst_parse,
 	.print         = dst_print,
 	.save          = dst_save,
-	.extra_opts    = dst_opts,
+	.x6_parse      = dst_parse,
+	.x6_options    = dst_opts,
 };
 
 void
-- 
1.7.1

