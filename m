Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7E7153BCC;
	Mon, 29 Jan 2024 15:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706542289; cv=none; b=IGXvnFEdU6di3/da9qXcFbpOJhE4NwOFPsCUXdo/lsK2RQ+6ozfrT+QyZr2u2KKS21Xiv17HHJ+ntags176mjURPEcP2n7Ps4AhisMFWalUPKc9dUUjpUec1ym3IDjXgEggAfjNFtL6F/MWJw5COIGPy6ECubGiLCSLeQJUm9kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706542289; c=relaxed/simple;
	bh=dKulQXqXWVw9DRzCSEiv2mw41rZBp4VyGqqm5mopIN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0sJw2E9FVRNTk4lbaYKa3sJv1FAQSYkNFnM9X2lKaKaBvoKa+li3mXNh1+OnxaBVmI6x6ccUWPU0tv5uh8koD9W1BM5x+eh6gy6FvHqFBsfS5y+ifOurC6vo9S1vzdIQsFX3m1AwJkSD3crWAwb3BATBxXZhtToDr0/ndLGmgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rUTbU-00020T-Bv; Mon, 29 Jan 2024 16:31:20 +0100
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	Phil Sutter <phil@nwl.cc>
Subject: [PATCH nf-next 3/9] netfilter: nf_tables: Implement table adoption support
Date: Mon, 29 Jan 2024 15:57:53 +0100
Message-ID: <20240129145807.8773-4-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129145807.8773-1-fw@strlen.de>
References: <20240129145807.8773-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

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
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h |  6 ++++++
 net/netfilter/nf_tables_api.c     | 19 ++++++++++++++++---
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 4e1ea18eb5f0..ac7c94d3648e 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1271,6 +1271,12 @@ static inline bool nft_table_has_owner(const struct nft_table *table)
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
index 6a96f0003faa..b0e0d039897e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1194,8 +1194,10 @@ static void nf_tables_table_disable(struct net *net, struct nft_table *table)
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
@@ -1215,8 +1217,8 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 
 	if ((nft_table_has_owner(ctx->table) &&
 	     !(flags & NFT_TABLE_F_OWNER)) ||
-	    (!nft_table_has_owner(ctx->table) &&
-	     flags & NFT_TABLE_F_OWNER))
+	    (flags & NFT_TABLE_F_OWNER &&
+	     !nft_table_is_orphan(ctx->table)))
 		return -EOPNOTSUPP;
 
 	if ((flags ^ ctx->table->flags) & NFT_TABLE_F_PERSIST)
@@ -1248,6 +1250,13 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
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
 
@@ -10423,6 +10432,10 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
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

