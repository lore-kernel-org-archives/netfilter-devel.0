From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 10/23] netfilter: nft_meta: fix lack of validation of the input register
Date: Fri, 10 Jan 2014 01:35:29 +0100
Message-ID: <1389314142-17969-11-git-send-email-pablo@netfilter.org>
References: <1389314142-17969-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1389314142-17969-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

We have to validate that the input register is in the range of
allowed registers, otherwise we can take a incorrect register
value as input that may lead us to a crash.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_meta.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index b43975a..e8254ad 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -239,6 +239,9 @@ static int nft_meta_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		return err;
 
 	priv->sreg = ntohl(nla_get_be32(tb[NFTA_META_SREG]));
+	err = nft_validate_input_register(priv->sreg);
+	if (err < 0)
+		return err;
 
 	return 0;
 }
-- 
1.7.10.4
