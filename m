Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B7A325495
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Jun 2026 23:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780527989; cv=none; b=aXRT0hrdv0mdwYMGfSFw398Ifz5f4EaGZF9QfXhR6U86UqQtG0sADTnEgsuMpo7RWRzCx/2WTvl0iDPTCU0m+TSY8GPT8FIndI2FqpG5LM92fxhUnAq278ir5zAkq0eJBDstumBm5/PGctLijZTQX57/ZQ3Dl8f27nyYFCTicIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780527989; c=relaxed/simple;
	bh=/5+80TdBiGSRzNme2YUQ5Z11eDHeT0HQJ59wYyopiWY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AbuRNkybEonW44f3BzbyJ+fxDR9nzfTdKKWRjDPQdA6xi7BFFF2E+eyhXUzTDzkWkEUu6OZv5FmmaNTDBzJaSk0iyyPN9/fO3bbklcuLrMRHVJl0gJTVFE46l8ktxDIMuPAtcGKdhtHHndsIWyIs6sbstL8X+gLJz6R+8N/IjWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 85AA0605BD; Thu, 04 Jun 2026 01:06:19 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf-next 0/4] netfilter: nf_conncount: fix gc and
Date: Thu,  4 Jun 2026 01:05:59 +0200
Message-ID: <20260603230610.7900-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This addresses a drive-by AI review of nf_conncount.  See patch 4 for
details.

1) Replace rb_root with a new container structure in nf_conncount to prepare
   for a per-tree sequence counter to detect concurrent modifications.

2) Split nf_conncount rbtree walk into a helper. Add find_tree_node() to
   fetch matching node so folluwp patch can reuse the function.

3) Add a sequence count to detect concurrent rbtree modifications.

4) Fix tree_gc_worker wrap-around by updating gc_tree unconditionally.
   Add rcu_barrier before zapping the kmem cache during module exit.

Florian Westphal (4):
  netfilter: nf_conncount: prepare for per-tree seqcount
  netfilter: nf_conncount: split count_tree_node rbtree walk into helper
  netfilter: nf_conncount: add sequence counter to detect tree
    modifications
  netfilter: nf_conncount: gc and rcu fixes

 net/netfilter/nf_conncount.c | 203 ++++++++++++++++++++++-------------
 1 file changed, 130 insertions(+), 73 deletions(-)

-- 
2.53.0
