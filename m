Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A24FC433DB
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Jan 2021 21:26:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCFCD64E0B
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Jan 2021 21:26:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233466AbhA2V0l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Jan 2021 16:26:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233369AbhA2V0h (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Jan 2021 16:26:37 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD81C0613ED
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Jan 2021 13:25:20 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id w1so14956480ejf.11
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Jan 2021 13:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pev26Wl8npqOnE2zS5Mqns+dc9VfXdgx8YoOnh20kfQ=;
        b=E1zF+eS5ZENzAN8uUepEkG1zq/Ru8cFcLiI1pPrZDMAaMYKsy8PKy47+4rUMaODvH2
         +NRNIMB+gWhZIRbF38GdV47Qk6Vv7jCMLpyvupzUB8gCGtF7UokFUT3uCxg5833KF0Rz
         +GlStEzBDH0UbJ/Opot/bJDgIQJIDFQUWqAni7jJT7D9dkXo1bUQy/XMuKsblCy/hdPM
         hmBcyOY/Ufi2tdtQFtcMjdBX8Lgdo9A45vYfGtai9qcGgI4Yc3bv0k8A5XcsJh4tvNYr
         CKXLzp3EM/8R2fOvvjh7NanOl8B1rgVZaewBOa+HPYiFHtfjeEaEuGgA7a6JIjRuRxWG
         DoSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pev26Wl8npqOnE2zS5Mqns+dc9VfXdgx8YoOnh20kfQ=;
        b=G12dbX4VjFunkEpCdu8laQTYguk2CDymo59lKbxjZ4Jp4MlI320Nuk/uTqrtQOc6j2
         UUk/qw+CYi9tnh1z//jXh6Ve3hPgohItL39vfsYWJmItuZZKzM3A8gT+fxPcMjesJMBo
         AHcff1giFTqRZkPZ+oSsdKrx45dNufLwM5XJkkvt/Sp/EcMU8wVQ8smR+OBP8RPweb+q
         Ray7TufFjo4pG7t4dwRPVMZY9BScH4XrvnW4R+QEUBjNGT52FUql2vJUb6x9Ls3iBK5G
         hNAAABiDYgvP+DonxU/ZXQPpT9mL00DIsdc9BLBRm/+UaID7XCmG/A1ad2bvB2lsFpx8
         DGLg==
X-Gm-Message-State: AOAM530ht6r7xgcttT60d6B24L9ACD9mNpPbnrLQpALHEg1k5Wx40sRy
        MturDCPUe88kaLbvZV7HeNNhwzkpoi8L2w==
X-Google-Smtp-Source: ABdhPJw2BU37JAWS82NjEWpfqedC7t3rYeCegmIQ2agxfz0a04wcEKZp4Qd+PusqPlu1Bno0GdgfRw==
X-Received: by 2002:a17:906:52c1:: with SMTP id w1mr6675019ejn.214.1611955518690;
        Fri, 29 Jan 2021 13:25:18 -0800 (PST)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bd4ff.dynamic.kabel-deutschland.de. [95.91.212.255])
        by smtp.gmail.com with ESMTPSA id q2sm5143218edv.93.2021.01.29.13.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 13:25:18 -0800 (PST)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Subject: [PATCH v3 5/8] conntrack: accept commands from file
Date:   Fri, 29 Jan 2021 22:24:49 +0100
Message-Id: <20210129212452.45352-6-mikhail.sennikovskii@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210129212452.45352-1-mikhail.sennikovskii@cloud.ionos.com>
References: <20210129212452.45352-1-mikhail.sennikovskii@cloud.ionos.com>
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

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
---
 src/conntrack.c | 163 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 162 insertions(+), 1 deletion(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 1719ca9..97357b0 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -3648,6 +3648,167 @@ static void ct_cmd_list_parse_argv(struct ct_cmd_list *list,
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
@@ -3664,7 +3825,7 @@ int main(int argc, char *argv[])
 
 	ct_cmd_list_init(&list);
 
-	ct_cmd_list_parse_argv(&list, argc, argv);
+	ct_cmd_list_parse(&list, argc, argv);
 
 	ct_cmd_list_apply(&list, argv[0]);
 
-- 
2.25.1

