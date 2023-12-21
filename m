Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2F77690D
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Dec 2023 13:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="bbhTcHnV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=EJp9beYSEXOaF8fWMeukEThSScZ8/PjNb4KtVkPF108=; b=bbhTcHnVxRPmU8fxsbndKOuKta
	9fyJYtt72yuR0cHjtH25SQ2uNV/uvGBwt/nK4Ie+3fk1uGV80KzdHjwZa+CAEyEyqdenoU80ARDBz
	v/2KEfrj+hOJ+665ImhS5t5HWci7i67nn4auC5dmBlNQIIXgK6r10RId46AJ2+adsOmy1+ZobsU+D
	XIziQYirTG/EtSz+rIV+R6MrAhXcvvka74rX8/o8/hWWdDSL3rZ+azlLTpyAOWel18YTEtu1J+QxR
	i4AiSHY9FgETNaJmSWUkhIx4TSPVETi1nO9VUc4GGL1v6u0vhHid9EwmyTsEZzNTEROqXYWZR9oPJ
	BajGLAag==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rGJ9f-0004Tb-GC; Thu, 21 Dec 2023 14:32:03 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v2 2/3] netfilter: nf_tables: Introduce NFT_TABLE_F_PERSIST
Date: Thu, 21 Dec 2023 14:31:58 +0100
Message-ID: <20231221133159.31198-3-phil@nwl.cc>
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

This companion flag to NFT_TABLE_F_OWNER requests the kernel to keep the
table around after the process has exited. It marks such table as
orphaned (by dropping OWNER flag but keeping PERSIST flag in place),
which opens it for other processes to manipulate. For the sake of
simplicity, PERSIST flag may not be altered though.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/uapi/linux/netfilter/nf_tables.h | 5 ++++-
 net/netfilter/nf_tables_api.c            | 7 +++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index fbce238abdc1..3fee994721cd 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -180,13 +180,16 @@ enum nft_hook_attributes {
  *
  * @NFT_TABLE_F_DORMANT: this table is not active
  * @NFT_TABLE_F_OWNER:   this table is owned by a process
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
index ac43688b30ec..c90e8e47a3f3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1218,6 +1218,9 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 	     flags & NFT_TABLE_F_OWNER))
 		return -EOPNOTSUPP;
 
+	if ((flags ^ ctx->table->flags) & NFT_TABLE_F_PERSIST)
+		return -EOPNOTSUPP;
+
 	/* No dormant off/on/off/on games in single transaction */
 	if (ctx->table->flags & __NFT_TABLE_F_UPDATE)
 		return -EINVAL;
@@ -11374,6 +11377,10 @@ static int nft_rcv_nl_event(struct notifier_block *this, unsigned long event,
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

