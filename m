From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 06/28] libip6t_frag: use guided option parser
Date: Tue, 12 Apr 2011 16:23:21 +0200
Message-ID: <1302618224-9449-7-git-send-email-jengelh@medozas.de>
References: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51097 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756120Ab1DLOXx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:23:53 -0400
In-Reply-To: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_frag.c |  145 +++++++++++----------------------------------
 1 files changed, 36 insertions(+), 109 deletions(-)

diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index 19aca4c..12794e4 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -1,14 +1,18 @@
-/* Shared library add-on to ip6tables to add Fragmentation header support. */
-#include <stdbool.h>
 #include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <errno.h>
 #include <xtables.h>
 #include <linux/netfilter_ipv6/ip6t_frag.h>
 
+enum {
+	O_FRAGID = 0,
+	O_FRAGLEN,
+	O_FRAGRES,
+	O_FRAGFIRST,
+	O_FRAGMORE,
+	O_FRAGLAST,
+	F_FRAGMORE = 1 << O_FRAGMORE,
+	F_FRAGLAST = 1 << O_FRAGLAST,
+};
+
 static void frag_help(void)
 {
 	printf(
@@ -21,58 +25,21 @@ static void frag_help(void)
 "                               is the last one\n");
 }
 
-static const struct option frag_opts[] = {
-	{.name = "fragid",    .has_arg = true,  .val = '1'},
-	{.name = "fraglen",   .has_arg = true,  .val = '2'},
-	{.name = "fragres",   .has_arg = false, .val = '3'},
-	{.name = "fragfirst", .has_arg = false, .val = '4'},
-	{.name = "fragmore",  .has_arg = false, .val = '5'},
-	{.name = "fraglast",  .has_arg = false, .val = '6'},
-	XT_GETOPT_TABLEEND,
+#define s struct ip6t_frag
+static const struct xt_option_entry frag_opts[] = {
+	{.name = "fragid", .id = O_FRAGID, .type = XTTYPE_UINT32RC,
+	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, ids)},
+	{.name = "fraglen", .id = O_FRAGLEN, .type = XTTYPE_UINT32,
+	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, hdrlen)},
+	{.name = "fragres", .id = O_FRAGRES, .type = XTTYPE_NONE},
+	{.name = "fragfirst", .id = O_FRAGFIRST, .type = XTTYPE_NONE},
+	{.name = "fragmore", .id = O_FRAGMORE, .type = XTTYPE_NONE,
+	 .excl = F_FRAGLAST},
+	{.name = "fraglast", .id = O_FRAGLAST, .type = XTTYPE_NONE,
+	 .excl = F_FRAGMORE},
+	XTOPT_TABLEEND,
 };
-
-static uint32_t
-parse_frag_id(const char *idstr, const char *typestr)
-{
-	unsigned long int id;
-	char* ep;
-
-	id = strtoul(idstr, &ep, 0);
-
-	if ( idstr == ep ) {
-		xtables_error(PARAMETER_PROBLEM,
-			   "FRAG no valid digits in %s `%s'", typestr, idstr);
-	}
-	if ( id == ULONG_MAX  && errno == ERANGE ) {
-		xtables_error(PARAMETER_PROBLEM,
-			   "%s `%s' specified too big: would overflow",
-			   typestr, idstr);
-	}	
-	if ( *idstr != '\0'  && *ep != '\0' ) {
-		xtables_error(PARAMETER_PROBLEM,
-			   "FRAG error parsing %s `%s'", typestr, idstr);
-	}
-	return id;
-}
-
-static void
-parse_frag_ids(const char *idstring, uint32_t *ids)
-{
-	char *buffer;
-	char *cp;
-
-	buffer = strdup(idstring);
-	if ((cp = strchr(buffer, ':')) == NULL)
-		ids[0] = ids[1] = parse_frag_id(buffer,"id");
-	else {
-		*cp = '\0';
-		cp++;
-
-		ids[0] = buffer[0] ? parse_frag_id(buffer,"id") : 0;
-		ids[1] = cp[0] ? parse_frag_id(cp,"id") : 0xFFFFFFFF;
-	}
-	free(buffer);
-}
+#undef s
 
 static void frag_init(struct xt_entry_match *m)
 {
@@ -81,65 +48,25 @@ static void frag_init(struct xt_entry_match *m)
 	fraginfo->ids[1] = 0xFFFFFFFF;
 }
 
-static int frag_parse(int c, char **argv, int invert, unsigned int *flags,
-                      const void *entry, struct xt_entry_match **match)
+static void frag_parse(struct xt_option_call *cb)
 {
-	struct ip6t_frag *fraginfo = (struct ip6t_frag *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		if (*flags & IP6T_FRAG_IDS)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Only one `--fragid' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		parse_frag_ids(optarg, fraginfo->ids);
-		if (invert)
-			fraginfo->invflags |= IP6T_FRAG_INV_IDS;
-		fraginfo->flags |= IP6T_FRAG_IDS;
-		*flags |= IP6T_FRAG_IDS;
-		break;
-	case '2':
-		if (*flags & IP6T_FRAG_LEN)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Only one `--fraglen' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		fraginfo->hdrlen = parse_frag_id(optarg, "length");
-		if (invert)
-			fraginfo->invflags |= IP6T_FRAG_INV_LEN;
-		fraginfo->flags |= IP6T_FRAG_LEN;
-		*flags |= IP6T_FRAG_LEN;
-		break;
-	case '3':
-		if (*flags & IP6T_FRAG_RES)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Only one `--fragres' allowed");
+	struct ip6t_frag *fraginfo = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_FRAGRES:
 		fraginfo->flags |= IP6T_FRAG_RES;
-		*flags |= IP6T_FRAG_RES;
 		break;
-	case '4':
-		if (*flags & IP6T_FRAG_FST)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Only one `--fragfirst' allowed");
+	case O_FRAGFIRST:
 		fraginfo->flags |= IP6T_FRAG_FST;
-		*flags |= IP6T_FRAG_FST;
 		break;
-	case '5':
-		if (*flags & (IP6T_FRAG_MF|IP6T_FRAG_NMF)) 
-			xtables_error(PARAMETER_PROBLEM,
-			   "Only one `--fragmore' or `--fraglast' allowed");
+	case O_FRAGMORE:
 		fraginfo->flags |= IP6T_FRAG_MF;
-		*flags |= IP6T_FRAG_MF;
 		break;
-	case '6':
-		if (*flags & (IP6T_FRAG_MF|IP6T_FRAG_NMF)) 
-			xtables_error(PARAMETER_PROBLEM,
-			   "Only one `--fragmore' or `--fraglast' allowed");
+	case O_FRAGLAST:
 		fraginfo->flags |= IP6T_FRAG_NMF;
-		*flags |= IP6T_FRAG_NMF;
 		break;
 	}
-
-	return 1;
 }
 
 static void
@@ -234,10 +161,10 @@ static struct xtables_match frag_mt6_reg = {
 	.userspacesize = XT_ALIGN(sizeof(struct ip6t_frag)),
 	.help          = frag_help,
 	.init          = frag_init,
-	.parse         = frag_parse,
 	.print         = frag_print,
 	.save          = frag_save,
-	.extra_opts    = frag_opts,
+	.x6_parse      = frag_parse,
+	.x6_options    = frag_opts,
 };
 
 void
-- 
1.7.1

