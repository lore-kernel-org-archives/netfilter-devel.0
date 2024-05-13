Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF381514E3
	for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2024 13:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715605796; cv=none; b=E5oBvnsDAuD5I2lQnMSosE2x88M59VMdUOwa8HZqJjxbYeCHeX5DL0Eu/alp3ivpvWVXRFxDp7IRs0Qlq7Va+9sfMaiVu39X+vkehslCVv1Dm8J9aMPgjFTf0DJ8nvlDs9J+M0KjNZ2IGYaaebHcNXE6GD+/H67wzUaCGjs3KaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715605796; c=relaxed/simple;
	bh=9DTZQe5LTOFAeaC9J1eR4cA44VXtxdXcHo28UMtFhrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NNQA1D7d0LDk6jMptEsJByUuhuJZEkstraCD9eSffnoNb4NNCni6Osr2CwR6gyAzAqs5ryPB1Jkq1OmwfWaZW4ZXYfo0zmF7RtFj+ddmsE6dVFZpEHjzx2vetNOvQtOpkVv2g3xQCpWbBG75T9pFoy0gRVEgjJjKHINMiJTztvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1s6VRC-0001Pt-29; Mon, 13 May 2024 15:09:54 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 07/11] netfilter: nf_tables: avoid usage of embedded nft_ctx
Date: Mon, 13 May 2024 15:00:47 +0200
Message-ID: <20240513130057.11014-8-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240513130057.11014-1-fw@strlen.de>
References: <20240513130057.11014-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nft_ctx is stored in nft_trans object, but nft_ctx is large
(48 bytes on 64-bit platforms), it should not be embedded in
the transaction structures.

Reduce its usage so we can remove it eventually.

This replaces trans->ctx.chain with the chain pointer
already available in nft_trans_chain structure.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c     | 10 +++++-----
 net/netfilter/nf_tables_offload.c | 16 ++++++++--------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5a40a8040539..044007893e79 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9681,10 +9681,10 @@ static void nf_tables_commit_chain_prepare_cancel(struct net *net)
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
@@ -10317,7 +10317,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				/* trans destroyed after rcu grace period */
 			} else {
 				nft_chain_commit_drop_policy(nft_trans_container_chain(trans));
-				nft_clear(net, trans->ctx.chain);
+				nft_clear(net, nft_trans_chain(trans));
 				nf_tables_chain_notify(&trans->ctx, NFT_MSG_NEWCHAIN, NULL);
 				nft_trans_destroy(trans);
 			}
@@ -10333,11 +10333,11 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
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
2.43.2

