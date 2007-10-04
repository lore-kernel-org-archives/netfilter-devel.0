From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 07/13] Unique symbols 1/6
Date: Thu, 4 Oct 2007 12:12:48 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710041209540.7253@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710041209210.7253@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58029 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957AbXJDKMu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Oct 2007 06:12:50 -0400
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id 3346A1C0624CB
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Oct 2007 12:12:48 +0200 (CEST)
In-Reply-To: <Pine.LNX.4.64.0710041209210.7253@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Give symbols of libxt matches unique names (1/3).

Adds unique prefixes to all functions (most of them - especially the hook
functions) so that debugging programs can unambiguously map a symbol to an
address. Also unifies the names of the xtables_match/xtables_target structs,
(based upon libxt_connmark.c/libip6t_*.c).

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 extensions/libxt_comment.c   |   51 +++++-------
 extensions/libxt_connbytes.c |   50 +++++------
 extensions/libxt_connlimit.c |    8 -
 extensions/libxt_connmark.c  |   44 ++++------
 extensions/libxt_dccp.c      |   54 +++++-------
 extensions/libxt_dscp.c      |   51 +++++-------
 extensions/libxt_esp.c       |   50 +++++------
 extensions/libxt_hashlimit.c |   59 ++++++--------
 extensions/libxt_helper.c    |   52 +++++-------
 extensions/libxt_length.c    |   52 +++++-------
 extensions/libxt_limit.c     |   51 +++++-------
 extensions/libxt_mac.c       |   50 +++++------
 extensions/libxt_mark.c      |   51 +++++-------
 extensions/libxt_multiport.c |  180 +++++++++++++++++++++----------------------
 extensions/libxt_physdev.c   |   50 +++++------
 extensions/libxt_pkttype.c   |   50 +++++------
 extensions/libxt_quota.c     |   42 ++++------
 extensions/libxt_sctp.c      |   52 +++++-------
 extensions/libxt_standard.c  |   27 ++----
 extensions/libxt_statistic.c |   52 +++++-------
 extensions/libxt_string.c    |   63 ++++++---------
 extensions/libxt_tcp.c       |   50 +++++------
 extensions/libxt_tcpmss.c    |   52 +++++-------
 extensions/libxt_time.c      |    8 -
 extensions/libxt_u32.c       |    8 -
 extensions/libxt_udp.c       |   52 +++++-------
 26 files changed, 600 insertions(+), 709 deletions(-)

Index: iptables/extensions/libxt_comment.c
===================================================================
--- iptables.orig/extensions/libxt_comment.c
+++ iptables/extensions/libxt_comment.c
@@ -15,8 +15,7 @@
 #include <linux/netfilter/xt_comment.h>
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void comment_help(void)
 {
 	printf(
 		"COMMENT match options:\n"
@@ -24,7 +23,7 @@ help(void)
 		);
 }
 
-static const struct option opts[] = {
+static const struct option comment_opts[] = {
 	{ "comment", 1, NULL, '1' },
 	{ }
 };
@@ -44,9 +43,8 @@ parse_comment(const char *s, struct xt_c
 /* Function which parses command options; returns true if it
    ate an option */
 static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+comment_parse(int c, char **argv, int invert, unsigned int *flags,
+              const void *entry, struct xt_entry_match **match)
 {
 	struct xt_comment_info *commentinfo = (struct xt_comment_info *)(*match)->data;
 
@@ -68,8 +66,7 @@ parse(int c, char **argv, int invert, un
 }
 
 /* Final check; must have specified --comment. */
-static void
-final_check(unsigned int flags)
+static void comment_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
@@ -78,9 +75,7 @@ final_check(unsigned int flags)
 
 /* Prints out the matchinfo. */
 static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
+comment_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	struct xt_comment_info *commentinfo = (struct xt_comment_info *)match->data;
 
@@ -90,7 +85,7 @@ print(const void *ip,
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
-save(const void *ip, const struct xt_entry_match *match)
+comment_save(const void *ip, const struct xt_entry_match *match)
 {
 	struct xt_comment_info *commentinfo = (struct xt_comment_info *)match->data;
 
@@ -98,36 +93,36 @@ save(const void *ip, const struct xt_ent
 	printf("--comment \"%s\" ", commentinfo->comment);
 }
 
-static struct xtables_match comment = {
+static struct xtables_match comment_match = {
 	.family		= AF_INET,
 	.name		= "comment",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_comment_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_comment_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print 		= &print,
-	.save 		= &save,
-	.extra_opts	= opts
+	.help		= comment_help,
+	.parse		= comment_parse,
+	.final_check	= comment_check,
+	.print 		= comment_print,
+	.save 		= comment_save,
+	.extra_opts	= comment_opts,
 };
 
-static struct xtables_match comment6 = {
+static struct xtables_match comment_match6 = {
 	.family		= AF_INET6,
 	.name		= "comment",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_comment_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_comment_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print 		= &print,
-	.save 		= &save,
-	.extra_opts	= opts
+	.help		= comment_help,
+	.parse		= comment_parse,
+	.final_check	= comment_check,
+	.print 		= comment_print,
+	.save 		= comment_save,
+	.extra_opts	= comment_opts,
 };
 
 void _init(void)
 {
-	xtables_register_match(&comment);
-	xtables_register_match(&comment6);
+	xtables_register_match(&comment_match);
+	xtables_register_match(&comment_match6);
 }
Index: iptables/extensions/libxt_connbytes.c
===================================================================
--- iptables.orig/extensions/libxt_connbytes.c
+++ iptables/extensions/libxt_connbytes.c
@@ -9,8 +9,7 @@
 #include <linux/netfilter/xt_connbytes.h>
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void connbytes_help(void)
 {
 	printf(
 "connbytes v%s options:\n"
@@ -20,7 +19,7 @@ help(void)
 "\n", IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option connbytes_opts[] = {
 	{ "connbytes", 1, NULL, '1' },
 	{ "connbytes-dir", 1, NULL, '2' },
 	{ "connbytes-mode", 1, NULL, '3' },
@@ -49,9 +48,8 @@ parse_range(const char *arg, struct xt_c
 /* Function which parses command options; returns true if it
    ate an option */
 static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+connbytes_parse(int c, char **argv, int invert, unsigned int *flags,
+                const void *entry, struct xt_entry_match **match)
 {
 	struct xt_connbytes_info *sinfo = (struct xt_connbytes_info *)(*match)->data;
 	unsigned long i;
@@ -101,7 +99,7 @@ parse(int c, char **argv, int invert, un
 	return 1;
 }
 
-static void final_check(unsigned int flags)
+static void connbytes_check(unsigned int flags)
 {
 	if (flags != 7)
 		exit_error(PARAMETER_PROBLEM, "You must specify `--connbytes'"
@@ -146,9 +144,7 @@ static void print_direction(struct xt_co
 
 /* Prints out the matchinfo. */
 static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
+connbytes_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	struct xt_connbytes_info *sinfo = (struct xt_connbytes_info *)match->data;
 
@@ -169,7 +165,7 @@ print(const void *ip,
 }
 
 /* Saves the matchinfo in parsable form to stdout. */
-static void save(const void *ip, const struct xt_entry_match *match)
+static void connbytes_save(const void *ip, const struct xt_entry_match *match)
 {
 	struct xt_connbytes_info *sinfo = (struct xt_connbytes_info *)match->data;
 
@@ -189,36 +185,36 @@ static void save(const void *ip, const s
 	print_direction(sinfo);
 }
 
-static struct xtables_match state = {
+static struct xtables_match connbytes_match = {
 	.family		= AF_INET,
 	.name 		= "connbytes",
 	.version 	= IPTABLES_VERSION,
 	.size 		= XT_ALIGN(sizeof(struct xt_connbytes_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_connbytes_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save 		= &save,
-	.extra_opts	= opts
+	.help		= connbytes_help,
+	.parse		= connbytes_parse,
+	.final_check	= connbytes_check,
+	.print		= connbytes_print,
+	.save 		= connbytes_save,
+	.extra_opts	= connbytes_opts,
 };
 
-static struct xtables_match state6 = {
+static struct xtables_match connbytes_match6 = {
 	.family		= AF_INET6,
 	.name 		= "connbytes",
 	.version 	= IPTABLES_VERSION,
 	.size 		= XT_ALIGN(sizeof(struct xt_connbytes_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_connbytes_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save 		= &save,
-	.extra_opts	= opts
+	.help		= connbytes_help,
+	.parse		= connbytes_parse,
+	.final_check	= connbytes_check,
+	.print		= connbytes_print,
+	.save 		= connbytes_save,
+	.extra_opts	= connbytes_opts,
 };
 
 void _init(void)
 {
-	xtables_register_match(&state);
-	xtables_register_match(&state6);
+	xtables_register_match(&connbytes_match);
+	xtables_register_match(&connbytes_match6);
 }
Index: iptables/extensions/libxt_connlimit.c
===================================================================
--- iptables.orig/extensions/libxt_connlimit.c
+++ iptables/extensions/libxt_connlimit.c
@@ -178,7 +178,7 @@ static void connlimit_save6(const void *
 	       count_bits6(info->v6_mask));
 }
 
-static struct xtables_match connlimit_reg4 = {
+static struct xtables_match connlimit_match = {
 	.name          = "connlimit",
 	.family        = AF_INET,
 	.version       = IPTABLES_VERSION,
@@ -193,7 +193,7 @@ static struct xtables_match connlimit_re
 	.extra_opts    = connlimit_opts,
 };
 
-static struct xtables_match connlimit_reg6 = {
+static struct xtables_match connlimit_match6 = {
 	.name          = "connlimit",
 	.family        = AF_INET6,
 	.version       = IPTABLES_VERSION,
@@ -210,6 +210,6 @@ static struct xtables_match connlimit_re
 
 void _init(void)
 {
-	xtables_register_match(&connlimit_reg4);
-	xtables_register_match(&connlimit_reg6);
+	xtables_register_match(&connlimit_match);
+	xtables_register_match(&connlimit_match6);
 }
Index: iptables/extensions/libxt_connmark.c
===================================================================
--- iptables.orig/extensions/libxt_connmark.c
+++ iptables/extensions/libxt_connmark.c
@@ -29,8 +29,7 @@
 #include <linux/netfilter/xt_connmark.h>
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void connmark_help(void)
 {
 	printf(
 "CONNMARK match v%s options:\n"
@@ -39,7 +38,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option connmark_opts[] = {
 	{ "mark", 1, NULL, '1' },
 	{ }
 };
@@ -47,9 +46,8 @@ static const struct option opts[] = {
 /* Function which parses command options; returns true if it
    ate an option */
 static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+connmark_parse(int c, char **argv, int invert, unsigned int *flags,
+               const void *entry, struct xt_entry_match **match)
 {
 	struct xt_connmark_info *markinfo = (struct xt_connmark_info *)(*match)->data;
 
@@ -87,8 +85,7 @@ print_mark(unsigned long mark, unsigned 
 }
 
 /* Final check; must have specified --mark. */
-static void
-final_check(unsigned int flags)
+static void connmark_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
@@ -97,9 +94,7 @@ final_check(unsigned int flags)
 
 /* Prints out the matchinfo. */
 static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
+connmark_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	struct xt_connmark_info *info = (struct xt_connmark_info *)match->data;
 
@@ -110,8 +105,7 @@ print(const void *ip,
 }
 
 /* Saves the matchinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_match *match)
+static void connmark_save(const void *ip, const struct xt_entry_match *match)
 {
 	struct xt_connmark_info *info = (struct xt_connmark_info *)match->data;
 
@@ -128,12 +122,12 @@ static struct xtables_match connmark_mat
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_connmark_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_connmark_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= connmark_help,
+	.parse		= connmark_parse,
+	.final_check	= connmark_check,
+	.print		= connmark_print,
+	.save		= connmark_save,
+	.extra_opts	= connmark_opts,
 };
 
 static struct xtables_match connmark_match6 = {
@@ -142,12 +136,12 @@ static struct xtables_match connmark_mat
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_connmark_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_connmark_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= connmark_help,
+	.parse		= connmark_parse,
+	.final_check	= connmark_check,
+	.print		= connmark_print,
+	.save		= connmark_save,
+	.extra_opts	= connmark_opts,
 };
 
 void _init(void)
Index: iptables/extensions/libxt_dccp.c
===================================================================
--- iptables.orig/extensions/libxt_dccp.c
+++ iptables/extensions/libxt_dccp.c
@@ -25,15 +25,14 @@
 #endif
 
 /* Initialize the match. */
-static void
-init(struct xt_entry_match *m)
+static void dccp_init(struct xt_entry_match *m)
 {
 	struct xt_dccp_info *einfo = (struct xt_dccp_info *)m->data;
 
 	memset(einfo, 0, sizeof(struct xt_dccp_info));
 }
 
-static void help(void)
+static void dccp_help(void)
 {
 	printf(
 "DCCP match v%s options\n"
@@ -45,7 +44,7 @@ static void help(void)
 	IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option dccp_opts[] = {
 	{ .name = "source-port", .has_arg = 1, .val = '1' },
 	{ .name = "sport", .has_arg = 1, .val = '1' },
 	{ .name = "destination-port", .has_arg = 1, .val = '2' },
@@ -132,9 +131,8 @@ static u_int8_t parse_dccp_option(char *
 }
 
 static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+dccp_parse(int c, char **argv, int invert, unsigned int *flags,
+           const void *entry, struct xt_entry_match **match)
 {
 	struct xt_dccp_info *einfo
 		= (struct xt_dccp_info *)(*match)->data;
@@ -272,9 +270,7 @@ print_option(u_int8_t option, int invert
 
 /* Prints out the matchinfo. */
 static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
+dccp_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	const struct xt_dccp_info *einfo =
 		(const struct xt_dccp_info *)match->data;
@@ -306,9 +302,7 @@ print(const void *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void
-save(const void *ip,
-     const struct xt_entry_match *match)
+static void dccp_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_dccp_info *einfo =
 		(const struct xt_dccp_info *)match->data;
@@ -345,39 +339,37 @@ save(const void *ip,
 	}
 }
 
-static struct xtables_match dccp =
-{
+static struct xtables_match dccp_match = {
 	.name		= "dccp",
 	.family		= AF_INET,
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_dccp_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_dccp_info)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= dccp_help,
+	.init		= dccp_init,
+	.parse		= dccp_parse,
+	.print		= dccp_print,
+	.save		= dccp_save,
+	.extra_opts	= dccp_opts,
 };
 
-static struct xtables_match dccp6 =
-{
+static struct xtables_match dccp_match6 = {
 	.name		= "dccp",
 	.family		= AF_INET6,
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_dccp_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_dccp_info)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= dccp_help,
+	.init		= dccp_init,
+	.parse		= dccp_parse,
+	.print		= dccp_print,
+	.save		= dccp_save,
+	.extra_opts	= dccp_opts,
 };
 
 void _init(void)
 {
-	xtables_register_match(&dccp);
-	xtables_register_match(&dccp6);
+	xtables_register_match(&dccp_match);
+	xtables_register_match(&dccp_match6);
 }
 
Index: iptables/extensions/libxt_dscp.c
===================================================================
--- iptables.orig/extensions/libxt_dscp.c
+++ iptables/extensions/libxt_dscp.c
@@ -24,7 +24,7 @@
 /* This is evil, but it's my code - HW*/
 #include "libipt_dscp_helper.c"
 
-static void help(void) 
+static void dscp_help(void)
 {
 	printf(
 "DSCP match v%s options\n"
@@ -39,7 +39,7 @@ static void help(void) 
 );
 }
 
-static const struct option opts[] = {
+static const struct option dscp_opts[] = {
 	{ "dscp", 1, NULL, 'F' },
 	{ "dscp-class", 1, NULL, 'G' },
 	{ }
@@ -74,9 +74,8 @@ parse_class(const char *s, struct xt_dsc
 
 
 static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+dscp_parse(int c, char **argv, int invert, unsigned int *flags,
+           const void *entry, struct xt_entry_match **match)
 {
 	struct xt_dscp_info *dinfo
 		= (struct xt_dscp_info *)(*match)->data;
@@ -111,8 +110,7 @@ parse(int c, char **argv, int invert, un
 	return 1;
 }
 
-static void
-final_check(unsigned int flags)
+static void dscp_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
@@ -130,9 +128,7 @@ print_dscp(u_int8_t dscp, int invert, in
 
 /* Prints out the matchinfo. */
 static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
+dscp_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	const struct xt_dscp_info *dinfo =
 		(const struct xt_dscp_info *)match->data;
@@ -141,8 +137,7 @@ print(const void *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_match *match)
+static void dscp_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_dscp_info *dinfo =
 		(const struct xt_dscp_info *)match->data;
@@ -151,36 +146,36 @@ save(const void *ip, const struct xt_ent
 	print_dscp(dinfo->dscp, dinfo->invert, 1);
 }
 
-static struct xtables_match dscp = { 
+static struct xtables_match dscp_match = {
 	.family		= AF_INET,
 	.name 		= "dscp",
 	.version 	= IPTABLES_VERSION,
 	.size 		= XT_ALIGN(sizeof(struct xt_dscp_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_dscp_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= dscp_help,
+	.parse		= dscp_parse,
+	.final_check	= dscp_check,
+	.print		= dscp_print,
+	.save		= dscp_save,
+	.extra_opts	= dscp_opts,
 };
 
-static struct xtables_match dscp6 = { 
+static struct xtables_match dscp_match6 = {
 	.family		= AF_INET6,
 	.name 		= "dscp",
 	.version 	= IPTABLES_VERSION,
 	.size 		= XT_ALIGN(sizeof(struct xt_dscp_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_dscp_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= dscp_help,
+	.parse		= dscp_parse,
+	.final_check	= dscp_check,
+	.print		= dscp_print,
+	.save		= dscp_save,
+	.extra_opts	= dscp_opts,
 };
 
 void _init(void)
 {
-	xtables_register_match(&dscp);
-	xtables_register_match(&dscp6);
+	xtables_register_match(&dscp_match);
+	xtables_register_match(&dscp_match6);
 }
Index: iptables/extensions/libxt_esp.c
===================================================================
--- iptables.orig/extensions/libxt_esp.c
+++ iptables/extensions/libxt_esp.c
@@ -9,8 +9,7 @@
 #include <linux/netfilter/xt_esp.h>
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void esp_help(void)
 {
 	printf(
 "ESP v%s options:\n"
@@ -19,7 +18,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option esp_opts[] = {
 	{ "espspi", 1, NULL, '1' },
 	{ }
 };
@@ -70,8 +69,7 @@ parse_esp_spis(const char *spistring, u_
 }
 
 /* Initialize the match. */
-static void
-init(struct xt_entry_match *m)
+static void esp_init(struct xt_entry_match *m)
 {
 	struct xt_esp *espinfo = (struct xt_esp *)m->data;
 
@@ -83,9 +81,8 @@ init(struct xt_entry_match *m)
 /* Function which parses command options; returns true if it
    ate an option */
 static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+esp_parse(int c, char **argv, int invert, unsigned int *flags,
+          const void *entry, struct xt_entry_match **match)
 {
 	struct xt_esp *espinfo = (struct xt_esp *)(*match)->data;
 
@@ -123,8 +120,7 @@ print_spis(const char *name, u_int32_t m
 
 /* Prints out the union ipt_matchinfo. */
 static void
-print(const void *ip,
-      const struct xt_entry_match *match, int numeric)
+esp_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	const struct xt_esp *esp = (struct xt_esp *)match->data;
 
@@ -137,7 +133,7 @@ print(const void *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const void *ip, const struct xt_entry_match *match)
+static void esp_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_esp *espinfo = (struct xt_esp *)match->data;
 
@@ -157,37 +153,37 @@ static void save(const void *ip, const s
 
 }
 
-static struct xtables_match esp = { 
+static struct xtables_match esp_match = {
 	.family		= AF_INET,
 	.name 		= "esp",
 	.version 	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_esp)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_esp)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= esp_help,
+	.init		= esp_init,
+	.parse		= esp_parse,
+	.print		= esp_print,
+	.save		= esp_save,
+	.extra_opts	= esp_opts,
 };
 
-static struct xtables_match esp6 = { 
+static struct xtables_match esp_match6 = {
 	.family		= AF_INET6,
 	.name 		= "esp",
 	.version 	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_esp)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_esp)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= esp_help,
+	.init		= esp_init,
+	.parse		= esp_parse,
+	.print		= esp_print,
+	.save		= esp_save,
+	.extra_opts	= esp_opts,
 };
 
 void
 _init(void)
 {
-	xtables_register_match(&esp);
-	xtables_register_match(&esp6);
+	xtables_register_match(&esp_match);
+	xtables_register_match(&esp_match6);
 }
Index: iptables/extensions/libxt_hashlimit.c
===================================================================
--- iptables.orig/extensions/libxt_hashlimit.c
+++ iptables/extensions/libxt_hashlimit.c
@@ -27,8 +27,7 @@
 #define XT_HASHLIMIT_EXPIRE	10000
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void hashlimit_help(void)
 {
 	printf(
 "hashlimit v%s options:\n"
@@ -46,7 +45,7 @@ help(void)
 "\n", IPTABLES_VERSION, XT_HASHLIMIT_BURST);
 }
 
-static const struct option opts[] = {
+static const struct option hashlimit_opts[] = {
 	{ "hashlimit", 1, NULL, '%' },
 	{ "hashlimit-burst", 1, NULL, '$' },
 	{ "hashlimit-htable-size", 1, NULL, '&' },
@@ -95,8 +94,7 @@ int parse_rate(const char *rate, u_int32
 }
 
 /* Initialize the match. */
-static void
-init(struct xt_entry_match *m)
+static void hashlimit_init(struct xt_entry_match *m)
 {
 	struct xt_hashlimit_info *r = (struct xt_hashlimit_info *)m->data;
 
@@ -150,9 +148,8 @@ static int parse_mode(struct xt_hashlimi
 /* Function which parses command options; returns true if it
    ate an option */
 static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
+                const void *entry, struct xt_entry_match **match)
 {
 	struct xt_hashlimit_info *r = 
 			(struct xt_hashlimit_info *)(*match)->data;
@@ -236,7 +233,7 @@ parse(int c, char **argv, int invert, un
 }
 
 /* Final check; nothing. */
-static void final_check(unsigned int flags)
+static void hashlimit_check(unsigned int flags)
 {
 	if (!(flags & PARAM_LIMIT))
 		exit_error(PARAMETER_PROBLEM,
@@ -302,10 +299,8 @@ static void print_mode(const struct xt_h
 }
 
 /* Prints out the matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
+static void hashlimit_print(const void *ip,
+                            const struct xt_entry_match *match, int numeric)
 {
 	struct xt_hashlimit_info *r = 
 		(struct xt_hashlimit_info *)match->data;
@@ -324,7 +319,7 @@ print(const void *ip,
 }
 
 /* FIXME: Make minimalist: only print rate if not default --RR */
-static void save(const void *ip, const struct xt_entry_match *match)
+static void hashlimit_save(const void *ip, const struct xt_entry_match *match)
 {
 	struct xt_hashlimit_info *r = 
 		(struct xt_hashlimit_info *)match->data;
@@ -348,38 +343,38 @@ static void save(const void *ip, const s
 		printf("--hashlimit-htable-expire %u ", r->cfg.expire);
 }
 
-static struct xtables_match hashlimit = {
+static struct xtables_match hashlimit_match = {
 	.family		= AF_INET,
 	.name		= "hashlimit",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_hashlimit_info)),
 	.userspacesize	= offsetof(struct xt_hashlimit_info, hinfo),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts,
+	.help		= hashlimit_help,
+	.init		= hashlimit_init,
+	.parse		= hashlimit_parse,
+	.final_check	= hashlimit_check,
+	.print		= hashlimit_print,
+	.save		= hashlimit_save,
+	.extra_opts	= hashlimit_opts,
 };
 
-static struct xtables_match hashlimit6 = {
+static struct xtables_match hashlimit_match6 = {
 	.family		= AF_INET6,
 	.name		= "hashlimit",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_hashlimit_info)),
 	.userspacesize	= offsetof(struct xt_hashlimit_info, hinfo),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts,
+	.help		= hashlimit_help,
+	.init		= hashlimit_init,
+	.parse		= hashlimit_parse,
+	.final_check	= hashlimit_check,
+	.print		= hashlimit_print,
+	.save		= hashlimit_save,
+	.extra_opts	= hashlimit_opts,
 };
 
 void _init(void)
 {
-	xtables_register_match(&hashlimit);
-	xtables_register_match(&hashlimit6);
+	xtables_register_match(&hashlimit_match);
+	xtables_register_match(&hashlimit_match6);
 }
Index: iptables/extensions/libxt_helper.c
===================================================================
--- iptables.orig/extensions/libxt_helper.c
+++ iptables/extensions/libxt_helper.c
@@ -9,8 +9,7 @@
 #include <linux/netfilter/xt_helper.h>
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void helper_help(void)
 {
 	printf(
 "helper match v%s options:\n"
@@ -19,7 +18,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option helper_opts[] = {
 	{ "helper", 1, NULL, '1' },
 	{ }
 };
@@ -27,9 +26,8 @@ static const struct option opts[] = {
 /* Function which parses command options; returns true if it
    ate an option */
 static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+helper_parse(int c, char **argv, int invert, unsigned int *flags,
+             const void *entry, struct xt_entry_match **match)
 {
 	struct xt_helper_info *info = (struct xt_helper_info *)(*match)->data;
 
@@ -53,8 +51,7 @@ parse(int c, char **argv, int invert, un
 }
 
 /* Final check; must have specified --helper. */
-static void
-final_check(unsigned int flags)
+static void helper_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
@@ -63,9 +60,7 @@ final_check(unsigned int flags)
 
 /* Prints out the info. */
 static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
+helper_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	struct xt_helper_info *info = (struct xt_helper_info *)match->data;
 
@@ -73,42 +68,41 @@ print(const void *ip,
 }
 
 /* Saves the union ipt_info in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_match *match)
+static void helper_save(const void *ip, const struct xt_entry_match *match)
 {
 	struct xt_helper_info *info = (struct xt_helper_info *)match->data;
 
 	printf("%s--helper \"%s\" ",info->invert ? "! " : "", info->name);
 }
 
-static struct xtables_match helper = { 
+static struct xtables_match helper_match = {
 	.family		= AF_INET,
 	.name		= "helper",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_helper_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts,
+	.help		= helper_help,
+	.parse		= helper_parse,
+	.final_check	= helper_check,
+	.print		= helper_print,
+	.save		= helper_save,
+	.extra_opts	= helper_opts,
 };
 
-static struct xtables_match helper6 = { 
+static struct xtables_match helper_match6 = {
 	.family		= AF_INET6,
 	.name		= "helper",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_helper_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts,
+	.help		= helper_help,
+	.parse		= helper_parse,
+	.final_check	= helper_check,
+	.print		= helper_print,
+	.save		= helper_save,
+	.extra_opts	= helper_opts,
 };
 
 void _init(void)
 {
-	xtables_register_match(&helper);
-	xtables_register_match(&helper6);
+	xtables_register_match(&helper_match);
+	xtables_register_match(&helper_match6);
 }
Index: iptables/extensions/libxt_length.c
===================================================================
--- iptables.orig/extensions/libxt_length.c
+++ iptables/extensions/libxt_length.c
@@ -9,8 +9,7 @@
 #include <linux/netfilter/xt_length.h>
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void length_help(void)
 {
 	printf(
 "length v%s options:\n"
@@ -20,7 +19,7 @@ IPTABLES_VERSION);
 
 }
   
-static const struct option opts[] = {
+static const struct option length_opts[] = {
 	{ "length", 1, NULL, '1' },
 	{ }
 };
@@ -65,9 +64,8 @@ parse_lengths(const char *s, struct xt_l
 /* Function which parses command options; returns true if it
    ate an option */
 static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+length_parse(int c, char **argv, int invert, unsigned int *flags,
+             const void *entry, struct xt_entry_match **match)
 {
 	struct xt_length_info *info = (struct xt_length_info *)(*match)->data;
 
@@ -91,8 +89,7 @@ parse(int c, char **argv, int invert, un
 }
 
 /* Final check; must have specified --length. */
-static void
-final_check(unsigned int flags)
+static void length_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
@@ -114,52 +111,49 @@ print_length(struct xt_length_info *info
 
 /* Prints out the matchinfo. */
 static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
+length_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	printf("length ");
 	print_length((struct xt_length_info *)match->data);
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_match *match)
+static void length_save(const void *ip, const struct xt_entry_match *match)
 {
 	printf("--length ");
 	print_length((struct xt_length_info *)match->data);
 }
 
-static struct xtables_match length = { 
+static struct xtables_match length_match = {
 	.family		= AF_INET,
 	.name		= "length",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_length_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_length_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= length_help,
+	.parse		= length_parse,
+	.final_check	= length_check,
+	.print		= length_print,
+	.save		= length_save,
+	.extra_opts	= length_opts,
 };
 
-static struct xtables_match length6 = { 
+static struct xtables_match length_match6 = {
 	.family		= AF_INET6,
 	.name		= "length",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_length_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_length_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= length_help,
+	.parse		= length_parse,
+	.final_check	= length_check,
+	.print		= length_print,
+	.save		= length_save,
+	.extra_opts	= length_opts,
 };
 
 void _init(void)
 {
-	xtables_register_match(&length);
-	xtables_register_match(&length6);
+	xtables_register_match(&length_match);
+	xtables_register_match(&length_match6);
 }
Index: iptables/extensions/libxt_limit.c
===================================================================
--- iptables.orig/extensions/libxt_limit.c
+++ iptables/extensions/libxt_limit.c
@@ -18,8 +18,7 @@
 #define XT_LIMIT_BURST	5
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void limit_help(void)
 {
 	printf(
 "limit v%s options:\n"
@@ -30,7 +29,7 @@ help(void)
 "\n", IPTABLES_VERSION, XT_LIMIT_BURST);
 }
 
-static const struct option opts[] = {
+static const struct option limit_opts[] = {
 	{ "limit", 1, NULL, '%' },
 	{ "limit-burst", 1, NULL, '$' },
 	{ }
@@ -73,8 +72,7 @@ int parse_rate(const char *rate, u_int32
 }
 
 /* Initialize the match. */
-static void
-init(struct xt_entry_match *m)
+static void limit_init(struct xt_entry_match *m)
 {
 	struct xt_rateinfo *r = (struct xt_rateinfo *)m->data;
 
@@ -92,9 +90,8 @@ init(struct xt_entry_match *m)
 /* Function which parses command options; returns true if it
    ate an option */
 static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+limit_parse(int c, char **argv, int invert, unsigned int *flags,
+            const void *entry, struct xt_entry_match **match)
 {
 	struct xt_rateinfo *r = (struct xt_rateinfo *)(*match)->data;
 	unsigned int num;
@@ -150,9 +147,7 @@ static void print_rate(u_int32_t period)
 
 /* Prints out the matchinfo. */
 static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
+limit_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	struct xt_rateinfo *r = (struct xt_rateinfo *)match->data;
 	printf("limit: avg "); print_rate(r->avg);
@@ -160,7 +155,7 @@ print(const void *ip,
 }
 
 /* FIXME: Make minimalist: only print rate if not default --RR */
-static void save(const void *ip, const struct xt_entry_match *match)
+static void limit_save(const void *ip, const struct xt_entry_match *match)
 {
 	struct xt_rateinfo *r = (struct xt_rateinfo *)match->data;
 
@@ -169,36 +164,36 @@ static void save(const void *ip, const s
 		printf("--limit-burst %u ", r->burst);
 }
 
-static struct xtables_match limit = { 
+static struct xtables_match limit_match = {
 	.family		= AF_INET,
 	.name		= "limit",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_rateinfo)),
 	.userspacesize	= offsetof(struct xt_rateinfo, prev),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= limit_help,
+	.init		= limit_init,
+	.parse		= limit_parse,
+	.print		= limit_print,
+	.save		= limit_save,
+	.extra_opts	= limit_opts,
 };
 
-static struct xtables_match limit6 = { 
+static struct xtables_match limit_match6 = {
 	.family		= AF_INET6,
 	.name		= "limit",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_rateinfo)),
 	.userspacesize	= offsetof(struct xt_rateinfo, prev),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= limit_help,
+	.init		= limit_init,
+	.parse		= limit_parse,
+	.print		= limit_print,
+	.save		= limit_save,
+	.extra_opts	= limit_opts,
 };
 
 void _init(void)
 {
-	xtables_register_match(&limit);
-	xtables_register_match(&limit6);
+	xtables_register_match(&limit_match);
+	xtables_register_match(&limit_match6);
 }
Index: iptables/extensions/libxt_mac.c
===================================================================
--- iptables.orig/extensions/libxt_mac.c
+++ iptables/extensions/libxt_mac.c
@@ -13,8 +13,7 @@
 #include <linux/netfilter/xt_mac.h>
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void mac_help(void)
 {
 	printf(
 "MAC v%s options:\n"
@@ -23,7 +22,7 @@ help(void)
 "\n", IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option mac_opts[] = {
 	{ "mac-source", 1, NULL, '1' },
 	{ }
 };
@@ -55,9 +54,8 @@ parse_mac(const char *mac, struct xt_mac
 /* Function which parses command options; returns true if it
    ate an option */
 static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+mac_parse(int c, char **argv, int invert, unsigned int *flags,
+          const void *entry, struct xt_entry_match **match)
 {
 	struct xt_mac_info *macinfo = (struct xt_mac_info *)(*match)->data;
 
@@ -88,7 +86,7 @@ static void print_mac(unsigned char maca
 }
 
 /* Final check; must have specified --mac. */
-static void final_check(unsigned int flags)
+static void mac_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
@@ -97,9 +95,7 @@ static void final_check(unsigned int fla
 
 /* Prints out the matchinfo. */
 static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
+mac_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	printf("MAC ");
 
@@ -110,7 +106,7 @@ print(const void *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const void *ip, const struct xt_entry_match *match)
+static void mac_save(const void *ip, const struct xt_entry_match *match)
 {
 	if (((struct xt_mac_info *)match->data)->invert)
 		printf("! ");
@@ -119,36 +115,36 @@ static void save(const void *ip, const s
 	print_mac(((struct xt_mac_info *)match->data)->srcaddr);
 }
 
-static struct xtables_match mac = { 
+static struct xtables_match mac_match = {
 	.family		= AF_INET,
  	.name		= "mac",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_mac_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_mac_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= mac_help,
+	.parse		= mac_parse,
+	.final_check	= mac_check,
+	.print		= mac_print,
+	.save		= mac_save,
+	.extra_opts	= mac_opts,
 };
 
-static struct xtables_match mac6 = { 
+static struct xtables_match mac_match6 = {
 	.family		= AF_INET6,
  	.name		= "mac",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_mac_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_mac_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= mac_help,
+	.parse		= mac_parse,
+	.final_check	= mac_check,
+	.print		= mac_print,
+	.save		= mac_save,
+	.extra_opts	= mac_opts,
 };
 
 void _init(void)
 {
-	xtables_register_match(&mac);
-	xtables_register_match(&mac6);
+	xtables_register_match(&mac_match);
+	xtables_register_match(&mac_match6);
 }
Index: iptables/extensions/libxt_mark.c
===================================================================
--- iptables.orig/extensions/libxt_mark.c
+++ iptables/extensions/libxt_mark.c
@@ -10,8 +10,7 @@
 #include "../include/linux/netfilter/xt_mark.h"
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void mark_help(void)
 {
 	printf(
 "MARK match v%s options:\n"
@@ -20,7 +19,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option mark_opts[] = {
 	{ "mark", 1, NULL, '1' },
 	{ }
 };
@@ -28,9 +27,8 @@ static const struct option opts[] = {
 /* Function which parses command options; returns true if it
    ate an option */
 static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+mark_parse(int c, char **argv, int invert, unsigned int *flags,
+           const void *entry, struct xt_entry_match **match)
 {
 	struct xt_mark_info *markinfo = (struct xt_mark_info *)(*match)->data;
 
@@ -66,8 +64,7 @@ print_mark(unsigned long mark, unsigned 
 }
 
 /* Final check; must have specified --mark. */
-static void
-final_check(unsigned int flags)
+static void mark_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
@@ -76,9 +73,7 @@ final_check(unsigned int flags)
 
 /* Prints out the matchinfo. */
 static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
+mark_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	struct xt_mark_info *info = (struct xt_mark_info *)match->data;
 
@@ -92,7 +87,7 @@ print(const void *ip,
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
-save(const void *ip, const struct xt_entry_match *match)
+mark_save(const void *ip, const struct xt_entry_match *match)
 {
 	struct xt_mark_info *info = (struct xt_mark_info *)match->data;
 
@@ -103,36 +98,36 @@ save(const void *ip, const struct xt_ent
 	print_mark(info->mark, info->mask, 0);
 }
 
-static struct xtables_match mark = { 
+static struct xtables_match mark_match = {
 	.family		= AF_INET,
 	.name		= "mark",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_mark_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_mark_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= mark_help,
+	.parse		= mark_parse,
+	.final_check	= mark_check,
+	.print		= mark_print,
+	.save		= mark_save,
+	.extra_opts	= mark_opts,
 };
 
-static struct xtables_match mark6 = { 
+static struct xtables_match mark_match6 = {
 	.family		= AF_INET6,
 	.name		= "mark",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_mark_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_mark_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= mark_help,
+	.parse		= mark_parse,
+	.final_check	= mark_check,
+	.print		= mark_print,
+	.save		= mark_save,
+	.extra_opts	= mark_opts,
 };
 
 void _init(void)
 {
-	xtables_register_match(&mark);
-	xtables_register_match(&mark6);
+	xtables_register_match(&mark_match);
+	xtables_register_match(&mark_match6);
 }
Index: iptables/extensions/libxt_multiport.c
===================================================================
--- iptables.orig/extensions/libxt_multiport.c
+++ iptables/extensions/libxt_multiport.c
@@ -12,8 +12,7 @@
 #include "../include/linux/netfilter/xt_multiport.h"
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void multiport_help(void)
 {
 	printf(
 "multiport v%s options:\n"
@@ -29,8 +28,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static void
-help_v1(void)
+static void multiport_help_v1(void)
 {
 	printf(
 "multiport v%s options:\n"
@@ -45,7 +43,7 @@ help_v1(void)
 IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option multiport_opts[] = {
 	{ "source-ports", 1, NULL, '1' },
 	{ "sports", 1, NULL, '1' }, /* synonym */
 	{ "destination-ports", 1, NULL, '2' },
@@ -156,9 +154,9 @@ check_proto(u_int16_t pnum, u_int8_t inv
 /* Function which parses command options; returns true if it
    ate an option */
 static int
-__parse(int c, char **argv, int invert, unsigned int *flags,
-	struct xt_entry_match **match,
-	u_int16_t pnum, u_int8_t invflags)
+__multiport_parse(int c, char **argv, int invert, unsigned int *flags,
+                  struct xt_entry_match **match, u_int16_t pnum,
+                  u_int8_t invflags)
 {
 	const char *proto;
 	struct xt_multiport *multiinfo
@@ -205,29 +203,27 @@ __parse(int c, char **argv, int invert, 
 }
 
 static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-	 const void *e,
-	 struct xt_entry_match **match)
+multiport_parse(int c, char **argv, int invert, unsigned int *flags,
+                const void *e, struct xt_entry_match **match)
 {
 	const struct ipt_entry *entry = e;
-	return __parse(c, argv, invert, flags, match, entry->ip.proto,
-		       entry->ip.invflags);
+	return __multiport_parse(c, argv, invert, flags, match,
+	       entry->ip.proto, entry->ip.invflags);
 }
 
 static int
-parse6(int c, char **argv, int invert, unsigned int *flags,
-	 const void *e,
-	 struct xt_entry_match **match)
+multiport_parse6(int c, char **argv, int invert, unsigned int *flags,
+                 const void *e, struct xt_entry_match **match)
 {
 	const struct ip6t_entry *entry = (const struct ip6t_entry *)e;
-	return __parse(c, argv, invert, flags, match, entry->ipv6.proto,
-		       entry->ipv6.invflags);
+	return __multiport_parse(c, argv, invert, flags, match,
+	       entry->ipv6.proto, entry->ipv6.invflags);
 }
 
 static int
-__parse_v1(int c, char **argv, int invert, unsigned int *flags,
-	   struct xt_entry_match **match,
-	   u_int16_t pnum, u_int8_t invflags)
+__multiport_parse_v1(int c, char **argv, int invert, unsigned int *flags,
+                     struct xt_entry_match **match, u_int16_t pnum,
+                     u_int8_t invflags)
 {
 	const char *proto;
 	struct xt_multiport_v1 *multiinfo
@@ -270,28 +266,25 @@ __parse_v1(int c, char **argv, int inver
 }
 
 static int
-parse_v1(int c, char **argv, int invert, unsigned int *flags,
-	 const void *e,
-	 struct xt_entry_match **match)
+multiport_parse_v1(int c, char **argv, int invert, unsigned int *flags,
+                   const void *e, struct xt_entry_match **match)
 {
 	const struct ipt_entry *entry = e;
-	return __parse_v1(c, argv, invert, flags, match, entry->ip.proto,
-			  entry->ip.invflags);
+	return __multiport_parse_v1(c, argv, invert, flags, match,
+	       entry->ip.proto, entry->ip.invflags);
 }
 
 static int
-parse6_v1(int c, char **argv, int invert, unsigned int *flags,
-	  const void *e,
-	  struct xt_entry_match **match)
+multiport_parse6_v1(int c, char **argv, int invert, unsigned int *flags,
+                    const void *e, struct xt_entry_match **match)
 {
 	const struct ip6t_entry *entry = (const struct ip6t_entry *)e;
-	return __parse_v1(c, argv, invert, flags, match, entry->ipv6.proto,
-			  entry->ipv6.invflags);
+	return __multiport_parse_v1(c, argv, invert, flags, match,
+	       entry->ipv6.proto, entry->ipv6.invflags);
 }
 
 /* Final check; must specify something. */
-static void
-final_check(unsigned int flags)
+static void multiport_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM, "multiport expection an option");
@@ -321,7 +314,8 @@ print_port(u_int16_t port, u_int8_t prot
 
 /* Prints out the matchinfo. */
 static void
-__print(const struct xt_entry_match *match, int numeric, u_int16_t proto)
+__multiport_print(const struct xt_entry_match *match, int numeric,
+                  u_int16_t proto)
 {
 	const struct xt_multiport *multiinfo
 		= (const struct xt_multiport *)match->data;
@@ -354,22 +348,22 @@ __print(const struct xt_entry_match *mat
 	printf(" ");
 }
 
-static void
-print(const void *ip_void, const struct xt_entry_match *match, int numeric)
+static void multiport_print(const void *ip_void,
+                            const struct xt_entry_match *match, int numeric)
 {
 	const struct ipt_ip *ip = ip_void;
-	__print(match, numeric, ip->proto);
+	__multiport_print(match, numeric, ip->proto);
 }
 
-static void
-print6(const void *ip_void, const struct xt_entry_match *match, int numeric)
+static void multiport_print6(const void *ip_void,
+                             const struct xt_entry_match *match, int numeric)
 {
 	const struct ip6t_ip6 *ip = (const struct ip6t_ip6 *)ip_void;
-	__print(match, numeric, ip->proto);
+	__multiport_print(match, numeric, ip->proto);
 }
 
-static void
-__print_v1(const struct xt_entry_match *match, int numeric, u_int16_t proto)
+static void __multiport_print_v1(const struct xt_entry_match *match,
+                                 int numeric, u_int16_t proto)
 {
 	const struct xt_multiport_v1 *multiinfo
 		= (const struct xt_multiport_v1 *)match->data;
@@ -409,22 +403,23 @@ __print_v1(const struct xt_entry_match *
 	printf(" ");
 }
 
-static void
-print_v1(const void *ip_void, const struct xt_entry_match *match, int numeric)
+static void multiport_print_v1(const void *ip_void,
+                               const struct xt_entry_match *match, int numeric)
 {
 	const struct ipt_ip *ip = ip_void;
-	__print_v1(match, numeric, ip->proto);
+	__multiport_print_v1(match, numeric, ip->proto);
 }
 
-static void
-print6_v1(const void *ip_void, const struct xt_entry_match *match, int numeric)
+static void multiport_print6_v1(const void *ip_void,
+                                const struct xt_entry_match *match, int numeric)
 {
 	const struct ip6t_ip6 *ip = (const struct ip6t_ip6 *)ip_void;
-	__print_v1(match, numeric, ip->proto);
+	__multiport_print_v1(match, numeric, ip->proto);
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void __save(const struct xt_entry_match *match, u_int16_t proto)
+static void __multiport_save(const struct xt_entry_match *match,
+                             u_int16_t proto)
 {
 	const struct xt_multiport *multiinfo
 		= (const struct xt_multiport *)match->data;
@@ -451,19 +446,22 @@ static void __save(const struct xt_entry
 	printf(" ");
 }
 
-static void save(const void *ip_void, const struct xt_entry_match *match)
+static void multiport_save(const void *ip_void,
+                           const struct xt_entry_match *match)
 {
 	const struct ipt_ip *ip = ip_void;
-	__save(match, ip->proto);
+	__multiport_save(match, ip->proto);
 }
 
-static void save6(const void *ip_void, const struct xt_entry_match *match)
+static void multiport_save6(const void *ip_void,
+                            const struct xt_entry_match *match)
 {
 	const struct ip6t_ip6 *ip = (const struct ip6t_ip6 *)ip_void;
-	__save(match, ip->proto);
+	__multiport_save(match, ip->proto);
 }
 
-static void __save_v1(const struct xt_entry_match *match, u_int16_t proto)
+static void __multiport_save_v1(const struct xt_entry_match *match,
+                                u_int16_t proto)
 {
 	const struct xt_multiport_v1 *multiinfo
 		= (const struct xt_multiport_v1 *)match->data;
@@ -497,83 +495,85 @@ static void __save_v1(const struct xt_en
 	printf(" ");
 }
 
-static void save_v1(const void *ip_void, const struct xt_entry_match *match)
+static void multiport_save_v1(const void *ip_void,
+                              const struct xt_entry_match *match)
 {
 	const struct ipt_ip *ip = ip_void;
-	__save_v1(match, ip->proto);
+	__multiport_save_v1(match, ip->proto);
 }
 
-static void save6_v1(const void *ip_void, const struct xt_entry_match *match)
+static void multiport_save6_v1(const void *ip_void,
+                               const struct xt_entry_match *match)
 {
 	const struct ip6t_ip6 *ip = (const struct ip6t_ip6 *)ip_void;
-	__save_v1(match, ip->proto);
+	__multiport_save_v1(match, ip->proto);
 }
 
-static struct xtables_match multiport = { 
+static struct xtables_match multiport_match = {
 	.family		= AF_INET,
 	.name		= "multiport",
 	.revision	= 0,
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_multiport)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_multiport)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= multiport_help,
+	.parse		= multiport_parse,
+	.final_check	= multiport_check,
+	.print		= multiport_print,
+	.save		= multiport_save,
+	.extra_opts	= multiport_opts,
 };
 
-static struct xtables_match multiport6 = { 
+static struct xtables_match multiport_match6 = {
 	.family		= AF_INET6,
 	.name		= "multiport",
 	.revision	= 0,
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_multiport)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_multiport)),
-	.help		= &help,
-	.parse		= &parse6,
-	.final_check	= &final_check,
-	.print		= &print6,
-	.save		= &save6,
-	.extra_opts	= opts
+	.help		= multiport_help,
+	.parse		= multiport_parse6,
+	.final_check	= multiport_check,
+	.print		= multiport_print6,
+	.save		= multiport_save6,
+	.extra_opts	= multiport_opts,
 };
 
-static struct xtables_match multiport_v1 = { 
+static struct xtables_match multiport_match_v1 = {
 	.family		= AF_INET,
 	.name		= "multiport",
 	.version	= IPTABLES_VERSION,
 	.revision	= 1,
 	.size		= XT_ALIGN(sizeof(struct xt_multiport_v1)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_multiport_v1)),
-	.help		= &help_v1,
-	.parse		= &parse_v1,
-	.final_check	= &final_check,
-	.print		= &print_v1,
-	.save		= &save_v1,
-	.extra_opts	= opts
+	.help		= multiport_help_v1,
+	.parse		= multiport_parse_v1,
+	.final_check	= multiport_check,
+	.print		= multiport_print_v1,
+	.save		= multiport_save_v1,
+	.extra_opts	= multiport_opts,
 };
 
-static struct xtables_match multiport6_v1 = { 
+static struct xtables_match multiport_match6_v1 = {
 	.family		= AF_INET6,
 	.name		= "multiport",
 	.version	= IPTABLES_VERSION,
 	.revision	= 1,
 	.size		= XT_ALIGN(sizeof(struct xt_multiport_v1)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_multiport_v1)),
-	.help		= &help_v1,
-	.parse		= &parse6_v1,
-	.final_check	= &final_check,
-	.print		= &print6_v1,
-	.save		= &save6_v1,
-	.extra_opts	= opts
+	.help		= multiport_help_v1,
+	.parse		= multiport_parse6_v1,
+	.final_check	= multiport_check,
+	.print		= multiport_print6_v1,
+	.save		= multiport_save6_v1,
+	.extra_opts	= multiport_opts,
 };
 
 void
 _init(void)
 {
-	xtables_register_match(&multiport);
-	xtables_register_match(&multiport6);
-	xtables_register_match(&multiport_v1);
-	xtables_register_match(&multiport6_v1);
+	xtables_register_match(&multiport_match);
+	xtables_register_match(&multiport_match6);
+	xtables_register_match(&multiport_match_v1);
+	xtables_register_match(&multiport_match6_v1);
 }
Index: iptables/extensions/libxt_physdev.c
===================================================================
--- iptables.orig/extensions/libxt_physdev.c
+++ iptables/extensions/libxt_physdev.c
@@ -12,8 +12,7 @@
 #include <linux/if_ether.h>
 #endif
 
-static void
-help(void)
+static void physdev_help(void)
 {
 	printf(
 "physdev v%s options:\n"
@@ -25,7 +24,7 @@ help(void)
 "\n", IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option physdev_opts[] = {
 	{ "physdev-in", 1, NULL, '1' },
 	{ "physdev-out", 1, NULL, '2' },
 	{ "physdev-is-in", 0, NULL, '3' },
@@ -35,9 +34,8 @@ static const struct option opts[] = {
 };
 
 static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+physdev_parse(int c, char **argv, int invert, unsigned int *flags,
+              const void *entry, struct xt_entry_match **match)
 {
 	struct xt_physdev_info *info =
 		(struct xt_physdev_info*)(*match)->data;
@@ -108,16 +106,14 @@ multiple_use:
 
 }
 
-static void final_check(unsigned int flags)
+static void physdev_check(unsigned int flags)
 {
 	if (flags == 0)
 		exit_error(PARAMETER_PROBLEM, "PHYSDEV: no physdev option specified");
 }
 
 static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
+physdev_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	struct xt_physdev_info *info =
 		(struct xt_physdev_info*)match->data;
@@ -142,7 +138,7 @@ print(const void *ip,
 	printf(" ");
 }
 
-static void save(const void *ip, const struct xt_entry_match *match)
+static void physdev_save(const void *ip, const struct xt_entry_match *match)
 {
 	struct xt_physdev_info *info =
 		(struct xt_physdev_info*)match->data;
@@ -166,36 +162,36 @@ static void save(const void *ip, const s
 	printf(" ");
 }
 
-static struct xtables_match physdev = { 
+static struct xtables_match physdev_match = {
 	.family		= AF_INET,
 	.name		= "physdev",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_physdev_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_physdev_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= physdev_help,
+	.parse		= physdev_parse,
+	.final_check	= physdev_check,
+	.print		= physdev_print,
+	.save		= physdev_save,
+	.extra_opts	= physdev_opts,
 };
 
-static struct xtables_match physdev6 = { 
+static struct xtables_match physdev_match6 = {
 	.family		= AF_INET6,
 	.name		= "physdev",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_physdev_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_physdev_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= physdev_help,
+	.parse		= physdev_parse,
+	.final_check	= physdev_check,
+	.print		= physdev_print,
+	.save		= physdev_save,
+	.extra_opts	= physdev_opts,
 };
 
 void _init(void)
 {
-	xtables_register_match(&physdev);
-	xtables_register_match(&physdev6);
+	xtables_register_match(&physdev_match);
+	xtables_register_match(&physdev_match6);
 }
Index: iptables/extensions/libxt_pkttype.c
===================================================================
--- iptables.orig/extensions/libxt_pkttype.c
+++ iptables/extensions/libxt_pkttype.c
@@ -55,16 +55,16 @@ static void print_types(void)
 }
 
 /* Function which prints out usage message. */
-static void help(void)
+static void pkttype_help(void)
 {
 	printf(
-"pkt_type v%s options:\n"
+"pkttype v%s options:\n"
 "  --pkt-type [!] packettype\tmatch packet type\n"
 "\n", PKTTYPE_VERSION);
 	print_types();
 }
 
-static const struct option opts[] = {
+static const struct option pkttype_opts[] = {
 	{"pkt-type", 1, NULL, '1'},
 	{ }
 };
@@ -85,9 +85,8 @@ static void parse_pkttype(const char *pk
 	exit_error(PARAMETER_PROBLEM, "Bad packet type '%s'", pkttype);
 }
 
-static int parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+static int pkttype_parse(int c, char **argv, int invert, unsigned int *flags,
+                         const void *entry, struct xt_entry_match **match)
 {
 	struct xt_pkttype_info *info = (struct xt_pkttype_info *)(*match)->data;
 	
@@ -108,7 +107,7 @@ static int parse(int c, char **argv, int
 	return 1;
 }
 
-static void final_check(unsigned int flags)
+static void pkttype_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM, "You must specify `--pkt-type'");
@@ -130,7 +129,8 @@ static void print_pkttype(struct xt_pktt
 	printf("%d ", info->pkttype);	/* in case we didn't find an entry in named-packtes */
 }
 
-static void print(const void *ip, const struct xt_entry_match *match, int numeric)
+static void pkttype_print(const void *ip, const struct xt_entry_match *match,
+                          int numeric)
 {
 	struct xt_pkttype_info *info = (struct xt_pkttype_info *)match->data;
 	
@@ -138,7 +138,7 @@ static void print(const void *ip, const 
 	print_pkttype(info);
 }
 
-static void save(const void *ip, const struct xt_entry_match *match)
+static void pkttype_save(const void *ip, const struct xt_entry_match *match)
 {
 	struct xt_pkttype_info *info = (struct xt_pkttype_info *)match->data;
 	
@@ -146,36 +146,36 @@ static void save(const void *ip, const s
 	print_pkttype(info);
 }
 
-static struct xtables_match pkttype = {
+static struct xtables_match pkttype_match = {
 	.family		= AF_INET,
 	.name		= "pkttype",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_pkttype_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_pkttype_info)),
-	.help		= &help,
-	.parse		= &parse, 
-	.final_check	= &final_check, 
-	.print		= &print,
-	.save		= &save, 
-	.extra_opts	= opts
+	.help		= pkttype_help,
+	.parse		= pkttype_parse,
+	.final_check	= pkttype_check,
+	.print		= pkttype_print,
+	.save		= pkttype_save,
+	.extra_opts	= pkttype_opts,
 };
 
-static struct xtables_match pkttype6 = {
+static struct xtables_match pkttype_match6 = {
 	.family		= AF_INET6,
 	.name		= "pkttype",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_pkttype_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_pkttype_info)),
-	.help		= &help,
-	.parse		= &parse, 
-	.final_check	= &final_check, 
-	.print		= &print,
-	.save		= &save, 
-	.extra_opts	= opts
+	.help		= pkttype_help,
+	.parse		= pkttype_parse,
+	.final_check	= pkttype_check,
+	.print		= pkttype_print,
+	.save		= pkttype_save,
+	.extra_opts	= pkttype_opts,
 };
 
 void _init(void)
 {
-	xtables_register_match(&pkttype);
-	xtables_register_match(&pkttype6);
+	xtables_register_match(&pkttype_match);
+	xtables_register_match(&pkttype_match6);
 }
Index: iptables/extensions/libxt_quota.c
===================================================================
--- iptables.orig/extensions/libxt_quota.c
+++ iptables/extensions/libxt_quota.c
@@ -11,14 +11,13 @@
 
 #include <linux/netfilter/xt_quota.h>
 
-static const struct option opts[] = {
+static const struct option quota_opts[] = {
         {"quota", 1, NULL, '1'},
         { }
 };
 
 /* print usage */
-static void
-help(void)
+static void quota_help(void)
 {
         printf("quota options:\n"
                " --quota quota			quota (bytes)\n" "\n");
@@ -26,7 +25,7 @@ help(void)
 
 /* print matchinfo */
 static void
-print(const void *ip, const struct xt_entry_match *match, int numeric)
+quota_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
         struct xt_quota_info *q = (struct xt_quota_info *) match->data;
         printf("quota: %llu bytes", (unsigned long long) q->quota);
@@ -34,7 +33,7 @@ print(const void *ip, const struct xt_en
 
 /* save matchinfo */
 static void
-save(const void *ip, const struct xt_entry_match *match)
+quota_save(const void *ip, const struct xt_entry_match *match)
 {
         struct xt_quota_info *q = (struct xt_quota_info *) match->data;
         printf("--quota %llu ", (unsigned long long) q->quota);
@@ -58,9 +57,8 @@ parse_quota(const char *s, u_int64_t * q
 
 /* parse all options, returning true if we found any for us */
 static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+quota_parse(int c, char **argv, int invert, unsigned int *flags,
+            const void *entry, struct xt_entry_match **match)
 {
         struct xt_quota_info *info = (struct xt_quota_info *) (*match)->data;
 
@@ -79,35 +77,35 @@ parse(int c, char **argv, int invert, un
         return 1;
 }
 
-struct xtables_match quota = { 
+struct xtables_match quota_match = {
 	.family		= AF_INET,
 	.name		= "quota",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof (struct xt_quota_info)),
 	.userspacesize	= offsetof(struct xt_quota_info, quota),
-	.help		= &help,
-	.parse		= &parse,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= quota_help,
+	.parse		= quota_parse,
+	.print		= quota_print,
+	.save		= quota_save,
+	.extra_opts	= quota_opts,
 };
 
-struct xtables_match quota6 = { 
+struct xtables_match quota_match6 = {
 	.family		= AF_INET6,
 	.name		= "quota",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof (struct xt_quota_info)),
 	.userspacesize	= offsetof(struct xt_quota_info, quota),
-	.help		= &help,
-	.parse		= &parse,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= quota_help,
+	.parse		= quota_parse,
+	.print		= quota_print,
+	.save		= quota_save,
+	.extra_opts	= quota_opts,
 };
 
 void
 _init(void)
 {
-	xtables_register_match(&quota);
-	xtables_register_match(&quota6);
+	xtables_register_match(&quota_match);
+	xtables_register_match(&quota_match6);
 }
Index: iptables/extensions/libxt_sctp.c
===================================================================
--- iptables.orig/extensions/libxt_sctp.c
+++ iptables/extensions/libxt_sctp.c
@@ -41,8 +41,7 @@ static void
 print_chunk(u_int32_t chunknum, int numeric);
 
 /* Initialize the match. */
-static void
-init(struct xt_entry_match *m)
+static void sctp_init(struct xt_entry_match *m)
 {
 	int i;
 	struct xt_sctp_info *einfo = (struct xt_sctp_info *)m->data;
@@ -54,7 +53,7 @@ init(struct xt_entry_match *m)
 	}
 }
 
-static void help(void)
+static void sctp_help(void)
 {
 	printf(
 "SCTP match v%s options\n"
@@ -68,7 +67,7 @@ static void help(void)
 	IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option sctp_opts[] = {
 	{ .name = "source-port", .has_arg = 1, .val = '1' },
 	{ .name = "sport", .has_arg = 1, .val = '1' },
 	{ .name = "destination-port", .has_arg = 1, .val = '2' },
@@ -260,9 +259,8 @@ parse_sctp_chunks(struct xt_sctp_info *e
 }
 
 static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+sctp_parse(int c, char **argv, int invert, unsigned int *flags,
+           const void *entry, struct xt_entry_match **match)
 {
 	struct xt_sctp_info *einfo
 		= (struct xt_sctp_info *)(*match)->data;
@@ -450,9 +448,7 @@ out:
 
 /* Prints out the matchinfo. */
 static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
+sctp_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	const struct xt_sctp_info *einfo =
 		(const struct xt_sctp_info *)match->data;
@@ -483,9 +479,7 @@ print(const void *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void
-save(const void *ip,
-     const struct xt_entry_match *match)
+static void sctp_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_sctp_info *einfo =
 		(const struct xt_sctp_info *)match->data;
@@ -520,37 +514,37 @@ save(const void *ip,
 	}
 }
 
-static struct xtables_match sctp = {
+static struct xtables_match sctp_match = {
 	.name		= "sctp",
 	.family		= AF_INET,
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_sctp_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_sctp_info)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= sctp_help,
+	.init		= sctp_init,
+	.parse		= sctp_parse,
+	.print		= sctp_print,
+	.save		= sctp_save,
+	.extra_opts	= sctp_opts,
 };
 
-static struct xtables_match sctp6 = {
+static struct xtables_match sctp_match6 = {
 	.name		= "sctp",
 	.family		= AF_INET6,
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_sctp_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_sctp_info)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= sctp_help,
+	.init		= sctp_init,
+	.parse		= sctp_parse,
+	.print		= sctp_print,
+	.save		= sctp_save,
+	.extra_opts	= sctp_opts,
 };
 
 void _init(void)
 {
-	xtables_register_match(&sctp);
-	xtables_register_match(&sctp6);
+	xtables_register_match(&sctp_match);
+	xtables_register_match(&sctp_match6);
 }
 
Index: iptables/extensions/libxt_standard.c
===================================================================
--- iptables.orig/extensions/libxt_standard.c
+++ iptables/extensions/libxt_standard.c
@@ -8,8 +8,7 @@
 #include <xtables.h>
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void standard_help(void)
 {
 	printf(
 "Standard v%s options:\n"
@@ -18,38 +17,34 @@ help(void)
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_target **target)
+static int standard_parse(int c, char **argv, int invert, unsigned int *flags,
+                          const void *entry, struct xt_entry_target **target)
 {
 	return 0;
 }
 
-static
-struct xtables_target standard = { 
+static struct xtables_target standard_target = {
 	.family		= AF_INET,
 	.name		= "standard",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(int)),
 	.userspacesize	= XT_ALIGN(sizeof(int)),
-	.help		= &help,
-	.parse		= &parse,
+	.help		= standard_help,
+	.parse		= standard_parse,
 };
 
-static
-struct xtables_target standard6 = { 
+static struct xtables_target standard_target6 = {
 	.family		= AF_INET6,
 	.name		= "standard",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(int)),
 	.userspacesize	= XT_ALIGN(sizeof(int)),
-	.help		= &help,
-	.parse		= &parse,
+	.help		= standard_help,
+	.parse		= standard_parse,
 };
 
 void _init(void)
 {
-	xtables_register_target(&standard);
-	xtables_register_target(&standard6);
+	xtables_register_target(&standard_target);
+	xtables_register_target(&standard_target6);
 }
Index: iptables/extensions/libxt_statistic.c
===================================================================
--- iptables.orig/extensions/libxt_statistic.c
+++ iptables/extensions/libxt_statistic.c
@@ -8,8 +8,7 @@
 #include <xtables.h>
 #include <linux/netfilter/xt_statistic.h>
 
-static void
-help(void)
+static void statistic_help(void)
 {
 	printf(
 "statistic match v%s options:\n"
@@ -23,7 +22,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option statistic_opts[] = {
 	{ "mode", 1, NULL, '1' },
 	{ "probability", 1, NULL, '2' },
 	{ "every", 1, NULL, '3' },
@@ -34,9 +33,8 @@ static const struct option opts[] = {
 static struct xt_statistic_info *info;
 
 static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+statistic_parse(int c, char **argv, int invert, unsigned int *flags,
+                const void *entry, struct xt_entry_match **match)
 {
 	double prob;
 
@@ -95,8 +93,7 @@ parse(int c, char **argv, int invert, un
 }
 
 /* Final check; must have specified --mark. */
-static void
-final_check(unsigned int flags)
+static void statistic_check(unsigned int flags)
 {
 	if (!(flags & 0x1))
 		exit_error(PARAMETER_PROBLEM, "no mode specified");
@@ -145,9 +142,7 @@ static void print_match(const struct xt_
 }
 
 static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
+statistic_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	struct xt_statistic_info *info = (struct xt_statistic_info *)match->data;
 
@@ -156,44 +151,43 @@ print(const void *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_match *match)
+static void statistic_save(const void *ip, const struct xt_entry_match *match)
 {
 	struct xt_statistic_info *info = (struct xt_statistic_info *)match->data;
 
 	print_match(info, "--");
 }
 
-static struct xtables_match statistic = { 
+static struct xtables_match statistic_match = {
 	.family		= AF_INET,
 	.name		= "statistic",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_statistic_info)),
 	.userspacesize	= offsetof(struct xt_statistic_info, u.nth.count),
-	.help		= help,
-	.parse		= parse,
-	.final_check	= final_check,
-	.print		= print,
-	.save		= save,
-	.extra_opts	= opts
+	.help		= statistic_help,
+	.parse		= statistic_parse,
+	.final_check	= statistic_check,
+	.print		= statistic_print,
+	.save		= statistic_save,
+	.extra_opts	= statistic_opts,
 };
 
-static struct xtables_match statistic6 = { 
+static struct xtables_match statistic_match6 = {
 	.family		= AF_INET6,
 	.name		= "statistic",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_statistic_info)),
 	.userspacesize	= offsetof(struct xt_statistic_info, u.nth.count),
-	.help		= help,
-	.parse		= parse,
-	.final_check	= final_check,
-	.print		= print,
-	.save		= save,
-	.extra_opts	= opts
+	.help		= statistic_help,
+	.parse		= statistic_parse,
+	.final_check	= statistic_check,
+	.print		= statistic_print,
+	.save		= statistic_save,
+	.extra_opts	= statistic_opts,
 };
 
 void _init(void)
 {
-	xtables_register_match(&statistic);
-	xtables_register_match(&statistic6);
+	xtables_register_match(&statistic_match);
+	xtables_register_match(&statistic_match6);
 }
Index: iptables/extensions/libxt_string.c
===================================================================
--- iptables.orig/extensions/libxt_string.c
+++ iptables/extensions/libxt_string.c
@@ -31,8 +31,7 @@
 #include <linux/netfilter/xt_string.h>
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void string_help(void)
 {
 	printf(
 "STRING match v%s options:\n"
@@ -44,7 +43,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option string_opts[] = {
 	{ "from", 1, NULL, '1' },
 	{ "to", 1, NULL, '2' },
 	{ "algo", 1, NULL, '3' },
@@ -53,8 +52,7 @@ static const struct option opts[] = {
 	{ }
 };
 
-static void
-init(struct xt_entry_match *m)
+static void string_init(struct xt_entry_match *m)
 {
 	struct xt_string_info *i = (struct xt_string_info *) m->data;
 
@@ -169,9 +167,8 @@ parse_hex_string(const char *s, struct x
 /* Function which parses command options; returns true if it
    ate an option */
 static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+string_parse(int c, char **argv, int invert, unsigned int *flags,
+             const void *entry, struct xt_entry_match **match)
 {
 	struct xt_string_info *stringinfo = (struct xt_string_info *)(*match)->data;
 
@@ -229,8 +226,7 @@ parse(int c, char **argv, int invert, un
 
 
 /* Final check; must have specified --string. */
-static void
-final_check(unsigned int flags)
+static void string_check(unsigned int flags)
 {
 	if (!(flags & STRING))
 		exit_error(PARAMETER_PROBLEM,
@@ -288,9 +284,7 @@ print_string(const char *str, const unsi
 
 /* Prints out the matchinfo. */
 static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
+string_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	const struct xt_string_info *info =
 	    (const struct xt_string_info*) match->data;
@@ -311,8 +305,7 @@ print(const void *ip,
 
 
 /* Saves the union ipt_matchinfo in parseable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_match *match)
+static void string_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_string_info *info =
 	    (const struct xt_string_info*) match->data;
@@ -332,39 +325,39 @@ save(const void *ip, const struct xt_ent
 }
 
 
-static struct xtables_match string = {
+static struct xtables_match string_match = {
     .name		= "string",
-    .family			= AF_INET,
+    .family		= AF_INET,
     .version		= IPTABLES_VERSION,
     .size		= XT_ALIGN(sizeof(struct xt_string_info)),
     .userspacesize	= offsetof(struct xt_string_info, config),
-    .help		= help,
-    .init		= init,
-    .parse		= parse,
-    .final_check	= final_check,
-    .print		= print,
-    .save		= save,
-    .extra_opts		= opts
+    .help		= string_help,
+    .init		= string_init,
+    .parse		= string_parse,
+    .final_check	= string_check,
+    .print		= string_print,
+    .save		= string_save,
+    .extra_opts		= string_opts,
 };
 
 
-static struct xtables_match string6 = {
+static struct xtables_match string_match6 = {
     .name		= "string",
-    .family			= AF_INET6,
+    .family		= AF_INET6,
     .version		= IPTABLES_VERSION,
     .size		= XT_ALIGN(sizeof(struct xt_string_info)),
     .userspacesize	= offsetof(struct xt_string_info, config),
-    .help		= help,
-    .init		= init,
-    .parse		= parse,
-    .final_check	= final_check,
-    .print		= print,
-    .save		= save,
-    .extra_opts		= opts
+    .help		= string_help,
+    .init		= string_init,
+    .parse		= string_parse,
+    .final_check	= string_check,
+    .print		= string_print,
+    .save		= string_save,
+    .extra_opts		= string_opts,
 };
 
 void _init(void)
 {
-	xtables_register_match(&string);
-	xtables_register_match(&string6);
+	xtables_register_match(&string_match);
+	xtables_register_match(&string_match6);
 }
Index: iptables/extensions/libxt_tcp.c
===================================================================
--- iptables.orig/extensions/libxt_tcp.c
+++ iptables/extensions/libxt_tcp.c
@@ -8,8 +8,7 @@
 #include <linux/netfilter/xt_tcpudp.h>
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void tcp_help(void)
 {
 	printf(
 "TCP v%s options:\n"
@@ -27,7 +26,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option tcp_opts[] = {
 	{ "source-port", 1, NULL, '1' },
 	{ "sport", 1, NULL, '1' }, /* synonym */
 	{ "destination-port", 1, NULL, '2' },
@@ -130,8 +129,7 @@ parse_tcp_option(const char *option, u_i
 }
 
 /* Initialize the match. */
-static void
-init(struct xt_entry_match *m)
+static void tcp_init(struct xt_entry_match *m)
 {
 	struct xt_tcp *tcpinfo = (struct xt_tcp *)m->data;
 
@@ -146,9 +144,8 @@ init(struct xt_entry_match *m)
 /* Function which parses command options; returns true if it
    ate an option. */
 static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+tcp_parse(int c, char **argv, int invert, unsigned int *flags,
+          const void *entry, struct xt_entry_match **match)
 {
 	struct xt_tcp *tcpinfo = (struct xt_tcp *)(*match)->data;
 
@@ -310,8 +307,7 @@ print_flags(u_int8_t mask, u_int8_t cmp,
 
 /* Prints out the union ipt_matchinfo. */
 static void
-print(const void *ip,
-      const struct xt_entry_match *match, int numeric)
+tcp_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	const struct xt_tcp *tcp = (struct xt_tcp *)match->data;
 
@@ -334,7 +330,7 @@ print(const void *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const void *ip, const struct xt_entry_match *match)
+static void tcp_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_tcp *tcpinfo = (struct xt_tcp *)match->data;
 
@@ -387,37 +383,37 @@ static void save(const void *ip, const s
 	}
 }
 
-static struct xtables_match tcp = { 
+static struct xtables_match tcp_match = {
 	.family		= AF_INET,
 	.name		= "tcp",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_tcp)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_tcp)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts,
+	.help		= tcp_help,
+	.init		= tcp_init,
+	.parse		= tcp_parse,
+	.print		= tcp_print,
+	.save		= tcp_save,
+	.extra_opts	= tcp_opts,
 };
 
-static struct xtables_match tcp6 = { 
+static struct xtables_match tcp_match6 = {
 	.family		= AF_INET6,
 	.name		= "tcp",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_tcp)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_tcp)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts,
+	.help		= tcp_help,
+	.init		= tcp_init,
+	.parse		= tcp_parse,
+	.print		= tcp_print,
+	.save		= tcp_save,
+	.extra_opts	= tcp_opts,
 };
 
 void
 _init(void)
 {
-	xtables_register_match(&tcp);
-	xtables_register_match(&tcp6);
+	xtables_register_match(&tcp_match);
+	xtables_register_match(&tcp_match6);
 }
Index: iptables/extensions/libxt_tcpmss.c
===================================================================
--- iptables.orig/extensions/libxt_tcpmss.c
+++ iptables/extensions/libxt_tcpmss.c
@@ -9,8 +9,7 @@
 #include <linux/netfilter/xt_tcpmss.h>
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void tcpmss_help(void)
 {
 	printf(
 "tcpmss match v%s options:\n"
@@ -19,7 +18,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option tcpmss_opts[] = {
 	{ "mss", 1, NULL, '1' },
 	{ }
 };
@@ -59,9 +58,8 @@ parse_tcp_mssvalues(const char *mssvalue
 /* Function which parses command options; returns true if it
    ate an option */
 static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+tcpmss_parse(int c, char **argv, int invert, unsigned int *flags,
+             const void *entry, struct xt_entry_match **match)
 {
 	struct xt_tcpmss_match_info *mssinfo =
 		(struct xt_tcpmss_match_info *)(*match)->data;
@@ -97,8 +95,7 @@ print_tcpmss(u_int16_t mss_min, u_int16_
 }
 
 /* Final check; must have specified --mss. */
-static void
-final_check(unsigned int flags)
+static void tcpmss_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
@@ -107,9 +104,7 @@ final_check(unsigned int flags)
 
 /* Prints out the matchinfo. */
 static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
+tcpmss_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	const struct xt_tcpmss_match_info *mssinfo =
 		(const struct xt_tcpmss_match_info *)match->data;
@@ -120,8 +115,7 @@ print(const void *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_match *match)
+static void tcpmss_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_tcpmss_match_info *mssinfo =
 		(const struct xt_tcpmss_match_info *)match->data;
@@ -131,36 +125,36 @@ save(const void *ip, const struct xt_ent
 		     mssinfo->invert, 0);
 }
 
-static struct xtables_match tcpmss = {
+static struct xtables_match tcpmss_match = {
 	.family		= AF_INET,
 	.name		= "tcpmss",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_tcpmss_match_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_tcpmss_match_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= tcpmss_help,
+	.parse		= tcpmss_parse,
+	.final_check	= tcpmss_check,
+	.print		= tcpmss_print,
+	.save		= tcpmss_save,
+	.extra_opts	= tcpmss_opts,
 };
 
-static struct xtables_match tcpmss6 = {
+static struct xtables_match tcpmss_match6 = {
 	.family		= AF_INET6,
 	.name		= "tcpmss",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_tcpmss_match_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_tcpmss_match_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= tcpmss_help,
+	.parse		= tcpmss_parse,
+	.final_check	= tcpmss_check,
+	.print		= tcpmss_print,
+	.save		= tcpmss_save,
+	.extra_opts	= tcpmss_opts,
 };
 
 void _init(void)
 {
-	xtables_register_match(&tcpmss);
-	xtables_register_match(&tcpmss6);
+	xtables_register_match(&tcpmss_match);
+	xtables_register_match(&tcpmss_match6);
 }
Index: iptables/extensions/libxt_time.c
===================================================================
--- iptables.orig/extensions/libxt_time.c
+++ iptables/extensions/libxt_time.c
@@ -463,7 +463,7 @@ static void time_save(const void *ip, co
 		printf("--utc ");
 }
 
-static struct xtables_match time_reg = {
+static struct xtables_match time_match = {
 	.name          = "time",
 	.family        = AF_INET,
 	.version       = IPTABLES_VERSION,
@@ -477,7 +477,7 @@ static struct xtables_match time_reg = {
 	.extra_opts    = time_opts,
 };
 
-static struct xtables_match time6_reg = {
+static struct xtables_match time_match6 = {
 	.name          = "time",
 	.family        = AF_INET6,
 	.version       = IPTABLES_VERSION,
@@ -493,6 +493,6 @@ static struct xtables_match time6_reg = 
 
 void _init(void)
 {
-	xtables_register_match(&time_reg);
-	xtables_register_match(&time6_reg);
+	xtables_register_match(&time_match);
+	xtables_register_match(&time_match6);
 }
Index: iptables/extensions/libxt_u32.c
===================================================================
--- iptables.orig/extensions/libxt_u32.c
+++ iptables/extensions/libxt_u32.c
@@ -268,7 +268,7 @@ static void u32_save(const void *ip, con
 	return;
 }
 
-static struct xtables_match u32_reg = {
+static struct xtables_match u32_match = {
 	.name          = "u32",
 	.family        = AF_INET,
 	.version       = IPTABLES_VERSION,
@@ -281,7 +281,7 @@ static struct xtables_match u32_reg = {
 	.extra_opts    = u32_opts,
 };
 
-static struct xtables_match u32_reg6 = {
+static struct xtables_match u32_match6 = {
 	.name          = "u32",
 	.family        = AF_INET6,
 	.version       = IPTABLES_VERSION,
@@ -296,7 +296,7 @@ static struct xtables_match u32_reg6 = {
 
 void _init(void)
 {
-	xtables_register_match(&u32_reg);
-	xtables_register_match(&u32_reg6);
+	xtables_register_match(&u32_match);
+	xtables_register_match(&u32_match6);
 	return;
 }
Index: iptables/extensions/libxt_udp.c
===================================================================
--- iptables.orig/extensions/libxt_udp.c
+++ iptables/extensions/libxt_udp.c
@@ -8,8 +8,7 @@
 #include <linux/netfilter/xt_tcpudp.h>
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void udp_help(void)
 {
 	printf(
 "UDP v%s options:\n"
@@ -22,7 +21,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option udp_opts[] = {
 	{ "source-port", 1, NULL, '1' },
 	{ "sport", 1, NULL, '1' }, /* synonym */
 	{ "destination-port", 1, NULL, '2' },
@@ -54,8 +53,7 @@ parse_udp_ports(const char *portstring, 
 }
 
 /* Initialize the match. */
-static void
-init(struct xt_entry_match *m)
+static void udp_init(struct xt_entry_match *m)
 {
 	struct xt_udp *udpinfo = (struct xt_udp *)m->data;
 
@@ -68,9 +66,8 @@ init(struct xt_entry_match *m)
 /* Function which parses command options; returns true if it
    ate an option */
 static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+udp_parse(int c, char **argv, int invert, unsigned int *flags,
+          const void *entry, struct xt_entry_match **match)
 {
 	struct xt_udp *udpinfo = (struct xt_udp *)(*match)->data;
 
@@ -149,8 +146,7 @@ print_ports(const char *name, u_int16_t 
 
 /* Prints out the union ipt_matchinfo. */
 static void
-print(const void *ip,
-      const struct xt_entry_match *match, int numeric)
+udp_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	const struct xt_udp *udp = (struct xt_udp *)match->data;
 
@@ -167,7 +163,7 @@ print(const void *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const void *ip, const struct xt_entry_match *match)
+static void udp_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_udp *udpinfo = (struct xt_udp *)match->data;
 
@@ -200,39 +196,37 @@ static void save(const void *ip, const s
 	}
 }
 
-static
-struct xtables_match udp = { 
+static struct xtables_match udp_match = {
 	.family		= AF_INET,
 	.name		= "udp",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_udp)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_udp)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= udp_help,
+	.init		= udp_init,
+	.parse		= udp_parse,
+	.print		= udp_print,
+	.save		= udp_save,
+	.extra_opts	= udp_opts,
 };
 
-static
-struct xtables_match udp6 = { 
+static struct xtables_match udp_match6 = {
 	.family		= AF_INET6,
 	.name		= "udp",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_udp)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_udp)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= udp_help,
+	.init		= udp_init,
+	.parse		= udp_parse,
+	.print		= udp_print,
+	.save		= udp_save,
+	.extra_opts	= udp_opts,
 };
 
 void
 _init(void)
 {
-	xtables_register_match(&udp);
-	xtables_register_match(&udp6);
+	xtables_register_match(&udp_match);
+	xtables_register_match(&udp_match6);
 }
