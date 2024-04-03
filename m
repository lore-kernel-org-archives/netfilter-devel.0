Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EA36EB44
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Apr 2024 08:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712133752; cv=none; b=U1DvOOAOgy3FcuWhHVrKtZpdoIq9QbulanK2TTHEva0MacdFjGBXOMfKfqI+Qng5RpbcwK/AY4W0sFuyJUkfFJuA2RKo+fCUySp+ZkyQ4krUSaZi1gzC7NwBPkqRxJ8TqhMGZAEZxU1SzKqDAeMUTsx62qLWd86bKlXuvQuVjGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712133752; c=relaxed/simple;
	bh=VUwO9bzXm2JGtAjgFtJ/avSAYswyWnj90MWFDBbkkpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ky8JMybDliUlsaZ0C9J9K8Iz+IPYeuYgLfheFeT5ZnxObDTJAqVxFoZBjglPujE84+MEXDnLHHPmn38LaSyVyq3yu1pfjoyCrlT+Iu8VcRGleaY4C5W7Soh3/R8Pi00HpUc9FJYBgRi5JeDRLrltp0ZOxjvEsHjiKyouCyAeRUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rrwCT-0005xT-Hq; Wed, 03 Apr 2024 10:42:29 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/9] netfilter: nft_set_pipapo: prepare destroy function for on-demand clone
Date: Wed,  3 Apr 2024 10:41:03 +0200
Message-ID: <20240403084113.18823-4-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240403084113.18823-1-fw@strlen.de>
References: <20240403084113.18823-1-fw@strlen.de>
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
---
 net/netfilter/nft_set_pipapo.c | 27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 48d5600f8836..d2ac2d5560e4 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2323,33 +2323,18 @@ static void nft_pipapo_destroy(const struct nft_ctx *ctx,
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

