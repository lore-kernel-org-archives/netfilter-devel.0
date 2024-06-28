Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44EE61CB31D;
	Fri, 28 Jun 2024 16:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719590727; cv=none; b=JwyWJu7Juya3YZo4937jzJX2gl/zhbF/izuPPp2JosLUbjYJAEzZFGwj5bJZ1NcZicgUpmIQWvvBScBXJJaFTuRgw3rDcid7rQps3O6NNWtDvf9xxODs2XSiY3DreLmaEs0p20ya+VBS2P0VXTIDuOwIHfvGcEdqmRdirfoE2Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719590727; c=relaxed/simple;
	bh=lGwXFw/B2hR89OEZNlvMv1NP5BCmRMIKCv05ABL2zTM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jXhWvdKZKLY+18Toz4UP9PfWb7mwBNlMD+1/qmGToNHCj1hKYLS5amwv7Mzjoo8OrLrtrV0AnRltaVQpjX+fQdYlhpES1WcbFJZv0j7Ip55uYQRYJpJZdLQAbAMYjKXj7ZOH49iBMDeFZRqwLLfR51ZrqaZSC/e6+XuyC/NjFTk=
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
Subject: [PATCH net-next 09/17] netfilter: nf_tables: reduce trans->ctx.chain references
Date: Fri, 28 Jun 2024 18:04:57 +0200
Message-Id: <20240628160505.161283-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240628160505.161283-1-pablo@netfilter.org>
References: <20240628160505.161283-1-pablo@netfilter.org>
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

