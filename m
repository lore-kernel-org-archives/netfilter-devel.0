Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4501FC8
	for <netfilter-devel@vger.kernel.org>; Sat, 11 Apr 2026 11:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775908766; cv=none; b=qMIRK/wj++MFzfEDZHj0D/7GR5yvmhjI5ABu9qeVLn3mrQkln4ln4B+3Qv+DzOMseNKn47OuFXAt0e9JBfp4lsOZ/T00HHgc8YE1+pVDFhr4ksZPNN7T+XOyhdL52ch1XFbgaG3IdrwuCElArVjrFZrrVFnWusTvGHnvaDED/lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775908766; c=relaxed/simple;
	bh=Nc8a8KMu6UoVIaFgj/MdWkd+2jVQcXiKYnQvHoMNxI0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g/8IgFKvw241JjRlpiQoUhEff8hKunn00AWBZa4ujnaDC2nGve4RTDakVZFtb+y3pEESl4Cp0SKreqc2CpFkM+WE/g0+GzaOY5GvkcOgHERy/x9BeFBve8JSyYHZBXPVBZLgrsDF0h5FN4NSnY2UKRxzlW1TT5Ft3pv4uZ8Jvqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2D28B60491; Sat, 11 Apr 2026 13:59:17 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Dan Carpenter <error27@gmail.com>
Subject: [PATCH nf] netfilter: nft_set_rbtree: fix memory leak during insertion
Date: Sat, 11 Apr 2026 13:59:02 +0200
Message-ID: <20260411115908.1554282-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

net/netfilter/nft_set_rbtree.c:399 __nft_rbtree_insert()
        warn: 'removed_end' is not an error pointer

Delete this incorrect test, we only want to know if the current element
was reaped.

This causes early "return-0", signalling a successful insertion of the
element, but no insertion was done.

Fixes: 087388278e0f ("netfilter: nf_tables: nft_set_rbtree: fix spurious
		insertion failure")
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/netfilter-devel/adjSaolTji0mPgqx@stanley.mountain/
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_rbtree.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 737c339decd0..3407109d6a5c 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -396,9 +396,6 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			const struct nft_rbtree_elem *removed_end;
 
 			removed_end = nft_rbtree_gc_elem(set, priv, rbe);
-			if (IS_ERR(removed_end))
-				return PTR_ERR(removed_end);
-
 			if (removed_end == rbe_le || removed_end == rbe_ge)
 				return -EAGAIN;
 
-- 
2.53.0

