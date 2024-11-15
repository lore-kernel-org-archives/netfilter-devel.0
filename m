Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB2CC1CD213;
	Fri, 15 Nov 2024 13:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731677544; cv=none; b=IvGj0Hy4d+Ihe7yswLAIF28f4Db+ytLG8DlgoKt41Rc5sW5pv4KeRfVftDLm+DGIIGReeKMRY1iWdXrQ/VL6MeJviJgPmV3ljTEEJuzt0dxIgSgEopHjKwgkPIm9Hd+2de15LWjSV2gPGAZkPvF9PHW/sHpVDXXAyeTnvppvVHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731677544; c=relaxed/simple;
	bh=AeYqxV4k8SsN68NRq6U751zU4sGPlP6WAkGt/O3vNeY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hfIZbcMT8VWqf8Y6OlCHoy/fkUW+iziWETJsXf33fKAOkaPubNCnkOG0/SW/u1BzuAE3ROvaUJlrhrQQXxiDv+gpnlfs0lJLbXv0g6EDC/NFB+u1p1YKafwf9f/AU2I1VGCq5osWzqKMeYihEDmJpYBi+xCrPXzdYd0Yu5wS56s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 05/14] netfilter: nf_tables: prepare nft audit for set element compaction
Date: Fri, 15 Nov 2024 14:31:58 +0100
Message-Id: <20241115133207.8907-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241115133207.8907-1-pablo@netfilter.org>
References: <20241115133207.8907-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

nftables audit log format emits the number of added/deleted rules, sets,
set elements and so on, to userspace:

    table=t1 family=2 entries=4 op=nft_register_set
                      ~~~~~~~~~

At this time, the 'entries' key is the number of transactions that will
be applied.

The upcoming set element compression will coalesce subsequent
adds/deletes to the same set requests in the same transaction
request to conseve memory.

Without this patch, we'd under-report the number of altered elements.

Increment the audit counter by the number of elements to keep the reported
entries value the same.

Without this, nft_audit.sh selftest fails because the recorded
(expected) entries key is smaller than the expected one.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0882f78c2204..5b5178841553 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10398,9 +10398,24 @@ static void nf_tables_commit_audit_free(struct list_head *adl)
 	}
 }
 
+/* nft audit emits the number of elements that get added/removed/updated,
+ * so NEW/DELSETELEM needs to increment based on the total elem count.
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
@@ -10410,7 +10425,7 @@ static void nf_tables_commit_audit_collect(struct list_head *adl,
 	WARN_ONCE(1, "table=%s not expected in commit list", table->name);
 	return;
 found:
-	adp->entries++;
+	adp->entries += nf_tables_commit_audit_entrycount(trans);
 	if (!adp->op || adp->op > op)
 		adp->op = op;
 }
@@ -10569,7 +10584,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 
 		nft_ctx_update(&ctx, trans);
 
-		nf_tables_commit_audit_collect(&adl, table, trans->msg_type);
+		nf_tables_commit_audit_collect(&adl, trans, trans->msg_type);
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWTABLE:
 			if (nft_trans_table_update(trans)) {
-- 
2.30.2

