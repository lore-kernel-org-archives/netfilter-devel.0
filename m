Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BC43B5833
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2026 10:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773310289; cv=none; b=HgvIqhixkKr/AuWbtu0mnQGq6iLjPnCQzrQbHLNfX/7yqHdqhoZwamAKFEExBYnRghUkxpu+b5Eee5EuLmalcSTmsrJv/hNZH21g9B4t65CrAk7KCEWH2Y5xVuxcxpH6DlhId/yaS9eBeg79emvwudNScpXtQJWMGC8IwghFW1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773310289; c=relaxed/simple;
	bh=/Tgoj9CCDUEzhbjtK0oZnOUCY9I2ylC+2fRwtKSTBOY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ny3+pEOaeAyb5S77ZKB2rVkldFZBaCzk9U3y7Mx9Rl2aREeSGY8TwWlTHp2FTWGrIrl92GyaLln7aJYX4FPsp9/JRdg31pTc1zOF5ffe/SmrSaiRXD6tiNQ/OVeAprKL0HFBSrtuGi/P593P6JpIHeQYN8irlfpEdK00q/UDPPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gKj/akjb; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gKj/akjb"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2AAC760578;
	Thu, 12 Mar 2026 11:11:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773310284;
	bh=BlzPC14n0mbtNivL+mnXELw0+LI2N1961v1X8OfyByg=;
	h=From:To:Cc:Subject:Date:From;
	b=gKj/akjbiwexZPSZR5r/XMQzSnckdL/ez+RCHRJ6Pw+RpmXUZ24bCFaTq6RMSOsyi
	 7CZzqfXJ1ITJWHTENpeKMsVVrmq2/2SsnGLSeVVFC/kOOV62Rbt0UbiAW/efadJAB8
	 v81nwHpSNXHIyUY8fRv8POSGbUpsQLE5DUhVW+9zQ6Tbnk1SQArQH6bjvt23bPfdKH
	 13PasSFvEwGDVCaP5FDrizccdna2xeraedrCBdWm9uXF2Nt/GRyM+1QisGffHchRJm
	 44XL7V8Dax2hmlBlTunbfxNc188BF/Jte1uC2wQoAtk/yLj/2p/8Vl8G8nwSYScNgj
	 YGquX2wVj5S3Q==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf] nf_tables: nft_dynset: fix possible stateful expression memleak in error path
Date: Thu, 12 Mar 2026 11:11:20 +0100
Message-ID: <20260312101120.3512073-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

If cloning the second stateful expression in the element via GFP_ATOMIC
fails, then the first stateful expression remains in place without being
released.

   unreferenced object (percpu) 0x607b97e9cab8 (size 16):
     comm "softirq", pid 0, jiffies 4294931867
     hex dump (first 16 bytes on cpu 3):
       00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
     backtrace (crc 0):
       pcpu_alloc_noprof+0x453/0xd80
       nft_counter_clone+0x9c/0x190 [nf_tables]
       nft_expr_clone+0x8f/0x1b0 [nf_tables]
       nft_dynset_new+0x2cb/0x5f0 [nf_tables]
       nft_rhash_update+0x236/0x11c0 [nf_tables]
       nft_dynset_eval+0x11f/0x670 [nf_tables]
       nft_do_chain+0x253/0x1700 [nf_tables]
       nft_do_chain_ipv4+0x18d/0x270 [nf_tables]
       nf_hook_slow+0xaa/0x1e0
       ip_local_deliver+0x209/0x330

Pass NULL to nft_set_elem_expr_destroy() given stateful expressions do
not require context at this stage.

Fixes: 563125a73ac3 ("netfilter: nftables: generalize set extension to support for several expressions")
Reported-by: Gurpreet Shergill <giki.shergill@proton.me>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Compile-tested only at this stage.

 include/net/netfilter/nf_tables.h | 2 ++
 net/netfilter/nf_tables_api.c     | 4 ++--
 net/netfilter/nft_dynset.c        | 7 ++++++-
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index ea6f29ad7888..3c8a60ec1cc4 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -878,6 +878,8 @@ struct nft_elem_priv *nft_set_elem_init(const struct nft_set *set,
 					u64 timeout, u64 expiration, gfp_t gfp);
 int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
 			    struct nft_expr *expr_array[]);
+void nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
+			       struct nft_set_elem_expr *elem_expr);
 void nft_set_elem_destroy(const struct nft_set *set,
 			  const struct nft_elem_priv *elem_priv,
 			  bool destroy_expr);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 15801a9a099e..2f19c155069e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6747,8 +6747,8 @@ static void __nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
 	}
 }
 
-static void nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
-				      struct nft_set_elem_expr *elem_expr)
+void nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
+			       struct nft_set_elem_expr *elem_expr)
 {
 	struct nft_expr *expr;
 	u32 size;
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 7807d8129664..31c5a5b52ce1 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -36,12 +36,17 @@ static int nft_dynset_expr_setup(const struct nft_dynset *priv,
 	for (i = 0; i < priv->num_exprs; i++) {
 		expr = nft_setelem_expr_at(elem_expr, elem_expr->size);
 		if (nft_expr_clone(expr, priv->expr_array[i], GFP_ATOMIC) < 0)
-			return -1;
+			goto err_out;
 
 		elem_expr->size += priv->expr_array[i]->ops->size;
 	}
 
 	return 0;
+err_out:
+	/* Stateful expression do not need context, pass NULL. */
+	nft_set_elem_expr_destroy(NULL, elem_expr);
+
+	return -1;
 }
 
 struct nft_elem_priv *nft_dynset_new(struct nft_set *set,
-- 
2.47.3

