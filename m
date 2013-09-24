From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: nf_tables: fix basechain release
Date: Tue, 24 Sep 2013 03:14:47 +0200
Message-ID: <1379985287-4118-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34050 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab3IXBO4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Sep 2013 21:14:56 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Base chains are containers of the chain object, kfree was
receiving the wrong memory address in that case.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 91cba3b..f2d7f93 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1004,10 +1004,11 @@ static void nf_tables_rcu_chain_destroy(struct rcu_head *head)
 
 	BUG_ON(chain->use > 0);
 
-	if (chain->flags & NFT_BASE_CHAIN)
+	if (chain->flags & NFT_BASE_CHAIN) {
 		free_percpu(nft_base_chain(chain)->stats);
-
-	kfree(chain);
+		kfree(nft_base_chain(chain));
+	} else
+		kfree(chain);
 }
 
 static int nf_tables_delchain(struct sock *nlsk, struct sk_buff *skb,
-- 
1.7.10.4

