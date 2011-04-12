From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 25/28] libxt_pkttype: use guided option parser
Date: Tue, 12 Apr 2011 16:23:40 +0200
Message-ID: <1302618224-9449-26-git-send-email-jengelh@medozas.de>
References: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54699 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756444Ab1DLOYN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:24:13 -0400
In-Reply-To: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_pkttype.c |   52 ++++++++++++-------------------------------
 1 files changed, 15 insertions(+), 37 deletions(-)

diff --git a/extensions/libxt_pkttype.c b/extensions/libxt_pkttype.c
index f5de3ef..1ed3b44 100644
--- a/extensions/libxt_pkttype.c
+++ b/extensions/libxt_pkttype.c
@@ -4,22 +4,15 @@
  *
  * Michal Ludvig <michal@logix.cz>
  */
-#include <stdbool.h>
 #include <stdio.h>
-#include <netdb.h>
 #include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#if defined(__GLIBC__) && __GLIBC__ == 2
-#include <net/ethernet.h>
-#else
-#include <linux/if_ether.h>
-#endif
 #include <xtables.h>
 #include <linux/if_packet.h>
 #include <linux/netfilter/xt_pkttype.h>
 
-#define	PKTTYPE_VERSION	"0.1"
+enum {
+	O_PKTTYPE = 0,
+};
 
 struct pkttypes {
 	const char *name;
@@ -61,9 +54,10 @@ static void pkttype_help(void)
 	print_types();
 }
 
-static const struct option pkttype_opts[] = {
-	{.name = "pkt-type", .has_arg = true, .val = '1'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry pkttype_opts[] = {
+	{.name = "pkt-type", .id = O_PKTTYPE, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND | XTOPT_INVERT},
+	XTOPT_TABLEEND,
 };
 
 static void parse_pkttype(const char *pkttype, struct xt_pkttype_info *info)
@@ -80,29 +74,14 @@ static void parse_pkttype(const char *pkttype, struct xt_pkttype_info *info)
 	xtables_error(PARAMETER_PROBLEM, "Bad packet type '%s'", pkttype);
 }
 
-static int pkttype_parse(int c, char **argv, int invert, unsigned int *flags,
-                         const void *entry, struct xt_entry_match **match)
+static void pkttype_parse(struct xt_option_call *cb)
 {
-	struct xt_pkttype_info *info = (struct xt_pkttype_info *)(*match)->data;
-	
-	switch(c)
-	{
-		case '1':
-			xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-			parse_pkttype(optarg, info);
-			if(invert)
-				info->invert=1;
-			*flags=1;
-			break;
-	}
+	struct xt_pkttype_info *info = cb->data;
 
-	return 1;
-}
-
-static void pkttype_check(unsigned int flags)
-{
-	if (!flags)
-		xtables_error(PARAMETER_PROBLEM, "You must specify \"--pkt-type\"");
+	xtables_option_parse(cb);
+	parse_pkttype(cb->arg, info);
+	if (cb->invert)
+		info->invert = 1;
 }
 
 static void print_pkttype(const struct xt_pkttype_info *info)
@@ -143,11 +122,10 @@ static struct xtables_match pkttype_match = {
 	.size		= XT_ALIGN(sizeof(struct xt_pkttype_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_pkttype_info)),
 	.help		= pkttype_help,
-	.parse		= pkttype_parse,
-	.final_check	= pkttype_check,
 	.print		= pkttype_print,
 	.save		= pkttype_save,
-	.extra_opts	= pkttype_opts,
+	.x6_parse	= pkttype_parse,
+	.x6_options	= pkttype_opts,
 };
 
 void _init(void)
-- 
1.7.1

