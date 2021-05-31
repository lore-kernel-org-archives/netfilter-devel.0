Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CA34C47080
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 May 2021 22:18:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D5316135C
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 May 2021 22:18:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbhEaWUE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 May 2021 18:20:04 -0400
Received: from mail.netfilter.org ([217.70.188.207]:37714 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232320AbhEaWUD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 May 2021 18:20:03 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7662564175;
        Tue,  1 Jun 2021 00:17:16 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     kadlec@netfilter.org
Subject: [PATCH ipset 1/3] lib: split parser from command execution
Date:   Tue,  1 Jun 2021 00:18:16 +0200
Message-Id: <20210531221818.24867-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

ipset_parse_argv() parses, builds and send the netlink messages to the
kernel. This patch extracts the parser and wrap it around the new
ipset_parser() function.

This patch comes is preparation for the ipset to nftables translation
infrastructure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 lib/ipset.c | 44 ++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/lib/ipset.c b/lib/ipset.c
index 672991965770..3077f9793f84 100644
--- a/lib/ipset.c
+++ b/lib/ipset.c
@@ -923,20 +923,8 @@ static const char *cmd_prefix[] = {
 	[IPSET_TEST]   = "test   SETNAME",
 };
 
-/* Workhorses */
-
-/**
- * ipset_parse_argv - parse and argv array and execute the command
- * @ipset: ipset structure
- * @argc: length of the array
- * @argv: array of strings
- *
- * Parse an array of strings and execute the ipset command.
- *
- * Returns 0 on success or a negative error code.
- */
-int
-ipset_parse_argv(struct ipset *ipset, int oargc, char *oargv[])
+static int
+ipset_parser(struct ipset *ipset, int oargc, char *oargv[])
 {
 	int ret = 0;
 	enum ipset_cmd cmd = IPSET_CMD_NONE;
@@ -1280,6 +1268,34 @@ ipset_parse_argv(struct ipset *ipset, int oargc, char *oargv[])
 	if (argc > 1)
 		return ipset->custom_error(ipset, p, IPSET_PARAMETER_PROBLEM,
 			"Unknown argument %s", argv[1]);
+
+	return cmd;
+}
+
+/* Workhorses */
+
+/**
+ * ipset_parse_argv - parse and argv array and execute the command
+ * @ipset: ipset structure
+ * @argc: length of the array
+ * @argv: array of strings
+ *
+ * Parse an array of strings and execute the ipset command.
+ *
+ * Returns 0 on success or a negative error code.
+ */
+int
+ipset_parse_argv(struct ipset *ipset, int oargc, char *oargv[])
+{
+	struct ipset_session *session = ipset->session;
+	void *p = ipset_session_printf_private(session);
+	enum ipset_cmd cmd;
+	int ret;
+
+	cmd = ipset_parser(ipset, oargc, oargv);
+	if (cmd < 0)
+		return cmd;
+
 	ret = ipset_cmd(session, cmd, ipset->restore_line);
 	D("ret %d", ret);
 	/* In the case of warning, the return code is success */
-- 
2.20.1

