Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7522111A1
	for <netfilter-devel@vger.kernel.org>; Sat, 27 Jul 2024 21:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722116218; cv=none; b=JSv+kLaqJn6VG2CcJpCJgXC9Q7yJEy9v1TqMuyh2tRJ67U3L7Ks9zquaxhMkvUWx5mm7zpO32vDJJG1X3h5HRJZD3fchWq3fKvlq0UiTgX8XXcyhCUpqaPhAguEFwUiCvc3NhYOCx/y/d4nZu7CG8MnZlQcY8EHL0Iv454vvxC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722116218; c=relaxed/simple;
	bh=xhKmXr7KdgIvnngopOqwMlrOnWx3iQhYKMnZ76EDqZg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBO7WmJ3Zjy6i5s9J6CFzdatYkcrscCjwNjnPo9OMGg1iKrBuI0Rh9y4m0LlH67EHMZch7Zcan/MbV3TxCrPBq0q9hU/vQubtTVDldYHNhmqxPnOwX7z1CNqm3230nns5gPZu4IwkfazM5rYP6F/Ty+dKUm2gOI/yEg4kvdxoO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=SB9hEUek; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="SB9hEUek"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gqz8NZvCUA0pizkqznDDwjPB4g/+Q9wnlhGZgIBqyKs=; b=SB9hEUekynyC72vLcVQ97yFG2j
	2W29btnstd0gikWOnt3guv76lHOQKb/LHE/6zIKyYVW/YOGlyobj9i0dY/3u7059N9HxPth9pC5JG
	V5GlpXSN4E0ErAK5JYqaabFG94P0I3PCagiV36KUpJdIBg9JzeCXoAWIwMH6bPSMW8bny3cXooj9/
	c060qH3qnRrd7ghQTk6He1dyTVj6tHH/abidu+FcLsbJ2Tr7A5Lk/IBcPHwxKne06LeJ3bGBWOGK9
	Me0Hqa/VLaka9/Vk82xEx/SkcdK24nAhqrYPcjj89G/CiV9SSa8utxtSvmm4kS9Fy1Ke52sC/WlJp
	tprzpVKA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sXp5w-000000002UF-1gu0
	for netfilter-devel@vger.kernel.org;
	Sat, 27 Jul 2024 23:36:52 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 01/14] nft: cache: Annotate faked base chains as such
Date: Sat, 27 Jul 2024 23:36:35 +0200
Message-ID: <20240727213648.28761-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240727213648.28761-1-phil@nwl.cc>
References: <20240727213648.28761-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To avoid pointless kernel ruleset modifications without too many
workarounds in user space, code sometimes adds "fake" base chains to
cache. Yet these fake entries happen to prevent base chain creation for
a following command which actually requires them. Fix this by annotating
the fake entries as such so *_builtin_init() functions may convert them
into real ones.

Fixes: fd4b9bf08b9eb ("nft: Avoid pointless table/chain creation")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c |  6 +++---
 iptables/nft-cache.h |  2 +-
 iptables/nft-chain.c |  3 ++-
 iptables/nft-chain.h |  3 ++-
 iptables/nft.c       | 31 ++++++++++++++++++++-----------
 5 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 91d296709b9de..da2d4d7fd872c 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -244,10 +244,10 @@ nft_cache_add_base_chain(struct nft_handle *h, const struct builtin_table *t,
 }
 
 int nft_cache_add_chain(struct nft_handle *h, const struct builtin_table *t,
-			struct nftnl_chain *c)
+			struct nftnl_chain *c, bool fake)
 {
 	const char *cname = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
-	struct nft_chain *nc = nft_chain_alloc(c);
+	struct nft_chain *nc = nft_chain_alloc(c, fake);
 	int ret;
 
 	if (nftnl_chain_is_set(c, NFTNL_CHAIN_HOOKNUM)) {
@@ -349,7 +349,7 @@ static int nftnl_chain_list_cb(const struct nlmsghdr *nlh, void *data)
 		goto out;
 	}
 
-	nft_cache_add_chain(h, t, c);
+	nft_cache_add_chain(h, t, c, false);
 	return MNL_CB_OK;
 out:
 	nftnl_chain_free(c);
diff --git a/iptables/nft-cache.h b/iptables/nft-cache.h
index 29ec6b5c3232b..e9f5755c9561d 100644
--- a/iptables/nft-cache.h
+++ b/iptables/nft-cache.h
@@ -17,7 +17,7 @@ int flush_rule_cache(struct nft_handle *h, const char *table,
 		     struct nft_chain *c);
 void nft_cache_build(struct nft_handle *h);
 int nft_cache_add_chain(struct nft_handle *h, const struct builtin_table *t,
-			struct nftnl_chain *c);
+			struct nftnl_chain *c, bool fake);
 int nft_cache_sort_chains(struct nft_handle *h, const char *table);
 
 struct nft_chain *
diff --git a/iptables/nft-chain.c b/iptables/nft-chain.c
index e954170fa7312..c24e6c9b346d1 100644
--- a/iptables/nft-chain.c
+++ b/iptables/nft-chain.c
@@ -12,12 +12,13 @@
 
 #include "nft-chain.h"
 
-struct nft_chain *nft_chain_alloc(struct nftnl_chain *nftnl)
+struct nft_chain *nft_chain_alloc(struct nftnl_chain *nftnl, bool fake)
 {
 	struct nft_chain *c = xtables_malloc(sizeof(*c));
 
 	INIT_LIST_HEAD(&c->head);
 	c->nftnl = nftnl;
+	c->fake = fake;
 
 	return c;
 }
diff --git a/iptables/nft-chain.h b/iptables/nft-chain.h
index 9adf173857420..166504c0c8f95 100644
--- a/iptables/nft-chain.h
+++ b/iptables/nft-chain.h
@@ -11,6 +11,7 @@ struct nft_chain {
 	struct hlist_node	hnode;
 	struct nft_chain	**base_slot;
 	struct nftnl_chain	*nftnl;
+	bool			fake;
 };
 
 #define CHAIN_NAME_HSIZE	512
@@ -20,7 +21,7 @@ struct nft_chain_list {
 	struct hlist_head	names[CHAIN_NAME_HSIZE];
 };
 
-struct nft_chain *nft_chain_alloc(struct nftnl_chain *nftnl);
+struct nft_chain *nft_chain_alloc(struct nftnl_chain *nftnl, bool fake);
 void nft_chain_free(struct nft_chain *c);
 
 struct nft_chain_list *nft_chain_list_alloc(void);
diff --git a/iptables/nft.c b/iptables/nft.c
index a9d97d4cef8e0..fde3db2a22b79 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -721,7 +721,7 @@ static void nft_chain_builtin_add(struct nft_handle *h,
 
 	if (!fake)
 		batch_chain_add(h, NFT_COMPAT_CHAIN_ADD, c);
-	nft_cache_add_chain(h, table, c);
+	nft_cache_add_chain(h, table, c, fake);
 }
 
 /* find if built-in table already exists */
@@ -765,14 +765,19 @@ nft_chain_builtin_find(const struct builtin_table *t, const char *chain)
 static void nft_chain_builtin_init(struct nft_handle *h,
 				   const struct builtin_table *table)
 {
+	struct nft_chain *c;
 	int i;
 
 	/* Initialize built-in chains if they don't exist yet */
 	for (i=0; i < NF_INET_NUMHOOKS && table->chains[i].name != NULL; i++) {
-		if (nft_chain_find(h, table->name, table->chains[i].name))
-			continue;
-
-		nft_chain_builtin_add(h, table, &table->chains[i], false);
+		c = nft_chain_find(h, table->name, table->chains[i].name);
+		if (!c) {
+			nft_chain_builtin_add(h, table,
+					      &table->chains[i], false);
+		} else if (c->fake) {
+			batch_chain_add(h, NFT_COMPAT_CHAIN_ADD, c->nftnl);
+			c->fake = false;
+		}
 	}
 }
 
@@ -799,6 +804,7 @@ static int nft_xt_builtin_init(struct nft_handle *h, const char *table,
 {
 	const struct builtin_table *t;
 	const struct builtin_chain *c;
+	struct nft_chain *nc;
 
 	if (!h->cache_init)
 		return 0;
@@ -819,10 +825,13 @@ static int nft_xt_builtin_init(struct nft_handle *h, const char *table,
 	if (!c)
 		return -1;
 
-	if (h->cache->table[t->type].base_chains[c->hook])
-		return 0;
-
-	nft_chain_builtin_add(h, t, c, false);
+	nc = h->cache->table[t->type].base_chains[c->hook];
+	if (!nc) {
+		nft_chain_builtin_add(h, t, c, false);
+	} else if (nc->fake) {
+		batch_chain_add(h, NFT_COMPAT_CHAIN_ADD, nc->nftnl);
+		nc->fake = false;
+	}
 	return 0;
 }
 
@@ -2091,7 +2100,7 @@ int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *tabl
 	if (!batch_chain_add(h, NFT_COMPAT_CHAIN_USER_ADD, c))
 		return 0;
 
-	nft_cache_add_chain(h, t, c);
+	nft_cache_add_chain(h, t, c, false);
 
 	/* the core expects 1 for success and 0 for error */
 	return 1;
@@ -2118,7 +2127,7 @@ int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table
 		nftnl_chain_set_str(c, NFTNL_CHAIN_NAME, chain);
 		created = true;
 
-		nft_cache_add_chain(h, t, c);
+		nft_cache_add_chain(h, t, c, false);
 	} else {
 		c = nc->nftnl;
 
-- 
2.43.0

