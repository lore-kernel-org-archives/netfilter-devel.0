Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85B7BC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Jun 2022 19:18:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345945AbiFMTSM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Jun 2022 15:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345600AbiFMTRi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Jun 2022 15:17:38 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 85EF75537C
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jun 2022 10:28:04 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack-tools 2/2] conntrack: update CT_GET to use libmnl
Date:   Mon, 13 Jun 2022 19:27:59 +0200
Message-Id: <20220613172759.232211-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220613172759.232211-1-pablo@netfilter.org>
References: <20220613172759.232211-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use nfct_mnl_request() to build and send the netlink command. Remove
dump_cb() since this is a copy of the new libmnl's mnl_nfct_dump_cb()
callback function.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 51 +++----------------------------------------------
 1 file changed, 3 insertions(+), 48 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 615aa01ed6be..82534ec9fb02 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -1996,47 +1996,6 @@ out:
 	return MNL_CB_OK;
 }
 
-static int dump_cb(enum nf_conntrack_msg_type type,
-		   struct nf_conntrack *ct,
-		   void *data)
-{
-	unsigned int op_type = NFCT_O_DEFAULT;
-	unsigned int op_flags = 0;
-	struct ct_cmd *cmd = data;
-	char buf[1024];
-
-	if (nfct_filter(cmd, ct, cur_tmpl))
-		return NFCT_CB_CONTINUE;
-
-	if (output_mask & _O_SAVE) {
-		ct_save_snprintf(buf, sizeof(buf), ct, labelmap, NFCT_T_NEW);
-		goto done;
-	}
-
-	if (output_mask & _O_XML) {
-		op_type = NFCT_O_XML;
-		if (dump_xml_header_done) {
-			dump_xml_header_done = 0;
-			printf("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
-			       "<conntrack>\n");
-		}
-	}
-	if (output_mask & _O_EXT)
-		op_flags = NFCT_OF_SHOW_LAYER3;
-	if (output_mask & _O_KTMS)
-		op_flags |= NFCT_OF_TIMESTAMP;
-	if (output_mask & _O_ID)
-		op_flags |= NFCT_OF_ID;
-
-	nfct_snprintf_labels(buf, sizeof(buf), ct, NFCT_T_UNKNOWN, op_type, op_flags, labelmap);
-done:
-	printf("%s\n", buf);
-
-	counter++;
-
-	return NFCT_CB_CONTINUE;
-}
-
 static int nfct_mnl_request(struct nfct_mnl_socket *sock, uint16_t subsys,
 			    int family, uint16_t type, uint16_t flags,
 			    mnl_cb_t cb, const struct nf_conntrack *ct,
@@ -3451,13 +3410,9 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd,
 		break;
 
 	case CT_GET:
-		cth = nfct_open(CONNTRACK, 0);
-		if (!cth)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
-
-		nfct_callback_register(cth, NFCT_T_ALL, dump_cb, cmd);
-		res = nfct_query(cth, NFCT_Q_GET, cmd->tmpl.ct);
-		nfct_close(cth);
+		res = nfct_mnl_request(sock, NFNL_SUBSYS_CTNETLINK, cmd->family,
+				       IPCTNL_MSG_CT_GET, NLM_F_ACK,
+				       mnl_nfct_dump_cb, cmd->tmpl.ct, cmd);
 		break;
 
 	case EXP_GET:
-- 
2.30.2

