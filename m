Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAADE302CDF;
	Wed, 24 Sep 2025 14:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758722840; cv=none; b=rs5woK6PqooHW3a62p9/JE4KPSpZUxrRsNWWeGlkIqGWdGroLb/HD+RKdTeEBKHtwxsQu0q0CJ9+ujZxmOZrQ0F2QCFi81sIBV12Ykmyi0uEO9aEdSoSJZI6PSdsyV//r8yfgEUb7Wcrgjo/IsMeb+h2EXuaMfQQhSIbyYaECDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758722840; c=relaxed/simple;
	bh=MWUw8gUL1WmkxMRBOhQ+0hyRJy+uT3s0hY0xIJ/maYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MbrY/HryIlhyMM0p6yJ0FVO61e/46qWMtk6f9Si2fWCy1X7r6kVKdVdt8DPGM8wjgGE3AmlxGlnxIljrl63myoJgHzxceDAeIzN5UH+/IHe7E04FR5UlmyHRLd4cRT8y8MarCiXFfvuFdeFnS2t+5onPYt52plvMqpHaaiWSTk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5296A601C9; Wed, 24 Sep 2025 16:07:17 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 3/6] netfilter: nft_set_pipapo: use 0 genmask for packetpath lookups
Date: Wed, 24 Sep 2025 16:06:51 +0200
Message-ID: <20250924140654.10210-4-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250924140654.10210-1-fw@strlen.de>
References: <20250924140654.10210-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In commit c4eaca2e1052 ("netfilter: nft_set_pipapo: don't check genbit from
packetpath lookups") I replaced genmask_cur() with NFT_GENMASK_ANY, but
this change has no effect in the pipapo set type.

New entries are unreachable from the active copy, so NFT_GENMASK_ANY has
same result as genmask_cur():

current-gen elements are disabled and the new-generation
elements cannot be found.

Tests did not catch this incomplete fix because the change also dropped
the genmask test from the AVX2 version of the algorithm, so test only
fails if host cpu lacks AVX2 support.

Use genmask test only from the control plane (inserts, deletions, ..).

Packet path has to skip the check, use of 0 is enough for this because
ext->genmask has a the relevant bit set when the element is INACTIVE
in that generation: using a 0 genmask thus makes nft_set_elem_active()
always return true.

Fix the comment and replace NFT_GENMASK_ANY with 0.

Fixes: c4eaca2e1052 ("netfilter: nft_set_pipapo: don't check genbit from packetpath lookups")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo.c      | 9 ++++-----
 net/netfilter/nft_set_pipapo_avx2.c | 2 +-
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index a7b8fa8cab7c..112fe46788b6 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -549,8 +549,7 @@ static struct nft_pipapo_elem *pipapo_get(const struct nft_pipapo_match *m,
  *
  * This function is called from the data path.  It will search for
  * an element matching the given key in the current active copy.
- * Unlike other set types, this uses NFT_GENMASK_ANY instead of
- * nft_genmask_cur().
+ * Unlike other set types, this uses 0 instead of nft_genmask_cur().
  *
  * This is because new (future) elements are not reachable from
  * priv->match, they get added to priv->clone instead.
@@ -560,8 +559,8 @@ static struct nft_pipapo_elem *pipapo_get(const struct nft_pipapo_match *m,
  * inconsistent state: matching old entries get skipped but thew
  * newly matching entries are unreachable.
  *
- * GENMASK will still find the 'now old' entries which ensures consistent
- * priv->match view.
+ * GENMASK_ANY doesn't work for the same reason: old-gen entries get
+ * skipped, new-gen entries are only reachable from priv->clone.
  *
  * nft_pipapo_commit swaps ->clone and ->match shortly after the
  * genbit flip.  As ->clone doesn't contain the old entries in the first
@@ -578,7 +577,7 @@ nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
 	const struct nft_pipapo_elem *e;
 
 	m = rcu_dereference(priv->match);
-	e = pipapo_get_slow(m, (const u8 *)key, NFT_GENMASK_ANY, get_jiffies_64());
+	e = pipapo_get_slow(m, (const u8 *)key, 0, get_jiffies_64());
 
 	return e ? &e->ext : NULL;
 }
diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index 27dab3667548..e72fd045d037 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1292,7 +1292,7 @@ nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 
 	m = rcu_dereference(priv->match);
 
-	e = pipapo_get_avx2(m, rp, NFT_GENMASK_ANY, get_jiffies_64());
+	e = pipapo_get_avx2(m, rp, 0, get_jiffies_64());
 	local_bh_enable();
 
 	return e ? &e->ext : NULL;
-- 
2.49.1

