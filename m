Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D80ED15278F;
	Thu, 27 Jun 2024 11:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719487647; cv=none; b=AQGqYShsWZLhb+Wt2dKtCO2jqf5M8eGL5nz3jQhUJiGM9n1rl5zBoJljgxPH82SZXlA5w7F61u85TBoxizrE9zQQFtppBeBXQOyNaBgvWx400koyK2LKWin2NWrGTt7C1ImFU7V2qeK9ROA9eTyJvXa1BGHN8NUz6gYzNRhrY5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719487647; c=relaxed/simple;
	bh=lGwXFw/B2hR89OEZNlvMv1NP5BCmRMIKCv05ABL2zTM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VgyRgitLT/Zy1ZNZHNsUbZ+UIVN0MZM6alUu+1gc7NkTD8u5q/SOVq1E4XQceUt80ea5RClbD7WhNY7VA5RFlJZiQdFrGU47cQI+4mHg7Ob+uFg3NXVh5dnzMXgjE4TgIyjRDFlaGVEp+YcyxcyN7pnFkta0oyvRi+jlLP9m4iM=
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
Subject: [PATCH nf-next 09/19] netfilter: nf_tables: reduce trans->ctx.chain references
Date: Thu, 27 Jun 2024 13:27:03 +0200
Message-Id: <20240627112713.4846-10-pablo@netfilter.org>
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

These objects are the trans_chain subtype, so use the helper instead
of referencing trans->ctx, which will be removed soon.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3e5980f0bf71..bd311b37fc61 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1262,7 +1262,7 @@ static bool nft_table_pending_update(const struct nft_ctx *ctx)
 		    ((trans->msg_type == NFT_MSG_NEWCHAIN &&
 		      nft_trans_chain_update(trans)) ||
 		     (trans->msg_type == NFT_MSG_DELCHAIN &&
-		      nft_is_base_chain(trans->ctx.chain))))
+		      nft_is_base_chain(nft_trans_chain(trans)))))
 			return true;
 	}
 
@@ -2815,13 +2815,11 @@ static struct nft_chain *nft_chain_lookup_byid(const struct net *net,
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
@@ -10625,9 +10623,9 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
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
@@ -10637,7 +10635,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 					    &nft_trans_basechain(trans)->hook_list);
 			} else {
 				nft_use_inc_restore(&table->use);
-				nft_clear(trans->ctx.net, trans->ctx.chain);
+				nft_clear(trans->ctx.net, nft_trans_chain(trans));
 			}
 			nft_trans_destroy(trans);
 			break;
-- 
2.30.2

