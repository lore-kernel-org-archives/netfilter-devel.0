Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C879391835
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 13:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786626045; cv=none; b=NsM3AAQ1tiP7ZjqDOS4uj/cCzTqHZLvSl7KbvaAhZrgfTAtzJSKI9rvdDvaWV/AtulOaidhU4ayyghAOSOd/m6f0RapRLIbj0j9wz5jjoH0u0PDC01DBtxK6afCnE9kKnntwRVHIG+XmbDc5g8+piCysyQ7pcTOiYWC9RtYxPCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786626045; c=relaxed/simple;
	bh=z7X6d7RCT6J4HPcenFVAL0I1zOtzaeRXN7njPFGK63w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zb7DXLNcxm+n7Vg9Gh8sBxH08JEOjSrB8Si7SM4cbt+HVl6YXsBGbz5ZbxNNK6C3JoiGEcJXtMVu5RKgYNLVr5AXBfBdrA/aZFVwSEsSsN7cT9o2Ax+g6E2158LPrJpprq3rTL7FZDeet8mJQa0ZGB+wobasgNmMAyqlxlacPwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=URUrjaXH; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="URUrjaXH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786626042;
	bh=jwULU6zDPuDfqtlwPB2b6AGV7BVWewQ4UGmrfoLpZyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=URUrjaXH7kI5kM+xAjKmFWGRvk3UYP/kzBcfZi73wprgm4PJRTKrsottRyB3FMWgW
	 GZn5ZY+3H2eu1jL1/Xq2e0T+HG2Iu1YuDL3vFg+dWKFmJ0BQeaLNW/z59fmT7YOr4j
	 Bb608Gds7t86jAosYg3nc8A7FU5ISpMCk65+0BXnUFRUOFpNERlLQr4AfMTSben5Vz
	 F+avSyXpRKlCHsATdDtmmrq7yqquZ8er/Fn0eVI1QdJ4+fq/8ZN8+KImAUvlVNTUg2
	 4EEIUz9jrrau3aDf1bLR2Wnqst4K9LHxPthdWjpGH4YkuJjtldIO+RDO9mdEHOz59A
	 1d1+rxCTpCp+A==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EE4AF60077;
	Thu, 13 Aug 2026 15:00:41 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf,v2 2/2] netfilter: nf_tables: call set ops .commit when building new ruleset blob
Date: Thu, 13 Aug 2026 15:00:36 +0200
Message-ID: <20260813130036.1088563-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260813130036.1088563-1-pablo@netfilter.org>
References: <20260813130036.1088563-1-pablo@netfilter.org>
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
v2: fix double notification on deleted elements.

 net/netfilter/nf_tables_api.c | 56 ++++++++++++++++++++++++++++++-----
 1 file changed, 48 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 110c0a31f8f2..7c33b523f678 100644
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
@@ -10853,9 +10870,29 @@ static void nf_tables_commit_audit_log(struct list_head *adl, u32 generation)
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
@@ -10970,6 +11007,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	}
 
 	/* step 2.  Make rules_gen_X visible to packet path */
+	nft_set_commit_update(&ctx, nft_net);
+
 	list_for_each_entry(table, &nft_net->tables, list) {
 		list_for_each_entry(chain, &table->chains, list)
 			nf_tables_commit_chain(net, chain);
@@ -11107,7 +11146,10 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
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
@@ -11176,8 +11218,6 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		}
 	}
 
-	nft_set_commit_update(nft_net);
-
 	nft_commit_notify(net, NETLINK_CB(skb).portid);
 	nf_tables_gen_notify(net, skb, NFT_MSG_NEWGEN);
 	nf_tables_commit_audit_log(&adl, nft_base_seq(net));
-- 
2.47.3

