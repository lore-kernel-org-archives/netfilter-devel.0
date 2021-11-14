Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23EEFC433FE
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 11:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF16560F21
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 11:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235762AbhKNMCG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Nov 2021 07:02:06 -0500
Received: from mail.netfilter.org ([217.70.188.207]:60844 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235895AbhKNMCE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Nov 2021 07:02:04 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 91FC56063B
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Nov 2021 12:57:06 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack-tools 3/3] conntrack: use libmnl for listing conntrack table
Date:   Sun, 14 Nov 2021 12:59:05 +0100
Message-Id: <20211114115905.608546-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211114115905.608546-1-pablo@netfilter.org>
References: <20211114115905.608546-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use libmnl and libnetfilter_conntrack mnl helpers to dump the conntrack
table entries.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 7d9eddb0f5d1..5bd3cb56b641 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -2451,6 +2451,9 @@ nfct_mnl_dump(uint16_t subsys, uint16_t type, mnl_cb_t cb,
 
 	nlh = nfct_mnl_nlmsghdr_put(buf, subsys, type, family);
 
+	if (filter_dump)
+		nfct_nlmsg_build_filter(nlh, filter_dump);
+
 	res = mnl_socket_sendto(sock.mnl, nlh, nlh->nlmsg_len);
 	if (res < 0)
 		return res;
@@ -3216,32 +3219,23 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 
 	switch(cmd->command) {
 	case CT_LIST:
-		if (cmd->type == CT_TABLE_DYING) {
-			if (nfct_mnl_socket_open(0) < 0)
-				exit_error(OTHER_PROBLEM, "Can't open handler");
+		if (nfct_mnl_socket_open(0) < 0)
+			exit_error(OTHER_PROBLEM, "Can't open handler");
 
+		if (cmd->type == CT_TABLE_DYING) {
 			res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
 					    IPCTNL_MSG_CT_GET_DYING,
 					    mnl_nfct_dump_cb, cmd, NULL);
-
 			nfct_mnl_socket_close();
 			break;
 		} else if (cmd->type == CT_TABLE_UNCONFIRMED) {
-			if (nfct_mnl_socket_open(0) < 0)
-				exit_error(OTHER_PROBLEM, "Can't open handler");
-
 			res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
 					    IPCTNL_MSG_CT_GET_UNCONFIRMED,
 					    mnl_nfct_dump_cb, cmd, NULL);
-
 			nfct_mnl_socket_close();
 			break;
 		}
 
-		cth = nfct_open(CONNTRACK, 0);
-		if (!cth)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
-
 		if (cmd->options & CT_COMPARISON &&
 		    cmd->options & CT_OPT_ZERO)
 			exit_error(PARAMETER_PROBLEM, "Can't use -z with "
@@ -3249,8 +3243,6 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 
 		nfct_filter_init(cmd);
 
-		nfct_callback_register(cth, NFCT_T_ALL, dump_cb, cmd);
-
 		filter_dump = nfct_filter_dump_create();
 		if (filter_dump == NULL)
 			exit_error(OTHER_PROBLEM, "OOM");
@@ -3268,11 +3260,15 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 						  NFCT_FILTER_DUMP_STATUS,
 						  &cmd->tmpl.filter_status_kernel);
 		}
-		if (cmd->options & CT_OPT_ZERO)
-			res = nfct_query(cth, NFCT_Q_DUMP_FILTER_RESET,
-					filter_dump);
-		else
-			res = nfct_query(cth, NFCT_Q_DUMP_FILTER, filter_dump);
+		if (cmd->options & CT_OPT_ZERO) {
+			res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
+					    IPCTNL_MSG_CT_GET_CTRZERO,
+					    mnl_nfct_dump_cb, cmd, filter_dump);
+		} else {
+			res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
+					    IPCTNL_MSG_CT_GET,
+					    mnl_nfct_dump_cb, cmd, filter_dump);
+		}
 
 		nfct_filter_dump_destroy(filter_dump);
 
@@ -3281,7 +3277,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 			fflush(stdout);
 		}
 
-		nfct_close(cth);
+		nfct_mnl_socket_close();
 		break;
 
 	case EXP_LIST:
-- 
2.30.2

