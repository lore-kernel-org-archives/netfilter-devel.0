From: Eric Leblond <eric@regit.org>
Subject: [PATCH] netfilter: nftables: fix warning in nft_reject
Date: Mon,  6 Jan 2014 22:19:14 +0100
Message-ID: <1389043154-28415-1-git-send-email-eric@regit.org>
References: <52cb0425.bwwhbZOarZlZjGHg%fengguang.wu@intel.com>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:34385 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702AbaAFVT6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 16:19:58 -0500
In-Reply-To: <52cb0425.bwwhbZOarZlZjGHg%fengguang.wu@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The 0-day testing from Fenguang Wu issued the following warning:
 net/netfilter/nft_reject.c: In function 'nft_reject_eval':
 >> net/netfilter/nft_reject.c:37:14: warning: unused variable 'net' [-Wunused-variable]
      struct net *net = dev_net((pkt->in != NULL) ? pkt->in : pkt->out);

This is due to the fact that if IPv6 is not build the variable is
indeed unused.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Eric Leblond <eric@regit.org>
---
 net/netfilter/nft_reject.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nft_reject.c b/net/netfilter/nft_reject.c
index 0d690d4..c65fbd8 100644
--- a/net/netfilter/nft_reject.c
+++ b/net/netfilter/nft_reject.c
@@ -34,7 +34,9 @@ static void nft_reject_eval(const struct nft_expr *expr,
 			      const struct nft_pktinfo *pkt)
 {
 	struct nft_reject *priv = nft_expr_priv(expr);
+#if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
 	struct net *net = dev_net((pkt->in != NULL) ? pkt->in : pkt->out);
+#endif
 
 	switch (priv->type) {
 	case NFT_REJECT_ICMP_UNREACH:
-- 
1.8.5.2

