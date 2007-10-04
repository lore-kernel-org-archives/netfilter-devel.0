From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 08/13] Unique names 2/6
Date: Thu, 4 Oct 2007 12:12:57 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710041209580.7253@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710041209210.7253@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58031 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146AbXJDKM7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Oct 2007 06:12:59 -0400
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id D0FA71C0624CB
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Oct 2007 12:12:57 +0200 (CEST)
In-Reply-To: <Pine.LNX.4.64.0710041209210.7253@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Give symbols of libxt targets unique names (1/3).

Adds unique prefixes to all functions (most of them - especially the hook
functions) so that debugging programs can unambiguously map a symbol to an
address. Also unifies the names of the xtables_match/xtables_target structs,
(based upon libxt_connmark.c/libip6t_*.c).

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 extensions/libxt_CONNMARK.c    |   46 +++++++++-------------
 extensions/libxt_CONNSECMARK.c |   51 +++++++++++++-----------
 extensions/libxt_DSCP.c        |   54 +++++++++++---------------
 extensions/libxt_MARK.c        |   84 ++++++++++++++++++-----------------------
 extensions/libxt_NFLOG.c       |   49 +++++++++++------------
 extensions/libxt_NFQUEUE.c     |   46 ++++++++++------------
 extensions/libxt_NOTRACK.c     |   28 +++++--------
 extensions/libxt_SECMARK.c     |   48 +++++++++++------------
 extensions/libxt_TCPMSS.c      |   80 +++++++++++++++++----------------------
 extensions/libxt_TRACE.c       |   25 +++++-------
 10 files changed, 234 insertions(+), 277 deletions(-)

Index: iptables/extensions/libxt_CONNMARK.c
===================================================================
--- iptables.orig/extensions/libxt_CONNMARK.c
+++ iptables/extensions/libxt_CONNMARK.c
@@ -36,8 +36,7 @@ struct markinfo {
 #endif
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void CONNMARK_help(void)
 {
 	printf(
 "CONNMARK target v%s options:\n"
@@ -48,7 +47,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option CONNMARK_opts[] = {
 	{ "set-mark", 1, NULL, '1' },
 	{ "save-mark", 0, NULL, '2' },
 	{ "restore-mark", 0, NULL, '3' },
@@ -59,9 +58,8 @@ static const struct option opts[] = {
 /* Function which parses command options; returns true if it
    ate an option */
 static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_target **target)
+CONNMARK_parse(int c, char **argv, int invert, unsigned int *flags,
+               const void *entry, struct xt_entry_target **target)
 {
 	struct xt_connmark_target_info *markinfo
 		= (struct xt_connmark_target_info *)(*target)->data;
@@ -114,8 +112,7 @@ parse(int c, char **argv, int invert, un
 	return 1;
 }
 
-static void
-final_check(unsigned int flags)
+static void CONNMARK_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
@@ -137,10 +134,8 @@ print_mask(const char *text, unsigned lo
 
 
 /* Prints out the target info. */
-static void
-print(const void *ip,
-      const struct xt_entry_target *target,
-      int numeric)
+static void CONNMARK_print(const void *ip,
+                           const struct xt_entry_target *target, int numeric)
 {
 	const struct xt_connmark_target_info *markinfo =
 		(const struct xt_connmark_target_info *)target->data;
@@ -167,8 +162,7 @@ print(const void *ip,
 }
 
 /* Saves the target into in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_target *target)
+static void CONNMARK_save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct xt_connmark_target_info *markinfo =
 		(const struct xt_connmark_target_info *)target->data;
@@ -200,12 +194,12 @@ static struct xtables_target connmark_ta
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_connmark_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_connmark_target_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts,
+	.help		= CONNMARK_help,
+	.parse		= CONNMARK_parse,
+	.final_check	= CONNMARK_check,
+	.print		= CONNMARK_print,
+	.save		= CONNMARK_save,
+	.extra_opts	= CONNMARK_opts,
 };
 
 static struct xtables_target connmark_target6 = {
@@ -214,12 +208,12 @@ static struct xtables_target connmark_ta
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_connmark_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_connmark_target_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts,
+	.help		= CONNMARK_help,
+	.parse		= CONNMARK_parse,
+	.final_check	= CONNMARK_check,
+	.print		= CONNMARK_print,
+	.save		= CONNMARK_save,
+	.extra_opts	= CONNMARK_opts,
 };
 
 void _init(void)
Index: iptables/extensions/libxt_CONNSECMARK.c
===================================================================
--- iptables.orig/extensions/libxt_CONNSECMARK.c
+++ iptables/extensions/libxt_CONNSECMARK.c
@@ -14,7 +14,7 @@
 
 #define PFX "CONNSECMARK target: "
 
-static void help(void)
+static void CONNSECMARK_help(void)
 {
 	printf(
 "CONNSECMARK target v%s options:\n"
@@ -24,14 +24,15 @@ static void help(void)
 IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option CONNSECMARK_opts[] = {
 	{ "save", 0, 0, '1' },
 	{ "restore", 0, 0, '2' },
 	{ 0 }
 };
 
-static int parse(int c, char **argv, int invert, unsigned int *flags,
-                 const void *entry, struct xt_entry_target **target)
+static int
+CONNSECMARK_parse(int c, char **argv, int invert, unsigned int *flags,
+                  const void *entry, struct xt_entry_target **target)
 {
 	struct xt_connsecmark_target_info *info =
 		(struct xt_connsecmark_target_info*)(*target)->data;
@@ -60,7 +61,7 @@ static int parse(int c, char **argv, int
 	return 1;
 }
 
-static void final_check(unsigned int flags)
+static void CONNSECMARK_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM, PFX "parameter required");
@@ -86,8 +87,9 @@ static void print_connsecmark(struct xt_
 	}
 }
 
-static void print(const void *ip,
-		  const struct xt_entry_target *target, int numeric)
+static void
+CONNSECMARK_print(const void *ip, const struct xt_entry_target *target,
+                  int numeric)
 {
 	struct xt_connsecmark_target_info *info =
 		(struct xt_connsecmark_target_info*)(target)->data;
@@ -96,7 +98,8 @@ static void print(const void *ip,
 	print_connsecmark(info);
 }
 
-static void save(const void *ip, const struct xt_entry_target *target)
+static void
+CONNSECMARK_save(const void *ip, const struct xt_entry_target *target)
 {
 	struct xt_connsecmark_target_info *info =
 		(struct xt_connsecmark_target_info*)target->data;
@@ -105,38 +108,38 @@ static void save(const void *ip, const s
 	print_connsecmark(info);
 }
 
-static struct xtables_target connsecmark = {
+static struct xtables_target connsecmark_target = {
 	.family		= AF_INET,
 	.name		= "CONNSECMARK",
 	.version	= IPTABLES_VERSION,
 	.revision	= 0,
 	.size		= XT_ALIGN(sizeof(struct xt_connsecmark_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_connsecmark_target_info)),
-	.parse		= &parse,
-	.help		= &help,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts,
+	.parse		= CONNSECMARK_parse,
+	.help		= CONNSECMARK_help,
+	.final_check	= CONNSECMARK_check,
+	.print		= CONNSECMARK_print,
+	.save		= CONNSECMARK_save,
+	.extra_opts	= CONNSECMARK_opts,
 };
 
-static struct xtables_target connsecmark6 = {
+static struct xtables_target connsecmark_target6 = {
 	.family		= AF_INET6,
 	.name		= "CONNSECMARK",
 	.version	= IPTABLES_VERSION,
 	.revision	= 0,
 	.size		= XT_ALIGN(sizeof(struct xt_connsecmark_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_connsecmark_target_info)),
-	.parse		= &parse,
-	.help		= &help,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts,
+	.parse		= CONNSECMARK_parse,
+	.help		= CONNSECMARK_help,
+	.final_check	= CONNSECMARK_check,
+	.print		= CONNSECMARK_print,
+	.save		= CONNSECMARK_save,
+	.extra_opts	= CONNSECMARK_opts,
 };
 
 void _init(void)
 {
-	xtables_register_target(&connsecmark);
-	xtables_register_target(&connsecmark6);
+	xtables_register_target(&connsecmark_target);
+	xtables_register_target(&connsecmark_target6);
 }
Index: iptables/extensions/libxt_DSCP.c
===================================================================
--- iptables.orig/extensions/libxt_DSCP.c
+++ iptables/extensions/libxt_DSCP.c
@@ -21,7 +21,7 @@
 /* This is evil, but it's my code - HW*/
 #include "libipt_dscp_helper.c"
 
-static void help(void) 
+static void DSCP_help(void)
 {
 	printf(
 "DSCP target options\n"
@@ -37,7 +37,7 @@ static void help(void) 
 );
 }
 
-static const struct option opts[] = {
+static const struct option DSCP_opts[] = {
 	{ "set-dscp", 1, NULL, 'F' },
 	{ "set-dscp-class", 1, NULL, 'G' },
 	{ }
@@ -71,10 +71,8 @@ parse_class(const char *s, struct xt_DSC
 }
 
 
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_target **target)
+static int DSCP_parse(int c, char **argv, int invert, unsigned int *flags,
+                      const void *entry, struct xt_entry_target **target)
 {
 	struct xt_DSCP_info *dinfo
 		= (struct xt_DSCP_info *)(*target)->data;
@@ -102,8 +100,7 @@ parse(int c, char **argv, int invert, un
 	return 1;
 }
 
-static void
-final_check(unsigned int flags)
+static void DSCP_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
@@ -117,10 +114,8 @@ print_dscp(u_int8_t dscp, int numeric)
 }
 
 /* Prints out the targinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_target *target,
-      int numeric)
+static void DSCP_print(const void *ip, const struct xt_entry_target *target,
+                       int numeric)
 {
 	const struct xt_DSCP_info *dinfo =
 		(const struct xt_DSCP_info *)target->data;
@@ -129,8 +124,7 @@ print(const void *ip,
 }
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_target *target)
+static void DSCP_save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct xt_DSCP_info *dinfo =
 		(const struct xt_DSCP_info *)target->data;
@@ -138,36 +132,36 @@ save(const void *ip, const struct xt_ent
 	printf("--set-dscp 0x%02x ", dinfo->dscp);
 }
 
-static struct xtables_target dscp = { 
+static struct xtables_target dscp_target = {
 	.family		= AF_INET,
 	.name		= "DSCP",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_DSCP_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_DSCP_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts,
+	.help		= DSCP_help,
+	.parse		= DSCP_parse,
+	.final_check	= DSCP_check,
+	.print		= DSCP_print,
+	.save		= DSCP_save,
+	.extra_opts	= DSCP_opts,
 };
 
-static struct xtables_target dscp6 = { 
+static struct xtables_target dscp_target6 = {
 	.family		= AF_INET6,
 	.name		= "DSCP",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_DSCP_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_DSCP_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts,
+	.help		= DSCP_help,
+	.parse		= DSCP_parse,
+	.final_check	= DSCP_check,
+	.print		= DSCP_print,
+	.save		= DSCP_save,
+	.extra_opts	= DSCP_opts,
 };
 
 void _init(void)
 {
-	xtables_register_target(&dscp);
-	xtables_register_target(&dscp6);
+	xtables_register_target(&dscp_target);
+	xtables_register_target(&dscp_target6);
 }
Index: iptables/extensions/libxt_MARK.c
===================================================================
--- iptables.orig/extensions/libxt_MARK.c
+++ iptables/extensions/libxt_MARK.c
@@ -9,8 +9,7 @@
 #include <linux/netfilter/xt_MARK.h>
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void MARK_help(void)
 {
 	printf(
 "MARK target v%s options:\n"
@@ -21,7 +20,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option MARK_opts[] = {
 	{ "set-mark", 1, NULL, '1' },
 	{ "and-mark", 1, NULL, '2' },
 	{ "or-mark", 1, NULL, '3' },
@@ -31,9 +30,8 @@ static const struct option opts[] = {
 /* Function which parses command options; returns true if it
    ate an option */
 static int
-parse_v0(int c, char **argv, int invert, unsigned int *flags,
-	 const void *entry,
-	 struct xt_entry_target **target)
+MARK_parse_v0(int c, char **argv, int invert, unsigned int *flags,
+              const void *entry, struct xt_entry_target **target)
 {
 	struct xt_mark_target_info *markinfo
 		= (struct xt_mark_target_info *)(*target)->data;
@@ -61,8 +59,7 @@ parse_v0(int c, char **argv, int invert,
 	return 1;
 }
 
-static void
-final_check(unsigned int flags)
+static void MARK_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
@@ -73,9 +70,8 @@ final_check(unsigned int flags)
 /* Function which parses command options; returns true if it
    ate an option */
 static int
-parse_v1(int c, char **argv, int invert, unsigned int *flags,
-	 const void *entry,
-	 struct xt_entry_target **target)
+MARK_parse_v1(int c, char **argv, int invert, unsigned int *flags,
+              const void *entry, struct xt_entry_target **target)
 {
 	struct xt_mark_target_info_v1 *markinfo
 		= (struct xt_mark_target_info_v1 *)(*target)->data;
@@ -112,10 +108,8 @@ print_mark(unsigned long mark)
 }
 
 /* Prints out the targinfo. */
-static void
-print_v0(const void *ip,
-	 const struct xt_entry_target *target,
-	 int numeric)
+static void MARK_print_v0(const void *ip,
+                          const struct xt_entry_target *target, int numeric)
 {
 	const struct xt_mark_target_info *markinfo =
 		(const struct xt_mark_target_info *)target->data;
@@ -124,8 +118,7 @@ print_v0(const void *ip,
 }
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
-static void
-save_v0(const void *ip, const struct xt_entry_target *target)
+static void MARK_save_v0(const void *ip, const struct xt_entry_target *target)
 {
 	const struct xt_mark_target_info *markinfo =
 		(const struct xt_mark_target_info *)target->data;
@@ -135,10 +128,8 @@ save_v0(const void *ip, const struct xt_
 }
 
 /* Prints out the targinfo. */
-static void
-print_v1(const void *ip,
-	 const struct xt_entry_target *target,
-	 int numeric)
+static void MARK_print_v1(const void *ip, const struct xt_entry_target *target,
+                          int numeric)
 {
 	const struct xt_mark_target_info_v1 *markinfo =
 		(const struct xt_mark_target_info_v1 *)target->data;
@@ -158,8 +149,7 @@ print_v1(const void *ip,
 }
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
-static void
-save_v1(const void *ip, const struct xt_entry_target *target)
+static void MARK_save_v1(const void *ip, const struct xt_entry_target *target)
 {
 	const struct xt_mark_target_info_v1 *markinfo =
 		(const struct xt_mark_target_info_v1 *)target->data;
@@ -178,54 +168,54 @@ save_v1(const void *ip, const struct xt_
 	print_mark(markinfo->mark);
 }
 
-static struct xtables_target mark_v0 = {
+static struct xtables_target mark_target_v0 = {
 	.family		= AF_INET,
 	.name		= "MARK",
 	.version	= IPTABLES_VERSION,
 	.revision	= 0,
 	.size		= XT_ALIGN(sizeof(struct xt_mark_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_mark_target_info)),
-	.help		= &help,
-	.parse		= &parse_v0,
-	.final_check	= &final_check,
-	.print		= &print_v0,
-	.save		= &save_v0,
-	.extra_opts	= opts,
+	.help		= MARK_help,
+	.parse		= MARK_parse_v0,
+	.final_check	= MARK_check,
+	.print		= MARK_print_v0,
+	.save		= MARK_save_v0,
+	.extra_opts	= MARK_opts,
 };
 
-static struct xtables_target mark_v1 = {
+static struct xtables_target mark_target_v1 = {
 	.family		= AF_INET,
 	.name		= "MARK",
 	.version	= IPTABLES_VERSION,
 	.revision	= 1,
 	.size		= XT_ALIGN(sizeof(struct xt_mark_target_info_v1)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_mark_target_info_v1)),
-	.help		= &help,
-	.parse		= &parse_v1,
-	.final_check	= &final_check,
-	.print		= &print_v1,
-	.save		= &save_v1,
-	.extra_opts	= opts,
+	.help		= MARK_help,
+	.parse		= MARK_parse_v1,
+	.final_check	= MARK_check,
+	.print		= MARK_print_v1,
+	.save		= MARK_save_v1,
+	.extra_opts	= MARK_opts,
 };
 
-static struct xtables_target mark6_v0 = {
+static struct xtables_target mark_target6_v0 = {
 	.family		= AF_INET6,
 	.name		= "MARK",
 	.version	= IPTABLES_VERSION,
 	.revision	= 0,
 	.size		= XT_ALIGN(sizeof(struct xt_mark_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_mark_target_info)),
-	.help		= &help,
-	.parse		= &parse_v0,
-	.final_check	= &final_check,
-	.print		= &print_v0,
-	.save		= &save_v0,
-	.extra_opts	= opts,
+	.help		= MARK_help,
+	.parse		= MARK_parse_v0,
+	.final_check	= MARK_check,
+	.print		= MARK_print_v0,
+	.save		= MARK_save_v0,
+	.extra_opts	= MARK_opts,
 };
 
 void _init(void)
 {
-	xtables_register_target(&mark_v0);
-	xtables_register_target(&mark_v1);
-	xtables_register_target(&mark6_v0);
+	xtables_register_target(&mark_target_v0);
+	xtables_register_target(&mark_target_v1);
+	xtables_register_target(&mark_target6_v0);
 }
Index: iptables/extensions/libxt_NFLOG.c
===================================================================
--- iptables.orig/extensions/libxt_NFLOG.c
+++ iptables/extensions/libxt_NFLOG.c
@@ -14,7 +14,7 @@ enum {
 	NFLOG_THRESHOLD	= 0x8,
 };
 
-static const struct option opts[] = {
+static const struct option NFLOG_opts[] = {
 	{ "nflog-group",     1, NULL, NFLOG_GROUP },
 	{ "nflog-prefix",    1, NULL, NFLOG_PREFIX },
 	{ "nflog-range",     1, NULL, NFLOG_RANGE },
@@ -22,7 +22,7 @@ static const struct option opts[] = {
 	{NULL},
 };
 
-static void help(void)
+static void NFLOG_help(void)
 {
 	printf("NFLOG v%s options:\n"
 	       " --nflog-group NUM		NETLINK group used for logging\n"
@@ -32,7 +32,7 @@ static void help(void)
 	       IPTABLES_VERSION);
 }
 
-static void init(struct xt_entry_target *t)
+static void NFLOG_init(struct xt_entry_target *t)
 {
 	struct xt_nflog_info *info = (struct xt_nflog_info *)t->data;
 
@@ -40,9 +40,8 @@ static void init(struct xt_entry_target 
 	info->threshold	= XT_NFLOG_DEFAULT_THRESHOLD;
 }
 
-static int parse(int c, char **argv, int invert, unsigned int *flags,
-		 const void *entry,
-		 struct xt_entry_target **target)
+static int NFLOG_parse(int c, char **argv, int invert, unsigned int *flags,
+                       const void *entry, struct xt_entry_target **target)
 {
 	struct xt_nflog_info *info = (struct xt_nflog_info *)(*target)->data;
 	int n;
@@ -122,51 +121,51 @@ static void nflog_print(const struct xt_
 		printf("%snflog-threshold %u ", prefix, info->threshold);
 }
 
-static void print(const void *ip, const struct xt_entry_target *target,
-		  int numeric)
+static void NFLOG_print(const void *ip, const struct xt_entry_target *target,
+                        int numeric)
 {
 	const struct xt_nflog_info *info = (struct xt_nflog_info *)target->data;
 
 	nflog_print(info, "");
 }
 
-static void save(const void *ip, const struct xt_entry_target *target)
+static void NFLOG_save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct xt_nflog_info *info = (struct xt_nflog_info *)target->data;
 
 	nflog_print(info, "--");
 }
 
-static struct xtables_target nflog = {
+static struct xtables_target nflog_target = {
 	.family		= AF_INET,
 	.name		= "NFLOG",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_nflog_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_nflog_info)),
-	.help		= help,
-	.init		= init,
-	.parse		= parse,
-	.print		= print,
-	.save		= save,
-	.extra_opts	= opts,
+	.help		= NFLOG_help,
+	.init		= NFLOG_init,
+	.parse		= NFLOG_parse,
+	.print		= NFLOG_print,
+	.save		= NFLOG_save,
+	.extra_opts	= NFLOG_opts,
 };
 
-static struct xtables_target nflog6 = {
+static struct xtables_target nflog_target6 = {
 	.family		= AF_INET6,
 	.name		= "NFLOG",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_nflog_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_nflog_info)),
-	.help		= help,
-	.init		= init,
-	.parse		= parse,
-	.print		= print,
-	.save		= save,
-	.extra_opts	= opts,
+	.help		= NFLOG_help,
+	.init		= NFLOG_init,
+	.parse		= NFLOG_parse,
+	.print		= NFLOG_print,
+	.save		= NFLOG_save,
+	.extra_opts	= NFLOG_opts,
 };
 
 void _init(void)
 {
-	xtables_register_target(&nflog);
-	xtables_register_target(&nflog6);
+	xtables_register_target(&nflog_target);
+	xtables_register_target(&nflog_target6);
 }
Index: iptables/extensions/libxt_NFQUEUE.c
===================================================================
--- iptables.orig/extensions/libxt_NFQUEUE.c
+++ iptables/extensions/libxt_NFQUEUE.c
@@ -14,7 +14,7 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_NFQUEUE.h>
 
-static void help(void) 
+static void NFQUEUE_help(void)
 {
 	printf(
 "NFQUEUE target options\n"
@@ -23,7 +23,7 @@ static void help(void) 
 );
 }
 
-static const struct option opts[] = {
+static const struct option NFQUEUE_opts[] = {
 	{ "queue-num", 1, NULL, 'F' },
 	{ }
 };
@@ -42,9 +42,8 @@ parse_num(const char *s, struct xt_NFQ_i
 }
 
 static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_target **target)
+NFQUEUE_parse(int c, char **argv, int invert, unsigned int *flags,
+              const void *entry, struct xt_entry_target **target)
 {
 	struct xt_NFQ_info *tinfo
 		= (struct xt_NFQ_info *)(*target)->data;
@@ -64,10 +63,8 @@ parse(int c, char **argv, int invert, un
 }
 
 /* Prints out the targinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_target *target,
-      int numeric)
+static void NFQUEUE_print(const void *ip,
+                          const struct xt_entry_target *target, int numeric)
 {
 	const struct xt_NFQ_info *tinfo =
 		(const struct xt_NFQ_info *)target->data;
@@ -75,8 +72,7 @@ print(const void *ip,
 }
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_target *target)
+static void NFQUEUE_save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct xt_NFQ_info *tinfo =
 		(const struct xt_NFQ_info *)target->data;
@@ -84,34 +80,34 @@ save(const void *ip, const struct xt_ent
 	printf("--queue-num %u ", tinfo->queuenum);
 }
 
-static struct xtables_target nfqueue = { 
+static struct xtables_target nfqueue_target = {
 	.family		= AF_INET,
 	.name		= "NFQUEUE",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_NFQ_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_NFQ_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= NFQUEUE_help,
+	.parse		= NFQUEUE_parse,
+	.print		= NFQUEUE_print,
+	.save		= NFQUEUE_save,
+	.extra_opts	= NFQUEUE_opts
 };
 
-static struct xtables_target nfqueue6 = { 
+static struct xtables_target nfqueue_target6 = {
 	.family		= AF_INET6,
 	.name		= "NFQUEUE",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_NFQ_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_NFQ_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= NFQUEUE_help,
+	.parse		= NFQUEUE_parse,
+	.print		= NFQUEUE_print,
+	.save		= NFQUEUE_save,
+	.extra_opts	= NFQUEUE_opts,
 };
 
 void _init(void)
 {
-	xtables_register_target(&nfqueue);
-	xtables_register_target(&nfqueue6);
+	xtables_register_target(&nfqueue_target);
+	xtables_register_target(&nfqueue_target6);
 }
Index: iptables/extensions/libxt_NOTRACK.c
===================================================================
--- iptables.orig/extensions/libxt_NOTRACK.c
+++ iptables/extensions/libxt_NOTRACK.c
@@ -8,8 +8,7 @@
 #include <linux/netfilter/x_tables.h>
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void NOTRACK_help(void)
 {
 	printf(
 "NOTRACK target v%s takes no options\n",
@@ -19,39 +18,34 @@ IPTABLES_VERSION);
 /* Function which parses command options; returns true if it
    ate an option */
 static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_target **target)
+NOTRACK_parse(int c, char **argv, int invert, unsigned int *flags,
+              const void *entry, struct xt_entry_target **target)
 {
 	return 0;
 }
 
-static
-struct xtables_target notrack =
-{
+static struct xtables_target notrack_target = {
 	.family		= AF_INET,
 	.name		= "NOTRACK",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(0),
 	.userspacesize	= XT_ALIGN(0),
-	.help		= &help,
-	.parse		= &parse,
+	.help		= NOTRACK_help,
+	.parse		= NOTRACK_parse,
 };
 
-static
-struct xtables_target notrack6 =
-{
+static struct xtables_target notrack_target6 = {
 	.family		= AF_INET6,
 	.name		= "NOTRACK",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(0),
 	.userspacesize	= XT_ALIGN(0),
-	.help		= &help,
-	.parse		= &parse,
+	.help		= NOTRACK_help,
+	.parse		= NOTRACK_parse,
 };
 
 void _init(void)
 {
-	xtables_register_target(&notrack);
-	xtables_register_target(&notrack6);
+	xtables_register_target(&notrack_target);
+	xtables_register_target(&notrack_target6);
 }
Index: iptables/extensions/libxt_SECMARK.c
===================================================================
--- iptables.orig/extensions/libxt_SECMARK.c
+++ iptables/extensions/libxt_SECMARK.c
@@ -14,7 +14,7 @@
 
 #define PFX "SECMARK target: "
 
-static void help(void)
+static void SECMARK_help(void)
 {
 	printf(
 "SECMARK target v%s options:\n"
@@ -23,7 +23,7 @@ static void help(void)
 IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option SECMARK_opts[] = {
 	{ "selctx", 1, 0, '1' },
 	{ 0 }
 };
@@ -32,8 +32,8 @@ static const struct option opts[] = {
  * Function which parses command options; returns true if it
  * ate an option.
  */
-static int parse(int c, char **argv, int invert, unsigned int *flags,
-                 const void *entry, struct xt_entry_target **target)
+static int SECMARK_parse(int c, char **argv, int invert, unsigned int *flags,
+                         const void *entry, struct xt_entry_target **target)
 {
 	struct xt_secmark_target_info *info =
 		(struct xt_secmark_target_info*)(*target)->data;
@@ -61,7 +61,7 @@ static int parse(int c, char **argv, int
 	return 1;
 }
 
-static void final_check(unsigned int flags)
+static void SECMARK_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM, PFX "parameter required");
@@ -79,8 +79,8 @@ static void print_secmark(struct xt_secm
 	}
 }
 
-static void print(const void *ip,
-		  const struct xt_entry_target *target, int numeric)
+static void SECMARK_print(const void *ip, const struct xt_entry_target *target,
+                          int numeric)
 {
 	struct xt_secmark_target_info *info =
 		(struct xt_secmark_target_info*)(target)->data;
@@ -90,7 +90,7 @@ static void print(const void *ip,
 }
 
 /* Saves the target info in parsable form to stdout. */
-static void save(const void *ip, const struct xt_entry_target *target)
+static void SECMARK_save(const void *ip, const struct xt_entry_target *target)
 {
 	struct xt_secmark_target_info *info =
 		(struct xt_secmark_target_info*)target->data;
@@ -99,38 +99,38 @@ static void save(const void *ip, const s
 	print_secmark(info);
 }
 
-static struct xtables_target secmark = {
+static struct xtables_target secmark_target = {
 	.family		= AF_INET,
 	.name		= "SECMARK",
 	.version	= IPTABLES_VERSION,
 	.revision	= 0,
 	.size		= XT_ALIGN(sizeof(struct xt_secmark_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_secmark_target_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= SECMARK_help,
+	.parse		= SECMARK_parse,
+	.final_check	= SECMARK_check,
+	.print		= SECMARK_print,
+	.save		= SECMARK_save,
+	.extra_opts	= SECMARK_opts,
 };
 
-static struct xtables_target secmark6 = {
+static struct xtables_target secmark_target6 = {
 	.family		= AF_INET6,
 	.name		= "SECMARK",
 	.version	= IPTABLES_VERSION,
 	.revision	= 0,
 	.size		= XT_ALIGN(sizeof(struct xt_secmark_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_secmark_target_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= SECMARK_help,
+	.parse		= SECMARK_parse,
+	.final_check	= SECMARK_check,
+	.print		= SECMARK_print,
+	.save		= SECMARK_save,
+	.extra_opts	= SECMARK_opts,
 };
 
 void _init(void)
 {
-	xtables_register_target(&secmark);
-	xtables_register_target(&secmark6);
+	xtables_register_target(&secmark_target);
+	xtables_register_target(&secmark_target6);
 }
Index: iptables/extensions/libxt_TCPMSS.c
===================================================================
--- iptables.orig/extensions/libxt_TCPMSS.c
+++ iptables/extensions/libxt_TCPMSS.c
@@ -17,7 +17,7 @@ struct mssinfo {
 };
 
 /* Function which prints out usage message. */
-static void __help(int hdrsize)
+static void __TCPMSS_help(int hdrsize)
 {
 	printf(
 "TCPMSS target v%s mutually-exclusive options:\n"
@@ -26,17 +26,17 @@ static void __help(int hdrsize)
 IPTABLES_VERSION, hdrsize);
 }
 
-static void help(void)
+static void TCPMSS_help(void)
 {
-	__help(40);
+	__TCPMSS_help(40);
 }
 
-static void help6(void)
+static void TCPMSS_help6(void)
 {
-	__help(60);
+	__TCPMSS_help(60);
 }
 
-static const struct option opts[] = {
+static const struct option TCPMSS_opts[] = {
 	{ "set-mss", 1, NULL, '1' },
 	{ "clamp-mss-to-pmtu", 0, NULL, '2' },
 	{ }
@@ -44,11 +44,9 @@ static const struct option opts[] = {
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-__parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_target **target,
-      int hdrsize)
+static int __TCPMSS_parse(int c, char **argv, int invert, unsigned int *flags,
+                          const void *entry, struct xt_entry_target **target,
+                          int hdrsize)
 {
 	struct xt_tcpmss_info *mssinfo
 		= (struct xt_tcpmss_info *)(*target)->data;
@@ -82,24 +80,19 @@ __parse(int c, char **argv, int invert, 
 	return 1;
 }
 
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_target **target)
+static int TCPMSS_parse(int c, char **argv, int invert, unsigned int *flags,
+                        const void *entry, struct xt_entry_target **target)
 {
-	return __parse(c, argv, invert, flags, entry, target, 40);
+	return __TCPMSS_parse(c, argv, invert, flags, entry, target, 40);
 }
 
-static int
-parse6(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_target **target)
+static int TCPMSS_parse6(int c, char **argv, int invert, unsigned int *flags,
+                         const void *entry, struct xt_entry_target **target)
 {
-	return __parse(c, argv, invert, flags, entry, target, 60);
+	return __TCPMSS_parse(c, argv, invert, flags, entry, target, 60);
 }
 
-static void
-final_check(unsigned int flags)
+static void TCPMSS_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
@@ -107,10 +100,8 @@ final_check(unsigned int flags)
 }
 
 /* Prints out the targinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_target *target,
-      int numeric)
+static void TCPMSS_print(const void *ip, const struct xt_entry_target *target,
+                         int numeric)
 {
 	const struct xt_tcpmss_info *mssinfo =
 		(const struct xt_tcpmss_info *)target->data;
@@ -121,8 +112,7 @@ print(const void *ip,
 }
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_target *target)
+static void TCPMSS_save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct xt_tcpmss_info *mssinfo =
 		(const struct xt_tcpmss_info *)target->data;
@@ -133,36 +123,36 @@ save(const void *ip, const struct xt_ent
 		printf("--set-mss %u ", mssinfo->mss);
 }
 
-static struct xtables_target mss = {
+static struct xtables_target tcpmss_target = {
 	.family		= AF_INET,
 	.name		= "TCPMSS",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_tcpmss_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_tcpmss_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= TCPMSS_help,
+	.parse		= TCPMSS_parse,
+	.final_check	= TCPMSS_check,
+	.print		= TCPMSS_print,
+	.save		= TCPMSS_save,
+	.extra_opts	= TCPMSS_opts,
 };
 
-static struct xtables_target mss6 = {
+static struct xtables_target tcpmss_target6 = {
 	.family		= AF_INET6,
 	.name		= "TCPMSS",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_tcpmss_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_tcpmss_info)),
-	.help		= &help6,
-	.parse		= &parse6,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= TCPMSS_help6,
+	.parse		= TCPMSS_parse6,
+	.final_check	= TCPMSS_check,
+	.print		= TCPMSS_print,
+	.save		= TCPMSS_save,
+	.extra_opts	= TCPMSS_opts,
 };
 
 void _init(void)
 {
-	xtables_register_target(&mss);
-	xtables_register_target(&mss6);
+	xtables_register_target(&tcpmss_target);
+	xtables_register_target(&tcpmss_target6);
 }
Index: iptables/extensions/libxt_TRACE.c
===================================================================
--- iptables.orig/extensions/libxt_TRACE.c
+++ iptables/extensions/libxt_TRACE.c
@@ -8,8 +8,7 @@
 #include <linux/netfilter/x_tables.h>
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void TRACE_help(void)
 {
 	printf(
 "TRACE target v%s takes no options\n",
@@ -18,36 +17,34 @@ IPTABLES_VERSION);
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_target **target)
+static int TRACE_parse(int c, char **argv, int invert, unsigned int *flags,
+                       const void *entry, struct xt_entry_target **target)
 {
 	return 0;
 }
 
-static struct xtables_target trace = {
+static struct xtables_target trace_target = {
 	.family		= AF_INET,
 	.name		= "TRACE",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(0),
 	.userspacesize	= XT_ALIGN(0),
-	.help		= &help,
-	.parse		= &parse,
+	.help		= TRACE_help,
+	.parse		= TRACE_parse,
 };
 
-static struct xtables_target trace6 = {
+static struct xtables_target trace_target6 = {
 	.family		= AF_INET6,
 	.name		= "TRACE",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(0),
 	.userspacesize	= XT_ALIGN(0),
-	.help		= &help,
-	.parse		= &parse,
+	.help		= TRACE_help,
+	.parse		= TRACE_parse,
 };
 
 void _init(void)
 {
-	xtables_register_target(&trace);
-	xtables_register_target(&trace6);
+	xtables_register_target(&trace_target);
+	xtables_register_target(&trace_target6);
 }
