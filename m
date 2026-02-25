Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3024A0C
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Feb 2026 00:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771978436; cv=none; b=ZogG4jWoXAxvm0uz9f2OFyUs9aiwg8eUXIEaOcQW1lz71vHq39A+G8ukOWWs7V1f7DmQ7Id/Ssck+C/cl0gQvnV1bxVaPb+COFbDYzy/L47C4m2E2huXQgf7zd9cv6E4TV4qPIZ32aQZjSM/pD9pZ08zZlEaOnn7csH4nOD0FRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771978436; c=relaxed/simple;
	bh=Nj2Kuz3UUpXDvvlaFtTk9RdQ/lOmylfzpTYvcNhzH58=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I6k/YAvE9zvk7XE1/+jDWBAGKRi5rajLuXnTlzsEwWMhNqFpEaO8D8O7y2HN5TH+NI4P7egMpA0bk+PeDsp72S4ZKsmzC57R3qCmohorUxMC9/x+8sP/pc3m2CBO91lhyVXQh51vJRCbedRKifysoJ3Fwbei+O5id2XXAVWxmgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DYyuYlFY; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DYyuYlFY"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4279B603C9;
	Wed, 25 Feb 2026 01:13:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1771978432;
	bh=15ZinKH5gZsU/JljAGR0xtF+zjtu/G0j4m4m6VAb2rw=;
	h=From:To:Cc:Subject:Date:From;
	b=DYyuYlFYhD2q1msxwrPapShXYG6H8WjA5pny4kt3QyH0gLaFLlga/BdNZ8LzA+w4s
	 hmYo4B6Y/NIGfU6PIx4GFkcxgRjfZpmGwwklfTo15lO7XItC+PSyRAth8XN6GPlqAt
	 C3k5bX4o7UneylF0JBxOMhJ0kRI5ORn54Lc7+8exQq4jxnSvOJYGHtQlKzij009ztU
	 rC3SDoVkjHnyz1ls2VDqAK8SUaGFOX+xBZGMyOmA18NseqRY6AsY0ehs3xnTc2UvcW
	 K/QWrmYjElxBUuhuB7RXT4aK/IhYmhlYO/58bWrktlPL4wC8PD18gJqyhhkHdEiI7Z
	 VwZO0l85GkJjg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf] netfilter: nf_tables: clone set on flush only
Date: Wed, 25 Feb 2026 01:13:48 +0100
Message-ID: <20260225001348.2371931-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Restrict set clone to the flush set command in the preparation phase.
Add NFT_ITER_UPDATE_CLONE and use it for this purpose, update the rbtree
and pipapo backends to only clone the set when this iteration type is
used.

As for the existing NFT_ITER_UPDATE type, update the pipapo backend to
use the existing set clone if available, otherwise use the existing set
representation. After this update, there is no need to clone a set that
is being deleted, this includes bound anonymous set.

An alternative approach to NFT_ITER_UPDATE_CLONE is to add a .clone
interface and call it from the flush set path.

Reported-by: syzbot+4924a0edc148e8b4b342@syzkaller.appspotmail.com
Fixes: 3f1d886cc7c3 ("netfilter: nft_set_pipapo: move cloning of match info to insert/removal path")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c     |  2 +-
 net/netfilter/nft_set_hash.c      |  1 +
 net/netfilter/nft_set_pipapo.c    | 11 +++++++++--
 net/netfilter/nft_set_rbtree.c    |  8 +++++---
 5 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 426534a711b0..ea6f29ad7888 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -320,11 +320,13 @@ static inline void *nft_elem_priv_cast(const struct nft_elem_priv *priv)
  * @NFT_ITER_UNSPEC: unspecified, to catch errors
  * @NFT_ITER_READ: read-only iteration over set elements
  * @NFT_ITER_UPDATE: iteration under mutex to update set element state
+ * @NFT_ITER_UPDATE_CLONE: clone set before iteration under mutex to update element
  */
 enum nft_iter_type {
 	NFT_ITER_UNSPEC,
 	NFT_ITER_READ,
 	NFT_ITER_UPDATE,
+	NFT_ITER_UPDATE_CLONE,
 };
 
 struct nft_set;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 834736237b09..618f79700f75 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7906,7 +7906,7 @@ static int nft_set_flush(struct nft_ctx *ctx, struct nft_set *set, u8 genmask)
 {
 	struct nft_set_iter iter = {
 		.genmask	= genmask,
-		.type		= NFT_ITER_UPDATE,
+		.type		= NFT_ITER_UPDATE_CLONE,
 		.fn		= nft_setelem_flush,
 	};
 
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 739b992bde59..b0e571c8e3f3 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -374,6 +374,7 @@ static void nft_rhash_walk(const struct nft_ctx *ctx, struct nft_set *set,
 {
 	switch (iter->type) {
 	case NFT_ITER_UPDATE:
+	case NFT_ITER_UPDATE_CLONE:
 		/* only relevant for netlink dumps which use READ type */
 		WARN_ON_ONCE(iter->skip != 0);
 
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 18e1903b1d3d..cd0d2d4ae36b 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2145,13 +2145,20 @@ static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
 	const struct nft_pipapo_match *m;
 
 	switch (iter->type) {
-	case NFT_ITER_UPDATE:
+	case NFT_ITER_UPDATE_CLONE:
 		m = pipapo_maybe_clone(set);
 		if (!m) {
 			iter->err = -ENOMEM;
 			return;
 		}
-
+		nft_pipapo_do_walk(ctx, set, m, iter);
+		break;
+	case NFT_ITER_UPDATE:
+		if (priv->clone)
+			m = priv->clone;
+		else
+			m = rcu_dereference_protected(priv->match,
+						      nft_pipapo_transaction_mutex_held(set));
 		nft_pipapo_do_walk(ctx, set, m, iter);
 		break;
 	case NFT_ITER_READ:
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 644d4b916705..853ff30a208c 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -861,13 +861,15 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 	struct nft_rbtree *priv = nft_set_priv(set);
 
 	switch (iter->type) {
-	case NFT_ITER_UPDATE:
-		lockdep_assert_held(&nft_pernet(ctx->net)->commit_mutex);
-
+	case NFT_ITER_UPDATE_CLONE:
 		if (nft_array_may_resize(set) < 0) {
 			iter->err = -ENOMEM;
 			break;
 		}
+		fallthrough;
+	case NFT_ITER_UPDATE:
+		lockdep_assert_held(&nft_pernet(ctx->net)->commit_mutex);
+
 		nft_rbtree_do_walk(ctx, set, iter);
 		break;
 	case NFT_ITER_READ:
-- 
2.47.3

