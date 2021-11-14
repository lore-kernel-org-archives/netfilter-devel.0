Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A30CFC433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 11:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C6CB60FE8
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 11:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235895AbhKNMCH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Nov 2021 07:02:07 -0500
Received: from mail.netfilter.org ([217.70.188.207]:60842 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235836AbhKNMCE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Nov 2021 07:02:04 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0EDDF6063A
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Nov 2021 12:57:06 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack-tools 2/3] conntrack: enhance mnl_nfct_dump_cb()
Date:   Sun, 14 Nov 2021 12:59:04 +0100
Message-Id: <20211114115905.608546-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211114115905.608546-1-pablo@netfilter.org>
References: <20211114115905.608546-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add missing features in dump_cb() to mnl_nfct_dump_cb().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 51 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 39 insertions(+), 12 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 1346fa8df338..7d9eddb0f5d1 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -2441,9 +2441,10 @@ static void nfct_mnl_socket_close(void)
 }
 
 static int
-nfct_mnl_dump(uint16_t subsys, uint16_t type, mnl_cb_t cb, uint8_t family,
-	      const struct nfct_filter_dump *filter_dump)
+nfct_mnl_dump(uint16_t subsys, uint16_t type, mnl_cb_t cb,
+	      struct ct_cmd *cmd, const struct nfct_filter_dump *filter_dump)
 {
+	uint8_t family = cmd ? cmd->family : AF_UNSPEC;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 	int res;
@@ -2457,7 +2458,7 @@ nfct_mnl_dump(uint16_t subsys, uint16_t type, mnl_cb_t cb, uint8_t family,
 	res = mnl_socket_recvfrom(sock.mnl, buf, sizeof(buf));
 	while (res > 0) {
 		res = mnl_cb_run(buf, res, nlh->nlmsg_seq, sock.portid,
-					 cb, NULL);
+				 cb, cmd);
 		if (res <= MNL_CB_STOP)
 			break;
 
@@ -2626,6 +2627,9 @@ static int nfct_global_stats_cb(const struct nlmsghdr *nlh, void *data)
 
 static int mnl_nfct_dump_cb(const struct nlmsghdr *nlh, void *data)
 {
+	unsigned int op_type = NFCT_O_DEFAULT;
+	unsigned int op_flags = 0;
+	struct ct_cmd *cmd = data;
 	struct nf_conntrack *ct;
 	char buf[4096];
 
@@ -2635,7 +2639,34 @@ static int mnl_nfct_dump_cb(const struct nlmsghdr *nlh, void *data)
 
 	nfct_nlmsg_parse(nlh, ct);
 
-	nfct_snprintf(buf, sizeof(buf), ct, NFCT_T_UNKNOWN, NFCT_O_DEFAULT, 0);
+	if (nfct_filter(cmd, ct, cur_tmpl)) {
+		nfct_destroy(ct);
+		return MNL_CB_OK;
+	}
+
+	if (output_mask & _O_SAVE) {
+		ct_save_snprintf(buf, sizeof(buf), ct, labelmap, NFCT_T_NEW);
+		goto done;
+	}
+
+	if (output_mask & _O_XML) {
+		op_type = NFCT_O_XML;
+		if (dump_xml_header_done) {
+			dump_xml_header_done = 0;
+			printf("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
+			       "<conntrack>\n");
+		}
+	}
+	if (output_mask & _O_EXT)
+		op_flags = NFCT_OF_SHOW_LAYER3;
+	if (output_mask & _O_KTMS)
+		op_flags |= NFCT_OF_TIMESTAMP;
+	if (output_mask & _O_ID)
+		op_flags |= NFCT_OF_ID;
+
+	nfct_snprintf_labels(buf, sizeof(buf), ct, NFCT_T_UNKNOWN, op_type,
+			     op_flags, labelmap);
+done:
 	printf("%s\n", buf);
 
 	nfct_destroy(ct);
@@ -3191,8 +3222,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 
 			res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
 					    IPCTNL_MSG_CT_GET_DYING,
-					    mnl_nfct_dump_cb, cmd->family,
-					    NULL);
+					    mnl_nfct_dump_cb, cmd, NULL);
 
 			nfct_mnl_socket_close();
 			break;
@@ -3202,8 +3232,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 
 			res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
 					    IPCTNL_MSG_CT_GET_UNCONFIRMED,
-					    mnl_nfct_dump_cb, cmd->family,
-					    NULL);
+					    mnl_nfct_dump_cb, cmd, NULL);
 
 			nfct_mnl_socket_close();
 			break;
@@ -3560,8 +3589,7 @@ try_proc_count:
 
 		res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
 				    IPCTNL_MSG_CT_GET_STATS_CPU,
-				    nfct_stats_cb, AF_UNSPEC,
-				    NULL);
+				    nfct_stats_cb, NULL, NULL);
 
 		nfct_mnl_socket_close();
 
@@ -3580,8 +3608,7 @@ try_proc_count:
 
 		res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK_EXP,
 				    IPCTNL_MSG_EXP_GET_STATS_CPU,
-				    nfexp_stats_cb, AF_UNSPEC,
-				    NULL);
+				    nfexp_stats_cb, NULL, NULL);
 
 		nfct_mnl_socket_close();
 
-- 
2.30.2

