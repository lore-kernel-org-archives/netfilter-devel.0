Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFF22DA759
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jun 2026 15:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780585807; cv=none; b=fOyK1/tt4G3I5L2/O1RhPqbu4ltRIHizalqfu0MLMxm3CNem7rh7TgB62RSPWC6U9HvtdB13suUUwE9I3g9XzLQ0fmf8vvEdp+Me01LKZmwLzvM1csP0UuHHbwIPF+/Z/0jqpwj49fnBslikdFiK/dQDh2a8Qswx+zZfzMvZFV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780585807; c=relaxed/simple;
	bh=DKxgu0u1hviH3ZJocQ8DucuGjyx50qIkF8m3phC33II=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MvjlvNaMOmyNgTjWbqZkIFHgPD2iP2PV9djrkfoZlviv9Vae5i6/sadyMTh7htZ46M/JxOcsm97orSjauF5iUQsBEuoDUbasU9B+KaMfEuEEmG22XFBSL9j/ypGl4/BLQakT2ZEdlOW7eiOucO2FmcXr28UzSpDg6UJ0dOO2drQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6F88360337; Thu, 04 Jun 2026 17:10:04 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 nf-next 0/5] netfilter: nf_conncount: fix gc and rbtree bugs
Date: Thu,  4 Jun 2026 17:03:33 +0200
Message-ID: <20260604150338.163592-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This addresses a drive-by AI review of nf_conncount.  See patch 5 for
details.

v3: add patch 1, openvswitch breakage was not raised before.
    in patch 4, check seqcount before returning -ENOENT.
    No other changes.

1) conncount API assumes rcu read lock is held, openvswitch doesn't do
   that.  Fix this.

2) Replace rb_root with a new container structure in nf_conncount to prepare
   for a per-tree sequence counter to detect concurrent modifications.

3) Split nf_conncount rbtree walk into a helper. Add find_tree_node() to
   fetch matching node so folluwp patch can reuse the function.

4) Add a sequence count to detect concurrent rbtree modifications.

5) Move rbtree iteration under spinlock, lockless iteration is not safe.
   Do lock-break + resched + restart to not hold spinlock for too long.
   Add rcu_barrier before zapping the kmem cache during module exit.

Florian Westphal (5):
  netfilter: nf_conncount: callers must hold rcu read lock
  netfilter: nf_conncount: prepare for per-tree seqcount
  netfilter: nf_conncount: split count_tree_node rbtree walk into helper
  netfilter: nf_conncount: add sequence counter to detect tree
    modifications
  netfilter: nf_conncount: gc and rcu fixes

 net/netfilter/nf_conncount.c | 208 ++++++++++++++++++++++-------------
 net/openvswitch/conntrack.c  |   2 +-
 2 files changed, 135 insertions(+), 75 deletions(-)

-- 
2.54.0
