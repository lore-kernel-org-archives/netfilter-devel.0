From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 08/12] netfilter: nf_tables: free set name in error path
Date: Mon, 23 Apr 2018 19:57:10 +0200
Message-ID: <20180423175714.9794-9-pablo@netfilter.org>
References: <20180423175714.9794-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180423175714.9794-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

set->name must be free'd here in case ops->init fails.

Fixes: 387454901bd6 ("netfilter: nf_tables: Allow set names of up to 255 chars")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b1984f8f7253..102ad873acb4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3212,18 +3212,20 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 
 	err = ops->init(set, &desc, nla);
 	if (err < 0)
-		goto err2;
+		goto err3;
 
 	err = nft_trans_set_add(&ctx, NFT_MSG_NEWSET, set);
 	if (err < 0)
-		goto err3;
+		goto err4;
 
 	list_add_tail_rcu(&set->list, &table->sets);
 	table->use++;
 	return 0;
 
-err3:
+err4:
 	ops->destroy(set);
+err3:
+	kfree(set->name);
 err2:
 	kvfree(set);
 err1:
-- 
2.11.0
