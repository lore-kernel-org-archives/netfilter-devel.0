Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62DAD1FA27E
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Nov 2024 13:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732713024; cv=none; b=OzlEsyOpcA+X1EgtfRnoQuRIV9XHw9RJ7JFz2a6HBgqD5MBWL7fnCbZ6UvL+RFtyc0ff4WwOnQPu/EK4ez9d1yyzkksZVMiOTmwuXUTZc4niHYNsG6ZVulotWALd3oY73/O7pnvBa9bWfVAfQM6oHn2PkrOk6+7US4vGXCO1V00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732713024; c=relaxed/simple;
	bh=7c4m6ve+h/t3zY6ly5W1AqG83XUllwgsT1BNFJf3yFo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oyDUf/3WTa7pfP595oplgWCAH987/EI10aJ4AAW47Zu4hN53DFFb5KqCehZjoWeM3w8fjzuUDuIrkq9/i6kBHl351ppruRtR/JQz3B1EQF+De/cknsPVjPcXJmNtRuO/1eBQmL0x2z+ICIJndDnzE+a/4QmBNGoFBzmlFGOzRgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf] netfilter: nft_inner: incorrect percpu area handling under softirq
Date: Wed, 27 Nov 2024 14:10:06 +0100
Message-Id: <20241127131007.353182-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Softirq can interrupt packet from process context which walks over the
percpu area.

Add routines to disable bh while restoring and saving the tunnel parser
context from percpu area to stack. Add a skbuff owner for this percpu
area to catch softirq interference to exercise the packet tunnel parser
again in such case.

Reported-by: syzbot+84d0441b9860f0d63285@syzkaller.appspotmail.com
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables_core.h |  1 +
 net/netfilter/nft_inner.c              | 56 ++++++++++++++++++++------
 2 files changed, 45 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index ff27cb2e1662..98e2bf648c63 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -161,6 +161,7 @@ enum {
 };
 
 struct nft_inner_tun_ctx {
+	struct sk_buff *skb;
 	u16	type;
 	u16	inner_tunoff;
 	u16	inner_lloff;
diff --git a/net/netfilter/nft_inner.c b/net/netfilter/nft_inner.c
index 928312d01eb1..fcaa126ac8da 100644
--- a/net/netfilter/nft_inner.c
+++ b/net/netfilter/nft_inner.c
@@ -210,35 +210,65 @@ static int nft_inner_parse(const struct nft_inner *priv,
 			   struct nft_pktinfo *pkt,
 			   struct nft_inner_tun_ctx *tun_ctx)
 {
-	struct nft_inner_tun_ctx ctx = {};
 	u32 off = pkt->inneroff;
 
 	if (priv->flags & NFT_INNER_HDRSIZE &&
-	    nft_inner_parse_tunhdr(priv, pkt, &ctx, &off) < 0)
+	    nft_inner_parse_tunhdr(priv, pkt, tun_ctx, &off) < 0)
 		return -1;
 
 	if (priv->flags & (NFT_INNER_LL | NFT_INNER_NH)) {
-		if (nft_inner_parse_l2l3(priv, pkt, &ctx, off) < 0)
+		if (nft_inner_parse_l2l3(priv, pkt, tun_ctx, off) < 0)
 			return -1;
 	} else if (priv->flags & NFT_INNER_TH) {
-		ctx.inner_thoff = off;
-		ctx.flags |= NFT_PAYLOAD_CTX_INNER_TH;
+		tun_ctx->inner_thoff = off;
+		tun_ctx->flags |= NFT_PAYLOAD_CTX_INNER_TH;
 	}
 
-	*tun_ctx = ctx;
 	tun_ctx->type = priv->type;
+	tun_ctx->skb = pkt->skb;
 	pkt->flags |= NFT_PKTINFO_INNER_FULL;
 
 	return 0;
 }
 
+static bool nft_inner_restore_tun_ctx(const struct nft_pktinfo *pkt,
+				      struct nft_inner_tun_ctx *tun_ctx)
+{
+	struct nft_inner_tun_ctx *this_cpu_tun_ctx;
+
+	local_bh_disable();
+	this_cpu_tun_ctx = this_cpu_ptr(&nft_pcpu_tun_ctx);
+	if (this_cpu_tun_ctx->skb != pkt->skb) {
+		local_bh_enable();
+		return false;
+	}
+	*tun_ctx = *this_cpu_tun_ctx;
+	local_bh_enable();
+
+	return true;
+}
+
+static void nft_inner_save_tun_ctx(const struct nft_pktinfo *pkt,
+				   const struct nft_inner_tun_ctx *tun_ctx)
+{
+	struct nft_inner_tun_ctx *this_cpu_tun_ctx;
+
+	local_bh_disable();
+	this_cpu_tun_ctx = this_cpu_ptr(&nft_pcpu_tun_ctx);
+	*this_cpu_tun_ctx = *tun_ctx;
+	local_bh_enable();
+}
+
 static bool nft_inner_parse_needed(const struct nft_inner *priv,
 				   const struct nft_pktinfo *pkt,
-				   const struct nft_inner_tun_ctx *tun_ctx)
+				   struct nft_inner_tun_ctx *tun_ctx)
 {
 	if (!(pkt->flags & NFT_PKTINFO_INNER_FULL))
 		return true;
 
+	if (!nft_inner_restore_tun_ctx(pkt, tun_ctx))
+		return true;
+
 	if (priv->type != tun_ctx->type)
 		return true;
 
@@ -248,27 +278,29 @@ static bool nft_inner_parse_needed(const struct nft_inner *priv,
 static void nft_inner_eval(const struct nft_expr *expr, struct nft_regs *regs,
 			   const struct nft_pktinfo *pkt)
 {
-	struct nft_inner_tun_ctx *tun_ctx = this_cpu_ptr(&nft_pcpu_tun_ctx);
 	const struct nft_inner *priv = nft_expr_priv(expr);
+	struct nft_inner_tun_ctx tun_ctx = {};
 
 	if (nft_payload_inner_offset(pkt) < 0)
 		goto err;
 
-	if (nft_inner_parse_needed(priv, pkt, tun_ctx) &&
-	    nft_inner_parse(priv, (struct nft_pktinfo *)pkt, tun_ctx) < 0)
+	if (nft_inner_parse_needed(priv, pkt, &tun_ctx) &&
+	    nft_inner_parse(priv, (struct nft_pktinfo *)pkt, &tun_ctx) < 0)
 		goto err;
 
 	switch (priv->expr_type) {
 	case NFT_INNER_EXPR_PAYLOAD:
-		nft_payload_inner_eval((struct nft_expr *)&priv->expr, regs, pkt, tun_ctx);
+		nft_payload_inner_eval((struct nft_expr *)&priv->expr, regs, pkt, &tun_ctx);
 		break;
 	case NFT_INNER_EXPR_META:
-		nft_meta_inner_eval((struct nft_expr *)&priv->expr, regs, pkt, tun_ctx);
+		nft_meta_inner_eval((struct nft_expr *)&priv->expr, regs, pkt, &tun_ctx);
 		break;
 	default:
 		WARN_ON_ONCE(1);
 		goto err;
 	}
+	nft_inner_save_tun_ctx(pkt, &tun_ctx);
+
 	return;
 err:
 	regs->verdict.code = NFT_BREAK;
-- 
2.30.2

