Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D78387482;
	Mon,  8 Apr 2024 21:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712611128; cv=none; b=GS6ybmFUvK3WwKiuy5N/7/H74+UwezDJ7A3DcfFrik3Gxvc/5eyZB4U/wV920Vj7N4QlLrYmlx6zRsf53yqMTh4SKRaWnduTUQ3mYd2GP7ZmyBaLslK8A0xOFIjZUo1e1TtIy3cGTruaTytffYvHZe3Nxeauzf5E4k2kP09eM8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712611128; c=relaxed/simple;
	bh=jhQtro2x0VcZsLsn8ijWrmfC7iAhPTNcpGgEdcgrbws=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ssiqVapy704EFpsKK+gSLMtLMSBfRWjEr9HtJ7erpoatUdUffJVnmxBQM6MrL8DC3UMoiL2atDLrGnTF8403mDqrRZNieB/Sr4j5p3kHS7bDED+sx8QIElXnJ1I56Cxd3CMCkw3aGg9/uOlCd3yKmVEB680IFDpZ+jyR4m5H+cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: stable@vger.kernel.org,
	gregkh@linuxfoundation.org,
	sashal@kernel.org
Subject: [PATCH -stable 6.1.x 3/3] netfilter: nf_tables: discard table flag update with pending basechain deletion
Date: Mon,  8 Apr 2024 23:18:34 +0200
Message-Id: <20240408211834.311982-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240408211834.311982-1-pablo@netfilter.org>
References: <20240408211834.311982-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 1bc83a019bbe268be3526406245ec28c2458a518 upstream.

Hook unregistration is deferred to the commit phase, same occurs with
hook updates triggered by the table dormant flag. When both commands are
combined, this results in deleting a basechain while leaving its hook
still registered in the core.

Fixes: 179d9ba5559a ("netfilter: nf_tables: fix table flag updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e7b31c2c92df..8152a69d8268 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1192,6 +1192,24 @@ static void nf_tables_table_disable(struct net *net, struct nft_table *table)
 #define __NFT_TABLE_F_UPDATE		(__NFT_TABLE_F_WAS_DORMANT | \
 					 __NFT_TABLE_F_WAS_AWAKEN)
 
+static bool nft_table_pending_update(const struct nft_ctx *ctx)
+{
+	struct nftables_pernet *nft_net = nft_pernet(ctx->net);
+	struct nft_trans *trans;
+
+	if (ctx->table->flags & __NFT_TABLE_F_UPDATE)
+		return true;
+
+	list_for_each_entry(trans, &nft_net->commit_list, list) {
+		if (trans->ctx.table == ctx->table &&
+		    trans->msg_type == NFT_MSG_DELCHAIN &&
+		    nft_is_base_chain(trans->ctx.chain))
+			return true;
+	}
+
+	return false;
+}
+
 static int nf_tables_updtable(struct nft_ctx *ctx)
 {
 	struct nft_trans *trans;
@@ -1215,7 +1233,7 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 		return -EOPNOTSUPP;
 
 	/* No dormant off/on/off/on games in single transaction */
-	if (ctx->table->flags & __NFT_TABLE_F_UPDATE)
+	if (nft_table_pending_update(ctx))
 		return -EINVAL;
 
 	trans = nft_trans_alloc(ctx, NFT_MSG_NEWTABLE,
-- 
2.30.2

