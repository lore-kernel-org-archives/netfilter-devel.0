Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC683ACA79
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Aug 2026 23:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786575860; cv=none; b=XXWUP0pGFClsYt3MkxQu7v0azE29I46owJ75jCMLEgwdGw07QDEpQq6ghJykFByS7SQxtjnWGm0Mi3vgWQ9DdoF7+Omn72nnW1qvciQ1YVsTW7GZHfNloa1R1B112uXCHGPUgGllHICv5Uaut7pADx84m+xOmJKVuRM3mdUHqug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786575860; c=relaxed/simple;
	bh=nwsRBYDxob1bVDQ6E3dcxrd07NZL+vEbGVQL+3ZvvGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGLXwYysILMIMxMPRzHI2w00z4+qStSAM1gyTET6WxSqCr60YVAWBwa0o5fRKJ2Zh7PV0zC9Af2yvWqYG3PpQ2gjxgbLKRHpz2RoxunFBmeCljFYMt/nQdmGM0qwMCvlm2YrZqtvCiBlIltSpBp8vQzb9Rtmv+MuYPaQ9F7owQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dwa8+8IB; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dwa8+8IB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786575856;
	bh=JRAAKyXumfIO2Eq30qCQw+fCFB5wy009RVUjIHItf5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dwa8+8IBj591y5zdjfC9IOIPM9kr8P+k0EBCj8jUDMhn37jij7IMMcdS3/xzdKzdm
	 i16/liN02aJFqqPB3ym1k96U2JvkZl7YnX7XyHARwgEBqpyL9+ozm/fzDotSbYJr44
	 lvKWBOWhoukkI3p3onk5RkUfm20f35zySX69hsyouyORdVpesGw/Y/DvOdW981FJxz
	 HLPg7Ur3QhYKQaB3MLkdEkPB1YStmEuUeWTmY9mZd9sxNky8FWHrfN1YuA+ejF2kb3
	 x8GTboRkND4vEhy6LdufSC3sNmfp1p7YkUrkGCMffcDnYu1MedoHKe8v9/BL4HnFaE
	 hvTId+S16z6sQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9913C600A4;
	Thu, 13 Aug 2026 01:04:16 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf 2/2] netfilter: nf_tables: call set ops .commit when building new ruleset blob
Date: Thu, 13 Aug 2026 01:04:11 +0200
Message-ID: <20260812230411.1048500-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260812230411.1048500-1-pablo@netfilter.org>
References: <20260812230411.1048500-1-pablo@netfilter.org>
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
v1: new in this series

 net/netfilter/nf_tables_api.c | 45 +++++++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 90a379533e08..5c4f6c354595 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7210,6 +7210,20 @@ static void nft_trans_elems_remove(const struct nft_ctx *ctx,
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
@@ -10853,9 +10867,29 @@ static void nf_tables_commit_audit_log(struct list_head *adl, u32 generation)
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
+			nft_trans_elems_remove(ctx, te);
+			break;
+		}
+	}
 
 	list_for_each_entry_safe(set, next, &nft_net->set_update_list, pending_update) {
 		list_del_init(&set->pending_update);
@@ -10964,6 +10998,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	}
 
 	/* step 2.  Make rules_gen_X visible to packet path */
+	nft_set_commit_update(&ctx, nft_net);
+
 	list_for_each_entry(table, &nft_net->tables, list) {
 		list_for_each_entry(chain, &table->chains, list)
 			nf_tables_commit_chain(net, chain);
@@ -11101,7 +11137,10 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		case NFT_MSG_DELSETELEM:
 		case NFT_MSG_DESTROYSETELEM:
 			te = nft_trans_container_elem(trans);
-			nft_trans_elems_remove(&ctx, te);
+			if (te->set->ops->commit)
+				nft_trans_elems_remove_notify(&ctx, te);
+			else
+				nft_trans_elems_remove(&ctx, te);
 			break;
 		case NFT_MSG_NEWOBJ:
 			if (nft_trans_obj_update(trans)) {
@@ -11170,8 +11209,6 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		}
 	}
 
-	nft_set_commit_update(nft_net);
-
 	nft_commit_notify(net, NETLINK_CB(skb).portid);
 	nf_tables_gen_notify(net, skb, NFT_MSG_NEWGEN);
 	nf_tables_commit_audit_log(&adl, nft_base_seq(net));
-- 
2.47.3

