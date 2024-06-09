Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1BA5337C;
	Sun,  9 Jun 2024 08:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.134.164.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717921695; cv=none; b=bBFQM2MB6rJwgtyJvdsaG5EsmenFo2HKL8ZrqMmVd6v68zHQP+dHeakmw281fOmv5CmJuNn9gz5QM6w5FDNL82k7NBRKMOZSxD8H5wyDn+068Y/LBElPIiDtEUlKFrySyfD6b8wsmZndOX2nucMmi8AQYsIP2kLZJKP/yaXYKDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717921695; c=relaxed/simple;
	bh=XjSGzBEEN4R1uM6+FzoVLzsuvTNxmayPngOiT1u3sG0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=irqZFMnBerrKO9/dHkCbHAgcjTyzMDE6dZIul0kBZpPCtsoXXS//pDPBFbLde8tm6Q7mWXuQczy6gAS3dGuuR+Q5kv9WLx2RHyM6hQbV8S2O9tMPgLK2KIXGA2sGfgAoy4WSLdm8GF+Fxd0LPowO9Dc7IZmvK88Uy7yntxsGK+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr; spf=pass smtp.mailfrom=inria.fr; dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b=PQ8uixq9; arc=none smtp.client-ip=192.134.164.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inria.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b="PQ8uixq9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UDrliNsi6qf9iZ0cJTSfrv8FntRHZmJcOSPF/U9CCyU=;
  b=PQ8uixq9gJb8XJ5kYQyD9s/ymp/dqHay+TNM4exQnNxtZvPryBNvScc0
   yKx1TUYcF+ilJUMjUqmuURKc0OVGwc7MvninM1ky5jsSke9R2PMmzcoBq
   5PKM4rmRoXEoS5gWDJL6KrtSpCRSd6OHyLzDTxvaFTRnqD67aFFemBGjC
   w=;
Authentication-Results: mail2-relais-roc.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="6.08,225,1712613600"; 
   d="scan'208";a="169696909"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2024 10:27:49 +0200
From: Julia Lawall <Julia.Lawall@inria.fr>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: kernel-janitors@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 14/14] netfilter: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
Date: Sun,  9 Jun 2024 10:27:26 +0200
Message-Id: <20240609082726.32742-15-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240609082726.32742-1-Julia.Lawall@inria.fr>
References: <20240609082726.32742-1-Julia.Lawall@inria.fr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since SLOB was removed, it is not necessary to use call_rcu
when the callback only performs kmem_cache_free. Use
kfree_rcu() directly.

The changes were done using the following Coccinelle semantic patch.
This semantic patch is designed to ignore cases where the callback
function is used in another way.

// <smpl>
@r@
expression e;
local idexpression e2;
identifier cb,f;
position p;
@@

(
call_rcu(...,e2)
|
call_rcu(&e->f,cb@p)
)

@r1@
type T;
identifier x,r.cb;
@@

 cb(...) {
(
   kmem_cache_free(...);
|
   T x = ...;
   kmem_cache_free(...,x);
|
   T x;
   x = ...;
   kmem_cache_free(...,x);
)
 }

@s depends on r1@
position p != r.p;
identifier r.cb;
@@

 cb@p

@script:ocaml@
cb << r.cb;
p << s.p;
@@

Printf.eprintf "Other use of %s at %s:%d\n"
   cb (List.hd p).file (List.hd p).line

@depends on r1 && !s@
expression e;
identifier r.cb,f;
position r.p;
@@

- call_rcu(&e->f,cb@p)
+ kfree_rcu(e,f)

@r1a depends on !s@
type T;
identifier x,r.cb;
@@

- cb(...) {
(
-  kmem_cache_free(...);
|
-  T x = ...;
-  kmem_cache_free(...,x);
|
-  T x;
-  x = ...;
-  kmem_cache_free(...,x);
)
- }
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

---
 net/netfilter/nf_conncount.c        |   10 +---------
 net/netfilter/nf_conntrack_expect.c |   10 +---------
 net/netfilter/xt_hashlimit.c        |    9 +--------
 3 files changed, 3 insertions(+), 26 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 8715617b02fe..587bfcb79723 100644
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
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 21fa550966f0..9dcaef6f3663 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -367,18 +367,10 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_init);
 
-static void nf_ct_expect_free_rcu(struct rcu_head *head)
-{
-	struct nf_conntrack_expect *exp;
-
-	exp = container_of(head, struct nf_conntrack_expect, rcu);
-	kmem_cache_free(nf_ct_expect_cachep, exp);
-}
-
 void nf_ct_expect_put(struct nf_conntrack_expect *exp)
 {
 	if (refcount_dec_and_test(&exp->use))
-		call_rcu(&exp->rcu, nf_ct_expect_free_rcu);
+		kfree_rcu(exp, rcu);
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_put);
 
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

