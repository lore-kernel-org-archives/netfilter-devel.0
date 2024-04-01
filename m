Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D077D28D
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Apr 2024 18:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711997239; cv=none; b=iX0DkUZSthQbWyn3osx2nK9H903HzgyoJ/lloJVi9Ern1VH//biIJ41O4XMEwAcymfbuF9a+lLBUGAaSUhavkzojRAtAdbUMrUSCJ7UXQNKuwMUcU/D9+FlzrrtPpp+kfol/4CDY+01O/BokIU5HHY1qaFB6U0UwjRHqxqOk4sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711997239; c=relaxed/simple;
	bh=A86iLn1Bpul2Smzmry3l9QCeH7KhDVTJvxUNfIpLvew=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=l+bGwM0FTMWRiwFVtF8QPQSbCNoUhZTvmDAG7PVFeLHdKB36bbT2mYY/kN+bZ7YI3o0H7f3a10VKPBgNt1sczXfzw/d+wmJ15jZczkx7CzLN4k3br3p6lRvQjQSpP88kVakAdl446rTmvcbxzr47hiBPoUn1ngy/vkBl7EdIlQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf 1/3] netfilter: nf_tables: release batch on table validation from abort path
Date: Mon,  1 Apr 2024 20:47:08 +0200
Message-Id: <20240401184710.632714-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Unlikely early commit path stage which triggers a call to abort, an
explicit release of the batch is required on abort, otherwise mutex is
released and commit_list remains in place.

Add WARN_ON_ONCE to ensure commit_list is empty from the abort path
before releasing the mutex.

Cc: stable@vger.kernel.org
Fixes: c0391b6ab810 ("netfilter: nf_tables: missing validation from the abort path")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index fd86f2720c9e..f0d2bf68731c 100644
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
-- 
2.30.2

