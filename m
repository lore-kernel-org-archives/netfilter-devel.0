Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792942435;
	b=YcYF7TfUIPy6EzUqxhPHGC/S/Nn6KeMDeTVeD9+rgTLxjXhLsD2MjDVf7LlaOe1lArfn
	 wgxRWQ1iXdTJhIgeEjNP+Vy68rFVl6tWAzbIXgAL1w0R1jvp50ChtUmE6e3oyIjpxDBUB
	 hTY3mTO7KzWu+b2+O7hz4mE09Va2+TYXupkUunij8TpqhndCwmX1hOqI40OrKhL0xYq+5
	 c5X+6GpabiH7KyNCD6aN/p3vVw1OC60mqCGhyohSl4kJMJQDO+AmI2U44K7RS0MyB2tZZ
	 OsV4bt/4TMLm4vw+ekUBPyJ7SjNx25JWXEo38x1y+ilrmtMqU1k/Mkd+/ZIUyIkz4Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792942435;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=HTyf5ur55yLdYQwBYCrQ3stmUJEtzGPNmaBJHQGfwG8=;
	b=xKSFoTKj2/8I8aCTdP7lh0Ij1sr4W2ItRYlJNNSLMudpzLyCmRxykkswdXm0FcVwe2VR
	 ho4wSDVItyG+i3b0BG22uI4uFOTWQsiHQi/b+M7zGz0tusrzrk8GH5zYwFWiXmFFFxFuu
	 fo//DIeeFJEZgjqIOhCSAmNB7jS2X9A+jBhCfnrs2l+kJ8T/l505S81Kd8M6QQ/G9Hywn
	 LM5s3i+BQJDbwkDqqo44gf2TW5UeXOtBj+vF7zEYqMZC2unyF9qEYtUzKNaxUhBnQVOkN
	 mRDgsrjHhhqNq71TjOyzsGmNc+EgGVnvx9vF2uw0GqRXKIMQAC0NVBZjIqdJ1kkCOjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=kernelscan.io;
	spf=pass smtp.mailfrom=kernelscan.io;
	arc=none smtp.remote-ip=212.227.17.10
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA96B606A31B;
	Sun, 25 Oct 2026 15:33:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA96B606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kernelscan.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernelscan.io
Received: from client.hidden.invalid by mrelayeu.kundenserver.de (mreue107
 [213.165.67.113]) with ESMTPSA (Nemesis) id 1N5FMB-1wcM8d3DBV-00x1T0; Sun, 25
 Oct 2026 16:33:46 +0100
From: Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [PATCH v2 5.10.y 2/2] netfilter: nf_tables: unconditionally bump set->nelems before insertion
Date: Sun, 25 Oct 2026 16:32:24 +0100
Message-ID: <20261025153224.42044-3-steffen.pfendtner@kernelscan.io>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261025153224.42044-1-steffen.pfendtner@kernelscan.io>
References: <2026-10-24-1-daily-reply-0010-nft-set-nelems-5-10-bounce@kernel.org>
 <20261025153224.42044-1-steffen.pfendtner@kernelscan.io>
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
X-Provags-ID: V03:K1:qQFIMenGGhe3/GKGnIr0iGNuMDV5Ge21vxRWPjqDAjPRt6cddUz
 XGe5of+ikOR6JT3GTsW053ePgVbSrLHMmxWErx4MQ3UINjXD2caAYXx8IsNaazaA7eZypek
 JFlcvRXnvG+wdP34eghEqdKz1NaCfrSh70d9hE3SIGo2pm+0UNuZCAWdiddSFbKcCsq7OLP
 KWJT7dMFluEmGmlb2KeBA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:nTYehaS6e5U=;ShxQ4YMrOKUEHZNSAKKYP1g26bx
 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

From: Pablo Neira Ayuso <pablo@netfilter.org>

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
[ Backport to 5.10.y: applies on top of d4b7f29eb85c ("netfilter:
  nf_tables: always increment set element count"), as in 6.1.y. 5.10
  has neither the nft_set_maxsize() helper (8d738c1869f6) nor the
  NFT_SET_ELEM_CATCHALL element class, so the ceiling is the same
  expression the prerequisite inlines, set->size ? set->size +
  set->ndeact : UINT_MAX, and every element is counted. On the
  full-set path the element is left in the transaction and unwound by
  the abort path, which removes it, decrements nelems and frees it only
  after synchronize_rcu(), instead of the in-place set->ops->remove()
  this replaces. The update-path hunk from the upstream commit does not
  apply: 5.10 has no in-place element-update path here. ]
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
---
 net/netfilter/nf_tables_api.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9a0b5a574d9a..3bfcf0dec880 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5596,6 +5596,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_data_desc desc;
 	enum nft_registers dreg;
 	struct nft_trans *trans;
+	unsigned int max, nelems;
+	bool set_full = false;
 	u32 flags = 0;
 	u64 timeout;
 	u64 expiration;
@@ -5806,10 +5808,15 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		goto err_elem_expr;
 	expr = NULL;
 
+	max = set->size ? set->size + set->ndeact : UINT_MAX;
+	nelems = atomic_inc_return(&set->nelems);
+	if (nelems > max)
+		set_full = true;
+
 	trans = nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
 	if (trans == NULL) {
 		err = -ENOMEM;
-		goto err_elem_expr;
+		goto err_set_size;
 	}
 
 	ext->genmask = nft_genmask_cur(ctx->net);
@@ -5841,20 +5848,15 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		goto err_element_clash;
 	}
 
-	if (!atomic_add_unless(&set->nelems, 1,
-			       set->size ? set->size + set->ndeact : UINT_MAX)) {
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
+	atomic_dec(&set->nelems);
 err_elem_expr:
 	nf_tables_set_elem_destroy(ctx, set, elem.priv);
 err_parse_data:
-- 
2.39.5

