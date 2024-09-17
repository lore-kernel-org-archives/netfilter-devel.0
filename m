Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6638313777E;
	Tue, 17 Sep 2024 20:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726604693; cv=none; b=YXzr/0GgSyHTOaqeIY8eqcXLvivMGCa/mCjJaNjiq9o+MVa1TRlCcQtCGxj1a9sGS5WVkg/qZfFuBI8XY4cUBRMQ2lyQb40Ql/mUChZ95IDU/AMPzzStnhHzCkPyUYLET3KdpmHY3MhzGLzJ4K77yD7XEo438pPo1/V0/K4oY50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726604693; c=relaxed/simple;
	bh=p3GaAIBeizXOJL5O1lNdrqliw7A7FtzYQOqKWsPdKZM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gRyw4wQgEVOXQUcFQkrPOtk6lRIq32pW1Z4gtFmM+0UV1LxwAmMq0mQa0H6HQ0PevDWZbJvTfV5WUYbLkJrEWklTpbXq+M/OW2XuB7v/ReVrV4x/1bj1ZlGIRz/uO74oVoCUMbXj7YR3ytXGjybW4VdVMQUd9rwA0NLDII71B9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,6.6 2/2] netfilter: nf_tables: missing iterator type in lookup walk
Date: Tue, 17 Sep 2024 22:24:44 +0200
Message-Id: <20240917202444.171526-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240917202444.171526-1-pablo@netfilter.org>
References: <20240917202444.171526-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit efefd4f00c967d00ad7abe092554ffbb70c1a793 upstream.

Add missing decorator type to lookup expression and tighten WARN_ON_ONCE
check in pipapo to spot earlier that this is unset.

Fixes: 29b359cf6d95 ("netfilter: nft_set_pipapo: walk over current view on netlink dump")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_lookup.c     | 1 +
 net/netfilter/nft_set_pipapo.c | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 7ba4b1454db4..1b9edf2b3393 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -217,6 +217,7 @@ static int nft_lookup_validate(const struct nft_ctx *ctx,
 		return 0;
 
 	iter.genmask	= nft_genmask_next(ctx->net);
+	iter.type	= NFT_ITER_UPDATE;
 	iter.skip	= 0;
 	iter.count	= 0;
 	iter.err	= 0;
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 90f129f1a136..22407e7e0b51 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2041,7 +2041,8 @@ static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
 	const struct nft_pipapo_field *f;
 	int i, r;
 
-	WARN_ON_ONCE(iter->type == NFT_ITER_UNSPEC);
+	WARN_ON_ONCE(iter->type != NFT_ITER_READ &&
+		     iter->type != NFT_ITER_UPDATE);
 
 	rcu_read_lock();
 	if (iter->type == NFT_ITER_READ)
-- 
2.30.2

