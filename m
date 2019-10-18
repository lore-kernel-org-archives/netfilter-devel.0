Return-Path: <SRS0=5/AD=YL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB198CA9EA0
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Oct 2019 15:53:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FB962064B
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Oct 2019 15:53:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732806AbfJRPxT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Oct 2019 11:53:19 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:44352 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727668AbfJRPxT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Oct 2019 11:53:19 -0400
Received: from localhost ([::1]:57442 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iLUZ3-0006LM-8F; Fri, 18 Oct 2019 17:53:17 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/2] xshared: Introduce struct argv_store
Date:   Fri, 18 Oct 2019 17:53:09 +0200
Message-Id: <20191018155309.8250-2-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191018155309.8250-1-phil@nwl.cc>
References: <20191018155309.8250-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Make add_argv() and related routines reentrant by introducing a data
structure to hold the stored arguments.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/iptables-restore.c | 28 +++++++-------
 iptables/iptables-xml.c     | 30 ++++++++-------
 iptables/xshared.c          | 76 +++++++++++++++++++------------------
 iptables/xshared.h          | 26 +++++++------
 iptables/xtables-restore.c  | 31 +++++++--------
 5 files changed, 96 insertions(+), 95 deletions(-)

diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 50d0708eff1f3..b0a51d491c508 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -94,6 +94,7 @@ ip46tables_restore_main(const struct iptables_restore_cb *cb,
 			int argc, char *argv[])
 {
 	struct xtc_handle *handle = NULL;
+	struct argv_store av_store = {};
 	char buffer[10240];
 	int c, lock;
 	char curtable[XT_TABLE_MAXNAMELEN + 1] = {};
@@ -311,34 +312,31 @@ ip46tables_restore_main(const struct iptables_restore_cb *cb,
 			ret = 1;
 
 		} else if (in_table) {
-			int a;
 			char *pcnt = NULL;
 			char *bcnt = NULL;
 			char *parsestart = buffer;
 
-			add_argv(argv[0], 0);
-			add_argv("-t", 0);
-			add_argv(curtable, 0);
+			add_argv(&av_store, argv[0], 0);
+			add_argv(&av_store, "-t", 0);
+			add_argv(&av_store, curtable, 0);
 
 			tokenize_rule_counters(&parsestart, &pcnt, &bcnt, line);
 			if (counters && pcnt && bcnt) {
-				add_argv("--set-counters", 0);
-				add_argv(pcnt, 0);
-				add_argv(bcnt, 0);
+				add_argv(&av_store, "--set-counters", 0);
+				add_argv(&av_store, pcnt, 0);
+				add_argv(&av_store, bcnt, 0);
 			}
 
-			add_param_to_argv(parsestart, line);
+			add_param_to_argv(&av_store, parsestart, line);
 
 			DEBUGP("calling do_command(%u, argv, &%s, handle):\n",
-				newargc, curtable);
+				av_store.argc, curtable);
+			debug_print_argv(&av_store);
 
-			for (a = 0; a < newargc; a++)
-				DEBUGP("argv[%u]: %s\n", a, newargv[a]);
+			ret = cb->do_command(av_store.argc, av_store.argv,
+					 &av_store.argv[2], &handle, true);
 
-			ret = cb->do_command(newargc, newargv,
-					 &newargv[2], &handle, true);
-
-			free_argv();
+			free_argv(&av_store);
 			fflush(stdout);
 		}
 		if (tablename && strcmp(tablename, curtable) != 0)
diff --git a/iptables/iptables-xml.c b/iptables/iptables-xml.c
index eafee64f5e954..98d03dda98d2b 100644
--- a/iptables/iptables-xml.c
+++ b/iptables/iptables-xml.c
@@ -440,7 +440,7 @@ do_rule_part(char *leveltag1, char *leveltag2, int part, int argc,
 }
 
 static int
-compareRules(void)
+compareRules(int newargc, char *newargv[], int oldargc, char *oldargv[])
 {
 	/* Compare arguments up to -j or -g for match.
 	 * NOTE: We don't want to combine actions if there were no criteria
@@ -489,11 +489,13 @@ compareRules(void)
 
 /* has a nice parsed rule starting with -A */
 static void
-do_rule(char *pcnt, char *bcnt, int argc, char *argv[], int argvattr[])
+do_rule(char *pcnt, char *bcnt, int argc, char *argv[], int argvattr[],
+	int oldargc, char *oldargv[])
 {
 	/* are these conditions the same as the previous rule?
 	 * If so, skip arg straight to -j or -g */
-	if (combine && argc > 2 && !isTarget(argv[2]) && compareRules()) {
+	if (combine && argc > 2 && !isTarget(argv[2]) &&
+	    compareRules(argc, argv, oldargc, oldargv)) {
 		xmlComment("Combine action from next rule");
 	} else {
 
@@ -539,6 +541,7 @@ do_rule(char *pcnt, char *bcnt, int argc, char *argv[], int argvattr[])
 int
 iptables_xml_main(int argc, char *argv[])
 {
+	struct argv_store last_rule = {}, cur_rule = {};
 	char buffer[10240];
 	int c;
 	FILE *in;
@@ -648,18 +651,16 @@ iptables_xml_main(int argc, char *argv[])
 			char *chain = NULL;
 
 			tokenize_rule_counters(&parsestart, &pcnt, &bcnt, line);
-			add_param_to_argv(parsestart, line);
+			add_param_to_argv(&cur_rule, parsestart, line);
 
 			DEBUGP("calling do_command4(%u, argv, &%s, handle):\n",
-			       newargc, curTable);
+			       cur_rule.argc, curTable);
+			debug_print_argv(&cur_rule);
 
-			for (a = 0; a < newargc; a++)
-				DEBUGP("argv[%u]: %s\n", a, newargv[a]);
-
-			for (a = 1; a < newargc; a++) {
-				if (strcmp(newargv[a - 1], "-A"))
+			for (a = 1; a < cur_rule.argc; a++) {
+				if (strcmp(cur_rule.argv[a - 1], "-A"))
 					continue;
-				chain = newargv[a];
+				chain = cur_rule.argv[a];
 				break;
 			}
 			if (!chain) {
@@ -668,9 +669,10 @@ iptables_xml_main(int argc, char *argv[])
 				exit(1);
 			}
 			needChain(chain);// Should we explicitly look for -A
-			do_rule(pcnt, bcnt, newargc, newargv, newargvattr);
+			do_rule(pcnt, bcnt, cur_rule.argc, cur_rule.argv,
+				cur_rule.argvattr, last_rule.argc, last_rule.argv);
 
-			save_argv();
+			save_argv(&last_rule, &cur_rule);
 			ret = 1;
 		}
 		if (!ret) {
@@ -687,7 +689,7 @@ iptables_xml_main(int argc, char *argv[])
 
 	fclose(in);
 	printf("</iptables-rules>\n");
-	free_argv();
+	free_argv(&last_rule);
 
 	return 0;
 }
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 4c012e32c775f..112b54e6bef55 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -417,56 +417,48 @@ inline bool xs_has_arg(int argc, char *argv[])
 	       argv[optind][0] != '!';
 }
 
-/* global new argv and argc */
-char *newargv[255];
-int newargc = 0;
-
-/* saved newargv and newargc from save_argv() */
-char *oldargv[255];
-int oldargc = 0;
-
-/* arg meta data, were they quoted, frinstance */
-int newargvattr[255];
-
-/* function adding one argument to newargv, updating newargc
- * returns true if argument added, false otherwise */
-int add_argv(const char *what, int quoted)
+/* function adding one argument to store, updating argc
+ * returns if argument added, does not return otherwise */
+void add_argv(struct argv_store *store, const char *what, int quoted)
 {
 	DEBUGP("add_argv: %s\n", what);
-	if (what && newargc + 1 < ARRAY_SIZE(newargv)) {
-		newargv[newargc] = strdup(what);
-		newargvattr[newargc] = quoted;
-		newargv[++newargc] = NULL;
-		return 1;
-	} else {
+
+	if (store->argc + 1 >= MAX_ARGC)
 		xtables_error(PARAMETER_PROBLEM,
 			      "Parser cannot handle more arguments\n");
-	}
+	if (!what)
+		xtables_error(PARAMETER_PROBLEM,
+			      "Trying to store NULL argument\n");
+
+	store->argv[store->argc] = strdup(what);
+	store->argvattr[store->argc] = quoted;
+	store->argv[++store->argc] = NULL;
 }
 
-void free_argv(void)
+void free_argv(struct argv_store *store)
 {
-	while (newargc)
-		free(newargv[--newargc]);
-	while (oldargc)
-		free(oldargv[--oldargc]);
+	while (store->argc) {
+		store->argc--;
+		free(store->argv[store->argc]);
+		store->argvattr[store->argc] = 0;
+	}
 }
 
 /* Save parsed rule for comparison with next rule to perform action aggregation
  * on duplicate conditions.
  */
-void save_argv(void)
+void save_argv(struct argv_store *dst, struct argv_store *src)
 {
-	unsigned int i;
+	int i;
 
-	while (oldargc)
-		free(oldargv[--oldargc]);
-
-	oldargc = newargc;
-	newargc = 0;
-	for (i = 0; i < oldargc; i++) {
-		oldargv[i] = newargv[i];
+	free_argv(dst);
+	for (i = 0; i < src->argc; i++) {
+		dst->argvattr[i] = src->argvattr[i];
+		dst->argv[i] = src->argv[i];
+		src->argv[i] = NULL;
 	}
+	dst->argc = src->argc;
+	src->argc = 0;
 }
 
 struct xt_param_buf {
@@ -482,7 +474,7 @@ static void add_param(struct xt_param_buf *param, const char *curchar)
 			      "Parameter too long!");
 }
 
-void add_param_to_argv(char *parsestart, int line)
+void add_param_to_argv(struct argv_store *store, char *parsestart, int line)
 {
 	int quote_open = 0, escaped = 0, quoted = 0;
 	struct xt_param_buf param = {};
@@ -546,12 +538,22 @@ void add_param_to_argv(char *parsestart, int line)
 				      line, xt_params->program_name);
 		}
 
-		add_argv(param.buffer, quoted);
+		add_argv(store, param.buffer, quoted);
 		param.len = 0;
 		quoted = 0;
 	}
 }
 
+#ifdef DEBUG
+void debug_print_argv(struct argv_store *store)
+{
+	int i;
+
+	for (i = 0; i < store->argc; i++)
+		fprintf(stderr, "argv[%d]: %s\n", i, store->argv[i]);
+}
+#endif
+
 static const char *ipv4_addr_to_string(const struct in_addr *addr,
 				       const struct in_addr *mask,
 				       unsigned int format)
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 21f4e8fdee67c..64b7e8fc4b690 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -156,18 +156,22 @@ bool xs_has_arg(int argc, char *argv[]);
 
 extern const struct xtables_afinfo *afinfo;
 
-extern char *newargv[];
-extern int newargc;
-
-extern char *oldargv[];
-extern int oldargc;
-
-extern int newargvattr[];
+#define MAX_ARGC	255
+struct argv_store {
+	int argc;
+	char *argv[MAX_ARGC];
+	int argvattr[MAX_ARGC];
+};
 
-int add_argv(const char *what, int quoted);
-void free_argv(void);
-void save_argv(void);
-void add_param_to_argv(char *parsestart, int line);
+void add_argv(struct argv_store *store, const char *what, int quoted);
+void free_argv(struct argv_store *store);
+void save_argv(struct argv_store *dst, struct argv_store *src);
+void add_param_to_argv(struct argv_store *store, char *parsestart, int line);
+#ifdef DEBUG
+void debug_print_argv(struct argv_store *store);
+#else
+#  define debug_print_argv(...) /* nothing */
+#endif
 
 void print_ipv4_addresses(const struct ipt_entry *fw, unsigned int format);
 void print_ipv6_addresses(const struct ip6t_entry *fw6, unsigned int format);
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 1c7d5da52df64..8d6cb7a97ea37 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -73,6 +73,7 @@ void xtables_restore_parse(struct nft_handle *h,
 			   const struct nft_xt_restore_cb *cb)
 {
 	const struct builtin_table *curtable = NULL;
+	struct argv_store av_store = {};
 	char buffer[10240];
 	int in_table = 0;
 
@@ -209,35 +210,29 @@ void xtables_restore_parse(struct nft_handle *h,
 			}
 			ret = 1;
 		} else if (in_table) {
-			int a;
 			char *pcnt = NULL;
 			char *bcnt = NULL;
 			char *parsestart = buffer;
 
-			/* reset the newargv */
-			newargc = 0;
-
-			add_argv(xt_params->program_name, 0);
-			add_argv("-t", 0);
-			add_argv(curtable->name, 0);
+			add_argv(&av_store, xt_params->program_name, 0);
+			add_argv(&av_store, "-t", 0);
+			add_argv(&av_store, curtable->name, 0);
 
 			tokenize_rule_counters(&parsestart, &pcnt, &bcnt, line);
 			if (counters && pcnt && bcnt) {
-				add_argv("--set-counters", 0);
-				add_argv(pcnt, 0);
-				add_argv(bcnt, 0);
+				add_argv(&av_store, "--set-counters", 0);
+				add_argv(&av_store, pcnt, 0);
+				add_argv(&av_store, bcnt, 0);
 			}
 
-			add_param_to_argv(parsestart, line);
+			add_param_to_argv(&av_store, parsestart, line);
 
 			DEBUGP("calling do_command4(%u, argv, &%s, handle):\n",
-				newargc, curtable->name);
-
-			for (a = 0; a < newargc; a++)
-				DEBUGP("argv[%u]: %s\n", a, newargv[a]);
+			       av_store.argc, curtable->name);
+			debug_print_argv(&av_store);
 
-			ret = cb->do_command(h, newargc, newargv,
-					    &newargv[2], true);
+			ret = cb->do_command(h, av_store.argc, av_store.argv,
+					    &av_store.argv[2], true);
 			if (ret < 0) {
 				if (cb->abort)
 					ret = cb->abort(h);
@@ -251,7 +246,7 @@ void xtables_restore_parse(struct nft_handle *h,
 				exit(1);
 			}
 
-			free_argv();
+			free_argv(&av_store);
 			fflush(stdout);
 		}
 		if (p->tablename && curtable &&
-- 
2.23.0

