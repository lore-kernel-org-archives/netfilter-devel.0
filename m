From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 10/13] Unique names 4/6
Date: Thu, 4 Oct 2007 12:13:16 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710041210050.7253@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710041209210.7253@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58037 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201AbXJDKNS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Oct 2007 06:13:18 -0400
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id 5F1C81C0624CB
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Oct 2007 12:13:16 +0200 (CEST)
In-Reply-To: <Pine.LNX.4.64.0710041209210.7253@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Give symbols of libxt targets unique names (2/3).

Adds unique prefixes to all functions (most of them - especially the hook
functions) so that debugging programs can unambiguously map a symbol to an
address. Also unifies the names of the xtables_match/xtables_target structs,
(based upon libxt_connmark.c/libip6t_*.c).

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 extensions/libipt_CLUSTERIP.c  |   39 ++++++++++++------------------
 extensions/libipt_DNAT.c       |   38 ++++++++++++-----------------
 extensions/libipt_ECN.c        |   39 ++++++++++++------------------
 extensions/libipt_LOG.c        |   41 ++++++++++++-------------------
 extensions/libipt_MASQUERADE.c |   37 ++++++++++++----------------
 extensions/libipt_MIRROR.c     |   17 +++++--------
 extensions/libipt_NETMAP.c     |   53 +++++++++++++++++------------------------
 extensions/libipt_REDIRECT.c   |   39 ++++++++++++------------------
 extensions/libipt_REJECT.c     |   38 ++++++++++++-----------------
 extensions/libipt_SAME.c       |   43 +++++++++++++--------------------
 extensions/libipt_SET.c        |   41 +++++++++++++------------------
 extensions/libipt_SNAT.c       |   38 ++++++++++++-----------------
 extensions/libipt_TOS.c        |   39 ++++++++++++------------------
 extensions/libipt_TTL.c        |   34 ++++++++++++--------------
 extensions/libipt_ULOG.c       |   35 ++++++++++++---------------
 15 files changed, 242 insertions(+), 329 deletions(-)

Index: iptables/extensions/libipt_CLUSTERIP.c
===================================================================
--- iptables.orig/extensions/libipt_CLUSTERIP.c
+++ iptables/extensions/libipt_CLUSTERIP.c
@@ -19,8 +19,7 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include "../include/linux/netfilter_ipv4/ipt_CLUSTERIP.h"
 
-static void
-help(void)
+static void CLUSTERIP_help(void)
 {
 	printf(
 "CLUSTERIP target v%s options:\n"
@@ -44,7 +43,7 @@ IPTABLES_VERSION);
 #define PARAM_LOCALNODE	0x0010
 #define PARAM_HASHINIT	0x0020
 
-static const struct option opts[] = {
+static const struct option CLUSTERIP_opts[] = {
 	{ "new", 0, NULL, '1' },
 	{ "hashmode", 1, NULL, '2' },
 	{ "clustermac", 1, NULL, '3' },
@@ -78,10 +77,8 @@ parse_mac(const char *mac, char *macbuf)
 	}
 }
 
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_target **target)
+static int CLUSTERIP_parse(int c, char **argv, int invert, unsigned int *flags,
+                           const void *entry, struct xt_entry_target **target)
 {
 	struct ipt_clusterip_tgt_info *cipinfo
 		= (struct ipt_clusterip_tgt_info *)(*target)->data;
@@ -158,8 +155,7 @@ parse(int c, char **argv, int invert, un
 	return 1;
 }
 
-static void
-final_check(unsigned int flags)
+static void CLUSTERIP_check(unsigned int flags)
 {
 	if (flags == 0)
 		return;
@@ -201,10 +197,8 @@ static char *mac2str(const u_int8_t mac[
 			
 
 /* Prints out the targinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_target *target,
-      int numeric)
+static void CLUSTERIP_print(const void *ip,
+                            const struct xt_entry_target *target, int numeric)
 {
 	const struct ipt_clusterip_tgt_info *cipinfo =
 		(const struct ipt_clusterip_tgt_info *)target->data;
@@ -223,8 +217,7 @@ print(const void *ip,
 }
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_target *target)
+static void CLUSTERIP_save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_clusterip_tgt_info *cipinfo =
 		(const struct ipt_clusterip_tgt_info *)target->data;
@@ -242,20 +235,20 @@ save(const void *ip, const struct xt_ent
 	       cipinfo->hash_initval);
 }
 
-static struct iptables_target clusterip = { 
+static struct iptables_target clusterip_target = {
 	.name		= "CLUSTERIP",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_clusterip_tgt_info)),
 	.userspacesize	= offsetof(struct ipt_clusterip_tgt_info, config),
- 	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+ 	.help		= CLUSTERIP_help,
+	.parse		= CLUSTERIP_parse,
+	.final_check	= CLUSTERIP_check,
+	.print		= CLUSTERIP_print,
+	.save		= CLUSTERIP_save,
+	.extra_opts	= CLUSTERIP_opts,
 };
 
 void _init(void)
 {
-	register_target(&clusterip);
+	register_target(&clusterip_target);
 }
Index: iptables/extensions/libipt_DNAT.c
===================================================================
--- iptables.orig/extensions/libipt_DNAT.c
+++ iptables/extensions/libipt_DNAT.c
@@ -20,8 +20,7 @@ struct ipt_natinfo
 };
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void DNAT_help(void)
 {
 	printf(
 "DNAT v%s options:\n"
@@ -32,7 +31,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option DNAT_opts[] = {
 	{ "to-destination", 1, NULL, '1' },
 	{ "random", 0, NULL, '2' },
 	{ }
@@ -139,10 +138,8 @@ parse_to(char *arg, int portok, struct i
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *e,
-      struct xt_entry_target **target)
+static int DNAT_parse(int c, char **argv, int invert, unsigned int *flags,
+                      const void *e, struct xt_entry_target **target)
 {
 	const struct ipt_entry *entry = e;
 	struct ipt_natinfo *info = (void *)*target;
@@ -187,7 +184,7 @@ parse(int c, char **argv, int invert, un
 }
 
 /* Final check; must have specfied --to-source. */
-static void final_check(unsigned int flags)
+static void DNAT_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
@@ -215,10 +212,8 @@ static void print_range(const struct ip_
 }
 
 /* Prints out the targinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_target *target,
-      int numeric)
+static void DNAT_print(const void *ip, const struct xt_entry_target *target,
+                       int numeric)
 {
 	struct ipt_natinfo *info = (void *)target;
 	unsigned int i = 0;
@@ -233,8 +228,7 @@ print(const void *ip,
 }
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_target *target)
+static void DNAT_save(const void *ip, const struct xt_entry_target *target)
 {
 	struct ipt_natinfo *info = (void *)target;
 	unsigned int i = 0;
@@ -248,20 +242,20 @@ save(const void *ip, const struct xt_ent
 	}
 }
 
-static struct iptables_target dnat = { 
+static struct iptables_target dnat_target = {
 	.name		= "DNAT",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ip_nat_multi_range)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ip_nat_multi_range)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= DNAT_help,
+	.parse		= DNAT_parse,
+	.final_check	= DNAT_check,
+	.print		= DNAT_print,
+	.save		= DNAT_save,
+	.extra_opts	= DNAT_opts,
 };
 
 void _init(void)
 {
-	register_target(&dnat);
+	register_target(&dnat_target);
 }
Index: iptables/extensions/libipt_ECN.c
===================================================================
--- iptables.orig/extensions/libipt_ECN.c
+++ iptables/extensions/libipt_ECN.c
@@ -17,7 +17,7 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_ECN.h>
 
-static void help(void) 
+static void ECN_help(void)
 {
 	printf(
 "ECN target v%s options\n"
@@ -33,7 +33,7 @@ static void help(void) 
 #endif
 
 
-static const struct option opts[] = {
+static const struct option ECN_opts[] = {
 	{ "ecn-tcp-remove", 0, NULL, 'F' },
 	{ "ecn-tcp-cwr", 1, NULL, 'G' },
 	{ "ecn-tcp-ece", 1, NULL, 'H' },
@@ -41,10 +41,8 @@ static const struct option opts[] = {
 	{ }
 };
 
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_target **target)
+static int ECN_parse(int c, char **argv, int invert, unsigned int *flags,
+                     const void *entry, struct xt_entry_target **target)
 {
 	unsigned int result;
 	struct ipt_ECN_info *einfo
@@ -100,8 +98,7 @@ parse(int c, char **argv, int invert, un
 	return 1;
 }
 
-static void
-final_check(unsigned int flags)
+static void ECN_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
@@ -109,10 +106,8 @@ final_check(unsigned int flags)
 }
 
 /* Prints out the targinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_target *target,
-      int numeric)
+static void ECN_print(const void *ip, const struct xt_entry_target *target,
+                      int numeric)
 {
 	const struct ipt_ECN_info *einfo =
 		(const struct ipt_ECN_info *)target->data;
@@ -136,8 +131,7 @@ print(const void *ip,
 }
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_target *target)
+static void ECN_save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_ECN_info *einfo =
 		(const struct ipt_ECN_info *)target->data;
@@ -159,21 +153,20 @@ save(const void *ip, const struct xt_ent
 	}
 }
 
-static
-struct iptables_target ecn = { 
+static struct iptables_target ecn_target = {
 	.name		= "ECN",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_ECN_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_ECN_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= ECN_help,
+	.parse		= ECN_parse,
+	.final_check	= ECN_check,
+	.print		= ECN_print,
+	.save		= ECN_save,
+	.extra_opts	= ECN_opts,
 };
 
 void _init(void)
 {
-	register_target(&ecn);
+	register_target(&ecn_target);
 }
Index: iptables/extensions/libipt_LOG.c
===================================================================
--- iptables.orig/extensions/libipt_LOG.c
+++ iptables/extensions/libipt_LOG.c
@@ -18,8 +18,7 @@
 #endif
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void LOG_help(void)
 {
 	printf(
 "LOG v%s options:\n"
@@ -32,7 +31,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option LOG_opts[] = {
 	{ .name = "log-level",        .has_arg = 1, .val = '!' },
 	{ .name = "log-prefix",       .has_arg = 1, .val = '#' },
 	{ .name = "log-tcp-sequence", .has_arg = 0, .val = '1' },
@@ -43,8 +42,7 @@ static const struct option opts[] = {
 };
 
 /* Initialize the target. */
-static void
-init(struct xt_entry_target *t)
+static void LOG_init(struct xt_entry_target *t)
 {
 	struct ipt_log_info *loginfo = (struct ipt_log_info *)t->data;
 
@@ -108,10 +106,8 @@ parse_level(const char *level)
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_target **target)
+static int LOG_parse(int c, char **argv, int invert, unsigned int *flags,
+                     const void *entry, struct xt_entry_target **target)
 {
 	struct ipt_log_info *loginfo = (struct ipt_log_info *)(*target)->data;
 
@@ -200,10 +196,8 @@ parse(int c, char **argv, int invert, un
 }
 
 /* Prints out the targinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_target *target,
-      int numeric)
+static void LOG_print(const void *ip, const struct xt_entry_target *target,
+                      int numeric)
 {
 	const struct ipt_log_info *loginfo
 		= (const struct ipt_log_info *)target->data;
@@ -241,8 +235,7 @@ print(const void *ip,
 }
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_target *target)
+static void LOG_save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_log_info *loginfo
 		= (const struct ipt_log_info *)target->data;
@@ -263,22 +256,20 @@ save(const void *ip, const struct xt_ent
 		printf("--log-uid ");
 }
 
-static
-struct iptables_target log
-= {
+static struct iptables_target log_target = {
     .name          = "LOG",
     .version       = IPTABLES_VERSION,
     .size          = IPT_ALIGN(sizeof(struct ipt_log_info)),
     .userspacesize = IPT_ALIGN(sizeof(struct ipt_log_info)),
-    .help          = &help,
-    .init          = &init,
-    .parse         = &parse,
-    .print         = &print,
-    .save          = &save,
-    .extra_opts    = opts
+    .help          = LOG_help,
+    .init          = LOG_init,
+    .parse         = LOG_parse,
+    .print         = LOG_print,
+    .save          = LOG_save,
+    .extra_opts    = LOG_opts,
 };
 
 void _init(void)
 {
-	register_target(&log);
+	register_target(&log_target);
 }
Index: iptables/extensions/libipt_MASQUERADE.c
===================================================================
--- iptables.orig/extensions/libipt_MASQUERADE.c
+++ iptables/extensions/libipt_MASQUERADE.c
@@ -9,8 +9,7 @@
 #include <linux/netfilter/nf_nat.h>
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void MASQUERADE_help(void)
 {
 	printf(
 "MASQUERADE v%s options:\n"
@@ -23,15 +22,14 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option MASQUERADE_opts[] = {
 	{ "to-ports", 1, NULL, '1' },
 	{ "random", 0, NULL, '2' },
 	{ }
 };
 
 /* Initialize the target. */
-static void
-init(struct xt_entry_target *t)
+static void MASQUERADE_init(struct xt_entry_target *t)
 {
 	struct ip_nat_multi_range *mr = (struct ip_nat_multi_range *)t->data;
 
@@ -76,10 +74,8 @@ parse_ports(const char *arg, struct ip_n
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *e,
-      struct xt_entry_target **target)
+static int MASQUERADE_parse(int c, char **argv, int invert, unsigned int *flags,
+                            const void *e, struct xt_entry_target **target)
 {
 	const struct ipt_entry *entry = e;
 	int portok;
@@ -117,9 +113,8 @@ parse(int c, char **argv, int invert, un
 
 /* Prints out the targinfo. */
 static void
-print(const void *ip,
-      const struct xt_entry_target *target,
-      int numeric)
+MASQUERADE_print(const void *ip, const struct xt_entry_target *target,
+                 int numeric)
 {
 	struct ip_nat_multi_range *mr
 		= (struct ip_nat_multi_range *)target->data;
@@ -139,7 +134,7 @@ print(const void *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const void *ip, const struct xt_entry_target *target)
+MASQUERADE_save(const void *ip, const struct xt_entry_target *target)
 {
 	struct ip_nat_multi_range *mr
 		= (struct ip_nat_multi_range *)target->data;
@@ -156,20 +151,20 @@ save(const void *ip, const struct xt_ent
 		printf("--random ");
 }
 
-static struct iptables_target masq = {
+static struct iptables_target masquerade_target = {
 	.name		= "MASQUERADE",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ip_nat_multi_range)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ip_nat_multi_range)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= MASQUERADE_help,
+	.init		= MASQUERADE_init,
+	.parse		= MASQUERADE_parse,
+	.print		= MASQUERADE_print,
+	.save		= MASQUERADE_save,
+	.extra_opts	= MASQUERADE_opts,
 };
 
 void _init(void)
 {
-	register_target(&masq);
+	register_target(&masquerade_target);
 }
Index: iptables/extensions/libipt_MIRROR.c
===================================================================
--- iptables.orig/extensions/libipt_MIRROR.c
+++ iptables/extensions/libipt_MIRROR.c
@@ -8,8 +8,7 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void MIRROR_help(void)
 {
 	printf(
 "MIRROR target v%s takes no options\n",
@@ -18,26 +17,24 @@ IPTABLES_VERSION);
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_target **target)
+static int MIRROR_parse(int c, char **argv, int invert, unsigned int *flags,
+                        const void *entry, struct xt_entry_target **target)
 {
 	return 0;
 }
 
-static struct iptables_target mirror = {
+static struct iptables_target mirror_target = {
 	.name		= "MIRROR",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(0),
 	.userspacesize	= IPT_ALIGN(0),
- 	.help		= &help,
- 	.parse		= &parse,
+ 	.help		= MIRROR_help,
+ 	.parse		= MIRROR_parse,
 	.print		= NULL,
 	.save		= NULL,
 };
 
 void _init(void)
 {
-	register_target(&mirror);
+	register_target(&mirror_target);
 }
Index: iptables/extensions/libipt_NETMAP.c
===================================================================
--- iptables.orig/extensions/libipt_NETMAP.c
+++ iptables/extensions/libipt_NETMAP.c
@@ -13,19 +13,18 @@
 
 #define MODULENAME "NETMAP"
 
-static const struct option opts[] = {
+static const struct option NETMAP_opts[] = {
 	{ "to", 1, NULL, '1' },
 	{ }
 };
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void NETMAP_help(void)
 {
 	printf(MODULENAME" v%s options:\n"
 	       "  --%s address[/mask]\n"
 	       "				Network address to map to.\n\n",
-	       IPTABLES_VERSION, opts[0].name);
+	       IPTABLES_VERSION, NETMAP_opts[0].name);
 }
 
 static u_int32_t
@@ -55,8 +54,7 @@ netmask2bits(u_int32_t netmask)
 }
 
 /* Initialize the target. */
-static void
-init(struct xt_entry_target *t)
+static void NETMAP_init(struct xt_entry_target *t)
 {
 	struct ip_nat_multi_range *mr = (struct ip_nat_multi_range *)t->data;
 
@@ -116,10 +114,8 @@ parse_to(char *arg, struct ip_nat_range 
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_target **target)
+static int NETMAP_parse(int c, char **argv, int invert, unsigned int *flags,
+                        const void *entry, struct xt_entry_target **target)
 {
 	struct ip_nat_multi_range *mr
 		= (struct ip_nat_multi_range *)(*target)->data;
@@ -128,7 +124,7 @@ parse(int c, char **argv, int invert, un
 	case '1':
 		if (check_inverse(optarg, &invert, NULL, 0))
 			exit_error(PARAMETER_PROBLEM,
-				   "Unexpected `!' after --%s", opts[0].name);
+				   "Unexpected `!' after --%s", NETMAP_opts[0].name);
 
 		parse_to(optarg, &mr->range[0]);
 		*flags = 1;
@@ -140,18 +136,16 @@ parse(int c, char **argv, int invert, un
 }
 
 /* Final check; need --to */
-static void final_check(unsigned int flags)
+static void NETMAP_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
-			   MODULENAME" needs --%s", opts[0].name);
+			   MODULENAME" needs --%s", NETMAP_opts[0].name);
 }
 
 /* Prints out the targinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_target *target,
-      int numeric)
+static void NETMAP_print(const void *ip, const struct xt_entry_target *target,
+                         int numeric)
 {
 	struct ip_nat_multi_range *mr
 		= (struct ip_nat_multi_range *)target->data;
@@ -170,29 +164,28 @@ print(const void *ip,
 }
 
 /* Saves the targinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_target *target)
+static void NETMAP_save(const void *ip, const struct xt_entry_target *target)
 {
-	printf("--%s ", opts[0].name);
-	print(ip, target, 0);
+	printf("--%s ", NETMAP_opts[0].name);
+	NETMAP_print(ip, target, 0);
 }
 
-static struct iptables_target target_module = {
+static struct iptables_target netmap_target = {
 	.name		= MODULENAME,
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ip_nat_multi_range)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ip_nat_multi_range)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= NETMAP_help,
+	.init		= NETMAP_init,
+	.parse		= NETMAP_parse,
+	.final_check	= NETMAP_check,
+	.print		= NETMAP_print,
+	.save		= NETMAP_save,
+	.extra_opts	= NETMAP_opts,
 };
 
 void _init(void)
 {
-	register_target(&target_module);
+	register_target(&netmap_target);
 }
 
Index: iptables/extensions/libipt_REDIRECT.c
===================================================================
--- iptables.orig/extensions/libipt_REDIRECT.c
+++ iptables/extensions/libipt_REDIRECT.c
@@ -12,8 +12,7 @@
 #define IPT_REDIRECT_OPT_RANDOM	0x02
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void REDIRECT_help(void)
 {
 	printf(
 "REDIRECT v%s options:\n"
@@ -22,15 +21,14 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option REDIRECT_opts[] = {
 	{ "to-ports", 1, NULL, '1' },
 	{ "random", 1, NULL, '2' },
 	{ }
 };
 
 /* Initialize the target. */
-static void
-init(struct xt_entry_target *t)
+static void REDIRECT_init(struct xt_entry_target *t)
 {
 	struct ip_nat_multi_range *mr = (struct ip_nat_multi_range *)t->data;
 
@@ -78,10 +76,8 @@ parse_ports(const char *arg, struct ip_n
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *e,
-      struct xt_entry_target **target)
+static int REDIRECT_parse(int c, char **argv, int invert, unsigned int *flags,
+                          const void *e, struct xt_entry_target **target)
 {
 	const struct ipt_entry *entry = e;
 	struct ip_nat_multi_range *mr
@@ -125,10 +121,8 @@ parse(int c, char **argv, int invert, un
 }
 
 /* Prints out the targinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_target *target,
-      int numeric)
+static void REDIRECT_print(const void *ip, const struct xt_entry_target *target,
+                           int numeric)
 {
 	struct ip_nat_multi_range *mr
 		= (struct ip_nat_multi_range *)target->data;
@@ -146,8 +140,7 @@ print(const void *ip,
 }
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_target *target)
+static void REDIRECT_save(const void *ip, const struct xt_entry_target *target)
 {
 	struct ip_nat_multi_range *mr
 		= (struct ip_nat_multi_range *)target->data;
@@ -164,20 +157,20 @@ save(const void *ip, const struct xt_ent
 	}
 }
 
-static struct iptables_target redir = { 
+static struct iptables_target redirect_target = {
 	.name		= "REDIRECT",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ip_nat_multi_range)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ip_nat_multi_range)),
-	.help		= &help,
-	.init		= &init,
- 	.parse		= &parse,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= REDIRECT_help,
+	.init		= REDIRECT_init,
+ 	.parse		= REDIRECT_parse,
+	.print		= REDIRECT_print,
+	.save		= REDIRECT_save,
+	.extra_opts	= REDIRECT_opts,
 };
 
 void _init(void)
 {
-	register_target(&redir);
+	register_target(&redirect_target);
 }
Index: iptables/extensions/libipt_REJECT.c
===================================================================
--- iptables.orig/extensions/libipt_REJECT.c
+++ iptables/extensions/libipt_REJECT.c
@@ -67,8 +67,7 @@ print_reject_types(void)
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void REJECT_help(void)
 {
 	printf(
 "REJECT options:\n"
@@ -80,14 +79,13 @@ help(void)
 	printf("(*) See man page or read the INCOMPATIBILITES file for compatibility issues.\n");
 }
 
-static const struct option opts[] = {
+static const struct option REJECT_opts[] = {
 	{ "reject-with", 1, NULL, '1' },
 	{ }
 };
 
 /* Allocate and initialize the target. */
-static void
-init(struct xt_entry_target *t)
+static void REJECT_init(struct xt_entry_target *t)
 {
 	struct ipt_reject_info *reject = (struct ipt_reject_info *)t->data;
 
@@ -98,10 +96,8 @@ init(struct xt_entry_target *t)
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_target **target)
+static int REJECT_parse(int c, char **argv, int invert, unsigned int *flags,
+                        const void *entry, struct xt_entry_target **target)
 {
 	struct ipt_reject_info *reject = (struct ipt_reject_info *)(*target)->data;
 	unsigned int limit = sizeof(reject_table)/sizeof(struct reject_names);
@@ -133,10 +129,8 @@ parse(int c, char **argv, int invert, un
 }
 
 /* Prints out ipt_reject_info. */
-static void
-print(const void *ip,
-      const struct xt_entry_target *target,
-      int numeric)
+static void REJECT_print(const void *ip, const struct xt_entry_target *target,
+                         int numeric)
 {
 	const struct ipt_reject_info *reject
 		= (const struct ipt_reject_info *)target->data;
@@ -150,7 +144,7 @@ print(const void *ip,
 }
 
 /* Saves ipt_reject in parsable form to stdout. */
-static void save(const void *ip, const struct xt_entry_target *target)
+static void REJECT_save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_reject_info *reject
 		= (const struct ipt_reject_info *)target->data;
@@ -163,20 +157,20 @@ static void save(const void *ip, const s
 	printf("--reject-with %s ", reject_table[i].name);
 }
 
-static struct iptables_target reject = { 
+static struct iptables_target reject_target = {
 	.name		= "REJECT",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_reject_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_reject_info)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= REJECT_help,
+	.init		= REJECT_init,
+	.parse		= REJECT_parse,
+	.print		= REJECT_print,
+	.save		= REJECT_save,
+	.extra_opts	= REJECT_opts,
 };
 
 void _init(void)
 {
-	register_target(&reject);
+	register_target(&reject_target);
 }
Index: iptables/extensions/libipt_SAME.c
===================================================================
--- iptables.orig/extensions/libipt_SAME.c
+++ iptables/extensions/libipt_SAME.c
@@ -11,8 +11,7 @@
 #include "../include/linux/netfilter_ipv4/ipt_SAME.h"
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void SAME_help(void)
 {
 	printf(
 "SAME v%s options:\n"
@@ -29,7 +28,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option SAME_opts[] = {
 	{ "to", 1, NULL, '1' },
 	{ "nodst", 0, NULL, '2'},
 	{ "random", 0, NULL, '3' },
@@ -37,8 +36,7 @@ static const struct option opts[] = {
 };
 
 /* Initialize the target. */
-static void
-init(struct xt_entry_target *t)
+static void SAME_init(struct xt_entry_target *t)
 {
 	struct ipt_same_info *mr = (struct ipt_same_info *)t->data;
 
@@ -87,10 +85,8 @@ parse_to(char *arg, struct ip_nat_range 
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_target **target)
+static int SAME_parse(int c, char **argv, int invert, unsigned int *flags,
+                      const void *entry, struct xt_entry_target **target)
 {
 	struct ipt_same_info *mr
 		= (struct ipt_same_info *)(*target)->data;
@@ -139,7 +135,7 @@ parse(int c, char **argv, int invert, un
 }
 
 /* Final check; need --to. */
-static void final_check(unsigned int flags)
+static void SAME_check(unsigned int flags)
 {
 	if (!(flags & IPT_SAME_OPT_TO))
 		exit_error(PARAMETER_PROBLEM,
@@ -147,10 +143,8 @@ static void final_check(unsigned int fla
 }
 
 /* Prints out the targinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_target *target,
-      int numeric)
+static void SAME_print(const void *ip, const struct xt_entry_target *target,
+                       int numeric)
 {
 	int count;
 	struct ipt_same_info *mr
@@ -184,8 +178,7 @@ print(const void *ip,
 }
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_target *target)
+static void SAME_save(const void *ip, const struct xt_entry_target *target)
 {
 	int count;
 	struct ipt_same_info *mr
@@ -215,21 +208,21 @@ save(const void *ip, const struct xt_ent
 		printf("--random ");
 }
 
-static struct iptables_target same = {
+static struct iptables_target same_target = {
 	.name		= "SAME",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_same_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_same_info)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= SAME_help,
+	.init		= SAME_init,
+	.parse		= SAME_parse,
+	.final_check	= SAME_check,
+	.print		= SAME_print,
+	.save		= SAME_save,
+	.extra_opts	= SAME_opts,
 };
 
 void _init(void)
 {
-	register_target(&same);
+	register_target(&same_target);
 }
Index: iptables/extensions/libipt_SET.c
===================================================================
--- iptables.orig/extensions/libipt_SET.c
+++ iptables/extensions/libipt_SET.c
@@ -23,7 +23,7 @@
 #include "libipt_set.h"
 
 /* Function which prints out usage message. */
-static void help(void)
+static void SET_help(void)
 {
 	printf("SET v%s options:\n"
 	       " --add-set name flags\n"
@@ -34,14 +34,14 @@ static void help(void)
 	       "\n", IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option SET_opts[] = {
 	{"add-set",   1, 0, '1'},
 	{"del-set",   1, 0, '2'},
 	{0}
 };
 
 /* Initialize the target. */
-static void init(struct xt_entry_target *target)
+static void SET_init(struct xt_entry_target *target)
 {
 	struct ipt_set_info_target *info =
 	    (struct ipt_set_info_target *) target->data;
@@ -83,9 +83,8 @@ parse_target(char **argv, int invert, un
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry, struct xt_entry_target **target)
+static int SET_parse(int c, char **argv, int invert, unsigned int *flags,
+                     const void *entry, struct xt_entry_target **target)
 {
 	struct ipt_set_info_target *myinfo =
 	    (struct ipt_set_info_target *) (*target)->data;
@@ -107,7 +106,7 @@ parse(int c, char **argv, int invert, un
 }
 
 /* Final check; must specify at least one. */
-static void final_check(unsigned int flags)
+static void SET_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
@@ -135,9 +134,8 @@ print_target(const char *prefix, const s
 }
 
 /* Prints out the targinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_target *target, int numeric)
+static void SET_print(const void *ip, const struct xt_entry_target *target,
+                      int numeric)
 {
 	struct ipt_set_info_target *info =
 	    (struct ipt_set_info_target *) target->data;
@@ -147,8 +145,7 @@ print(const void *ip,
 }
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_target *target)
+static void SET_save(const void *ip, const struct xt_entry_target *target)
 {
 	struct ipt_set_info_target *info =
 	    (struct ipt_set_info_target *) target->data;
@@ -157,23 +154,21 @@ save(const void *ip, const struct xt_ent
 	print_target("--del-set", &info->del_set);
 }
 
-static
-struct iptables_target ipt_set_target 
-= {
+static struct iptables_target set_target = {
 	.name		= "SET",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_set_info_target)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_set_info_target)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= SET_help,
+	.init		= SET_init,
+	.parse		= SET_parse,
+	.final_check	= SET_check,
+	.print		= SET_print,
+	.save		= SET_save,
+	.extra_opts	= SET_opts,
 };
 
 void _init(void)
 {
-	register_target(&ipt_set_target);
+	register_target(&set_target);
 }
Index: iptables/extensions/libipt_SNAT.c
===================================================================
--- iptables.orig/extensions/libipt_SNAT.c
+++ iptables/extensions/libipt_SNAT.c
@@ -20,8 +20,7 @@ struct ipt_natinfo
 };
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void SNAT_help(void)
 {
 	printf(
 "SNAT v%s options:\n"
@@ -32,7 +31,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option SNAT_opts[] = {
 	{ "to-source", 1, NULL, '1' },
 	{ "random", 0, NULL, '2' },
 	{ }
@@ -139,10 +138,8 @@ parse_to(char *arg, int portok, struct i
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *e,
-      struct xt_entry_target **target)
+static int SNAT_parse(int c, char **argv, int invert, unsigned int *flags,
+                      const void *e, struct xt_entry_target **target)
 {
 	const struct ipt_entry *entry = e;
 	struct ipt_natinfo *info = (void *)*target;
@@ -189,7 +186,7 @@ parse(int c, char **argv, int invert, un
 }
 
 /* Final check; must have specfied --to-source. */
-static void final_check(unsigned int flags)
+static void SNAT_check(unsigned int flags)
 {
 	if (!(flags & IPT_SNAT_OPT_SOURCE))
 		exit_error(PARAMETER_PROBLEM,
@@ -217,10 +214,8 @@ static void print_range(const struct ip_
 }
 
 /* Prints out the targinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_target *target,
-      int numeric)
+static void SNAT_print(const void *ip, const struct xt_entry_target *target,
+                       int numeric)
 {
 	struct ipt_natinfo *info = (void *)target;
 	unsigned int i = 0;
@@ -235,8 +230,7 @@ print(const void *ip,
 }
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_target *target)
+static void SNAT_save(const void *ip, const struct xt_entry_target *target)
 {
 	struct ipt_natinfo *info = (void *)target;
 	unsigned int i = 0;
@@ -250,20 +244,20 @@ save(const void *ip, const struct xt_ent
 	}
 }
 
-static struct iptables_target snat = {
+static struct iptables_target snat_target = {
 	.name		= "SNAT",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ip_nat_multi_range)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ip_nat_multi_range)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= SNAT_help,
+	.parse		= SNAT_parse,
+	.final_check	= SNAT_check,
+	.print		= SNAT_print,
+	.save		= SNAT_save,
+	.extra_opts	= SNAT_opts,
 };
 
 void _init(void)
 {
-	register_target(&snat);
+	register_target(&snat_target);
 }
Index: iptables/extensions/libipt_TOS.c
===================================================================
--- iptables.orig/extensions/libipt_TOS.c
+++ iptables/extensions/libipt_TOS.c
@@ -28,8 +28,7 @@ struct TOS_value
 };
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void TOS_help(void)
 {
 	unsigned int i;
 
@@ -47,7 +46,7 @@ IPTABLES_VERSION);
 	fputc('\n', stdout);
 }
 
-static const struct option opts[] = {
+static const struct option TOS_opts[] = {
 	{ "set-tos", 1, NULL, '1' },
 	{ }
 };
@@ -78,10 +77,8 @@ parse_tos(const char *s, struct ipt_tos_
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_target **target)
+static int TOS_parse(int c, char **argv, int invert, unsigned int *flags,
+                     const void *entry, struct xt_entry_target **target)
 {
 	struct ipt_tos_target_info *tosinfo
 		= (struct ipt_tos_target_info *)(*target)->data;
@@ -102,8 +99,7 @@ parse(int c, char **argv, int invert, un
 	return 1;
 }
 
-static void
-final_check(unsigned int flags)
+static void TOS_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
@@ -126,10 +122,8 @@ print_tos(u_int8_t tos, int numeric)
 }
 
 /* Prints out the targinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_target *target,
-      int numeric)
+static void TOS_print(const void *ip, const struct xt_entry_target *target,
+                      int numeric)
 {
 	const struct ipt_tos_target_info *tosinfo =
 		(const struct ipt_tos_target_info *)target->data;
@@ -138,8 +132,7 @@ print(const void *ip,
 }
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_target *target)
+static void TOS_save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_tos_target_info *tosinfo =
 		(const struct ipt_tos_target_info *)target->data;
@@ -147,20 +140,20 @@ save(const void *ip, const struct xt_ent
 	printf("--set-tos 0x%02x ", tosinfo->tos);
 }
 
-static struct iptables_target tos = {
+static struct iptables_target tos_target = {
 	.name		= "TOS",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_tos_target_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_tos_target_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= TOS_help,
+	.parse		= TOS_parse,
+	.final_check	= TOS_check,
+	.print		= TOS_print,
+	.save		= TOS_save,
+	.extra_opts	= TOS_opts,
 };
 
 void _init(void)
 {
-	register_target(&tos);
+	register_target(&tos_target);
 }
Index: iptables/extensions/libipt_TTL.c
===================================================================
--- iptables.orig/extensions/libipt_TTL.c
+++ iptables/extensions/libipt_TTL.c
@@ -16,7 +16,7 @@
 
 #define IPT_TTL_USED	1
 
-static void help(void) 
+static void TTL_help(void)
 {
 	printf(
 "TTL target v%s options\n"
@@ -26,9 +26,8 @@ static void help(void) 
 , IPTABLES_VERSION);
 }
 
-static int parse(int c, char **argv, int invert, unsigned int *flags,
-		const void *entry,
-		struct xt_entry_target **target)
+static int TTL_parse(int c, char **argv, int invert, unsigned int *flags,
+                     const void *entry, struct xt_entry_target **target)
 {
 	struct ipt_TTL_info *info = (struct ipt_TTL_info *) (*target)->data;
 	unsigned int value;
@@ -85,15 +84,14 @@ static int parse(int c, char **argv, int
 	return 1;
 }
 
-static void final_check(unsigned int flags)
+static void TTL_check(unsigned int flags)
 {
 	if (!(flags & IPT_TTL_USED))
 		exit_error(PARAMETER_PROBLEM,
 				"TTL: You must specify an action");
 }
 
-static void save(const void *ip,
-		const struct xt_entry_target *target)
+static void TTL_save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_TTL_info *info = 
 		(struct ipt_TTL_info *) target->data;
@@ -113,8 +111,8 @@ static void save(const void *ip,
 	printf("%u ", info->ttl);
 }
 
-static void print(const void *ip,
-		const struct xt_entry_target *target, int numeric)
+static void TTL_print(const void *ip, const struct xt_entry_target *target,
+                      int numeric)
 {
 	const struct ipt_TTL_info *info =
 		(struct ipt_TTL_info *) target->data;
@@ -134,28 +132,28 @@ static void print(const void *ip,
 	printf("%u ", info->ttl);
 }
 
-static const struct option opts[] = {
+static const struct option TTL_opts[] = {
 	{ "ttl-set", 1, NULL, '1' },
 	{ "ttl-dec", 1, NULL, '2' },
 	{ "ttl-inc", 1, NULL, '3' },
 	{ }
 };
 
-static struct iptables_target TTL = {
+static struct iptables_target ttl_target = {
 	.next		= NULL, 
 	.name		= "TTL",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_TTL_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_TTL_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts 
+	.help		= TTL_help,
+	.parse		= TTL_parse,
+	.final_check	= TTL_check,
+	.print		= TTL_print,
+	.save		= TTL_save,
+	.extra_opts	= TTL_opts,
 };
 
 void _init(void)
 {
-	register_target(&TTL);
+	register_target(&ttl_target);
 }
Index: iptables/extensions/libipt_ULOG.c
===================================================================
--- iptables.orig/extensions/libipt_ULOG.c
+++ iptables/extensions/libipt_ULOG.c
@@ -34,7 +34,7 @@ void print_groups(unsigned int gmask)
 }
 
 /* Function which prints out usage message. */
-static void help(void)
+static void ULOG_help(void)
 {
 	printf("ULOG v%s options:\n"
 	       " --ulog-nlgroup nlgroup		NETLINK group used for logging\n"
@@ -44,7 +44,7 @@ static void help(void)
 	       IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option ULOG_opts[] = {
 	{"ulog-nlgroup", 1, NULL, '!'},
 	{"ulog-prefix", 1, NULL, '#'},
 	{"ulog-cprange", 1, NULL, 'A'},
@@ -53,7 +53,7 @@ static const struct option opts[] = {
 };
 
 /* Initialize the target. */
-static void init(struct xt_entry_target *t)
+static void ULOG_init(struct xt_entry_target *t)
 {
 	struct ipt_ulog_info *loginfo = (struct ipt_ulog_info *) t->data;
 
@@ -69,9 +69,8 @@ static void init(struct xt_entry_target 
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int parse(int c, char **argv, int invert, unsigned int *flags,
-		 const void *entry,
-		 struct xt_entry_target **target)
+static int ULOG_parse(int c, char **argv, int invert, unsigned int *flags,
+                      const void *entry, struct xt_entry_target **target)
 {
 	struct ipt_ulog_info *loginfo =
 	    (struct ipt_ulog_info *) (*target)->data;
@@ -151,8 +150,7 @@ static int parse(int c, char **argv, int
 }
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
-static void save(const void *ip,
-		 const struct xt_entry_target *target)
+static void ULOG_save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_ulog_info *loginfo
 	    = (const struct ipt_ulog_info *) target->data;
@@ -172,9 +170,8 @@ static void save(const void *ip,
 }
 
 /* Prints out the targinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_target *target, int numeric)
+static void ULOG_print(const void *ip, const struct xt_entry_target *target,
+                       int numeric)
 {
 	const struct ipt_ulog_info *loginfo
 	    = (const struct ipt_ulog_info *) target->data;
@@ -187,20 +184,20 @@ print(const void *ip,
 	printf("queue_threshold %u ", (unsigned int)loginfo->qthreshold);
 }
 
-static struct iptables_target ulog = {
+static struct iptables_target ulog_target = {
 	.name		= "ULOG",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_ulog_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_ulog_info)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= ULOG_help,
+	.init		= ULOG_init,
+	.parse		= ULOG_parse,
+	.print		= ULOG_print,
+	.save		= ULOG_save,
+	.extra_opts	= ULOG_opts,
 };
 
 void _init(void)
 {
-	register_target(&ulog);
+	register_target(&ulog_target);
 }
