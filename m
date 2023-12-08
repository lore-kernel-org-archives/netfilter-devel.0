Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ZHHBotjO"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0ABD121
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Dec 2023 05:01:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jsY+4qPY1sZ2vUBod2H8lHSjlIA5Zn9Oa3y8zcxI9bM=; b=ZHHBotjOwYTbKUmIkEHHHK6JIS
	B6ysAKtuO6iIYcn/w8N/RC5XyP73aP0kkPFhwnfa4YHKjGuLheFeTeYnWtSJKS74p3Jmt/iqCUOh8
	5ayoe5UldBIv0VzOU2pDJAXns7NYIb7KeOgFsF8Y6yRxTXLSzHyc+HyCsKRXg87awMMZlDIgx/bRd
	a58k1PWo5RVKxF5Cxb7GeM9WBbQufaIY4XhDahCgvw08lHQOn+wnFzJ4WamCXmavX8xycSmmGxvrz
	6DEOLIZGY2nLrpWRWzN8hBliL/yA+YOG5AuxwdNuZ4VjoSup5lco2qPuZ8Mm6bmNYu3VfRsZe9V2p
	xdYpWjag==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rBaTb-00086Y-78; Fri, 08 Dec 2023 14:01:07 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH] netfilter: nf_tables: Support updating table's owner flag
Date: Fri,  8 Dec 2023 14:01:03 +0100
Message-ID: <20231208130103.26931-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A process may take ownership of an existing table not owned yet or free
a table it owns already.

A practical use-case is Firewalld's CleanupOnExit=no option: If it
starts creating its own tables with owner flag, dropping that flag upon
program exit is the easiest solution to make the ruleset survive.

Mostly for consistency, this patch enables taking ownership of an
existing table, too. This would allow firewalld to retake the ruleset it
has previously left.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a75dcce2c6c4..ef89298cd11a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1198,24 +1198,21 @@ static void nf_tables_table_disable(struct net *net, struct nft_table *table)
 static int nf_tables_updtable(struct nft_ctx *ctx)
 {
 	struct nft_trans *trans;
-	u32 flags;
+	u32 flags = 0;
 	int ret;
 
-	if (!ctx->nla[NFTA_TABLE_FLAGS])
-		return 0;
+	if (ctx->nla[NFTA_TABLE_FLAGS])
+		flags = ntohl(nla_get_be32(ctx->nla[NFTA_TABLE_FLAGS]));
 
-	flags = ntohl(nla_get_be32(ctx->nla[NFTA_TABLE_FLAGS]));
 	if (flags & ~NFT_TABLE_F_MASK)
 		return -EOPNOTSUPP;
 
 	if (flags == ctx->table->flags)
 		return 0;
 
-	if ((nft_table_has_owner(ctx->table) &&
-	     !(flags & NFT_TABLE_F_OWNER)) ||
-	    (!nft_table_has_owner(ctx->table) &&
-	     flags & NFT_TABLE_F_OWNER))
-		return -EOPNOTSUPP;
+	if (nft_table_has_owner(ctx->table) &&
+	    ctx->table->nlpid != ctx->portid)
+		return -EPERM;
 
 	/* No dormant off/on/off/on games in single transaction */
 	if (ctx->table->flags & __NFT_TABLE_F_UPDATE)
@@ -1226,6 +1223,14 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 	if (trans == NULL)
 		return -ENOMEM;
 
+	if (flags & NFT_TABLE_F_OWNER) {
+		ctx->table->flags |= NFT_TABLE_F_OWNER;
+		ctx->table->nlpid = ctx->portid;
+	} else if (nft_table_has_owner(ctx->table)) {
+		ctx->table->flags &= ~NFT_TABLE_F_OWNER;
+		ctx->table->nlpid = 0;
+	}
+
 	if ((flags & NFT_TABLE_F_DORMANT) &&
 	    !(ctx->table->flags & NFT_TABLE_F_DORMANT)) {
 		ctx->table->flags |= NFT_TABLE_F_DORMANT;
-- 
2.41.0

