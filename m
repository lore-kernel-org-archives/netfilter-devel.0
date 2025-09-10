Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F2130FF06
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Sep 2025 08:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757491415; cv=none; b=ckJGIPJLsZq3NMnJk3ZJEwgVtbcooxioszqwHL4lbanC9HQkXE9tWznC1fFy6OHYLoyKWvadGr/FW3VSLNNBaKMTJTiNmJd2mhIxbNewvWrAzlMiH8hKMIGHDQ1MWR6pVLjB8TBEG0WG44pX/M+S+rJl5pOEBc4/oO9J993roY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757491415; c=relaxed/simple;
	bh=RLVnQUiq68/pymlC5PdzVOBwittqtpJWl9fn1ZF5iUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QpJj3qtai7QTqRj5Sy+XSwCmZfZsoqPeVqjRaTn/cM2+pkFfgAhf/sA8PnV3KLaexIymSACF1iYFgYRR/V71oMbD3JdTRrGj5BqUWk2pEhPIGAiNk5eav1fM/34XdSpQLPDHel4bSfui0W85XhM+xc0pGdKhYTGKeXqxWiDKtWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8BCEB6061A; Wed, 10 Sep 2025 10:03:31 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: s.hanreich@proxmox.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 5/5] netfilter: nf_tables: restart set lookup on base_seq change
Date: Wed, 10 Sep 2025 10:02:22 +0200
Message-ID: <20250910080227.11174-6-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250910080227.11174-1-fw@strlen.de>
References: <20250910080227.11174-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The hash, hash_fast, rhash and bitwise sets may indicate no result even
though a matching element exists during a short time window while other
cpu is finalizing the transaction.

This happens when the hash lookup/bitwise lookup function has picked up
the old genbit, right before it was toggled by nf_tables_commit(), but
then the same cpu managed to unlink the matching old element from the
hash table:

cpu0					cpu1
  has added new elements to clone
  has marked elements as being
  inactive in new generation
					perform lookup in the set
  enters commit phase:
					A) observes old genbit
   increments base_seq
I) increments the genbit
II) removes old element from the set
					B) finds matching element
					C) returns no match: found
					element is not valid in old
					generation

					Next lookup observes new genbit and
					finds matching e2.

Consider a packet matching element e1, e2.

cpu0 processes following transaction:
1. remove e1
2. adds e2, which has same key as e1.

P matches both e1 and e2.  Therefore, cpu1 should always find a match
for P. Due to above race, this is not the case:

cpu1 observed the old genbit.  e2 will not be considered once it is found.
The element e1 is not found anymore if cpu0 managed to unlink it from the
hlist before cpu1 found it during list traversal.

The situation only occurs for a brief time period, lookups happening
after I) observe new genbit and return e2.

This problem exists in all set types except nft_set_pipapo, so fix it once
in nft_lookup rather than each set ops individually.

Sample the base sequence counter, which gets incremented right before the
genbit is changed.

Then, if no match is found, retry the lookup if the base sequence was
altered in between.

If the base sequence hasn't changed:
 - No update took place: no-match result is expected.
   This is the common case.  or:
 - nf_tables_commit() hasn't progressed to genbit update yet.
   Old elements were still visible and nomatch result is expected, or:
 - nf_tables_commit updated the genbit:
   We picked up the new base_seq, so the lookup function also picked
   up the new genbit, no-match result is expected.

If the old genbit was observed, then nft_lookup also picked up the old
base_seq: nft_lookup_should_retry() returns true and relookup is performed
in the new generation.

Thanks to Pablo Neira Ayuso for reviewing an earlier version of this
patchset, for suggesting re-use of existing base_seq and placement of
the restart loop in nft_set_do_lookup().

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c |  3 ++-
 net/netfilter/nft_lookup.c    | 31 ++++++++++++++++++++++++++++++-
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9518b50695ba..c3c73411c40c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10973,7 +10973,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	while (++base_seq == 0)
 		;
 
-	WRITE_ONCE(net->nft.base_seq, base_seq);
+	/* pairs with smp_load_acquire in nft_lookup_eval */
+	smp_store_release(&net->nft.base_seq, base_seq);
 
 	gc_seq = nft_gc_seq_begin(nft_net);
 
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 2c6909bf1b40..58c5b14889c4 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -55,11 +55,40 @@ __nft_set_do_lookup(const struct net *net, const struct nft_set *set,
 	return set->ops->lookup(net, set, key);
 }
 
+static unsigned int nft_base_seq(const struct net *net)
+{
+	/* pairs with smp_store_release() in nf_tables_commit() */
+	return smp_load_acquire(&net->nft.base_seq);
+}
+
+static bool nft_lookup_should_retry(const struct net *net, unsigned int seq)
+{
+	return unlikely(seq != nft_base_seq(net));
+}
+
 const struct nft_set_ext *
 nft_set_do_lookup(const struct net *net, const struct nft_set *set,
 		  const u32 *key)
 {
-	return __nft_set_do_lookup(net, set, key);
+	const struct nft_set_ext *ext;
+	unsigned int base_seq;
+
+	do {
+		base_seq = nft_base_seq(net);
+
+		ext = __nft_set_do_lookup(net, set, key);
+		if (ext)
+			break;
+		/* No match?  There is a small chance that lookup was
+		 * performed in the old generation, but nf_tables_commit()
+		 * already unlinked a (matching) element.
+		 *
+		 * We need to repeat the lookup to make sure that we didn't
+		 * miss a matching element in the new generation.
+		 */
+	} while (nft_lookup_should_retry(net, base_seq));
+
+	return ext;
 }
 EXPORT_SYMBOL_GPL(nft_set_do_lookup);
 
-- 
2.49.1

