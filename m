From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [05/10] [IPTABLES]: xt_hashlimit revision 1
Date: Fri, 1 Feb 2008 01:28:58 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802010128480.4864@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801312315120.4864@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38767 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbYBAA3A (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jan 2008 19:29:00 -0500
In-Reply-To: <Pine.LNX.4.64.0801312315120.4864@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support for xt_hashlimit match revision 1

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 extensions/libxt_hashlimit.c           |  398 ++++++++++++++++++++++++++++++---
 extensions/libxt_hashlimit.man         |   80 ++++--
 include/linux/netfilter/xt_hashlimit.h |   38 ++-
 3 files changed, 455 insertions(+), 61 deletions(-)

Index: iptables/extensions/libxt_hashlimit.c
===================================================================
--- iptables.orig/extensions/libxt_hashlimit.c
+++ iptables/extensions/libxt_hashlimit.c
@@ -10,7 +10,7 @@
  * 
  * Error corections by nmalykh@bilim.com (22.01.2005)
  */
-
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -45,6 +45,27 @@ static void hashlimit_help(void)
 "\n", IPTABLES_VERSION, XT_HASHLIMIT_BURST);
 }
 
+static void hashlimit_mt_help(void)
+{
+	printf(
+"hashlimit match options:\n"
+"  --hashlimit-upto <avg>           max average match rate\n"
+"                                   [Packets per second unless followed by \n"
+"                                   /sec /minute /hour /day postfixes]\n"
+"  --hashlimit-above <avg>          min average match rate\n"
+"  --hashlimit-mode <mode>          mode is a comma-separated list of\n"
+"                                   dstip,srcip,dstport,srcport (or none)\n"
+"  --hashlimit-srcmask <length>     source address grouping prefix length\n"
+"  --hashlimit-dstmask <length>     destination address grouping prefix length\n"
+"  --hashlimit-name <name>          name for /proc/net/ipt_hashlimit\n"
+"  --hashlimit-burst <num>	    number to match in a burst, default %u\n"
+"  --hashlimit-htable-size <num>    number of hashtable buckets\n"
+"  --hashlimit-htable-max <num>     number of hashtable entries\n"
+"  --hashlimit-htable-gcinterval    interval between garbage collection runs\n"
+"  --hashlimit-htable-expire        after which time are idle entries expired?\n"
+"\n", XT_HASHLIMIT_BURST);
+}
+
 static const struct option hashlimit_opts[] = {
 	{ "hashlimit", 1, NULL, '%' },
 	{ "hashlimit-burst", 1, NULL, '$' },
@@ -57,6 +78,22 @@ static const struct option hashlimit_opt
 	{},
 };
 
+static const struct option hashlimit_mt_opts[] = {
+	{.name = "hashlimit-upto",              .has_arg = true, .val = '%'},
+	{.name = "hashlimit-above",             .has_arg = true, .val = '^'},
+	{.name = "hashlimit",                   .has_arg = true, .val = '%'},
+	{.name = "hashlimit-srcmask",           .has_arg = true, .val = '<'},
+	{.name = "hashlimit-dstmask",           .has_arg = true, .val = '>'},
+	{.name = "hashlimit-burst",             .has_arg = true, .val = '$'},
+	{.name = "hashlimit-htable-size",       .has_arg = true, .val = '&'},
+	{.name = "hashlimit-htable-max",        .has_arg = true, .val = '*'},
+	{.name = "hashlimit-htable-gcinterval", .has_arg = true, .val = '('},
+	{.name = "hashlimit-htable-expire",     .has_arg = true, .val = ')'},
+	{.name = "hashlimit-mode",              .has_arg = true, .val = '_'},
+	{.name = "hashlimit-name",              .has_arg = true, .val = '"'},
+	{},
+};
+
 static
 int parse_rate(const char *rate, u_int32_t *val)
 {
@@ -98,15 +135,39 @@ static void hashlimit_init(struct xt_ent
 {
 	struct xt_hashlimit_info *r = (struct xt_hashlimit_info *)m->data;
 
+	r->cfg.mode = 0;
 	r->cfg.burst = XT_HASHLIMIT_BURST;
 	r->cfg.gc_interval = XT_HASHLIMIT_GCINTERVAL;
 	r->cfg.expire = XT_HASHLIMIT_EXPIRE;
 
 }
 
+static void hashlimit_mt4_init(struct xt_entry_match *match)
+{
+	struct xt_hashlimit_mtinfo1 *info = (void *)match->data;
+
+	info->cfg.mode        = 0;
+	info->cfg.burst       = XT_HASHLIMIT_BURST;
+	info->cfg.gc_interval = XT_HASHLIMIT_GCINTERVAL;
+	info->cfg.expire      = XT_HASHLIMIT_EXPIRE;
+	info->cfg.srcmask     = 32;
+	info->cfg.dstmask     = 32;
+}
+
+static void hashlimit_mt6_init(struct xt_entry_match *match)
+{
+	struct xt_hashlimit_mtinfo1 *info = (void *)match->data;
+
+	info->cfg.mode        = 0;
+	info->cfg.burst       = XT_HASHLIMIT_BURST;
+	info->cfg.gc_interval = XT_HASHLIMIT_GCINTERVAL;
+	info->cfg.expire      = XT_HASHLIMIT_EXPIRE;
+	info->cfg.srcmask     = 128;
+	info->cfg.dstmask     = 128;
+}
 
 /* Parse a 'mode' parameter into the required bitmask */
-static int parse_mode(struct xt_hashlimit_info *r, char *option_arg)
+static int parse_mode(uint32_t *mode, char *option_arg)
 {
 	char *tok;
 	char *arg = strdup(option_arg);
@@ -114,19 +175,17 @@ static int parse_mode(struct xt_hashlimi
 	if (!arg)
 		return -1;
 
-	r->cfg.mode = 0;
-
 	for (tok = strtok(arg, ",|");
 	     tok;
 	     tok = strtok(NULL, ",|")) {
 		if (!strcmp(tok, "dstip"))
-			r->cfg.mode |= XT_HASHLIMIT_HASH_DIP;
+			*mode |= XT_HASHLIMIT_HASH_DIP;
 		else if (!strcmp(tok, "srcip"))
-			r->cfg.mode |= XT_HASHLIMIT_HASH_SIP;
+			*mode |= XT_HASHLIMIT_HASH_SIP;
 		else if (!strcmp(tok, "srcport"))
-			r->cfg.mode |= XT_HASHLIMIT_HASH_SPT;
+			*mode |= XT_HASHLIMIT_HASH_SPT;
 		else if (!strcmp(tok, "dstport"))
-			r->cfg.mode |= XT_HASHLIMIT_HASH_DPT;
+			*mode |= XT_HASHLIMIT_HASH_DPT;
 		else {
 			free(arg);
 			return -1;
@@ -136,14 +195,18 @@ static int parse_mode(struct xt_hashlimi
 	return 0;
 }
 
-#define PARAM_LIMIT		0x00000001
-#define PARAM_BURST		0x00000002
-#define PARAM_MODE		0x00000004
-#define PARAM_NAME		0x00000008
-#define PARAM_SIZE		0x00000010
-#define PARAM_MAX		0x00000020
-#define PARAM_GCINTERVAL	0x00000040
-#define PARAM_EXPIRE		0x00000080
+enum {
+	PARAM_LIMIT      = 1 << 0,
+	PARAM_BURST      = 1 << 1,
+	PARAM_MODE       = 1 << 2,
+	PARAM_NAME       = 1 << 3,
+	PARAM_SIZE       = 1 << 4,
+	PARAM_MAX        = 1 << 5,
+	PARAM_GCINTERVAL = 1 << 6,
+	PARAM_EXPIRE     = 1 << 7,
+	PARAM_SRCMASK    = 1 << 8,
+	PARAM_DSTMASK    = 1 << 9,
+};
 
 /* Function which parses command options; returns true if it
    ate an option */
@@ -224,7 +287,7 @@ hashlimit_parse(int c, char **argv, int 
 		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-mode",
 		          *flags & PARAM_MODE);
 		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
-		if (parse_mode(r, optarg) < 0)
+		if (parse_mode(&r->cfg.mode, optarg) < 0)
 			exit_error(PARAMETER_PROBLEM, 
 				   "bad --hashlimit-mode: `%s'\n", optarg);
 		*flags |= PARAM_MODE;
@@ -249,6 +312,146 @@ hashlimit_parse(int c, char **argv, int 
 	return 1;
 }
 
+static int
+hashlimit_mt_parse(struct xt_hashlimit_mtinfo1 *info, unsigned int *flags,
+                   int c, int invert, unsigned int maxmask)
+{
+	unsigned int num;
+
+	switch(c) {
+	case '%': /* --hashlimit / --hashlimit-below */
+		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-upto",
+		          *flags & PARAM_LIMIT);
+		if (invert)
+			info->cfg.mode |= XT_HASHLIMIT_INVERT;
+		if (!parse_rate(optarg, &info->cfg.avg))
+			param_act(P_BAD_VALUE, "hashlimit",
+			          "--hashlimit-upto", optarg);
+		*flags |= PARAM_LIMIT;
+		return true;
+
+	case '^': /* --hashlimit-above == !--hashlimit-below */
+		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-above",
+		          *flags & PARAM_LIMIT);
+		if (!invert)
+			info->cfg.mode |= XT_HASHLIMIT_INVERT;
+		if (!parse_rate(optarg, &info->cfg.avg))
+			param_act(P_BAD_VALUE, "hashlimit",
+			          "--hashlimit-above", optarg);
+		*flags |= PARAM_LIMIT;
+		return true;
+
+	case '$': /* --hashlimit-burst */
+		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-burst",
+		          *flags & PARAM_BURST);
+		if (!strtonum(optarg, NULL, &num, 0, 10000))
+			param_act(P_BAD_VALUE, "hashlimit",
+			          "--hashlimit-burst", optarg);
+		info->cfg.burst = num;
+		*flags |= PARAM_BURST;
+		return true;
+
+	case '&': /* --hashlimit-htable-size */
+		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-htable-size",
+		          *flags & PARAM_SIZE);
+		if (!strtonum(optarg, NULL, &num, 0, 0xffffffff))
+			param_act(P_BAD_VALUE, "hashlimit",
+			          "--hashlimit-htable-size", optarg);
+		info->cfg.size = num;
+		*flags |= PARAM_SIZE;
+		return true;
+
+	case '*': /* --hashlimit-htable-max */
+		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-htable-max",
+		          *flags & PARAM_MAX);
+		if (!strtonum(optarg, NULL, &num, 0, 0xffffffff))
+			param_act(P_BAD_VALUE, "hashlimit",
+			          "--hashlimit-htable-max", optarg);
+		info->cfg.max = num;
+		*flags |= PARAM_MAX;
+		return true;
+
+	case '(': /* --hashlimit-htable-gcinterval */
+		param_act(P_ONLY_ONCE, "hashlimit",
+		          "--hashlimit-htable-gcinterval",
+		          *flags & PARAM_GCINTERVAL);
+		if (!strtonum(optarg, NULL, &num, 0, 0xffffffff))
+			param_act(P_BAD_VALUE, "hashlimit",
+			          "--hashlimit-htable-gcinterval", optarg);
+		/* FIXME: not HZ dependent!! */
+		info->cfg.gc_interval = num;
+		*flags |= PARAM_GCINTERVAL;
+		return true;
+
+	case ')': /* --hashlimit-htable-expire */
+		param_act(P_ONLY_ONCE, "hashlimit",
+		          "--hashlimit-htable-expire", *flags & PARAM_EXPIRE);
+		if (!strtonum(optarg, NULL, &num, 0, 0xffffffff))
+			param_act(P_BAD_VALUE, "hashlimit",
+			          "--hashlimit-htable-expire", optarg);
+		/* FIXME: not HZ dependent */
+		info->cfg.expire = num;
+		*flags |= PARAM_EXPIRE;
+		return true;
+
+	case '_':
+		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-mode",
+		          *flags & PARAM_MODE);
+		if (parse_mode(&info->cfg.mode, optarg) < 0)
+			param_act(P_BAD_VALUE, "hashlimit",
+			          "--hashlimit-mode", optarg);
+		*flags |= PARAM_MODE;
+		return true;
+
+	case '"': /* --hashlimit-name */
+		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-name",
+		          *flags & PARAM_NAME);
+		if (strlen(optarg) == 0)
+			exit_error(PARAMETER_PROBLEM, "Zero-length name?");
+		strncpy(info->name, optarg, sizeof(info->name));
+		info->name[sizeof(info->name)-1] = '\0';
+		*flags |= PARAM_NAME;
+		return true;
+
+	case '<': /* --hashlimit-srcmask */
+		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-srcmask",
+		          *flags & PARAM_SRCMASK);
+		if (!strtonum(optarg, NULL, &num, 0, maxmask))
+			param_act(P_BAD_VALUE, "hashlimit",
+			          "--hashlimit-srcmask", optarg);
+		info->cfg.srcmask = num;
+		*flags |= PARAM_SRCMASK;
+		return true;
+
+	case '>': /* --hashlimit-dstmask */
+		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-dstmask",
+		          *flags & PARAM_DSTMASK);
+		if (!strtonum(optarg, NULL, &num, 0, maxmask))
+			param_act(P_BAD_VALUE, "hashlimit",
+			          "--hashlimit-dstmask", optarg);
+		info->cfg.dstmask = num;
+		*flags |= PARAM_DSTMASK;
+		return true;
+	}
+	return false;
+}
+
+static int
+hashlimit_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
+                    const void *entry, struct xt_entry_match **match)
+{
+	return hashlimit_mt_parse((void *)(*match)->data,
+	       flags, c, invert, 32);
+}
+
+static int
+hashlimit_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
+                    const void *entry, struct xt_entry_match **match)
+{
+	return hashlimit_mt_parse((void *)(*match)->data,
+	       flags, c, invert, 128);
+}
+
 /* Final check; nothing. */
 static void hashlimit_check(unsigned int flags)
 {
@@ -263,6 +466,16 @@ static void hashlimit_check(unsigned int
 				"You have to specify --hashlimit-name");
 }
 
+static void hashlimit_mt_check(unsigned int flags)
+{
+	if (!(flags & PARAM_LIMIT))
+		exit_error(PARAMETER_PROBLEM, "You have to specify "
+		           "--hashlimit-upto or --hashlimit-above");
+	if (!(flags & PARAM_NAME))
+		exit_error(PARAMETER_PROBLEM,
+		           "You have to specify --hashlimit-name");
+}
+
 static const struct rates
 {
 	const char *name;
@@ -285,29 +498,27 @@ static void print_rate(u_int32_t period)
 	printf("%u/%s ", rates[i-1].mult / period, rates[i-1].name);
 }
 
-static void print_mode(const struct xt_hashlimit_info *r, char separator)
+static void print_mode(unsigned int mode, char separator)
 {
-	int prevmode = 0;
+	bool prevmode = false;
 
-	if (r->cfg.mode & XT_HASHLIMIT_HASH_SIP) {
-		if (prevmode)
-			putchar(separator);
+	if (mode & XT_HASHLIMIT_HASH_SIP) {
 		fputs("srcip", stdout);
 		prevmode = 1;
 	}
-	if (r->cfg.mode & XT_HASHLIMIT_HASH_SPT) {
+	if (mode & XT_HASHLIMIT_HASH_SPT) {
 		if (prevmode)
 			putchar(separator);
 		fputs("srcport", stdout);
 		prevmode = 1;
 	}
-	if (r->cfg.mode & XT_HASHLIMIT_HASH_DIP) {
+	if (mode & XT_HASHLIMIT_HASH_DIP) {
 		if (prevmode)
 			putchar(separator);
 		fputs("dstip", stdout);
 		prevmode = 1;
 	}
-	if (r->cfg.mode & XT_HASHLIMIT_HASH_DPT) {
+	if (mode & XT_HASHLIMIT_HASH_DPT) {
 		if (prevmode)
 			putchar(separator);
 		fputs("dstport", stdout);
@@ -324,7 +535,7 @@ static void hashlimit_print(const void *
 	fputs("limit: avg ", stdout); print_rate(r->cfg.avg);
 	printf("burst %u ", r->cfg.burst);
 	fputs("mode ", stdout);
-	print_mode(r, '-');
+	print_mode(r->cfg.mode, '-');
 	if (r->cfg.size)
 		printf("htable-size %u ", r->cfg.size);
 	if (r->cfg.max)
@@ -335,6 +546,53 @@ static void hashlimit_print(const void *
 		printf("htable-expire %u ", r->cfg.expire);
 }
 
+static void
+hashlimit_mt_print(const struct xt_hashlimit_mtinfo1 *info, unsigned int dmask)
+{
+	if (info->cfg.mode & XT_HASHLIMIT_INVERT)
+		fputs("limit: above ", stdout);
+	else
+		fputs("limit: up to ", stdout);
+	print_rate(info->cfg.avg);
+	printf("burst %u ", info->cfg.burst);
+	if (info->cfg.mode & (XT_HASHLIMIT_HASH_SIP | XT_HASHLIMIT_HASH_SPT |
+	    XT_HASHLIMIT_HASH_DIP | XT_HASHLIMIT_HASH_DPT)) {
+		fputs("mode ", stdout);
+		print_mode(info->cfg.mode, '-');
+	}
+	if (info->cfg.size != 0)
+		printf("htable-size %u ", info->cfg.size);
+	if (info->cfg.max != 0)
+		printf("htable-max %u ", info->cfg.max);
+	if (info->cfg.gc_interval != XT_HASHLIMIT_GCINTERVAL)
+		printf("htable-gcinterval %u ", info->cfg.gc_interval);
+	if (info->cfg.expire != XT_HASHLIMIT_EXPIRE)
+		printf("htable-expire %u ", info->cfg.expire);
+
+	if (info->cfg.srcmask != dmask)
+		printf("srcmask %u ", info->cfg.srcmask);
+	if (info->cfg.dstmask != dmask)
+		printf("dstmask %u ", info->cfg.dstmask);
+}
+
+static void
+hashlimit_mt4_print(const void *ip, const struct xt_entry_match *match,
+                   int numeric)
+{
+	const struct xt_hashlimit_mtinfo1 *info = (const void *)match->data;
+
+	hashlimit_mt_print(info, 32);
+}
+
+static void
+hashlimit_mt6_print(const void *ip, const struct xt_entry_match *match,
+                   int numeric)
+{
+	const struct xt_hashlimit_mtinfo1 *info = (const void *)match->data;
+
+	hashlimit_mt_print(info, 128);
+}
+
 /* FIXME: Make minimalist: only print rate if not default --RR */
 static void hashlimit_save(const void *ip, const struct xt_entry_match *match)
 {
@@ -346,7 +604,7 @@ static void hashlimit_save(const void *i
 		printf("--hashlimit-burst %u ", r->cfg.burst);
 
 	fputs("--hashlimit-mode ", stdout);
-	print_mode(r, ',');
+	print_mode(r->cfg.mode, ',');
 	
 	printf("--hashlimit-name %s ", r->name);
 
@@ -360,10 +618,61 @@ static void hashlimit_save(const void *i
 		printf("--hashlimit-htable-expire %u ", r->cfg.expire);
 }
 
+static void
+hashlimit_mt_save(const struct xt_hashlimit_mtinfo1 *info, unsigned int dmask)
+{
+	if (info->cfg.mode & XT_HASHLIMIT_INVERT)
+		fputs("--hashlimit-above ", stdout);
+	else
+		fputs("--hashlimit-upto ", stdout);
+	print_rate(info->cfg.avg);
+	if (info->cfg.burst != XT_HASHLIMIT_BURST)
+		printf("--hashlimit-burst %u ", info->cfg.burst);
+
+	if (info->cfg.mode & (XT_HASHLIMIT_HASH_SIP | XT_HASHLIMIT_HASH_SPT |
+	    XT_HASHLIMIT_HASH_DIP | XT_HASHLIMIT_HASH_DPT)) {
+		fputs("--hashlimit-mode ", stdout);
+		print_mode(info->cfg.mode, ',');
+	}
+
+	printf("--hashlimit-name %s ", info->name);
+
+	if (info->cfg.size != 0)
+		printf("--hashlimit-htable-size %u ", info->cfg.size);
+	if (info->cfg.max != 0)
+		printf("--hashlimit-htable-max %u ", info->cfg.max);
+	if (info->cfg.gc_interval != XT_HASHLIMIT_GCINTERVAL)
+		printf("--hashlimit-htable-gcinterval %u", info->cfg.gc_interval);
+	if (info->cfg.expire != XT_HASHLIMIT_EXPIRE)
+		printf("--hashlimit-htable-expire %u ", info->cfg.expire);
+
+	if (info->cfg.srcmask != dmask)
+		printf("--hashlimit-srcmask %u ", info->cfg.srcmask);
+	if (info->cfg.dstmask != dmask)
+		printf("--hashlimit-dstmask %u ", info->cfg.dstmask);
+}
+
+static void
+hashlimit_mt4_save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_hashlimit_mtinfo1 *info = (const void *)match->data;
+
+	hashlimit_mt_save(info, 32);
+}
+
+static void
+hashlimit_mt6_save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_hashlimit_mtinfo1 *info = (const void *)match->data;
+
+	hashlimit_mt_save(info, 128);
+}
+
 static struct xtables_match hashlimit_match = {
 	.family		= AF_INET,
 	.name		= "hashlimit",
 	.version	= IPTABLES_VERSION,
+	.revision	= 0,
 	.size		= XT_ALIGN(sizeof(struct xt_hashlimit_info)),
 	.userspacesize	= offsetof(struct xt_hashlimit_info, hinfo),
 	.help		= hashlimit_help,
@@ -379,6 +688,7 @@ static struct xtables_match hashlimit_ma
 	.family		= AF_INET6,
 	.name		= "hashlimit",
 	.version	= IPTABLES_VERSION,
+	.revision	= 0,
 	.size		= XT_ALIGN(sizeof(struct xt_hashlimit_info)),
 	.userspacesize	= offsetof(struct xt_hashlimit_info, hinfo),
 	.help		= hashlimit_help,
@@ -390,9 +700,43 @@ static struct xtables_match hashlimit_ma
 	.extra_opts	= hashlimit_opts,
 };
 
+static struct xtables_match hashlimit_mt_reg = {
+	.version        = IPTABLES_VERSION,
+	.name           = "hashlimit",
+	.revision       = 1,
+	.family         = AF_INET,
+	.size           = XT_ALIGN(sizeof(struct xt_hashlimit_mtinfo1)),
+	.userspacesize  = offsetof(struct xt_hashlimit_mtinfo1, hinfo),
+	.help           = hashlimit_mt_help,
+	.init           = hashlimit_mt4_init,
+	.parse          = hashlimit_mt4_parse,
+	.final_check	= hashlimit_mt_check,
+	.print          = hashlimit_mt4_print,
+	.save           = hashlimit_mt4_save,
+	.extra_opts     = hashlimit_mt_opts,
+};
+
+static struct xtables_match hashlimit_mt6_reg = {
+	.version        = IPTABLES_VERSION,
+	.name           = "hashlimit",
+	.revision       = 1,
+	.family         = AF_INET6,
+	.size           = XT_ALIGN(sizeof(struct xt_hashlimit_mtinfo1)),
+	.userspacesize  = offsetof(struct xt_hashlimit_mtinfo1, hinfo),
+	.help           = hashlimit_mt_help,
+	.init           = hashlimit_mt6_init,
+	.parse          = hashlimit_mt6_parse,
+	.final_check	= hashlimit_mt_check,
+	.print          = hashlimit_mt6_print,
+	.save           = hashlimit_mt6_save,
+	.extra_opts     = hashlimit_mt_opts,
+};
+
 void _init(void);
 void _init(void)
 {
 	xtables_register_match(&hashlimit_match);
 	xtables_register_match(&hashlimit_match6);
+	xtables_register_match(&hashlimit_mt_reg);
+	xtables_register_match(&hashlimit_mt6_reg);
 }
Index: iptables/extensions/libxt_hashlimit.man
===================================================================
--- iptables.orig/extensions/libxt_hashlimit.man
+++ iptables/extensions/libxt_hashlimit.man
@@ -1,35 +1,59 @@
-This patch adds a new match called 'hashlimit'.
-The idea is to have something like 'limit', but either per
-destination-ip or per (destip,destport) tuple.
-
-It gives you the ability to express
-.IP
- '1000 packets per second for every host in 192.168.0.0/16'
-.IP
- '100 packets per second for every service of 192.168.1.1'
-.P
-with a single iptables rule.
-.TP
-.BI "--hashlimit " "rate"
-A rate just like the limit match
-.TP
-.BI "--hashlimit-burst " "num"
-Burst value, just like limit match
+\fBhashlimit\fR uses hash buckets to express a rate limiting match (like the
+\fBlimit\fR match) for a group of connections using a \fBsingle\fR iptables
+rule. Grouping can be done per-hostgroup (source and/or destination address)
+and/or per-port. It gives you the ability to express "\fIN\fR packets per time
+quantum per group":
+.TP
+matching on source host
+"1000 packets per second for every host in 192.168.0.0/16"
+.TP
+matching on source prot
+"100 packets per second for every service of 192.168.1.1"
+.TP
+matching on subnet
+"10000 packets per minute for every /28 subnet in 10.0.0.0/8"
+.PP
+A hash limit option (\fB--hashlimit-upto\fR, \fB--hashlimit-above\fR) and
+\fB--hashlimit-name\fR are required.
+.TP
+\fB--hashlimit-upto\fR \fIamount\fR[\fB/second\fR|\fB/minute\fR|\fB/hour\fR|\fB/day\fR]
+Match if the rate is below or equal to \fIamount\fR/quantum. It is specified as
+a number, with an optional time quantum suffix; the default is 3/hour.
+.TP
+\fB--hashlimit-above\fR \fIamount\fR[\fB/second\fR|\fB/minute\fR|\fB/hour\fR|\fB/day\fR]
+Match if the rate is above \fIamount\fR/quantum.
+.TP
+\fB--hashlimit-burst\fR \fIamount\fR
+Maximum initial number of packets to match: this number gets recharged by one
+every time the limit specified above is not reached, up to this number; the
+default is 5.
+.TP
+\fB--hashlimit-mode\fR [\fBsrcip\fR|\fBsrcport\fR|\fBdstip\fR|\fBdstport\fR[\fB,\fR...]]
+A comma-separated list of objects to take into consideration. If no
+--hashlimit-mode option is given, hashlimit acts like limit, but at the
+expensive of doing the hash housekeeping.
+.TP
+\fB--hashlimit-srcmask\fR \fIprefix\fR
+When --hashlimit-mode srcip is used, all source addresses encountered will be
+grouped according to the given prefix length and the so-created subnet will be
+subject to hashlimit. \fIprefix\fR must be between (inclusive) 0 and 32. Note
+that --hashlimit-srcmask 0 is basically doing the same thing as not specifying
+srcip for --hashlimit-mode, but is technically more expensive.
 .TP
-.BI "--hashlimit-mode " "dstip,srcip,dstport,srcport"
-A comma-separated list of objects to take into consideration
+\fB--hashlimit-dstmask\fR \fIprefix\fR
+Like --hashlimit-srcmask, but for destination addresses.
 .TP
-.BI "--hashlimit-name " "foo"
-The name for the /proc/net/ipt_hashlimit/foo entry
+\fB--hashlimit-name\fR \fIfoo\fR
+The name for the /proc/net/ipt_hashlimit/foo entry.
 .TP
-.BI "--hashlimit-htable-size " "num"
+\fB--hashlimit-htable-size\fR \fIbuckets\fR
 The number of buckets of the hash table
 .TP
-.BI "--hashlimit-htable-max " "num"
-Maximum entries in the hash
+\fB--hashlimit-htable-max\fR \fIentries\fR
+Maximum entries in the hash.
 .TP
-.BI "--hashlimit-htable-expire " "num"
-After how many miliseconds do hash entries expire
+\fB--hashlimit-htable-expire\fR \fImsec\fR
+After how many miliseconds do hash entries expire.
 .TP
-.BI "--hashlimit-htable-gcinterval " "num"
-How many miliseconds between garbage collection intervals
+\fB--hashlimit-htable-gcinterval\fR \fImsec\fR
+How many miliseconds between garbage collection intervals.
Index: iptables/include/linux/netfilter/xt_hashlimit.h
===================================================================
--- iptables.orig/include/linux/netfilter/xt_hashlimit.h
+++ iptables/include/linux/netfilter/xt_hashlimit.h
@@ -9,13 +9,16 @@
 /* details of this structure hidden by the implementation */
 struct xt_hashlimit_htable;
 
-#define XT_HASHLIMIT_HASH_DIP	0x0001
-#define XT_HASHLIMIT_HASH_DPT	0x0002
-#define XT_HASHLIMIT_HASH_SIP	0x0004
-#define XT_HASHLIMIT_HASH_SPT	0x0008
+enum {
+	XT_HASHLIMIT_HASH_DIP = 1 << 0,
+	XT_HASHLIMIT_HASH_DPT = 1 << 1,
+	XT_HASHLIMIT_HASH_SIP = 1 << 2,
+	XT_HASHLIMIT_HASH_SPT = 1 << 3,
+	XT_HASHLIMIT_INVERT   = 1 << 4,
+};
 
 struct hashlimit_cfg {
-	u_int32_t mode;	  /* bitmask of IPT_HASHLIMIT_HASH_* */
+	u_int32_t mode;	  /* bitmask of XT_HASHLIMIT_HASH_* */
 	u_int32_t avg;    /* Average secs between packets * scale */
 	u_int32_t burst;  /* Period multiplier for upper limit. */
 
@@ -29,12 +32,35 @@ struct hashlimit_cfg {
 struct xt_hashlimit_info {
 	char name [IFNAMSIZ];		/* name */
 	struct hashlimit_cfg cfg;
-	struct xt_hashlimit_htable *hinfo;
 
 	/* Used internally by the kernel */
+	struct xt_hashlimit_htable *hinfo;
 	union {
 		void *ptr;
 		struct xt_hashlimit_info *master;
 	} u;
 };
+
+struct hashlimit_cfg1 {
+	u_int32_t mode;	  /* bitmask of XT_HASHLIMIT_HASH_* */
+	u_int32_t avg;    /* Average secs between packets * scale */
+	u_int32_t burst;  /* Period multiplier for upper limit. */
+
+	/* user specified */
+	u_int32_t size;		/* how many buckets */
+	u_int32_t max;		/* max number of entries */
+	u_int32_t gc_interval;	/* gc interval */
+	u_int32_t expire;	/* when do entries expire? */
+
+	u_int8_t srcmask, dstmask;
+};
+
+struct xt_hashlimit_mtinfo1 {
+	char name[IFNAMSIZ];
+	struct hashlimit_cfg1 cfg;
+
+	/* Used internally by the kernel */
+	struct xt_hashlimit_htable *hinfo __attribute__((aligned(8)));
+};
+
 #endif /*_XT_HASHLIMIT_H*/
