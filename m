Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 905FE4F215;
	Sun, 12 May 2024 16:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715530494; cv=none; b=AKIdfb9NborO74QT9nRbsRtrJqguzlXc82rvM5AP0UR161CdnfvMRKCksw0uzGRx+8TI8lz+zY3zEs1bOcEBNRYdgrr2BaH0apKSPhu5qiyYTHeKnQRgy0uVLEtfEgHpWW6B7jV08mkCcI/NpJQtNn7wrItbug81sHakqeWX3Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715530494; c=relaxed/simple;
	bh=AMDps6fOAYIbIgbUTyhL7ViVny0EBfDcUGIvrv4BKkE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fpqtTYsOqIWKx5O1wh1nAvCFQpYQu+mVBvopaQgKG9LIb9dG+X1v/qjwNV3HHLj5HhGVsNGXvHYGcCCXZOD3/56KQSOANcqPXadRGMSDWhegXC/WGAUdPV0osin767/PyfBN4L+O8wptzhISRsHCkVB4VwN/C9ck1v9FTPJ4gZU=
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
Subject: [PATCH net-next 12/17] netfilter: nft_set_pipapo: merge deactivate helper into caller
Date: Sun, 12 May 2024 18:14:31 +0200
Message-Id: <20240512161436.168973-13-pablo@netfilter.org>
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

Its the only remaining call site so there is no need for this to
be separated anymore.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo.c | 39 ++++++++--------------------------
 1 file changed, 9 insertions(+), 30 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 543d6cf01de6..7c11f568069c 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1851,52 +1851,31 @@ static void nft_pipapo_activate(const struct net *net,
 }
 
 /**
- * pipapo_deactivate() - Check that element is in set, mark as inactive
+ * nft_pipapo_deactivate() - Search for element and make it inactive
  * @net:	Network namespace
  * @set:	nftables API set representation
- * @data:	Input key data
- * @ext:	nftables API extension pointer, used to check for end element
- *
- * This is a convenience function that can be called from both
- * nft_pipapo_deactivate() and nft_pipapo_flush(), as they are in fact the same
- * operation.
+ * @elem:	nftables API element representation containing key data
  *
  * Return: deactivated element if found, NULL otherwise.
  */
-static void *pipapo_deactivate(const struct net *net, const struct nft_set *set,
-			       const u8 *data, const struct nft_set_ext *ext)
+static struct nft_elem_priv *
+nft_pipapo_deactivate(const struct net *net, const struct nft_set *set,
+		      const struct nft_set_elem *elem)
 {
 	struct nft_pipapo_elem *e;
 
-	e = pipapo_get(net, set, data, nft_genmask_next(net),
-		       nft_net_tstamp(net), GFP_KERNEL);
+	e = pipapo_get(net, set, (const u8 *)elem->key.val.data,
+		       nft_genmask_next(net), nft_net_tstamp(net), GFP_KERNEL);
 	if (IS_ERR(e))
 		return NULL;
 
 	nft_set_elem_change_active(net, set, &e->ext);
 
-	return e;
-}
-
-/**
- * nft_pipapo_deactivate() - Call pipapo_deactivate() to make element inactive
- * @net:	Network namespace
- * @set:	nftables API set representation
- * @elem:	nftables API element representation containing key data
- *
- * Return: deactivated element if found, NULL otherwise.
- */
-static struct nft_elem_priv *
-nft_pipapo_deactivate(const struct net *net, const struct nft_set *set,
-		      const struct nft_set_elem *elem)
-{
-	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
-
-	return pipapo_deactivate(net, set, (const u8 *)elem->key.val.data, ext);
+	return &e->priv;
 }
 
 /**
- * nft_pipapo_flush() - Call pipapo_deactivate() to make element inactive
+ * nft_pipapo_flush() - make element inactive
  * @net:	Network namespace
  * @set:	nftables API set representation
  * @elem_priv:	nftables API element representation containing key data
-- 
2.30.2

