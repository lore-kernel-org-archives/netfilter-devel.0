Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C0920C014
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2024 14:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729089115; cv=none; b=lJ4tClO6Ujz0K7dJhg4pTJKBpO4Wp8nVfHTaF7PRBEPelaBGUfLTqSzjZyRvGKw34ktqXGw1IWE/7So3ob2dGwgYNQmrhG3CKKhJaOBYT2xkM6B/dqM/7eQUs+fcsW31din0lbYqHk0mA8CUMAwt8fgz7XMwUkterpypGSn1zis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729089115; c=relaxed/simple;
	bh=mrcMwvMvrMHRX0OTdbMJWaTkHIJCHw7ZYamQburPs2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OM9m3yHBNMBOdmSS4C/PxBsWIW0XvwtbUQGxYtJ5ZEO3m9BPoTYl3p7iEkVkyZW8bzP0LQStk8dWKTEKksvvMp927dRqEicK1ERPbqxc+glpN8uWp+8v+s23wFQvfk6i6/+eyzhGmgIfUQHbaugfXusRIiCq8BrFFeHSwW0lwKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1t1544-0002B7-99; Wed, 16 Oct 2024 16:31:52 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v3 3/5] netfiler: nf_tables: preemitve fix for audit failure
Date: Wed, 16 Oct 2024 15:19:10 +0200
Message-ID: <20241016131917.17193-4-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241016131917.17193-1-fw@strlen.de>
References: <20241016131917.17193-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Nftables audit log unfortunately leaks implementation detail, the
transaction log size, to userspace.

Without this, nft_audit.sh selftest fails once subsequenct NEW/DELELEM
transactions can be compressed.

Thus increment the audit counter by the number of elements to keep
the output identical.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v3: this patch is new to prevent nft_audit.sh from breaking
 after next patch.

 net/netfilter/nf_tables_api.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d88adbd96ebe..bcb069057a53 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10373,9 +10373,26 @@ static void nf_tables_commit_audit_free(struct list_head *adl)
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
@@ -10385,7 +10402,7 @@ static void nf_tables_commit_audit_collect(struct list_head *adl,
 	WARN_ONCE(1, "table=%s not expected in commit list", table->name);
 	return;
 found:
-	adp->entries++;
+	adp->entries += nf_tables_commit_audit_entrycount(trans);
 	if (!adp->op || adp->op > op)
 		adp->op = op;
 }
@@ -10544,7 +10561,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 
 		nft_ctx_update(&ctx, trans);
 
-		nf_tables_commit_audit_collect(&adl, table, trans->msg_type);
+		nf_tables_commit_audit_collect(&adl, trans, trans->msg_type);
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWTABLE:
 			if (nft_trans_table_update(trans)) {
-- 
2.45.2

