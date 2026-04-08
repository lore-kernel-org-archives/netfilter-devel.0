Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB69331A7B;
	Wed,  8 Apr 2026 16:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775666119; cv=none; b=Rp0Tx5yFkZch1Sa4lM2gaYh9qwZcwvgd9mJsh6nPL0ETmuE1ZsYXT4W2urw2cc59zu47xcVDAowQRDjMetdjH572r4NULdBj8bQxaoq4MmuXRUY1PdCP5WzMHtgLvQkDiK+6f/59cR27Xm2NsEmt0mASv/tg+2amvDZ2kBeAKq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775666119; c=relaxed/simple;
	bh=xebDANJS1qaiAVwhbW4aCjYdayt/kHgjH6bSpEIKVtE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TUxevWaP7dmQbKafxOaSErMhIliOea7Rj/SuzMvcCjvhjy6pGnPifrEuPtm6tnHq3k0VEfBBG5KRrT/iWprec0YvU2vq4z06Wz6biwpTUBaSHkWi2cq9eExJYU1o2yGaUKucOEVrxx9QVSA7PnDRCAGjkiatyb+anKiGhzXxCUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5BD6560560; Wed, 08 Apr 2026 18:35:15 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 0/7] netfilter updates for net
Date: Wed,  8 Apr 2026 18:35:05 +0200
Message-ID: <20260408163512.30537-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi.

This pull requests contain netfilter fixes for the *net* tree.
I only included crash fixes, as we're closer to a release, rest will
be handled via -next.

1) Fix a NULL pointer dereference in ip_vs_add_service error path, from
   Weiming Shi, bug added in 6.2 development cycle.

2) Don't leak kernel data bytes from allocator to userspace: nfnetlink_log
   needs to init the trailing NLMSG_DONE terminator. From Xiang Mei.

3) xt_multiport match lacks range validation, bogus userspace request will
   cause out-of-bounds read. From Ren Wei.

4) ip6t_eui64 match must reject packets with invalid mac header before
   calling eth_hdr. Make existing check unconditional.  From Zhengchuan
   Liang.

5) nft_ct timeout policies are free'd via kfree() while they may still
   be reachable by other cpus that process a conntrack object that
   uses such a timeout policy.  Existing reaping of entries is not
   sufficient because it doesn't wait for a grace period.  Use kfree_rcu().
   From Tuan Do.

6/7) Make nfnetlink_queue hash table per queue.  As-is we can hit a page
   fault in case underlying page of removed element was free'd.  Per-queue
   hash prevents parallel lookups.  This comes with a test case that
   demonstrates the bug, from Fernando Fernandez Mancera.

Please, pull these changes from:
The following changes since commit f821664dde29302e8450aa0597bf1e4c7c5b0a22:

  Merge branch 'seg6-fix-dst_cache-sharing-in-seg6-lwtunnel' (2026-04-07 20:21:00 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-04-08

for you to fetch changes up to dde1a6084c5ca9d143a562540d5453454d79ea15:

  selftests: nft_queue.sh: add a parallel stress test (2026-04-08 13:34:51 +0200)

----------------------------------------------------------------
netfilter pull request nf-26-04-08

----------------------------------------------------------------

Fernando Fernandez Mancera (1):
  selftests: nft_queue.sh: add a parallel stress test

Florian Westphal (1):
  netfilter: nfnetlink_queue: make hash table per queue

Ren Wei (1):
  netfilter: xt_multiport: validate range encoding in checkentry

Tuan Do (1):
  netfilter: nft_ct: fix use-after-free in timeout object destroy

Weiming Shi (1):
  ipvs: fix NULL deref in ip_vs_add_service error path

Xiang Mei (1):
  netfilter: nfnetlink_log: initialize nfgenmsg in NLMSG_DONE terminator

Zhengchuan Liang (1):
  netfilter: ip6t_eui64: reject invalid MAC header for all packets

 include/net/netfilter/nf_conntrack_timeout.h  |   1 +
 include/net/netfilter/nf_queue.h              |   1 -
 net/ipv6/netfilter/ip6t_eui64.c               |   3 +-
 net/netfilter/ipvs/ip_vs_ctl.c                |   1 -
 net/netfilter/nfnetlink_log.c                 |   8 +-
 net/netfilter/nfnetlink_queue.c               | 139 ++++++------------
 net/netfilter/nft_ct.c                        |   2 +-
 net/netfilter/xt_multiport.c                  |  34 ++++-
 .../selftests/net/netfilter/nf_queue.c        |  50 ++++++-
 .../selftests/net/netfilter/nft_queue.sh      |  83 +++++++++--
 10 files changed, 201 insertions(+), 121 deletions(-)
-- 
2.52.0
