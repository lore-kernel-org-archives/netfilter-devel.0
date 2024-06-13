Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B5F2B664;
	Thu, 13 Jun 2024 01:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718240545; cv=none; b=Midi0J3QgsxFB/TWIPCP3/ZYVbAck6bsNS9wtY7lWW38qswmu4h64WwZ8Jxv2Jco3K2yes0vfSV6ubeCDCLB5QwWx8ZR7+cXT/yc1DbSOKBZCv4W9U3IL4Z7TgYf1LojUCjRVlY+Pwn+WH6u5nh4TwAirErZ8/AU+iqxMmukH0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718240545; c=relaxed/simple;
	bh=mO7DmLa/bDMebuPvJOFGEMKgj5RGeh0hkHCQfL6XZH8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cStDiA7Rpm0pvWmFsrXnqPbBz2SFJ/4uXBupmOE8YU41MJo+5+12VEuNyRqjE/vBSkC7NitrirdbLLAKi3qHPougRmnILIuxTX3fMmMkea/vZfEbUDeX8ZiZj4cxIdM0m2GJ2qlJNlolWo9T+Osi1Sk3c1mNANzUPG75yjikj9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,4.19.x 09/40] netfilter: nf_tables: don't skip expired elements during walk
Date: Thu, 13 Jun 2024 03:01:38 +0200
Message-Id: <20240613010209.104423-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240613010209.104423-1-pablo@netfilter.org>
References: <20240613010209.104423-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 24138933b97b055d486e8064b4a1721702442a9b upstream.

There is an asymmetry between commit/abort and preparation phase if the
following conditions are met:

1. set is a verdict map ("1.2.3.4 : jump foo")
2. timeouts are enabled

In this case, following sequence is problematic:

1. element E in set S refers to chain C
2. userspace requests removal of set S
3. kernel does a set walk to decrement chain->use count for all elements
   from preparation phase
4. kernel does another set walk to remove elements from the commit phase
   (or another walk to do a chain->use increment for all elements from
    abort phase)

If E has already expired in 1), it will be ignored during list walk, so its use count
won't have been changed.

Then, when set is culled, ->destroy callback will zap the element via
nf_tables_set_elem_destroy(), but this function is only safe for
elements that have been deactivated earlier from the preparation phase:
lack of earlier deactivate removes the element but leaks the chain use
count, which results in a WARN splat when the chain gets removed later,
plus a leak of the nft_chain structure.

Update pipapo_get() not to skip expired elements, otherwise flush
command reports bogus ENOENT errors.

Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Fixes: 8d8540c4f5e0 ("netfilter: nft_set_rbtree: add timeout support")
Fixes: 9d0982927e79 ("netfilter: nft_hash: add support for timeouts")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c  | 4 ++++
 net/netfilter/nft_set_hash.c   | 2 --
 net/netfilter/nft_set_rbtree.c | 2 --
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a9dfe3183565..a0cc186cc17d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4159,8 +4159,12 @@ static int nf_tables_dump_setelem(const struct nft_ctx *ctx,
 				  const struct nft_set_iter *iter,
 				  struct nft_set_elem *elem)
 {
+	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
 	struct nft_set_dump_args *args;
 
+	if (nft_set_elem_expired(ext))
+		return 0;
+
 	args = container_of(iter, struct nft_set_dump_args, iter);
 	return nf_tables_fill_setelem(args->skb, set, elem);
 }
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index f2be05731740..c899df945b0d 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -268,8 +268,6 @@ static void nft_rhash_walk(const struct nft_ctx *ctx, struct nft_set *set,
 
 		if (iter->count < iter->skip)
 			goto cont;
-		if (nft_set_elem_expired(&he->ext))
-			goto cont;
 		if (!nft_set_elem_active(&he->ext, iter->genmask))
 			goto cont;
 
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index daf5df18c580..fc069ffc38f7 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -556,8 +556,6 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 
 		if (iter->count < iter->skip)
 			goto cont;
-		if (nft_set_elem_expired(&rbe->ext))
-			goto cont;
 		if (!nft_set_elem_active(&rbe->ext, iter->genmask))
 			goto cont;
 
-- 
2.30.2

