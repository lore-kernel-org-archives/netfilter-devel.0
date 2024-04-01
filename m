Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ED89249E4
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Apr 2024 18:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711997238; cv=none; b=aeV7/+IFcxUGnUm0/JAVAgedn67L98NQr8detWueEDqaqTY/2Mw/sxjCBj+OkIi85p5oAzjauj14xk6uuXW4U87/bkjshvlBAc3EhICdUUYFbOARGQK34Dt+44WzpNO17ofUVGgWytkAC1aF4UJ0p+RAZFFxiBMkMLh+pPSJCi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711997238; c=relaxed/simple;
	bh=Tmk3I3pYKnrp9ySh/tqaElGqvl+g1j575M71Yqd22c0=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lp+9ZnWCi1Ncxuaq1D4lcyYPW3zmeyqx/F4mI9PXiVkgu7iDSg2WmITEYebK4SxToP+w0HdUopAksTAbHAFlBTfY9Sd++bGqqDb93mnaKwQK1/JDQxbBnOwKBDfI45Jz02/vTaqTiEOCKmOUkMWGHDhdwou3o5REogQGp7BdNbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf 2/3] netfilter: nf_tables: release mutex after nft_gc_seq_end from abort path
Date: Mon,  1 Apr 2024 20:47:09 +0200
Message-Id: <20240401184710.632714-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240401184710.632714-1-pablo@netfilter.org>
References: <20240401184710.632714-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The commit mutex should not be released during the critical section
between nft_gc_seq_begin() and nft_gc_seq_end(), otherwise, async GC
worker could collect the expired object and get the released commit lock
within the same GC sequence.

nf_tables_module_autoload() temporarily releases the mutex to load
module dependencies, then it goes back to transparently replay the
transaction again. Move it at the end of the abort phase after
nft_gc_seq_end() is called.

Cc: stable@vger.kernel.org
Fixes: 720344340fb9 ("netfilter: nf_tables: GC transaction race with abort path")
Reported-by: Kuan-Ting Chen <hexrabbit@devco.re>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f0d2bf68731c..c7b3df6a915c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10651,11 +10651,6 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		nf_tables_abort_release(trans);
 	}
 
-	if (action == NFNL_ABORT_AUTOLOAD)
-		nf_tables_module_autoload(net);
-	else
-		nf_tables_module_autoload_cleanup(net);
-
 	return err;
 }
 
@@ -10672,6 +10667,14 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb,
 
 	WARN_ON_ONCE(!list_empty(&nft_net->commit_list));
 
+	/* module autoload needs to happen after GC sequence update because it
+	 * temporarily releases and grabs mutex again.
+	 */
+	if (action == NFNL_ABORT_AUTOLOAD)
+		nf_tables_module_autoload(net);
+	else
+		nf_tables_module_autoload_cleanup(net);
+
 	mutex_unlock(&nft_net->commit_mutex);
 
 	return ret;
-- 
2.30.2

