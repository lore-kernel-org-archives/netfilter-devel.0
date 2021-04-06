Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4057CC433ED
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 10:10:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 125C9613C4
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 10:10:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234020AbhDFKKM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 06:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbhDFKKK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 06:10:10 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7A3C061756
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Apr 2021 03:10:02 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id d13so21810956lfg.7
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Apr 2021 03:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=HG9ePvDxZ7TZEk57gHcPqh3jHMZ3qx/wNnyPxSV8f30=;
        b=J4lE7STcKqmuAF5A5SIDmStEncQ+QvmA91Nc06FF8ajv61FC1P9U2mex68vk2iQBKl
         +ALc9mFbUzJG968Z0Dk4LCMpWa7LBTm78N+gzdlqdgx49rJ7DV/Pe42YV/R0rjfsE75w
         0eENjP8Hka3ADbGEqnLdE5KVLfbe/o8yXCi+/kQiOgLhdvvhATYnG1Rt1+2MSlzp6kEx
         o8ulJeZqN8zCnH5UBDBr1vR4k5UCoFRWf3MXWTjRKzupwktsO2SkHgqrUx7w30uU4DhS
         BBgT1O+gBrFwZkRffTD297B3HVy7dQUg2wfoKutfKcpNGn4BvMGXCZ5H1+SeoKLA7YS1
         FIvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HG9ePvDxZ7TZEk57gHcPqh3jHMZ3qx/wNnyPxSV8f30=;
        b=Lh8hV2heH7DCk3bIL8kCwB3R8RuQVNvu8CKVEDykz+QApDCdOg1sFuQ1c0jdSP3Ehg
         cIubBThwursqZc0ATh0MOSSIxo5fvtbNLt3GooOS5bv7VHanOxs5SI1hA07EwyFjDCwI
         UU1rUy/Bo2jv5nOr5EmPib3OOcg5z94unQdgnCr/HxiZEGjV2Kprd6Qn29M+5XWTiQO+
         lMY099rn5hHlI7q/p//GIMMZHliXPkB+/A8qtYk2l5oXJxD/5RR1SqKEodGF+ngCirDa
         XQXAE62x3xpNS9DStP7/n8QAf9NqPcjKR+L5YtYb636LGU4CBRKlJi1Z7vpVsJDL3wFh
         vzMg==
X-Gm-Message-State: AOAM530/AJHqikVxZs68C52vd+55fXwVrf020Jmbxs0Kn6iEhoteMezO
        uwVSrgNG3zEdN8PnAsAUXzOLoxJKg9morVyj
X-Google-Smtp-Source: ABdhPJwbQkM6b/tUXC5MrcbLJO+RteA0dZvmq71tYuJ90Wm8RDY6eX0+P75HLxOBXDnany5HNi2BIw==
X-Received: by 2002:ac2:41d4:: with SMTP id d20mr19782484lfi.213.1617703800686;
        Tue, 06 Apr 2021 03:10:00 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net ([2a00:1fa1:c4fc:25fe:f165:934d:dfbd:8cd3])
        by smtp.gmail.com with ESMTPSA id l7sm2170070lje.30.2021.04.06.03.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 03:10:00 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovskii@ionos.com
Subject: [PATCH v4 2/5] conntrack: accept commands from file
Date:   Tue,  6 Apr 2021 12:09:44 +0200
Message-Id: <20210406100947.57579-3-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210406100947.57579-1-mikhail.sennikovskii@ionos.com>
References: <20210406100947.57579-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This commit implements the --load-file option which
allows processing conntrack commands stored in file.
Most often this would be used as a counter-part for the
-o save option, which outputs conntrack entries
in the format of the conntrack tool options.
This could be useful when one needs to add/update/delete a large
set of ct entries with a single conntrack tool invocation.

Expected syntax is "conntrack --load-file file".
If "-" is given as a file name, stdin is used.
No other commands or options are allowed to be specified
in conjunction with the --load-file command.
It is however possible to specify multiple --load-file file pairs.

Example:
Copy all entries from ct zone 11 to ct zone 12:

conntrack -L -w 11 -o save | sed "s/-w 11/-w 12/g" | \
        conntrack --load-file -

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
---
 src/conntrack.c | 180 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 178 insertions(+), 2 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 6040828..905d3a7 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -615,6 +615,17 @@ static unsigned int addr_valid_flags[ADDR_VALID_FLAGS_MAX] = {
 	CT_OPT_REPL_SRC | CT_OPT_REPL_DST,
 };
 
+#define CT_COMMANDS_LOAD_FILE_ALLOWED ( 0 \
+						| CT_CREATE       \
+						| CT_UPDATE_BIT   \
+						| CT_DELETE       \
+						| CT_FLUSH        \
+						)
+
+static unsigned int cmd_allowed = ~0;
+
+static bool print_stats_allowed = true;
+
 static LIST_HEAD(proto_list);
 
 static struct nfct_labelmap *labelmap;
@@ -1267,6 +1278,9 @@ add_command(unsigned int *cmd, const int newcmd)
 {
 	if (*cmd)
 		exit_error(PARAMETER_PROBLEM, "Invalid commands combination");
+	if (!(cmd_allowed & newcmd))
+		exit_error(PARAMETER_PROBLEM,
+				"Command can not be used in the current mode");
 	*cmd |= newcmd;
 }
 
@@ -2798,7 +2812,7 @@ nfct_set_nat_details(const int opt, struct nf_conntrack *ct,
 
 static int print_stats(const struct ct_cmd *cmd)
 {
-	if (cmd->command && exit_msg[cmd->cmd][0]) {
+	if (print_stats_allowed && cmd->command && exit_msg[cmd->cmd][0]) {
 		fprintf(stderr, "%s v%s (conntrack-tools): ",PROGNAME,VERSION);
 		fprintf(stderr, exit_msg[cmd->cmd], counter);
 		if (counter == 0 && !(cmd->command & (CT_LIST | EXP_LIST)))
@@ -3606,6 +3620,168 @@ static void ct_cmd_list_parse_argv(struct ct_cmd_list *list,
 	ct_cmd_list_add(list, ct_cmd_create(argc, argv));
 }
 
+#define MAX_ARGC	255
+struct argv_store {
+	int argc;
+	char *argv[MAX_ARGC];
+	int argvattr[MAX_ARGC];
+};
+
+/* function adding one argument to store, updating argc
+ * returns if argument added, does not return otherwise */
+static void add_argv(struct argv_store *store, const char *what, int quoted)
+{
+	if (store->argc + 1 >= MAX_ARGC)
+		exit_error(PARAMETER_PROBLEM,
+			      "Parser cannot handle more arguments\n");
+	if (!what)
+		exit_error(PARAMETER_PROBLEM,
+			      "Trying to store NULL argument\n");
+
+	store->argv[store->argc] = strdup(what);
+	store->argvattr[store->argc] = quoted;
+	store->argv[++store->argc] = NULL;
+}
+
+static void free_argv(struct argv_store *store)
+{
+	while (store->argc) {
+		store->argc--;
+		free(store->argv[store->argc]);
+		store->argvattr[store->argc] = 0;
+	}
+}
+
+struct ct_param_buf {
+	char	buffer[1024];
+	int 	len;
+};
+
+static void add_param(struct ct_param_buf *param, const char *curchar)
+{
+	param->buffer[param->len++] = *curchar;
+	if (param->len >= (int)sizeof(param->buffer))
+		exit_error(PARAMETER_PROBLEM, "Parameter too long!");
+}
+
+static void add_param_to_argv(struct argv_store *store, char *parsestart)
+{
+	int quote_open = 0, escaped = 0, quoted = 0;
+	struct ct_param_buf param = {};
+	char *curchar;
+
+	/* After fighting with strtok enough, here's now
+	 * a 'real' parser. According to Rusty I'm now no
+	 * longer a real hacker, but I can live with that */
+
+	for (curchar = parsestart; *curchar; curchar++) {
+		if (quote_open) {
+			if (escaped) {
+				add_param(&param, curchar);
+				escaped = 0;
+				continue;
+			} else if (*curchar == '\\') {
+				escaped = 1;
+				continue;
+			} else if (*curchar == '"') {
+				quote_open = 0;
+			} else {
+				add_param(&param, curchar);
+				continue;
+			}
+		} else {
+			if (*curchar == '"') {
+				quote_open = 1;
+				quoted = 1;
+				continue;
+			}
+		}
+
+		switch (*curchar) {
+		case '"':
+			break;
+		case ' ':
+		case '\t':
+		case '\n':
+			if (!param.len) {
+				/* two spaces? */
+				continue;
+			}
+			break;
+		default:
+			/* regular character, copy to buffer */
+			add_param(&param, curchar);
+			continue;
+		}
+
+		param.buffer[param.len] = '\0';
+		add_argv(store, param.buffer, quoted);
+		param.len = 0;
+		quoted = 0;
+	}
+	if (param.len) {
+		param.buffer[param.len] = '\0';
+		add_argv(store, param.buffer, 0);
+	}
+}
+
+static void ct_cmd_list_parse_line(struct ct_cmd_list *list,
+		const char *progname, char *buffer)
+{
+	struct argv_store store = {};
+
+	/* skip prepended tabs and spaces */
+	for (; *buffer == ' ' || *buffer == '\t'; buffer++);
+
+	if (buffer[0] == '\n'
+			|| buffer[0] == '#')
+		return;
+
+	add_argv(&store, progname, false);
+
+	add_param_to_argv(&store, buffer);
+
+	ct_cmd_list_parse_argv(list, store.argc, store.argv);
+
+	free_argv(&store);
+}
+
+static void ct_cmd_list_parse_file(struct ct_cmd_list *list,
+			   const char *progname,
+			   const char *file_name)
+{
+	char buffer[10240] = {};
+	FILE *file;
+
+	if (!strcmp(file_name, "-"))
+		file_name = "/dev/stdin";
+
+	file = fopen(file_name, "r");
+	if (!file)
+		exit_error(PARAMETER_PROBLEM, NULL,
+					   "Failed to open file %s for reading", file_name);
+
+	while (fgets(buffer, sizeof(buffer), file))
+		ct_cmd_list_parse_line(list, progname, buffer);
+}
+
+static void ct_cmd_list_parse(struct ct_cmd_list *list, int argc, char *argv[])
+{
+	if (argc > 2
+			&& (!strcmp(argv[1], "-R")
+			|| !strcmp(argv[1], "--load-file"))) {
+		int i;
+
+		cmd_allowed = CT_COMMANDS_LOAD_FILE_ALLOWED;
+		print_stats_allowed = false;
+
+		for (i = 2; i < argc; ++i)
+			ct_cmd_list_parse_file(list, argv[0], argv[i]);
+		return;
+	}
+	ct_cmd_list_parse_argv(list, argc, argv);
+}
+
 int main(int argc, char *argv[])
 {
 	struct ct_cmd_list list;
@@ -3622,7 +3798,7 @@ int main(int argc, char *argv[])
 
 	ct_cmd_list_init(&list);
 
-	ct_cmd_list_parse_argv(&list, argc, argv);
+	ct_cmd_list_parse(&list, argc, argv);
 
 	if (ct_cmd_list_apply(&list, argv[0]) < 0)
 		return EXIT_FAILURE;
-- 
2.25.1

