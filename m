Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0D9D6CDDB
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Apr 2024 11:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712143121; cv=none; b=j4zFT7ptgpgT1U2A0lvDJ/M7mL61FdNRPgxR/1AzpBFmOt4fW9xQzLG6YXt9yNLPLqRbpoNJsJ5SIZ5oz1navdOVTls6u4Bf8RU7YPD5qIcSiiN2RFv8a6Z6mCNStLTV7Et4CQTGtDCoFCU5OSSpFQ9QcTBS5dV4540GBwAdlmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712143121; c=relaxed/simple;
	bh=vgx02VcY1TDZ3tHm/olfcuX8fBHVL/H915SkMCVMKuc=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=k82tSpC6Xi/2gTfraCf7V87EhvDeZyWvjfNyGp1RaXBmDLJA8xcWd3ILnZrxbfMSroUpl5v8bkLHRzqqueT9DHUAm6ST9aVLfLOlc1FuifXl5Lazs4fUq5aGlJb9ugYkYJc+6LIwkOH8bSMr+HFsd92xiK1rZcb6Asm/dfGR5jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2 1/4] netfilter: nf_tables: release batch on table validation from abort path
Date: Wed,  3 Apr 2024 13:18:29 +0200
Message-Id: <20240403111832.234325-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Unlike early commit path stage which triggers a call to abort, an
explicit release of the batch is required on abort, otherwise mutex is
released and commit_list remains in place.

Add WARN_ON_ONCE to ensure commit_list is empty from the abort path
before releasing the mutex.

After this patch, commit_list is always assumed to be empty before
grabbing the mutex, therefore

  03c1f1ef1584 ("netfilter: Cleanup nft_net->module_list from nf_tables_exit_net()")

only needs to release the pending modules for registration.

Cc: stable@vger.kernel.org
Fixes: c0391b6ab810 ("netfilter: nf_tables: missing validation from the abort path")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: Kuan-Ting Chen reported a kmemleak of modules in module_list in v1.

 net/netfilter/nf_tables_api.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index fd86f2720c9e..ffcd3213c335 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10455,10 +10455,11 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 	struct nft_trans *trans, *next;
 	LIST_HEAD(set_update_list);
 	struct nft_trans_elem *te;
+	int err = 0;
 
 	if (action == NFNL_ABORT_VALIDATE &&
 	    nf_tables_validate(net) < 0)
-		return -EAGAIN;
+		err = -EAGAIN;
 
 	list_for_each_entry_safe_reverse(trans, next, &nft_net->commit_list,
 					 list) {
@@ -10655,7 +10656,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 	else
 		nf_tables_module_autoload_cleanup(net);
 
-	return 0;
+	return err;
 }
 
 static int nf_tables_abort(struct net *net, struct sk_buff *skb,
@@ -10668,6 +10669,9 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb,
 	gc_seq = nft_gc_seq_begin(nft_net);
 	ret = __nf_tables_abort(net, action);
 	nft_gc_seq_end(nft_net, gc_seq);
+
+	WARN_ON_ONCE(!list_empty(&nft_net->commit_list));
+
 	mutex_unlock(&nft_net->commit_mutex);
 
 	return ret;
@@ -11473,9 +11477,10 @@ static void __net_exit nf_tables_exit_net(struct net *net)
 
 	gc_seq = nft_gc_seq_begin(nft_net);
 
-	if (!list_empty(&nft_net->commit_list) ||
-	    !list_empty(&nft_net->module_list))
-		__nf_tables_abort(net, NFNL_ABORT_NONE);
+	WARN_ON_ONCE(!list_empty(&nft_net->commit_list));
+
+	if (!list_empty(&nft_net->module_list))
+		nf_tables_module_autoload_cleanup(net);
 
 	__nft_release_tables(net);
 
-- 
2.30.2

