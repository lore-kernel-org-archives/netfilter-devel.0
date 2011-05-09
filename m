From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 12/17] libxt_multiport: use guided option parser
Date: Mon,  9 May 2011 21:55:06 +0200
Message-ID: <1304970912-11520-13-git-send-email-jengelh@medozas.de>
References: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49366 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586Ab1EITza (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 15:55:30 -0400
In-Reply-To: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_multiport.c |  178 +++++++++++++++++-------------------------
 include/xtables.h.in         |    2 +
 xtoptions.c                  |    2 +
 3 files changed, 77 insertions(+), 105 deletions(-)

diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index 7fa537e..03af5a9 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -1,19 +1,23 @@
-/* Shared library add-on to iptables to add multiple TCP port support. */
-#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
 #include <stdlib.h>
-#include <getopt.h>
-
 #include <xtables.h>
-#include <libiptc/libiptc.h>
-#include <libiptc/libip6tc.h>
 #include <limits.h> /* INT_MAX in ip_tables.h/ip6_tables.h */
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter/xt_multiport.h>
 
+enum {
+	O_SOURCE_PORTS = 0,
+	O_DEST_PORTS,
+	O_SD_PORTS,
+	F_SOURCE_PORTS = 1 << O_SOURCE_PORTS,
+	F_DEST_PORTS   = 1 << O_DEST_PORTS,
+	F_SD_PORTS     = 1 << O_SD_PORTS,
+	F_ANY          = F_SOURCE_PORTS | F_DEST_PORTS | F_SD_PORTS,
+};
+
 /* Function which prints out usage message. */
 static void multiport_help(void)
 {
@@ -44,13 +48,18 @@ static void multiport_help_v1(void)
 "				match both source and destination port(s)\n");
 }
 
-static const struct option multiport_opts[] = {
-	{.name = "source-ports",      .has_arg = true, .val = '1'},
-	{.name = "sports",            .has_arg = true, .val = '1'}, /* synonym */
-	{.name = "destination-ports", .has_arg = true, .val = '2'},
-	{.name = "dports",            .has_arg = true, .val = '2'}, /* synonym */
-	{.name = "ports",             .has_arg = true, .val = '3'},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry multiport_opts[] = {
+	{.name = "source-ports", .id = O_SOURCE_PORTS, .type = XTTYPE_STRING,
+	 .excl = F_ANY, .flags = XTOPT_INVERT},
+	{.name = "sports", .id = O_SOURCE_PORTS, .type = XTTYPE_STRING,
+	 .excl = F_ANY, .flags = XTOPT_INVERT},
+	{.name = "destination-ports", .id = O_DEST_PORTS,
+	 .type = XTTYPE_STRING, .excl = F_ANY, .flags = XTOPT_INVERT},
+	{.name = "dports", .id = O_DEST_PORTS, .type = XTTYPE_STRING,
+	 .excl = F_ANY, .flags = XTOPT_INVERT},
+	{.name = "ports", .id = O_SD_PORTS, .type = XTTYPE_STRING,
+	 .excl = F_ANY, .flags = XTOPT_INVERT},
+	XTOPT_TABLEEND,
 };
 
 static const char *
@@ -152,136 +161,97 @@ check_proto(uint16_t pnum, uint8_t invflags)
 			   "multiport only works with TCP, UDP, UDPLITE, SCTP and DCCP");
 }
 
-/* Function which parses command options; returns true if it
-   ate an option */
-static int
-__multiport_parse(int c, char **argv, int invert, unsigned int *flags,
-                  struct xt_entry_match **match, uint16_t pnum,
-                  uint8_t invflags)
+static void __multiport_parse(struct xt_option_call *cb, uint16_t pnum,
+			      uint8_t invflags)
 {
 	const char *proto;
-	struct xt_multiport *multiinfo
-		= (struct xt_multiport *)(*match)->data;
+	struct xt_multiport *multiinfo = cb->data;
 
-	switch (c) {
-	case '1':
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_SOURCE_PORTS:
 		proto = check_proto(pnum, invflags);
-		multiinfo->count = parse_multi_ports(optarg,
+		multiinfo->count = parse_multi_ports(cb->arg,
 						     multiinfo->ports, proto);
 		multiinfo->flags = XT_MULTIPORT_SOURCE;
 		break;
-
-	case '2':
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
+	case O_DEST_PORTS:
 		proto = check_proto(pnum, invflags);
-		multiinfo->count = parse_multi_ports(optarg,
+		multiinfo->count = parse_multi_ports(cb->arg,
 						     multiinfo->ports, proto);
 		multiinfo->flags = XT_MULTIPORT_DESTINATION;
 		break;
-
-	case '3':
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
+	case O_SD_PORTS:
 		proto = check_proto(pnum, invflags);
-		multiinfo->count = parse_multi_ports(optarg,
+		multiinfo->count = parse_multi_ports(cb->arg,
 						     multiinfo->ports, proto);
 		multiinfo->flags = XT_MULTIPORT_EITHER;
 		break;
 	}
-
-	if (invert)
+	if (cb->invert)
 		xtables_error(PARAMETER_PROBLEM,
-			   "multiport does not support invert");
-
-	if (*flags)
-		xtables_error(PARAMETER_PROBLEM,
-			   "multiport can only have one option");
-	*flags = 1;
-	return 1;
+			   "multiport.0 does not support invert");
 }
 
-static int
-multiport_parse(int c, char **argv, int invert, unsigned int *flags,
-                const void *e, struct xt_entry_match **match)
+static void multiport_parse(struct xt_option_call *cb)
 {
-	const struct ipt_entry *entry = e;
-	return __multiport_parse(c, argv, invert, flags, match,
+	const struct ipt_entry *entry = cb->xt_entry;
+	return __multiport_parse(cb,
 	       entry->ip.proto, entry->ip.invflags);
 }
 
-static int
-multiport_parse6(int c, char **argv, int invert, unsigned int *flags,
-                 const void *e, struct xt_entry_match **match)
+static void multiport_parse6(struct xt_option_call *cb)
 {
-	const struct ip6t_entry *entry = e;
-	return __multiport_parse(c, argv, invert, flags, match,
+	const struct ip6t_entry *entry = cb->xt_entry;
+	return __multiport_parse(cb,
 	       entry->ipv6.proto, entry->ipv6.invflags);
 }
 
-static int
-__multiport_parse_v1(int c, char **argv, int invert, unsigned int *flags,
-                     struct xt_entry_match **match, uint16_t pnum,
-                     uint8_t invflags)
+static void __multiport_parse_v1(struct xt_option_call *cb, uint16_t pnum,
+				 uint8_t invflags)
 {
 	const char *proto;
-	struct xt_multiport_v1 *multiinfo
-		= (struct xt_multiport_v1 *)(*match)->data;
+	struct xt_multiport_v1 *multiinfo = cb->data;
 
-	switch (c) {
-	case '1':
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_SOURCE_PORTS:
 		proto = check_proto(pnum, invflags);
-		parse_multi_ports_v1(optarg, multiinfo, proto);
+		parse_multi_ports_v1(cb->arg, multiinfo, proto);
 		multiinfo->flags = XT_MULTIPORT_SOURCE;
 		break;
-
-	case '2':
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
+	case O_DEST_PORTS:
 		proto = check_proto(pnum, invflags);
-		parse_multi_ports_v1(optarg, multiinfo, proto);
+		parse_multi_ports_v1(cb->arg, multiinfo, proto);
 		multiinfo->flags = XT_MULTIPORT_DESTINATION;
 		break;
-
-	case '3':
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
+	case O_SD_PORTS:
 		proto = check_proto(pnum, invflags);
-		parse_multi_ports_v1(optarg, multiinfo, proto);
+		parse_multi_ports_v1(cb->arg, multiinfo, proto);
 		multiinfo->flags = XT_MULTIPORT_EITHER;
 		break;
 	}
-
-	if (invert)
+	if (cb->invert)
 		multiinfo->invert = 1;
-
-	if (*flags)
-		xtables_error(PARAMETER_PROBLEM,
-			   "multiport can only have one option");
-	*flags = 1;
-	return 1;
 }
 
-static int
-multiport_parse_v1(int c, char **argv, int invert, unsigned int *flags,
-                   const void *e, struct xt_entry_match **match)
+static void multiport_parse_v1(struct xt_option_call *cb)
 {
-	const struct ipt_entry *entry = e;
-	return __multiport_parse_v1(c, argv, invert, flags, match,
+	const struct ipt_entry *entry = cb->xt_entry;
+	return __multiport_parse_v1(cb,
 	       entry->ip.proto, entry->ip.invflags);
 }
 
-static int
-multiport_parse6_v1(int c, char **argv, int invert, unsigned int *flags,
-                    const void *e, struct xt_entry_match **match)
+static void multiport_parse6_v1(struct xt_option_call *cb)
 {
-	const struct ip6t_entry *entry = e;
-	return __multiport_parse_v1(c, argv, invert, flags, match,
+	const struct ip6t_entry *entry = cb->xt_entry;
+	return __multiport_parse_v1(cb,
 	       entry->ipv6.proto, entry->ipv6.invflags);
 }
 
-/* Final check; must specify something. */
-static void multiport_check(unsigned int flags)
+static void multiport_check(struct xt_fcheck_call *cb)
 {
-	if (!flags)
+	if (cb->xflags == 0)
 		xtables_error(PARAMETER_PROBLEM, "multiport expection an option");
 }
 
@@ -307,7 +277,6 @@ print_port(uint16_t port, uint8_t protocol, int numeric)
 		printf("%s", service);
 }
 
-/* Prints out the matchinfo. */
 static void
 __multiport_print(const struct xt_entry_match *match, int numeric,
                   uint16_t proto)
@@ -410,7 +379,6 @@ static void multiport_print6_v1(const void *ip_void,
 	__multiport_print_v1(match, numeric, ip->proto);
 }
 
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void __multiport_save(const struct xt_entry_match *match,
                              uint16_t proto)
 {
@@ -509,11 +477,11 @@ static struct xtables_match multiport_mt_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct xt_multiport)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_multiport)),
 		.help          = multiport_help,
-		.parse         = multiport_parse,
-		.final_check   = multiport_check,
+		.x6_parse      = multiport_parse,
+		.x6_fcheck     = multiport_check,
 		.print         = multiport_print,
 		.save          = multiport_save,
-		.extra_opts    = multiport_opts,
+		.x6_options    = multiport_opts,
 	},
 	{
 		.family        = NFPROTO_IPV6,
@@ -523,11 +491,11 @@ static struct xtables_match multiport_mt_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct xt_multiport)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_multiport)),
 		.help          = multiport_help,
-		.parse         = multiport_parse6,
-		.final_check   = multiport_check,
+		.x6_parse      = multiport_parse6,
+		.x6_fcheck     = multiport_check,
 		.print         = multiport_print6,
 		.save          = multiport_save6,
-		.extra_opts    = multiport_opts,
+		.x6_options    = multiport_opts,
 	},
 	{
 		.family        = NFPROTO_IPV4,
@@ -537,11 +505,11 @@ static struct xtables_match multiport_mt_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct xt_multiport_v1)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_multiport_v1)),
 		.help          = multiport_help_v1,
-		.parse         = multiport_parse_v1,
-		.final_check   = multiport_check,
+		.x6_parse      = multiport_parse_v1,
+		.x6_fcheck     = multiport_check,
 		.print         = multiport_print_v1,
 		.save          = multiport_save_v1,
-		.extra_opts    = multiport_opts,
+		.x6_options    = multiport_opts,
 	},
 	{
 		.family        = NFPROTO_IPV6,
@@ -551,11 +519,11 @@ static struct xtables_match multiport_mt_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct xt_multiport_v1)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_multiport_v1)),
 		.help          = multiport_help_v1,
-		.parse         = multiport_parse6_v1,
-		.final_check   = multiport_check,
+		.x6_parse      = multiport_parse6_v1,
+		.x6_fcheck     = multiport_check,
 		.print         = multiport_print6_v1,
 		.save          = multiport_save6_v1,
-		.extra_opts    = multiport_opts,
+		.x6_options    = multiport_opts,
 	},
 };
 
diff --git a/include/xtables.h.in b/include/xtables.h.in
index caaec2f..50aa414 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -163,10 +163,12 @@ struct xt_option_call {
 			uint32_t mark, mask;
 		};
 	} val;
+	/* Wished for a world where the ones below were gone: */
 	union {
 		struct xt_entry_match **match;
 		struct xt_entry_target **target;
 	};
+	void *xt_entry;
 };
 
 /**
diff --git a/xtoptions.c b/xtoptions.c
index 36f90e4..413de1b 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -808,6 +808,7 @@ void xtables_option_tpcall(unsigned int c, char **argv, bool invert,
 	cb.data     = t->t->data;
 	cb.xflags   = t->tflags;
 	cb.target   = &t->t;
+	cb.xt_entry = fw;
 	t->x6_parse(&cb);
 	t->tflags = cb.xflags;
 }
@@ -842,6 +843,7 @@ void xtables_option_mpcall(unsigned int c, char **argv, bool invert,
 	cb.data     = m->m->data;
 	cb.xflags   = m->mflags;
 	cb.match    = &m->m;
+	cb.xt_entry = fw;
 	m->x6_parse(&cb);
 	m->mflags = cb.xflags;
 }
-- 
1.7.1

