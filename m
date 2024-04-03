Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502B16CDDB
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Apr 2024 08:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712133756; cv=none; b=CHuH3UshccxBfNFL917Nm6jwEpaCi63r5XEdZlJ1UU0s2lZLpiT7dddPYA60exJg2yjFHk+QiebjWMKNkXPlhkxkpdv/lQmyU555fcDdfdHMyqETBoGYr9ZQ1Tad0cl0cziiP+p8Hi9/pLjy+0iYNC2CbtyhG+4N7zNxW8YclV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712133756; c=relaxed/simple;
	bh=V7YmFkoPqtDzqXba5zz9g6jJQrUMM/Y3xt6qs3IMlls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YscUEjicsCGSrLR8wGxllUru150VoBXL09yZvAxFjdDSXtIg/atCFXQSOMMdS9PFo1NsDhSJs2JAc34o9cTVPDnXvduhRJ93Wx9I8o1xsR86SejvxIaMdGXqlL5Xv0aSaKTaAaoprz5Yd9mcWaWs+pO/JsEIVubUmzHLedUjenA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rrwCX-0005xs-RL; Wed, 03 Apr 2024 10:42:33 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 4/9] netfilter: nft_set_pipapo: prepare walk function for on-demand clone
Date: Wed,  3 Apr 2024 10:41:04 +0200
Message-ID: <20240403084113.18823-5-fw@strlen.de>
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

Right now, without pending updates, priv->clone and priv->match
will point to different memory locations, but they have identical
content.

Future patch will make priv->clone == NULL if there are no pending
changes.

We cannot just fallback to the live data in this case because there
are different types of walks:

- set dump: this can fallback to the live copy.
- flush walk: all set elements should be deactivated.
  If no single element was removed before, then we must first
  make a copy of the live data.
- deactivate/activate walks during abort or commit.
  This would always have a non-null clone.

The existing test is unreliable, if genmask is not equal to current
one, we can't infer that the transaction mutex is held, we could
be in a (lockless) dump.

Its only safe at this time because both commit and abort paths
will re-clone the live copy, so ->clone is always non-null -- something
that is about to change.

Next patch will add explicit iter type to tell when flushing
is requested (i.e., when live data must be copied first).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo.c | 54 +++++++++++++++++++++++-----------
 1 file changed, 37 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index d2ac2d5560e4..57b1508d3502 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2102,33 +2102,23 @@ static void nft_pipapo_remove(const struct net *net, const struct nft_set *set,
 }
 
 /**
- * nft_pipapo_walk() - Walk over elements
+ * __nft_pipapo_walk() - Walk over elements in m
  * @ctx:	nftables API context
  * @set:	nftables API set representation
+ * @m:		matching data pointing to key mapping array
  * @iter:	Iterator
  *
  * As elements are referenced in the mapping array for the last field, directly
  * scan that array: there's no need to follow rule mappings from the first
  * field.
  */
-static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
-			    struct nft_set_iter *iter)
+static void __nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
+			      const struct nft_pipapo_match *m,
+			      struct nft_set_iter *iter)
 {
-	struct nft_pipapo *priv = nft_set_priv(set);
-	struct net *net = read_pnet(&set->net);
-	const struct nft_pipapo_match *m;
 	const struct nft_pipapo_field *f;
 	unsigned int i, r;
 
-	rcu_read_lock();
-	if (iter->genmask == nft_genmask_cur(net))
-		m = rcu_dereference(priv->match);
-	else
-		m = priv->clone;
-
-	if (unlikely(!m))
-		goto out;
-
 	for (i = 0, f = m->f; i < m->field_count - 1; i++, f++)
 		;
 
@@ -2148,13 +2138,43 @@ static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
 
 		iter->err = iter->fn(ctx, set, iter, &e->priv);
 		if (iter->err < 0)
-			goto out;
+			return;
 
 cont:
 		iter->count++;
 	}
+}
+
+/**
+ * nft_pipapo_walk() - Walk over elements
+ * @ctx:	nftables API context
+ * @set:	nftables API set representation
+ * @iter:	Iterator
+ *
+ * Test if destructive action is needed or not, clone active backend if needed
+ * and call the real function to work on the data.
+ */
+static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
+			    struct nft_set_iter *iter)
+{
+	struct nft_pipapo *priv = nft_set_priv(set);
+	struct net *net = read_pnet(&set->net);
+	const struct nft_pipapo_match *m;
+
+	rcu_read_lock();
+	if (iter->genmask == nft_genmask_cur(net)) {
+		m = rcu_dereference(priv->match);
+	} else {
+		m = priv->clone;
+		if (!m) /* no pending updates */
+			m = rcu_dereference(priv->match);
+	}
+
+	if (m)
+		__nft_pipapo_walk(ctx, set, m, iter);
+	else
+		WARN_ON_ONCE(1);
 
-out:
 	rcu_read_unlock();
 }
 
-- 
2.43.2

