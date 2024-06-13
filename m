Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFEBCD534;
	Thu, 13 Jun 2024 01:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718240542; cv=none; b=hUYSzNblNTDj8gBMk+oEcg38F5Ne9906cNahEehNCb+bdk/jupu3Wgpe1p2LDZ1HhHLyPTTVgG0l2HhmbPMnnwota5bCevk6X0pltVGZzFYeCuXeyTCD9M7kg3KvsSLUy8XuZUgGgDV9AVQUPpgOV6S1cxSfms5CstJ69bNAksQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718240542; c=relaxed/simple;
	bh=PJqdynmhPWpVc0umxF98SdlAsU6qFmie7h8YfKPvmu8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Uk4ZzDgZKyyQ9mHppNbXS5GX/MB2T7O/GIBW5leDWV8d1yZnuiXpaE45x/pLn/svwdkdV1lQhyW9Pfgrsihea/H91E9bsT+HJFToLKMAWyKnaxvzEmnhM+d3/OmrLcoFgLQlCU0JW2f6ZQapjXRjSn4/G5Gjeod60b0z/j6N8LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,4.19.x 02/40] netfilter: nftables: rename set element data activation/deactivation functions
Date: Thu, 13 Jun 2024 03:01:31 +0200
Message-Id: <20240613010209.104423-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240613010209.104423-1-pablo@netfilter.org>
References: <20240613010209.104423-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit f8bb7889af58d8e74d2d61c76b1418230f1610fa upstream.

Rename:

- nft_set_elem_activate() to nft_set_elem_data_activate().
- nft_set_elem_deactivate() to nft_set_elem_data_deactivate().

To prepare for updates in the set element infrastructure to add support
for the special catch-all element.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 36bbbd2c0762..acd2763bb784 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4501,8 +4501,8 @@ void nft_set_elem_destroy(const struct nft_set *set, void *elem,
 }
 EXPORT_SYMBOL_GPL(nft_set_elem_destroy);
 
-/* Only called from commit path, nft_set_elem_deactivate() already deals with
- * the refcounting from the preparation phase.
+/* Only called from commit path, nft_setelem_data_deactivate() already deals
+ * with the refcounting from the preparation phase.
  */
 static void nf_tables_set_elem_destroy(const struct nft_ctx *ctx,
 				       const struct nft_set *set, void *elem)
@@ -4806,9 +4806,9 @@ void nft_data_hold(const struct nft_data *data, enum nft_data_types type)
 	}
 }
 
-static void nft_set_elem_activate(const struct net *net,
-				  const struct nft_set *set,
-				  struct nft_set_elem *elem)
+static void nft_setelem_data_activate(const struct net *net,
+				      const struct nft_set *set,
+				      struct nft_set_elem *elem)
 {
 	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
 
@@ -4818,9 +4818,9 @@ static void nft_set_elem_activate(const struct net *net,
 		nft_use_inc_restore(&(*nft_set_ext_obj(ext))->use);
 }
 
-static void nft_set_elem_deactivate(const struct net *net,
-				    const struct nft_set *set,
-				    struct nft_set_elem *elem)
+static void nft_setelem_data_deactivate(const struct net *net,
+					const struct nft_set *set,
+					struct nft_set_elem *elem)
 {
 	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
 
@@ -4887,7 +4887,7 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	kfree(elem.priv);
 	elem.priv = priv;
 
-	nft_set_elem_deactivate(ctx->net, set, &elem);
+	nft_setelem_data_deactivate(ctx->net, set, &elem);
 
 	nft_trans_elem(trans) = elem;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
@@ -4921,7 +4921,7 @@ static int nft_flush_set(const struct nft_ctx *ctx,
 	}
 	set->ndeact++;
 
-	nft_set_elem_deactivate(ctx->net, set, elem);
+	nft_setelem_data_deactivate(ctx->net, set, elem);
 	nft_trans_elem_set(trans) = set;
 	nft_trans_elem(trans) = *elem;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
@@ -6954,7 +6954,7 @@ static int __nf_tables_abort(struct net *net)
 		case NFT_MSG_DELSETELEM:
 			te = (struct nft_trans_elem *)trans->data;
 
-			nft_set_elem_activate(net, te->set, &te->elem);
+			nft_setelem_data_activate(net, te->set, &te->elem);
 			te->set->ops->activate(net, te->set, &te->elem);
 			te->set->ndeact--;
 
-- 
2.30.2

