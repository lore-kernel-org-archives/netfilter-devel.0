Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD482340DAB;
	Thu, 11 Sep 2025 14:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757601518; cv=none; b=SwiZpO2AUc88UsyOJDU2npMI3PInyjUz1Zjr+BXIG2jxBHVregVRTtofKbBLXFu2GVfWsJoegzzTbC4XR+qMlJd8JgCtrHFQJF1+/AzzqWxUy1b8laH2fVmUxfzYQc8hMzs77OeAhRtVd8T8pDYBWSJh0sko2oxfYyhHwKfoI8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757601518; c=relaxed/simple;
	bh=0GKBcWnoMkmGgI6KSrz2yAfXdWpuS9nTro7aEOdcQyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrnRL6T6yK2iNmooJGm8QH7B8tWzhheBP3Afa8jpPE3k64CPN1+VPHoPv40bmliK53XWBcoXTdeL8bPhjwhdzbA+KdCHAm794v98NyIf72b6+/VXty0S/s2Yz2F45qMOHoiqu3LhkEIyyb4wYddD0+jTqkRBuDzf1vq8nkNYbWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 732796014E; Thu, 11 Sep 2025 16:38:32 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 2/5] netfilter: ipset: Remove unused htable_bits in macro ahash_region
Date: Thu, 11 Sep 2025 16:38:16 +0200
Message-ID: <20250911143819.14753-3-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250911143819.14753-1-fw@strlen.de>
References: <20250911143819.14753-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhen Ni <zhen.ni@easystack.cn>

Since the ahash_region() macro was redefined to calculate the region
index solely from HTABLE_REGION_BITS, the htable_bits parameter became
unused.

Remove the unused htable_bits argument and its call sites, simplifying
the code without changing semantics.

Fixes: 8478a729c046 ("netfilter: ipset: fix region locking in hash types")
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
Reviewed-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 5251524b96af..5e4453e9ef8e 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -63,7 +63,7 @@ struct hbucket {
 		: jhash_size((htable_bits) - HTABLE_REGION_BITS))
 #define ahash_sizeof_regions(htable_bits)		\
 	(ahash_numof_locks(htable_bits) * sizeof(struct ip_set_region))
-#define ahash_region(n, htable_bits)		\
+#define ahash_region(n)		\
 	((n) / jhash_size(HTABLE_REGION_BITS))
 #define ahash_bucket_start(h,  htable_bits)	\
 	((htable_bits) < HTABLE_REGION_BITS ? 0	\
@@ -702,7 +702,7 @@ mtype_resize(struct ip_set *set, bool retried)
 #endif
 				key = HKEY(data, h->initval, htable_bits);
 				m = __ipset_dereference(hbucket(t, key));
-				nr = ahash_region(key, htable_bits);
+				nr = ahash_region(key);
 				if (!m) {
 					m = kzalloc(sizeof(*m) +
 					    AHASH_INIT_SIZE * dsize,
@@ -852,7 +852,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	rcu_read_lock_bh();
 	t = rcu_dereference_bh(h->table);
 	key = HKEY(value, h->initval, t->htable_bits);
-	r = ahash_region(key, t->htable_bits);
+	r = ahash_region(key);
 	atomic_inc(&t->uref);
 	elements = t->hregion[r].elements;
 	maxelem = t->maxelem;
@@ -1050,7 +1050,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	rcu_read_lock_bh();
 	t = rcu_dereference_bh(h->table);
 	key = HKEY(value, h->initval, t->htable_bits);
-	r = ahash_region(key, t->htable_bits);
+	r = ahash_region(key);
 	atomic_inc(&t->uref);
 	rcu_read_unlock_bh();
 
-- 
2.49.1

