Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B12602C85C;
	Thu, 28 Mar 2024 03:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711595946; cv=none; b=eUSp6ccxk0A0y4l+eiZAarmaFhkOGW/mIWQnVvQuATPwAZo9o7iv6unxLQZ43EU3Xu72/EkVfctqEuE/6DnZKncxvKL8eIqRXIPBs26/UMPFyAb8RApQ2YfqA7fvAL880FmbELKwOEuWynslulFIZatbLO6VThVX+6xK83XY9ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711595946; c=relaxed/simple;
	bh=J5KA1gEGIKWyuc4b65d6aHSOsmT02n8qm6MqdJiIdZo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a7uUILpKLOvSFG2ak53Xps3rUpurWpXBKi9SiFA6pyyORB5FXbN+ISI6Wqe4N5J1yXcq+DVW7ozC0caL5wHXRSnenQkgQeFaiFJL20VX0Y8VWaBP/u/qEpz8lKrObcWwb6Fqd51a1W9rodCQeOANNb2nT8FblwtkvA/jguv7+50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com
Subject: [PATCH net 2/4] netfilter: nf_tables: reject table flag and netdev basechain updates
Date: Thu, 28 Mar 2024 04:18:53 +0100
Message-Id: <20240328031855.2063-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240328031855.2063-1-pablo@netfilter.org>
References: <20240328031855.2063-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

netdev basechain updates are stored in the transaction object hook list.
When setting on the table dormant flag, it iterates over the existing
hooks in the basechain. Thus, skipping the hooks that are being
added/deleted in this transaction, which leaves hook registration in
inconsistent state.

Reject table flag updates in combination with netdev basechain updates
in the same batch:

- Update table flags and add/delete basechain: Check from basechain update
  path if there are pending flag updates for this table.
- add/delete basechain and update table flags: Iterate over the transaction
  list to search for basechain updates from the table update path.

In both cases, the batch is rejected. Based on suggestion from Florian Westphal.

Fixes: b9703ed44ffb ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
Fixes: 7d937b107108f ("netfilter: nf_tables: support for deleting devices in an existing netdev chain")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a1a8030e16a5..086d85fffeb1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1200,6 +1200,25 @@ static void nf_tables_table_disable(struct net *net, struct nft_table *table)
 					 __NFT_TABLE_F_WAS_AWAKEN | \
 					 __NFT_TABLE_F_WAS_ORPHAN)
 
+static bool nft_table_pending_update(const struct nft_ctx *ctx)
+{
+	struct nftables_pernet *nft_net = nft_pernet(ctx->net);
+	struct nft_trans *trans;
+
+	if (ctx->table->flags & __NFT_TABLE_F_UPDATE)
+		return true;
+
+	list_for_each_entry(trans, &nft_net->commit_list, list) {
+		if ((trans->msg_type == NFT_MSG_NEWCHAIN ||
+		     trans->msg_type == NFT_MSG_DELCHAIN) &&
+		    trans->ctx.table == ctx->table &&
+		    nft_trans_chain_update(trans))
+			return true;
+	}
+
+	return false;
+}
+
 static int nf_tables_updtable(struct nft_ctx *ctx)
 {
 	struct nft_trans *trans;
@@ -1226,7 +1245,7 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 		return -EOPNOTSUPP;
 
 	/* No dormant off/on/off/on games in single transaction */
-	if (ctx->table->flags & __NFT_TABLE_F_UPDATE)
+	if (nft_table_pending_update(ctx))
 		return -EINVAL;
 
 	trans = nft_trans_alloc(ctx, NFT_MSG_NEWTABLE,
@@ -2631,6 +2650,13 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 		}
 	}
 
+	if (table->flags & __NFT_TABLE_F_UPDATE &&
+	    !list_empty(&hook.list)) {
+		NL_SET_BAD_ATTR(extack, attr);
+		err = -EOPNOTSUPP;
+		goto err_hooks;
+	}
+
 	if (!(table->flags & NFT_TABLE_F_DORMANT) &&
 	    nft_is_base_chain(chain) &&
 	    !list_empty(&hook.list)) {
@@ -2860,6 +2886,9 @@ static int nft_delchain_hook(struct nft_ctx *ctx,
 	struct nft_trans *trans;
 	int err;
 
+	if (ctx->table->flags & __NFT_TABLE_F_UPDATE)
+		return -EOPNOTSUPP;
+
 	err = nft_chain_parse_hook(ctx->net, basechain, nla, &chain_hook,
 				   ctx->family, chain->flags, extack);
 	if (err < 0)
-- 
2.30.2

