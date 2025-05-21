Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C750B26983B
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 13:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747833178; cv=none; b=fa69OMM8mXbeOOba6Icnh1GjMqxLPckLfMyjF0epWIcPBMF0mAVMwZNOx/MpRfFPk7OUFXS945dGTmIplAJlZHI9/aYEcYNJihOhDAJctgeRO9s+hQsRQAUKIU2bZuLBgzFWBS9NMyzAg8o0uU6HkTLPqx9yl8D/CDYWAtN1bLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747833178; c=relaxed/simple;
	bh=PES2UDvouxmX/8vyXGzvX2oZCSjPnrRBMlMJtg80dSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FqG0IaiUn9NSqZo5Vn5nWR+lP71e7sZJ8I1TPfo3rjDqImWQ1TH+ei4xnTWHMExbR/SaLVEAy0XshY11jAEgy7wXyF6YwhmM5d5AAnjjuttE2V86QyD4doVj3eItq6LGIpBi29TFB3ctnRXkjYXECMwOQdJYuasZ+YanYqLd91A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=dxdMbkmY; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="dxdMbkmY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=VtHjXfQmLkVcnMJasYDxPOsM5S9mt3LCXTAgj7jxW0M=; b=dxdMbkmYlKxyGKW4Ffzttq9H7N
	HkLUwa9VMA61Tk3gLRVNh0SA8kGPXDwI+Ps2r6lc0v2dBXMrxt/TT56snHIVzKLZzuiP6iX3RULJb
	mU4LOEoK48qF16mV4e/jDroCsvDQ7k8cLdy2XpzDQ/yt5RoQW2EHtwh8DsWr3QOO/haZ+u9HUNef/
	sTJGEED0bTTxUZgfsVn9KIGERJIG3Tz1662LWXJRNayCarMh5Yr3kn4M/t1W/ZqDitAuiE+fNwGaJ
	lVHGLuzzBi/E7YYjoWLq4kOXNnB1UvE/evV/h7T3t0tj/WNrJs/ht7C7HQZ1rSnOKc9TSXCI1tI+C
	M3FA8x4A==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uHjFY-0000000083e-1w71;
	Wed, 21 May 2025 15:12:48 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/4] netlink_delinearize: Replace some BUG()s by error messages
Date: Wed, 21 May 2025 15:12:39 +0200
Message-ID: <20250521131242.2330-2-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250521131242.2330-1-phil@nwl.cc>
References: <20250521131242.2330-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Netlink parser tries to keep going despite errors. Faced with an
incompatible ruleset, this is much more user-friendly than exiting the
program upon the first obstacle. This patch fixes three more spots to
support this.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/netlink_delinearize.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index f7c10fb5af316..79bef0bb299ab 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -605,7 +605,8 @@ static void netlink_parse_bitwise(struct netlink_parse_ctx *ctx,
 						   sreg, left);
 		break;
 	default:
-		BUG("invalid bitwise operation %u\n", op);
+		return netlink_error(ctx, loc,
+				     "Invalid bitwise operation %u", op);
 	}
 
 	dreg = netlink_parse_register(nle, NFTNL_EXPR_BITWISE_DREG);
@@ -616,6 +617,7 @@ static void netlink_parse_byteorder(struct netlink_parse_ctx *ctx,
 				    const struct location *loc,
 				    const struct nftnl_expr *nle)
 {
+	uint32_t opval = nftnl_expr_get_u32(nle, NFTNL_EXPR_BYTEORDER_OP);
 	enum nft_registers sreg, dreg;
 	struct expr *expr, *arg;
 	enum ops op;
@@ -627,7 +629,7 @@ static void netlink_parse_byteorder(struct netlink_parse_ctx *ctx,
 				     "Byteorder expression has no left "
 				     "hand side");
 
-	switch (nftnl_expr_get_u32(nle, NFTNL_EXPR_BYTEORDER_OP)) {
+	switch (opval) {
 	case NFT_BYTEORDER_NTOH:
 		op = OP_NTOH;
 		break;
@@ -635,8 +637,9 @@ static void netlink_parse_byteorder(struct netlink_parse_ctx *ctx,
 		op = OP_HTON;
 		break;
 	default:
-		BUG("invalid byteorder operation %u\n",
-		    nftnl_expr_get_u32(nle, NFTNL_EXPR_BYTEORDER_OP));
+		expr_free(arg);
+		return netlink_error(ctx, loc,
+				     "Invalid byteorder operation %u\n", opval);
 	}
 
 	expr = unary_expr_alloc(loc, op, arg);
@@ -733,8 +736,10 @@ static void netlink_parse_inner(struct netlink_parse_ctx *ctx,
 		expr->meta.inner_desc = inner_desc;
 		break;
 	default:
-		assert(0);
-		break;
+		netlink_error(ctx, loc, "Unsupported inner expression type %s",
+			      expr_ops(expr)->name);
+		expr_free(expr);
+		return;
 	}
 
 	netlink_set_register(ctx, ctx->inner_reg, expr);
-- 
2.49.0

