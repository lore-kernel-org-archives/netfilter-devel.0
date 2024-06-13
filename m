Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25A66175AD;
	Thu, 13 Jun 2024 01:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718240552; cv=none; b=gmSCY9S3q6MgNw1QM8BzE/9mPSn3V4U98KtWbNdIpJNlB5u+frf2LEBz2vMtzDGlka91B5B5gQ6ecmPAy0PfhNysLEMEnpbAnMUnOozX4sq9bnITG43/nOoEEoUV/IXdaYv31ibw8EycyRYGur5A7n4Zm76vzLyGISwwV+nwDRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718240552; c=relaxed/simple;
	bh=fQfCXzLP+W70JrsbT7NmMWL+Lo/paz54Z1IpoPAYc/k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iM7v6lrtCyGrzz0pIGl/zwj9lAMS9FibDHGEHz6Tt9SzVEaSyTbzJB4g3qF34kdr0Sq77oY+1CHWTVM1m84RlHQPOkGl0bYRgoVky7Kn/3hYQz7ZLa0QuwzTMG6bBRrS+NBolMblIO8rgvd8QbvpRhGKcLTBb/PE43XdubidGDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,4.19.x 18/40] netfilter: nft_set_rbtree: use read spinlock to avoid datapath contention
Date: Thu, 13 Jun 2024 03:01:47 +0200
Message-Id: <20240613010209.104423-19-pablo@netfilter.org>
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

commit 96b33300fba880ec0eafcf3d82486f3463b4b6da upstream.

rbtree GC does not modify the datastructure, instead it collects expired
elements and it enqueues a GC transaction. Use a read spinlock instead
to avoid data contention while GC worker is running.

Fixes: f6c383b8c31a ("netfilter: nf_tables: adapt set backend to use GC transaction API")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_rbtree.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 8bda3f25360b..69fb57f6a23f 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -629,8 +629,7 @@ static void nft_rbtree_gc(struct work_struct *work)
 	if (!gc)
 		goto done;
 
-	write_lock_bh(&priv->lock);
-	write_seqcount_begin(&priv->count);
+	read_lock_bh(&priv->lock);
 	for (node = rb_first(&priv->root); node != NULL; node = rb_next(node)) {
 
 		/* Ruleset has been updated, try later. */
@@ -679,8 +678,7 @@ static void nft_rbtree_gc(struct work_struct *work)
 	}
 
 try_later:
-	write_seqcount_end(&priv->count);
-	write_unlock_bh(&priv->lock);
+	read_unlock_bh(&priv->lock);
 
 	if (gc)
 		nft_trans_gc_queue_async_done(gc);
-- 
2.30.2

