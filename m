Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4D037C92C;
	Tue, 30 Jun 2026 04:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782795204; cv=none; b=CESWJPtR/mkIGd8RqnaN25RHWDpGO2Xr14MhxCGGClk1UwyZptZcPHhaJ+FB9wwjAyDZA01MfhuDezDtTxljWbmRT3eh/W1/at+eZIuVvUicwQx9QKrajj0eLKbKsRA6l/RoMSGntB3cNXp2JxdkcWxTwJbq6ZXITRmYKF1brl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782795204; c=relaxed/simple;
	bh=Jr9JKwwZBpZgJh5l/my3mr27ZpxN1+XGGs5uKzGBY7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwX6RDBhPuuBXVjlaNbGm080QM5CKt0I9DQr0TCRhkGyEOoiF2JDRp15B8HyZFUxEDWcwSKiamQJm963ry6dwz3/OY8jf9DX6wjlkOypPhd3IWp1MYnhXWDrGijLrzypMdZBwNAdOMdIibItFZzX3HPjOqNnL/STz3CfQseDvPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 93DBC6032C; Tue, 30 Jun 2026 06:53:21 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 2/9] netfilter: nft_set_pipapo: don't leak bad clone into future transaction
Date: Tue, 30 Jun 2026 06:52:36 +0200
Message-ID: <20260630045243.2657-3-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260630045243.2657-1-fw@strlen.de>
References: <20260630045243.2657-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On memory allocation failure the cloned nft_pipapo_match can enter a bad
state:
 - some fields can have their lookup tables resized while others did
   not
 - bits might have been toggled
 - scratch map can be undersized which also means m->bsize_max can be
   lower than what is required

This means that the next insertion in the same batch can trigger
out-of-bounds writes.

Furthermore, a failure in the first can result in the bad clone to
leak into the next transaction because the abort callback is never
executed in this case (the upper layer saw an error and no attempt to
allocate a transactional request was made).

Record a state for the nft_pipapo_match structure:
- NEW (pristine clone)
- MOD (modified clone with good state)
- ERR (potentially bogus content)

Then make it so that deletes and insertions fail when the clone
entered ERR state.

In case the very first insert attempt results in an error, free the
clone right away.

Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Cc: stable@vger.kernel.org
Reported-and-tested-by: Seesee <cjc000013@gmail.com>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo.c | 34 +++++++++++++++++++++++++++++-----
 net/netfilter/nft_set_pipapo.h |  8 ++++++++
 2 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 706c78853f24..978bb0c01106 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -342,6 +342,8 @@
 #include "nft_set_pipapo_avx2.h"
 #include "nft_set_pipapo.h"
 
+static void nft_pipapo_abort(const struct nft_set *set);
+
 /**
  * pipapo_refill() - For each set bit, set bits from selected mapping table item
  * @map:	Bitmap to be scanned for set bits
@@ -1296,7 +1298,7 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 	const u8 *start_p, *end_p;
 	int i, bsize_max, err = 0;
 
-	if (!m)
+	if (!m || m->state == NFT_PIPAPO_CLONE_ERR)
 		return -ENOMEM;
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY_END))
@@ -1367,8 +1369,10 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 		else
 			ret = pipapo_expand(f, start, end, f->groups * f->bb);
 
-		if (ret < 0)
-			return ret;
+		if (ret < 0) {
+			err = ret;
+			goto abort;
+		}
 
 		if (f->bsize > bsize_max)
 			bsize_max = f->bsize;
@@ -1384,7 +1388,7 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 
 		err = pipapo_realloc_scratch(m, bsize_max);
 		if (err)
-			return err;
+			goto abort;
 
 		m->bsize_max = bsize_max;
 	} else {
@@ -1396,7 +1400,26 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 
 	pipapo_map(m, rulemap, e);
 
+	m->state = NFT_PIPAPO_CLONE_MOD;
 	return 0;
+abort:
+	DEBUG_NET_WARN_ON_ONCE(m->state == NFT_PIPAPO_CLONE_ERR);
+
+	/* Two rollback cases:
+	 * 1) no previous changes.  nft_pipapo_abort is not
+	 * guaranteed to be invoked (there might be no further
+	 * add/delete requests coming after this).
+	 *
+	 * 2) we had previous changes: there are transaction
+	 * records pointing to this set.  Leave the rollback to
+	 * the transaction handling.
+	 */
+	if (m->state == NFT_PIPAPO_CLONE_NEW)
+		nft_pipapo_abort(set); /* releases m */
+	else
+		m->state = NFT_PIPAPO_CLONE_ERR;
+
+	return err;
 }
 
 /**
@@ -1473,6 +1496,7 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 		dst++;
 	}
 
+	new->state = NFT_PIPAPO_CLONE_NEW;
 	return new;
 
 out_mt:
@@ -1896,7 +1920,7 @@ nft_pipapo_deactivate(const struct net *net, const struct nft_set *set,
 	/* removal must occur on priv->clone, if we are low on memory
 	 * we have no choice and must fail the removal request.
 	 */
-	if (!m)
+	if (!m || m->state == NFT_PIPAPO_CLONE_ERR)
 		return NULL;
 
 	e = pipapo_get(m, (const u8 *)elem->key.val.data,
diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
index b82abb03576e..a19e980d06ef 100644
--- a/net/netfilter/nft_set_pipapo.h
+++ b/net/netfilter/nft_set_pipapo.h
@@ -131,9 +131,16 @@ struct nft_pipapo_scratch {
 	unsigned long __map[];
 };
 
+enum nft_pipapo_clone_state {
+	NFT_PIPAPO_CLONE_NEW,
+	NFT_PIPAPO_CLONE_MOD,
+	NFT_PIPAPO_CLONE_ERR,
+};
+
 /**
  * struct nft_pipapo_match - Data used for lookup and matching
  * @field_count:	Amount of fields in set
+ * @state:		add/delete state; used from control plane
  * @bsize_max:		Maximum lookup table bucket size of all fields, in longs
  * @scratch:		Preallocated per-CPU maps for partial matching results
  * @rcu:		Matching data is swapped on commits
@@ -141,6 +148,7 @@ struct nft_pipapo_scratch {
  */
 struct nft_pipapo_match {
 	u8 field_count;
+	enum nft_pipapo_clone_state state:8;
 	unsigned int bsize_max;
 	struct nft_pipapo_scratch * __percpu *scratch;
 	struct rcu_head rcu;
-- 
2.53.0

