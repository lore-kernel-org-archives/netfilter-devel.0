Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A369537B00F;
	Wed,  4 Mar 2026 17:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772645394; cv=none; b=TEwKfjoB1brtiIZrAivq/Gb6+Fb8AGEAlzWwN2S1YVQz8+3dgD9bQvdZre66REp7pmEP4WJpO2Xy9aYl0pib49IM7O2A1VmH95yqK0rLophFBUHl8/mk7wZjUpU8FR0PZWiHbxdEM3Xeb5wO0BzcRLfZmr4Y6mPOsVwTdagF/F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772645394; c=relaxed/simple;
	bh=FyvW/LxF1YTHFjloFRD3V/I+Tubn5lyqQ8Zz6ROSsZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMJut9swXrTeCqXN3ns74JsnmQ9ZZ7EBiOXGgNwoqBzQ97z0e1plw6LDmgVjjt3vP1qbVQ4ako2eBiorUhMDX5PdYILJA7qvb0z1glw4swNSeb7kd5LifBh8PGhuJ/YSgJSyKtvcUzrgwZITLWQa8m2GUIa9YkaCYXibI+ttr8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 21995602AB; Wed, 04 Mar 2026 18:29:52 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 2/4] netfilter: nf_tables: unconditionally bump set->nelems before insertion
Date: Wed,  4 Mar 2026 18:29:38 +0100
Message-ID: <20260304172940.24948-3-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260304172940.24948-1-fw@strlen.de>
References: <20260304172940.24948-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

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
---
 net/netfilter/nf_tables_api.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index fd7f7e4e2a43..df67932d3e09 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7170,6 +7170,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_data_desc desc;
 	enum nft_registers dreg;
 	struct nft_trans *trans;
+	bool set_full = false;
 	u64 expiration;
 	u64 timeout;
 	int err, i;
@@ -7461,10 +7462,18 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (err < 0)
 		goto err_elem_free;
 
+	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
+		unsigned int max = nft_set_maxsize(set), nelems;
+
+		nelems = atomic_inc_return(&set->nelems);
+		if (nelems > max)
+			set_full = true;
+	}
+
 	trans = nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
 	if (trans == NULL) {
 		err = -ENOMEM;
-		goto err_elem_free;
+		goto err_set_size;
 	}
 
 	ext->genmask = nft_genmask_cur(ctx->net);
@@ -7516,7 +7525,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 
 						ue->priv = elem_priv;
 						nft_trans_commit_list_add_elem(ctx->net, trans);
-						goto err_elem_free;
+						goto err_set_size;
 					}
 				}
 			}
@@ -7534,23 +7543,16 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		goto err_element_clash;
 	}
 
-	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
-		unsigned int max = nft_set_maxsize(set);
-
-		if (!atomic_add_unless(&set->nelems, 1, max)) {
-			err = -ENFILE;
-			goto err_set_full;
-		}
-	}
-
 	nft_trans_container_elem(trans)->elems[0].priv = elem.priv;
 	nft_trans_commit_list_add_elem(ctx->net, trans);
-	return 0;
 
-err_set_full:
-	nft_setelem_remove(ctx->net, set, elem.priv);
+	return set_full ? -ENFILE : 0;
+
 err_element_clash:
 	kfree(trans);
+err_set_size:
+	if (!(flags & NFT_SET_ELEM_CATCHALL))
+		atomic_dec(&set->nelems);
 err_elem_free:
 	nf_tables_set_elem_destroy(ctx, set, elem.priv);
 err_parse_data:
-- 
2.52.0

