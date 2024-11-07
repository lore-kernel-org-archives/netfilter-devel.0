Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952742161FA
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Nov 2024 17:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731001612; cv=none; b=Cx6GsNfRk7A/yBX7aC88dgb+XjQy+yWZQbD+fzQD5WlztErZAI1xJ690GT87h9sahHkBMmPcL0meQF9GGjHb0ysEiKJSlAf9PVwd0e9/5zET0Ac39YAjBjMN2tdq0KihFWMhK5th1Fa5ZIepNBtl/jvBfrFdqOKPJCUfbUGU3JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731001612; c=relaxed/simple;
	bh=Q8bkKGc/U6Z2hT5/DHy459wjiWFfWb9mFy/y8SSt2AM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eajWjlC0et880XH1h+C5DRULtQ15QNRKzJf0U9agduCJaONMsqJTCRl0hzva5CuE/ym/wYBTLPOgRSSBWbRymYjkWaCkmcTK8X8urPjubJ6VW0ZIBPdod/sWKrQ1dSR2itgguYziW7HCPnIuONgtoMW7wgI2J6mzrFYPhq/Lmfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1t96am-0007LJ-Rh; Thu, 07 Nov 2024 18:46:48 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v4 3/5] netfilter: nf_tables: preemptive fix for audit selftest failure
Date: Thu,  7 Nov 2024 18:44:07 +0100
Message-ID: <20241107174415.4690-4-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241107174415.4690-1-fw@strlen.de>
References: <20241107174415.4690-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nftables audit log format unfortunately leaks an implementation detail, the
transaction log size, to userspace:

    table=t1 family=2 entries=4 op=nft_register_set
                      ~~~~~~~~~

This 'entries' key is the number of transactions that will be applied.
The upcoming set element compression (add elem x to set s, add element y
to s would be placed in a single transaction request) would lower that
number to 3.

~ncrement the audit counter by the number of elements to keep the reported
entries value the same.

Without this, nft_audit.sh selftest fails because the recorded
(expected) entries key is smaller than the expected one.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5eab6f121684..bdf5ba21c76d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10397,9 +10397,26 @@ static void nf_tables_commit_audit_free(struct list_head *adl)
 	}
 }
 
+/* Silly, but existing test audit test cases require a count
+ * value derived from the (INTERNAL!) transaction log length.
+ *
+ * Thus, compaction of NEW/DELSETELEM breaks such tests.
+ */
+static unsigned int nf_tables_commit_audit_entrycount(const struct nft_trans *trans)
+{
+	switch (trans->msg_type) {
+	case NFT_MSG_NEWSETELEM:
+	case NFT_MSG_DELSETELEM:
+		return nft_trans_container_elem(trans)->nelems;
+	}
+
+	return 1;
+}
+
 static void nf_tables_commit_audit_collect(struct list_head *adl,
-					   struct nft_table *table, u32 op)
+					   const struct nft_trans *trans, u32 op)
 {
+	const struct nft_table *table = trans->table;
 	struct nft_audit_data *adp;
 
 	list_for_each_entry(adp, adl, list) {
@@ -10409,7 +10426,7 @@ static void nf_tables_commit_audit_collect(struct list_head *adl,
 	WARN_ONCE(1, "table=%s not expected in commit list", table->name);
 	return;
 found:
-	adp->entries++;
+	adp->entries += nf_tables_commit_audit_entrycount(trans);
 	if (!adp->op || adp->op > op)
 		adp->op = op;
 }
@@ -10568,7 +10585,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 
 		nft_ctx_update(&ctx, trans);
 
-		nf_tables_commit_audit_collect(&adl, table, trans->msg_type);
+		nf_tables_commit_audit_collect(&adl, trans, trans->msg_type);
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWTABLE:
 			if (nft_trans_table_update(trans)) {
-- 
2.45.2

