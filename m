From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 02/11] libip6t_rt: use guided option parser
Date: Wed, 11 May 2011 15:52:47 +0200
Message-ID: <1305121977-4361-3-git-send-email-jengelh@medozas.de>
References: <1305121977-4361-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:60360 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755128Ab1EKPsQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 May 2011 11:48:16 -0400
In-Reply-To: <1305121977-4361-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_rt.c |  159 +++++++++++++----------------------------------
 1 files changed, 44 insertions(+), 115 deletions(-)

diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index 1c57dbd..11bfda9 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -1,19 +1,20 @@
-/* Shared library add-on to ip6tables to add Routing header support. */
-#include <stdbool.h>
 #include <stdio.h>
-#include <netdb.h>
 #include <string.h>
 #include <stdlib.h>
-#include <getopt.h>
-#include <errno.h>
 #include <xtables.h>
-/*#include <linux/in6.h>*/
 #include <linux/netfilter_ipv6/ip6t_rt.h>
-#include <sys/types.h>
-#include <sys/socket.h>
 #include <arpa/inet.h>
 
-/*#define DEBUG	1*/
+enum {
+	O_RT_TYPE = 0,
+	O_RT_SEGSLEFT,
+	O_RT_LEN,
+	O_RT0RES,
+	O_RT0ADDRS,
+	O_RT0NSTRICT,
+	F_RT_TYPE  = 1 << O_RT_TYPE,
+	F_RT0ADDRS = 1 << O_RT0ADDRS,
+};
 
 static void rt_help(void)
 {
@@ -28,58 +29,20 @@ static void rt_help(void)
 IP6T_RT_HOPS);
 }
 
-static const struct option rt_opts[] = {
-	{.name = "rt-type",         .has_arg = true,  .val = '1'},
-	{.name = "rt-segsleft",     .has_arg = true,  .val = '2'},
-	{.name = "rt-len",          .has_arg = true,  .val = '3'},
-	{.name = "rt-0-res",        .has_arg = false, .val = '4'},
-	{.name = "rt-0-addrs",      .has_arg = true,  .val = '5'},
-	{.name = "rt-0-not-strict", .has_arg = false, .val = '6'},
-	XT_GETOPT_TABLEEND,
+#define s struct ip6t_rt
+static const struct xt_option_entry rt_opts[] = {
+	{.name = "rt-type", .id = O_RT_TYPE, .type = XTTYPE_UINT32RC,
+	 .flags = XTOPT_INVERT},
+	{.name = "rt-segsleft", .id = O_RT_SEGSLEFT, .type = XTTYPE_UINT32RC,
+	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, segsleft)},
+	{.name = "rt-len", .id = O_RT_LEN, .type = XTTYPE_UINT32,
+	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, hdrlen)},
+	{.name = "rt-0-res", .id = O_RT0RES, .type = XTTYPE_NONE},
+	{.name = "rt-0-addrs", .id = O_RT0ADDRS, .type = XTTYPE_STRING},
+	{.name = "rt-0-not-strict", .id = O_RT0NSTRICT, .type = XTTYPE_STRING},
+	XTOPT_TABLEEND,
 };
-
-static uint32_t
-parse_rt_num(const char *idstr, const char *typestr)
-{
-	unsigned long int id;
-	char* ep;
-
-	id =  strtoul(idstr,&ep,0) ;
-
-	if ( idstr == ep ) {
-		xtables_error(PARAMETER_PROBLEM,
-			   "RT no valid digits in %s `%s'", typestr, idstr);
-	}
-	if ( id == ULONG_MAX  && errno == ERANGE ) {
-		xtables_error(PARAMETER_PROBLEM,
-			   "%s `%s' specified too big: would overflow",
-			   typestr, idstr);
-	}	
-	if ( *idstr != '\0'  && *ep != '\0' ) {
-		xtables_error(PARAMETER_PROBLEM,
-			   "RT error parsing %s `%s'", typestr, idstr);
-	}
-	return id;
-}
-
-static void
-parse_rt_segsleft(const char *idstring, uint32_t *ids)
-{
-	char *buffer;
-	char *cp;
-
-	buffer = strdup(idstring);
-	if ((cp = strchr(buffer, ':')) == NULL)
-		ids[0] = ids[1] = parse_rt_num(buffer,"segsleft");
-	else {
-		*cp = '\0';
-		cp++;
-
-		ids[0] = buffer[0] ? parse_rt_num(buffer,"segsleft") : 0;
-		ids[1] = cp[0] ? parse_rt_num(cp,"segsleft") : 0xFFFFFFFF;
-	}
-	free(buffer);
-}
+#undef s
 
 static const char *
 addr_to_numeric(const struct in6_addr *addrp)
@@ -143,83 +106,49 @@ static void rt_init(struct xt_entry_match *m)
 	rtinfo->segsleft[1] = 0xFFFFFFFF;
 }
 
-static int rt_parse(int c, char **argv, int invert, unsigned int *flags,
-                    const void *entry, struct xt_entry_match **match)
+static void rt_parse(struct xt_option_call *cb)
 {
-	struct ip6t_rt *rtinfo = (struct ip6t_rt *)(*match)->data;
+	struct ip6t_rt *rtinfo = cb->data;
 
-	switch (c) {
-	case '1':
-		if (*flags & IP6T_RT_TYP)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Only one `--rt-type' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		rtinfo->rt_type = parse_rt_num(optarg, "type");
-		if (invert)
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_RT_TYPE:
+		if (cb->invert)
 			rtinfo->invflags |= IP6T_RT_INV_TYP;
 		rtinfo->flags |= IP6T_RT_TYP;
-		*flags |= IP6T_RT_TYP;
 		break;
-	case '2':
-		if (*flags & IP6T_RT_SGS)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Only one `--rt-segsleft' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		parse_rt_segsleft(optarg, rtinfo->segsleft);
-		if (invert)
+	case O_RT_SEGSLEFT:
+		if (cb->invert)
 			rtinfo->invflags |= IP6T_RT_INV_SGS;
 		rtinfo->flags |= IP6T_RT_SGS;
-		*flags |= IP6T_RT_SGS;
 		break;
-	case '3':
-		if (*flags & IP6T_RT_LEN)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Only one `--rt-len' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		rtinfo->hdrlen = parse_rt_num(optarg, "length");
-		if (invert)
+	case O_RT_LEN:
+		if (cb->invert)
 			rtinfo->invflags |= IP6T_RT_INV_LEN;
 		rtinfo->flags |= IP6T_RT_LEN;
-		*flags |= IP6T_RT_LEN;
 		break;
-	case '4':
-		if (*flags & IP6T_RT_RES)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Only one `--rt-0-res' allowed");
-		if ( !(*flags & IP6T_RT_TYP) || (rtinfo->rt_type != 0) || (rtinfo->invflags & IP6T_RT_INV_TYP) )
+	case O_RT0RES:
+		if (!(cb->xflags & F_RT_TYPE) || rtinfo->rt_type != 0 ||
+		    rtinfo->invflags & IP6T_RT_INV_TYP)
 			xtables_error(PARAMETER_PROBLEM,
 				   "`--rt-type 0' required before `--rt-0-res'");
 		rtinfo->flags |= IP6T_RT_RES;
-		*flags |= IP6T_RT_RES;
 		break;
-	case '5':
-		if (*flags & IP6T_RT_FST)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Only one `--rt-0-addrs' allowed");
-		if ( !(*flags & IP6T_RT_TYP) || (rtinfo->rt_type != 0) || (rtinfo->invflags & IP6T_RT_INV_TYP) )
+	case O_RT0ADDRS:
+		if (!(cb->xflags & F_RT_TYPE) || rtinfo->rt_type != 0 ||
+		    rtinfo->invflags & IP6T_RT_INV_TYP)
 			xtables_error(PARAMETER_PROBLEM,
 				   "`--rt-type 0' required before `--rt-0-addrs'");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		if (invert)
-			xtables_error(PARAMETER_PROBLEM,
-				   " '!' not allowed with `--rt-0-addrs'");
-		rtinfo->addrnr = parse_addresses(optarg, rtinfo->addrs);
+		rtinfo->addrnr = parse_addresses(cb->arg, rtinfo->addrs);
 		rtinfo->flags |= IP6T_RT_FST;
-		*flags |= IP6T_RT_FST;
 		break;
-	case '6':
-		if (*flags & IP6T_RT_FST_NSTRICT)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Only one `--rt-0-not-strict' allowed");
-		if ( !(*flags & IP6T_RT_FST) )
+	case O_RT0NSTRICT:
+		if (!(cb->xflags & F_RT0ADDRS))
 			xtables_error(PARAMETER_PROBLEM,
 				   "`--rt-0-addr ...' required before `--rt-0-not-strict'");
 		rtinfo->flags |= IP6T_RT_FST_NSTRICT;
-		*flags |= IP6T_RT_FST_NSTRICT;
 		break;
 	}
-
-	return 1;
 }
 
 static void
@@ -322,10 +251,10 @@ static struct xtables_match rt_mt6_reg = {
 	.userspacesize	= XT_ALIGN(sizeof(struct ip6t_rt)),
 	.help		= rt_help,
 	.init		= rt_init,
-	.parse		= rt_parse,
+	.x6_parse	= rt_parse,
 	.print		= rt_print,
 	.save		= rt_save,
-	.extra_opts	= rt_opts,
+	.x6_options	= rt_opts,
 };
 
 void
-- 
1.7.1

