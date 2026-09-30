Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41F7448B9B;
	Wed, 30 Sep 2026 07:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754122; cv=none; b=ohp2prU/Dz7VPYSAgo126tOgSoHvqFWvd8bPHq+afejlYlCogCag7zBJY2O/4KVz4iFrkZS4y3/vGJC2BOYklUAO5NitgBkbTmtZI7RA/nldWZZcw4KPxJXLoM+suvplDmDzHKZ2OMuiRk7pMZ9LOTWG3bdgy9ySjoFEK76vE64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754122; c=relaxed/simple;
	bh=x6480Bkp4FMukmxr95Y6+aX959844cxgZnkNbjHndQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZOaSAJU+VG0EzTYxYzz6GOg8vkAT6Q9WsMJ3eK0FXfugleXpy45ibdguoI54x3iqsEWsPLE4kbJGqnV0guvKUn+oV/7jEOoTZYKSOYzDZQ4zTqwteEKDmT0s+lS5hfF9BTYDoY743UVdFab8Xrw6GDueRR0SWn5IvGEkw3QqpuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XJ7YojUb; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XJ7YojUb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790754116;
	bh=6l5thKv2kTDA338HhHiKkjI3Rp+ZkGjxPqRXLRQ8F/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XJ7YojUb9iLSdt8JP9vklf48+zQoWmN42ah3patcmi4cLWkNodb9/e9xEKyQ8T2vt
	 tSR/XhSeSNpX3zvlELnjLHc32s/EAePuMUieycJqT9p+U1OqSW2eHF6/IORS9XaRHq
	 xtiMQtge+Md1p0b68uFqIIwwSr8H8VmlM/MECp+9zCSKqjr6d30GSn0eB6W05ppEpq
	 W+Qjk1W5FvYcqLw17vjEDvm/MYZY9Fli05fSnYVhrh/PiKYVUSKP4K/0uXQk9RfmYo
	 ilSA0rpzcZYHq8M2Fh6j7H4yAV7Mcn9mKdsRE/f5rioPt9qxBeXPK2SzC+BVD5ZpiL
	 QJ3vx2hqwRgjg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BDA93606F6;
	Wed, 30 Sep 2026 09:41:55 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 07/10] netfilter: nft_set_rbtree: skip transaction elements during GC
Date: Wed, 30 Sep 2026 09:41:38 +0200
Message-ID: <20260930074142.298353-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260930074142.298353-1-pablo@netfilter.org>
References: <20260930074142.298353-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Weiming Shi <bestswngs@gmail.com>

Since nft_set_commit_update() runs set commit callbacks before processing
NEWSETELEM transactions, nft_rbtree_gc_scan() can observe elements added by
the transaction being committed.

The scan records an interval end in rbe_end without checking the element's
transaction state. A later, unrelated expired start then moves both
elements to the expired list. The synchronous GC queue can free the new end
element before the transaction subsequently activates it, causing a
use-after-free.

Only consider elements that are fully active in both generations. This
keeps transaction-state elements out of the GC scan and preserves interval
pairing across skipped elements.

KASAN reports:

  BUG: KASAN: slab-use-after-free in nft_setelem_activate
  nft_setelem_activate net/netfilter/nf_tables_api.c:7047
  nf_tables_commit net/netfilter/nf_tables_api.c:11137

  Allocated by task 130:
  nft_set_elem_init net/netfilter/nf_tables_api.c:6794
  nft_add_set_elem net/netfilter/nf_tables_api.c:7523

  Freed by task 130:
  nft_trans_gc_trans_free net/netfilter/nf_tables_api.c:10506
  rcu_core kernel/rcu/tree.c:2919

Fixes: 1e3b9e1c77fe ("netfilter: nf_tables: call set ops .commit when building new ruleset blob")
Reported-by: <co+ee5e50ef2670e5f4@bugs.sh>
Assisted-by: LLM
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_rbtree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 9894832281c4..12431b55752f 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -900,6 +900,8 @@ static void nft_rbtree_gc_scan(struct nft_set *set)
 		next = rb_next(node);
 
 		rbe = rb_entry(node, struct nft_rbtree_elem, node);
+		if (!nft_set_elem_active(&rbe->ext, NFT_GENMASK_ANY))
+			continue;
 
 		/* elements are reversed in the rbtree for historical reasons,
 		 * from highest to lowest value, that is why end element is
-- 
2.47.3

