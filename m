Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9001121FF4F
	for <netfilter-devel@vger.kernel.org>; Fri, 23 May 2025 12:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748002891; cv=none; b=tQGp4omVmfs3X9USQgMIAsNfGPRSFsmGFqYQuiZyAncR1GF2AP6LPDGGs4ArRgLXI1JAawqTj9dqc2z17Bgjg4TxQ7L8MTh+EXXC3MhYh8Fn2DmcVZbMEk/lbOp0U11Eihi7kfKtU83Ra6jM4/1nhzbFPM8V3/c5aqzV9qnn9C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748002891; c=relaxed/simple;
	bh=fyzHHhnvka9Dd3vVrr+/JGNLaCMx6O3QCo2iW0xTmRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NK6K41JvN6GcAiyJvWdcG4YCrnNgRfTDsU5mN41apSiqPp693Psacsix7hiE8uUCuAnLQ2EawHcAEEobiFi/KpxiMK3EjwNF8k8VPgosIrN2OE+RJlwKJt0q2IvMyNXBCtJ0dpBR80Hd4ZwHMBDuSTk/j6riGUT6FUdLplpVEhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6EBCC6035E; Fri, 23 May 2025 14:21:27 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/3] netfilter: nf_set_pipapo_avx2: fix initial map fill
Date: Fri, 23 May 2025 14:20:44 +0200
Message-ID: <20250523122051.20315-2-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250523122051.20315-1-fw@strlen.de>
References: <20250523122051.20315-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the first field doesn't cover the entire start map, then we must zero
out the remainder, else we leak those bits into the next match round map.

The earlie fix was incomplete and did only fix up the generic C
implementation.

A followup patch adds a test case to nft_concat_range.sh.

Fixes: 791a615b7ad2 ("netfilter: nf_set_pipapo: fix initial map fill")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo_avx2.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index c15db28c5ebc..be7c16c79f71 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1113,6 +1113,25 @@ bool nft_pipapo_avx2_estimate(const struct nft_set_desc *desc, u32 features,
 	return true;
 }
 
+/**
+ * pipapo_resmap_init_avx2() - Initialise result map before first use
+ * @m:		Matching data, including mapping table
+ * @res_map:	Result map
+ *
+ * Like pipapo_resmap_init() but do not set start map bits covered by the first field.
+ */
+static inline void pipapo_resmap_init_avx2(const struct nft_pipapo_match *m, unsigned long *res_map)
+{
+	const struct nft_pipapo_field *f = m->f;
+	int i;
+
+	/* Starting map doesn't need to be set to all-ones for this implementation,
+	 * but we do need to zero the remaining bits, if any.
+	 */
+	for (i = f->bsize; i < m->bsize_max; i++)
+		res_map[i] = 0ul;
+}
+
 /**
  * nft_pipapo_avx2_lookup() - Lookup function for AVX2 implementation
  * @net:	Network namespace
@@ -1171,7 +1190,7 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 	res  = scratch->map + (map_index ? m->bsize_max : 0);
 	fill = scratch->map + (map_index ? 0 : m->bsize_max);
 
-	/* Starting map doesn't need to be set for this implementation */
+	pipapo_resmap_init_avx2(m, res);
 
 	nft_pipapo_avx2_prepare();
 
-- 
2.49.0

