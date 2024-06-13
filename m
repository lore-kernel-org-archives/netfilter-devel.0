Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C3F684A5F;
	Thu, 13 Jun 2024 01:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718240561; cv=none; b=Lc8lUAD9x1M7vHnKeEghGvqg9TMHybP+LkqV8mncuLzIsRP/4ZiJteDX57vlNw3e0LZMI6tsUBKjX/M9zxtonggsziSsC2IcS32knT0UB6LVhrD8V34D6jZlJOVYZHI/A51oWurSCGYYMOtQVz1GQphe8VsD6ulWFenqJhf9GgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718240561; c=relaxed/simple;
	bh=Ym1kaE7RlAGm1V9ShuQIguicUGWbtMGm4DSTLi7AsM8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VmYS28wVh6ao1F7cl8yw/Nk/d9kYpsVgitre6LUlXySTw5ocascr9skd+/HkW/N1Z1tlBfUZVQkDoAS30fUtxj9F6RrxP4MD0f6pkqJ+I4vYqE5zLEsQFFBVg+HXus1+Oc3SXfk93V/BX5ESZGWA3gIan+1wImrufIVfk0EL0TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,4.19.x 34/40] netfilter: nft_set_rbtree: skip end interval element from gc
Date: Thu, 13 Jun 2024 03:02:03 +0200
Message-Id: <20240613010209.104423-35-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240613010209.104423-1-pablo@netfilter.org>
References: <20240613010209.104423-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 60c0c230c6f046da536d3df8b39a20b9a9fd6af0 upstream.

rbtree lazy gc on insert might collect an end interval element that has
been just added in this transactions, skip end interval elements that
are not yet active.

Fixes: f718863aca46 ("netfilter: nft_set_rbtree: fix overlap expiration walk")
Cc: stable@vger.kernel.org
Reported-by: lonial con <kongln9170@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_rbtree.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 69fb57f6a23f..caddacc1d446 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -240,8 +240,7 @@ static void nft_rbtree_gc_remove(struct net *net, struct nft_set *set,
 
 static int nft_rbtree_gc_elem(const struct nft_set *__set,
 			      struct nft_rbtree *priv,
-			      struct nft_rbtree_elem *rbe,
-			      u8 genmask)
+			      struct nft_rbtree_elem *rbe)
 {
 	struct nft_set *set = (struct nft_set *)__set;
 	struct rb_node *prev = rb_prev(&rbe->node);
@@ -260,7 +259,7 @@ static int nft_rbtree_gc_elem(const struct nft_set *__set,
 	while (prev) {
 		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
 		if (nft_rbtree_interval_end(rbe_prev) &&
-		    nft_set_elem_active(&rbe_prev->ext, genmask))
+		    nft_set_elem_active(&rbe_prev->ext, NFT_GENMASK_ANY))
 			break;
 
 		prev = rb_prev(prev);
@@ -368,7 +367,7 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 		 */
 		if (nft_set_elem_expired(&rbe->ext) &&
 		    nft_set_elem_active(&rbe->ext, cur_genmask)) {
-			err = nft_rbtree_gc_elem(set, priv, rbe, genmask);
+			err = nft_rbtree_gc_elem(set, priv, rbe);
 			if (err < 0)
 				return err;
 
-- 
2.30.2

