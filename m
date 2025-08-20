Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EBF2DE1E6;
	Wed, 20 Aug 2025 14:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755701283; cv=none; b=M5ymb8A4b+rkj/6CUi/Kmv6GgQL9Tgf+t+tLHn+JVJX44yM+/o2XLz0MS0zJty4VUL65ifFVCveG9nsVKuy2HyoUOeYoeaizwdh2Xu/c6Ds/d83ddYLSisNsyMSWnno7kHs65TQLfdyv/mHW9rHg+/H5e4s+ZYZVNEI59RBnWLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755701283; c=relaxed/simple;
	bh=e/XcA+nEeJoUl4siT+YAXV78xmDatUIkwvCs9HGTG1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ND4yj3Ve2xxKlGjXJktLV3SyRNqpsk0iEaRJs+eL4jTZ8hs4ycVQFSrAf/nlyGfQpZSyIB01wFpUU0oGHJedROd2Q2feQfGqsH0/bPs9MfgrNaVMf715z9wip0LGYStvEU/Rsa3kBYcPz/OWw5FViZv4kVVsjPp9/WoCd+OKAL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 34909602F8; Wed, 20 Aug 2025 16:48:00 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 4/6] netfilter: nft_set_pipapo: use avx2 algorithm for insertions too
Date: Wed, 20 Aug 2025 16:47:36 +0200
Message-ID: <20250820144738.24250-5-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250820144738.24250-1-fw@strlen.de>
References: <20250820144738.24250-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Always prefer the avx2 implementation if its available.
This greatly improves insertion performance (each insertion
checks if the new element would overlap with an existing one):

time nft -f - <<EOF
table ip pipapo {
	set s {
		typeof ip saddr . tcp dport
		flags interval
		size 800000
		elements = { 10.1.1.1 - 10.1.1.4 . 3996,
[.. 800k entries elided .. ]

before:
real    1m55.993s
user    0m2.505s
sys     1m53.296s

after:
real    0m42.586s
user    0m2.554s
sys     0m39.811s

Fold patch from Sebastian:

kernel_fpu_begin_mask()/ _end() remains in pipapo_get_avx2() where it is
required.

A followup patch will add local_lock_t to struct nft_pipapo_scratch in
order to protect the map pointer. The lock can not be acquired in
preemption disabled context which is what kernel_fpu_begin*() does.

Link: https://lore.kernel.org/netfilter-devel/20250818110213.1319982-2-bigeasy@linutronix.de/
Co-developed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo.c      | 45 +++++++++++++++++++++++++----
 net/netfilter/nft_set_pipapo_avx2.c |  8 ++---
 net/netfilter/nft_set_pipapo_avx2.h |  4 +++
 3 files changed, 48 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 9a10251228fd..7ed9c5f0e233 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -397,7 +397,7 @@ int pipapo_refill(unsigned long *map, unsigned int len, unsigned int rules,
 }
 
 /**
- * pipapo_get() - Get matching element reference given key data
+ * pipapo_get_slow() - Get matching element reference given key data
  * @m:		storage containing the set elements
  * @data:	Key data to be matched against existing elements
  * @genmask:	If set, check that element is active in given genmask
@@ -414,9 +414,9 @@ int pipapo_refill(unsigned long *map, unsigned int len, unsigned int rules,
  *
  * Return: pointer to &struct nft_pipapo_elem on match, NULL otherwise.
  */
-static struct nft_pipapo_elem *pipapo_get(const struct nft_pipapo_match *m,
-					  const u8 *data, u8 genmask,
-					  u64 tstamp)
+static struct nft_pipapo_elem *pipapo_get_slow(const struct nft_pipapo_match *m,
+					       const u8 *data, u8 genmask,
+					       u64 tstamp)
 {
 	struct nft_pipapo_scratch *scratch;
 	unsigned long *res_map, *fill_map;
@@ -502,6 +502,41 @@ static struct nft_pipapo_elem *pipapo_get(const struct nft_pipapo_match *m,
 	return NULL;
 }
 
+/**
+ * pipapo_get() - Get matching element reference given key data
+ * @m:		Storage containing the set elements
+ * @data:	Key data to be matched against existing elements
+ * @genmask:	If set, check that element is active in given genmask
+ * @tstamp:	Timestamp to check for expired elements
+ *
+ * This is a dispatcher function, either calling out the generic C
+ * implementation or, if available, the AVX2 one.
+ * This helper is only called from the control plane, with either RCU
+ * read lock or transaction mutex held.
+ *
+ * Return: pointer to &struct nft_pipapo_elem on match, NULL otherwise.
+ */
+static struct nft_pipapo_elem *pipapo_get(const struct nft_pipapo_match *m,
+					  const u8 *data, u8 genmask,
+					  u64 tstamp)
+{
+	struct nft_pipapo_elem *e;
+
+	local_bh_disable();
+
+#if defined(CONFIG_X86_64) && !defined(CONFIG_UML)
+	if (boot_cpu_has(X86_FEATURE_AVX2) && boot_cpu_has(X86_FEATURE_AVX) &&
+	    irq_fpu_usable()) {
+		e = pipapo_get_avx2(m, data, genmask, tstamp);
+		local_bh_enable();
+		return e;
+	}
+#endif
+	e = pipapo_get_slow(m, data, genmask, tstamp);
+	local_bh_enable();
+	return e;
+}
+
 /**
  * nft_pipapo_lookup() - Dataplane fronted for main lookup function
  * @net:	Network namespace
@@ -523,7 +558,7 @@ nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
 	const struct nft_pipapo_elem *e;
 
 	m = rcu_dereference(priv->match);
-	e = pipapo_get(m, (const u8 *)key, genmask, get_jiffies_64());
+	e = pipapo_get_slow(m, (const u8 *)key, genmask, get_jiffies_64());
 
 	return e ? &e->ext : NULL;
 }
diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index 994a2ad2d9b1..028c11724b42 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1149,9 +1149,9 @@ static inline void pipapo_resmap_init_avx2(const struct nft_pipapo_match *m, uns
  *
  * Return: pointer to &struct nft_pipapo_elem on match, NULL otherwise.
  */
-static struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
-					       const u8 *data, u8 genmask,
-					       u64 tstamp)
+struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
+					const u8 *data, u8 genmask,
+					u64 tstamp)
 {
 	struct nft_pipapo_scratch *scratch;
 	const struct nft_pipapo_field *f;
@@ -1261,7 +1261,7 @@ static struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
  *
  * This function is called from the data path.  It will search for
  * an element matching the given key in the current active copy using
- * the AVX2 routines if the fpu is usable or fall back to the generic
+ * the AVX2 routines if the FPU is usable or fall back to the generic
  * implementation of the algorithm otherwise.
  *
  * Return: nftables API extension pointer or NULL if no match.
diff --git a/net/netfilter/nft_set_pipapo_avx2.h b/net/netfilter/nft_set_pipapo_avx2.h
index dbb6aaca8a7a..c2999b63da3f 100644
--- a/net/netfilter/nft_set_pipapo_avx2.h
+++ b/net/netfilter/nft_set_pipapo_avx2.h
@@ -5,8 +5,12 @@
 #include <asm/fpu/xstate.h>
 #define NFT_PIPAPO_ALIGN	(XSAVE_YMM_SIZE / BITS_PER_BYTE)
 
+struct nft_pipapo_match;
 bool nft_pipapo_avx2_estimate(const struct nft_set_desc *desc, u32 features,
 			      struct nft_set_estimate *est);
+struct nft_pipapo_elem *pipapo_get_avx2(const struct nft_pipapo_match *m,
+					const u8 *data, u8 genmask,
+					u64 tstamp);
 #endif /* defined(CONFIG_X86_64) && !defined(CONFIG_UML) */
 
 #endif /* _NFT_SET_PIPAPO_AVX2_H */
-- 
2.49.1

