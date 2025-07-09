Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFB221FF24
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Jul 2025 17:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752080732; cv=none; b=JxVI7s7O14QNTpD2jlxBmA16zEUVNxRmzILHOdOc1Pw8RJVLxeFVBI6WyRMP3t0mQGvORPNOS1YFcgWtWFuUWD9ZykHVZu+w7otVbMh4cWKysi3DcZnoa5QsrYJ8NfJ/FcWAnLzqudAvCAwPuM8pxRi2hUXBF2aJ3Xm9dXw94vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752080732; c=relaxed/simple;
	bh=ZhWr2mqMFyXMEVt+z7VnzI699oSMR6kW++7bJA2RCrM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aRk5ZQKyMCJbSUAFoiz8zW1uc/YOEtE0AXLRMSee4EcguBEsJjR1pbhvShOcLlW5EP201vf3CnJIuB4nz1dGEQ8tyroDHHrAZriBtM0DpJ4L2YG6clvinxLQB1NBy/GNbuNhrIETGgB52HfSbrmE5q2cF6qXzaQ2K/cFTD5Gjlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id DFCB2607AC; Wed,  9 Jul 2025 19:05:27 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 0/5] netfilter: nft_set updates
Date: Wed,  9 Jul 2025 19:05:11 +0200
Message-ID: <20250709170521.11778-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2: minor kdoc updates.  I copied Stefanos RvB tags.

This series serves as preparation to make pipapos avx2 functions
available from the control plane.

First patch removes a few unused arguments.
Second and third patch simplify some of the set api functions.

The fourth patch is the main change, it removes the control-plane
only C implementation of the pipapo lookup algorithm.

The last patch allows the scratch maps to be backed by vmalloc.

Florian Westphal (5):
  netfilter: nft_set_pipapo: remove unused arguments
  netfilter: nft_set: remove one argument from lookup and update
    functions
  netfilter: nft_set: remove indirection from update API call
  netfilter: nft_set_pipapo: merge pipapo_get/lookup
  netfilter: nft_set_pipapo: prefer kvmalloc for scratch maps

 include/net/netfilter/nf_tables.h      |  14 +-
 include/net/netfilter/nf_tables_core.h |  50 +++---
 net/netfilter/nft_dynset.c             |  10 +-
 net/netfilter/nft_lookup.c             |  27 ++--
 net/netfilter/nft_objref.c             |   5 +-
 net/netfilter/nft_set_bitmap.c         |  11 +-
 net/netfilter/nft_set_hash.c           |  54 +++----
 net/netfilter/nft_set_pipapo.c         | 204 ++++++++-----------------
 net/netfilter/nft_set_pipapo_avx2.c    |  26 ++--
 net/netfilter/nft_set_rbtree.c         |  40 +++--
 10 files changed, 184 insertions(+), 257 deletions(-)

-- 
2.49.0

