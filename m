Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D636B238150;
	Sun,  7 Dec 2025 01:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765069805; cv=none; b=ZkTKK4FYZQqhv67wQfqjF52soYMw2zShDujWZD/j9PETm8C7Yg4dg5Nwjf3Cs4xdDXio/zNolyiQ46d8VBAMNsBgSAJUrzr3hNKZ1RMxOz/g/MZZ1PNDUL9hnrTd9Xd9/6dQyplM85ww0HMwlCcu1fuLbPUZ0VI9iMUypW8P0Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765069805; c=relaxed/simple;
	bh=Ds5YnaVMDyEfcUU9LvWtKN9gs7WEJBVXuvTDGyOUbeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9vqGCqi1FyvY1v/8FAVsCieZ7KAxJlLQTChrGPkczThEYLpYVfmHbT1yULkcYLGydfHqhAjWoXDzVo1f56iOrZJZI7n1B1Ywfu/BJn/HYWWvP5aMc7Lo8XOCHm8A/ns9hKLQ5sdPPyUm77/GIQ/HNDrHE8MTsuuv8F5Cp2OZow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dzQPAACt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dzQPAACt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E892EC113D0;
	Sun,  7 Dec 2025 01:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765069803;
	bh=Ds5YnaVMDyEfcUU9LvWtKN9gs7WEJBVXuvTDGyOUbeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dzQPAACtB8I9e3dDh6i4pBun6bwYikv/R7FR4y+dTo3Mudq2qdYMbD76eLghBf97v
	 zWQJ45wuFXX/vHFAh5HvDkAs11gDyBO3j318kdJ6MOA+ufwQrcN4Ecaoj40ytlM1HH
	 t6eiECznbYU/wi6CeTvlXunIVKBOE/32k1tq8H2oAw9uKDSmAIRALDWhUZ2OO4DeTa
	 JogwRpKMc92RIRaJjTnmInFjRjmJFIIlZRZUw3vV7kXZyPQ3lPdnb+BuYpDS8zFX3X
	 Q4rkLh5XUjSMc2viph0YT4K9IjMtHO9fjeJujyyHIdRDGLGp8PYcdrnfA1n1gXxa/B
	 OPzbPxbkvzNGQ==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	andrew+netdev@lunn.ch,
	horms@kernel.org,
	pablo@netfilter.org,
	fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	willemdebruijn.kernel@gmail.com,
	kuniyu@google.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 2/4] inet: frags: add inet_frag_queue_flush()
Date: Sat,  6 Dec 2025 17:09:40 -0800
Message-ID: <20251207010942.1672972-3-kuba@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251207010942.1672972-1-kuba@kernel.org>
References: <20251207010942.1672972-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of exporting inet_frag_rbtree_purge() which requires that
caller takes care of memory accounting, add a new helper. We will
need to call it from a few places in the next patch.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/inet_frag.h  |  5 ++---
 net/ipv4/inet_fragment.c | 15 ++++++++++++---
 net/ipv4/ip_fragment.c   |  6 +-----
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index 0eccd9c3a883..3ffaceee7bbc 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -141,9 +141,8 @@ void inet_frag_kill(struct inet_frag_queue *q, int *refs);
 void inet_frag_destroy(struct inet_frag_queue *q);
 struct inet_frag_queue *inet_frag_find(struct fqdir *fqdir, void *key);
 
-/* Free all skbs in the queue; return the sum of their truesizes. */
-unsigned int inet_frag_rbtree_purge(struct rb_root *root,
-				    enum skb_drop_reason reason);
+void inet_frag_queue_flush(struct inet_frag_queue *q,
+			   enum skb_drop_reason reason);
 
 static inline void inet_frag_putn(struct inet_frag_queue *q, int refs)
 {
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index 30f4fa50ee2d..1bf969b5a1cb 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -263,8 +263,8 @@ static void inet_frag_destroy_rcu(struct rcu_head *head)
 	kmem_cache_free(f->frags_cachep, q);
 }
 
-unsigned int inet_frag_rbtree_purge(struct rb_root *root,
-				    enum skb_drop_reason reason)
+static unsigned int
+inet_frag_rbtree_purge(struct rb_root *root, enum skb_drop_reason reason)
 {
 	struct rb_node *p = rb_first(root);
 	unsigned int sum = 0;
@@ -284,7 +284,16 @@ unsigned int inet_frag_rbtree_purge(struct rb_root *root,
 	}
 	return sum;
 }
-EXPORT_SYMBOL(inet_frag_rbtree_purge);
+
+void inet_frag_queue_flush(struct inet_frag_queue *q,
+			   enum skb_drop_reason reason)
+{
+	unsigned int sum;
+
+	sum = inet_frag_rbtree_purge(&q->rb_fragments, reason);
+	sub_frag_mem_limit(q->fqdir, sum);
+}
+EXPORT_SYMBOL(inet_frag_queue_flush);
 
 void inet_frag_destroy(struct inet_frag_queue *q)
 {
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index d7bccdc9dc69..32f1c1a46ba7 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -240,14 +240,10 @@ static int ip_frag_too_far(struct ipq *qp)
 
 static int ip_frag_reinit(struct ipq *qp)
 {
-	unsigned int sum_truesize = 0;
-
 	if (!mod_timer_pending(&qp->q.timer, jiffies + qp->q.fqdir->timeout))
 		return -ETIMEDOUT;
 
-	sum_truesize = inet_frag_rbtree_purge(&qp->q.rb_fragments,
-					      SKB_DROP_REASON_FRAG_TOO_FAR);
-	sub_frag_mem_limit(qp->q.fqdir, sum_truesize);
+	inet_frag_queue_flush(&qp->q, SKB_DROP_REASON_FRAG_TOO_FAR);
 
 	qp->q.flags = 0;
 	qp->q.len = 0;
-- 
2.52.0

