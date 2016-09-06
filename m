From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next] netfilter: nft_queue: check the validation of queues_total and queuenum
Date: Tue,  6 Sep 2016 22:33:37 +0800
Message-ID: <1473172417-8311-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-15.163.com ([220.181.12.15]:57174 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756624AbcIFOeq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Sep 2016 10:34:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Although the validation of queues_total and queuenum is checked in nft
utility, but user can add nft rules via nfnetlink, so it is necessary
to check the validation at the nft_queue expr init routine too.

Tested by run ./nft-test.py any/queue.t:
  any/queue.t: 6 unit tests, 0 error, 0 warning

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/nft_queue.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/netfilter/nft_queue.c b/net/netfilter/nft_queue.c
index 61d216e..d16d599 100644
--- a/net/netfilter/nft_queue.c
+++ b/net/netfilter/nft_queue.c
@@ -65,6 +65,7 @@ static int nft_queue_init(const struct nft_ctx *ctx,
 			   const struct nlattr * const tb[])
 {
 	struct nft_queue *priv = nft_expr_priv(expr);
+	u32 maxid;
 
 	if (tb[NFTA_QUEUE_NUM] == NULL)
 		return -EINVAL;
@@ -74,6 +75,16 @@ static int nft_queue_init(const struct nft_ctx *ctx,
 
 	if (tb[NFTA_QUEUE_TOTAL] != NULL)
 		priv->queues_total = ntohs(nla_get_be16(tb[NFTA_QUEUE_TOTAL]));
+	else
+		priv->queues_total = 1;
+
+	if (priv->queues_total == 0)
+		return -EINVAL;
+
+	maxid = priv->queues_total - 1 + priv->queuenum;
+	if (maxid > U16_MAX)
+		return -ERANGE;
+
 	if (tb[NFTA_QUEUE_FLAGS] != NULL) {
 		priv->flags = ntohs(nla_get_be16(tb[NFTA_QUEUE_FLAGS]));
 		if (priv->flags & ~NFT_QUEUE_FLAG_MASK)
-- 
2.5.5


