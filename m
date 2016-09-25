From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 11/53] netfilter: nft_queue: check the validation of queues_total and queuenum
Date: Mon, 26 Sep 2016 01:06:21 +0200
Message-ID: <1474844823-2026-12-git-send-email-pablo@netfilter.org>
References: <1474844823-2026-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1474844823-2026-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Liping Zhang <liping.zhang@spreadtrum.com>

Although the validation of queues_total and queuenum is checked in nft
utility, but user can add nft rules via nfnetlink, so it is necessary
to check the validation at the nft_queue expr init routine too.

Tested by run ./nft-test.py any/queue.t:
  any/queue.t: 6 unit tests, 0 error, 0 warning

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_queue.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/netfilter/nft_queue.c b/net/netfilter/nft_queue.c
index 61d216eb7917..d16d59959ff6 100644
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
2.1.4
