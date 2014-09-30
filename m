From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] mnl: use nft_batch_begin and nft_batch_end from libnftnl
Date: Tue, 30 Sep 2014 19:34:37 +0200
Message-ID: <1412098477-8811-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53154 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbaI3Rdc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:33:32 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use the existing functions in libnftnl to begin and end a batch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c |   25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index b01e91c..bc8b7ea 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -192,33 +192,20 @@ static void nft_batch_continue(void)
 		nft_batch_page_add();
 }
 
-static uint32_t mnl_batch_put(int type)
+uint32_t mnl_batch_begin(void)
 {
-	struct nlmsghdr *nlh;
-	struct nfgenmsg *nfg;
-
-	nlh = mnl_nlmsg_put_header(nft_nlmsg_batch_current());
-	nlh->nlmsg_type = type;
-	nlh->nlmsg_flags = NLM_F_REQUEST;
-	nlh->nlmsg_seq = mnl_seqnum_alloc();
+	uint32_t seq = mnl_seqnum_alloc();
 
-	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
-	nfg->nfgen_family = AF_INET;
-	nfg->version = NFNETLINK_V0;
-	nfg->res_id = NFNL_SUBSYS_NFTABLES;
+	nft_batch_begin(nft_nlmsg_batch_current(), seq);
 	nft_batch_continue();
 
-	return nlh->nlmsg_seq;
-}
-
-uint32_t mnl_batch_begin(void)
-{
-	return mnl_batch_put(NFNL_MSG_BATCH_BEGIN);
+	return seq;
 }
 
 void mnl_batch_end(void)
 {
-	mnl_batch_put(NFNL_MSG_BATCH_END);
+	nft_batch_end(nft_nlmsg_batch_current(), mnl_seqnum_alloc());
+	nft_batch_continue();
 }
 
 bool mnl_batch_ready(void)
-- 
1.7.10.4

