Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B034D171E76
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Sep 2024 17:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726593598; cv=none; b=jEIccoZisrnAJHv/bs0CVUkadzDHa1PRat34ZvVzQfaZRF1xm3IqsKtbaTtgKKS5juwXzYaF9Lnf38JF86RaBc7uz9ciH9F1q1d/KCuR40weLuwVl3FFcCiIbo9ivvTdQNc5t0sVLqnyWpf7bcQReZ6mWD7n7jh40+2Z2blexxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726593598; c=relaxed/simple;
	bh=iV1O6vcnRA7X7qfnNyG4Fy9A29j9ZhSWy9a46eg4iCc=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=mKUnfWkty9O4eptIEAuJaTwomMbjIb/f2Z+sInxUk/5FXESZuAH3RlSQzYBqSrwVTs1JDXWVuUdW4cb4G/S7kW979qodXiYaFgRouFKTOiz8uGFouL2eQcrLeTXAhZNpfbthKS3ZGmIvJ3I8cOI3PPsGLycZdGPIhBCP4I9R6hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] cache: initialize filter when fetching implicit chains
Date: Tue, 17 Sep 2024 19:19:40 +0200
Message-Id: <20240917171940.160969-1-pablo@netfilter.org>
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

initialize filter, otherwise filter->reset.rule is uninitialized.

Fixes: dbff26bfba83 ("cache: consolidate reset command")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/cache.c b/src/cache.c
index c8ef16033551..7288666256bb 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -1118,7 +1118,7 @@ err_ctx_list:
 static int implicit_chain_cache(struct netlink_ctx *ctx, struct table *table,
 				const char *chain_name)
 {
-	struct nft_cache_filter filter;
+	struct nft_cache_filter filter = {};
 	struct chain *chain;
 	int ret = 0;
 
-- 
2.30.2

