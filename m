From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 9/9] libxt_dccp: use guided option parser
Date: Sun,  1 May 2011 13:50:29 +0200
Message-ID: <1304250630-6150-10-git-send-email-jengelh@medozas.de>
References: <1304250630-6150-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50027 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754391Ab1EALun (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 May 2011 07:50:43 -0400
In-Reply-To: <1304250630-6150-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_dccp.c |  134 ++++++++++++++---------------------------------
 1 files changed, 40 insertions(+), 94 deletions(-)

diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index ee8e009..3eff177 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -5,15 +5,12 @@
  * This program is distributed under the terms of GNU GPL v2, 1991
  *
  */
-#include <stdbool.h>
+#include <stdint.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
-#include <getopt.h>
 #include <netdb.h>
-#include <ctype.h>
-
-#include <netinet/in.h>
+#include <arpa/inet.h>
 #include <xtables.h>
 #include <linux/dccp.h>
 #include <linux/netfilter/x_tables.h>
@@ -26,6 +23,13 @@
 #define DEBUGP(format, fist...) 
 #endif
 
+enum {
+	O_SOURCE_PORT = 0,
+	O_DEST_PORT,
+	O_DCCP_TYPES,
+	O_DCCP_OPTION,
+};
+
 static void dccp_help(void)
 {
 	printf(
@@ -36,41 +40,23 @@ static void dccp_help(void)
 " --dport ...\n");
 }
 
-static const struct option dccp_opts[] = {
-	{.name = "source-port",      .has_arg = true, .val = '1'},
-	{.name = "sport",            .has_arg = true, .val = '1'},
-	{.name = "destination-port", .has_arg = true, .val = '2'},
-	{.name = "dport",            .has_arg = true, .val = '2'},
-	{.name = "dccp-types",       .has_arg = true, .val = '3'},
-	{.name = "dccp-option",      .has_arg = true, .val = '4'},
-	XT_GETOPT_TABLEEND,
+#define s struct xt_dccp_info
+static const struct xt_option_entry dccp_opts[] = {
+	{.name = "source-port", .id = O_SOURCE_PORT, .type = XTTYPE_PORTRC_NE,
+	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, spts)},
+	{.name = "sport", .id = O_SOURCE_PORT, .type = XTTYPE_PORTRC_NE,
+	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, spts)},
+	{.name = "destination-port", .id = O_DEST_PORT, .type = XTTYPE_PORTRC_NE,
+	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, dpts)},
+	{.name = "dport", .id = O_DEST_PORT, .type = XTTYPE_PORTRC_NE,
+	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, dpts)},
+	{.name = "dccp-types", .id = O_DCCP_TYPES, .type = XTTYPE_STRING},
+	{.name = "dccp-option", .id = O_DCCP_OPTION, .type = XTTYPE_UINT8,
+	 .min = 1, .max = UINT8_MAX, .flags = XTOPT_PUT,
+	 XTOPT_POINTER(s, option)},
+	XTOPT_TABLEEND,
 };
-
-static void
-parse_dccp_ports(const char *portstring, 
-		 uint16_t *ports)
-{
-	char *buffer;
-	char *cp;
-
-	buffer = strdup(portstring);
-	DEBUGP("%s\n", portstring);
-	if ((cp = strchr(buffer, ':')) == NULL) {
-		ports[0] = ports[1] = xtables_parse_port(buffer, "dccp");
-	}
-	else {
-		*cp = '\0';
-		cp++;
-
-		ports[0] = buffer[0] ? xtables_parse_port(buffer, "dccp") : 0;
-		ports[1] = cp[0] ? xtables_parse_port(cp, "dccp") : 0xFFFF;
-
-		if (ports[0] > ports[1])
-			xtables_error(PARAMETER_PROBLEM,
-				   "invalid portrange (min > max)");
-	}
-	free(buffer);
-}
+#undef s
 
 static const char *const dccp_pkt_types[] = {
 	[DCCP_PKT_REQUEST] 	= "REQUEST",
@@ -110,74 +96,34 @@ parse_dccp_types(const char *typestring)
 	return typemask;
 }
 
-static uint8_t parse_dccp_option(char *optstring)
+static void dccp_parse(struct xt_option_call *cb)
 {
-	unsigned int ret;
-
-	if (!xtables_strtoui(optstring, NULL, &ret, 1, UINT8_MAX))
-		xtables_error(PARAMETER_PROBLEM, "Bad DCCP option \"%s\"",
-			   optstring);
-
-	return ret;
-}
+	struct xt_dccp_info *einfo = cb->data;
 
-static int
-dccp_parse(int c, char **argv, int invert, unsigned int *flags,
-           const void *entry, struct xt_entry_match **match)
-{
-	struct xt_dccp_info *einfo
-		= (struct xt_dccp_info *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		if (*flags & XT_DCCP_SRC_PORTS)
-			xtables_error(PARAMETER_PROBLEM,
-			           "Only one `--source-port' allowed");
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_SOURCE_PORT:
 		einfo->flags |= XT_DCCP_SRC_PORTS;
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		parse_dccp_ports(optarg, einfo->spts);
-		if (invert)
+		if (cb->invert)
 			einfo->invflags |= XT_DCCP_SRC_PORTS;
-		*flags |= XT_DCCP_SRC_PORTS;
 		break;
-
-	case '2':
-		if (*flags & XT_DCCP_DEST_PORTS)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Only one `--destination-port' allowed");
+	case O_DEST_PORT:
 		einfo->flags |= XT_DCCP_DEST_PORTS;
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		parse_dccp_ports(optarg, einfo->dpts);
-		if (invert)
+		if (cb->invert)
 			einfo->invflags |= XT_DCCP_DEST_PORTS;
-		*flags |= XT_DCCP_DEST_PORTS;
 		break;
-
-	case '3':
-		if (*flags & XT_DCCP_TYPE)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Only one `--dccp-types' allowed");
+	case O_DCCP_TYPES:
 		einfo->flags |= XT_DCCP_TYPE;
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		einfo->typemask = parse_dccp_types(optarg);
-		if (invert)
+		einfo->typemask = parse_dccp_types(cb->arg);
+		if (cb->invert)
 			einfo->invflags |= XT_DCCP_TYPE;
-		*flags |= XT_DCCP_TYPE;
 		break;
-
-	case '4':
-		if (*flags & XT_DCCP_OPTION)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Only one `--dccp-option' allowed");
+	case O_DCCP_OPTION:
 		einfo->flags |= XT_DCCP_OPTION;
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		einfo->option = parse_dccp_option(optarg);
-		if (invert)
+		if (cb->invert)
 			einfo->invflags |= XT_DCCP_OPTION;
-		*flags |= XT_DCCP_OPTION;
 		break;
 	}
-	return 1;
 }
 
 static char *
@@ -333,10 +279,10 @@ static struct xtables_match dccp_match = {
 	.size		= XT_ALIGN(sizeof(struct xt_dccp_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_dccp_info)),
 	.help		= dccp_help,
-	.parse		= dccp_parse,
 	.print		= dccp_print,
 	.save		= dccp_save,
-	.extra_opts	= dccp_opts,
+	.x6_parse	= dccp_parse,
+	.x6_options	= dccp_opts,
 };
 
 void _init(void)
-- 
1.7.1

