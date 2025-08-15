Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B66826F44D
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Aug 2025 14:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755268650; cv=none; b=ehnfEPhStzW1ZmmdSCU3EdxONZk6p4oamZafDfL8h5OLqG2JOrhBt+q9AK0FvexHybqtE7Uyh6IoyauyuqfqrazQwXeI39nZMnwDHABWCE+T9iEL9rwW2+0qMjpaj0zxCYnAUjAETXKUTEdlZTDqHsSIO2xUDCyWRBVxbcLirLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755268650; c=relaxed/simple;
	bh=2SANT7uMN0dz/KzlAwiOksACZE/R62PX2EmwNHBCvU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JaRVTpCrsdtePGXFZCTgZJe9EN16DlH5cU/vzLhGxqbi5fJk3ApqIYUkogL6xqTa87laDgZpn/28MlnNEIgRpwGWu8eJmFeKVhrO4lHqkvnnnhPxDJ65KBnRUKnqxQlz6WL0MJsz6dzdd4uNIBfyfJJCYG5iWe60abQrzKibu88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 713D86064D; Fri, 15 Aug 2025 16:37:26 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/2] netfilter: nft_set_pipapo: use avx2 algorithm for insertions too
Date: Fri, 15 Aug 2025 16:36:58 +0200
Message-ID: <20250815143702.17272-3-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250815143702.17272-1-fw@strlen.de>
References: <20250815143702.17272-1-fw@strlen.de>
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

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo.c      | 47 ++++++++++++++++++++++++++---
 net/netfilter/nft_set_pipapo_avx2.c |  6 ++--
 net/netfilter/nft_set_pipapo_avx2.h |  4 +++
 3 files changed, 49 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 9a10251228fd..affa473b13a6 100644
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
@@ -502,6 +502,43 @@ static struct nft_pipapo_elem *pipapo_get(const struct nft_pipapo_match *m,
 	return NULL;
 }
 
+/**
+ * pipapo_get() - Get matching element reference given key data
+ * @m:		storage containing the set elements
+ * @data:	Key data to be matched against existing elements
+ * @genmask:	If set, check that element is active in given genmask
+ * @tstamp:	timestamp to check for expired elements
+ *
+ * This is a dispatcher function, either calling out the generic C
+ * implementation or, if available, the avx2 one.
+ * This helper is only called from the control plane, with either rcu
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
+		kernel_fpu_begin_mask(0);
+		e = pipapo_get_avx2(m, data, genmask, tstamp);
+		kernel_fpu_end();
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
@@ -523,7 +560,7 @@ nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
 	const struct nft_pipapo_elem *e;
 
 	m = rcu_dereference(priv->match);
-	e = pipapo_get(m, (const u8 *)key, genmask, get_jiffies_64());
+	e = pipapo_get_slow(m, (const u8 *)key, genmask, get_jiffies_64());
 
 	return e ? &e->ext : NULL;
 }
diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index d512877cc211..7a9900f8ce2f 100644
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

