Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005FD1553AA
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Nov 2024 15:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731513372; cv=none; b=KMB2Sp/MMzZz2qSdJGBQFxVwL3I0msvBf9k9x1+NhBgL6Fl+22MFaytUq3Q8zf8pO7sCiwTeE4tIZQKWoWIezePHKVj1rfpHV7c/Vo1EAJ0/tPeIOMctTAMYF4UmO08LtQVhwXD8SyJjZ75fUJBzqtBtBGo/ZEu1LfsW/sR/x+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731513372; c=relaxed/simple;
	bh=JVJhLz+L+R+iHT5/lek9IB07aa6oy5cFVA+3USdA5yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cWDMe9xadkPzN3UUiqaEHI1pz0X9PZBo2rumnpfZvrtTOIAkn+efJxooQhpIizuQ1FrMddl2U0GEx3xDp30sJvxP+eZSNvTBRgRGh/Q2hSQfXBKouJFQ9dirGKEuWt3DyV9LeE9CnpGKhm2VJ0hR6C4kYZd/QEwnROl4yxQh1RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tBFiy-0007JG-6G; Wed, 13 Nov 2024 16:56:08 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v5 3/5] netfilter: nf_tables: prepare nft audit for set element compaction
Date: Wed, 13 Nov 2024 16:35:51 +0100
Message-ID: <20241113153557.20302-4-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241113153557.20302-1-fw@strlen.de>
References: <20241113153557.20302-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
2.45.2

