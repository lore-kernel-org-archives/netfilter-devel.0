From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 08/13] netfilter: nft_exthdr: fix error handling in nft_exthdr_init()
Date: Fri, 21 Oct 2016 12:12:18 +0200
Message-ID: <1477044743-18948-9-git-send-email-pablo@netfilter.org>
References: <1477044743-18948-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1477044743-18948-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

"err" needs to be signed for the error handling to work.

Fixes: 36b701fae12a ('netfilter: nf_tables: validate maximum value of u32 netlink attributes')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_exthdr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index a84cf3d66056..47beb3abcc9d 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -59,7 +59,8 @@ static int nft_exthdr_init(const struct nft_ctx *ctx,
 			   const struct nlattr * const tb[])
 {
 	struct nft_exthdr *priv = nft_expr_priv(expr);
-	u32 offset, len, err;
+	u32 offset, len;
+	int err;
 
 	if (tb[NFTA_EXTHDR_DREG] == NULL ||
 	    tb[NFTA_EXTHDR_TYPE] == NULL ||
-- 
2.1.4
