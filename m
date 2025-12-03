Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1C92D9484
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Dec 2025 09:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764752622; cv=none; b=OEp+/7MZo3R4lAcYz25oBRrfyjxpc3LGplMQv8ZIotLK4lKrCuzLUNplra8Pvi1oD3X+EBpTnrUYHzCQdSFT0x1Nk5aLD/mndnrTWw2r5WtyGh1usEfRfER4SYgJpS0Q9Av30ridZirW6FgP75HgFqV6x5X+1GjljTvDRN2x7e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764752622; c=relaxed/simple;
	bh=uFkPUJKO4OT9dYVsCnucOGrigjUssiYwJFj55eHgMqo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JPAdNaVzQgBYCAJTfX5NF5rBGQl7KkzIwkIZcjSXGTZBp9DFJFC5WHEnp2wpkH2JoM2OUczg5Xq/P6uN8sYgBfLVqd0axP6s527kDb0QkZfF/XmEzJN6qN0BRziX72RYxdpKoEWQXDW0d5lHS+CQW3O5yOTxQX5We8EWn35dOp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AD4BE60371; Wed, 03 Dec 2025 10:03:31 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf 0/3] netfilter: nft_set_rbtree: use cloned tree for insertions and removal
Date: Wed,  3 Dec 2025 10:03:12 +0100
Message-ID: <20251203090320.26905-1-fw@strlen.de>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Changes since v1:
 - rebase on nf
 - fix a sparse warning reported by kbuild robot

This series fixes false negative lookup bug in rbtree set backend that
can occur during transaction.

First two patches prepare for actual fix, which is coming in last patch.

All inserts/removals will now occur in a cloned copy, so packetpath can
no longer observe the problematic mixed-bag of old, current and new
elements.

The live tree will only have reachable elements that are active in the
current generation or were active in the previous generation (but are still
valid while packetpath holds rcu read lock).  The latter case is only
temporary, new lookups use the updated tree.

Florian Westphal (3):
  netfilter: nft_set_rbtree: prepare for two rbtrees
  netfilter: nft_set_rbtree: factor out insert helper
  netfilter: nft_set_rbtree: do not modifiy live tree

 net/netfilter/nft_set_rbtree.c | 290 ++++++++++++++++++++++++---------
 1 file changed, 215 insertions(+), 75 deletions(-)

-- 
2.51.2

