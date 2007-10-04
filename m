From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 12/13] Unique symbols 6/6
Date: Thu, 4 Oct 2007 12:13:41 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710041210120.7253@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710041209210.7253@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58040 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429AbXJDKNm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Oct 2007 06:13:42 -0400
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id 6CB591C0624CB
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Oct 2007 12:13:41 +0200 (CEST)
In-Reply-To: <Pine.LNX.4.64.0710041209210.7253@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Give symbols of libxt targets unique names (3/3).

Adds unique prefixes to all functions (most of them - especially the hook
functions) so that debugging programs can unambiguously map a symbol to an
address. Also unifies the names of the xtables_match/xtables_target structs,
(based upon libxt_connmark.c/libip6t_*.c).

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 extensions/libip6t_HL.c     |   35 ++++++++++++++++-------------------
 extensions/libip6t_LOG.c    |   41 ++++++++++++++++-------------------------
 extensions/libip6t_REJECT.c |   39 ++++++++++++++++-----------------------
 3 files changed, 48 insertions(+), 67 deletions(-)

Index: iptables/extensions/libip6t_HL.c
===================================================================
--- iptables.orig/extensions/libip6t_HL.c
+++ iptables/extensions/libip6t_HL.c
@@ -16,7 +16,7 @@
 
 #define IP6T_HL_USED	1
 
-static void help(void) 
+static void HL_help(void)
 {
 	printf(
 "HL target v%s options\n"
@@ -26,9 +26,8 @@ static void help(void) 
 , IPTABLES_VERSION);
 }
 
-static int parse(int c, char **argv, int invert, unsigned int *flags,
-		const void *entry,
-		struct xt_entry_target **target)
+static int HL_parse(int c, char **argv, int invert, unsigned int *flags,
+                    const void *entry, struct xt_entry_target **target)
 {
 	struct ip6t_HL_info *info = (struct ip6t_HL_info *) (*target)->data;
 	unsigned int value;
@@ -85,15 +84,14 @@ static int parse(int c, char **argv, int
 	return 1;
 }
 
-static void final_check(unsigned int flags)
+static void HL_check(unsigned int flags)
 {
 	if (!(flags & IP6T_HL_USED))
 		exit_error(PARAMETER_PROBLEM,
 				"HL: You must specify an action");
 }
 
-static void save(const void *ip,
-		const struct xt_entry_target *target)
+static void HL_save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ip6t_HL_info *info = 
 		(struct ip6t_HL_info *) target->data;
@@ -113,8 +111,8 @@ static void save(const void *ip,
 	printf("%u ", info->hop_limit);
 }
 
-static void print(const void *ip,
-		const struct xt_entry_target *target, int numeric)
+static void HL_print(const void *ip, const struct xt_entry_target *target,
+                     int numeric)
 {
 	const struct ip6t_HL_info *info =
 		(struct ip6t_HL_info *) target->data;
@@ -134,28 +132,27 @@ static void print(const void *ip,
 	printf("%u ", info->hop_limit);
 }
 
-static const struct option opts[] = {
+static const struct option HL_opts[] = {
 	{ "hl-set", 1, NULL, '1' },
 	{ "hl-dec", 1, NULL, '2' },
 	{ "hl-inc", 1, NULL, '3' },
 	{ }
 };
 
-static
-struct ip6tables_target HL = {
+static struct ip6tables_target hl_target6 = {
 	.name 		= "HL",
 	.version	= IPTABLES_VERSION,
 	.size		= IP6T_ALIGN(sizeof(struct ip6t_HL_info)),
 	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_HL_info)),
-	.help		= &help, 
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts 
+	.help		= HL_help,
+	.parse		= HL_parse,
+	.final_check	= HL_check,
+	.print		= HL_print,
+	.save		= HL_save,
+	.extra_opts	= HL_opts,
 };
 
 void _init(void)
 {
-	register_target6(&HL);
+	register_target6(&hl_target6);
 }
Index: iptables/extensions/libip6t_LOG.c
===================================================================
--- iptables.orig/extensions/libip6t_LOG.c
+++ iptables/extensions/libip6t_LOG.c
@@ -18,8 +18,7 @@
 #define LOG_DEFAULT_LEVEL LOG_WARNING
 
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
 	struct ip6t_log_info *loginfo = (struct ip6t_log_info *)t->data;
 
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
 	struct ip6t_log_info *loginfo = (struct ip6t_log_info *)(*target)->data;
 
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
 	const struct ip6t_log_info *loginfo
 		= (const struct ip6t_log_info *)target->data;
@@ -241,8 +235,7 @@ print(const void *ip,
 }
 
 /* Saves the union ip6t_targinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_target *target)
+static void LOG_save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ip6t_log_info *loginfo
 		= (const struct ip6t_log_info *)target->data;
@@ -263,22 +256,20 @@ save(const void *ip, const struct xt_ent
 		printf("--log-uid ");
 }
 
-static
-struct ip6tables_target log
-= {
+static struct ip6tables_target log_target6 = {
     .name          = "LOG",
     .version       = IPTABLES_VERSION,
     .size          = IP6T_ALIGN(sizeof(struct ip6t_log_info)),
     .userspacesize = IP6T_ALIGN(sizeof(struct ip6t_log_info)),
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
-	register_target6(&log);
+	register_target6(&log_target6);
 }
Index: iptables/extensions/libip6t_REJECT.c
===================================================================
--- iptables.orig/extensions/libip6t_REJECT.c
+++ iptables/extensions/libip6t_REJECT.c
@@ -54,8 +54,7 @@ print_reject_types(void)
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void REJECT_help(void)
 {
 	printf(
 "REJECT options:\n"
@@ -65,14 +64,13 @@ help(void)
 	print_reject_types();
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
 	struct ip6t_reject_info *reject = (struct ip6t_reject_info *)t->data;
 
@@ -83,10 +81,8 @@ init(struct xt_entry_target *t)
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_target **target)
+static int REJECT_parse(int c, char **argv, int invert, unsigned int *flags,
+                        const void *entry, struct xt_entry_target **target)
 {
 	struct ip6t_reject_info *reject = 
 		(struct ip6t_reject_info *)(*target)->data;
@@ -114,10 +110,8 @@ parse(int c, char **argv, int invert, un
 }
 
 /* Prints out ipt_reject_info. */
-static void
-print(const void *ip,
-      const struct xt_entry_target *target,
-      int numeric)
+static void REJECT_print(const void *ip, const struct xt_entry_target *target,
+                         int numeric)
 {
 	const struct ip6t_reject_info *reject
 		= (const struct ip6t_reject_info *)target->data;
@@ -131,8 +125,7 @@ print(const void *ip,
 }
 
 /* Saves ipt_reject in parsable form to stdout. */
-static void save(const void *ip,
-		 const struct xt_entry_target *target)
+static void REJECT_save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ip6t_reject_info *reject
 		= (const struct ip6t_reject_info *)target->data;
@@ -145,20 +138,20 @@ static void save(const void *ip,
 	printf("--reject-with %s ", reject_table[i].name);
 }
 
-static struct ip6tables_target reject = {
+static struct ip6tables_target reject_target6 = {
 	.name = "REJECT",
 	.version	= IPTABLES_VERSION,
 	.size 		= IP6T_ALIGN(sizeof(struct ip6t_reject_info)),
 	.userspacesize 	= IP6T_ALIGN(sizeof(struct ip6t_reject_info)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts,
+	.help		= REJECT_help,
+	.init		= REJECT_init,
+	.parse		= REJECT_parse,
+	.print		= REJECT_print,
+	.save		= REJECT_save,
+	.extra_opts	= REJECT_opts,
 };
 
 void _init(void)
 {
-	register_target6(&reject);
+	register_target6(&reject_target6);
 }
