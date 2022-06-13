Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24B2AC43334
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Jun 2022 19:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241589AbiFMTTw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Jun 2022 15:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239018AbiFMTSI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Jun 2022 15:18:08 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 85EA05537B
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jun 2022 10:28:04 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack-tools 1/2] conntrack: pass command object to nfct_mnl_request()
Date:   Mon, 13 Jun 2022 19:27:58 +0200
Message-Id: <20220613172759.232211-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch comes in preparation for updating the CT_GET command to use
libmnl.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 949ba1f22d0a..615aa01ed6be 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -2039,7 +2039,8 @@ done:
 
 static int nfct_mnl_request(struct nfct_mnl_socket *sock, uint16_t subsys,
 			    int family, uint16_t type, uint16_t flags,
-			    mnl_cb_t cb, const struct nf_conntrack *ct);
+			    mnl_cb_t cb, const struct nf_conntrack *ct,
+			    const struct ct_cmd *cmd);
 
 static int mnl_nfct_delete_cb(const struct nlmsghdr *nlh, void *data)
 {
@@ -2062,7 +2063,7 @@ static int mnl_nfct_delete_cb(const struct nlmsghdr *nlh, void *data)
 
 	res = nfct_mnl_request(modifier_sock, NFNL_SUBSYS_CTNETLINK,
 			       nfct_get_attr_u8(ct, ATTR_ORIG_L3PROTO),
-			       IPCTNL_MSG_CT_DELETE, NLM_F_ACK, NULL, ct);
+			       IPCTNL_MSG_CT_DELETE, NLM_F_ACK, NULL, ct, NULL);
 	if (res < 0)
 		exit_error(OTHER_PROBLEM,
 			   "Operation failed: %s",
@@ -2259,7 +2260,7 @@ static int mnl_nfct_update_cb(const struct nlmsghdr *nlh, void *data)
 		goto destroy_ok;
 
 	res = nfct_mnl_request(modifier_sock, NFNL_SUBSYS_CTNETLINK, cmd->family,
-			       IPCTNL_MSG_CT_NEW, NLM_F_ACK, NULL, tmp);
+			       IPCTNL_MSG_CT_NEW, NLM_F_ACK, NULL, tmp, NULL);
 	if (res < 0) {
 		fprintf(stderr, "Operation failed: %s\n",
 			err2str(errno, CT_UPDATE));
@@ -2267,7 +2268,7 @@ static int mnl_nfct_update_cb(const struct nlmsghdr *nlh, void *data)
 
 	res = nfct_mnl_request(modifier_sock, NFNL_SUBSYS_CTNETLINK, cmd->family,
 			       IPCTNL_MSG_CT_GET, NLM_F_ACK,
-			       mnl_nfct_print_cb, tmp);
+			       mnl_nfct_print_cb, tmp, NULL);
 	if (res < 0) {
 		/* the entry has vanish in middle of the update */
 		if (errno == ENOENT)
@@ -2529,7 +2530,8 @@ nfct_mnl_dump(struct nfct_mnl_socket *sock, uint16_t subsys, uint16_t type,
 }
 
 static int nfct_mnl_talk(struct nfct_mnl_socket *sock,
-			 const struct nlmsghdr *nlh, mnl_cb_t cb)
+			 const struct nlmsghdr *nlh, mnl_cb_t cb,
+			 const struct ct_cmd *cmd)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	int ret;
@@ -2542,12 +2544,13 @@ static int nfct_mnl_talk(struct nfct_mnl_socket *sock,
 	if (ret < 0)
 		return ret;
 
-	return mnl_cb_run(buf, ret, nlh->nlmsg_seq, sock->portid, cb, NULL);
+	return mnl_cb_run(buf, ret, nlh->nlmsg_seq, sock->portid, cb, (void *)cmd);
 }
 
 static int nfct_mnl_request(struct nfct_mnl_socket *sock, uint16_t subsys,
 			    int family, uint16_t type, uint16_t flags,
-			    mnl_cb_t cb, const struct nf_conntrack *ct)
+			    mnl_cb_t cb, const struct nf_conntrack *ct,
+			    const struct ct_cmd *cmd)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
@@ -2561,7 +2564,7 @@ static int nfct_mnl_request(struct nfct_mnl_socket *sock, uint16_t subsys,
 			return err;
 	}
 
-	return nfct_mnl_talk(sock, nlh, cb);
+	return nfct_mnl_talk(sock, nlh, cb, cmd);
 }
 
 #define UNKNOWN_STATS_NUM 4
@@ -3381,7 +3384,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd,
 		res = nfct_mnl_request(sock, NFNL_SUBSYS_CTNETLINK, cmd->family,
 				       IPCTNL_MSG_CT_NEW,
 				       NLM_F_CREATE | NLM_F_ACK | NLM_F_EXCL,
-				       NULL, cmd->tmpl.ct);
+				       NULL, cmd->tmpl.ct, NULL);
 		if (res >= 0)
 			counter++;
 
@@ -3471,7 +3474,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd,
 
 	case CT_FLUSH:
 		res = nfct_mnl_request(sock, NFNL_SUBSYS_CTNETLINK, cmd->family,
-				       IPCTNL_MSG_CT_DELETE, NLM_F_ACK, NULL, NULL);
+				       IPCTNL_MSG_CT_DELETE, NLM_F_ACK, NULL, NULL, NULL);
 
 		fprintf(stderr, "%s v%s (conntrack-tools): ",PROGNAME,VERSION);
 		fprintf(stderr,"connection tracking table has been emptied.\n");
@@ -3594,7 +3597,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd,
 		 */
 		res = nfct_mnl_request(sock, NFNL_SUBSYS_CTNETLINK, AF_UNSPEC,
 				       IPCTNL_MSG_CT_GET_STATS, 0,
-				       nfct_global_stats_cb, NULL);
+				       nfct_global_stats_cb, NULL, NULL);
 
 		/* don't look at /proc, we got the information via ctnetlink */
 		if (res >= 0)
-- 
2.30.2

