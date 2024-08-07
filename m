Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EB0661674
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Aug 2024 14:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723040653; cv=none; b=FQueNXo7OAa+JmuYdB9CRCHZlClEJ3DM3Vueq9/xzsWgnM+S+qTtIk5CW+rywFojImUqlJe6tZHpusfkyuqOsr0vKlSjET4/Mbw9Jb+NU1aJtynPhKHDu6bgO4lqRIwtxxA3LQBWrf09oWX9YrbqAi9aBjtw9Urn3P6uwEJABac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723040653; c=relaxed/simple;
	bh=SscAlHHbC8BjfR/NPkXC4K4jNPCVyUfin8UvOBD6R1k=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Nd6Uf0OMX/iIoIce9+IesgQS9C7ida301/i5+qBa8GKLMn2H7gurEDcR1C5wcUkJ+/iXxH/fVYjmHa9zULx5BrH/wtQjlcSns4Qj/RKZz7S8rIkql6WnDL/3jmDHl90vSgT1DvQYm1AIdNiZRy8DHx92LAoRuv3k4BC7gNHjT3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 4/8] netfilter: nft_dynset: annotate data-races around set timeout
Date: Wed,  7 Aug 2024 16:23:53 +0200
Message-Id: <20240807142357.90493-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240807142357.90493-1-pablo@netfilter.org>
References: <20240807142357.90493-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

set timeout can be read locklessly while being updated from control
plane, add annotation.

Fixes: 123b99619cca ("netfilter: nf_tables: honor set timeout and garbage collection updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_dynset.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index b4ada3ab2167..489a9b34f1ec 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -56,7 +56,7 @@ static struct nft_elem_priv *nft_dynset_new(struct nft_set *set,
 	if (!atomic_add_unless(&set->nelems, 1, set->size))
 		return NULL;
 
-	timeout = priv->timeout ? : set->timeout;
+	timeout = priv->timeout ? : READ_ONCE(set->timeout);
 	elem_priv = nft_set_elem_init(set, &priv->tmpl,
 				      &regs->data[priv->sreg_key], NULL,
 				      &regs->data[priv->sreg_data],
@@ -95,7 +95,7 @@ void nft_dynset_eval(const struct nft_expr *expr,
 			     expr, regs, &ext)) {
 		if (priv->op == NFT_DYNSET_OP_UPDATE &&
 		    nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION)) {
-			timeout = priv->timeout ? : set->timeout;
+			timeout = priv->timeout ? : READ_ONCE(set->timeout);
 			*nft_set_ext_expiration(ext) = get_jiffies_64() + timeout;
 		}
 
@@ -313,7 +313,7 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 		nft_dynset_ext_add_expr(priv);
 
 	if (set->flags & NFT_SET_TIMEOUT) {
-		if (timeout || set->timeout) {
+		if (timeout || READ_ONCE(set->timeout)) {
 			nft_set_ext_add(&priv->tmpl, NFT_SET_EXT_TIMEOUT);
 			nft_set_ext_add(&priv->tmpl, NFT_SET_EXT_EXPIRATION);
 		}
-- 
2.30.2

