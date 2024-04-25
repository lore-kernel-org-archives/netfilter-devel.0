Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C1012BEB8
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Apr 2024 12:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714046952; cv=none; b=EBIs1kIst0YSu3fQHxrHYeL9jkLn6HFGY+TpWQPBoiI0GhLSZ+7DLLaNwXVHDYK8cy58rA5VCYUXcUSX7JhQAXEEvGHXkN6fjuO8ixCYS418dHuZ09nfJaIi5KKhyb5YC90spRUy5ymPkjZgpknu5catabYb8DngFdnqmKE//pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714046952; c=relaxed/simple;
	bh=zN1sxpgPU+WbTfwQ3Nrflxc+88dNpwqYS9Giigg2vaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8nuYNsopBOC6v+cA0GgamP+6dyelPIGOs2+jn3bVvdIURrmhB9uTOCdWMymfoAh8VMSyO13076GtvmH1d2UozR4FB0kpUzJcYubVAaHS4ib9agiRMTlJhVkMn9Nd4dtUAnT5qT9iJHXlW/Op+VKoyLEb7Na6yIfZ842XdDHJCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rzxuX-0007pU-Ny; Thu, 25 Apr 2024 14:09:09 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 3/8] netfilter: nft_set_pipapo: prepare destroy function for on-demand clone
Date: Thu, 25 Apr 2024 14:06:42 +0200
Message-ID: <20240425120651.16326-4-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240425120651.16326-1-fw@strlen.de>
References: <20240425120651.16326-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Once priv->clone can be NULL in case no insertions/removals occurred
in the last transaction we need to drop set elements from priv->match
if priv->clone is NULL.

While at it, condense this function by reusing the pipapo_free_match
helper instead of open-coded version.

The rcu_barrier() is removed, its not needed: old call_rcu instances
for pipapo_reclaim_match do not access struct nft_set.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
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
2.43.2

