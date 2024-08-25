Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8ED97581A
	for <netfilter-devel@vger.kernel.org>; Sun, 25 Aug 2024 22:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724626041; cv=none; b=UItOg+6CgV1QmVjoKP/Vs6EMx8LWnxj50B5RF3hzqY390SYOgaxNJmPagKH17oIp5DvGNy0sxIfi2weuerXpocunyo96mL2V6v9eeIhqRviiR5X5+rKXp4JcT5ZLp4sqSnSJ33Y4+jWufafg8TuP0As6TMi0qsPHK6p4jOa6LzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724626041; c=relaxed/simple;
	bh=wBcrUpFie9JsHn5YfygTqcdCXv69UodCDnzn4g7KJ1A=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UL43P0WfBrcoPPVia2/YzC3WVqWTQ7ktVodGXcsqOsw1uVJHHj+x3yWX+KbfhS04WmR5RMPDjgb6DjXKRMDrFvskctkfEBdFnaVVkzrnHMSgVWzkcDUA5ZMU5a9d2ZI3JpB7Xz7u7zRhTjDfT/bYZqnxW0vbNGTK0cCxRmRTJts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/5] cache: only dump rules for the given table
Date: Mon, 26 Aug 2024 00:47:04 +0200
Message-Id: <20240825224707.3687-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240825224707.3687-1-pablo@netfilter.org>
References: <20240825224707.3687-1-pablo@netfilter.org>
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
 src/cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/cache.c b/src/cache.c
index 63443c68376d..3b664ee77d04 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -688,7 +688,7 @@ int rule_cache_dump(struct netlink_ctx *ctx, const struct handle *h,
 		    bool dump, bool reset)
 {
 	struct nftnl_rule_list *rule_cache;
-	const char *table = NULL;
+	const char *table = h->table.name;
 	const char *chain = NULL;
 	uint64_t rule_handle = 0;
 
-- 
2.30.2

