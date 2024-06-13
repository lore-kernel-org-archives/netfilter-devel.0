Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2BDD1CF8F;
	Thu, 13 Jun 2024 01:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718240550; cv=none; b=RspIBz5kcDeAVtgN3W5Jyba9XezckBpLfAeQNbjCSgEg4AuqV/e8QFyFgTCY3VKyEhvnfauHEWRZIZ1/bueqJk5X9n464KxFqn2Mp5ISJJjFgmp66D6P57o4KDFwJFKKqhzxnlRm7QPfwJBZD9zxvdugt/kKg1JlZIz7yNfcKiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718240550; c=relaxed/simple;
	bh=A50b4L+qT6qvaBUZLhUAoqhVPk4KIdFd0CRD1kpzn1w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lXFd2f1jgOelZbWhIk4oQ2Ysk/R1+hASN9fWMpTJGTH3Dz5tsYrVDb3jqO1d+qLYuXisbuMyKy7u7JESPpDJsaZSfzPmKthBwllT1Z6DbCbhm479nnF3d7whUTblXzkHMd9YD1XsozYpMhReFu+EwuAt4oREba2J13J5DqZ/X1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,4.19.x 16/40] netfilter: nf_tables: defer gc run if previous batch is still pending
Date: Thu, 13 Jun 2024 03:01:45 +0200
Message-Id: <20240613010209.104423-17-pablo@netfilter.org>
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

From: Florian Westphal <fw@strlen.de>

commit 8e51830e29e12670b4c10df070a4ea4c9593e961 upstream.

Don't queue more gc work, else we may queue the same elements multiple
times.

If an element is flagged as dead, this can mean that either the previous
gc request was invalidated/discarded by a transaction or that the previous
request is still pending in the system work queue.

The latter will happen if the gc interval is set to a very low value,
e.g. 1ms, and system work queue is backlogged.

The sets refcount is 1 if no previous gc requeusts are queued, so add
a helper for this and skip gc run if old requests are pending.

Add a helper for this and skip the gc run in this case.

Fixes: f6c383b8c31a ("netfilter: nf_tables: adapt set backend to use GC transaction API")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h | 5 +++++
 net/netfilter/nft_set_hash.c      | 3 +++
 net/netfilter/nft_set_rbtree.c    | 3 +++
 3 files changed, 11 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index cf63b52f3c94..70fdfe6d410b 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -445,6 +445,11 @@ static inline void *nft_set_priv(const struct nft_set *set)
 	return (void *)set->data;
 }
 
+static inline bool nft_set_gc_is_pending(const struct nft_set *s)
+{
+	return refcount_read(&s->refs) != 1;
+}
+
 static inline struct nft_set *nft_set_container_of(const void *priv)
 {
 	return (void *)priv - offsetof(struct nft_set, data);
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 9ff988b1bc1a..a7dcf2e141c6 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -304,6 +304,9 @@ static void nft_rhash_gc(struct work_struct *work)
 	nft_net = net_generic(net, nf_tables_net_id);
 	gc_seq = READ_ONCE(nft_net->gc_seq);
 
+	if (nft_set_gc_is_pending(set))
+		goto done;
+
 	gc = nft_trans_gc_alloc(set, gc_seq, GFP_KERNEL);
 	if (!gc)
 		goto done;
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 35200be68c15..92931fa9593b 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -618,6 +618,9 @@ static void nft_rbtree_gc(struct work_struct *work)
 	nft_net = net_generic(net, nf_tables_net_id);
 	gc_seq  = READ_ONCE(nft_net->gc_seq);
 
+	if (nft_set_gc_is_pending(set))
+		goto done;
+
 	gc = nft_trans_gc_alloc(set, gc_seq, GFP_KERNEL);
 	if (!gc)
 		goto done;
-- 
2.30.2

