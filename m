Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438E8768FC
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Dec 2023 13:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="KHWAt/IE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=wVePy9H0e8YOb2rIthlrpC+TQHa2sM6MASqBcRYCsY4=; b=KHWAt/IEAQPlizbrFZvUX0yyKJ
	Ln3imLtuG5fUHSc5nN9W3UsSY4JO2ZJosQowfNmhYlOAVXcVNtXcaKawUs9j/6x88AU+7YZMmuv+U
	LJDtAlLrxDQOgqeas6//XUgcovQAcKErJFz8eiqLNHi7IwIkvqjArw2NC3HapqWHrSeLQiwPQ7K4k
	wOQR0ECUhKZzsinyFULt7sv8D5pep2VzBy6druR6pweqARIH0+ZbT4LYZ0KiLrarOS2L3U3nByRCM
	bgMvtSI3RwyhUWOJMhBi6IaGTBVrIk2V5ovgi4rzGjU26bJ9J7nitpKqoK5ICh+Z656MtkU/pGw8g
	6fA2+YOw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rGJ9e-0004TV-R9; Thu, 21 Dec 2023 14:32:02 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v2 3/3] netfilter: nf_tables: Implement table adoption support
Date: Thu, 21 Dec 2023 14:31:59 +0100
Message-ID: <20231221133159.31198-4-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231221133159.31198-1-phil@nwl.cc>
References: <20231221133159.31198-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow a new process to take ownership of a previously owned table,
useful mostly for firewall management services restarting or suspending
when idle.

By extending __NFT_TABLE_F_UPDATE, the on/off/on check in
nf_tables_updtable() also covers table adoption, although it is actually
not needed: Table adoption is irreversible because nf_tables_updtable()
rejects attempts to drop NFT_TABLE_F_OWNER so table->nlpid setting can
happen just once within the transaction.

If the transaction commences, table's nlpid and flags fields are already
set and no further action is required. If it aborts, the table returns
to orphaned state.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/net/netfilter/nf_tables.h |  6 ++++++
 net/netfilter/nf_tables_api.c     | 19 ++++++++++++++++---
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index b157c5cafd14..d4b162363351 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1244,6 +1244,12 @@ static inline bool nft_table_has_owner(const struct nft_table *table)
 	return table->flags & NFT_TABLE_F_OWNER;
 }
 
+static inline bool nft_table_is_orphan(const struct nft_table *table)
+{
+	return (table->flags & (NFT_TABLE_F_OWNER | NFT_TABLE_F_PERSIST)) ==
+			NFT_TABLE_F_PERSIST;
+}
+
 static inline bool nft_base_chain_netdev(int family, u32 hooknum)
 {
 	return family == NFPROTO_NETDEV ||
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c90e8e47a3f3..fff9c15dbaa0 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1193,8 +1193,10 @@ static void nf_tables_table_disable(struct net *net, struct nft_table *table)
 #define __NFT_TABLE_F_INTERNAL		(NFT_TABLE_F_MASK + 1)
 #define __NFT_TABLE_F_WAS_DORMANT	(__NFT_TABLE_F_INTERNAL << 0)
 #define __NFT_TABLE_F_WAS_AWAKEN	(__NFT_TABLE_F_INTERNAL << 1)
+#define __NFT_TABLE_F_WAS_ORPHAN	(__NFT_TABLE_F_INTERNAL << 2)
 #define __NFT_TABLE_F_UPDATE		(__NFT_TABLE_F_WAS_DORMANT | \
-					 __NFT_TABLE_F_WAS_AWAKEN)
+					 __NFT_TABLE_F_WAS_AWAKEN | \
+					 __NFT_TABLE_F_WAS_ORPHAN)
 
 static int nf_tables_updtable(struct nft_ctx *ctx)
 {
@@ -1214,8 +1216,8 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 
 	if ((nft_table_has_owner(ctx->table) &&
 	     !(flags & NFT_TABLE_F_OWNER)) ||
-	    (!nft_table_has_owner(ctx->table) &&
-	     flags & NFT_TABLE_F_OWNER))
+	    (flags & NFT_TABLE_F_OWNER &&
+	     !nft_table_is_orphan(ctx->table)))
 		return -EOPNOTSUPP;
 
 	if ((flags ^ ctx->table->flags) & NFT_TABLE_F_PERSIST)
@@ -1247,6 +1249,13 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 		}
 	}
 
+	if ((flags & NFT_TABLE_F_OWNER) &&
+	    !nft_table_has_owner(ctx->table)) {
+		ctx->table->nlpid = ctx->portid;
+		ctx->table->flags |= NFT_TABLE_F_OWNER |
+				     __NFT_TABLE_F_WAS_ORPHAN;
+	}
+
 	nft_trans_table_update(trans) = true;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
 
@@ -10449,6 +10458,10 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				} else if (trans->ctx.table->flags & __NFT_TABLE_F_WAS_AWAKEN) {
 					trans->ctx.table->flags &= ~NFT_TABLE_F_DORMANT;
 				}
+				if (trans->ctx.table->flags & __NFT_TABLE_F_WAS_ORPHAN) {
+					trans->ctx.table->flags &= ~NFT_TABLE_F_OWNER;
+					trans->ctx.table->nlpid = 0;
+				}
 				trans->ctx.table->flags &= ~__NFT_TABLE_F_UPDATE;
 				nft_trans_destroy(trans);
 			} else {
-- 
2.43.0

