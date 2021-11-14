Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13C66C433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 11:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E489560FE8
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 11:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbhKNMCG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Nov 2021 07:02:06 -0500
Received: from mail.netfilter.org ([217.70.188.207]:60840 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235762AbhKNMCD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Nov 2021 07:02:03 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2DDEA6009B
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Nov 2021 12:57:05 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack-tools 1/3] conntrack: pass filter_dump object to nfct_mnl_dump()
Date:   Sun, 14 Nov 2021 12:59:03 +0100
Message-Id: <20211114115905.608546-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In preparation for kernel filtering support for nfct_mnl_dump().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 9e2fa2552f15..1346fa8df338 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -2441,7 +2441,8 @@ static void nfct_mnl_socket_close(void)
 }
 
 static int
-nfct_mnl_dump(uint16_t subsys, uint16_t type, mnl_cb_t cb, uint8_t family)
+nfct_mnl_dump(uint16_t subsys, uint16_t type, mnl_cb_t cb, uint8_t family,
+	      const struct nfct_filter_dump *filter_dump)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
@@ -3190,7 +3191,8 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 
 			res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
 					    IPCTNL_MSG_CT_GET_DYING,
-					    mnl_nfct_dump_cb, cmd->family);
+					    mnl_nfct_dump_cb, cmd->family,
+					    NULL);
 
 			nfct_mnl_socket_close();
 			break;
@@ -3200,7 +3202,8 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 
 			res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
 					    IPCTNL_MSG_CT_GET_UNCONFIRMED,
-					    mnl_nfct_dump_cb, cmd->family);
+					    mnl_nfct_dump_cb, cmd->family,
+					    NULL);
 
 			nfct_mnl_socket_close();
 			break;
@@ -3557,7 +3560,8 @@ try_proc_count:
 
 		res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
 				    IPCTNL_MSG_CT_GET_STATS_CPU,
-				    nfct_stats_cb, AF_UNSPEC);
+				    nfct_stats_cb, AF_UNSPEC,
+				    NULL);
 
 		nfct_mnl_socket_close();
 
@@ -3576,7 +3580,8 @@ try_proc_count:
 
 		res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK_EXP,
 				    IPCTNL_MSG_EXP_GET_STATS_CPU,
-				    nfexp_stats_cb, AF_UNSPEC);
+				    nfexp_stats_cb, AF_UNSPEC,
+				    NULL);
 
 		nfct_mnl_socket_close();
 
-- 
2.30.2

