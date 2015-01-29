From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [ebtables-compat PATCH 2/2] ebtables-compat: add mark target
 extension
Date: Thu, 29 Jan 2015 17:44:39 +0100
Message-ID: <20150129164439.21224.8860.stgit@nfdev.cica.es>
References: <20150129164433.21224.14657.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4.cica.es ([150.214.5.182]:42328 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754248AbbA2Qov (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Jan 2015 11:44:51 -0500
In-Reply-To: <20150129164433.21224.14657.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Translate the mark target extension to the xtables-compat environment.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 extensions/libebt_mark.c |  187 ++++++++++++++++++++++++++++++++++++++++++++++
 iptables/nft-bridge.c    |    2 
 iptables/nft-bridge.h    |   52 +++++++++++++
 iptables/xtables-eb.c    |   52 +++----------
 4 files changed, 253 insertions(+), 40 deletions(-)
 create mode 100644 extensions/libebt_mark.c

diff --git a/extensions/libebt_mark.c b/extensions/libebt_mark.c
new file mode 100644
index 0000000..97039ba
--- /dev/null
+++ b/extensions/libebt_mark.c
@@ -0,0 +1,187 @@
+/* ebt_mark
+ *
+ * Authors:
+ * Bart De Schuymer <bdschuym@pandora.be>
+ *
+ * July, 2002, September 2006
+ *
+ * Adapted by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ * to use libxtables for ebtables-compat in 2015.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <getopt.h>
+#include <xtables.h>
+#include <linux/netfilter_bridge/ebt_mark_t.h>
+#include "iptables/nft.h"
+#include "iptables/nft-bridge.h"
+
+static int mark_supplied;
+
+#define MARK_TARGET  '1'
+#define MARK_SETMARK '2'
+#define MARK_ORMARK  '3'
+#define MARK_ANDMARK '4'
+#define MARK_XORMARK '5'
+static struct option brmark_opts[] = {
+	{ .name = "mark-target",.has_arg = true,	.val = MARK_TARGET },
+	/* an oldtime messup, we should have always used the scheme
+	 * <extension-name>-<option> */
+	{ .name = "set-mark",	.has_arg = true,	.val = MARK_SETMARK },
+	{ .name = "mark-set",	.has_arg = true,	.val = MARK_SETMARK },
+	{ .name = "mark-or",	.has_arg = true,	.val = MARK_ORMARK },
+	{ .name = "mark-and",	.has_arg = true,	.val = MARK_ANDMARK },
+	{ .name = "mark-xor",	.has_arg = true,	.val = MARK_XORMARK },
+	XT_GETOPT_TABLEEND,
+};
+
+static void brmark_print_help(void)
+{
+	printf(
+	"mark target options:\n"
+	" --mark-set value     : Set nfmark value\n"
+	" --mark-or  value     : Or nfmark with value (nfmark |= value)\n"
+	" --mark-and value     : And nfmark with value (nfmark &= value)\n"
+	" --mark-xor value     : Xor nfmark with value (nfmark ^= value)\n"
+	" --mark-target target : ACCEPT, DROP, RETURN or CONTINUE\n");
+}
+
+static void brmark_init(struct xt_entry_target *target)
+{
+	struct ebt_mark_t_info *info = (struct ebt_mark_t_info *)target->data;
+
+	info->target = EBT_ACCEPT;
+	info->mark = 0;
+	mark_supplied = 0;
+}
+
+#define OPT_MARK_TARGET   0x01
+#define OPT_MARK_SETMARK  0x02
+#define OPT_MARK_ORMARK   0x04
+#define OPT_MARK_ANDMARK  0x08
+#define OPT_MARK_XORMARK  0x10
+
+static int
+brmark_parse(int c, char **argv, int invert, unsigned int *flags,
+	     const void *entry, struct xt_entry_target **target)
+{
+	struct ebt_mark_t_info *info = (struct ebt_mark_t_info *)
+				       (*target)->data;
+	char *end;
+	uint32_t mask;
+
+	switch (c) {
+	case MARK_TARGET:
+		{ int tmp;
+		EBT_CHECK_OPTION(flags, OPT_MARK_TARGET);
+		if (EBT_FILL_TARGET(optarg, tmp))
+			xtables_error(PARAMETER_PROBLEM,
+				      "Illegal --mark-target target");
+		/* the 4 lsb are left to designate the target */
+		info->target = (info->target & ~EBT_VERDICT_BITS) | (tmp & EBT_VERDICT_BITS);
+		}
+		return 1;
+	case MARK_SETMARK:
+		EBT_CHECK_OPTION(flags, OPT_MARK_SETMARK);
+		mask = (OPT_MARK_ORMARK|OPT_MARK_ANDMARK|OPT_MARK_XORMARK);
+		if (*flags & mask)
+			xtables_error(PARAMETER_PROBLEM,
+				      "--mark-set cannot be used together with"
+				      " specific --mark option");
+		info->target = (info->target & EBT_VERDICT_BITS) |
+			       MARK_SET_VALUE;
+		break;
+	case MARK_ORMARK:
+		EBT_CHECK_OPTION(flags, OPT_MARK_ORMARK);
+		mask = (OPT_MARK_SETMARK|OPT_MARK_ANDMARK|OPT_MARK_XORMARK);
+		if (*flags & mask)
+			xtables_error(PARAMETER_PROBLEM,
+				      "--mark-or cannot be used together with"
+				      " specific --mark option");
+		info->target = (info->target & EBT_VERDICT_BITS) |
+			       MARK_OR_VALUE;
+		break;
+	case MARK_ANDMARK:
+		EBT_CHECK_OPTION(flags, OPT_MARK_ANDMARK);
+		mask = (OPT_MARK_SETMARK|OPT_MARK_ORMARK|OPT_MARK_XORMARK);
+		if (*flags & mask)
+			xtables_error(PARAMETER_PROBLEM,
+				      "--mark-and cannot be used together with"
+				      " specific --mark option");
+		info->target = (info->target & EBT_VERDICT_BITS) |
+			       MARK_AND_VALUE;
+		break;
+	case MARK_XORMARK:
+		EBT_CHECK_OPTION(flags, OPT_MARK_XORMARK);
+		mask = (OPT_MARK_SETMARK|OPT_MARK_ANDMARK|OPT_MARK_ORMARK);
+		if (*flags & mask)
+			xtables_error(PARAMETER_PROBLEM,
+				      "--mark-xor cannot be used together with"
+				      " specific --mark option");
+		info->target = (info->target & EBT_VERDICT_BITS) |
+			       MARK_XOR_VALUE;
+		break;
+	default:
+		return 0;
+	}
+	/* mutual code */
+	info->mark = strtoul(optarg, &end, 0);
+	if (*end != '\0' || end == optarg)
+		xtables_error(PARAMETER_PROBLEM, "Bad MARK value '%s'",
+			      optarg);
+
+	mark_supplied = 1;
+	return 1;
+}
+
+static void brmark_print(const void *ip, const struct xt_entry_target *target,
+			 int numeric)
+{
+	struct ebt_mark_t_info *info = (struct ebt_mark_t_info *)target->data;
+	int tmp;
+
+	tmp = info->target & ~EBT_VERDICT_BITS;
+	if (tmp == MARK_SET_VALUE)
+		printf("--mark-set");
+	else if (tmp == MARK_OR_VALUE)
+		printf("--mark-or");
+	else if (tmp == MARK_XOR_VALUE)
+		printf("--mark-xor");
+	else if (tmp == MARK_AND_VALUE)
+		printf("--mark-and");
+	else
+		xtables_error(PARAMETER_PROBLEM, "Unknown mark action");
+
+	printf(" 0x%lx", info->mark);
+	tmp = info->target | ~EBT_VERDICT_BITS;
+	printf(" --mark-target %s", EBT_TARGET_NAME(tmp));
+}
+
+static void brmark_final_check(unsigned int flags)
+{
+	if (!flags)
+		xtables_error(PARAMETER_PROBLEM,
+			      "You must specify some option");
+}
+
+static struct xtables_target brmark_target = {
+	.name		= "mark",
+	.revision	= 0,
+	.version	= XTABLES_VERSION,
+	.family		= NFPROTO_BRIDGE,
+	.size		= XT_ALIGN(sizeof(struct ebt_mark_t_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct ebt_mark_t_info)),
+	.help		= brmark_print_help,
+	.init		= brmark_init,
+	.parse		= brmark_parse,
+	.final_check	= brmark_final_check,
+	.print		= brmark_print,
+	.extra_opts	= brmark_opts,
+};
+
+void _init(void)
+{
+	xtables_register_target(&brmark_target);
+}
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 62aab04..00402ed 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -114,6 +114,8 @@ static int _add_action(struct nft_rule *r, struct ebtables_command_state *cs)
 {
 	int ret = 0;
 
+	printf("_add_action() %s\n", cs->jumpto);
+
 	if (cs->jumpto == NULL || strcmp(cs->jumpto, "CONTINUE") == 0)
 		return 0;
 
diff --git a/iptables/nft-bridge.h b/iptables/nft-bridge.h
index 8357543..7a1db8e 100644
--- a/iptables/nft-bridge.h
+++ b/iptables/nft-bridge.h
@@ -4,7 +4,9 @@
 #include <netinet/in.h>
 //#include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/nf_tables.h>
 #include <net/ethernet.h>
+#include <libiptc/libxtc.h>
 
 /* We use replace->flags, so we can't use the following values:
  * 0x01 == OPT_COMMAND, 0x02 == OPT_TABLE, 0x100 == OPT_ZERO */
@@ -62,6 +64,12 @@ int ebt_get_mac_and_mask(const char *from, unsigned char *to, unsigned char *mas
 #define EBT_INV_MASK (EBT_IPROTO | EBT_IIN | EBT_IOUT | EBT_ILOGICALIN \
    | EBT_ILOGICALOUT | EBT_ISOURCE | EBT_IDEST)
 
+/* ebtables target modules store the verdict inside an int. We can
+ * reclaim a part of this int for backwards compatible extensions.
+ * The 4 lsb are more than enough to store the verdict.
+ */
+#define EBT_VERDICT_BITS 0x0000000F
+
 /* Fake ebt_entry */
 struct ebt_entry {
 	/* this needs to be the first field */
@@ -102,4 +110,48 @@ struct ebtables_command_state {
 void nft_rule_to_ebtables_command_state(struct nft_rule *r,
 					struct ebtables_command_state *cs);
 
+static const char *ebt_standard_targets[NUM_STANDARD_TARGETS] = {
+	"ACCEPT",
+	"DROP",
+	"CONTINUE",
+	"RETURN",
+};
+
+static inline const char *nft_ebt_standard_target(int index)
+{
+	if (index > NUM_STANDARD_TARGETS || index < 0)
+		return NULL;
+
+	return ebt_standard_targets[index];
+}
+
+/*
+ * Transforms a target string into the right integer,
+ * returns 0 on success.
+ */
+#define EBT_FILL_TARGET(_str, _pos) ({				\
+	int _i, _ret = 0;					\
+	for (_i = 0; _i < NUM_STANDARD_TARGETS; _i++)		\
+		if (!strcmp(_str, ebt_standard_targets[_i])) {	\
+			_pos = -_i - 1;				\
+			break;					\
+		}						\
+	if (_i == NUM_STANDARD_TARGETS)				\
+		_ret = 1;					\
+	_ret;							\
+})
+
+/* Transforms the target value to an index into standard_targets[] */
+#define EBT_TARGET_INDEX(_value) (-_value - 1)
+/* Returns a target string corresponding to the value */
+#define EBT_TARGET_NAME(_value) (nft_ebt_standard_target(EBT_TARGET_INDEX(_value)))
+
+#define EBT_CHECK_OPTION(flags, mask) ({				\
+	if (*flags & mask)						\
+		xtables_error(PARAMETER_PROBLEM,			\
+			      "Multiple use of same "			\
+			      "option not allowed");			\
+	*flags |= mask;							\
+})
+
 #endif
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 0ac39d0..a1d2110 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -21,6 +21,7 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <ctype.h>
 #include <errno.h>
 #include <getopt.h>
 #include <string.h>
@@ -36,6 +37,7 @@
 #include <linux/netfilter_bridge.h>
 #include <linux/netfilter/nf_tables.h>
 #include <ebtables/ethernetdb.h>
+#include <libiptc/libxtc.h>
 #include "xshared.h"
 #include "nft.h"
 #include "nft-bridge.h"
@@ -46,6 +48,8 @@
 #define EXEC_STYLE_PRG    0
 #define EXEC_STYLE_DAEMON 1
 
+#define ebt_check_option2(flags, mask) EBT_CHECK_OPTION(flags, mask)
+
 /*
  * From useful_functions.c
  */
@@ -105,19 +109,6 @@ int ebt_get_mac_and_mask(const char *from, unsigned char *to,
 	return 0;
 }
 
-/* This is a replacement for the ebt_check_option2() macro.
- *
- * Make sure the same option wasn't specified twice. This is used in the parse
- * functions of the extensions and ebtables.c.
- */
-static void ebt_check_option2(unsigned int *flags, unsigned int mask)
-{
-	if (*flags & mask)
-		xtables_error(PARAMETER_PROBLEM,
-			      "Multiple use of same option not allowed");
-	*flags |= mask;
-}
-
 static int ebt_check_inverse2(const char option[], int argc, char **argv)
 {
 	if (!option)
@@ -302,8 +293,6 @@ static struct option ebt_original_options[] =
 
 void xtables_exit_error(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
 
-static struct option *ebt_options = ebt_original_options;
-
 struct xtables_globals ebtables_globals = {
 	.option_offset 		= 0,
 	.program_version	= IPTABLES_VERSION,
@@ -320,15 +309,6 @@ struct xtables_globals ebtables_globals = {
  * From libebtc.c
  */
 
-/* The four target names, from libebtc.c */
-const char* ebt_standard_targets[NUM_STANDARD_TARGETS] =
-{
-	"ACCEPT",
-	"DROP",
-	"CONTINUE",
-	"RETURN",
-};
-
 /* Prints all registered extensions */
 static void ebt_list_extensions(const struct xtables_target *t,
 				const struct xtables_rule_match *m)
@@ -363,7 +343,7 @@ static struct option *merge_options(struct option *oldopts,
 	struct option *merge;
 
 	if (!newopts || !oldopts || !options_offset)
-		xtables_error(OTHER_PROBLEM, "merge wrong");
+		return oldopts;
 	for (num_old = 0; oldopts[num_old].name; num_old++);
 	for (num_new = 0; newopts[num_new].name; num_new++);
 
@@ -412,14 +392,9 @@ static struct xtables_target *command_jump(struct ebtables_command_state *cs,
 
 	xs_init_target(target);
 
-	if (target->x6_options != NULL)
-		ebt_options = xtables_options_xfrm(ebtables_globals.orig_opts,
-					    ebt_options, target->x6_options,
-					    &target->option_offset);
-	else
-		ebt_options = xtables_merge_options(ebtables_globals.orig_opts,
-					     ebt_options, target->extra_opts,
-					     &target->option_offset);
+	opts = merge_options(opts, target->extra_opts, &target->option_offset);
+	if (opts == NULL)
+		xtables_error(OTHER_PROBLEM, "Can't alloc memory");
 
 	return target;
 }
@@ -792,7 +767,7 @@ handle_P:
 					xtables_error(PARAMETER_PROBLEM,
 						      "No policy specified");
 				for (i = 0; i < NUM_STANDARD_TARGETS; i++)
-					if (!strcmp(argv[optind], ebt_standard_targets[i])) {
+					if (!strcmp(argv[optind], nft_ebt_standard_target(i))) {
 						policy = argv[optind];
 						if (-i-1 == EBT_CONTINUE)
 							xtables_error(PARAMETER_PROBLEM,
@@ -1170,12 +1145,9 @@ big_iface_length:
 			continue;
 		default:
 			/* Is it a target option? */
-			/*t = (struct ebt_u_target *)new_entry->t;
-			if ((t->parse(c - t->option_offset, argv, argc, new_entry, &t->flags, &t->t))) {
-				if (ebt_errormsg[0] != '\0')
-					return -1;
-				goto check_extension;
-			}*/
+			if (cs.target != NULL && cs.target->parse != NULL)
+				if (cs.target->parse(c - cs.target->option_offset, argv, ebt_invert, &cs.target->tflags, NULL, &cs.target->t))
+					goto check_extension;
 
 			/* Is it a match_option? */
 			for (m = xtables_matches; m; m = m->next) {

