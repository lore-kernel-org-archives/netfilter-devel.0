Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0882D321D;
	Wed, 10 Sep 2025 19:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757531017; cv=none; b=CwMmed3okHbRtMZczEiXdU76Wl+4ZaEloKysiuHvwtIWSNeLZFiJzbd8we8UtG4IgSDoDeqTXap2ElXxUL6Dl7T8AWhW34fzibENSDXXSUZ3tjvqYxRubwo+Fd/8KWkLMewDiy8XJw8WDMqNm+TYQV246NsXBf9Q/+/afoerCGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757531017; c=relaxed/simple;
	bh=RZkLJmnu4KKD9rPqv0Tyzj55eXi2H/j/TWfr/YV1nSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/9Xng+Tunp+ehH27SkkEpqL47P9RzSP6UC4salMszqeuAMTeZUjjROpSM9Op1/nhmaCY1D2e+src5Z470OSDBhQuT1g7bWC9s3GtOE1wrAmhP+8gfXKTDSVGIFf/1oKbbhhDWoeAKRWjrE/ol+vgzZkyDY8sUoVC+LWr8fwtCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7F4D860532; Wed, 10 Sep 2025 21:03:34 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 5/7] netfilter: nf_tables: make nft_set_do_lookup available unconditionally
Date: Wed, 10 Sep 2025 21:03:06 +0200
Message-ID: <20250910190308.13356-6-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250910190308.13356-1-fw@strlen.de>
References: <20250910190308.13356-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This function was added for retpoline mitigation and is replaced by a
static inline helper if mitigations are not enabled.

Enable this helper function unconditionally so next patch can add a lookup
restart mechanism to fix possible false negatives while transactions are
in progress.

Adding lookup restarts in nft_lookup_eval doesn't work as nft_objref would
then need the same copypaste loop.

This patch is separate to ease review of the actual bug fix.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables_core.h | 10 ++--------
 net/netfilter/nft_lookup.c             | 17 ++++++++++++-----
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 6c2f483d9828..656e784714f3 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -109,17 +109,11 @@ nft_hash_lookup_fast(const struct net *net, const struct nft_set *set,
 const struct nft_set_ext *
 nft_hash_lookup(const struct net *net, const struct nft_set *set,
 		const u32 *key);
+#endif
+
 const struct nft_set_ext *
 nft_set_do_lookup(const struct net *net, const struct nft_set *set,
 		  const u32 *key);
-#else
-static inline const struct nft_set_ext *
-nft_set_do_lookup(const struct net *net, const struct nft_set *set,
-		  const u32 *key)
-{
-	return set->ops->lookup(net, set, key);
-}
-#endif
 
 /* called from nft_pipapo_avx2.c */
 const struct nft_set_ext *
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 40c602ffbcba..2c6909bf1b40 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -24,11 +24,11 @@ struct nft_lookup {
 	struct nft_set_binding		binding;
 };
 
-#ifdef CONFIG_MITIGATION_RETPOLINE
-const struct nft_set_ext *
-nft_set_do_lookup(const struct net *net, const struct nft_set *set,
-		  const u32 *key)
+static const struct nft_set_ext *
+__nft_set_do_lookup(const struct net *net, const struct nft_set *set,
+		    const u32 *key)
 {
+#ifdef CONFIG_MITIGATION_RETPOLINE
 	if (set->ops == &nft_set_hash_fast_type.ops)
 		return nft_hash_lookup_fast(net, set, key);
 	if (set->ops == &nft_set_hash_type.ops)
@@ -51,10 +51,17 @@ nft_set_do_lookup(const struct net *net, const struct nft_set *set,
 		return nft_rbtree_lookup(net, set, key);
 
 	WARN_ON_ONCE(1);
+#endif
 	return set->ops->lookup(net, set, key);
 }
+
+const struct nft_set_ext *
+nft_set_do_lookup(const struct net *net, const struct nft_set *set,
+		  const u32 *key)
+{
+	return __nft_set_do_lookup(net, set, key);
+}
 EXPORT_SYMBOL_GPL(nft_set_do_lookup);
-#endif
 
 void nft_lookup_eval(const struct nft_expr *expr,
 		     struct nft_regs *regs,
-- 
2.49.1

