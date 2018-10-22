From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/8] netfilter: nft_osf: usage from output path is not valid
Date: Mon, 22 Oct 2018 22:07:18 +0200
Message-ID: <20181022200724.25806-3-pablo@netfilter.org>
References: <20181022200724.25806-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181022200724.25806-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

The nft_osf extension, like xt_osf, is not supported from the output
path.

Fixes: b96af92d6eaf ("netfilter: nf_tables: implement Passive OS fingerprint module in nft_osf")
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_osf.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index a35fb59ace73..df4e3e0412ed 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -69,6 +69,15 @@ static int nft_osf_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
+static int nft_osf_validate(const struct nft_ctx *ctx,
+			    const struct nft_expr *expr,
+			    const struct nft_data **data)
+{
+	return nft_chain_validate_hooks(ctx->chain, (1 << NF_INET_LOCAL_IN) |
+						    (1 << NF_INET_PRE_ROUTING) |
+						    (1 << NF_INET_FORWARD));
+}
+
 static struct nft_expr_type nft_osf_type;
 static const struct nft_expr_ops nft_osf_op = {
 	.eval		= nft_osf_eval,
@@ -76,6 +85,7 @@ static const struct nft_expr_ops nft_osf_op = {
 	.init		= nft_osf_init,
 	.dump		= nft_osf_dump,
 	.type		= &nft_osf_type,
+	.validate	= nft_osf_validate,
 };
 
 static struct nft_expr_type nft_osf_type __read_mostly = {
-- 
2.11.0
