Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C00C77B7D
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 May 2023 09:18:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbjERJSU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 May 2023 05:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbjERJST (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 May 2023 05:18:19 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AA2CC2109
        for <netfilter-devel@vger.kernel.org>; Thu, 18 May 2023 02:18:08 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack 2/2] conntrack: do not silence EEXIST error, use NLM_F_EXCL
Date:   Thu, 18 May 2023 11:18:01 +0200
Message-Id: <20230518091803.90494-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230518091803.90494-1-pablo@netfilter.org>
References: <20230518091803.90494-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead of silencing EEXIST error with -A/--add, unset NLM_F_EXCL
netlink flag.

This patch revisits e42ea65e9c93 ("conntrack: introduce new -A
command").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 926213a27efc..b9fcf8e44ee2 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -3219,6 +3219,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd,
 	struct nfct_mnl_socket *modifier_sock = &_modifier_sock;
 	struct nfct_mnl_socket *event_sock = &_event_sock;
 	struct nfct_filter_dump *filter_dump;
+	uint16_t nl_flags = 0;
 	int res = 0;
 
 	switch(cmd->command) {
@@ -3305,14 +3306,15 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd,
 			nfct_set_attr(cmd->tmpl.ct, ATTR_CONNLABELS,
 					xnfct_bitmask_clone(cmd->tmpl.label_modify));
 
+		if (cmd->command == CT_CREATE)
+			nl_flags = NLM_F_EXCL;
+
 		res = nfct_mnl_request(sock, NFNL_SUBSYS_CTNETLINK, cmd->family,
 				       IPCTNL_MSG_CT_NEW,
-				       NLM_F_CREATE | NLM_F_ACK | NLM_F_EXCL,
+				       NLM_F_CREATE | NLM_F_ACK | nl_flags,
 				       NULL, cmd->tmpl.ct, NULL);
 		if (res >= 0)
 			counter++;
-		else if (errno == EEXIST && cmd->command == CT_ADD)
-			res = 0;
 		break;
 
 	case EXP_CREATE:
-- 
2.30.2

