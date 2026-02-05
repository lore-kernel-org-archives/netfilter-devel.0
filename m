Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F5438B7BF;
	Thu,  5 Feb 2026 11:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770289757; cv=none; b=bRkW4k6nD1OpZYjY0JFbmQQd0feyBUFcX4TPe4k/NScu/nmaMC2us+IhJB76dlMPr3WFJL2IQRmxcWvjnLny0pHYCCCe9axP1+XzzFMUzBHW4L9ZBIaRHhTUHSIfeoQkyKl0hvVCi3TQGpIVTGXjCQYpcxfJkp0sgV85uNbfgAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770289757; c=relaxed/simple;
	bh=fe04NyMiMj+RjrcWbcVeK3DrnZ7wUYaLLUR8t7Hzb7g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IfvCakio5Zi6Iins8AphbpkFGKNILT+I3NoPaEKzg7BLzewdHsj//21gvhTX/ObfOBD8e5XVw44HHkYG0m4UA9FRLG/RFX2V+OJWBeov2ircQLslFGCKtRQwdwt2DT7YXcY0HjgC7iNnhUIz4OWH5HbX/Cp5+FzwFe/D0N0QuYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D0B5560610; Thu, 05 Feb 2026 12:09:14 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 00/11] netfilter: updates for net-next
Date: Thu,  5 Feb 2026 12:08:54 +0100
Message-ID: <20260205110905.26629-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The following patchset contains Netfilter updates for *net-next*:

1) Fix net-next-only use-after-free bug in nf_tables rbtree set:
   Expired elements cannot be released right away after unlink anymore
   because there is no guarantee that the binary-search blob is going to
   be updated.  Spotted by syzkaller.

2) Fix esoteric bug in nf_queue with udp fraglist gro, broken since
   6.11. Patch 3 adds extends the nfqueue selftest for this.

4) Use dedicated slab for flowtable entries, currently the -512 cache
   is used, which is wasteful.  From Qingfang Deng.

5) Recent net-next update extended existing test for ip6ip6 tunnels, add
   the required /config entry.  Test still passed by accident because the
   previous tests network setup gets re-used, so also update the test so
   it will fail in case the ip6ip6 tunnel interface cannot be added.

6) Fix 'nft get element mytable myset { 1.2.3.4 }' on big endian
   platforms, this was broken since code was added in v5.1.

7-10) update nf_tables rbtree set type to detect partial
   operlaps.  This will eventually speed up nftables userspace: at this
   time userspace does a netlink dump of the set content which slows down
   incremental updates on interval sets.  From Pablo Neira Ayuso.

11) fixes nf_tables counter reset support on 32bit platforms, where counter
   reset may cause huge values to appear due to wraparound.
   Broken since reset feature was added in v6.11.  From Anders Grahn.

Please, pull these changes from:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-26-02-05

for you to fetch changes up to bd3aaea1ae36e2931ddb8e40464a4cd3cfa43bf6:

  netfilter: nft_counter: fix reset of counters on 32bit archs (2026-02-05 11:45:28 +0100)

----------------------------------------------------------------
netfilter pull request nf-next-26-02-05

----------------------------------------------------------------

Anders Grahn (1):
  netfilter: nft_counter: fix reset of counters on 32bit archs

Florian Westphal (5):
  netfilter: nft_set_rbtree: don't gc elements on insert
  netfilter: nfnetlink_queue: do shared-unconfirmed check before segmentation
  selftests: netfilter: nft_queue.sh: add udp fraglist gro test case
  selftests: netfilter: add IPV6_TUNNEL to config
  netfilter: nft_set_hash: fix get operation on big endian

Pablo Neira Ayuso (4):
  netfilter: nft_set_rbtree: fix bogus EEXIST with NLM_F_CREATE with null interval
  netfilter: nft_set_rbtree: check for partial overlaps in anonymous sets
  netfilter: nft_set_rbtree: validate element belonging to interval
  netfilter: nft_set_rbtree: validate open interval overlap

Qingfang Deng (1):
  netfilter: flowtable: dedicated slab for flow entry

 include/linux/u64_stats_sync.h                |  10 +
 include/net/netfilter/nf_queue.h              |   1 +
 include/net/netfilter/nf_tables.h             |   4 +
 net/netfilter/nf_flow_table_core.c            |  12 +-
 net/netfilter/nf_tables_api.c                 |  26 +-
 net/netfilter/nfnetlink_queue.c               | 123 +++---
 net/netfilter/nft_counter.c                   |   4 +-
 net/netfilter/nft_set_hash.c                  |   9 +-
 net/netfilter/nft_set_rbtree.c                | 376 ++++++++++++++----
 tools/testing/selftests/net/netfilter/config  |   1 +
 .../selftests/net/netfilter/nft_flowtable.sh  |  19 +-
 .../selftests/net/netfilter/nft_queue.sh      | 142 ++++++-
 12 files changed, 579 insertions(+), 148 deletions(-)

-- 
2.52.0
