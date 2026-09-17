Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E0B4E9C23
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 17:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666637; cv=none; b=V/w5f47B/CwiG8B0/AzX9mo09uDrg9WeqTfxV/RVBRsoJoh/PZssNn3LLOIIUuOrcMq4voKb1iFA3yZmnCNRDKtit6G2+VzymZsYfpx6exdCGpNYlkDl7dbJG1TL7vAhyDHkH75ZkvUos8+I8CpjFU4bY+3N64mRUye7jnut/aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666637; c=relaxed/simple;
	bh=ptI6jvkODcWbZ/WjsDtnP5c7Ld/nwsDPHZUsDREHpK4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=W09rFzH7XwOGCHy4nGWE+7VmOJe7bHxY+toqQkWhP7p0dSHl0Cc75LAIYmR/MVcFDN+FJoLiwDKqeMczCLrBJKsToFU95GqUgeOmB+BMEF+gzpUn33KWS61vs/IQLmtURh2wVfTCK1sIi3EDrD9kHadePVBW6JwMxsN8fhr+LJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=k0JbDp2N; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="k0JbDp2N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=eQps0hDFZMP8vV+p6AWoUD2hYz6eB90rGjFOsiN+pSU=; b=k0JbDp2NkIvRae2mqIbZieBmQc
	lWch+Ywk2kslRP3+UiqQKmfpz51Gq3DJ/gYV5ACE+U4JWkVR/HiFOdutC/gakY2Z0ncxD329q8p6H
	0tD/SSxg5shjooNbZxmgtNodxe/EvMHR4XAbnRWlZ6YPxcT77Q15pAy5a24lYC9SERvqWVDZKRDeo
	KywzpVVg1a+aWgM6Dw4+JbpRucNVllmiDHdvlit5CMBQGXC8c3t444vCdfGWb3bbdR2CpGYMG/dbv
	xDUiFDxxC6rhQ68DzmD624JbCT0z4dDq7O7LeNEvCpOSIRvVkMaAV8ErNWhCpNRdqRnp5wsu3mBUd
	ZieyJwLw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1x7G2q-000000004lG-2kmC;
	Thu, 17 Sep 2026 19:37:12 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] Fix for warnings when compiling for 32bit arch
Date: Thu, 17 Sep 2026 19:37:07 +0200
Message-ID: <20260917173707.2080891-1-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This eliminates several, probably harmless warnings when e.g. compiling
with '-m32' for x86_64:

- Printing code assumes NFT_MAX_EXPR_LEN_BITS is unsigned long, when on
  32bit it is unsigned int - multiply by 1UL to force the implicit type

- Pointers are unsigned long, casting to uint64_t yields a warning on
  32bit due to the different size

- Bison tokens of type 'val' are uint64_t, print their values using
  PRIu64 macro

- On 32bit, UINT32_MAX is of type unsigned int - cast to off_t when
  comparing against state->indesc->line_offset to avoid different
  signedness warning

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/expression.h    | 2 +-
 src/netlink_linearize.c | 4 ++--
 src/parser_bison.y      | 2 +-
 src/scanner.l           | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index e6a05603552b5..b3ba4ad8d297e 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -11,7 +11,7 @@
 #include <json.h>
 #include <libnftnl/udata.h>
 
-#define NFT_MAX_EXPR_LEN_BYTES (NFT_REG32_COUNT * sizeof(uint32_t))
+#define NFT_MAX_EXPR_LEN_BYTES (1UL * NFT_REG32_COUNT * sizeof(uint32_t))
 #define NFT_MAX_EXPR_LEN_BITS  (NFT_MAX_EXPR_LEN_BYTES * BITS_PER_BYTE)
 #define NFT_MAX_EXPR_RECURSION 16
 
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index dfa841c6a407f..8de507059fe59 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -31,7 +31,7 @@ struct nft_expr_loc *nft_expr_loc_find(const struct nftnl_expr *nle,
 	struct nft_expr_loc *eloc;
 	uint32_t hash;
 
-	hash = (uint64_t)nle % NFT_EXPR_LOC_HSIZE;
+	hash = (unsigned long)nle % NFT_EXPR_LOC_HSIZE;
 	list_for_each_entry(eloc, &ctx->expr_loc_htable[hash], hlist) {
 		if (eloc->nle == nle)
 			return eloc;
@@ -50,7 +50,7 @@ static void nft_expr_loc_add(const struct nftnl_expr *nle,
 	eloc = xmalloc(sizeof(*eloc));
 	eloc->nle = nle;
 	eloc->loc = loc;
-	hash = (uint64_t)nle % NFT_EXPR_LOC_HSIZE;
+	hash = (unsigned long)nle % NFT_EXPR_LOC_HSIZE;
 	list_add_tail(&eloc->hlist, &ctx->expr_loc_htable[hash]);
 }
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 6e1c1cc205331..138dbfa3b70de 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -5887,7 +5887,7 @@ payload_expr		:	payload_raw_expr
 payload_raw_len		:	NUM
 			{
 				if ($1 > NFT_MAX_EXPR_LEN_BITS) {
-					erec_queue(error(&@1, "raw payload length %lu exceeds upper limit of %lu",
+					erec_queue(error(&@1, "raw payload length %" PRIu64 " exceeds upper limit of %lu",
 							 $1, NFT_MAX_EXPR_LEN_BITS),
 						 state->msgs);
 					YYERROR;
diff --git a/src/scanner.l b/src/scanner.l
index 61fcc4fa3bad3..37729ebc3cc55 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -91,7 +91,7 @@ static void update_offset(struct parser_state *state, struct location *loc,
 	uint32_t line_offset;
 
 	state->indesc->token_offset	+= len;
-	if (state->indesc->line_offset > UINT32_MAX)
+	if (state->indesc->line_offset > (off_t)UINT32_MAX)
 		line_offset = UINT32_MAX;
 	else
 		line_offset = state->indesc->line_offset;
-- 
2.54.0

