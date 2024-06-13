Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BBF6B646;
	Thu, 13 Jun 2024 01:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718240550; cv=none; b=mfqatwhYZYG0W77JQSf5n2oOWMIvm6KGwhkyw/E8kgWloseuWvu8lgVWCo5in9kwhq9jfnlyioKldklDvkFX9gE2ap8rzYl+HfkaiF//vkogK75SOqefFtYsj5fhDQrK1drGUJh4Fc5oxkebvrQZgDGNskmqE0jUQ0Zeul7EZ14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718240550; c=relaxed/simple;
	bh=afqdUmR1zLyaNOXhMRKzkiOqOrxo3ttlGhnNYDTSirw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ds090J3HVi1wyTtA4j2b322Zx21xN/xIthbIsgRSH2LC0z9F9vh57DpB73LcAvmIqeQOhcwVmfLd/Br2u+5bK8mYcUh84DF0J0JX01h80PBCTY95b9wW7XLDuAr7maGcfgyNzOL3cOGPGVq/YA/DNGcdwoVoM+ZvWoN97ofjKM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,4.19.x 17/40] netfilter: nft_set_rbtree: skip sync GC for new elements in this transaction
Date: Thu, 13 Jun 2024 03:01:46 +0200
Message-Id: <20240613010209.104423-18-pablo@netfilter.org>
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

commit 2ee52ae94baabf7ee09cf2a8d854b990dac5d0e4 upstream.

New elements in this transaction might expired before such transaction
ends. Skip sync GC for such elements otherwise commit path might walk
over an already released object. Once transaction is finished, async GC
will collect such expired element.

Fixes: f6c383b8c31a ("netfilter: nf_tables: adapt set backend to use GC transaction API")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_rbtree.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 92931fa9593b..8bda3f25360b 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -317,6 +317,7 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	struct nft_rbtree_elem *rbe, *rbe_le = NULL, *rbe_ge = NULL;
 	struct rb_node *node, *next, *parent, **p, *first = NULL;
 	struct nft_rbtree *priv = nft_set_priv(set);
+	u8 cur_genmask = nft_genmask_cur(net);
 	u8 genmask = nft_genmask_next(net);
 	int d, err;
 
@@ -362,8 +363,11 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 		if (!nft_set_elem_active(&rbe->ext, genmask))
 			continue;
 
-		/* perform garbage collection to avoid bogus overlap reports. */
-		if (nft_set_elem_expired(&rbe->ext)) {
+		/* perform garbage collection to avoid bogus overlap reports
+		 * but skip new elements in this transaction.
+		 */
+		if (nft_set_elem_expired(&rbe->ext) &&
+		    nft_set_elem_active(&rbe->ext, cur_genmask)) {
 			err = nft_rbtree_gc_elem(set, priv, rbe, genmask);
 			if (err < 0)
 				return err;
-- 
2.30.2

