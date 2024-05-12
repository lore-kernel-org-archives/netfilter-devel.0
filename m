Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C78214F5FA;
	Sun, 12 May 2024 16:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715530494; cv=none; b=J6gu4b+9ir4j4nAgWY7r15tRzv5G2XhwjrOCIBWEK04A/v5Jw76jVeyt7gCEjhXO9wXLKjrnU9ZbNooLnhx8jWWHmTjTHmX2EM2pEnf0rEAu6ky3RBdfuoWzMBwBQxTLLGgIeikN0gz+65blNcHforAqXAylS9ljsUAwYVdIBFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715530494; c=relaxed/simple;
	bh=KHA30vNJCCVSqHwpf09gKV9+lwqi1/mPLSVhogpMxIQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LMwf9O/AnO19ZC3R9E0H8zzYnG4GTdt/UlcAVw5+UcjSMaDsPavs1ArjmHghNF8ZntiC71X3bBh7x9/RkWzSghrfhiRa1b4c5yfpywuG5enINA+dl3PGHXDY9bk+jLGuWaRuYVxR0bwMGnW83PRupslGbbICWnmRX8WvBezQzXY=
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
Subject: [PATCH net-next 13/17] netfilter: nft_set_pipapo: prepare pipapo_get helper for on-demand clone
Date: Sun, 12 May 2024 18:14:32 +0200
Message-Id: <20240512161436.168973-14-pablo@netfilter.org>
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

The helper uses priv->clone unconditionally which will fail once we do
the clone conditionally on first insert or removal.

'nft get element' from userspace needs to use priv->match since this
runs from rcu read side lock section.

Prepare for this by passing the match backend data as argument.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 7c11f568069c..6657aa34f4d7 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -504,6 +504,7 @@ bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
  * pipapo_get() - Get matching element reference given key data
  * @net:	Network namespace
  * @set:	nftables API set representation
+ * @m:		storage containing active/existing elements
  * @data:	Key data to be matched against existing elements
  * @genmask:	If set, check that element is active in given genmask
  * @tstamp:	timestamp to check for expired elements
@@ -517,17 +518,15 @@ bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
  */
 static struct nft_pipapo_elem *pipapo_get(const struct net *net,
 					  const struct nft_set *set,
+					  const struct nft_pipapo_match *m,
 					  const u8 *data, u8 genmask,
 					  u64 tstamp, gfp_t gfp)
 {
 	struct nft_pipapo_elem *ret = ERR_PTR(-ENOENT);
-	struct nft_pipapo *priv = nft_set_priv(set);
 	unsigned long *res_map, *fill_map = NULL;
-	const struct nft_pipapo_match *m;
 	const struct nft_pipapo_field *f;
 	int i;
 
-	m = priv->clone;
 	if (m->bsize_max == 0)
 		return ret;
 
@@ -612,9 +611,11 @@ static struct nft_elem_priv *
 nft_pipapo_get(const struct net *net, const struct nft_set *set,
 	       const struct nft_set_elem *elem, unsigned int flags)
 {
+	struct nft_pipapo *priv = nft_set_priv(set);
+	struct nft_pipapo_match *m = rcu_dereference(priv->match);
 	struct nft_pipapo_elem *e;
 
-	e = pipapo_get(net, set, (const u8 *)elem->key.val.data,
+	e = pipapo_get(net, set, m, (const u8 *)elem->key.val.data,
 		       nft_genmask_cur(net), get_jiffies_64(),
 		       GFP_ATOMIC);
 	if (IS_ERR(e))
@@ -1288,7 +1289,7 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 	else
 		end = start;
 
-	dup = pipapo_get(net, set, start, genmask, tstamp, GFP_KERNEL);
+	dup = pipapo_get(net, set, m, start, genmask, tstamp, GFP_KERNEL);
 	if (!IS_ERR(dup)) {
 		/* Check if we already have the same exact entry */
 		const struct nft_data *dup_key, *dup_end;
@@ -1310,7 +1311,7 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 
 	if (PTR_ERR(dup) == -ENOENT) {
 		/* Look for partially overlapping entries */
-		dup = pipapo_get(net, set, end, nft_genmask_next(net), tstamp,
+		dup = pipapo_get(net, set, m, end, nft_genmask_next(net), tstamp,
 				 GFP_KERNEL);
 	}
 
@@ -1862,9 +1863,11 @@ static struct nft_elem_priv *
 nft_pipapo_deactivate(const struct net *net, const struct nft_set *set,
 		      const struct nft_set_elem *elem)
 {
+	const struct nft_pipapo *priv = nft_set_priv(set);
+	struct nft_pipapo_match *m = priv->clone;
 	struct nft_pipapo_elem *e;
 
-	e = pipapo_get(net, set, (const u8 *)elem->key.val.data,
+	e = pipapo_get(net, set, m, (const u8 *)elem->key.val.data,
 		       nft_genmask_next(net), nft_net_tstamp(net), GFP_KERNEL);
 	if (IS_ERR(e))
 		return NULL;
-- 
2.30.2

