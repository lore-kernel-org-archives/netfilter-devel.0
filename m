Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93C8253355
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Jun 2025 10:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749206530; cv=none; b=fHNsJehZzbfPPQbtVcQZc1/hei0o+EI4xB+UUm1gPrHeLz98UkWPBoGQKRYfbmQwMEw7NNWWCQ4NyihiEQ0N31LP7U8u81ItSECBd2K0dluI3br27+8/zaz0h1hZYlQvETTCReUSaidGguOBeoux/DrBZPsvonwzMaeOFvfcX1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749206530; c=relaxed/simple;
	bh=9RK1Ac1pROAUbXfI6B7a8VoRJiB+fjfKqd7vpitYwFw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V7fwQNVdrXp/VLoX/GIilZ68bWp78ziLUMt2l2MnMlDHl+BU9vygCc67GcScG7KF/GwTMN8lr6TEVS43ceyTZ/WF6CXbAv+HSwXQ3XcjANti75wKCDtl/ElzZWlqpYvhFKTxPcQMAjJNzm/xNT+xJKtQPOpLinw2vOmAxkOsGUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5175760637; Fri,  6 Jun 2025 12:42:05 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: fix crash when set name is null
Date: Fri,  6 Jun 2025 12:41:49 +0200
Message-ID: <20250606104152.7742-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bogon provides a handle but not a name.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/cache.c                                            | 3 +++
 src/evaluate.c                                         | 3 +++
 tests/shell/testcases/bogons/nft-f/null_set_name_crash | 2 ++
 3 files changed, 8 insertions(+)
 create mode 100644 tests/shell/testcases/bogons/nft-f/null_set_name_crash

diff --git a/src/cache.c b/src/cache.c
index 3ac819cf68fb..67ba35bee1fa 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -840,6 +840,9 @@ struct set *set_cache_find(const struct table *table, const char *name)
 	struct set *set;
 	uint32_t hash;
 
+	if (!name)
+		return NULL;
+
 	hash = djb_hash(name) % NFT_CACHE_HSIZE;
 	list_for_each_entry(set, &table->set_cache.ht[hash], cache.hlist) {
 		if (!strcmp(set->handle.set.name, name))
diff --git a/src/evaluate.c b/src/evaluate.c
index 9c7f23cb080e..e8e4aa2df4ca 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -284,6 +284,9 @@ static int set_not_found(struct eval_ctx *ctx, const struct location *loc,
 	const struct table *table;
 	struct set *set;
 
+	if (!set_name)
+		set_name = "";
+
 	set = set_lookup_fuzzy(set_name, &ctx->nft->cache, &table);
 	if (set == NULL)
 		return cmd_error(ctx, loc, "%s", strerror(ENOENT));
diff --git a/tests/shell/testcases/bogons/nft-f/null_set_name_crash b/tests/shell/testcases/bogons/nft-f/null_set_name_crash
new file mode 100644
index 000000000000..e5d85b228a84
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/null_set_name_crash
@@ -0,0 +1,2 @@
+table y { }
+reset set y handle 6
-- 
2.49.0

