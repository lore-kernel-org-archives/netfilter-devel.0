From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 7/7] libxt_state: replace as an alias to xt_conntrack
Date: Fri, 28 Sep 2012 00:48:29 +0200
Message-ID: <1348786109-20894-8-git-send-email-jengelh@inai.de>
References: <1348786109-20894-1-git-send-email-jengelh@inai.de>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:56166 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756027Ab2I0Wse (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Sep 2012 18:48:34 -0400
In-Reply-To: <1348786109-20894-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/GNUmakefile.in    |    4 +-
 extensions/libxt_conntrack.c |  189 ++++++++++++++++++++++++++++++++++++++++++
 extensions/libxt_state.c     |  137 ------------------------------
 3 files changed, 192 insertions(+), 138 deletions(-)
 delete mode 100644 extensions/libxt_state.c

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index b5c355a..48facce 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -39,7 +39,7 @@ endif
 #	Wildcard module list
 #
 pfx_build_mod := $(patsubst ${srcdir}/libxt_%.c,%,$(sort $(wildcard ${srcdir}/libxt_*.c)))
-pfx_build_mod += NOTRACK
+pfx_build_mod += NOTRACK state
 @ENABLE_IPV4_TRUE@ pf4_build_mod := $(patsubst ${srcdir}/libipt_%.c,%,$(sort $(wildcard ${srcdir}/libipt_*.c)))
 @ENABLE_IPV6_TRUE@ pf6_build_mod := $(patsubst ${srcdir}/libip6t_%.c,%,$(sort $(wildcard ${srcdir}/libip6t_*.c)))
 pfx_build_mod := $(filter-out @blacklist_modules@,${pfx_build_mod})
@@ -99,6 +99,8 @@ lib%.oo: ${srcdir}/lib%.c
 
 libxt_NOTRACK.so: libxt_CT.so
 	ln -fs $< $@
+libxt_state.so: libxt_conntrack.so
+	ln -fs $< $@
 
 # Need the LIBADDs in iptables/Makefile.am too for libxtables_la_LIBADD
 xt_RATEEST_LIBADD   = -lm
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index fff69f8..b559d9d 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -13,7 +13,11 @@
 #include <string.h>
 #include <xtables.h>
 #include <linux/netfilter/xt_conntrack.h>
+#include <linux/netfilter/xt_state.h>
 #include <linux/netfilter/nf_conntrack_common.h>
+#ifndef XT_STATE_UNTRACKED
+#define XT_STATE_UNTRACKED (1 << (IP_CT_NUMBER + 1))
+#endif
 
 struct ip_conntrack_old_tuple {
 	struct {
@@ -1003,6 +1007,142 @@ conntrack1_mt6_save(const void *ip, const struct xt_entry_match *match)
 	conntrack_dump(&up, "--", NFPROTO_IPV6, true, false);
 }
 
+static void
+state_help(void)
+{
+	printf(
+"state match options:\n"
+" [!] --state [INVALID|ESTABLISHED|NEW|RELATED|UNTRACKED][,...]\n"
+"				State(s) to match\n");
+}
+
+static const struct xt_option_entry state_opts[] = {
+	{.name = "state", .id = O_CTSTATE, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND | XTOPT_INVERT},
+	XTOPT_TABLEEND,
+};
+
+static unsigned int
+state_parse_state(const char *state, size_t len)
+{
+	if (strncasecmp(state, "INVALID", len) == 0)
+		return XT_STATE_INVALID;
+	else if (strncasecmp(state, "NEW", len) == 0)
+		return XT_STATE_BIT(IP_CT_NEW);
+	else if (strncasecmp(state, "ESTABLISHED", len) == 0)
+		return XT_STATE_BIT(IP_CT_ESTABLISHED);
+	else if (strncasecmp(state, "RELATED", len) == 0)
+		return XT_STATE_BIT(IP_CT_RELATED);
+	else if (strncasecmp(state, "UNTRACKED", len) == 0)
+		return XT_STATE_UNTRACKED;
+	return 0;
+}
+
+static unsigned int
+state_parse_states(const char *arg)
+{
+	const char *comma;
+	unsigned int mask = 0, flag;
+
+	while ((comma = strchr(arg, ',')) != NULL) {
+		if (comma == arg)
+			goto badstate;
+		flag = state_parse_state(arg, comma-arg);
+		if (flag == 0)
+			goto badstate;
+		mask |= flag;
+		arg = comma+1;
+	}
+	if (!*arg)
+		xtables_error(PARAMETER_PROBLEM, "\"--state\" requires a list of "
+					      "states with no spaces, e.g. "
+					      "ESTABLISHED,RELATED");
+	if (strlen(arg) == 0)
+		goto badstate;
+	flag = state_parse_state(arg, strlen(arg));
+	if (flag == 0)
+		goto badstate;
+	mask |= flag;
+	return mask;
+ badstate:
+	xtables_error(PARAMETER_PROBLEM, "Bad state \"%s\"", arg);
+}
+
+static void state_parse(struct xt_option_call *cb)
+{
+	struct xt_state_info *sinfo = cb->data;
+
+	xtables_option_parse(cb);
+	sinfo->statemask = state_parse_states(cb->arg);
+	if (cb->invert)
+		sinfo->statemask = ~sinfo->statemask;
+}
+
+static void state_ct1_parse(struct xt_option_call *cb)
+{
+	struct xt_conntrack_mtinfo1 *sinfo = cb->data;
+
+	xtables_option_parse(cb);
+	sinfo->state_mask = state_parse_states(cb->arg);
+	if (cb->invert)
+		sinfo->invert_flags |= XT_CONNTRACK_STATE;
+}
+
+static void state_ct23_parse(struct xt_option_call *cb)
+{
+	struct xt_conntrack_mtinfo3 *sinfo = cb->data;
+
+	xtables_option_parse(cb);
+	sinfo->state_mask = state_parse_states(cb->arg);
+	if (cb->invert)
+		sinfo->invert_flags |= XT_CONNTRACK_STATE;
+}
+
+static void state_print_state(unsigned int statemask)
+{
+	const char *sep = "";
+
+	if (statemask & XT_STATE_INVALID) {
+		printf("%sINVALID", sep);
+		sep = ",";
+	}
+	if (statemask & XT_STATE_BIT(IP_CT_NEW)) {
+		printf("%sNEW", sep);
+		sep = ",";
+	}
+	if (statemask & XT_STATE_BIT(IP_CT_RELATED)) {
+		printf("%sRELATED", sep);
+		sep = ",";
+	}
+	if (statemask & XT_STATE_BIT(IP_CT_ESTABLISHED)) {
+		printf("%sESTABLISHED", sep);
+		sep = ",";
+	}
+	if (statemask & XT_STATE_UNTRACKED) {
+		printf("%sUNTRACKED", sep);
+		sep = ",";
+	}
+}
+
+static void
+state_print(const void *ip,
+      const struct xt_entry_match *match,
+      int numeric)
+{
+	const struct xt_state_info *sinfo = (const void *)match->data;
+
+	printf(" state ");
+	state_print_state(sinfo->statemask);
+}
+
+static void state_save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_state_info *sinfo = (const void *)match->data;
+
+	printf(" --state ");
+	state_print_state(sinfo->statemask);
+}
+
 static struct xtables_match conntrack_mt_reg[] = {
 	{
 		.version       = XTABLES_VERSION,
@@ -1102,6 +1242,55 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.save          = conntrack3_mt6_save,
 		.x6_options    = conntrack3_mt_opts,
 	},
+	{
+		.family        = NFPROTO_UNSPEC,
+		.name          = "state",
+		.real_name     = "conntrack",
+		.revision      = 1,
+		.version       = XTABLES_VERSION,
+		.size          = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
+		.help          = state_help,
+		.x6_parse      = state_ct1_parse,
+		.x6_options    = state_opts,
+	},
+	{
+		.family        = NFPROTO_UNSPEC,
+		.name          = "state",
+		.real_name     = "conntrack",
+		.revision      = 2,
+		.version       = XTABLES_VERSION,
+		.size          = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo2)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo2)),
+		.help          = state_help,
+		.x6_parse      = state_ct23_parse,
+		.x6_options    = state_opts,
+	},
+	{
+		.family        = NFPROTO_UNSPEC,
+		.name          = "state",
+		.real_name     = "conntrack",
+		.revision      = 3,
+		.version       = XTABLES_VERSION,
+		.size          = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo3)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo3)),
+		.help          = state_help,
+		.x6_parse      = state_ct23_parse,
+		.x6_options    = state_opts,
+	},
+	{
+		.family        = NFPROTO_UNSPEC,
+		.name          = "state",
+		.revision      = 0,
+		.version       = XTABLES_VERSION,
+		.size          = XT_ALIGN(sizeof(struct xt_state_info)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_state_info)),
+		.help          = state_help,
+		.print         = state_print,
+		.save          = state_save,
+		.x6_parse      = state_parse,
+		.x6_options    = state_opts,
+	},
 };
 
 void _init(void)
diff --git a/extensions/libxt_state.c b/extensions/libxt_state.c
deleted file mode 100644
index eff444c..0000000
--- a/extensions/libxt_state.c
+++ /dev/null
@@ -1,137 +0,0 @@
-#include <stdio.h>
-#include <string.h>
-#include <xtables.h>
-#include <linux/netfilter/nf_conntrack_common.h>
-#include <linux/netfilter/xt_state.h>
-
-#ifndef XT_STATE_UNTRACKED
-#define XT_STATE_UNTRACKED (1 << (IP_CT_NUMBER + 1))
-#endif
-
-enum {
-	O_STATE = 0,
-};
-
-static void
-state_help(void)
-{
-	printf(
-"state match options:\n"
-" [!] --state [INVALID|ESTABLISHED|NEW|RELATED|UNTRACKED][,...]\n"
-"				State(s) to match\n");
-}
-
-static const struct xt_option_entry state_opts[] = {
-	{.name = "state", .id = O_STATE, .type = XTTYPE_STRING,
-	 .flags = XTOPT_MAND | XTOPT_INVERT},
-	XTOPT_TABLEEND,
-};
-
-static int
-state_parse_state(const char *state, size_t len, struct xt_state_info *sinfo)
-{
-	if (strncasecmp(state, "INVALID", len) == 0)
-		sinfo->statemask |= XT_STATE_INVALID;
-	else if (strncasecmp(state, "NEW", len) == 0)
-		sinfo->statemask |= XT_STATE_BIT(IP_CT_NEW);
-	else if (strncasecmp(state, "ESTABLISHED", len) == 0)
-		sinfo->statemask |= XT_STATE_BIT(IP_CT_ESTABLISHED);
-	else if (strncasecmp(state, "RELATED", len) == 0)
-		sinfo->statemask |= XT_STATE_BIT(IP_CT_RELATED);
-	else if (strncasecmp(state, "UNTRACKED", len) == 0)
-		sinfo->statemask |= XT_STATE_UNTRACKED;
-	else
-		return 0;
-	return 1;
-}
-
-static void
-state_parse_states(const char *arg, struct xt_state_info *sinfo)
-{
-	const char *comma;
-
-	while ((comma = strchr(arg, ',')) != NULL) {
-		if (comma == arg || !state_parse_state(arg, comma-arg, sinfo))
-			xtables_error(PARAMETER_PROBLEM, "Bad state \"%s\"", arg);
-		arg = comma+1;
-	}
-	if (!*arg)
-		xtables_error(PARAMETER_PROBLEM, "\"--state\" requires a list of "
-					      "states with no spaces, e.g. "
-					      "ESTABLISHED,RELATED");
-	if (strlen(arg) == 0 || !state_parse_state(arg, strlen(arg), sinfo))
-		xtables_error(PARAMETER_PROBLEM, "Bad state \"%s\"", arg);
-}
-
-static void state_parse(struct xt_option_call *cb)
-{
-	struct xt_state_info *sinfo = cb->data;
-
-	xtables_option_parse(cb);
-	state_parse_states(cb->arg, sinfo);
-	if (cb->invert)
-		sinfo->statemask = ~sinfo->statemask;
-}
-
-static void state_print_state(unsigned int statemask)
-{
-	const char *sep = "";
-
-	if (statemask & XT_STATE_INVALID) {
-		printf("%sINVALID", sep);
-		sep = ",";
-	}
-	if (statemask & XT_STATE_BIT(IP_CT_NEW)) {
-		printf("%sNEW", sep);
-		sep = ",";
-	}
-	if (statemask & XT_STATE_BIT(IP_CT_RELATED)) {
-		printf("%sRELATED", sep);
-		sep = ",";
-	}
-	if (statemask & XT_STATE_BIT(IP_CT_ESTABLISHED)) {
-		printf("%sESTABLISHED", sep);
-		sep = ",";
-	}
-	if (statemask & XT_STATE_UNTRACKED) {
-		printf("%sUNTRACKED", sep);
-		sep = ",";
-	}
-}
-
-static void
-state_print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
-{
-	const struct xt_state_info *sinfo = (const void *)match->data;
-
-	printf(" state ");
-	state_print_state(sinfo->statemask);
-}
-
-static void state_save(const void *ip, const struct xt_entry_match *match)
-{
-	const struct xt_state_info *sinfo = (const void *)match->data;
-
-	printf(" --state ");
-	state_print_state(sinfo->statemask);
-}
-
-static struct xtables_match state_match = { 
-	.family		= NFPROTO_UNSPEC,
-	.name		= "state",
-	.version	= XTABLES_VERSION,
-	.size		= XT_ALIGN(sizeof(struct xt_state_info)),
-	.userspacesize	= XT_ALIGN(sizeof(struct xt_state_info)),
-	.help		= state_help,
-	.print		= state_print,
-	.save		= state_save,
-	.x6_parse	= state_parse,
-	.x6_options	= state_opts,
-};
-
-void _init(void)
-{
-	xtables_register_match(&state_match);
-}
-- 
1.7.10.4

