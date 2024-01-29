Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AEF154438;
	Mon, 29 Jan 2024 15:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706542291; cv=none; b=TGFVa4/uBzIIBGrDKCgoeVUDeT8rpzUDkU1GXEXYrbIDD1ZwO0Xn9OWHeD4rq6/WmYA1IrVhAlDxsHlaV67xtP+BZ4IEt/JBo8AVtU/BHgiXQ4eUS23juMU+FBmGB+/wGKp5qDBYRInndFoc5/rYcmUIjlvzvNmvwky6SkmsMP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706542291; c=relaxed/simple;
	bh=VJ56BV+bpfqPZmjDLe35hc8oJ0QB/ctBiT+04zb+3SM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qR3msP5rJEqPx7g0naPdLxq/AUOGaEsaNpIaA3ArY61ex3C0XVlRKjtDv4QWvTKY0dUxsbDEAvXPiauAlNtC8IKqMw9kseg/1aCmqbPJR0bmvMw7WcuSEqGylVFGU2Uluq93r42Qu1W3AGgaee2g0Fejsp7eODrtMg0MoWMAFMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rUTbT-00020B-2k; Mon, 29 Jan 2024 16:31:19 +0100
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	Phil Sutter <phil@nwl.cc>
Subject: [PATCH nf-next 2/9] netfilter: nf_tables: Introduce NFT_TABLE_F_PERSIST
Date: Mon, 29 Jan 2024 15:57:52 +0100
Message-ID: <20240129145807.8773-3-fw@strlen.de>
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

This companion flag to NFT_TABLE_F_OWNER requests the kernel to keep the
table around after the process has exited. It marks such table as
orphaned (by dropping OWNER flag but keeping PERSIST flag in place),
which opens it for other processes to manipulate. For the sake of
simplicity, PERSIST flag may not be altered though.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Florian Westphal <fw@strlen.de>
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
index c537104411e7..6a96f0003faa 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1219,6 +1219,9 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 	     flags & NFT_TABLE_F_OWNER))
 		return -EOPNOTSUPP;
 
+	if ((flags ^ ctx->table->flags) & NFT_TABLE_F_PERSIST)
+		return -EOPNOTSUPP;
+
 	/* No dormant off/on/off/on games in single transaction */
 	if (ctx->table->flags & __NFT_TABLE_F_UPDATE)
 		return -EINVAL;
@@ -11345,6 +11348,10 @@ static int nft_rcv_nl_event(struct notifier_block *this, unsigned long event,
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

