From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 03/15] netfilter: nf_tables: skip synchronize_rcu if transaction log is empty
Date: Mon, 14 May 2018 00:36:44 +0200
Message-ID: <20180513223656.10077-4-pablo@netfilter.org>
References: <20180513223656.10077-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180513223656.10077-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

After processing the transaction log, the remaining entries of the log
need to be released.

However, in some cases no entries remain, e.g. because the transaction
did not remove anything.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 04d4e3772584..785d7fcf1fe1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5761,7 +5761,7 @@ static void nft_chain_commit_update(struct nft_trans *trans)
 	}
 }
 
-static void nf_tables_commit_release(struct nft_trans *trans)
+static void nft_commit_release(struct nft_trans *trans)
 {
 	switch (trans->msg_type) {
 	case NFT_MSG_DELTABLE:
@@ -5790,6 +5790,21 @@ static void nf_tables_commit_release(struct nft_trans *trans)
 	kfree(trans);
 }
 
+static void nf_tables_commit_release(struct net *net)
+{
+	struct nft_trans *trans, *next;
+
+	if (list_empty(&net->nft.commit_list))
+		return;
+
+	synchronize_rcu();
+
+	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
+		list_del(&trans->list);
+		nft_commit_release(trans);
+	}
+}
+
 static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 {
 	struct nft_trans *trans, *next;
@@ -5920,13 +5935,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		}
 	}
 
-	synchronize_rcu();
-
-	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
-		list_del(&trans->list);
-		nf_tables_commit_release(trans);
-	}
-
+	nf_tables_commit_release(net);
 	nf_tables_gen_notify(net, skb, NFT_MSG_NEWGEN);
 
 	return 0;
-- 
2.11.0
