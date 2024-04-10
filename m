Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF9E7460
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Apr 2024 19:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712776033; cv=none; b=tDjF2dejC+YsF4hAxbXUWT4CZbsQPZj4n9AjAzrstJZnh0XEQwr4JxMopGtkSEOiSqafO0FqmXBM9W6QtrR/fM59ys5Hm9sydHQli6DRoKKiO0uyJrQHLBNGT9f73Qbq4CDJXZklboGuHp792sLJnDa3uQYbbH8861vVozoCPc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712776033; c=relaxed/simple;
	bh=/nVfUN5Zl2MIlaFWdX/NfgDqDawxhP9gj2guKsrO418=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ajo8WYcxtNV9Mh3fMVPdvusKk3XOByMWsg73Sa6h1HpC+hPzFH28r1YhzLjgvHqUTyIDp3PEneLriauOklo3FDA334D+S9v6MPKRo6rn2Gvy3t5Tjw+u/WWffNFmvplvIr1fQnHnRiVIQT/JPf8VW3l8D/+X+HBCsPXJCHqNpGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rudHn-0002HR-Hc; Wed, 10 Apr 2024 21:07:07 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Stefano Brivio <sbrivio@redhat.com>
Subject: [PATCH v2 nf] netfilter: nft_set_pipapo: do not free live element
Date: Wed, 10 Apr 2024 21:05:13 +0200
Message-ID: <20240410190515.27344-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pablo reports a crash with large batches of elements with a
back-to-back add/remove pattern.  Quoting Pablo:

  add_elem("00000000") timeout 100 ms
  ...
  add_elem("0000000X") timeout 100 ms
  del_elem("0000000X") <---------------- delete one that was just added
  ...
  add_elem("00005000") timeout 100 ms

  1) nft_pipapo_remove() removes element 0000000X
  Then, KASAN shows a splat.

Looking at the remove function there is a chance that we will drop a
rule that maps to a non-deactivated element.

Removal happens in two steps, first we do a lookup for key k and return the
to-be-removed element and mark it as inactive in the next generation.
Then, in a second step, the element gets removed from the set/map.

The _remove function does not work correctly if we have more than one
element that share the same key.

This can happen if we insert an element into a set when the set already
holds an element with same key, but the element mapping to the existing
key has timed out or is not active in the next generation.

In such case its possible that removal will unmap the wrong element.
If this happens, we will leak the non-deactivated element, it becomes
unreachable.

The element that got deactivated (and will be freed later) will
remain reachable in the set data structure, this can result in
a crash when such an element is retrieved during lookup (stale
pointer).

Add a check that the fully matching key does in fact map to the element
that we have marked as inactive in the deactivation step.
If not, we need to continue searching.

Add a bug/warn trap at the end of the function as well, the remove
function must not ever be called with an invisible/unreachable/non-existent
element.

v2: avoid uneeded temporary variable (Stefano)

Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index df8de5090246..80cc6a0b184f 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2077,6 +2077,8 @@ static void nft_pipapo_remove(const struct net *net, const struct nft_set *set,
 		rules_fx = rules_f0;
 
 		nft_pipapo_for_each_field(f, i, m) {
+			bool last = i == m->field_count - 1;
+
 			if (!pipapo_match_field(f, start, rules_fx,
 						match_start, match_end))
 				break;
@@ -2089,16 +2091,18 @@ static void nft_pipapo_remove(const struct net *net, const struct nft_set *set,
 
 			match_start += NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
 			match_end += NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
-		}
 
-		if (i == m->field_count) {
-			priv->dirty = true;
-			pipapo_drop(m, rulemap);
-			return;
+			if (last && f->mt[rulemap[i].to].e == e) {
+				priv->dirty = true;
+				pipapo_drop(m, rulemap);
+				return;
+			}
 		}
 
 		first_rule += rules_f0;
 	}
+
+	WARN_ON_ONCE(1); /* elem_priv not found */
 }
 
 /**
-- 
2.43.2

