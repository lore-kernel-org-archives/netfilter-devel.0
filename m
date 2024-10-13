Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233941A0B1A;
	Sun, 13 Oct 2024 20:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.134.164.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728850704; cv=none; b=SCxMmuVs22ed4ZPYujwtETbDqTfIEfl0qwXZ3liHGz/iSiH+tosWdMLRKWDV4mzNVmBdgUMAZRiD7L7EUGpSU/eN64dYDjVl1HvTScVwGr/BF7/kLkdl3LAR4xjsxIBAKDAHQUffbOgWdA0PFlrg/csWOzEWHzcgEPHzBuZ3oxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728850704; c=relaxed/simple;
	bh=DQyIN9G/mibNG2Z+E7ru3Rp35+OYcqnr/9mPvGNa+vU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PitqqbroUyzmOE7NQdCGjMPmJrscKFtw8Ks+zPYwNo5jyPspKYTuRf6Vb9t8Lb+uv2Hpr5ex5eZh/IKZ+3brYfBL++lx6Rxx3ScevTyAKUpHlNRzciDw2KF1Xn1hvMKqndC4xdsI+MPKGJSmiz+R5Gg2VgXQYdZpAD+qOE0sJV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr; spf=pass smtp.mailfrom=inria.fr; dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b=IrHkH9nj; arc=none smtp.client-ip=192.134.164.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inria.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b="IrHkH9nj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OmvFRdBgQ9mucvU+eufo2e2dqSURiDoArUZisEbnCAw=;
  b=IrHkH9njN1+OVcwemgQKBL/Rp2eru/6QTGtd2zLxuwkXohfNMRkeluds
   HlaZWXABjJbWajzXwtxFaqzLHpdoAmsDHgGTx8y9D0Hm4zlluhKQBGmXJ
   +SZQNkyyc89MjbQsfqC6/tVJdW+H+WDVwGpwzsdgngWJ749QfuabDnRz/
   Q=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="6.11,201,1725314400"; 
   d="scan'208";a="98968290"
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
Subject: [PATCH 15/17] netfilter: nf_conncount: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
Date: Sun, 13 Oct 2024 22:17:02 +0200
Message-Id: <20241013201704.49576-16-Julia.Lawall@inria.fr>
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
 net/netfilter/nf_conncount.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 4890af4dc263..6a7a6c2d6ebc 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -275,14 +275,6 @@ bool nf_conncount_gc_list(struct net *net,
 }
 EXPORT_SYMBOL_GPL(nf_conncount_gc_list);
 
-static void __tree_nodes_free(struct rcu_head *h)
-{
-	struct nf_conncount_rb *rbconn;
-
-	rbconn = container_of(h, struct nf_conncount_rb, rcu_head);
-	kmem_cache_free(conncount_rb_cachep, rbconn);
-}
-
 /* caller must hold tree nf_conncount_locks[] lock */
 static void tree_nodes_free(struct rb_root *root,
 			    struct nf_conncount_rb *gc_nodes[],
@@ -295,7 +287,7 @@ static void tree_nodes_free(struct rb_root *root,
 		spin_lock(&rbconn->list.list_lock);
 		if (!rbconn->list.count) {
 			rb_erase(&rbconn->node, root);
-			call_rcu(&rbconn->rcu_head, __tree_nodes_free);
+			kfree_rcu(rbconn, rcu_head);
 		}
 		spin_unlock(&rbconn->list.list_lock);
 	}

