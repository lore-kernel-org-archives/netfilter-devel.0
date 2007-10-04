From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 11/13] Unique names 5/6
Date: Thu, 4 Oct 2007 12:13:25 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710041210090.7253@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710041209210.7253@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58039 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429AbXJDKN1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Oct 2007 06:13:27 -0400
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id C90751C0624CB
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Oct 2007 12:13:25 +0200 (CEST)
In-Reply-To: <Pine.LNX.4.64.0710041209210.7253@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Give symbols of libxt matches unique names (3/3).

Adds unique prefixes to all functions (most of them - especially the hook
functions) so that debugging programs can unambiguously map a symbol to an
address. Also unifies the names of the xtables_match/xtables_target structs,
(based upon libxt_connmark.c/libip6t_*.c).

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 extensions/libip6t_ah.c         |   38 ++++++++++++++-------------------
 extensions/libip6t_condition.c  |   43 ++++++++++++++------------------------
 extensions/libip6t_dst.c        |   38 ++++++++++++++-------------------
 extensions/libip6t_eui64.c      |   17 ++++++---------
 extensions/libip6t_frag.c       |   38 ++++++++++++++-------------------
 extensions/libip6t_hbh.c        |   39 +++++++++++++++-------------------
 extensions/libip6t_hl.c         |   36 ++++++++++++++------------------
 extensions/libip6t_icmp6.c      |   42 ++++++++++++++++---------------------
 extensions/libip6t_ipv6header.c |   45 ++++++++++++++++------------------------
 extensions/libip6t_mh.c         |   34 ++++++++++++++----------------
 extensions/libip6t_owner.c      |   39 ++++++++++++++--------------------
 extensions/libip6t_policy.c     |   34 ++++++++++++++----------------
 extensions/libip6t_rt.c         |   37 ++++++++++++++------------------
 extensions/libip6t_state.c      |   37 ++++++++++++++------------------
 14 files changed, 220 insertions(+), 297 deletions(-)

Index: iptables/extensions/libip6t_ah.c
===================================================================
--- iptables.orig/extensions/libip6t_ah.c
+++ iptables/extensions/libip6t_ah.c
@@ -9,8 +9,7 @@
 #include <linux/netfilter_ipv6/ip6t_ah.h>
                                         
 /* Function which prints out usage message. */
-static void
-help(void)
+static void ah_help(void)
 {
 	printf(
 "AH v%s options:\n"
@@ -20,7 +19,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option ah_opts[] = {
 	{ .name = "ahspi", .has_arg = 1, .val = '1' },
 	{ .name = "ahlen", .has_arg = 1, .val = '2' },
 	{ .name = "ahres", .has_arg = 0, .val = '3' },
@@ -71,8 +70,7 @@ parse_ah_spis(const char *spistring, u_i
 }
 
 /* Initialize the match. */
-static void
-init(struct xt_entry_match *m)
+static void ah_init(struct xt_entry_match *m)
 {
 	struct ip6t_ah *ahinfo = (struct ip6t_ah *)m->data;
 
@@ -83,10 +81,8 @@ init(struct xt_entry_match *m)
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+static int ah_parse(int c, char **argv, int invert, unsigned int *flags,
+                    const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_ah *ahinfo = (struct ip6t_ah *)(*match)->data;
 
@@ -149,9 +145,8 @@ print_len(const char *name, u_int32_t le
 }
 
 /* Prints out the union ip6t_matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match, int numeric)
+static void ah_print(const void *ip, const struct xt_entry_match *match,
+                     int numeric)
 {
 	const struct ip6t_ah *ah = (struct ip6t_ah *)match->data;
 
@@ -170,7 +165,7 @@ print(const void *ip,
 }
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void save(const void *ip, const struct xt_entry_match *match)
+static void ah_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_ah *ahinfo = (struct ip6t_ah *)match->data;
 
@@ -198,22 +193,21 @@ static void save(const void *ip, const s
 		printf("--ahres ");
 }
 
-static
-struct ip6tables_match ah = {
+static struct ip6tables_match ah_match6 = {
 	.name          = "ah",
 	.version       = IPTABLES_VERSION,
 	.size          = IP6T_ALIGN(sizeof(struct ip6t_ah)),
 	.userspacesize = IP6T_ALIGN(sizeof(struct ip6t_ah)),
-	.help          = &help,
-	.init          = &init,
-	.parse         = &parse,
-	.print         = &print,
-	.save          = &save,
-	.extra_opts    = opts
+	.help          = ah_help,
+	.init          = ah_init,
+	.parse         = ah_parse,
+	.print         = ah_print,
+	.save          = ah_save,
+	.extra_opts    = ah_opts,
 };
 
 void
 _init(void)
 {
-	register_match6(&ah);
+	register_match6(&ah_match6);
 }
Index: iptables/extensions/libip6t_condition.c
===================================================================
--- iptables.orig/extensions/libip6t_condition.c
+++ iptables/extensions/libip6t_condition.c
@@ -8,9 +8,7 @@
 #include<linux/netfilter_ipv6/ip6_tables.h>
 #include<linux/netfilter_ipv6/ip6t_condition.h>
 
-
-static void
-help(void)
+static void condition_help(void)
 {
 	printf("condition match v%s options:\n"
 	       "--condition [!] filename       "
@@ -18,16 +16,14 @@ help(void)
 	       IPTABLES_VERSION);
 }
 
-
-static const struct option opts[] = {
+static const struct option condition_opts[] = {
 	{ .name = "condition", .has_arg = 1, .flag = 0, .val = 'X' },
 	{ .name = 0 }
 };
 
 static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+condition_parse(int c, char **argv, int invert, unsigned int *flags,
+                const void *entry, struct xt_entry_match **match)
 {
 	struct condition6_info *info =
 	    (struct condition6_info *) (*match)->data;
@@ -53,19 +49,15 @@ parse(int c, char **argv, int invert, un
 	return 0;
 }
 
-
-static void
-final_check(unsigned int flags)
+static void condition_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
 			   "Condition match: must specify --condition");
 }
 
-
-static void
-print(const void *ip,
-		  const struct xt_entry_match *match, int numeric)
+static void condition_print(const void *ip, const struct xt_entry_match *match,
+                            int numeric)
 {
 	const struct condition6_info *info =
 	    (const struct condition6_info *) match->data;
@@ -74,9 +66,7 @@ print(const void *ip,
 }
 
 
-static void
-save(const void *ip,
-		 const struct xt_entry_match *match)
+static void condition_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct condition6_info *info =
 	    (const struct condition6_info *) match->data;
@@ -84,23 +74,22 @@ save(const void *ip,
 	printf("--condition %s\"%s\" ", (info->invert) ? "! " : "", info->name);
 }
 
-
-static struct ip6tables_match condition = {
+static struct ip6tables_match condition_match6 = {
 	.name = "condition",
 	.version = IPTABLES_VERSION,
 	.size = IP6T_ALIGN(sizeof(struct condition6_info)),
 	.userspacesize = IP6T_ALIGN(sizeof(struct condition6_info)),
-	.help = &help,
-	.parse = &parse,
-	.final_check = &final_check,
-	.print = &print,
-	.save = &save,
-	.extra_opts = opts
+	.help = condition_help,
+	.parse = condition_parse,
+	.final_check = condition_check,
+	.print = condition_print,
+	.save = condition_save,
+	.extra_opts = condition_opts,
 };
 
 
 void
 _init(void)
 {
-	register_match6(&condition);
+	register_match6(&condition_match6);
 }
Index: iptables/extensions/libip6t_dst.c
===================================================================
--- iptables.orig/extensions/libip6t_dst.c
+++ iptables/extensions/libip6t_dst.c
@@ -20,8 +20,7 @@
 #endif
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void dst_help(void)
 {
 	printf(
 UNAME " v%s options:\n"
@@ -31,7 +30,7 @@ UNAME " v%s options:\n"
 IPTABLES_VERSION, IP6T_OPTS_OPTSNR);
 }
 
-static const struct option opts[] = {
+static const struct option dst_opts[] = {
 	{ .name = LNAME "-len",        .has_arg = 1, .val = '1' },
 	{ .name = LNAME "-opts",       .has_arg = 1, .val = '2' },
 	{ .name = LNAME "-not-strict", .has_arg = 1, .val = '3' },
@@ -117,8 +116,7 @@ parse_options(const char *optsstr, u_int
 }
 
 /* Initialize the match. */
-static void
-init(struct xt_entry_match *m)
+static void dst_init(struct xt_entry_match *m)
 {
 	struct ip6t_opts *optinfo = (struct ip6t_opts *)m->data;
 
@@ -130,10 +128,8 @@ init(struct xt_entry_match *m)
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+static int dst_parse(int c, char **argv, int invert, unsigned int *flags,
+                     const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_opts *optinfo = (struct ip6t_opts *)(*match)->data;
 
@@ -195,9 +191,8 @@ print_options(int optsnr, u_int16_t *opt
 }
 
 /* Prints out the union ip6t_matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match, int numeric)
+static void dst_print(const void *ip, const struct xt_entry_match *match,
+                      int numeric)
 {
 	const struct ip6t_opts *optinfo = (struct ip6t_opts *)match->data;
 
@@ -221,7 +216,7 @@ print(const void *ip,
 }
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void save(const void *ip, const struct xt_entry_match *match)
+static void dst_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_opts *optinfo = (struct ip6t_opts *)match->data;
 
@@ -240,22 +235,21 @@ static void save(const void *ip, const s
 		printf("--" LNAME "-not-strict ");
 }
 
-static
-struct ip6tables_match optstruct = {
+static struct ip6tables_match dst_match6 = {
 	.name          = LNAME,
 	.version       = IPTABLES_VERSION,
 	.size          = IP6T_ALIGN(sizeof(struct ip6t_opts)),
 	.userspacesize = IP6T_ALIGN(sizeof(struct ip6t_opts)),
-	.help          = &help,
-	.init          = &init,
-	.parse         = &parse,
-	.print         = &print,
-	.save          = &save,
-	.extra_opts    = opts
+	.help          = dst_help,
+	.init          = dst_init,
+	.parse         = dst_parse,
+	.print         = dst_print,
+	.save          = dst_save,
+	.extra_opts    = dst_opts,
 };
 
 void
 _init(void)
 {
-	register_match6(&optstruct);
+	register_match6(&dst_match6);
 }
Index: iptables/extensions/libip6t_eui64.c
===================================================================
--- iptables.orig/extensions/libip6t_eui64.c
+++ iptables/extensions/libip6t_eui64.c
@@ -12,8 +12,7 @@
 #include <ip6tables.h>
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void eui64_help(void)
 {
 	printf(
 "eui64 v%s options:\n"
@@ -24,24 +23,22 @@ help(void)
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+static int eui64_parse(int c, char **argv, int invert, unsigned int *flags,
+                       const void *entry, struct xt_entry_match **match)
 {
 	return 0;
 }
 
-static struct ip6tables_match eui64 = {
+static struct ip6tables_match eui64_target6 = {
 	.name 		= "eui64",
 	.version	= IPTABLES_VERSION,
 	.size		= IP6T_ALIGN(sizeof(int)),
 	.userspacesize	= IP6T_ALIGN(sizeof(int)),
-	.help		= &help,
-	.parse		= &parse,
+	.help		= eui64_help,
+	.parse		= eui64_parse,
 };
 
 void _init(void)
 {
-	register_match6(&eui64);
+	register_match6(&eui64_target6);
 }
Index: iptables/extensions/libip6t_frag.c
===================================================================
--- iptables.orig/extensions/libip6t_frag.c
+++ iptables/extensions/libip6t_frag.c
@@ -9,8 +9,7 @@
 #include <linux/netfilter_ipv6/ip6t_frag.h>
                                         
 /* Function which prints out usage message. */
-static void
-help(void)
+static void frag_help(void)
 {
 	printf(
 "FRAG v%s options:\n"
@@ -23,7 +22,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option frag_opts[] = {
 	{ .name = "fragid",    .has_arg = 1, .val = '1' },
 	{ .name = "fraglen",   .has_arg = 1, .val = '2' },
 	{ .name = "fragres",   .has_arg = 0, .val = '3' },
@@ -77,8 +76,7 @@ parse_frag_ids(const char *idstring, u_i
 }
 
 /* Initialize the match. */
-static void
-init(struct xt_entry_match *m)
+static void frag_init(struct xt_entry_match *m)
 {
 	struct ip6t_frag *fraginfo = (struct ip6t_frag *)m->data;
 
@@ -91,10 +89,8 @@ init(struct xt_entry_match *m)
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+static int frag_parse(int c, char **argv, int invert, unsigned int *flags,
+                      const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_frag *fraginfo = (struct ip6t_frag *)(*match)->data;
 
@@ -172,9 +168,8 @@ print_ids(const char *name, u_int32_t mi
 }
 
 /* Prints out the union ip6t_matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match, int numeric)
+static void frag_print(const void *ip, const struct xt_entry_match *match,
+                       int numeric)
 {
 	const struct ip6t_frag *frag = (struct ip6t_frag *)match->data;
 
@@ -206,7 +201,7 @@ print(const void *ip,
 }
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void save(const void *ip, const struct xt_entry_match *match)
+static void frag_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_frag *fraginfo = (struct ip6t_frag *)match->data;
 
@@ -243,22 +238,21 @@ static void save(const void *ip, const s
 		printf("--fraglast ");
 }
 
-static
-struct ip6tables_match frag = {
+static struct ip6tables_match frag_match6 = {
 	.name          = "frag",
 	.version       = IPTABLES_VERSION,
 	.size          = IP6T_ALIGN(sizeof(struct ip6t_frag)),
 	.userspacesize = IP6T_ALIGN(sizeof(struct ip6t_frag)),
-	.help          = &help,
-	.init          = &init,
-	.parse         = &parse,
-	.print         = &print,
-	.save          = &save,
-	.extra_opts    = opts
+	.help          = frag_help,
+	.init          = frag_init,
+	.parse         = frag_parse,
+	.print         = frag_print,
+	.save          = frag_save,
+	.extra_opts    = frag_opts,
 };
 
 void
 _init(void)
 {
-	register_match6(&frag);
+	register_match6(&frag_match6);
 }
Index: iptables/extensions/libip6t_hbh.c
===================================================================
--- iptables.orig/extensions/libip6t_hbh.c
+++ iptables/extensions/libip6t_hbh.c
@@ -18,8 +18,7 @@
 #define LNAME		(HOPBYHOP ? "hbh" : "dst")
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void hbh_help(void)
 {
 	printf(
 "%s v%s options:\n"
@@ -30,14 +29,14 @@ UNAME , IPTABLES_VERSION, LNAME, LNAME, 
 }
 
 #if HOPBYHOP
-static const struct option opts[] = {
+static const struct option hbh_opts[] = {
 	{ "hbh-len", 1, NULL, '1' },
 	{ "hbh-opts", 1, NULL, '2' },
 	{ "hbh-not-strict", 1, NULL, '3' },
 	{ }
 };
 #else
-static const struct option opts[] = {
+static const struct option hbh_opts[] = {
 	{ "dst-len", 1, NULL, '1' },
 	{ "dst-opts", 1, NULL, '2' },
 	{ "dst-not-strict", 1, NULL, '3' },
@@ -116,8 +115,7 @@ parse_options(const char *optsstr, u_int
 }
 
 /* Initialize the match. */
-static void
-init(struct xt_entry_match *m)
+static void hbh_init(struct xt_entry_match *m)
 {
 	struct ip6t_opts *optinfo = (struct ip6t_opts *)m->data;
 
@@ -129,10 +127,8 @@ init(struct xt_entry_match *m)
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+static int hbh_parse(int c, char **argv, int invert, unsigned int *flags,
+                     const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_opts *optinfo = (struct ip6t_opts *)(*match)->data;
 
@@ -192,9 +188,8 @@ print_options(int optsnr, u_int16_t *opt
 }
 
 /* Prints out the union ip6t_matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match, int numeric)
+static void hbh_print(const void *ip, const struct xt_entry_match *match,
+                      int numeric)
 {
 	const struct ip6t_opts *optinfo = (struct ip6t_opts *)match->data;
 
@@ -214,7 +209,7 @@ print(const void *ip,
 }
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void save(const void *ip, const struct xt_entry_match *match)
+static void hbh_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_opts *optinfo = (struct ip6t_opts *)match->data;
 
@@ -230,7 +225,7 @@ static void save(const void *ip, const s
 
 }
 
-static struct ip6tables_match optstruct = {
+static struct ip6tables_match hbh_match6 = {
 #if HOPBYHOP
 	.name 		= "hbh",
 #else
@@ -239,16 +234,16 @@ static struct ip6tables_match optstruct 
 	.version	= IPTABLES_VERSION,
 	.size		= IP6T_ALIGN(sizeof(struct ip6t_opts)),
 	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_opts)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts,
+	.help		= hbh_help,
+	.init		= hbh_init,
+	.parse		= hbh_parse,
+	.print		= hbh_print,
+	.save		= hbh_save,
+	.extra_opts	= hbh_opts,
 };
 
 void
 _init(void)
 {
-	register_match6(&optstruct);
+	register_match6(&hbh_match6);
 }
Index: iptables/extensions/libip6t_hl.c
===================================================================
--- iptables.orig/extensions/libip6t_hl.c
+++ iptables/extensions/libip6t_hl.c
@@ -15,7 +15,7 @@
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv6/ip6t_hl.h>
 
-static void help(void) 
+static void hl_help(void)
 {
 	printf(
 "HL match v%s options:\n"
@@ -25,9 +25,8 @@ static void help(void) 
 , IPTABLES_VERSION);
 }
 
-static int parse(int c, char **argv, int invert, unsigned int *flags,
-		const void *entry,
-		struct xt_entry_match **match)
+static int hl_parse(int c, char **argv, int invert, unsigned int *flags,
+                    const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_hl_info *info = (struct ip6t_hl_info *) (*match)->data;
 	u_int8_t value;
@@ -81,7 +80,7 @@ static int parse(int c, char **argv, int
 	return 1;
 }
 
-static void final_check(unsigned int flags)
+static void hl_check(unsigned int flags)
 {
 	if (!flags) 
 		exit_error(PARAMETER_PROBLEM,
@@ -89,9 +88,8 @@ static void final_check(unsigned int fla
 			"`--hl-eq', `--hl-lt', `--hl-gt'");
 }
 
-static void print(const void *ip,
-		const struct xt_entry_match *match,
-		int numeric)
+static void hl_print(const void *ip, const struct xt_entry_match *match,
+                     int numeric)
 {
 	static const char *op[] = {
 		[IP6T_HL_EQ] = "==",
@@ -105,8 +103,7 @@ static void print(const void *ip,
 	printf("HL match HL %s %u ", op[info->mode], info->hop_limit);
 }
 
-static void save(const void *ip,
-		const struct xt_entry_match *match)
+static void hl_save(const void *ip, const struct xt_entry_match *match)
 {
 	static const char *op[] = {
 		[IP6T_HL_EQ] = "eq",
@@ -120,7 +117,7 @@ static void save(const void *ip,
 	printf("--hl-%s %u ", op[info->mode], info->hop_limit);
 }
 
-static const struct option opts[] = {
+static const struct option hl_opts[] = {
 	{ .name = "hl",    .has_arg = 1, .val = '2' },
 	{ .name = "hl-eq", .has_arg = 1, .val = '2' },
 	{ .name = "hl-lt", .has_arg = 1, .val = '3' },
@@ -128,22 +125,21 @@ static const struct option opts[] = {
 	{ }
 };
 
-static
-struct ip6tables_match hl = {
+static struct ip6tables_match hl_match6 = {
 	.name          = "hl",
 	.version       = IPTABLES_VERSION,
 	.size          = IP6T_ALIGN(sizeof(struct ip6t_hl_info)),
 	.userspacesize = IP6T_ALIGN(sizeof(struct ip6t_hl_info)),
-	.help          = &help,
-	.parse         = &parse,
-	.final_check   = &final_check,
-	.print         = &print,
-	.save          = &save,
-	.extra_opts    = opts
+	.help          = hl_help,
+	.parse         = hl_parse,
+	.final_check   = hl_check,
+	.print         = hl_print,
+	.save          = hl_save,
+	.extra_opts    = hl_opts,
 };
 
 
 void _init(void) 
 {
-	register_match6(&hl);
+	register_match6(&hl_match6);
 }
Index: iptables/extensions/libip6t_icmp6.c
===================================================================
--- iptables.orig/extensions/libip6t_icmp6.c
+++ iptables/extensions/libip6t_icmp6.c
@@ -74,8 +74,7 @@ print_icmpv6types(void)
 }
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void icmp6_help(void)
 {
 	printf(
 "ICMPv6 v%s options:\n"
@@ -85,7 +84,7 @@ help(void)
 	print_icmpv6types();
 }
 
-static const struct option opts[] = {
+static const struct option icmp6_opts[] = {
 	{ "icmpv6-type", 1, NULL, '1' },
 	{ }
 };
@@ -144,8 +143,7 @@ parse_icmpv6(const char *icmpv6type, u_i
 }
 
 /* Initialize the match. */
-static void
-init(struct xt_entry_match *m)
+static void icmp6_init(struct xt_entry_match *m)
 {
 	struct ip6t_icmp *icmpv6info = (struct ip6t_icmp *)m->data;
 
@@ -154,10 +152,8 @@ init(struct xt_entry_match *m)
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+static int icmp6_parse(int c, char **argv, int invert, unsigned int *flags,
+                       const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_icmp *icmpv6info = (struct ip6t_icmp *)(*match)->data;
 
@@ -219,10 +215,8 @@ static void print_icmpv6type(u_int8_t ty
 }
 
 /* Prints out the union ipt_matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
+static void icmp6_print(const void *ip, const struct xt_entry_match *match,
+                        int numeric)
 {
 	const struct ip6t_icmp *icmpv6 = (struct ip6t_icmp *)match->data;
 
@@ -237,7 +231,7 @@ print(const void *ip,
 }
 
 /* Saves the match in parsable form to stdout. */
-static void save(const void *ip, const struct xt_entry_match *match)
+static void icmp6_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_icmp *icmpv6 = (struct ip6t_icmp *)match->data;
 
@@ -250,28 +244,28 @@ static void save(const void *ip, const s
 	printf(" ");
 }
 
-static void final_check(unsigned int flags)
+static void icmp6_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
 			   "icmpv6 match: You must specify `--icmpv6-type'");
 }
 
-static struct ip6tables_match icmpv6 = {
+static struct ip6tables_match icmp6_match6 = {
 	.name 		= "icmp6",
 	.version 	= IPTABLES_VERSION,
 	.size		= IP6T_ALIGN(sizeof(struct ip6t_icmp)),
 	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_icmp)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts,
+	.help		= icmp6_help,
+	.init		= icmp6_init,
+	.parse		= icmp6_parse,
+	.final_check	= icmp6_check,
+	.print		= icmp6_print,
+	.save		= icmp6_save,
+	.extra_opts	= icmp6_opts,
 };
 
 void _init(void)
 {
-	register_match6(&icmpv6);
+	register_match6(&icmp6_match6);
 }
Index: iptables/extensions/libip6t_ipv6header.c
===================================================================
--- iptables.orig/extensions/libip6t_ipv6header.c
+++ iptables/extensions/libip6t_ipv6header.c
@@ -134,8 +134,7 @@ add_proto_to_mask(int proto){
 	return flag;
 }	
 
-static void
-help(void)
+static void ipv6header_help(void)
 {
 	printf(
 "ipv6header v%s match options:\n"
@@ -148,14 +147,13 @@ help(void)
 	IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option ipv6header_opts[] = {
 	{ "header", 1, NULL, '1' },
 	{ "soft", 0, NULL, '2' },
 	{ }
 };
 
-static void
-init(struct xt_entry_match *m)
+static void ipv6header_init(struct xt_entry_match *m)
 {
 	struct ip6t_ipv6header_info *info = (struct ip6t_ipv6header_info *)m->data;
 
@@ -184,9 +182,8 @@ parse_header(const char *flags) {
 
 /* Parses command options; returns 0 if it ate an option */
 static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+ipv6header_parse(int c, char **argv, int invert, unsigned int *flags,
+                 const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_ipv6header_info *info = (struct ip6t_ipv6header_info *)(*match)->data;
 
@@ -223,8 +220,7 @@ parse(int c, char **argv, int invert, un
 }
 
 /* Checks the flags variable */
-static void
-final_check(unsigned int flags)
+static void ipv6header_check(unsigned int flags)
 {
 	if (!flags) exit_error(PARAMETER_PROBLEM, "ip6t_ipv6header: no options specified");
 }
@@ -252,10 +248,8 @@ print_header(u_int8_t flags){
 }
 
 /* Prints out the match */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
+static void ipv6header_print(const void *ip,
+                             const struct xt_entry_match *match, int numeric)
 {
 	const struct ip6t_ipv6header_info *info = (const struct ip6t_ipv6header_info *)match->data;
 	printf("ipv6header ");
@@ -277,9 +271,7 @@ print(const void *ip,
 }
 
 /* Saves the match */
-static void
-save(const void *ip,
-     const struct xt_entry_match *match)
+static void ipv6header_save(const void *ip, const struct xt_entry_match *match)
 {
 
 	const struct ip6t_ipv6header_info *info = (const struct ip6t_ipv6header_info *)match->data;
@@ -294,22 +286,21 @@ save(const void *ip,
 	return;
 }
 
-static
-struct ip6tables_match ipv6header = {
+static struct ip6tables_match ipv6header_match6 = {
 	.name		= "ipv6header",
 	.version	= IPTABLES_VERSION,
 	.size		= IP6T_ALIGN(sizeof(struct ip6t_ipv6header_info)),
 	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_ipv6header_info)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts,
+	.help		= ipv6header_help,
+	.init		= ipv6header_init,
+	.parse		= ipv6header_parse,
+	.final_check	= ipv6header_check,
+	.print		= ipv6header_print,
+	.save		= ipv6header_save,
+	.extra_opts	= ipv6header_opts,
 };
 
 void _init(void)
 {
-	register_match6(&ipv6header);
+	register_match6(&ipv6header_match6);
 }
Index: iptables/extensions/libip6t_mh.c
===================================================================
--- iptables.orig/extensions/libip6t_mh.c
+++ iptables/extensions/libip6t_mh.c
@@ -58,7 +58,7 @@ static void print_types_all(void)
 	printf("\n");
 }
 
-static void help(void)
+static void mh_help(void)
 {
 	printf(
 "MH v%s options:\n"
@@ -67,7 +67,7 @@ IPTABLES_VERSION);
 	print_types_all();
 }
 
-static void init(struct xt_entry_match *m)
+static void mh_init(struct xt_entry_match *m)
 {
 	struct ip6t_mh *mhinfo = (struct ip6t_mh *)m->data;
 
@@ -125,9 +125,8 @@ static void parse_mh_types(const char *m
 
 #define MH_TYPES 0x01
 
-static int parse(int c, char **argv, int invert, unsigned int *flags,
-		 const void *entry,
-		 struct xt_entry_match **match)
+static int mh_parse(int c, char **argv, int invert, unsigned int *flags,
+                    const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_mh *mhinfo = (struct ip6t_mh *)(*match)->data;
 
@@ -189,9 +188,8 @@ static void print_types(u_int8_t min, u_
 	}
 }
 
-static void print(const void *ip,
-		  const struct xt_entry_match *match,
-		  int numeric)
+static void mh_print(const void *ip, const struct xt_entry_match *match,
+                     int numeric)
 {
 	const struct ip6t_mh *mhinfo = (struct ip6t_mh *)match->data;
 
@@ -204,7 +202,7 @@ static void print(const void *ip,
 		       mhinfo->invflags & ~IP6T_MH_INV_MASK);
 }
 
-static void save(const void *ip, const struct xt_entry_match *match)
+static void mh_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_mh *mhinfo = (struct ip6t_mh *)match->data;
 
@@ -220,25 +218,25 @@ static void save(const void *ip, const s
 		printf("--mh-type %u ", mhinfo->types[0]);
 }
 
-static const struct option opts[] = {
+static const struct option mh_opts[] = {
 	{ "mh-type", 1, NULL, '1' },
 	{ }
 };
 
-static struct ip6tables_match mh = {
+static struct ip6tables_match mh_match6 = {
 	.name		= "mh",
 	.version	= IPTABLES_VERSION,
 	.size		= IP6T_ALIGN(sizeof(struct ip6t_mh)),
 	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_mh)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts,
+	.help		= mh_help,
+	.init		= mh_init,
+	.parse		= mh_parse,
+	.print		= mh_print,
+	.save		= mh_save,
+	.extra_opts	= mh_opts,
 };
 
 void _init(void)
 {
-	register_match6(&mh);
+	register_match6(&mh_match6);
 }
Index: iptables/extensions/libip6t_owner.c
===================================================================
--- iptables.orig/extensions/libip6t_owner.c
+++ iptables/extensions/libip6t_owner.c
@@ -11,8 +11,7 @@
 #include <linux/netfilter_ipv6/ip6t_owner.h>
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void owner_help(void)
 {
 #ifdef IP6T_OWNER_COMM
 	printf(
@@ -36,7 +35,7 @@ IPTABLES_VERSION);
 #endif /* IP6T_OWNER_COMM */
 }
 
-static const struct option opts[] = {
+static const struct option owner_opts[] = {
 	{ "uid-owner", 1, NULL, '1' },
 	{ "gid-owner", 1, NULL, '2' },
 	{ "pid-owner", 1, NULL, '3' },
@@ -49,10 +48,8 @@ static const struct option opts[] = {
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+static int owner_parse(int c, char **argv, int invert, unsigned int *flags,
+                       const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_owner_info *ownerinfo = (struct ip6t_owner_info *)(*match)->data;
 
@@ -188,8 +185,7 @@ print_item(struct ip6t_owner_info *info,
 }
 
 /* Final check; must have specified --own. */
-static void
-final_check(unsigned int flags)
+static void owner_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
@@ -197,10 +193,8 @@ final_check(unsigned int flags)
 }
 
 /* Prints out the matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
+static void owner_print(const void *ip, const struct xt_entry_match *match,
+                        int numeric)
 {
 	struct ip6t_owner_info *info = (struct ip6t_owner_info *)match->data;
 
@@ -214,8 +208,7 @@ print(const void *ip,
 }
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_match *match)
+static void owner_save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ip6t_owner_info *info = (struct ip6t_owner_info *)match->data;
 
@@ -228,20 +221,20 @@ save(const void *ip, const struct xt_ent
 #endif
 }
 
-static struct ip6tables_match owner = {
+static struct ip6tables_match owner_match6 = {
 	.name 		= "owner",
 	.version	= IPTABLES_VERSION,
 	.size		= IP6T_ALIGN(sizeof(struct ip6t_owner_info)),
 	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_owner_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts,
+	.help		= owner_help,
+	.parse		= owner_parse,
+	.final_check	= owner_check,
+	.print		= owner_print,
+	.save		= owner_save,
+	.extra_opts	= owner_opts,
 };
 
 void _init(void)
 {
-	register_match6(&owner);
+	register_match6(&owner_match6);
 }
Index: iptables/extensions/libip6t_policy.c
===================================================================
--- iptables.orig/extensions/libip6t_policy.c
+++ iptables/extensions/libip6t_policy.c
@@ -22,7 +22,7 @@
  */
 static struct ip6t_policy_info *policy_info;
 
-static void help(void)
+static void policy_help(void)
 {
 	printf(
 "policy v%s options:\n"
@@ -41,7 +41,7 @@ static void help(void)
 	IPTABLES_VERSION);
 }
 
-static const struct option opts[] =
+static const struct option policy_opts[] =
 {
 	{
 		.name		= "dir",
@@ -160,9 +160,8 @@ static int parse_mode(char *s)
 	exit_error(PARAMETER_PROBLEM, "policy match: invalid mode `%s'", s);
 }
 
-static int parse(int c, char **argv, int invert, unsigned int *flags,
-                 const void *entry,
-                 struct xt_entry_match **match)
+static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
+                        const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_policy_info *info = (void *)(*match)->data;
 	struct ip6t_policy_elem *e = &info->pol[info->len];
@@ -289,7 +288,7 @@ static int parse(int c, char **argv, int
 	return 1;
 }
 
-static void final_check(unsigned int flags)
+static void policy_check(unsigned int flags)
 {
 	struct ip6t_policy_info *info = policy_info;
 	struct ip6t_policy_elem *e;
@@ -421,9 +420,8 @@ static void print_flags(char *prefix, co
 		printf("%sstrict ", prefix);
 }
 
-static void print(const void *ip,
-                  const struct xt_entry_match *match,
-		  int numeric)
+static void policy_print(const void *ip, const struct xt_entry_match *match,
+                         int numeric)
 {
 	const struct ip6t_policy_info *info = (void *)match->data;
 	unsigned int i;
@@ -439,7 +437,7 @@ static void print(const void *ip,
 	printf("\n");
 }
 
-static void save(const void *ip, const struct xt_entry_match *match)
+static void policy_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_policy_info *info = (void *)match->data;
 	unsigned int i;
@@ -452,20 +450,20 @@ static void save(const void *ip, const s
 	}
 }
 
-static struct ip6tables_match policy = {
+static struct ip6tables_match policy_match6 = {
 	.name		= "policy",
 	.version	= IPTABLES_VERSION,
 	.size		= IP6T_ALIGN(sizeof(struct ip6t_policy_info)),
 	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_policy_info)),
-	.help		= help,
-	.parse		= parse,
-	.final_check	= final_check,
-	.print		= print,
-	.save		= save,
-	.extra_opts	= opts
+	.help		= policy_help,
+	.parse		= policy_parse,
+	.final_check	= policy_check,
+	.print		= policy_print,
+	.save		= policy_save,
+	.extra_opts	= policy_opts,
 };
 
 void _init(void)
 {
-	register_match6(&policy);
+	register_match6(&policy_match6);
 }
Index: iptables/extensions/libip6t_rt.c
===================================================================
--- iptables.orig/extensions/libip6t_rt.c
+++ iptables/extensions/libip6t_rt.c
@@ -15,8 +15,7 @@
 /*#define DEBUG	1*/
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void rt_help(void)
 {
 	printf(
 "RT v%s options:\n"
@@ -29,7 +28,7 @@ help(void)
 IPTABLES_VERSION, IP6T_RT_HOPS);
 }
 
-static const struct option opts[] = {
+static const struct option rt_opts[] = {
 	{ "rt-type", 1, NULL, '1' },
 	{ "rt-segsleft", 1, NULL, '2' },
 	{ "rt-len", 1, NULL, '3' },
@@ -138,8 +137,7 @@ parse_addresses(const char *addrstr, str
 }
 
 /* Initialize the match. */
-static void
-init(struct xt_entry_match *m)
+static void rt_init(struct xt_entry_match *m)
 {
 	struct ip6t_rt *rtinfo = (struct ip6t_rt *)m->data;
 
@@ -154,10 +152,8 @@ init(struct xt_entry_match *m)
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+static int rt_parse(int c, char **argv, int invert, unsigned int *flags,
+                    const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_rt *rtinfo = (struct ip6t_rt *)(*match)->data;
 
@@ -269,9 +265,8 @@ print_addresses(int addrnr, struct in6_a
 }
 
 /* Prints out the union ip6t_matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match, int numeric)
+static void rt_print(const void *ip, const struct xt_entry_match *match,
+                     int numeric)
 {
 	const struct ip6t_rt *rtinfo = (struct ip6t_rt *)match->data;
 
@@ -297,7 +292,7 @@ print(const void *ip,
 }
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void save(const void *ip, const struct xt_entry_match *match)
+static void rt_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_rt *rtinfo = (struct ip6t_rt *)match->data;
 
@@ -334,21 +329,21 @@ static void save(const void *ip, const s
 
 }
 
-static struct ip6tables_match rt = {
+static struct ip6tables_match rt_match6 = {
 	.name		= "rt",
 	.version	= IPTABLES_VERSION,
 	.size		= IP6T_ALIGN(sizeof(struct ip6t_rt)),
 	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_rt)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts,
+	.help		= rt_help,
+	.init		= rt_init,
+	.parse		= rt_parse,
+	.print		= rt_print,
+	.save		= rt_save,
+	.extra_opts	= rt_opts,
 };
 
 void
 _init(void)
 {
-	register_match6(&rt);
+	register_match6(&rt_match6);
 }
Index: iptables/extensions/libip6t_state.c
===================================================================
--- iptables.orig/extensions/libip6t_state.c
+++ iptables/extensions/libip6t_state.c
@@ -13,8 +13,7 @@
 #endif
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void state_help(void)
 {
 	printf(
 "state v%s options:\n"
@@ -23,7 +22,7 @@ help(void)
 "\n", IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option state_opts[] = {
 	{ "state", 1, 0, '1' },
 	{0}
 };
@@ -63,10 +62,8 @@ parse_states(const char *arg, struct ipt
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+static int state_parse(int c, char **argv, int invert, unsigned int *flags,
+                       const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_state_info *sinfo = (struct ipt_state_info *)(*match)->data;
 
@@ -88,7 +85,7 @@ parse(int c, char **argv, int invert, un
 }
 
 /* Final check; must have specified --state. */
-static void final_check(unsigned int flags)
+static void state_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM, "You must specify `--state'");
@@ -122,10 +119,8 @@ static void print_state(unsigned int sta
 }
 
 /* Prints out the matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
+static void state_print(const void *ip, const struct xt_entry_match *match,
+                        int numeric)
 {
 	struct ipt_state_info *sinfo = (struct ipt_state_info *)match->data;
 
@@ -134,7 +129,7 @@ print(const void *ip,
 }
 
 /* Saves the matchinfo in parsable form to stdout. */
-static void save(const void *ip, const struct xt_entry_match *match)
+static void state_save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ipt_state_info *sinfo = (struct ipt_state_info *)match->data;
 
@@ -142,20 +137,20 @@ static void save(const void *ip, const s
 	print_state(sinfo->statemask);
 }
 
-static struct ip6tables_match state = { 
+static struct ip6tables_match state_match6 = {
 	.name		= "state",
 	.version	= IPTABLES_VERSION,
 	.size		= IP6T_ALIGN(sizeof(struct ipt_state_info)),
 	.userspacesize	= IP6T_ALIGN(sizeof(struct ipt_state_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= state_help,
+	.parse		= state_parse,
+	.final_check	= state_check,
+	.print		= state_print,
+	.save		= state_save,
+	.extra_opts	= state_opts,
 };
 
 void _init(void)
 {
-	register_match6(&state);
+	register_match6(&state_match6);
 }
