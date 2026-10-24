Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.126.134
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792840598;
	b=oFjlMz2NbOq4CpHrcyCOVy6/HDRLJ4Etz4rwqrywU54qzZfRW9fEStW/NlJ1k52kM+Ct
	 Hl7/vCs+KFZuxdoZEw9CeTfpzaqeDWLSpTL+UTjnZwbRs+YP1+wQRF3rdVcPQPyNnBQBr
	 BUZ1b2ZcXYmKerXoMhHR+7hUdQuuYATzP4PsZcA2avQiI7F0CATtr5R1qKB2BroTcKmwt
	 xgVR+wDWCOq18sx6fB+nAnHt4NcIKVLTi4l55OBnnDw4sALF89H7oTYw0UNRR7VeQ3t1s
	 kZ0FlyDsQnjsiL+cYKPq9l/vlS8C1ioheQcrQtQQ5z4g6wJGS0UGJv7kKgwmeJbXwIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792840598;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=lpfw3H4mNofQFtQNtLD1IzZDLp3tyAmxuTnxuHFJBoQ=;
	b=eU3zMgw8IcyEaRSE6eqI1KOnQCQK5pZxcUC78JIzFUJ7dPlRaYWXERRDfFzQ9RuDorGz
	 wjrA3mGayBPOkpBe+c9kpRvxGp2OLLTmQE+SJ6QsoFFuNZbhFHGuLXRvuAZlb55KZRC8c
	 bVEcWkrKaPAxKPmtQ6NRGxcuyvqCgUpunAa6WdJr/IxF8/OUAd9CrdeLbAhNqPfoZJLF0
	 RpEnhSnkfM+mY2+nwddIh16VJgIiP32R2Kfd1BSMvIhsLiH5/QABxxQYm9aS5fephegrG
	 169qyVH2ADvzbT39pjxiFIWc8Brwahnc9fpw6SsmPrGq6Ff3Mpz+nR4+MrB4Oxy/L+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=kernelscan.io;
	spf=pass smtp.mailfrom=kernelscan.io;
	arc=none smtp.remote-ip=212.227.126.134
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CBC606A31A;
	Sat, 24 Oct 2026 11:16:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28CBC606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kernelscan.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernelscan.io
Received: from client.hidden.invalid by mrelayeu.kundenserver.de (mreue012
 [213.165.67.97]) with ESMTPSA (Nemesis) id 1MBBCI-1xQfaq1GrW-00FFQ0; Sat, 24
 Oct 2026 13:16:14 +0200
From: Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
To: stable@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [PATCH 5.10.y] netfilter: nf_tables: unconditionally bump set->nelems before insertion
Date: Sat, 24 Oct 2026 13:16:11 +0200
Message-ID: <20261024111611.51303-1-steffen.pfendtner@kernelscan.io>
X-Mailer: git-send-email 2.50.1
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:UsYXzGOuKxScpQ0ui1NM9QLybUWnZv7SwEnYxnT/3yRd1IzYBUu
 o5vYM63ZD47+r1ERvMjFwSxtbAFWY/sQC8syYtJriVjAZjhREssATh6KtxKysRc3LBgdHtC
 x9XR18A3Gru6tgseCZcl/kEGLj8jK+2ScIud8OttP8Zo9zEc/W7mu3Sd+TU4YCmoDECxMbs
 HDxKJpB37y2+bbPnBQl7Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:K319BfJDzB0=;SRQ7TUE93DAnqg4S7Lcp0TnPju/
 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
 wRnu0//

[ Upstream commit def602e498a4f951da95c95b1b8ce8ae68aa733a ]

In case that the set is full, a new element gets published then removed
without waiting for the RCU grace period, while RCU reader can be
walking over it already.

To address this issue, add the element transaction even if set is full,
but toggle the set_full flag to report -ENFILE so the abort path safely
unwinds the set to its previous state.

As for element updates, decrement set->nelems to restore it.

A simpler fix is to call synchronize_rcu() in the error path.
However, with a large batch adding elements to already maxed-out set,
this could cause noticeable slowdown of such batches.

Fixes: 35d0ac9070ef ("netfilter: nf_tables: fix set->nelems counting with no NLM_F_EXCL")
Reported-by: Inseo An <y0un9sa@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
[ Backport to 5.10.y: 5.10 has neither the nft_set_maxsize() helper nor
  the NFT_SET_ELEM_CATCHALL element class, so the per-set ceiling is
  inlined (max = set->size + set->ndeact) and gated only on set->size,
  matching 5.10's original accounting. The element is counted with
  atomic_inc_return() before insertion; on the full-set path it is now
  left in the transaction and unwound by the abort path instead of being
  removed in-place without an RCU grace period (the old err_set_full
  set->ops->remove() call, which is the use-after-free being fixed). The
  matching atomic_dec() runs on every error path, guarded on set->size. ]
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
---
Not a clean cherry-pick, please see the bracketed backport note: 5.10 has
neither nft_set_maxsize() nor catchall elements, so the change was adapted
by hand. A review of the adaptation from the netfilter side would be
appreciated.

Build-tested on arm64, and boot-tested under QEMU with KASAN: the set size
limit is still enforced (ENFILE), element counts stay correct across
delete/re-add and flush, unlimited sets are unaffected, no KASAN reports.

 net/netfilter/nf_tables_api.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 63592c73a7a1..54d1dd670c11 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5596,6 +5596,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_data_desc desc;
 	enum nft_registers dreg;
 	struct nft_trans *trans;
+	bool set_full = false;
 	u32 flags = 0;
 	u64 timeout;
 	u64 expiration;
@@ -5806,10 +5807,18 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		goto err_elem_expr;
 	expr = NULL;
 
+	if (set->size) {
+		unsigned int max = set->size + set->ndeact, nelems;
+
+		nelems = atomic_inc_return(&set->nelems);
+		if (nelems > max)
+			set_full = true;
+	}
+
 	trans = nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
 	if (trans == NULL) {
 		err = -ENOMEM;
-		goto err_elem_expr;
+		goto err_set_size;
 	}
 
 	ext->genmask = nft_genmask_cur(ctx->net);
@@ -5841,20 +5850,16 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		goto err_element_clash;
 	}
 
-	if (set->size &&
-	    !atomic_add_unless(&set->nelems, 1, set->size + set->ndeact)) {
-		err = -ENFILE;
-		goto err_set_full;
-	}
-
 	nft_trans_elem(trans) = elem;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
-	return 0;
 
-err_set_full:
-	set->ops->remove(ctx->net, set, &elem);
+	return set_full ? -ENFILE : 0;
+
 err_element_clash:
 	kfree(trans);
+err_set_size:
+	if (set->size)
+		atomic_dec(&set->nelems);
 err_elem_expr:
 	nf_tables_set_elem_destroy(ctx, set, elem.priv);
 err_parse_data:
-- 
2.50.1 (Apple Git-155)

