From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables-compat 1/2] iptables-compat: nft: use nft_batch_begin and nft_batch_end from libnftnl
Date: Tue, 30 Sep 2014 19:35:45 +0200
Message-ID: <1412098546-8952-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53329 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbaI3Reu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:34:50 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use the existing functions in libnftnl to begin and end a batch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft.c |   26 +++++---------------------
 1 file changed, 5 insertions(+), 21 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index e3b07e0..8c91e99 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -240,34 +240,18 @@ static int mnl_nft_batch_talk(struct nft_handle *h)
 	return err ? -1 : 0;
 }
 
-static void mnl_nft_batch_put(struct mnl_nlmsg_batch *batch, int type,
-			      uint32_t seq)
+static void mnl_nft_batch_begin(struct mnl_nlmsg_batch *batch, uint32_t seq)
 {
-	struct nlmsghdr *nlh;
-	struct nfgenmsg *nfg;
-
-	nlh = mnl_nlmsg_put_header(mnl_nlmsg_batch_current(batch));
-	nlh->nlmsg_type = type;
-	nlh->nlmsg_flags = NLM_F_REQUEST;
-	nlh->nlmsg_seq = seq;
-
-	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
-	nfg->nfgen_family = AF_INET;
-	nfg->version = NFNETLINK_V0;
-	nfg->res_id = NFNL_SUBSYS_NFTABLES;
-
+	nft_batch_begin(mnl_nlmsg_batch_current(batch), seq);
 	if (!mnl_nlmsg_batch_next(batch))
 		mnl_nft_batch_page_add(batch);
 }
 
-static void mnl_nft_batch_begin(struct mnl_nlmsg_batch *batch, uint32_t seq)
-{
-	mnl_nft_batch_put(batch, NFNL_MSG_BATCH_BEGIN, seq);
-}
-
 static void mnl_nft_batch_end(struct mnl_nlmsg_batch *batch, uint32_t seq)
 {
-	mnl_nft_batch_put(batch, NFNL_MSG_BATCH_END, seq);
+	nft_batch_end(mnl_nlmsg_batch_current(batch), seq);
+	if (!mnl_nlmsg_batch_next(batch))
+		mnl_nft_batch_page_add(batch);
 }
 
 enum obj_update_type {
-- 
1.7.10.4

