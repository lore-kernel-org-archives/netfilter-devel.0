Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B512E4B5A6;
	Sun, 12 May 2024 16:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715530493; cv=none; b=aO3BzrV6/EiKt21v3leia9uZszDCZI4T3Q37HnJGhH5asnbqZVWqLA0fEAZBd7XTVF5PqFG6nKGCoyOnNgsMdpKM/yerSuLds4zsqBtWl24QIt/8GPtHdsWecnPrdtWTlo/a6zMClkfdHvkvV7w11hZHyR0utyqqwNNCMCmE5/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715530493; c=relaxed/simple;
	bh=5Jrm7Aeo1VASZOcoO4uVbeprh5O37YDIz4MTycixMEo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PjdaTPlzwxT1TjcALoljDrbWfiemlCVV6T/llPDgSTEK5fTD/oynheHznC6vhJCe9xCtOZooJhh/AWpcgIP+lYfXYwcBANxKnzcHSUh7ZMzgOS0BpwgRSJCAu9zBXOfTggZGj79UZNmmxoY6RDmKUNXtD/NQacLJomckCfLiuY4=
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
Subject: [PATCH net-next 10/17] netfilter: nft_set_pipapo: prepare destroy function for on-demand clone
Date: Sun, 12 May 2024 18:14:29 +0200
Message-Id: <20240512161436.168973-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240512161436.168973-1-pablo@netfilter.org>
References: <20240512161436.168973-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Once priv->clone can be NULL in case no insertions/removals occurred
in the last transaction we need to drop set elements from priv->match
if priv->clone is NULL.

While at it, condense this function by reusing the pipapo_free_match
helper instead of open-coded version.

The rcu_barrier() is removed, its not needed: old call_rcu instances
for pipapo_reclaim_match do not access struct nft_set.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo.c | 27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 7b6d5d2d0d54..459e2dd5050c 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2326,33 +2326,18 @@ static void nft_pipapo_destroy(const struct nft_ctx *ctx,
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
 	struct nft_pipapo_match *m;
-	int cpu;
 
 	m = rcu_dereference_protected(priv->match, true);
-	if (m) {
-		rcu_barrier();
-
-		for_each_possible_cpu(cpu)
-			pipapo_free_scratch(m, cpu);
-		free_percpu(m->scratch);
-		pipapo_free_fields(m);
-		kfree(m);
-		priv->match = NULL;
-	}
 
 	if (priv->clone) {
-		m = priv->clone;
-
-		nft_set_pipapo_match_destroy(ctx, set, m);
-
-		for_each_possible_cpu(cpu)
-			pipapo_free_scratch(priv->clone, cpu);
-		free_percpu(priv->clone->scratch);
-
-		pipapo_free_fields(priv->clone);
-		kfree(priv->clone);
+		nft_set_pipapo_match_destroy(ctx, set, priv->clone);
+		pipapo_free_match(priv->clone);
 		priv->clone = NULL;
+	} else {
+		nft_set_pipapo_match_destroy(ctx, set, m);
 	}
+
+	pipapo_free_match(m);
 }
 
 /**
-- 
2.30.2

