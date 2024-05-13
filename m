Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B311509BA
	for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2024 13:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715605805; cv=none; b=YnHThRv8k32ap8MYgkcHYSMsospH+ihOp1wKFVy6mCeNSmkDxmjOtzHDVceIpga18GihCqDPOG60ujns7NOuiOGm7UhdMSRTcTpZKInHgsXnm2qzQ5VrNKyl6qoKv7Amf7RL4EgDLoBupgwBq92n2HtWNsXpobB/sb5y/lFQqrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715605805; c=relaxed/simple;
	bh=Iqu5CmeXzli2bVXsdaDdTV8FH/BmoZSV683ns7iWD7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWcvl5YvKWTxwROwDYQh0jQ2DrS+Em8zraL5oLjoG4Ri8Ktz7yEVlTkPPX7xbzZcU3faRXwgIWnZjLJeZFTn5lI+RRebS16m6+kTxrwVyCQVoBnxHcKKWafViJUsdQIpHjs3ke2xCoZXseAc6/xoRyFmT8oYmFGE+yYVai7ulho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1s6VRK-0001QI-6M; Mon, 13 May 2024 15:10:02 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 09/11] netfilter: nf_tables: reduce trans->ctx.chain references
Date: Mon, 13 May 2024 15:00:49 +0200
Message-ID: <20240513130057.11014-10-fw@strlen.de>
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

These objects are the trans_chain subtype, so use the helper instead
of referencing trans->ctx, which will be removed soon.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9d8fc31bbfc6..70d65a09787b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1261,7 +1261,7 @@ static bool nft_table_pending_update(const struct nft_ctx *ctx)
 		    ((trans->msg_type == NFT_MSG_NEWCHAIN &&
 		      nft_trans_chain_update(trans)) ||
 		     (trans->msg_type == NFT_MSG_DELCHAIN &&
-		      nft_is_base_chain(trans->ctx.chain))))
+		      nft_is_base_chain(nft_trans_chain(trans)))))
 			return true;
 	}
 
@@ -2814,13 +2814,11 @@ static struct nft_chain *nft_chain_lookup_byid(const struct net *net,
 	struct nft_trans *trans;
 
 	list_for_each_entry(trans, &nft_net->commit_list, list) {
-		struct nft_chain *chain = trans->ctx.chain;
-
 		if (trans->msg_type == NFT_MSG_NEWCHAIN &&
-		    chain->table == table &&
+		    nft_trans_chain(trans)->table == table &&
 		    id == nft_trans_chain_id(trans) &&
-		    nft_active_genmask(chain, genmask))
-			return chain;
+		    nft_active_genmask(nft_trans_chain(trans), genmask))
+			return nft_trans_chain(trans);
 	}
 	return ERR_PTR(-ENOENT);
 }
@@ -10624,9 +10622,9 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 					break;
 				}
 				nft_use_dec_restore(&table->use);
-				nft_chain_del(trans->ctx.chain);
+				nft_chain_del(nft_trans_chain(trans));
 				nf_tables_unregister_hook(trans->ctx.net, table,
-							  trans->ctx.chain);
+							  nft_trans_chain(trans));
 			}
 			break;
 		case NFT_MSG_DELCHAIN:
@@ -10636,7 +10634,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 					    &nft_trans_basechain(trans)->hook_list);
 			} else {
 				nft_use_inc_restore(&table->use);
-				nft_clear(trans->ctx.net, trans->ctx.chain);
+				nft_clear(trans->ctx.net, nft_trans_chain(trans));
 			}
 			nft_trans_destroy(trans);
 			break;
-- 
2.43.2

