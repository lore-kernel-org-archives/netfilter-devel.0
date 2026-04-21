Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A684533E379
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Apr 2026 18:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776795426; cv=none; b=AfO5GQ9qzs5GRaP/nNurj+DhqEWKNaobuQZKH3BcPB66Bi+39gxcEGZ8BzQchyw8SkBYQ5Os5JZXTlri/240B+IetY09nwZXVJfr8ul7MZ5jfB5N8Gb5FVsGVcgKJt2+DUVmvUfb2UzOXrH0rtslOl6XXWDXCBEeZ1mCIWtPOVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776795426; c=relaxed/simple;
	bh=UUZ1A2Rr5bxBz8+HAj328MyQlWHLHDmlTx+8U8fOou4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=dlHD4ZDBJLgniW9FnTmO1LD9H9Cp3SzcXblnWmqL7NW8J8B65hDIqVa0Et8fgm3YRukU1yd2miNQgJgQU8AbA5O0+LXHOj3hSl90rOVGFQLWwOldGDglLTb1geZr7KwSkinf0tS+JLtIZ2+g8LsvZHDfLVr3tTgctsCd9bso730=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=aZ3uxCNe; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="aZ3uxCNe"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9FFC660177
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Apr 2026 20:16:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776795415;
	bh=cIDHkEVVoe3LWJ/8WDCM31uPvOr5kBPwQXXT8IFZ2tA=;
	h=From:To:Subject:Date:From;
	b=aZ3uxCNeTXzkFzxKVZEmpPXB2kEInUFoFmglaoZOHqF+/iNVXxUVKg15dWrxx0M4U
	 ZA4e2qqaG1LfzXMbhIXK70EuezOHZiNaK17XEhZqJcCowKqGflVf1bBc7kWzl98Dv8
	 0hW3oXYP9loY3gB0vklsp33J/mItxNPTt0ADVqoe79Wu1+rifXHKiksp/o9iQ5VR+X
	 6FRBSijV0ppyp7m1Bwt3t3O8ieigUDRKZslxNXnUrJiRQXECzg5nU3LWXBNpBEY7r1
	 4IjmPjvWZuzXDn7XpFYZnULgWogEddl48StZv/aqyQaFkSMq/Fy5UGUgIBgn+Qax44
	 9U4qMCrDfrNTQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf 1/3] netfilter: replace skb_try_make_writable() by skb_ensure_writable()
Date: Tue, 21 Apr 2026 20:16:50 +0200
Message-ID: <20260421181652.161719-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

skb_try_make_writable() only works on clones and uncloned packets might
have their network header in paged fragments.

Fixes: d32de98ea70f ("netfilter: nft_fwd_netdev: allow to forward packets via neighbour layer")
Fixes: 7d2086871762 ("netfilter: nf_flow_table: move ipv4 offload hook code to nf_flow_table")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 2 +-
 net/netfilter/nft_fwd_netdev.c   | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index fd56d663cb5b..39b537fa6e51 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -524,7 +524,7 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 		return 0;
 	}
 
-	if (skb_try_make_writable(skb, thoff + ctx->hdrsize))
+	if (skb_ensure_writable(skb, thoff + ctx->hdrsize))
 		return -1;
 
 	flow_offload_refresh(flow_table, flow, false);
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 4bce36c3a6a0..0bc0cf194849 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -111,7 +111,7 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 			verdict = NFT_BREAK;
 			goto out;
 		}
-		if (skb_try_make_writable(skb, sizeof(*iph))) {
+		if (skb_ensure_writable(skb, sizeof(*iph))) {
 			verdict = NF_DROP;
 			goto out;
 		}
@@ -132,7 +132,7 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 			verdict = NFT_BREAK;
 			goto out;
 		}
-		if (skb_try_make_writable(skb, sizeof(*ip6h))) {
+		if (skb_ensure_writable(skb, sizeof(*ip6h))) {
 			verdict = NF_DROP;
 			goto out;
 		}
-- 
2.47.3

