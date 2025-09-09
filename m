Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5C811187
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Sep 2025 20:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757451008; cv=none; b=S3eP3q1ejkbtVMJXXEduSkeSbyXvtVok4n0vwL80IEdIkMddoHSM4nh0WlorgXdHhj/813AfaExTBdVRkW2vfXlhI+l5TWLpi8+3My/ovN1fpnCLZ0vnNOb1tkFszKvXayGSXdGkZIQybb3fc1XMDtA3WWUMvZWAi7fa3LyowQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757451008; c=relaxed/simple;
	bh=k8rRJ9lkU3Y+U8vxPIPrBEEKq1rsOQHaISlFu+BCx8E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QEOVrQRAYPUNgzKIYignjb9DYAX73WdQcGdabevOLsFavkUWVvWhM4f7z9STmP308jmlQJmXb8Nd1eVMCKUYYTWByEq4MPcDrav/Vpuf9E+Ez9MFPW/eWidCta4ZdJOPff6u8iv4dvioUlz7Sfv+piwbfAt2XXN73NX2AetrfsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=CcpFWJig; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="CcpFWJig"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=URk0JXQqr7D95X38s2G8TED8f4mzUADAfDKauMo0q8c=; b=CcpFWJig8SB5LwjMZrc6VbupEe
	QTvTeTOQRmaBkTmFp/DFviGYjwXsSD8BqSYeGqplmnOoAYdupNI9BpmCs3DRNQQceZ4kH2LtaA29Z
	+tSC3hMGh7ACpww9maNxQ0kX0MhBARH2x7aZBYBUnSAmgGUk+19s3lxxZOlyFGsmDkjI2YCFe7wvU
	HQsO1glxi0zsEXP+x/0lewaPg0kapzIJvV02rZhLJGGQHYaiim68Rai70RFk65k44/vNsdlB4zg4A
	dS6n/6ozaN3LAE2c1JDu3tIvmFsxUZ0/281du/GYlNVw+fcMf9zTx1wwpbYF+msYQmbMP0tygKRAA
	jDpX2ldQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uw5Hs-000000002HV-39Fr;
	Tue, 09 Sep 2025 22:50:02 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Yi Chen <yiche@redhat.com>
Subject: [nft PATCH] fib: Fix for existence check on Big Endian
Date: Tue,  9 Sep 2025 22:49:48 +0200
Message-ID: <20250909204948.17757-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Adjust the expression size to 1B so cmp expression value is correct.
Without this, the rule 'fib saddr . iif check exists' generates
following byte code on BE:

|  [ fib saddr . iif oif present => reg 1 ]
|  [ cmp eq reg 1 0x00000001 ]

Though with NFTA_FIB_F_PRESENT flag set, nft_fib.ko writes to the first
byte of reg 1 only (using nft_reg_store8()). With this patch in place,
byte code is correct:

|  [ fib saddr . iif oif present => reg 1 ]
|  [ cmp eq reg 1 0x01000000 ]

Fixes: f686a17eafa0b ("fib: Support existence check")
Cc: Yi Chen <yiche@redhat.com>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/evaluate.c | 1 +
 src/fib.c      | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 8cecbe09de01c..6a1aa4963bceb 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3002,6 +3002,7 @@ static int expr_evaluate_fib(struct eval_ctx *ctx, struct expr **exprp)
 	if (expr->flags & EXPR_F_BOOLEAN) {
 		expr->fib.flags |= NFTA_FIB_F_PRESENT;
 		datatype_set(expr, &boolean_type);
+		expr->len = BITS_PER_BYTE;
 	}
 	return expr_evaluate_primary(ctx, exprp);
 }
diff --git a/src/fib.c b/src/fib.c
index 5383613292a5e..4db7cd2bbc9c3 100644
--- a/src/fib.c
+++ b/src/fib.c
@@ -198,8 +198,10 @@ struct expr *fib_expr_alloc(const struct location *loc,
 		BUG("Unknown result %d\n", result);
 	}
 
-	if (flags & NFTA_FIB_F_PRESENT)
+	if (flags & NFTA_FIB_F_PRESENT) {
 		type = &boolean_type;
+		len = BITS_PER_BYTE;
+	}
 
 	expr = expr_alloc(loc, EXPR_FIB, type,
 			  BYTEORDER_HOST_ENDIAN, len);
-- 
2.51.0

