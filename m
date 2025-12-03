Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF8E2D77E2
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Dec 2025 09:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764752772; cv=none; b=dADECMvoK1HY1a8Eys53NiGE/2w2tNGYl9TVi4pNdx0Dag5tZPVnBzmbvuAPUgKCqlhrZzXHhZq95uHOT0LnJZNjkcMHxKTdYFG7JfDfdymoEb24Gk20zLurt3+WNiLI4br5KageIhkk95ti1ymPYpYu510neexVb3icbHh6gKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764752772; c=relaxed/simple;
	bh=2CiPIZ4X+0e4SoqmRUl2N7jfjPhCjwJdWYHpArEfWWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aKT0KxsjU2QNguIKMf7drKAG8x2ic2y0alL5LMEgG/e73elUwwqC32g/5Mpb6yvi/yDbFAfzl1c3sy8XV30di4bFmbGLerT7uJb8FWNyiK05O6qbJsYmKpIHah3b2Q674uekEoKdHQDv5HwZta7Bv8IrjXKPKqxUQOwV+5XubgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C071460371; Wed, 03 Dec 2025 10:06:07 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf v2 2/3] netfilter: nft_set_rbtree: factor out insert helper
Date: Wed,  3 Dec 2025 10:03:14 +0100
Message-ID: <20251203090320.26905-3-fw@strlen.de>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251203090320.26905-1-fw@strlen.de>
References: <20251203090320.26905-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Before __nft_rbtree_insert() adds a new node it performs overlap checks
and refuses to insert such conflicting elements.

Upcoming change needs to duplicate the live tree once before the first
modifications can be done on the newly cloned tree.

Such copy doesn't need any of the duplicate checks as all inserted elements
have been validated earlier.

As the cloned tree isn't exüosed to other cpus we won't need to hold any
extra lock either.

So split the final insertion step into its own function so it can be reused
in followup patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 No changes.

 net/netfilter/nft_set_rbtree.c | 57 ++++++++++++++++++++++------------
 1 file changed, 38 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index dbf08f6a9ba5..d051d8075070 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -28,6 +28,11 @@ struct nft_rbtree_elem {
 	struct nft_set_ext	ext;
 };
 
+static inline u8 nft_rbtree_genbit_copy(const struct nft_rbtree *priv)
+{
+	return 0;
+}
+
 static bool nft_rbtree_interval_end(const struct nft_rbtree_elem *rbe)
 {
 	return nft_set_ext_exists(&rbe->ext, NFT_SET_EXT_FLAGS) &&
@@ -309,6 +314,38 @@ static bool nft_rbtree_update_first(const struct nft_set *set,
 	return false;
 }
 
+/* insert into tree without any timeout or overlap checks. */
+static void __nft_rbtree_insert_do(const struct nft_set *set,
+				   struct nft_rbtree_elem *new)
+{
+	struct nft_rbtree *priv = nft_set_priv(set);
+	u8 genbit = nft_rbtree_genbit_copy(priv);
+	struct rb_node *parent, **p;
+	int d;
+
+	parent = NULL;
+	p = &priv->root[genbit].rb_node;
+	while (*p) {
+		struct nft_rbtree_elem *rbe;
+
+		parent = *p;
+		rbe = rb_entry(parent, struct nft_rbtree_elem, node[genbit]);
+		d = nft_rbtree_cmp(set, rbe, new);
+
+		if (d < 0)
+			p = &parent->rb_left;
+		else if (d > 0)
+			p = &parent->rb_right;
+		else if (nft_rbtree_interval_end(rbe))
+			p = &parent->rb_left;
+		else
+			p = &parent->rb_right;
+	}
+
+	rb_link_node_rcu(&new->node[genbit], parent, p);
+	rb_insert_color(&new->node[genbit], &priv->root[genbit]);
+}
+
 static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			       struct nft_rbtree_elem *new,
 			       struct nft_elem_priv **elem_priv)
@@ -467,25 +504,7 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 		return -ENOTEMPTY;
 
 	/* Accepted element: pick insertion point depending on key value */
-	parent = NULL;
-	p = &priv->root[genbit].rb_node;
-	while (*p != NULL) {
-		parent = *p;
-		rbe = rb_entry(parent, struct nft_rbtree_elem, node[genbit]);
-		d = nft_rbtree_cmp(set, rbe, new);
-
-		if (d < 0)
-			p = &parent->rb_left;
-		else if (d > 0)
-			p = &parent->rb_right;
-		else if (nft_rbtree_interval_end(rbe))
-			p = &parent->rb_left;
-		else
-			p = &parent->rb_right;
-	}
-
-	rb_link_node_rcu(&new->node[genbit], parent, p);
-	rb_insert_color(&new->node[genbit], &priv->root[genbit]);
+	__nft_rbtree_insert_do(set, new);
 	return 0;
 }
 
-- 
2.51.2

