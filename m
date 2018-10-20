From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 08/10] netfilter: remove two unused variables.
Date: Sat, 20 Oct 2018 11:43:15 +0200
Message-ID: <20181020094317.16011-9-pablo@netfilter.org>
References: <20181020094317.16011-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181020094317.16011-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Weongyo Jeong <weongyo.linux@gmail.com>

nft_dup_netdev_ingress_ops and nft_fwd_netdev_ingress_ops variables are
no longer used at the code.

Signed-off-by: Weongyo Jeong <weongyo.linux@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_dup_netdev.c | 2 --
 net/netfilter/nft_fwd_netdev.c | 4 ----
 2 files changed, 6 deletions(-)

diff --git a/net/netfilter/nft_dup_netdev.c b/net/netfilter/nft_dup_netdev.c
index 2cc1e0ef56e8..15cc62b293d6 100644
--- a/net/netfilter/nft_dup_netdev.c
+++ b/net/netfilter/nft_dup_netdev.c
@@ -46,8 +46,6 @@ static int nft_dup_netdev_init(const struct nft_ctx *ctx,
 	return nft_validate_register_load(priv->sreg_dev, sizeof(int));
 }
 
-static const struct nft_expr_ops nft_dup_netdev_ingress_ops;
-
 static int nft_dup_netdev_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	struct nft_dup_netdev *priv = nft_expr_priv(expr);
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 8abb9891cdf2..d7694e7255a0 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -53,8 +53,6 @@ static int nft_fwd_netdev_init(const struct nft_ctx *ctx,
 	return nft_validate_register_load(priv->sreg_dev, sizeof(int));
 }
 
-static const struct nft_expr_ops nft_fwd_netdev_ingress_ops;
-
 static int nft_fwd_netdev_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	struct nft_fwd_netdev *priv = nft_expr_priv(expr);
@@ -169,8 +167,6 @@ static int nft_fwd_neigh_init(const struct nft_ctx *ctx,
 	return nft_validate_register_load(priv->sreg_addr, addr_len);
 }
 
-static const struct nft_expr_ops nft_fwd_netdev_ingress_ops;
-
 static int nft_fwd_neigh_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	struct nft_fwd_neigh *priv = nft_expr_priv(expr);
-- 
2.11.0
