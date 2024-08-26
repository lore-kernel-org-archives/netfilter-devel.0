Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 946B813BC3F
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Aug 2024 08:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724662505; cv=none; b=WA6stMk8m9ENp3SzVqmahg0eena/UJ2SYDMOqsugmKRBpk8OfruX115R+Sr5QAivdPvdBBMl29t3pmQuWulCqumlOX8xeFcWzONWNE15CD7bjNPLCe0goqdmcC7GFfjnNP/oYVt7L5ImoyT961bgt4+kwI1MW8k37bygWviOJ0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724662505; c=relaxed/simple;
	bh=JnRl2WxkGMc+2fvzxIVw2XUrKxmui4xank+QfZL8pp0=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s26U1pGfzlvlBiQNKsok6JivulwYuabxOOjEL+UzZKqLbltUMLCh+tTmhF0n7J5DDeQicnULvEVOtXACffWBnBLs/A6RNlejPs+LheB1cyT5VmvhaM9P+mpv2j0c5Dv1NpdQcn22HUFeIzGQWpOG1xnfmBqCXrcSKtqqIKs3qa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 4/7] cache: only dump rules for the given table
Date: Mon, 26 Aug 2024 10:54:52 +0200
Message-Id: <20240826085455.163392-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240826085455.163392-1-pablo@netfilter.org>
References: <20240826085455.163392-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Only family is set on in the dump request, set on table and chain
otherwise, rules for the given family are fetched for each existing
table.

Fixes: afbd102211dc ("src: do not use the nft_cache_filter object from mnl.c")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes

 src/cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/cache.c b/src/cache.c
index 3849a4640416..c36b3ebc0614 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -694,7 +694,7 @@ int rule_cache_dump(struct netlink_ctx *ctx, const struct handle *h,
 		    bool dump, bool reset)
 {
 	struct nftnl_rule_list *rule_cache;
-	const char *table = NULL;
+	const char *table = h->table.name;
 	const char *chain = NULL;
 	uint64_t rule_handle = 0;
 
-- 
2.30.2

