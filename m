Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E33194151
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Oct 2024 09:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730281512; cv=none; b=p/w4//uANNVwUzgK3T64XtjWvj6ci/Wa2k6QzKSVVbS3hJopSctYfXL2c6OnRxIr9tDaxcoHNYr8D2jl0gqcuZZ+N0vW84OQX3/atVaf7YVprbha8B+3Tea+QS8q7iKY0Zv6gF9dHuCLTliQC1v9RW7tX/1HP12FXVkICY8dvU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730281512; c=relaxed/simple;
	bh=+9UBOcdC+Kr9klVcFnlE+w6hWhrO8MnYeenGhRabyoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tJqHGcQ6U+VzsZTxcvuffPaqoas3cfVWye9ir0x4pyJpExo/zQy3cJEalNwXKIulxlbBNw1YzGUFDU0dvT/pVH7StuDzIFhfT7FaXs2s9+SUzgSaLEyS/WtXuVrriYWD2pk1d1w0xJPrcooZeK5OjBrdORPo1m7e+cad3zShdFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1t65G9-0000l9-2Q; Wed, 30 Oct 2024 10:45:01 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf-next 0/7] netfilter: nf_tables: avoid PROVE_RCU_LIST splats
Date: Wed, 30 Oct 2024 10:40:37 +0100
Message-ID: <20241030094053.13118-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2: fix typo in commit message & fix inverted logic in patch 6.
No other changes.

Mathieu reported a lockdep splat on rule deletion with
CONFIG_RCU_LIST=y.

Unfortunately there are many more errors, and not all are false positives.

First patches pass lockdep_commit_lock_is_held() to the rcu list traversal
macro so that those splats are avoided.

The last two patches are real code change as opposed to
'pass the transaction mutex to relax rcu check':

Those two lists are not protected by transaction mutex so could be altered
in parallel.

Aside from context these patches could be applied in any order.

This targets nf-next because these are long-standing issues.

Florian Westphal (7):
  netfilter: nf_tables: avoid false-positive lockdep splat on rule
    deletion
  netfilter: nf_tables: avoid false-positive lockdep splats with sets
  netfilter: nf_tables: avoid false-positive lockdep splats with
    flowtables
  netfilter: nf_tables: avoid false-positive lockdep splats in set
    walker
  netfilter: nf_tables: avoid false-positive lockdep splats with
    basechain hook
  netfilter: nf_tables: must hold rcu read lock while iterating
    expression type list
  netfilter: nf_tables: must hold rcu read lock while iterating object
    type list

 include/net/netfilter/nf_tables.h |   3 +-
 net/netfilter/nf_tables_api.c     | 110 ++++++++++++++++++------------
 net/netfilter/nft_flow_offload.c  |   4 +-
 net/netfilter/nft_set_bitmap.c    |  10 +--
 net/netfilter/nft_set_hash.c      |   3 +-
 5 files changed, 79 insertions(+), 51 deletions(-)

-- 
2.45.2

