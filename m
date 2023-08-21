Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBEE8EE4993
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Aug 2023 12:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbjHUMBS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Aug 2023 08:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234175AbjHUMBS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2023 08:01:18 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4DF2B90
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Aug 2023 05:01:13 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack] conntrack: do not set on NLM_F_ACK in IPCTNL_MSG_CT_GET requests
Date:   Mon, 21 Aug 2023 14:01:05 +0200
Message-Id: <20230821120105.29538-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

GET requests report either error via NLMSG_ERROR or the corresponding
entry, therefore, there is always a reply from the kernel.

The NLM_F_ACK flag results in two netlink messages as reply in case of
success for GET requests, one containing the entry and another with the
explicit acknowledgment.

nfct_mnl_request() leaves the explicit acknowledment in the buffer,
filling it up with unhandled netlink messages, leading to the following
error:

 conntrack v1.4.7 (conntrack-tools): Operation failed: No buffer space available

Fixes: b7a396b70015 ("conntrack: use libmnl for updating conntrack table")
Reported-by: Tony He <huangya90@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 20aeed52da0f..d95d3edee4f3 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -2202,7 +2202,7 @@ static int mnl_nfct_update_cb(const struct nlmsghdr *nlh, void *data)
 
 	res = nfct_mnl_request(modifier_sock, NFNL_SUBSYS_CTNETLINK,
 			       nfct_get_attr_u8(ct, ATTR_ORIG_L3PROTO),
-			       IPCTNL_MSG_CT_GET, NLM_F_ACK,
+			       IPCTNL_MSG_CT_GET, 0,
 			       mnl_nfct_print_cb, tmp, NULL);
 	if (res < 0) {
 		/* the entry has vanish in middle of the update */
@@ -3389,7 +3389,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd,
 
 	case CT_GET:
 		res = nfct_mnl_request(sock, NFNL_SUBSYS_CTNETLINK, cmd->family,
-				       IPCTNL_MSG_CT_GET, NLM_F_ACK,
+				       IPCTNL_MSG_CT_GET, 0,
 				       mnl_nfct_dump_cb, cmd->tmpl.ct, cmd);
 		break;
 
-- 
2.30.2

