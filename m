Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32C0EC433DB
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Jan 2021 21:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6F3264E06
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Jan 2021 21:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233272AbhA2V0Q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Jan 2021 16:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233454AbhA2VZ7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Jan 2021 16:25:59 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3690AC0613D6
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Jan 2021 13:25:19 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id z22so12212745edb.9
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Jan 2021 13:25:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n8vJceBMMYCQ8JIumv0N1HCIgk6n9/a9VY0by/5BQqo=;
        b=CnAJcp4dm8WFBkJP5G/+XdbBhXbVZrGqSAZEpK3UqJiBRGB+jan4es5Qsld3LZSmJD
         2TRGKhpno8hHHcKXwirs2BLdsUAxzNqKAIZ8RqxAj+CkhfBiBLB3yBLPZChfV4hpRcsQ
         DjRk+DDdCGny1qFvsT1SfJ6+HDNlrFaHKRAM6FswaGESrJjniEzUV5RAowh50+EOwZj7
         3JjKqOMSeOJFGTe2TAl4JmaCcZt77/cRWs9Aq49H5S5Kr6RP9lw+3YJojg05bHGbeon2
         KzQMPoXNSm6RlSBGeUpmFtQIJsqdM8uKdLtX0lmUFayq7QYGXeO0T7WH8WPuA/GyTYUj
         zJng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n8vJceBMMYCQ8JIumv0N1HCIgk6n9/a9VY0by/5BQqo=;
        b=fupxX+yEMXXExIr5BTh5VDupLWGVOlVXXuavKW616zp4h5KSZSbDTtupuYl6Uch4Sj
         tEvL/MWtNm4lMGOzi5IpgmMrX3D7/FZQEUdsK8v5PCFYQbuy5AIDjUwKn/3tCyd91kxf
         Mq1RHIPG7hDc5HY8T/xz4QcfXVCeb/nR79Z4JIcQlsRFX7mu5DjFmzFweAjPxVodCd3a
         U0Z3yTQB1Cu6So1tj1GvnVW3xi2t6QIEZZrqohoThQJlYtQqZseRd5CkTnlq8JKgzM7W
         Y8gq3FMVglvPharsGChY5ONR3PoyRZmdAMqGbfhJYdYcdhgKPBYpsaKLzDElKkQpP/0t
         tcIA==
X-Gm-Message-State: AOAM5318WRYmgzWF2JfPRljlZ+O8k1/tk0UXIN46BfGnsWCqPzOyoPHG
        y3acJfm+Hr1REDUU5jYVWDeXU4WQB/fZxg==
X-Google-Smtp-Source: ABdhPJxIxk8MBPfA0JDLK5XM1QyAtvyqyVAp/VuUHAeN4lHNxvxdzuCgBVEn1jJG4fiqvPbKS0z4zg==
X-Received: by 2002:a05:6402:2288:: with SMTP id cw8mr7333813edb.161.1611955517782;
        Fri, 29 Jan 2021 13:25:17 -0800 (PST)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bd4ff.dynamic.kabel-deutschland.de. [95.91.212.255])
        by smtp.gmail.com with ESMTPSA id q2sm5143218edv.93.2021.01.29.13.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 13:25:17 -0800 (PST)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Subject: [PATCH v3 4/8] conntrack: introduce ct_cmd_list
Date:   Fri, 29 Jan 2021 22:24:48 +0100
Message-Id: <20210129212452.45352-5-mikhail.sennikovskii@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210129212452.45352-1-mikhail.sennikovskii@cloud.ionos.com>
References: <20210129212452.45352-1-mikhail.sennikovskii@cloud.ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

As a multicommand support preparation, add support for the
ct_cmd_list, which represents a list of ct_cmd elements.
Currently only a single entry generated from the command line
arguments is created.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
---
 src/conntrack.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 66 insertions(+), 3 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 4783825..1719ca9 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -598,6 +598,19 @@ static unsigned int addr_valid_flags[ADDR_VALID_FLAGS_MAX] = {
 	CT_OPT_REPL_SRC | CT_OPT_REPL_DST,
 };
 
+#define CT_COMMANDS_LOAD_FILE_ALLOWED ( 0 \
+						| CT_CREATE       \
+						| CT_UPDATE_BIT   \
+						| CT_DELETE       \
+						| CT_FLUSH        \
+						| EXP_CREATE      \
+						| EXP_DELETE      \
+						| EXP_FLUSH       \
+						)
+
+static unsigned int cmd_allowed = ~0;
+
+
 static LIST_HEAD(proto_list);
 
 static struct nfct_labelmap *labelmap;
@@ -1250,6 +1263,9 @@ add_command(unsigned int *cmd, const int newcmd)
 {
 	if (*cmd)
 		exit_error(PARAMETER_PROBLEM, "Invalid commands combination");
+	if (!(cmd_allowed & newcmd))
+		exit_error(PARAMETER_PROBLEM,
+				"Command can not be used in the current mode");
 	*cmd |= newcmd;
 }
 
@@ -1472,6 +1488,10 @@ struct ct_cmd {
 	struct ct_tmpl	tmpl;
 };
 
+struct ct_cmd_list {
+	struct list_head list;
+};
+
 static int
 filter_label(const struct nf_conntrack *ct, const struct ct_tmpl *tmpl)
 {
@@ -3155,6 +3175,19 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 	ct_cmd->socketbuffersize = socketbuffersize;
 }
 
+static struct ct_cmd *ct_cmd_create(int argc, char *argv[])
+{
+	struct ct_cmd *ct_cmd;
+
+	ct_cmd = calloc(1, sizeof(*ct_cmd));
+	if (!ct_cmd)
+		exit_error(OTHER_PROBLEM, "cmd alloc failed!!");
+
+	do_parse(ct_cmd, argc, argv);
+
+	return ct_cmd;
+}
+
 static void do_command_ct(const char *progname, struct ct_cmd *cmd)
 {
 	struct nfct_filter_dump *filter_dump;
@@ -3587,9 +3620,37 @@ try_proc:
 		nfct_labelmap_destroy(labelmap);
 }
 
+static void ct_cmd_list_init(struct ct_cmd_list *list)
+{
+	memset(list, 0, sizeof(*list));
+	INIT_LIST_HEAD(&list->list);
+}
+
+static void ct_cmd_list_add(struct ct_cmd_list *list, struct ct_cmd *cmd)
+{
+	list_add_tail(&cmd->list_entry, &list->list);
+}
+
+static void ct_cmd_list_apply(struct ct_cmd_list *list, const char *progname)
+{
+	struct ct_cmd *cmd, *tmp;
+
+	list_for_each_entry_safe(cmd, tmp, &list->list, list_entry) {
+		list_del(&cmd->list_entry);
+		do_command_ct(progname, cmd);
+		free(cmd);
+	}
+}
+
+static void ct_cmd_list_parse_argv(struct ct_cmd_list *list,
+		int argc, char *argv[])
+{
+	ct_cmd_list_add(list, ct_cmd_create(argc, argv));
+}
+
 int main(int argc, char *argv[])
 {
-	struct ct_cmd _cmd = {}, *cmd = &_cmd;
+	struct ct_cmd_list list;
 
 	register_tcp();
 	register_udp();
@@ -3601,9 +3662,11 @@ int main(int argc, char *argv[])
 	register_gre();
 	register_unknown();
 
-	do_parse(cmd, argc, argv);
+	ct_cmd_list_init(&list);
+
+	ct_cmd_list_parse_argv(&list, argc, argv);
 
-	do_command_ct(argv[0], cmd);
+	ct_cmd_list_apply(&list, argv[0]);
 
 	return print_cmd_counters();
 }
-- 
2.25.1

