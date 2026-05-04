Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C042D8DDF
	for <netfilter-devel@vger.kernel.org>; Mon,  4 May 2026 17:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777914731; cv=none; b=FmovlO1/t4uTtdBb26NQ3htt4RcfITTwy+n3tDIo1V4sqGYvQNocNUvnIoBlvnDiNHwa3Svp8QuWCeRH343pjctLPqNiwDD2K1O4wr3/1s/SrUU99CsSPJRlsokATZGn2v2bYTgT0BN9c9Joq2rBKf0ZmaWeiFMZ5XhpGQPLIlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777914731; c=relaxed/simple;
	bh=LPhkfnFT7SqsfrweJPtAI2loEsn0Dp0+XNcysdLsVb4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dw4P1klqigVBCejOqgtTXXQctQE7WStDK3AmTVVg4qK7aBMcJCGhad0o/6S2Y7gzNlV7X7WDqFSJhSiSlrTgHafxOHLYCcqs3B8pqM3X0gN9Zh5SkhCnEUr0Fp6GXTOEefn0r9ISLy6PiBuUIrNpGwtVDi1Hut2Bqx3VsSo6Bok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 25CEF6079C; Mon, 04 May 2026 19:12:07 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] src: don't write to possible rodata location
Date: Mon,  4 May 2026 19:11:55 +0200
Message-ID: <20260504171201.28383-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

seen with gcc-16.0.1:
src/libnftables.c: In function 'nft_ctx_add_var':
src/libnftables.c:153:27: warning: initialization discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
153 |         char *separator = strchr(var, '=');

function arg says "const char *", write to this memory location is not expected.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/libnftables.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index bc42c32de889..db9ee388adde 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -150,21 +150,27 @@ static void nft_exit(struct nft_ctx *ctx)
 EXPORT_SYMBOL(nft_ctx_add_var);
 int nft_ctx_add_var(struct nft_ctx *ctx, const char *var)
 {
-	char *separator = strchr(var, '=');
+	const char *separator = strchr(var, '=');
 	int pcount = ctx->num_vars;
 	struct nft_vars *tmp;
 	const char *value;
+	size_t len;
+	char *key;
 
 	if (!separator)
 		return -1;
 
 	tmp = xrealloc(ctx->vars, (pcount + 1) * sizeof(struct nft_vars));
 
-	*separator = '\0';
 	value = separator + 1;
+	len = separator - var;
+
+	key = xmalloc(len + 1);
+	memcpy(key, var, len);
+	key[len] = '\0';
 
 	ctx->vars = tmp;
-	ctx->vars[pcount].key = xstrdup(var);
+	ctx->vars[pcount].key = key;
 	ctx->vars[pcount].value = xstrdup(value);
 	ctx->num_vars++;
 
-- 
2.53.0

