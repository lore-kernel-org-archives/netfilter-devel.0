From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/9] netfilter: nf_tables: free flow table struct too
Date: Tue, 24 Jul 2018 18:31:29 +0200
Message-ID: <20180724163133.14586-6-pablo@netfilter.org>
References: <20180724163133.14586-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180724163133.14586-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Fixes: 3b49e2e94e6ebb ("netfilter: nf_tables: add flow table netlink frontend")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 54a4f75ff9da..200da08524ae 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5784,6 +5784,7 @@ static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
 	kfree(flowtable->name);
 	flowtable->data.type->free(&flowtable->data);
 	module_put(flowtable->data.type->owner);
+	kfree(flowtable);
 }
 
 static int nf_tables_fill_gen_info(struct sk_buff *skb, struct net *net,
-- 
2.11.0
