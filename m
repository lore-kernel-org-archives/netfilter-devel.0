Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85EF1147C9F;
	Mon,  8 Apr 2024 21:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712611179; cv=none; b=P4ZyPKtm8UcD9t4S4BH4zv1eB+yxyfBZT2FPyoh3Xzs54/xzEJ3xMqEbx8nstsOc+ly23uaUo6KmSgdkFO/iECdxCUPl1+dMSvch6iujPrKJFLE2rqf6s+SijtYqqhG2cJNS8hHB+wY5PicilAr54JnonpYAxitkQW+gkAJ2qBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712611179; c=relaxed/simple;
	bh=LnbpB0qhLgeC7MGX1SQhzit35W6LvJ40Pd1rE8l6qUU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l2FOaVYtuA2s2mj4cKgxRiBNi0i05g1TIRWhM6SLdIeAZ/XAsaXUFISjbuj/EMpuqOpf1paICGIJf2zAvYkTjnCp0Oei3RKsDAxp2JKOHO969DSvsROf8wG/iGDKYVOlkS3e4IobM8vZ5I0RXTh+maJIEdHYaWF//Siv2QvFjgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: stable@vger.kernel.org,
	gregkh@linuxfoundation.org,
	sashal@kernel.org
Subject: [PATCH -stable,5.15.x 1/3] netfilter: nf_tables: release batch on table validation from abort path
Date: Mon,  8 Apr 2024 23:19:28 +0200
Message-Id: <20240408211930.312070-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240408211930.312070-1-pablo@netfilter.org>
References: <20240408211930.312070-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit a45e6889575c2067d3c0212b6bc1022891e65b91 upstream.

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
 net/netfilter/nf_tables_api.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 607f841098ad..5f6a46d55ad9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9698,10 +9698,11 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
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
@@ -9877,7 +9878,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 	else
 		nf_tables_module_autoload_cleanup(net);
 
-	return 0;
+	return err;
 }
 
 static int nf_tables_abort(struct net *net, struct sk_buff *skb,
@@ -9891,6 +9892,8 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb,
 	ret = __nf_tables_abort(net, action);
 	nft_gc_seq_end(nft_net, gc_seq);
 
+	WARN_ON_ONCE(!list_empty(&nft_net->commit_list));
+
 	mutex_unlock(&nft_net->commit_mutex);
 
 	return ret;
@@ -10688,9 +10691,10 @@ static void __net_exit nf_tables_exit_net(struct net *net)
 
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

