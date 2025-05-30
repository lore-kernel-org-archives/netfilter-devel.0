Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A691F4C85
	for <netfilter-devel@vger.kernel.org>; Fri, 30 May 2025 10:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748601264; cv=none; b=Kqv6qAZpJogx2tM/+pqKpHTm/urRknmKklrVMI3/R/G7bLPWS3jr4UnUiC0dQ+8ipaCycASpqwZzAp3rTNYAH85BvGk1R8cQldIzX/b6lzTrMHXbcVqY5aST2Hv4sD6tOdOovmZtmYehJp31n1d2W605uUO1UUxbmd2WAo2zW1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748601264; c=relaxed/simple;
	bh=weqtXhVQtBI8J4Kmv60WccsLoJ9qF2u0wbwPt1CpROs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=smLNaUeVT+ZdVLyy+hMLghfME41bJMthvsDGeqUvzD5eTox/lknYMTO0T8rPqNuFodj9jZhdpDCRT3koqQamKld9xfQlVo/ZXmhJnRuUPaBJVHL32oTZ26h4FRs4Txn5YjJSd+39ncpOOezMGGIFkR9GKlUEsCA1r+7q6G4Pyo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2986E60489; Fri, 30 May 2025 12:34:20 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Yafang Shao <laoar.shao@gmail.com>,
	Shaun Brady <brady.1345@gmail.com>
Subject: [PATCH nf 1/2] netfilter: nf_nat: also check reverse tuple to obtain clashing entry
Date: Fri, 30 May 2025 12:34:02 +0200
Message-ID: <20250530103408.3767-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The logic added in the blamed commit was supposed to only omit nat source
port allocation if neither the existing nor the new entry are subject to
NAT.

However, its not enough to lookup the conntrack based on the proposed
tuple, we must also check the reverse direction.

Otherwise there are esoteric cases where the collision is in the reverse
direction because that colliding connection has a port rewrite, but the
new entry doesn't.  In this case, we only check the new entry and then
erronously conclude that no clash exists anymore.

 The existing (udp) tuple is:
  a:p -> b:P, with nat translation to s:P, i.e. pure daddr rewrite,
  reverse tuple in conntrack table is s:P -> a:p.

When another UDP packet is sent directly to s, i.e. a:p->s:P, this is
correctly detected as a colliding entry: tuple is taken by existing reply
tuple in reverse direction.

But the colliding conntrack is only searched for with unreversed
direction, and we can't find such entry matching a:p->s:P.

The incorrect conclusion is that the clashing entry has timed out and
that no port address translation is required.

Such conntrack will then be discarded at nf_confirm time because the
proposed reverse direction clashes with an existing mapping in the
conntrack table.

Search for the reverse tuple too, this will then check the NAT bits of
the colliding entry and triggers port reallocation.

Followp patch extends nft_nat.sh selftest to cover this scenario.

The IPS_SEQ_ADJUST change is also a bug fix:
Instead of checking for SEQ_ADJ this tested for SEEN_REPLY and ASSURED
by accident -- _BIT is only for use with the test_bit() API.

This bug has little consequence in practice, because the sequence number
adjustments are only useful for TCP which doesn't support clash resolution.

The existing test case (conntrack_clash_clash.sh) exercise a race
condition path (parallel conntrack creation on different CPUs), so
the colliding entries have neither SEEN_REPLY nor ASSURED set.

Thanks to Yafang Shao and Shaun Brady for an initial investigation
of this bug.

Fixes: d8f84a9bc7c4 ("netfilter: nf_nat: don't try nat source port reallocation for reverse dir clash")
Reported-by: Yafang Shao <laoar.shao@gmail.com>
Reported-by: Shaun Brady <brady.1345@gmail.com>
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1795
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_nat_core.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index aad84aabd7f1..f391cd267922 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -248,7 +248,7 @@ static noinline bool
 nf_nat_used_tuple_new(const struct nf_conntrack_tuple *tuple,
 		      const struct nf_conn *ignored_ct)
 {
-	static const unsigned long uses_nat = IPS_NAT_MASK | IPS_SEQ_ADJUST_BIT;
+	static const unsigned long uses_nat = IPS_NAT_MASK | IPS_SEQ_ADJUST;
 	const struct nf_conntrack_tuple_hash *thash;
 	const struct nf_conntrack_zone *zone;
 	struct nf_conn *ct;
@@ -287,8 +287,14 @@ nf_nat_used_tuple_new(const struct nf_conntrack_tuple *tuple,
 	zone = nf_ct_zone(ignored_ct);
 
 	thash = nf_conntrack_find_get(net, zone, tuple);
-	if (unlikely(!thash)) /* clashing entry went away */
-		return false;
+	if (unlikely(!thash)) {
+		struct nf_conntrack_tuple reply;
+
+		nf_ct_invert_tuple(&reply, tuple);
+		thash = nf_conntrack_find_get(net, zone, &reply);
+		if (!thash) /* clashing entry went away */
+			return false;
+	}
 
 	ct = nf_ct_tuplehash_to_ctrack(thash);
 
-- 
2.49.0

