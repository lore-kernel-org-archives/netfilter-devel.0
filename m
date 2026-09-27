Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E815F3EB10D;
	Sun, 27 Sep 2026 22:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790546918; cv=none; b=qtk9NcvgBl5LlNU4YSV6PeX3jOSPW0Gz23XyrwNnLShjWg7xw18a/q+KK7Yi6GHx36TdOLVAPaK2H6VpTdxZAP3xBLyl+5XMyG9gu2arUzv09/DKAbTCOOt5D1LMsR0ptPVUyta8DK/osEIxpjTl+NNV2MlpTN2aNssugj4xUqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790546918; c=relaxed/simple;
	bh=x6480Bkp4FMukmxr95Y6+aX959844cxgZnkNbjHndQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NTkhiiRsWsj0c9XrnriFX7GM+Jk/u9u+FWRf2TLzS1225uJLDo/znWgbEM6gX2Mw2zicv7awA9jbVXRs1Y50YH3tgEzslA9z0Qnrj8LMEnCNaTNq24MDls+rD4rZdMFf9iiQPLA4KPKVs4yLHmcd4wC/XoXaaiBnNUDkAbYEQqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LC/40+tS; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LC/40+tS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790546911;
	bh=6l5thKv2kTDA338HhHiKkjI3Rp+ZkGjxPqRXLRQ8F/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LC/40+tSecYW8/9rKtgxXM+vv3dWYYCW1t7/5smFkS/qHKhgPsvkLo6l0beVd2qxN
	 nZVO8Eridl6reh8svQW04dpU0aEodPSLZGm2I50WxRBDIuGtqkpOCsKdO8EGLc6SSF
	 6JJBnquh7dnxPAP6air6P0QaudGh5c8g7fIeoqeCm8mVzi1BYK6E48uHknao4l10DG
	 4grbPl5wCVasu+pI7jsnJNuY1S5O0JeeIAo/1b3IZB35ejTdO7+4gIEmtIeivMMdUG
	 CUyX5LRhwmfhwKSlKgca9roncoBRbwgpRAatwoeTRIXQgEgVkJ3vZnNu6AecEVigYB
	 GzFXa3u68Z36A==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 67C6F603E4;
	Mon, 28 Sep 2026 00:08:31 +0200 (CEST)
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
Subject: [PATCH net 08/11] netfilter: nft_set_rbtree: skip transaction elements during GC
Date: Mon, 28 Sep 2026 00:08:13 +0200
Message-ID: <20260927220816.268206-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260927220816.268206-1-pablo@netfilter.org>
References: <20260927220816.268206-1-pablo@netfilter.org>
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

