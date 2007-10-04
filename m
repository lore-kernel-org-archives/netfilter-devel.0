From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 09/13] Unique names 3/6
Date: Thu, 4 Oct 2007 12:13:07 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710041210010.7253@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710041209210.7253@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58032 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032AbXJDKNJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Oct 2007 06:13:09 -0400
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id 932D51C0624CB
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Oct 2007 12:13:07 +0200 (CEST)
In-Reply-To: <Pine.LNX.4.64.0710041209210.7253@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Give symbols of libxt matches unique names (2/3).

Adds unique prefixes to all functions (most of them - especially the hook
functions) so that debugging programs can unambiguously map a symbol to an
address. Also unifies the names of the xtables_match/xtables_target structs,
(based upon libxt_connmark.c/libip6t_*.c).

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 extensions/libipt_addrtype.c  |   41 ++++++++++++++++++---------------------
 extensions/libipt_ah.c        |   37 +++++++++++++++--------------------
 extensions/libipt_condition.c |   44 +++++++++++++++---------------------------
 extensions/libipt_conntrack.c |   40 +++++++++++++++-----------------------
 extensions/libipt_ecn.c       |   41 ++++++++++++++++-----------------------
 extensions/libipt_icmp.c      |   38 +++++++++++++++---------------------
 extensions/libipt_iprange.c   |   39 +++++++++++++++----------------------
 extensions/libipt_owner.c     |   39 +++++++++++++++----------------------
 extensions/libipt_policy.c    |   34 +++++++++++++++-----------------
 extensions/libipt_realm.c     |   39 +++++++++++++++----------------------
 extensions/libipt_recent.c    |   44 +++++++++++++++++-------------------------
 extensions/libipt_set.c       |   41 +++++++++++++++++----------------------
 extensions/libipt_tos.c       |   39 +++++++++++++++----------------------
 extensions/libipt_ttl.c       |   35 +++++++++++++++------------------
 extensions/libipt_unclean.c   |   18 ++++++-----------
 15 files changed, 239 insertions(+), 330 deletions(-)

Index: iptables/extensions/libipt_addrtype.c
===================================================================
--- iptables.orig/extensions/libipt_addrtype.c
+++ iptables/extensions/libipt_addrtype.c
@@ -28,7 +28,7 @@ static const char *const rtn_names[] = {
 	NULL
 };
 
-static void help_types(void)
+static void addrtype_help_types(void)
 {
 	int i;
 
@@ -36,7 +36,7 @@ static void help_types(void)
 		printf("                                %s\n", rtn_names[i]);
 }
 
-static void help(void) 
+static void addrtype_help(void)
 {
 	printf(
 "Address type match v%s options:\n"
@@ -45,7 +45,7 @@ static void help(void) 
 "\n"
 "Valid types:           \n"
 , IPTABLES_VERSION);
-	help_types();
+	addrtype_help_types();
 }
 
 static int
@@ -81,9 +81,9 @@ static void parse_types(const char *arg,
 #define IPT_ADDRTYPE_OPT_SRCTYPE	0x1
 #define IPT_ADDRTYPE_OPT_DSTTYPE	0x2
 
-static int parse(int c, char **argv, int invert, unsigned int *flags,
-		const void *entry,
-		struct xt_entry_match **match)
+static int
+addrtype_parse(int c, char **argv, int invert, unsigned int *flags,
+               const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_addrtype_info *info =
 		(struct ipt_addrtype_info *) (*match)->data;
@@ -116,7 +116,7 @@ static int parse(int c, char **argv, int
 	return 1;
 }
 
-static void final_check(unsigned int flags)
+static void addrtype_check(unsigned int flags)
 {
 	if (!(flags & (IPT_ADDRTYPE_OPT_SRCTYPE|IPT_ADDRTYPE_OPT_DSTTYPE)))
 		exit_error(PARAMETER_PROBLEM,
@@ -137,9 +137,8 @@ static void print_types(u_int16_t mask)
 	printf(" ");
 }
 
-static void print(const void *ip,
-		const struct xt_entry_match *match,
-		int numeric)
+static void addrtype_print(const void *ip, const struct xt_entry_match *match,
+                           int numeric)
 {
 	const struct ipt_addrtype_info *info = 
 		(struct ipt_addrtype_info *) match->data;
@@ -159,8 +158,7 @@ static void print(const void *ip,
 	}
 }
 
-static void save(const void *ip,
-		const struct xt_entry_match *match)
+static void addrtype_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_addrtype_info *info =
 		(struct ipt_addrtype_info *) match->data;
@@ -179,28 +177,27 @@ static void save(const void *ip,
 	}
 }
 
-static const struct option opts[] = {
+static const struct option addrtype_opts[] = {
 	{ "src-type", 1, NULL, '1' },
 	{ "dst-type", 1, NULL, '2' },
 	{ }
 };
 
-static
-struct iptables_match addrtype = {
+static struct iptables_match addrtype_match = {
 	.name 		= "addrtype",
 	.version 	= IPTABLES_VERSION,
 	.size 		= IPT_ALIGN(sizeof(struct ipt_addrtype_info)),
 	.userspacesize 	= IPT_ALIGN(sizeof(struct ipt_addrtype_info)),
-	.help 		= &help,
-	.parse 		= &parse,
-	.final_check 	= &final_check,
-	.print 		= &print,
-	.save 		= &save,
-	.extra_opts 	= opts
+	.help 		= addrtype_help,
+	.parse 		= addrtype_parse,
+	.final_check 	= addrtype_check,
+	.print 		= addrtype_print,
+	.save 		= addrtype_save,
+	.extra_opts 	= addrtype_opts,
 };
 
 
 void _init(void) 
 {
-	register_match(&addrtype);
+	register_match(&addrtype_match);
 }
Index: iptables/extensions/libipt_ah.c
===================================================================
--- iptables.orig/extensions/libipt_ah.c
+++ iptables/extensions/libipt_ah.c
@@ -9,8 +9,7 @@
 #include <linux/netfilter_ipv4/ipt_ah.h>
                                         
 /* Function which prints out usage message. */
-static void
-help(void)
+static void ah_help(void)
 {
 	printf(
 "AH v%s options:\n"
@@ -19,7 +18,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option ah_opts[] = {
 	{ "ahspi", 1, NULL, '1' },
 	{ }
 };
@@ -67,8 +66,7 @@ parse_ah_spis(const char *spistring, u_i
 }
 
 /* Initialize the match. */
-static void
-init(struct xt_entry_match *m)
+static void ah_init(struct xt_entry_match *m)
 {
 	struct ipt_ah *ahinfo = (struct ipt_ah *)m->data;
 
@@ -79,10 +77,8 @@ init(struct xt_entry_match *m)
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+static int ah_parse(int c, char **argv, int invert, unsigned int *flags,
+                    const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_ah *ahinfo = (struct ipt_ah *)(*match)->data;
 
@@ -126,9 +122,8 @@ print_spis(const char *name, u_int32_t m
 }
 
 /* Prints out the union ipt_matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match, int numeric)
+static void ah_print(const void *ip, const struct xt_entry_match *match,
+                     int numeric)
 {
 	const struct ipt_ah *ah = (struct ipt_ah *)match->data;
 
@@ -141,7 +136,7 @@ print(const void *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const void *ip, const struct xt_entry_match *match)
+static void ah_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_ah *ahinfo = (struct ipt_ah *)match->data;
 
@@ -161,21 +156,21 @@ static void save(const void *ip, const s
 
 }
 
-static struct iptables_match ah = { 
+static struct iptables_match ah_match = {
 	.name 		= "ah",
 	.version 	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_ah)),
 	.userspacesize 	= IPT_ALIGN(sizeof(struct ipt_ah)),
-	.help 		= &help,
-	.init 		= &init,
-	.parse 		= &parse,
-	.print 		= &print,
-	.save 		= &save,
-	.extra_opts 	= opts
+	.help 		= ah_help,
+	.init 		= ah_init,
+	.parse 		= ah_parse,
+	.print 		= ah_print,
+	.save 		= ah_save,
+	.extra_opts 	= ah_opts,
 };
 
 void
 _init(void)
 {
-	register_match(&ah);
+	register_match(&ah_match);
 }
Index: iptables/extensions/libipt_condition.c
===================================================================
--- iptables.orig/extensions/libipt_condition.c
+++ iptables/extensions/libipt_condition.c
@@ -8,9 +8,7 @@
 #include<linux/netfilter_ipv4/ip_tables.h>
 #include<linux/netfilter_ipv4/ipt_condition.h>
 
-
-static void
-help(void)
+static void condition_help(void)
 {
 	printf("condition match v%s options:\n"
 	       "--condition [!] filename       "
@@ -18,16 +16,13 @@ help(void)
 	       IPTABLES_VERSION);
 }
 
-
-static const struct option opts[] = {
+static const struct option condition_opts[] = {
 	{ .name = "condition", .has_arg = 1, .flag = 0, .val = 'X' },
 	{ .name = 0 }
 };
 
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+static int condition_parse(int c, char **argv, int invert, unsigned int *flags,
+                           const void *entry, struct xt_entry_match **match)
 {
 	struct condition_info *info =
 	    (struct condition_info *) (*match)->data;
@@ -53,19 +48,15 @@ parse(int c, char **argv, int invert, un
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
 	const struct condition_info *info =
 	    (const struct condition_info *) match->data;
@@ -74,9 +65,7 @@ print(const void *ip,
 }
 
 
-static void
-save(const void *ip,
-		 const struct xt_entry_match *match)
+static void condition_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct condition_info *info =
 	    (const struct condition_info *) match->data;
@@ -84,23 +73,22 @@ save(const void *ip,
 	printf("--condition %s\"%s\" ", (info->invert) ? "! " : "", info->name);
 }
 
-
-static struct iptables_match condition = {
+static struct iptables_match condition_match = {
 	.name 		= "condition",
 	.version 	= IPTABLES_VERSION,
 	.size 		= IPT_ALIGN(sizeof(struct condition_info)),
 	.userspacesize 	= IPT_ALIGN(sizeof(struct condition_info)),
-	.help 		= &help,
-	.parse 		= &parse,
-	.final_check	= &final_check,
-	.print 		= &print,
-	.save 		= &save,
-	.extra_opts 	= opts
+	.help 		= condition_help,
+	.parse 		= condition_parse,
+	.final_check	= condition_check,
+	.print 		= condition_print,
+	.save 		= condition_save,
+	.extra_opts 	= condition_opts,
 };
 
 
 void
 _init(void)
 {
-	register_match(&condition);
+	register_match(&condition_match);
 }
Index: iptables/extensions/libipt_conntrack.c
===================================================================
--- iptables.orig/extensions/libipt_conntrack.c
+++ iptables/extensions/libipt_conntrack.c
@@ -18,8 +18,7 @@
 #endif
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void conntrack_help(void)
 {
 	printf(
 "conntrack match v%s options:\n"
@@ -41,9 +40,7 @@ help(void)
 "\n", IPTABLES_VERSION);
 }
 
-
-
-static const struct option opts[] = {
+static const struct option conntrack_opts[] = {
 	{ "ctstate", 1, NULL, '1' },
 	{ "ctproto", 1, NULL, '2' },
 	{ "ctorigsrc", 1, NULL, '3' },
@@ -165,10 +162,8 @@ parse_expires(const char *s, struct ipt_
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
+                           const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_conntrack_info *sinfo = (struct ipt_conntrack_info *)(*match)->data;
 	char *protocol = NULL;
@@ -316,8 +311,7 @@ parse(int c, char **argv, int invert, un
 	return 1;
 }
 
-static void
-final_check(unsigned int flags)
+static void conntrack_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM, "You must specify one or more options");
@@ -489,34 +483,32 @@ matchinfo_print(const void *ip, const st
 }
 
 /* Prints out the matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
+static void conntrack_print(const void *ip, const struct xt_entry_match *match,
+                            int numeric)
 {
 	matchinfo_print(ip, match, numeric, "");
 }
 
 /* Saves the matchinfo in parsable form to stdout. */
-static void save(const void *ip, const struct xt_entry_match *match)
+static void conntrack_save(const void *ip, const struct xt_entry_match *match)
 {
 	matchinfo_print(ip, match, 1, "--");
 }
 
-static struct iptables_match conntrack = { 
+static struct iptables_match conntrack_match = {
 	.name		= "conntrack",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_conntrack_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_conntrack_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= conntrack_help,
+	.parse		= conntrack_parse,
+	.final_check	= conntrack_check,
+	.print		= conntrack_print,
+	.save		= conntrack_save,
+	.extra_opts	= conntrack_opts,
 };
 
 void _init(void)
 {
-	register_match(&conntrack);
+	register_match(&conntrack_match);
 }
Index: iptables/extensions/libipt_ecn.c
===================================================================
--- iptables.orig/extensions/libipt_ecn.c
+++ iptables/extensions/libipt_ecn.c
@@ -16,7 +16,7 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_ecn.h>
 
-static void help(void) 
+static void ecn_help(void)
 {
 	printf(
 "ECN match v%s options\n"
@@ -26,17 +26,15 @@ static void help(void) 
 	IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option ecn_opts[] = {
 	{ .name = "ecn-tcp-cwr", .has_arg = 0, .val = 'F' },
 	{ .name = "ecn-tcp-ece", .has_arg = 0, .val = 'G' },
 	{ .name = "ecn-ip-ect",  .has_arg = 1, .val = 'H' },
 	{ }
 };
 
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+static int ecn_parse(int c, char **argv, int invert, unsigned int *flags,
+                     const void *entry, struct xt_entry_match **match)
 {
 	unsigned int result;
 	struct ipt_ecn_info *einfo
@@ -86,8 +84,7 @@ parse(int c, char **argv, int invert, un
 	return 1;
 }
 
-static void
-final_check(unsigned int flags)
+static void ecn_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
@@ -95,10 +92,8 @@ final_check(unsigned int flags)
 }
 
 /* Prints out the matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
+static void ecn_print(const void *ip, const struct xt_entry_match *match,
+                      int numeric)
 {
 	const struct ipt_ecn_info *einfo =
 		(const struct ipt_ecn_info *)match->data;
@@ -125,8 +120,7 @@ print(const void *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_match *match)
+static void ecn_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_ecn_info *einfo =
 		(const struct ipt_ecn_info *)match->data;
@@ -150,21 +144,20 @@ save(const void *ip, const struct xt_ent
 	}
 }
 
-static
-struct iptables_match ecn
-= { .name          = "ecn",
+static struct iptables_match ecn_match = {
+    .name          = "ecn",
     .version       = IPTABLES_VERSION,
     .size          = IPT_ALIGN(sizeof(struct ipt_ecn_info)),
     .userspacesize = IPT_ALIGN(sizeof(struct ipt_ecn_info)),
-    .help          = &help,
-    .parse         = &parse,
-    .final_check   = &final_check,
-    .print         = &print,
-    .save          = &save,
-    .extra_opts    = opts
+    .help          = ecn_help,
+    .parse         = ecn_parse,
+    .final_check   = ecn_check,
+    .print         = ecn_print,
+    .save          = ecn_save,
+    .extra_opts    = ecn_opts,
 };
 
 void _init(void)
 {
-	register_match(&ecn);
+	register_match(&ecn_match);
 }
Index: iptables/extensions/libipt_icmp.c
===================================================================
--- iptables.orig/extensions/libipt_icmp.c
+++ iptables/extensions/libipt_icmp.c
@@ -98,8 +98,7 @@ print_icmptypes(void)
 }
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void icmp_help(void)
 {
 	printf(
 "ICMP v%s options:\n"
@@ -109,7 +108,7 @@ help(void)
 	print_icmptypes();
 }
 
-static const struct option opts[] = {
+static const struct option icmp_opts[] = {
 	{ "icmp-type", 1, NULL, '1' },
 	{ }
 };
@@ -168,8 +167,7 @@ parse_icmp(const char *icmptype, u_int8_
 }
 
 /* Initialize the match. */
-static void
-init(struct xt_entry_match *m)
+static void icmp_init(struct xt_entry_match *m)
 {
 	struct ipt_icmp *icmpinfo = (struct ipt_icmp *)m->data;
 
@@ -179,10 +177,8 @@ init(struct xt_entry_match *m)
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+static int icmp_parse(int c, char **argv, int invert, unsigned int *flags,
+                      const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_icmp *icmpinfo = (struct ipt_icmp *)(*match)->data;
 
@@ -244,10 +240,8 @@ static void print_icmptype(u_int8_t type
 }
 
 /* Prints out the union ipt_matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
+static void icmp_print(const void *ip, const struct xt_entry_match *match,
+                       int numeric)
 {
 	const struct ipt_icmp *icmp = (struct ipt_icmp *)match->data;
 
@@ -262,7 +256,7 @@ print(const void *ip,
 }
 
 /* Saves the match in parsable form to stdout. */
-static void save(const void *ip, const struct xt_entry_match *match)
+static void icmp_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_icmp *icmp = (struct ipt_icmp *)match->data;
 
@@ -280,20 +274,20 @@ static void save(const void *ip, const s
 	}
 }
 
-static struct iptables_match icmp = { 
+static struct iptables_match icmp_match = {
 	.name		= "icmp",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_icmp)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_icmp)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= icmp_help,
+	.init		= icmp_init,
+	.parse		= icmp_parse,
+	.print		= icmp_print,
+	.save		= icmp_save,
+	.extra_opts	= icmp_opts,
 };
 
 void _init(void)
 {
-	register_match(&icmp);
+	register_match(&icmp_match);
 }
Index: iptables/extensions/libipt_iprange.c
===================================================================
--- iptables.orig/extensions/libipt_iprange.c
+++ iptables/extensions/libipt_iprange.c
@@ -9,8 +9,7 @@
 #include <linux/netfilter_ipv4/ipt_iprange.h>
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void iprange_help(void)
 {
 	printf(
 "iprange match v%s options:\n"
@@ -20,7 +19,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option iprange_opts[] = {
 	{ "src-range", 1, NULL, '1' },
 	{ "dst-range", 1, NULL, '2' },
 	{ }
@@ -54,10 +53,8 @@ parse_iprange(char *arg, struct ipt_ipra
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+static int iprange_parse(int c, char **argv, int invert, unsigned int *flags,
+                         const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_iprange_info *info = (struct ipt_iprange_info *)(*match)->data;
 
@@ -99,8 +96,7 @@ parse(int c, char **argv, int invert, un
 }
 
 /* Final check; must have specified --src-range or --dst-range. */
-static void
-final_check(unsigned int flags)
+static void iprange_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
@@ -120,10 +116,8 @@ print_iprange(const struct ipt_iprange *
 }
 
 /* Prints out the info. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
+static void iprange_print(const void *ip, const struct xt_entry_match *match,
+                          int numeric)
 {
 	struct ipt_iprange_info *info = (struct ipt_iprange_info *)match->data;
 
@@ -142,8 +136,7 @@ print(const void *ip,
 }
 
 /* Saves the union ipt_info in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_match *match)
+static void iprange_save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ipt_iprange_info *info = (struct ipt_iprange_info *)match->data;
 
@@ -163,20 +156,20 @@ save(const void *ip, const struct xt_ent
 	}
 }
 
-static struct iptables_match iprange = { 
+static struct iptables_match iprange_match = {
 	.name		= "iprange",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_iprange_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_iprange_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= iprange_help,
+	.parse		= iprange_parse,
+	.final_check	= iprange_check,
+	.print		= iprange_print,
+	.save		= iprange_save,
+	.extra_opts	= iprange_opts,
 };
 
 void _init(void)
 {
-	register_match(&iprange);
+	register_match(&iprange_match);
 }
Index: iptables/extensions/libipt_owner.c
===================================================================
--- iptables.orig/extensions/libipt_owner.c
+++ iptables/extensions/libipt_owner.c
@@ -11,8 +11,7 @@
 #include <linux/netfilter_ipv4/ipt_owner.h>
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void owner_help(void)
 {
 #ifdef IPT_OWNER_COMM
 	printf(
@@ -38,7 +37,7 @@ IPTABLES_VERSION);
 #endif /* IPT_OWNER_COMM */
 }
 
-static const struct option opts[] = {
+static const struct option owner_opts[] = {
 	{ "uid-owner", 1, NULL, '1' },
 	{ "gid-owner", 1, NULL, '2' },
 	{ "pid-owner", 1, NULL, '3' },
@@ -51,10 +50,8 @@ static const struct option opts[] = {
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+static int owner_parse(int c, char **argv, int invert, unsigned int *flags,
+                       const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_owner_info *ownerinfo = (struct ipt_owner_info *)(*match)->data;
 
@@ -189,8 +186,7 @@ print_item(struct ipt_owner_info *info, 
 }
 
 /* Final check; must have specified --own. */
-static void
-final_check(unsigned int flags)
+static void owner_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
@@ -198,10 +194,8 @@ final_check(unsigned int flags)
 }
 
 /* Prints out the matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
+static void owner_print(const void *ip, const struct xt_entry_match *match,
+                        int numeric)
 {
 	struct ipt_owner_info *info = (struct ipt_owner_info *)match->data;
 
@@ -215,8 +209,7 @@ print(const void *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_match *match)
+static void owner_save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ipt_owner_info *info = (struct ipt_owner_info *)match->data;
 
@@ -229,20 +222,20 @@ save(const void *ip, const struct xt_ent
 #endif
 }
 
-static struct iptables_match owner = { 
+static struct iptables_match owner_match = {
 	.name		= "owner",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_owner_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_owner_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= owner_help,
+	.parse		= owner_parse,
+	.final_check	= owner_check,
+	.print		= owner_print,
+	.save		= owner_save,
+	.extra_opts	= owner_opts,
 };
 
 void _init(void)
 {
-	register_match(&owner);
+	register_match(&owner_match);
 }
Index: iptables/extensions/libipt_policy.c
===================================================================
--- iptables.orig/extensions/libipt_policy.c
+++ iptables/extensions/libipt_policy.c
@@ -21,7 +21,7 @@
  */
 static struct ipt_policy_info *policy_info;
 
-static void help(void)
+static void policy_help(void)
 {
 	printf(
 "policy v%s options:\n"
@@ -40,7 +40,7 @@ static void help(void)
 	IPTABLES_VERSION);
 }
 
-static const struct option opts[] =
+static const struct option policy_opts[] =
 {
 	{
 		.name		= "dir",
@@ -120,9 +120,8 @@ static int parse_mode(char *s)
 	exit_error(PARAMETER_PROBLEM, "policy match: invalid mode `%s'", s);
 }
 
-static int parse(int c, char **argv, int invert, unsigned int *flags,
-                 const void *entry,
-                 struct xt_entry_match **match)
+static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
+                        const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_policy_info *info = (void *)(*match)->data;
 	struct ipt_policy_elem *e = &info->pol[info->len];
@@ -249,7 +248,7 @@ static int parse(int c, char **argv, int
 	return 1;
 }
 
-static void final_check(unsigned int flags)
+static void policy_check(unsigned int flags)
 {
 	struct ipt_policy_info *info = policy_info;
 	struct ipt_policy_elem *e;
@@ -381,9 +380,8 @@ static void print_flags(char *prefix, co
 		printf("%sstrict ", prefix);
 }
 
-static void print(const void *ip,
-                  const struct xt_entry_match *match,
-		  int numeric)
+static void policy_print(const void *ip, const struct xt_entry_match *match,
+                         int numeric)
 {
 	const struct ipt_policy_info *info = (void *)match->data;
 	unsigned int i;
@@ -397,7 +395,7 @@ static void print(const void *ip,
 	}
 }
 
-static void save(const void *ip, const struct xt_entry_match *match)
+static void policy_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_policy_info *info = (void *)match->data;
 	unsigned int i;
@@ -410,20 +408,20 @@ static void save(const void *ip, const s
 	}
 }
 
-static struct iptables_match policy = {
+static struct iptables_match policy_match = {
 	.name		= "policy",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_policy_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_policy_info)),
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
-	register_match(&policy);
+	register_match(&policy_match);
 }
Index: iptables/extensions/libipt_realm.c
===================================================================
--- iptables.orig/extensions/libipt_realm.c
+++ iptables/extensions/libipt_realm.c
@@ -15,8 +15,7 @@
 #include <linux/netfilter_ipv4/ipt_realm.h>
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void realm_help(void)
 {
 	printf(
 "realm v%s options:\n"
@@ -25,7 +24,7 @@ help(void)
 "\n", IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option realm_opts[] = {
 	{ "realm", 1, NULL, '1' },
 	{ }
 };
@@ -154,10 +153,8 @@ static const char *realm_id2name(int id)
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+static int realm_parse(int c, char **argv, int invert, unsigned int *flags,
+                       const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_realm_info *realminfo = (struct ipt_realm_info *)(*match)->data;
 	int id;
@@ -213,10 +210,8 @@ print_realm(unsigned long id, unsigned l
 }
 
 /* Prints out the matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
+static void realm_print(const void *ip, const struct xt_entry_match *match,
+                        int numeric)
 {
 	struct ipt_realm_info *ri = (struct ipt_realm_info *) match->data;
 
@@ -229,8 +224,7 @@ print(const void *ip,
 
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_match *match)
+static void realm_save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ipt_realm_info *ri = (struct ipt_realm_info *) match->data;
 
@@ -242,30 +236,29 @@ save(const void *ip, const struct xt_ent
 }
 
 /* Final check; must have specified --mark. */
-static void
-final_check(unsigned int flags)
+static void realm_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
 			   "realm match: You must specify `--realm'");
 }
 
-static struct iptables_match realm = {
+static struct iptables_match realm_match = {
 	.name		= "realm",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_realm_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_realm_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= realm_help,
+	.parse		= realm_parse,
+	.final_check	= realm_check,
+	.print		= realm_print,
+	.save		= realm_save,
+	.extra_opts	= realm_opts,
 };
 
 void _init(void)
 {
-	register_match(&realm);
+	register_match(&realm_match);
 }
 
 
Index: iptables/extensions/libipt_recent.c
===================================================================
--- iptables.orig/extensions/libipt_recent.c
+++ iptables/extensions/libipt_recent.c
@@ -22,7 +22,7 @@
 #endif /* IPT_RECENT_NAME_LEN */
 
 /* Options for this module */
-static const struct option opts[] = {
+static const struct option recent_opts[] = {
 	{ .name = "set",      .has_arg = 0, .val = 201 }, 
 	{ .name = "rcheck",   .has_arg = 0, .val = 202 }, 
 	{ .name = "update",   .has_arg = 0, .val = 203 },
@@ -37,8 +37,7 @@ static const struct option opts[] = {
 };
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void recent_help(void)
 {
 	printf(
 "recent v%s options:\n"
@@ -67,8 +66,7 @@ IPTABLES_VERSION);
 }
   
 /* Initialize the match. */
-static void
-init(struct xt_entry_match *match)
+static void recent_init(struct xt_entry_match *match)
 {
 	struct ipt_recent_info *info = (struct ipt_recent_info *)(match)->data;
 
@@ -82,10 +80,8 @@ init(struct xt_entry_match *match)
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
+                        const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_recent_info *info = (struct ipt_recent_info *)(*match)->data;
 	switch (c) {
@@ -162,8 +158,7 @@ parse(int c, char **argv, int invert, un
 }
 
 /* Final check; must have specified a specific option. */
-static void
-final_check(unsigned int flags)
+static void recent_check(unsigned int flags)
 {
 
 	if (!flags)
@@ -173,10 +168,8 @@ final_check(unsigned int flags)
 }
 
 /* Prints out the matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
+static void recent_print(const void *ip, const struct xt_entry_match *match,
+                         int numeric)
 {
 	struct ipt_recent_info *info = (struct ipt_recent_info *)match->data;
 
@@ -197,8 +190,7 @@ print(const void *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_match *match)
+static void recent_save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ipt_recent_info *info = (struct ipt_recent_info *)match->data;
 
@@ -218,21 +210,21 @@ save(const void *ip, const struct xt_ent
 }
 
 /* Structure for iptables to use to communicate with module */
-static struct iptables_match recent = { 
+static struct iptables_match recent_match = {
     .name          = "recent",
     .version       = IPTABLES_VERSION,
     .size          = IPT_ALIGN(sizeof(struct ipt_recent_info)),
     .userspacesize = IPT_ALIGN(sizeof(struct ipt_recent_info)),
-    .help          = &help,
-    .init          = &init,
-    .parse         = &parse,
-    .final_check   = &final_check,
-    .print         = &print,
-    .save          = &save,
-    .extra_opts    = opts
+    .help          = recent_help,
+    .init          = recent_init,
+    .parse         = recent_parse,
+    .final_check   = recent_check,
+    .print         = recent_print,
+    .save          = recent_save,
+    .extra_opts    = recent_opts,
 };
 
 void _init(void)
 {
-	register_match(&recent);
+	register_match(&recent_match);
 }
Index: iptables/extensions/libipt_set.c
===================================================================
--- iptables.orig/extensions/libipt_set.c
+++ iptables/extensions/libipt_set.c
@@ -22,7 +22,7 @@
 #include "libipt_set.h"
 
 /* Function which prints out usage message. */
-static void help(void)
+static void set_help(void)
 {
 	printf("set v%s options:\n"
 	       " [!] --set     name flags\n"
@@ -32,13 +32,13 @@ static void help(void)
 	       "\n", IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option set_opts[] = {
 	{"set", 1, 0, '1'},
 	{0}
 };
 
 /* Initialize the match. */
-static void init(struct xt_entry_match *match)
+static void set_init(struct xt_entry_match *match)
 {
 	struct ipt_set_info_match *info = 
 		(struct ipt_set_info_match *) match->data;
@@ -49,10 +49,8 @@ static void init(struct xt_entry_match *
 }
 
 /* Function which parses command options; returns true if it ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+static int set_parse(int c, char **argv, int invert, unsigned int *flags,
+                     const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_set_info_match *myinfo = 
 		(struct ipt_set_info_match *) (*match)->data;
@@ -95,7 +93,7 @@ parse(int c, char **argv, int invert, un
 }
 
 /* Final check; must have specified --set. */
-static void final_check(unsigned int flags)
+static void set_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
@@ -125,9 +123,8 @@ print_match(const char *prefix, const st
 }
 
 /* Prints out the matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match, int numeric)
+static void set_print(const void *ip, const struct xt_entry_match *match,
+                      int numeric)
 {
 	struct ipt_set_info_match *info = 
 		(struct ipt_set_info_match *) match->data;
@@ -136,8 +133,7 @@ print(const void *ip,
 }
 
 /* Saves the matchinfo in parsable form to stdout. */
-static void save(const void *ip,
-		 const struct xt_entry_match *match)
+static void set_save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ipt_set_info_match *info = 
 		(struct ipt_set_info_match *) match->data;
@@ -145,22 +141,21 @@ static void save(const void *ip,
 	print_match("--set", &info->match_set);
 }
 
-static
-struct iptables_match set = {
+static struct iptables_match set_match = {
 	.name		= "set",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_set_info_match)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_set_info_match)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= set_help,
+	.init		= set_init,
+	.parse		= set_parse,
+	.final_check	= set_check,
+	.print		= set_print,
+	.save		= set_save,
+	.extra_opts	= set_opts,
 };
 
 void _init(void)
 {
-	register_match(&set);
+	register_match(&set_match);
 }
Index: iptables/extensions/libipt_tos.c
===================================================================
--- iptables.orig/extensions/libipt_tos.c
+++ iptables/extensions/libipt_tos.c
@@ -23,8 +23,7 @@ struct TOS_value
 };
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void tos_help(void)
 {
 	unsigned int i;
 
@@ -42,7 +41,7 @@ IPTABLES_VERSION);
 	fputc('\n', stdout);
 }
 
-static const struct option opts[] = {
+static const struct option tos_opts[] = {
 	{ "tos", 1, NULL, '1' },
 	{ }
 };
@@ -74,10 +73,8 @@ parse_tos(const char *s, struct ipt_tos_
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+static int tos_parse(int c, char **argv, int invert, unsigned int *flags,
+                     const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_tos_info *tosinfo = (struct ipt_tos_info *)(*match)->data;
 
@@ -117,8 +114,7 @@ print_tos(u_int8_t tos, int numeric)
 }
 
 /* Final check; must have specified --tos. */
-static void
-final_check(unsigned int flags)
+static void tos_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
@@ -126,10 +122,8 @@ final_check(unsigned int flags)
 }
 
 /* Prints out the matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
+static void tos_print(const void *ip, const struct xt_entry_match *match,
+                      int numeric)
 {
 	const struct ipt_tos_info *info = (const struct ipt_tos_info *)match->data;
     
@@ -140,8 +134,7 @@ print(const void *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_match *match)
+static void tos_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_tos_info *info = (const struct ipt_tos_info *)match->data;
     
@@ -151,20 +144,20 @@ save(const void *ip, const struct xt_ent
 	print_tos(info->tos, 0);
 }
 
-static struct iptables_match tos = { 
+static struct iptables_match tos_match = {
 	.name		= "tos",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_tos_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_tos_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= tos_help,
+	.parse		= tos_parse,
+	.final_check	= tos_check,
+	.print		= tos_print,
+	.save		= tos_save,
+	.extra_opts	= tos_opts,
 };
 
 void _init(void)
 {
-	register_match(&tos);
+	register_match(&tos_match);
 }
Index: iptables/extensions/libipt_ttl.c
===================================================================
--- iptables.orig/extensions/libipt_ttl.c
+++ iptables/extensions/libipt_ttl.c
@@ -14,7 +14,7 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_ttl.h>
 
-static void help(void) 
+static void ttl_help(void)
 {
 	printf(
 "TTL match v%s options:\n"
@@ -24,9 +24,8 @@ static void help(void) 
 , IPTABLES_VERSION);
 }
 
-static int parse(int c, char **argv, int invert, unsigned int *flags,
-		const void *entry,
-		struct xt_entry_match **match)
+static int ttl_parse(int c, char **argv, int invert, unsigned int *flags,
+                     const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_ttl_info *info = (struct ipt_ttl_info *) (*match)->data;
 	unsigned int value;
@@ -84,7 +83,7 @@ static int parse(int c, char **argv, int
 	return 1;
 }
 
-static void final_check(unsigned int flags)
+static void ttl_check(unsigned int flags)
 {
 	if (!flags) 
 		exit_error(PARAMETER_PROBLEM,
@@ -92,9 +91,8 @@ static void final_check(unsigned int fla
 			"`--ttl-eq', `--ttl-lt', `--ttl-gt");
 }
 
-static void print(const void *ip,
-		const struct xt_entry_match *match,
-		int numeric)
+static void ttl_print(const void *ip, const struct xt_entry_match *match,
+                      int numeric)
 {
 	const struct ipt_ttl_info *info = 
 		(struct ipt_ttl_info *) match->data;
@@ -117,8 +115,7 @@ static void print(const void *ip,
 	printf("%u ", info->ttl);
 }
 
-static void save(const void *ip,
-		const struct xt_entry_match *match)
+static void ttl_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_ttl_info *info =
 		(struct ipt_ttl_info *) match->data;
@@ -143,7 +140,7 @@ static void save(const void *ip,
 	printf("%u ", info->ttl);
 }
 
-static const struct option opts[] = {
+static const struct option ttl_opts[] = {
 	{ "ttl", 1, NULL, '2' },
 	{ "ttl-eq", 1, NULL, '2'},
 	{ "ttl-lt", 1, NULL, '3'},
@@ -151,21 +148,21 @@ static const struct option opts[] = {
 	{ }
 };
 
-static struct iptables_match ttl = {
+static struct iptables_match ttl_match = {
 	.name		= "ttl",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_ttl_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_ttl_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= ttl_help,
+	.parse		= ttl_parse,
+	.final_check	= ttl_check,
+	.print		= ttl_print,
+	.save		= ttl_save,
+	.extra_opts	= ttl_opts,
 };
 
 
 void _init(void) 
 {
-	register_match(&ttl);
+	register_match(&ttl_match);
 }
Index: iptables/extensions/libipt_unclean.c
===================================================================
--- iptables.orig/extensions/libipt_unclean.c
+++ iptables/extensions/libipt_unclean.c
@@ -5,8 +5,7 @@
 #include <iptables.h>
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void unclean_help(void)
 {
 	printf(
 "unclean v%s takes no options\n"
@@ -15,25 +14,22 @@ help(void)
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_match **match)
+static int unclean_parse(int c, char **argv, int invert, unsigned int *flags,
+                         const void *entry, struct xt_entry_match **match)
 {
 	return 0;
 }
 
-static
-struct iptables_match unclean = { 
+static struct iptables_match unclean_match = {
 	.name		= "unclean",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(0),
 	.userspacesize	= IPT_ALIGN(0),
-	.help		= &help,
-	.parse		= &parse,
+	.help		= unclean_help,
+	.parse		= unclean_parse,
 };
 
 void _init(void)
 {
-	register_match(&unclean);
+	register_match(&unclean_match);
 }
