Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B771A7047;
	Sun, 13 Oct 2024 20:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.134.164.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728850706; cv=none; b=oEWYSHl6GdLnzYOIkWhECXbWStPQukOIOs9O/IQpeV7FXM5aou0DWeSjW9jCWLCkZx0dQO+ywpMDHDGCtK9Rp8GBcqQHOJpLeQ+Bi1t8l/5dSE8Sr3WlXbz7WNYLhEviivVNuKSjBQu0uz/Fi8Os0mmWblwUqTrmlYmgr9gXI78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728850706; c=relaxed/simple;
	bh=nPI1KUY0y5ZVvOVYmqwiOP/3+JXV4M/eGrJnRpqjMF8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=D50SXLN+bimzWOgfgnBVnXgP1Q6yIy8S4eQYUWDNOifntNCqrRyn9s2559hvKqbHnLeKaJcNDPzKFtfjPXb0S/xB5gQE4l9AdhnXlUWvAOOJqjAacPjlhyjAY5E2FrgL2aatoPKOiYTVusCrJlY/d+hxOOnSr4YTIqxQffyzlOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr; spf=pass smtp.mailfrom=inria.fr; dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b=SYsDZHEK; arc=none smtp.client-ip=192.134.164.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inria.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b="SYsDZHEK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kFW/hho3zfoBYZLXkHEk+t9EhY0lm+H2Lt9PvPsPfwY=;
  b=SYsDZHEKMDyhdntWfCHsALfPcQV5BxGmPv/NgmkM4HM+brzN3PdbUPZw
   qdH1cro9zCjtVxjM8aqctbkcmGBjNLeBYUv7UiSsPKxX0z3nYe8zLmW9c
   jgmuoHiGUihei+PCyXp+hnGPwr0UTHdvKAEEx1X3+NGQyJpZK70V1dka/
   U=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="6.11,201,1725314400"; 
   d="scan'208";a="98968292"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2024 22:18:01 +0200
From: Julia Lawall <Julia.Lawall@inria.fr>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: kernel-janitors@vger.kernel.org,
	vbabka@suse.cz,
	paulmck@kernel.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 17/17] netfilter: xt_hashlimit: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
Date: Sun, 13 Oct 2024 22:17:04 +0200
Message-Id: <20241013201704.49576-18-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20241013201704.49576-1-Julia.Lawall@inria.fr>
References: <20241013201704.49576-1-Julia.Lawall@inria.fr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since SLOB was removed and since
commit 6c6c47b063b5 ("mm, slab: call kvfree_rcu_barrier() from kmem_cache_destroy()"),
it is not necessary to use call_rcu when the callback only performs
kmem_cache_free. Use kfree_rcu() directly.

The changes were made using Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 net/netfilter/xt_hashlimit.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 0859b8f76764..c2b9b954eb53 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -256,18 +256,11 @@ dsthash_alloc_init(struct xt_hashlimit_htable *ht,
 	return ent;
 }
 
-static void dsthash_free_rcu(struct rcu_head *head)
-{
-	struct dsthash_ent *ent = container_of(head, struct dsthash_ent, rcu);
-
-	kmem_cache_free(hashlimit_cachep, ent);
-}
-
 static inline void
 dsthash_free(struct xt_hashlimit_htable *ht, struct dsthash_ent *ent)
 {
 	hlist_del_rcu(&ent->node);
-	call_rcu(&ent->rcu, dsthash_free_rcu);
+	kfree_rcu(ent, rcu);
 	ht->count--;
 }
 static void htable_gc(struct work_struct *work);

