Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80485280CC9
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Sep 2025 16:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758040460; cv=none; b=E5XcmTCNESjtigVZUT/KGfD1wI6rx0/fz2VVjS1nqf5W8YLeIZOX1tFClyXMi1DffLDQBb4R7Pj2BsE9m6O/0b2eqTD4wUVBb9iVpQSWI6FFcGCqAFRmMN/2NUuoK3iWWUfkPEIdcLBsSDx50M7MPbTHKOhGauaJ5Wq4KgJtLNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758040460; c=relaxed/simple;
	bh=xDIOoELoK1mzJ3FbWRlI0LE3Son8gQip6GAcUtcbKYs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZOY5wlmgwY6yajZkGECw/0rkUA96xflDc8bV7InWmS/HMmlpD4lB4q0x6mDZPsZwjFwEMdVsiSzdbAykZszoDvQF9/QobHQI7CVhHMh+QSmKK72WTLTgJP9sr+G+MaL30dryQANJ56yCw51M6DNOA4d+ujyJdEqEcQu0MWqzZJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E3962601B0; Tue, 16 Sep 2025 18:34:08 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nft_set_pipapo: use 0 genmask for packetpath lookups
Date: Tue, 16 Sep 2025 18:34:01 +0200
Message-ID: <20250916163403.14307-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix-for-a-fix: I replaced genmask_cur() with NFT_GENMASK_ANY, but this
doesn't work.

New entries are unreachable from the active copy, so it makes no
difference: current-gen elements are disabled and the new-generation
elements cannot be found.

Use the genmasks only from the control plane (inserts, deletions, ..).
Packet path has to skip the check, use of 0 is enough for this because
ext->genmask has a the relevant bit set when the element is INACTIVE
in that generation: using a 0 genmask thus makes nft_set_elem_active()
always return true.

Fix the comment and replace NFT_GENMASK_ANY with 0.

I did not catch this with the tests due to AVX2 being support and the
AVX2 version of this algorithm doesn't have the check in the nf tree
anymore.

But this genmask test is there on -next, where the test fails as well.
This also means that this needs another fixup in -next.

Fixes: c4eaca2e1052 ("netfilter: nft_set_pipapo: don't check genbit from packetpath lookups")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Dumb thinko on my end :-(
 Only noticed it because test case was failing on
 -next despite "fix" having been merged.

 net/netfilter/nft_set_pipapo.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 793790d79d13..ac9d989c0a51 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -510,8 +510,7 @@ static struct nft_pipapo_elem *pipapo_get(const struct nft_pipapo_match *m,
  *
  * This function is called from the data path.  It will search for
  * an element matching the given key in the current active copy.
- * Unlike other set types, this uses NFT_GENMASK_ANY instead of
- * nft_genmask_cur().
+ * Unlike other set types, this uses 0 instead of nft_genmask_cur().
  *
  * This is because new (future) elements are not reachable from
  * priv->match, they get added to priv->clone instead.
@@ -520,9 +519,8 @@ static struct nft_pipapo_elem *pipapo_get(const struct nft_pipapo_match *m,
  * elements becoming visible. Using nft_genmask_cur() thus creates
  * inconsistent state: matching old entries get skipped but thew
  * newly matching entries are unreachable.
- *
- * GENMASK will still find the 'now old' entries which ensures consistent
- * priv->match view.
+ * GENMASK_ANY doesn't work for the same reason: old-gen entries get
+ * skipped, new-gen entries are only reachable from priv->clone.
  *
  * nft_pipapo_commit swaps ->clone and ->match shortly after the
  * genbit flip.  As ->clone doesn't contain the old entries in the first
@@ -539,7 +537,7 @@ nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
 	const struct nft_pipapo_elem *e;
 
 	m = rcu_dereference(priv->match);
-	e = pipapo_get(m, (const u8 *)key, NFT_GENMASK_ANY, get_jiffies_64());
+	e = pipapo_get(m, (const u8 *)key, 0, get_jiffies_64());
 
 	return e ? &e->ext : NULL;
 }
-- 
2.49.1

