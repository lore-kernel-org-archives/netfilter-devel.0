Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8FF7149C4A;
	Thu, 27 Jun 2024 11:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719487646; cv=none; b=QCmBU2Xu8FC9xFBesGOMsHzcWmrJgYKIT/3B1xTJaTINnbEfgDLbEgw+PkI7aOBaXMr5PnMLTxyW6Fg7vNk8h+vXbDeW0wIoEqw5xSujA+CfXJQvM1UL7UbV+w3+rzfIUTu7Ruu3md8js30AhH+CTqh3/BIFqhIhC7oXB1/LA0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719487646; c=relaxed/simple;
	bh=ZQosr7Zmlhz1whQCpHN9OsOlXUJbZIUiLx6QtQR6oR0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cx1qmigLiJ4awgMuEoBKzKBFkdCwy2jhqPMvbC5hRj+/ZiVj7813AYsDfUeA5sIdRK6DP9t5KzpJVjjWzqu8QWYnULkfMi/UWrsOwZ7Oi26z7rONE8nNnVQe4ngF2sqFmrUEEw55qBmG4LHKr8fVhnPnr2rE5jQl81jNnBeynw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH nf-next 07/19] netfilter: nf_tables: avoid usage of embedded nft_ctx
Date: Thu, 27 Jun 2024 13:27:01 +0200
Message-Id: <20240627112713.4846-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240627112713.4846-1-pablo@netfilter.org>
References: <20240627112713.4846-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

nft_ctx is stored in nft_trans object, but nft_ctx is large
(48 bytes on 64-bit platforms), it should not be embedded in
the transaction structures.

Reduce its usage so we can remove it eventually.

This replaces trans->ctx.chain with the chain pointer
already available in nft_trans_chain structure.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c     | 10 +++++-----
 net/netfilter/nf_tables_offload.c | 16 ++++++++--------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 62a4da955574..f4e39816104f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9682,10 +9682,10 @@ static void nf_tables_commit_chain_prepare_cancel(struct net *net)
 	struct nft_trans *trans, *next;
 
 	list_for_each_entry_safe(trans, next, &nft_net->commit_list, list) {
-		struct nft_chain *chain = trans->ctx.chain;
-
 		if (trans->msg_type == NFT_MSG_NEWRULE ||
 		    trans->msg_type == NFT_MSG_DELRULE) {
+			struct nft_chain *chain = trans->ctx.chain;
+
 			kvfree(chain->blob_next);
 			chain->blob_next = NULL;
 		}
@@ -10318,7 +10318,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				/* trans destroyed after rcu grace period */
 			} else {
 				nft_chain_commit_drop_policy(nft_trans_container_chain(trans));
-				nft_clear(net, trans->ctx.chain);
+				nft_clear(net, nft_trans_chain(trans));
 				nf_tables_chain_notify(&trans->ctx, NFT_MSG_NEWCHAIN, NULL);
 				nft_trans_destroy(trans);
 			}
@@ -10334,11 +10334,11 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 								    true);
 				}
 			} else {
-				nft_chain_del(trans->ctx.chain);
+				nft_chain_del(nft_trans_chain(trans));
 				nf_tables_chain_notify(&trans->ctx, NFT_MSG_DELCHAIN,
 						       NULL);
 				nf_tables_unregister_hook(trans->ctx.net, table,
-							  trans->ctx.chain);
+							  nft_trans_chain(trans));
 			}
 			break;
 		case NFT_MSG_NEWRULE:
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 12ab78fa5d84..8d892a0d2438 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -518,18 +518,18 @@ static void nft_flow_rule_offload_abort(struct net *net,
 
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWCHAIN:
-			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD) ||
+			if (!(nft_trans_chain(trans)->flags & NFT_CHAIN_HW_OFFLOAD) ||
 			    nft_trans_chain_update(trans))
 				continue;
 
-			err = nft_flow_offload_chain(trans->ctx.chain, NULL,
+			err = nft_flow_offload_chain(nft_trans_chain(trans), NULL,
 						     FLOW_BLOCK_UNBIND);
 			break;
 		case NFT_MSG_DELCHAIN:
-			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
+			if (!(nft_trans_chain(trans)->flags & NFT_CHAIN_HW_OFFLOAD))
 				continue;
 
-			err = nft_flow_offload_chain(trans->ctx.chain, NULL,
+			err = nft_flow_offload_chain(nft_trans_chain(trans), NULL,
 						     FLOW_BLOCK_BIND);
 			break;
 		case NFT_MSG_NEWRULE:
@@ -569,20 +569,20 @@ int nft_flow_rule_offload_commit(struct net *net)
 
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWCHAIN:
-			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD) ||
+			if (!(nft_trans_chain(trans)->flags & NFT_CHAIN_HW_OFFLOAD) ||
 			    nft_trans_chain_update(trans))
 				continue;
 
 			policy = nft_trans_chain_policy(trans);
-			err = nft_flow_offload_chain(trans->ctx.chain, &policy,
+			err = nft_flow_offload_chain(nft_trans_chain(trans), &policy,
 						     FLOW_BLOCK_BIND);
 			break;
 		case NFT_MSG_DELCHAIN:
-			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
+			if (!(nft_trans_chain(trans)->flags & NFT_CHAIN_HW_OFFLOAD))
 				continue;
 
 			policy = nft_trans_chain_policy(trans);
-			err = nft_flow_offload_chain(trans->ctx.chain, &policy,
+			err = nft_flow_offload_chain(nft_trans_chain(trans), &policy,
 						     FLOW_BLOCK_UNBIND);
 			break;
 		case NFT_MSG_NEWRULE:
-- 
2.30.2

