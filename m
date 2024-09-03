Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB6031B12F6
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Sep 2024 12:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725365963; cv=none; b=kgix+iz57bTm29fBAF80KLKmkKoyWFrqDoMYaPS8EkC3suQSNPIlz9fBgculECR3lMDlHeCghDB8t/1EbHznVUKRJZvLvrb4YUEbbFfmz733X42YEhtoknD7qtv76cQ8MLEfs3OGYm/F0/85ruUVLMZnnGMHMjbM5/sg5FVhS8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725365963; c=relaxed/simple;
	bh=2p7rx6HJBgt+jUF/+pQs/s50zPYMRrt0jpGbPShRN44=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=AQgzR8CRjfcdGNjdOMzHLkbnKehvQgEj3mbHNRfxD3LIo6cFpuoqdebUi2xToUHJKBHzVrDSydkfuMDmD5Wja+gMgvaPa9qlFZEWFAF0TXsR+hQUOzjuqzwHqtPJLs+3tWiAOdEFUT1Eia6jLTKHYduNgu9wy8f+mOWevwlGrj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] libnftables: set variable array to NULL after release
Date: Tue,  3 Sep 2024 14:19:10 +0200
Message-Id: <20240903121910.305004-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

User reports that:

1. Call nft_ctx_clear_vars();
2. Call nft_ctx_free().

because nft_ctx_clear_vars() is called from nft_ctx_free().

results in double free, set ctx->vars to NULL from nft_ctx_clear_vars().

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1772
Fixes: 4e8dff2cb4da ("src: expose nft_ctx_clear_vars as API")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/libnftables.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/libnftables.c b/src/libnftables.c
index 7fc81515258d..2ae215013cb0 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -160,6 +160,7 @@ void nft_ctx_clear_vars(struct nft_ctx *ctx)
 	}
 	ctx->num_vars = 0;
 	free(ctx->vars);
+	ctx->vars = NULL;
 }
 
 EXPORT_SYMBOL(nft_ctx_add_include_path);
-- 
2.30.2

