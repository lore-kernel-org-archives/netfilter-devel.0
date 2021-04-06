Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CECDEC433B4
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 10:10:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A198E613CA
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 10:10:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234059AbhDFKKL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 06:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234020AbhDFKKJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 06:10:09 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DEBFC06174A
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Apr 2021 03:10:01 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id u10so15822307lju.7
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Apr 2021 03:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ibuIUFVCYnPD8EoITbJczY4GHq1E2Xtkc3zE0eg0b5w=;
        b=OyH3JX/jCwz0P0oZFLh/dviRExxP3vwp3nhGCVSC9HgE9QAyfQ0yxPYEubb5p4vGNa
         UMUvZh4ghKBAJjDyamohjfd3Z9W4O89XIwFtpNBfuIhRUc8qPsxVugqm0k/+S2TZOTul
         /llAk1ykxBfptp+ib+07tj2zmZQyvOFYcrVEU8ttq/NuALghBSGhnBfuB8DINvKwvsID
         aiOugwE7DgPIISzj9jQJ0tSvxiovzRhnErlO8UnEVgAnba+n4X7C850uMDd3v+Ovg2tj
         ai3xGbdhuaH6kHtyloZIdyXWNehiQBfVmSe9ufH+I6JqW5UNdYk8KmzUDFcPJpwULllu
         PePw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ibuIUFVCYnPD8EoITbJczY4GHq1E2Xtkc3zE0eg0b5w=;
        b=rTPinjU7HUMR4S8JOnp+STb10JRcCLOLVUf5iH7PnaY/FH2WDGnIG1XYsM4C8vKAQB
         qPmOZ9oAnpz2W/iE1QLpXoI8ePJRNTkBMhySDjUS4w60QmTUHqoZwjg+T/rxRE07gjcL
         K713POO2nUaYHlQHb8OEpaYiCXdGUT9xG3Z56pbBT0VWMuuKDwtJZV+dWlD6qB0UKBUm
         X87FAXTf0ByInL5USQd/O6uHzWhUdPTLxvcvJA1EKO8/v3GOakTZFofgMb8p5NE3LLzr
         RKM4Kdo/QpK2TUJzqgQ5t2z1uigc5T3gtQ5InYIaIUcIRKh0gpMPqklFsMNqMhoPO4yU
         SSYw==
X-Gm-Message-State: AOAM531oQI7SBufGo2ZZLbUf/GgJu6bJgElPTSwRQropaRJs5OvM/8z2
        NZumiEbDvyP2NnyV6NBj7m/rbK0j6WACG2pu
X-Google-Smtp-Source: ABdhPJxi+CdV7/Ik7Nu9awrL8k0wp5/x2EIcFl1BbdriOxhsaSiSH+Q5oKsN+YxxLO+4T4icBMoatg==
X-Received: by 2002:a2e:924e:: with SMTP id v14mr19026816ljg.362.1617703799838;
        Tue, 06 Apr 2021 03:09:59 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net ([2a00:1fa1:c4fc:25fe:f165:934d:dfbd:8cd3])
        by smtp.gmail.com with ESMTPSA id l7sm2170070lje.30.2021.04.06.03.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 03:09:59 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovskii@ionos.com
Subject: [PATCH v4 1/5] conntrack: introduce ct_cmd_list
Date:   Tue,  6 Apr 2021 12:09:43 +0200
Message-Id: <20210406100947.57579-2-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210406100947.57579-1-mikhail.sennikovskii@ionos.com>
References: <20210406100947.57579-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

As a load from file support preparation, introduce a
ct_cmd_list, which represents a list of ct_cmd elements.
Currently only a single entry is generated for the command line
processing.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
---
 src/conntrack.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 68 insertions(+), 4 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 4bc340f..6040828 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -102,6 +102,7 @@ struct ct_tmpl {
 static struct ct_tmpl *cur_tmpl;
 
 struct ct_cmd {
+	struct list_head list_entry;
 	unsigned int	command;
 	unsigned int	cmd;
 	unsigned int	type;
@@ -113,6 +114,10 @@ struct ct_cmd {
 	struct ct_tmpl	tmpl;
 };
 
+struct ct_cmd_list {
+	struct list_head list;
+};
+
 static int alloc_tmpl_objects(struct ct_tmpl *tmpl)
 {
 	tmpl->ct = nfct_new();
@@ -2823,6 +2828,8 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 
 	/* disable explicit missing arguments error output from getopt_long */
 	opterr = 0;
+	/* reset optind, for the case do_parse is called multiple times */
+	optind = 0;
 
 	while ((c = getopt_long(argc, argv, getopt_str, opts, NULL)) != -1) {
 	switch(c) {
@@ -3543,9 +3550,65 @@ try_proc:
 	return EXIT_SUCCESS;
 }
 
+static int ct_cmd_process(struct ct_cmd *ct_cmd, const char *progname)
+{
+	int res;
+
+	res = do_command_ct(progname, ct_cmd);
+	if (res < 0)
+		return res;
+
+	return print_stats(ct_cmd);
+}
+
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
+static int ct_cmd_list_apply(struct ct_cmd_list *list, const char *progname)
+{
+	int res = 0;
+	struct ct_cmd *cmd, *tmp;
+
+	list_for_each_entry_safe(cmd, tmp, &list->list, list_entry) {
+		list_del(&cmd->list_entry);
+		res |= ct_cmd_process(cmd, progname);
+
+		free(cmd);
+	}
+
+	return res;
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
@@ -3557,10 +3620,11 @@ int main(int argc, char *argv[])
 	register_gre();
 	register_unknown();
 
-	do_parse(cmd, argc, argv);
-	do_command_ct(argv[0], cmd);
+	ct_cmd_list_init(&list);
+
+	ct_cmd_list_parse_argv(&list, argc, argv);
 
-	if (print_stats(cmd) < 0)
+	if (ct_cmd_list_apply(&list, argv[0]) < 0)
 		return EXIT_FAILURE;
 
 	return EXIT_SUCCESS;
-- 
2.25.1

