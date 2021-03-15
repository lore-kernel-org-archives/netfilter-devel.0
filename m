Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F398C4332E
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Mar 2021 16:56:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0D7B64F38
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Mar 2021 16:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbhCOQzb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Mar 2021 12:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233156AbhCOQzD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Mar 2021 12:55:03 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A0541C06174A
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Mar 2021 09:55:02 -0700 (PDT)
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 62C6D63534;
        Mon, 15 Mar 2021 17:49:36 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     mikhail.sennikovskii@cloud.ionos.com
Subject: [PATCH conntrack 1/6] conntrack: pass command object to callbacks
Date:   Mon, 15 Mar 2021 17:49:24 +0100
Message-Id: <20210315164929.23608-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pass the command object to prepare for batch support.

Move ct_cmd structure definition right at the top of file otherwise
compilation breaks.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 50 ++++++++++++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 23 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 987d936e7ee2..333da0f83453 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -101,6 +101,17 @@ struct ct_tmpl {
 
 static struct ct_tmpl *cur_tmpl;
 
+struct ct_cmd {
+	unsigned int	command;
+	unsigned int	cmd;
+	unsigned int	type;
+	unsigned int	event_mask;
+	int		family;
+	int		protonum;
+	size_t		socketbuffersize;
+	struct ct_tmpl	tmpl;
+};
+
 static int alloc_tmpl_objects(struct ct_tmpl *tmpl)
 {
 	tmpl->ct = nfct_new();
@@ -1843,7 +1854,8 @@ static int event_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nfgenmsg *nfh = mnl_nlmsg_get_payload(nlh);
 	unsigned int op_type = NFCT_O_DEFAULT;
-	struct nf_conntrack *obj = data;
+	struct ct_cmd *cmd = data;
+	struct nf_conntrack *obj = cmd->tmpl.ct;
 	enum nf_conntrack_msg_type type;
 	unsigned int op_flags = 0;
 	struct nf_conntrack *ct;
@@ -1929,10 +1941,11 @@ static int dump_cb(enum nf_conntrack_msg_type type,
 		   struct nf_conntrack *ct,
 		   void *data)
 {
-	char buf[1024];
-	struct nf_conntrack *obj = data;
+	struct ct_cmd *cmd = data;
+	struct nf_conntrack *obj = cmd->tmpl.ct;
 	unsigned int op_type = NFCT_O_DEFAULT;
 	unsigned int op_flags = 0;
+	char buf[1024];
 
 	if (nfct_filter(obj, ct, cur_tmpl))
 		return NFCT_CB_CONTINUE;
@@ -1970,11 +1983,12 @@ static int delete_cb(enum nf_conntrack_msg_type type,
 		     struct nf_conntrack *ct,
 		     void *data)
 {
-	int res;
-	char buf[1024];
-	struct nf_conntrack *obj = data;
+	struct ct_cmd *cmd = data;
+	struct nf_conntrack *obj = cmd->tmpl.ct;
 	unsigned int op_type = NFCT_O_DEFAULT;
 	unsigned int op_flags = 0;
+	char buf[1024];
+	int res;
 
 	if (nfct_filter(obj, ct, cur_tmpl))
 		return NFCT_CB_CONTINUE;
@@ -2125,8 +2139,9 @@ static int update_cb(enum nf_conntrack_msg_type type,
 		     struct nf_conntrack *ct,
 		     void *data)
 {
+	struct ct_cmd *cmd = data;
+	struct nf_conntrack *obj = cmd->tmpl.ct, *tmp;
 	int res;
-	struct nf_conntrack *obj = data, *tmp;
 
 	if (filter_nat(obj, ct) ||
 	    filter_label(ct, cur_tmpl) ||
@@ -2768,17 +2783,6 @@ nfct_set_nat_details(const int opt, struct nf_conntrack *ct,
 
 }
 
-struct ct_cmd {
-	unsigned int	command;
-	unsigned int	cmd;
-	unsigned int	type;
-	unsigned int	event_mask;
-	int		family;
-	int		protonum;
-	size_t		socketbuffersize;
-	struct ct_tmpl	tmpl;
-};
-
 static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 {
 	unsigned int type = 0, event_mask = 0, l4flags = 0, status = 0;
@@ -3123,7 +3127,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 
 		nfct_filter_init(cmd->family, &cmd->tmpl);
 
-		nfct_callback_register(cth, NFCT_T_ALL, dump_cb, cmd->tmpl.ct);
+		nfct_callback_register(cth, NFCT_T_ALL, dump_cb, cmd);
 
 		filter_dump = nfct_filter_dump_create();
 		if (filter_dump == NULL)
@@ -3214,7 +3218,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 
 		nfct_filter_init(cmd->family, &cmd->tmpl);
 
-		nfct_callback_register(cth, NFCT_T_ALL, update_cb, cmd->tmpl.ct);
+		nfct_callback_register(cth, NFCT_T_ALL, update_cb, cmd);
 
 		res = nfct_query(cth, NFCT_Q_DUMP, &cmd->family);
 		nfct_close(ith);
@@ -3229,7 +3233,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 
 		nfct_filter_init(cmd->family, &cmd->tmpl);
 
-		nfct_callback_register(cth, NFCT_T_ALL, delete_cb, cmd->tmpl.ct);
+		nfct_callback_register(cth, NFCT_T_ALL, delete_cb, cmd);
 
 		filter_dump = nfct_filter_dump_create();
 		if (filter_dump == NULL)
@@ -3268,7 +3272,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		if (!cth)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
-		nfct_callback_register(cth, NFCT_T_ALL, dump_cb, cmd->tmpl.ct);
+		nfct_callback_register(cth, NFCT_T_ALL, dump_cb, cmd);
 		res = nfct_query(cth, NFCT_Q_GET, cmd->tmpl.ct);
 		nfct_close(cth);
 		break;
@@ -3373,7 +3377,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 					   strerror(errno));
 				break;
 			}
-			res = mnl_cb_run(buf, res, 0, 0, event_cb, cmd->tmpl.ct);
+			res = mnl_cb_run(buf, res, 0, 0, event_cb, cmd);
 		}
 		mnl_socket_close(sock.mnl);
 		break;
-- 
2.20.1

