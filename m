Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247122C6B2
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Dec 2023 12:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="VxSKDGuL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=q4p89AsaH5gHlZGd2tYWuj5DSg7/WX7erNm33AF/Jxk=; b=VxSKDGuLnOHtFNXA685DIDponz
	NfFaEEzm2qSB+KrUB71L/3+hYBCiXbpQrVIdJ3xaEtm9B+TBJhIbJ1YzEbBEj3F931ucs2Ub4dynO
	Tl0pE6USHFq4c/E9hwlax7zrFoDFb2Q0zPPJel5AcASYg+tVfcnnsZUKcGEc1KHB3dwRcYU9OXkCy
	ZJCfmcGiD4yIJY3ZjzyHrrI/wTGlhoLL0rqssgcrmoCx8aYJs4rPkmDGUylcSAW2U94rE/8//oSul
	ac5ZhH7xM1H2CdfZgyPPz/ph59640B9SP0ptyt7NnsSfWbA/JGew35uixqyntBb3bdSMLRRQnbP0k
	jd+fAeMw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rE7Iv-0001JJ-CC; Fri, 15 Dec 2023 13:28:33 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>,
	netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH] netfilter: nf_tables: Introduce NFT_TABLE_F_PERSIST
Date: Fri, 15 Dec 2023 13:26:27 +0100
Message-ID: <20231215122627.19686-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This companion flag to NFT_TABLE_F_OWNER requests the kernel to keep the
table around after the process has exited. It marks such table as
orphaned and allows another process to retake ownership later.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/uapi/linux/netfilter/nf_tables.h |  6 +++-
 net/netfilter/nf_tables_api.c            | 37 ++++++++++++++++++------
 2 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index ca30232b7bc8..3fee994721cd 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -179,13 +179,17 @@ enum nft_hook_attributes {
  * enum nft_table_flags - nf_tables table flags
  *
  * @NFT_TABLE_F_DORMANT: this table is not active
+ * @NFT_TABLE_F_OWNER:   this table is owned by a process
+ * @NFT_TABLE_F_PERSIST: this table shall outlive its owner
  */
 enum nft_table_flags {
 	NFT_TABLE_F_DORMANT	= 0x1,
 	NFT_TABLE_F_OWNER	= 0x2,
+	NFT_TABLE_F_PERSIST	= 0x4,
 };
 #define NFT_TABLE_F_MASK	(NFT_TABLE_F_DORMANT | \
-				 NFT_TABLE_F_OWNER)
+				 NFT_TABLE_F_OWNER | \
+				 NFT_TABLE_F_PERSIST)
 
 /**
  * enum nft_table_attributes - nf_tables table netlink attributes
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a75dcce2c6c4..cca2741f47be 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1198,24 +1198,29 @@ static void nf_tables_table_disable(struct net *net, struct nft_table *table)
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
+	if (nft_table_has_owner(ctx->table)) {
+		if (ctx->table->nlpid != ctx->portid)
+			return -EPERM;
+		if (!(flags & NFT_TABLE_F_OWNER))
+			return -EOPNOTSUPP;
+	}
+
+	if (flags & NFT_TABLE_F_OWNER &&
+	    !nft_table_has_owner(ctx->table) &&
+	    !(ctx->table->flags & NFT_TABLE_F_PERSIST))
+		return -EPERM;
 
 	/* No dormant off/on/off/on games in single transaction */
 	if (ctx->table->flags & __NFT_TABLE_F_UPDATE)
@@ -1226,6 +1231,16 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 	if (trans == NULL)
 		return -ENOMEM;
 
+	if (flags & NFT_TABLE_F_OWNER) {
+		ctx->table->flags &= ~NFT_TABLE_F_PERSIST;
+		ctx->table->flags |= flags & NFT_TABLE_F_PERSIST;
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
@@ -11373,6 +11388,10 @@ static int nft_rcv_nl_event(struct notifier_block *this, unsigned long event,
 	list_for_each_entry(table, &nft_net->tables, list) {
 		if (nft_table_has_owner(table) &&
 		    n->portid == table->nlpid) {
+			if (table->flags & NFT_TABLE_F_PERSIST) {
+				table->flags &= ~NFT_TABLE_F_OWNER;
+				continue;
+			}
 			__nft_release_hook(net, table);
 			list_del_rcu(&table->list);
 			to_delete[deleted++] = table;
-- 
2.43.0

