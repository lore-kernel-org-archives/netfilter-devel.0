Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CA02D7BF;
	Fri,  6 Feb 2026 15:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770391885; cv=none; b=bByDC8RRAOd7H0OpHQmHpCfhaMC91psK0R1EK11q6KbOEgkGWU50UjLCpU+MOl6p5cpfT54X/zRfkN4OElEJaYbW+wlAMFnBgRcIoZk9RwrhkjsF3nNFqCvrC5wrrKwSKyjlWYACqNSpErhiPKmBUdetvMNfDqICXmcNFnvQJFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770391885; c=relaxed/simple;
	bh=R2oVvWbGTbWXNyOjXmPILbwPyZOtQNur6SerR9/yJpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RmAqhbNES72thWnDmy/YnHi3br2eEC9huVZbQzFJImY8bFTuDJgp24w5cDANz3S7Xr3zj5Khe+esPWMx9nv9S2z/1HwTYRRUihpfYZNkvyR524tYAaPPvB0LVNL+hJ1zhE8uCumMOlwXR8mFyNfifnEti/ItmnoI/+3XWriyjQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C844F6090B; Fri, 06 Feb 2026 16:31:23 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH v2 net-next 06/11] netfilter: nft_set_hash: fix get operation on big endian
Date: Fri,  6 Feb 2026 16:30:43 +0100
Message-ID: <20260206153048.17570-7-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260206153048.17570-1-fw@strlen.de>
References: <20260206153048.17570-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

tests/shell/testcases/packetpath/set_match_nomatch_hash_fast
fails on big endian with:

Error: Could not process rule: No such file or directory
reset element ip test s { 244.147.90.126 }
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Fatal: Cannot fetch element "244.147.90.126"

... because the wrong bucket is searched, jhash() and jhash1_word are
not interchangeable on big endian.

Fixes: 3b02b0adc242 ("netfilter: nft_set_hash: fix lookups with fixed size hash on big endian")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_hash.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index ba01ce75d6de..739b992bde59 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -619,15 +619,20 @@ static struct nft_elem_priv *
 nft_hash_get(const struct net *net, const struct nft_set *set,
 	     const struct nft_set_elem *elem, unsigned int flags)
 {
+	const u32 *key = (const u32 *)&elem->key.val;
 	struct nft_hash *priv = nft_set_priv(set);
 	u8 genmask = nft_genmask_cur(net);
 	struct nft_hash_elem *he;
 	u32 hash;
 
-	hash = jhash(elem->key.val.data, set->klen, priv->seed);
+	if (set->klen == 4)
+		hash = jhash_1word(*key, priv->seed);
+	else
+		hash = jhash(key, set->klen, priv->seed);
+
 	hash = reciprocal_scale(hash, priv->buckets);
 	hlist_for_each_entry_rcu(he, &priv->table[hash], node) {
-		if (!memcmp(nft_set_ext_key(&he->ext), elem->key.val.data, set->klen) &&
+		if (!memcmp(nft_set_ext_key(&he->ext), key, set->klen) &&
 		    nft_set_elem_active(&he->ext, genmask))
 			return &he->priv;
 	}
-- 
2.52.0

