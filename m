From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 01/11] libip6t_mh: use guided option parser
Date: Wed, 11 May 2011 15:52:46 +0200
Message-ID: <1305121977-4361-2-git-send-email-jengelh@medozas.de>
References: <1305121977-4361-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:60361 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971Ab1EKPsQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 May 2011 11:48:16 -0400
In-Reply-To: <1305121977-4361-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_mh.c |   44 +++++++++++++++++---------------------------
 1 files changed, 17 insertions(+), 27 deletions(-)

diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index 460f9e4..686a293 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -11,15 +11,17 @@
  *
  * Based on libip6t_{icmpv6,udp}.c
  */
-#include <stdbool.h>
+#include <stdint.h>
 #include <stdio.h>
-#include <netdb.h>
 #include <string.h>
 #include <stdlib.h>
-#include <getopt.h>
 #include <xtables.h>
 #include <linux/netfilter_ipv6/ip6t_mh.h>
 
+enum {
+	O_MH_TYPE = 0,
+};
+
 struct mh_name {
 	const char *name;
 	uint8_t type;
@@ -122,27 +124,14 @@ static void parse_mh_types(const char *mhtype, uint8_t *types)
 	free(buffer);
 }
 
-#define MH_TYPES 0x01
-
-static int mh_parse(int c, char **argv, int invert, unsigned int *flags,
-                    const void *entry, struct xt_entry_match **match)
+static void mh_parse(struct xt_option_call *cb)
 {
-	struct ip6t_mh *mhinfo = (struct ip6t_mh *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		if (*flags & MH_TYPES)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Only one `--mh-type' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		parse_mh_types(optarg, mhinfo->types);
-		if (invert)
-			mhinfo->invflags |= IP6T_MH_INV_TYPE;
-		*flags |= MH_TYPES;
-		break;
-	}
+	struct ip6t_mh *mhinfo = cb->data;
 
-	return 1;
+	xtables_option_parse(cb);
+	parse_mh_types(cb->arg, mhinfo->types);
+	if (cb->invert)
+		mhinfo->invflags |= IP6T_MH_INV_TYPE;
 }
 
 static const char *type_to_name(uint8_t type)
@@ -213,9 +202,10 @@ static void mh_save(const void *ip, const struct xt_entry_match *match)
 		printf(" --mh-type %u", mhinfo->types[0]);
 }
 
-static const struct option mh_opts[] = {
-	{.name = "mh-type", .has_arg = true, .val = '1'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry mh_opts[] = {
+	{.name = "mh-type", .id = O_MH_TYPE, .type = XTTYPE_STRING,
+	 .flags = XTOPT_INVERT},
+	XTOPT_TABLEEND,
 };
 
 static struct xtables_match mh_mt6_reg = {
@@ -226,10 +216,10 @@ static struct xtables_match mh_mt6_reg = {
 	.userspacesize	= XT_ALIGN(sizeof(struct ip6t_mh)),
 	.help		= mh_help,
 	.init		= mh_init,
-	.parse		= mh_parse,
+	.x6_parse	= mh_parse,
 	.print		= mh_print,
 	.save		= mh_save,
-	.extra_opts	= mh_opts,
+	.x6_options	= mh_opts,
 };
 
 void _init(void)
-- 
1.7.1

