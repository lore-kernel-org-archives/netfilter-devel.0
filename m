Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBAF3F4830;
	Mon, 17 Aug 2026 23:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787009417; cv=none; b=T4XZTgJf0Pjpu8QUbUYAKkcV/5W7jDsDtwtPUq3+tQ5GK3KiM5jdmA0HqjBZdn/slmciK7g2kFsoXfInXNDaEW4sWFv7nfwNIPOKHqmRCLRdUcXxotE88iWKWCUrSuw9J+YRVpa+vP/Y18RmtWqUGHT1u9tgkQM+PRo2QITZIZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787009417; c=relaxed/simple;
	bh=6Qpo6PgymKMclFU6C1r2cazjWEjcy1X/4C9AjLkKXxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LeFChzl1zPvIrMS3dSeXtEf3lypeQy4Moy03X8AAXZC/iLL0ODXlAFyQGsNkp2DeHy1bxZJ7oGJsJI6tLwFVuvf7HeNtj6Ay5kCjmzPAeSNtE3rF+h0Vy8kRiBB4O2XwLBdruRDB+fKUarr/NnBr73KoZ0RHQ9Wi/fTyJnbL9wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=izF2SE+5; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="izF2SE+5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787009413;
	bh=9QOPBomFIEQEvIG6StjxXSke1vMmqLfCkvxLR/elVG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=izF2SE+5IdGkNq/W7mgUHsANYH1+hAGsSR90KvIz6MWVkT3sosYow0JVNqtXl+spp
	 jOa6BZfMaURyrDpV6Glmqiov+dtgI+bzWBBVItLtVYZOS36fYgO3KktHrOdUgGZjjl
	 aD76aMMqFOmkU7A4nlpl1zV+x4IwnBGTo0ZVeV02cYi25d58sLq1shXXJF+ocEiq0c
	 4ENogFO/CAMhNK4AKkc5JibMfU+BjWNY6wH+xE+2ErJCfhI4eb1gPQcjSQbpt7wg8K
	 xj5RSikvZFFd9I1PcxLstE3Xk0pcxz4ax228ZEzn1JUFhiPXld55aM/hXxhV/RTZt3
	 NHwa56pnsZ0EQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 458D160092;
	Tue, 18 Aug 2026 01:30:13 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 7/8] netfilter: nf_tables: call set ops .commit when building new ruleset blob
Date: Tue, 18 Aug 2026 01:29:56 +0200
Message-ID: <20260817232957.1281637-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260817232957.1281637-1-pablo@netfilter.org>
References: <20260817232957.1281637-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The rbtree set only builds the b-search array after the new ruleset has
been published through set ops .commit.

This exposes an empty set for a short time span which results in a bogus
mismatch for the following batch:

 destroy table ip x
 table ip x {
	...
 }

The same problem also affects the pipapo set backend which also provides
a set ops .commit interface too.

This patch moves the set ops .commit call right before building and
publishing the chain blob. The commit path now performs an early
handling of the DELSETELEM command to remove stale elements from the
clone before it is published via rcu. Note that DELSETELEM notifications
are still delivered in order. NEWSETELEM commands are handled after the
set is published, since this clears the previous genbit to 1 to prepare
the element for the next control plane transaction. This comes at the
cost of one extra iteration over the transaction list.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 56 ++++++++++++++++++++++++++++++-----
 1 file changed, 48 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b51ba77b5151..c112ecc4fca3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7191,16 +7191,19 @@ static void nft_setelem_remove(const struct net *net,
 }
 
 static void nft_trans_elems_remove(const struct nft_ctx *ctx,
-				   const struct nft_trans_elem *te)
+				   const struct nft_trans_elem *te,
+				   bool notify)
 {
 	int i;
 
 	for (i = 0; i < te->nelems; i++) {
 		WARN_ON_ONCE(te->elems[i].update);
 
-		nf_tables_setelem_notify(ctx, te->set,
-					 te->elems[i].priv,
-					 te->nft_trans.msg_type);
+		if (notify) {
+			nf_tables_setelem_notify(ctx, te->set,
+						 te->elems[i].priv,
+						 te->nft_trans.msg_type);
+		}
 
 		nft_setelem_remove(ctx->net, te->set, te->elems[i].priv);
 		if (!nft_setelem_is_catchall(te->set, te->elems[i].priv)) {
@@ -7210,6 +7213,20 @@ static void nft_trans_elems_remove(const struct nft_ctx *ctx,
 	}
 }
 
+static void nft_trans_elems_remove_notify(const struct nft_ctx *ctx,
+					  const struct nft_trans_elem *te)
+{
+	int i;
+
+	for (i = 0; i < te->nelems; i++) {
+		WARN_ON_ONCE(te->elems[i].update);
+
+		nf_tables_setelem_notify(ctx, te->set,
+					 te->elems[i].priv,
+					 te->nft_trans.msg_type);
+	}
+}
+
 static bool nft_setelem_valid_key_end(const struct nft_set *set,
 				      struct nlattr **nla, u32 flags)
 {
@@ -10863,9 +10880,29 @@ static void nf_tables_commit_audit_log(struct list_head *adl, u32 generation)
 	}
 }
 
-static void nft_set_commit_update(struct nftables_pernet *nft_net)
+static void nft_set_commit_update(struct nft_ctx *ctx,
+				  struct nftables_pernet *nft_net)
 {
 	struct nft_set *set, *next;
+	struct nft_trans_elem *te;
+	struct nft_trans *trans;
+
+	if (list_empty(&nft_net->set_update_list))
+		return;
+
+	list_for_each_entry(trans, &nft_net->commit_list, list) {
+		nft_ctx_update(ctx, trans);
+
+		switch (trans->msg_type) {
+		case NFT_MSG_DELSETELEM:
+			te = nft_trans_container_elem(trans);
+			if (!te->set->ops->commit)
+				break;
+
+			nft_trans_elems_remove(ctx, te, false);
+			break;
+		}
+	}
 
 	list_for_each_entry_safe(set, next, &nft_net->set_update_list, pending_update) {
 		list_del_init(&set->pending_update);
@@ -10974,6 +11011,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	}
 
 	/* step 2.  Make rules_gen_X visible to packet path */
+	nft_set_commit_update(&ctx, nft_net);
+
 	list_for_each_entry(table, &nft_net->tables, list) {
 		list_for_each_entry(chain, &table->chains, list)
 			nf_tables_commit_chain(net, chain);
@@ -11111,7 +11150,10 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		case NFT_MSG_DELSETELEM:
 		case NFT_MSG_DESTROYSETELEM:
 			te = nft_trans_container_elem(trans);
-			nft_trans_elems_remove(&ctx, te);
+			if (te->set->ops->commit)
+				nft_trans_elems_remove_notify(&ctx, te);
+			else
+				nft_trans_elems_remove(&ctx, te, true);
 			break;
 		case NFT_MSG_NEWOBJ:
 			if (nft_trans_obj_update(trans)) {
@@ -11180,8 +11222,6 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		}
 	}
 
-	nft_set_commit_update(nft_net);
-
 	nft_commit_notify(net, NETLINK_CB(skb).portid);
 	nf_tables_gen_notify(net, skb, NFT_MSG_NEWGEN);
 	nf_tables_commit_audit_log(&adl, nft_base_seq(net));
-- 
2.47.3

