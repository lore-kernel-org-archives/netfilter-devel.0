Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A329BA3D
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Sep 2024 19:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726601131; cv=none; b=gasGkASuLGMmNU/LhehPR7d/nS3I4RgL9f3AeRfQWgidPiMq7VnbYWR4p+NktHi3Xr2bHopt2ZbIJ9lBEHkPxH7tUcbKQAd6wfa2EZiMd6VUAndRox+mbB3VFR/5XydOLjnpCbJEzLyid3fxuDzwBFoVNHGOXcDCWg+zTJGdkm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726601131; c=relaxed/simple;
	bh=tVrE36OpgqCH7pvP0HZM40VbHcOyJvqmfNUx8Qgf/dQ=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=Ur2ENVPw9C7QAuLAxktUpuPDDcnRQjAFiKlpq81mW8WsX7HJ/oQBtbFcy3xWnxK0bQrZY5b4DbgFEWYVt9iRmcaWARYiQtexy7DO3V7gbzEZGMzHkhVo08aI8Wn6isUIwrWDpZ2tKvBVBARXQaTp0kodJ9Ek9r4RG0GeklYmtMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2] cache: initialize filter when fetching implicit chains
Date: Tue, 17 Sep 2024 21:25:23 +0200
Message-Id: <20240917192523.316471-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ASAN reports:

  src/cache.c:734:25: runtime error: load of value 189, which is not a valid value for type '_Bool'

because filter->reset.rule remains uninitialized.

Initialize filter and replace existing construct to initialize table and
chain when filtering which was to be leaving remaining fields
uninitialized.

Fixes: dbff26bfba83 ("cache: consolidate reset command")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: replace construct which does not initialize remaining fields.

 src/cache.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index c8ef16033551..b75a5bf3283c 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -1118,15 +1118,14 @@ err_ctx_list:
 static int implicit_chain_cache(struct netlink_ctx *ctx, struct table *table,
 				const char *chain_name)
 {
-	struct nft_cache_filter filter;
+	struct nft_cache_filter filter = {};
 	struct chain *chain;
 	int ret = 0;
 
 	list_for_each_entry(chain, &table->chain_bindings, cache.list) {
-		filter.list = (typeof(filter.list)) {
-			.table = table->handle.table.name,
-			.chain = chain->handle.chain.name,
-		};
+		filter.list.table = table->handle.table.name;
+		filter.list.chain = chain->handle.chain.name;
+
 		ret = rule_init_cache(ctx, table, &filter);
 	}
 
-- 
2.30.2

