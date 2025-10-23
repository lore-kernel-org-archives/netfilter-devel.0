Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A64288510
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761236070; cv=none; b=tzCzir9ri71xhVgLLqYMtl8TlhWoIz62qKvwAYmPOvVe59JzLNmDv7RX3poYb//1P079LlSxmLueh5Y3iMdklgL0Q6IAXsVdTtISMg+A3VOtfCdXf1kD8MzkPz2+5XNhktvt/1qZHeHC2kmExfuRlV3T12u4EU/ah1+MgaRicfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761236070; c=relaxed/simple;
	bh=DBdu2LM+jec27vqvoVYkTOHiZAG+JwXevOdat1LbqNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ON4RZcBi3XpYhvfcl1KwqkB1pHGlQI9u2A0myz41RaoDQOMidzqcbvbgelVaj6gN409Fi1WNKxnasWVwzedDS89U/3dPey2pXoDI+DBtE3hQcJ/62S0ICrW8YxNnYB8RSzbfnh3aEDY767x90pbALjzH+YrRDnQwx3V1OsvfSNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=gvMg5u87; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="gvMg5u87"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+EKbEmPKhbF183S1NHg/16+VcTQqopvBSX3DG/lsKGo=; b=gvMg5u87HkVGX6F8wDG99UP6Zy
	lF5Emyo1OXAU7U2PuaXeSQ/5tQEfst0+kpmapc3DpJHOLBRU1v97xZPwPJB/RN34OosAnjkYp4bDc
	GxHaHchrWNnrPwbAhptvsHubYmh8+8ARKEzg1XulTQ88VJjwznob968gW/lGqRtehgE5sfsl9gZFt
	9wFEvJvJH8axfHWbzlFvA8VSPPNMY4CEp4DUH2wEvbYfkVRLrNPDAodqS3sSv3tipGY4JBLDUZDDB
	mB+HTaf2oRb/zIZDBnGCZUUYCK97gBfBJVPk1zBuLU7zlQ4F/nxc8uSSUMZ4Zh/lRYg6r3a6YuEmj
	IRcqcwlA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxxK-0000000005B-379J;
	Thu, 23 Oct 2025 18:14:27 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 21/28] netlink: Make use of nftnl_{expr,set_elem}_set_imm()
Date: Thu, 23 Oct 2025 18:14:10 +0200
Message-ID: <20251023161417.13228-22-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251023161417.13228-1-phil@nwl.cc>
References: <20251023161417.13228-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pass the previously collected byteorder (and sizes) to libnftnl for
improved netlink debug output.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/netlink.c           | 18 ++++++++++++------
 src/netlink_linearize.c | 34 ++++++++++++++++++++++------------
 2 files changed, 34 insertions(+), 18 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 9d6cc31e40fb5..68228bdc5c99a 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -139,17 +139,22 @@ struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 			netlink_gen_key(key, &nld);
 			key->flags &= ~EXPR_F_INTERVAL;
 
-			nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_KEY, nld.value, nld.len);
+			nftnl_set_elem_set_imm(nlse, NFTNL_SET_ELEM_KEY,
+					       nld.value, nld.len,
+					       nld.byteorder, nld.sizes);
 
 			key->flags |= EXPR_F_INTERVAL_END;
 			netlink_gen_key(key, &nld);
 			key->flags &= ~EXPR_F_INTERVAL_END;
 
-			nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_KEY_END,
-					   nld.value, nld.len);
+			nftnl_set_elem_set_imm(nlse, NFTNL_SET_ELEM_KEY_END,
+					       nld.value, nld.len,
+					       nld.byteorder, nld.sizes);
 		} else {
 			netlink_gen_key(key, &nld);
-			nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_KEY, nld.value, nld.len);
+			nftnl_set_elem_set_imm(nlse, NFTNL_SET_ELEM_KEY,
+					       nld.value, nld.len,
+					       nld.byteorder, nld.sizes);
 		}
 		break;
 	}
@@ -217,8 +222,9 @@ struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 		case EXPR_RANGE:
 		case EXPR_RANGE_VALUE:
 		case EXPR_PREFIX:
-			nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_DATA,
-					   nld.value, nld.len);
+			nftnl_set_elem_set_imm(nlse, NFTNL_SET_ELEM_DATA,
+					       nld.value, nld.len,
+					       nld.byteorder, nld.sizes);
 			break;
 		default:
 			BUG("unexpected set element expression\n");
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 43cfbfa75f3d2..36a539bf96283 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -482,8 +482,10 @@ static struct expr *netlink_gen_prefix(struct netlink_linearize_ctx *ctx,
 	netlink_put_register(nle, NFTNL_EXPR_BITWISE_SREG, sreg);
 	netlink_put_register(nle, NFTNL_EXPR_BITWISE_DREG, sreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_LEN, nld.len);
-	nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_MASK, nld.value, nld.len);
-	nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_XOR, zero.value, zero.len);
+	nftnl_expr_set_imm(nle, NFTNL_EXPR_BITWISE_MASK,
+			   nld.value, nld.len, nld.byteorder);
+	nftnl_expr_set_imm(nle, NFTNL_EXPR_BITWISE_XOR,
+			   zero.value, zero.len, zero.byteorder);
 	nft_rule_add_expr(ctx, nle, &expr->location);
 
 	return expr->right->prefix;
@@ -551,15 +553,18 @@ static void netlink_gen_flagcmp(struct netlink_linearize_ctx *ctx,
 		nle = alloc_nft_expr("cmp");
 		netlink_put_register(nle, NFTNL_EXPR_CMP_SREG, sreg);
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_CMP_OP, NFT_CMP_EQ);
-		nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld2.value, nld2.len);
+		nftnl_expr_set_imm(nle, NFTNL_EXPR_CMP_DATA,
+				   nld2.value, nld2.len, nld2.byteorder);
 		nft_rule_add_expr(ctx, nle, &expr->location);
 	} else {
 		nle = alloc_nft_expr("bitwise");
 		netlink_put_register(nle, NFTNL_EXPR_BITWISE_SREG, sreg);
 		netlink_put_register(nle, NFTNL_EXPR_BITWISE_DREG, sreg);
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_LEN, len);
-		nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_MASK, nld2.value, nld2.len);
-		nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_XOR, nld.value, nld.len);
+		nftnl_expr_set_imm(nle, NFTNL_EXPR_BITWISE_MASK,
+				   nld2.value, nld2.len, nld2.byteorder);
+		nftnl_expr_set_imm(nle, NFTNL_EXPR_BITWISE_XOR,
+				   nld.value, nld.len, nld.byteorder);
 		nft_rule_add_expr(ctx, nle, &expr->location);
 
 		nle = alloc_nft_expr("cmp");
@@ -569,7 +574,8 @@ static void netlink_gen_flagcmp(struct netlink_linearize_ctx *ctx,
 		else
 			nftnl_expr_set_u32(nle, NFTNL_EXPR_CMP_OP, NFT_CMP_NEQ);
 
-		nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld.value, nld.len);
+		nftnl_expr_set_imm(nle, NFTNL_EXPR_CMP_DATA,
+				   nld.value, nld.len, nld.byteorder);
 		nft_rule_add_expr(ctx, nle, &expr->location);
 	}
 
@@ -645,7 +651,8 @@ static void netlink_gen_relational(struct netlink_linearize_ctx *ctx,
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_CMP_OP,
 			   netlink_gen_cmp_op(expr->op));
 	netlink_gen_data(right, &nld);
-	nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld.value, len);
+	nftnl_expr_set_imm(nle, NFTNL_EXPR_CMP_DATA,
+			   nld.value, len, nld.byteorder);
 	release_register(ctx, expr->left);
 
 	nft_rule_add_expr(ctx, nle, &expr->location);
@@ -681,8 +688,8 @@ static void netlink_gen_bitwise_shift(struct netlink_linearize_ctx *ctx,
 	netlink_gen_raw_data(expr->right->value, expr->right->byteorder,
 			     sizeof(uint32_t), &nld);
 
-	nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_DATA, nld.value,
-		       nld.len);
+	nftnl_expr_set_imm(nle, NFTNL_EXPR_BITWISE_DATA,
+			   nld.value, nld.len, nld.byteorder);
 
 	nft_rule_add_expr(ctx, nle, &expr->location);
 }
@@ -747,9 +754,11 @@ static void netlink_gen_bitwise_mask_xor(struct netlink_linearize_ctx *ctx,
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_LEN, len);
 
 	netlink_gen_raw_data(mask, expr->byteorder, len, &nld);
-	nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_MASK, nld.value, nld.len);
+	nftnl_expr_set_imm(nle, NFTNL_EXPR_BITWISE_MASK,
+			   nld.value, nld.len, nld.byteorder);
 	netlink_gen_raw_data(xor, expr->byteorder, len, &nld);
-	nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_XOR, nld.value, nld.len);
+	nftnl_expr_set_imm(nle, NFTNL_EXPR_BITWISE_XOR,
+			   nld.value, nld.len, nld.byteorder);
 
 	mpz_clear(tmp);
 	mpz_clear(val);
@@ -871,7 +880,8 @@ static void netlink_gen_immediate(struct netlink_linearize_ctx *ctx,
 	netlink_gen_data(expr, &nld);
 	switch (expr->etype) {
 	case EXPR_VALUE:
-		nftnl_expr_set(nle, NFTNL_EXPR_IMM_DATA, nld.value, nld.len);
+		nftnl_expr_set_imm(nle, NFTNL_EXPR_IMM_DATA,
+				   nld.value, nld.len, nld.byteorder);
 		break;
 	case EXPR_VERDICT:
 		if (expr->chain) {
-- 
2.51.0

