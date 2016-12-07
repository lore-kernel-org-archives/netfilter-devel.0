From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 45/50] netfilter: nf_tables: constify struct nft_ctx * parameter in nft_trans_alloc()
Date: Wed,  7 Dec 2016 22:52:51 +0100
Message-ID: <1481147576-5690-46-git-send-email-pablo@netfilter.org>
References: <1481147576-5690-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1481147576-5690-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Context is not modified by nft_trans_alloc(), so constify it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b04d4ee1d533..b42059795819 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -111,8 +111,8 @@ static void nft_ctx_init(struct nft_ctx *ctx,
 	ctx->seq	= nlh->nlmsg_seq;
 }
 
-static struct nft_trans *nft_trans_alloc(struct nft_ctx *ctx, int msg_type,
-					 u32 size)
+static struct nft_trans *nft_trans_alloc(const struct nft_ctx *ctx,
+					 int msg_type, u32 size)
 {
 	struct nft_trans *trans;
 
-- 
2.1.4
