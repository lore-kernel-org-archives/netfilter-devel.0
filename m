Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4BB93F4841
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Jun 2026 13:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780665094; cv=none; b=hhUaRjCDPD0dJczh62DP7nUnugToRnKrTCOYTqvdXmKTHIMOJGCmp7sxcIG5UcTiNmeS+j6XwBpk4VnewD615rM/0J4yBjSSPghFwE089MTRxoNOCqojhv6kxd4UKUEwNkizveeq6ejjieFf50cHU15+bzqtZBt9P6zrKaPyLd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780665094; c=relaxed/simple;
	bh=irtgDx6semsLwai5PglCFEbzAWWpVyHHsX17tk/MRZY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=phFV+yBQ5ITNv/j8yO+bbWpFUi6Qj79zrsbClFeXohpH4nZnBYY+dc7RhthyY+EGJttIESZHq377pF7aim4FyUUIrv1RrN0T2GwA3ArDXFomctrWAarn0ekTA+8tRlsmWSOHvMigIDpZSsP0BkC72rksodhSmvnnzphrb+w9qkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B0E9460425; Fri, 05 Jun 2026 15:11:30 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v4 0/5] netfilter: nf_conncount: fix gc and rbtree bugs
Date: Fri,  5 Jun 2026 15:11:18 +0200
Message-ID: <20260605131123.19435-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v4: address even more drive by findings:
    - must switch to kzalloc, atm initial bitmap is random at start
      (which is harmless but wrong)
    - PREEMPT_RT needs seqcnt <-> spinlock association so preemption
      is disabled

1) Extend RCU read lock scope in ovs, conncount API requires this.
   rcu_dereference_raw should not have been used here.
   Note this adds new sparse warnings, but those are the lesser
   evil; lockdep support is more desirable wrt. rcu access correctness
   than sparse.

2) Replace rb_root with a new container structure in nf_conncount. Assign
   dedicated locks to each tree instead of a shared lock array. Use kvzalloc
   to ensure zero-initialized memory.

3) Split the count_tree_node rbtree walk into a helper. Add find_tree_node()
   to fetch matching rbtree nodes.

4) Add sequence counter to nf_conncount to detect tree modifications. Re-do
   lookups under lock if the counter changes. Prevent unsafe lockless
   iteration.

5) Fix tree_gc_worker wrap-around and protect rbtree iteration with a
   spinlock. Use disable_work_sync() and add rcu_barrier() to module exit.

Florian Westphal (5):
  netfilter: nf_conncount: callers must hold rcu read lock
  netfilter: nf_conncount: use per nf_conncount_data spinlocks
  netfilter: nf_conncount: split count_tree_node rbtree walk into helper
  netfilter: nf_conncount: add sequence counter to detect tree modifications
  netfilter: nf_conncount: gc and rcu fixes

 net/netfilter/nf_conncount.c | 230 ++++++++++++++++++++++-------------
 net/openvswitch/conntrack.c  |   2 +-
 2 files changed, 144 insertions(+), 88 deletions(-)

-- 
2.53.0

