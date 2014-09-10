From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 15/25] netfilter: nf_tables: rename nf_table_delrule_by_chain()
Date: Wed, 10 Sep 2014 17:10:32 +0200
Message-ID: <1410361842-4656-16-git-send-email-pablo@netfilter.org>
References: <1410361842-4656-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1410361842-4656-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Arturo Borrero <arturo.borrero.glez@gmail.com>

For the sake of homogenize the function naming scheme, let's rename
nf_table_delrule_by_chain() to nft_delrule_by_chain().

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 90e3496..eac4fab 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1902,7 +1902,7 @@ static int nft_delrule(struct nft_ctx *ctx, struct nft_rule *rule)
 	return 0;
 }
 
-static int nf_table_delrule_by_chain(struct nft_ctx *ctx)
+static int nft_delrule_by_chain(struct nft_ctx *ctx)
 {
 	struct nft_rule *rule;
 	int err;
@@ -1955,12 +1955,12 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 
 			err = nft_delrule(&ctx, rule);
 		} else {
-			err = nf_table_delrule_by_chain(&ctx);
+			err = nft_delrule_by_chain(&ctx);
 		}
 	} else {
 		list_for_each_entry(chain, &table->chains, list) {
 			ctx.chain = chain;
-			err = nf_table_delrule_by_chain(&ctx);
+			err = nft_delrule_by_chain(&ctx);
 			if (err < 0)
 				break;
 		}
-- 
1.7.10.4
