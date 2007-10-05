From: Laszlo Attila Toth <panther@balabit.hu>
Subject: [PATCH] Unique symbols and no '&' characters
Date: Fri, 05 Oct 2007 10:52:40 +0200
Message-ID: <4705fb58.jF9ZZTjcjs6Uxq0Q%panther@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:52550 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176AbXJEIwp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Oct 2007 04:52:45 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 4CB6CC118F
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Oct 2007 10:52:43 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Removing '&' from .._match and ..._target variables.
Give all symbols unique names.

Signed-off-by: Laszlo Attila Toth

Index: extensions/libxt_CLASSIFY.c
===================================================================
--- extensions/libxt_CLASSIFY.c	(revision 7065)
+++ extensions/libxt_CLASSIFY.c	(working copy)
@@ -12,7 +12,7 @@
 
 /* Function which prints out usage message. */
 static void
-help(void)
+CLASSIFY_help(void)
 {
 	printf(
 "CLASSIFY target v%s options:\n"
@@ -21,12 +21,12 @@
 IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option CLASSIFY_opts[] = {
 	{ "set-class", 1, NULL, '1' },
 	{ }
 };
 
-static int string_to_priority(const char *s, unsigned int *p)
+static int CLASSIFY_string_to_priority(const char *s, unsigned int *p)
 {
 	unsigned int i, j;
 
@@ -40,7 +40,7 @@
 /* Function which parses command options; returns true if it
    ate an option */
 static int
-parse(int c, char **argv, int invert, unsigned int *flags,
+CLASSIFY_parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
       struct xt_entry_target **target)
 {
@@ -49,7 +49,7 @@
 
 	switch (c) {
 	case '1':
-		if (string_to_priority(optarg, &clinfo->priority))
+		if (CLASSIFY_string_to_priority(optarg, &clinfo->priority))
 			exit_error(PARAMETER_PROBLEM,
 				   "Bad class value `%s'", optarg);
 		if (*flags)
@@ -66,7 +66,7 @@
 }
 
 static void
-final_check(unsigned int flags)
+CLASSIFY_final_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
@@ -74,26 +74,26 @@
 }
 
 static void
-print_class(unsigned int priority, int numeric)
+CLASSIFY_print_class(unsigned int priority, int numeric)
 {
 	printf("%x:%x ", TC_H_MAJ(priority)>>16, TC_H_MIN(priority));
 }
 
 /* Prints out the targinfo. */
 static void
-print(const void *ip,
+CLASSIFY_print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
 	const struct xt_classify_target_info *clinfo =
 		(const struct xt_classify_target_info *)target->data;
 	printf("CLASSIFY set ");
-	print_class(clinfo->priority, numeric);
+	CLASSIFY_print_class(clinfo->priority, numeric);
 }
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const void *ip, const struct xt_entry_target *target)
+CLASSIFY_save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct xt_classify_target_info *clinfo =
 		(const struct xt_classify_target_info *)target->data;
@@ -102,36 +102,36 @@
 	       TC_H_MAJ(clinfo->priority)>>16, TC_H_MIN(clinfo->priority));
 }
 
-static struct xtables_target classify = { 
+static struct xtables_target classify_target = { 
 	.family		= AF_INET,
 	.name		= "CLASSIFY",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_classify_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_classify_target_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts,
+	.help		= CLASSIFY_help,
+	.parse		= CLASSIFY_parse,
+	.final_check	= CLASSIFY_final_check,
+	.print		= CLASSIFY_print,
+	.save		= CLASSIFY_save,
+	.extra_opts	= CLASSIFY_opts,
 };
 
-static struct xtables_target classify6 = { 
+static struct xtables_target classify_target6 = { 
 	.family		= AF_INET6,
 	.name		= "CLASSIFY",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_classify_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_classify_target_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts,
+	.help		= CLASSIFY_help,
+	.parse		= CLASSIFY_parse,
+	.final_check	= CLASSIFY_final_check,
+	.print		= CLASSIFY_print,
+	.save		= CLASSIFY_save,
+	.extra_opts	= CLASSIFY_opts,
 };
 
 void _init(void)
 {
-	xtables_register_target(&classify);
-	xtables_register_target(&classify6);
+	xtables_register_target(&classify_target);
+	xtables_register_target(&classify_target6);
 }
Index: extensions/libxt_state.c
===================================================================
--- extensions/libxt_state.c	(revision 7065)
+++ extensions/libxt_state.c	(working copy)
@@ -14,7 +14,7 @@
 
 /* Function which prints out usage message. */
 static void
-help(void)
+state_help(void)
 {
 	printf(
 "state v%s options:\n"
@@ -23,13 +23,13 @@
 "\n", IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option state_opts[] = {
 	{ "state", 1, NULL, '1' },
 	{ }
 };
 
 static int
-parse_state(const char *state, size_t strlen, struct xt_state_info *sinfo)
+state_parse_state(const char *state, size_t strlen, struct xt_state_info *sinfo)
 {
 	if (strncasecmp(state, "INVALID", strlen) == 0)
 		sinfo->statemask |= XT_STATE_INVALID;
@@ -47,24 +47,24 @@
 }
 
 static void
-parse_states(const char *arg, struct xt_state_info *sinfo)
+state_parse_states(const char *arg, struct xt_state_info *sinfo)
 {
 	const char *comma;
 
 	while ((comma = strchr(arg, ',')) != NULL) {
-		if (comma == arg || !parse_state(arg, comma-arg, sinfo))
+		if (comma == arg || !state_parse_state(arg, comma-arg, sinfo))
 			exit_error(PARAMETER_PROBLEM, "Bad state `%s'", arg);
 		arg = comma+1;
 	}
 
-	if (strlen(arg) == 0 || !parse_state(arg, strlen(arg), sinfo))
+	if (strlen(arg) == 0 || !state_parse_state(arg, strlen(arg), sinfo))
 		exit_error(PARAMETER_PROBLEM, "Bad state `%s'", arg);
 }
 
 /* Function which parses command options; returns true if it
    ate an option */
 static int
-parse(int c, char **argv, int invert, unsigned int *flags,
+state_parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
       struct xt_entry_match **match)
 {
@@ -74,7 +74,7 @@
 	case '1':
 		check_inverse(optarg, &invert, &optind, 0);
 
-		parse_states(argv[optind-1], sinfo);
+		state_parse_states(argv[optind-1], sinfo);
 		if (invert)
 			sinfo->statemask = ~sinfo->statemask;
 		*flags = 1;
@@ -88,13 +88,13 @@
 }
 
 /* Final check; must have specified --state. */
-static void final_check(unsigned int flags)
+static void state_final_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM, "You must specify `--state'");
 }
 
-static void print_state(unsigned int statemask)
+static void state_print_state(unsigned int statemask)
 {
 	const char *sep = "";
 
@@ -123,55 +123,55 @@
 
 /* Prints out the matchinfo. */
 static void
-print(const void *ip,
+state_print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
 	struct xt_state_info *sinfo = (struct xt_state_info *)match->data;
 
 	printf("state ");
-	print_state(sinfo->statemask);
+	state_print_state(sinfo->statemask);
 }
 
 /* Saves the matchinfo in parsable form to stdout. */
-static void save(const void *ip, const struct xt_entry_match *match)
+static void state_save(const void *ip, const struct xt_entry_match *match)
 {
 	struct xt_state_info *sinfo = (struct xt_state_info *)match->data;
 
 	printf("--state ");
-	print_state(sinfo->statemask);
+	state_print_state(sinfo->statemask);
 }
 
-static struct xtables_match state = { 
+static struct xtables_match state_match = { 
 	.family		= AF_INET,
 	.name		= "state",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_state_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_state_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts,
+	.help		= state_help,
+	.parse		= state_parse,
+	.final_check	= state_final_check,
+	.print		= state_print,
+	.save		= state_save,
+	.extra_opts	= state_opts,
 };
 
-static struct xtables_match state6 = { 
+static struct xtables_match state_match6 = { 
 	.family		= AF_INET6,
 	.name		= "state",
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_state_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_state_info)),
-	.help		= &help,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts,
+	.help		= state_help,
+	.parse		= state_parse,
+	.final_check	= state_final_check,
+	.print		= state_print,
+	.save		= state_save,
+	.extra_opts	= state_opts,
 };
 
 void _init(void)
 {
-	xtables_register_match(&state);
-	xtables_register_match(&state6);
+	xtables_register_match(&state_match);
+	xtables_register_match(&state_match6);
 }
