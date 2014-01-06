From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nftables] netfilter: nft_reject: fix compilation warning if NF_TABLES_IPV6 is disabled
Date: Mon,  6 Jan 2014 21:09:16 +0100
Message-ID: <1389038956-5125-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59109 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806AbaAFUJY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 15:09:24 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

net/netfilter/nft_reject.c: In function 'nft_reject_eval':
net/netfilter/nft_reject.c:37:14: warning: unused variable 'net' [-Wunused-variable]

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_reject.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_reject.c b/net/netfilter/nft_reject.c
index 0d690d4..7ae63cd 100644
--- a/net/netfilter/nft_reject.c
+++ b/net/netfilter/nft_reject.c
@@ -34,8 +34,9 @@ static void nft_reject_eval(const struct nft_expr *expr,
 			      const struct nft_pktinfo *pkt)
 {
 	struct nft_reject *priv = nft_expr_priv(expr);
+#if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
 	struct net *net = dev_net((pkt->in != NULL) ? pkt->in : pkt->out);
-
+#endif
 	switch (priv->type) {
 	case NFT_REJECT_ICMP_UNREACH:
 		if (priv->family == NFPROTO_IPV4)
-- 
1.7.10.4

