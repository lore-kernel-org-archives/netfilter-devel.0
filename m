Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB703FE5F;
	Wed, 21 Feb 2024 11:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708515007; cv=none; b=eWOSLyzLpJEfGIEaWmNj1XAf1VZMQkd8BXLoRMJSJNwOtBW8EFypUybgQVzf6S4SDfTdKaeZofr4ZX1LVz4galCppLbW2cfYAhtSECjkpEgw4fJVF0mEIvErLknJ+DU/AoCn4G4dMKhSPRPgisX4xodnP7ELBRxytgBxguaOAv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708515007; c=relaxed/simple;
	bh=+BHc1OAdUgXjf5xunuA0CoXPKMUSdOst/gul8MZDbwc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Tpqqjj7/QgLrkpZhzx1GhKSJeuMJAXNkJpsqMRjdHCzT2J2GkzO7OhoOA9e2SGQMGElVqPJtWFnb0Nmxo7D0C/ZIyURvR7eVQOdL2crTskUDMiPT6Lflv65rENqW8AatPF3YGHs1zp9obiJyOZA502bQoJWZy2WcRA7qcXQJWNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rckn7-0003rh-NT; Wed, 21 Feb 2024 12:29:33 +0100
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>
Subject: [PATCH net-next 00/12] netfilter updates for net-next
Date: Wed, 21 Feb 2024 12:26:02 +0100
Message-ID: <20240221112637.5396-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This pull request contains updates for your *net-next* tree:

1. Prefer KMEM_CACHE() macro to create kmem caches, from Kunwu Chan.

Patches 2 and 3 consolidate nf_log NULL checks and introduces
extra boundary checks on family and type to make it clear that no out
of bounds access will happen.  No in-tree user currently passes such
values, but thats not clear from looking at the function.
From Pablo Neira Ayuso.

Patch 4, also from Pablo, gets rid of unneeded conditional in
nft_osf init function.

Patch 5, from myself, fixes erroneous Kconfig dependencies that
came in an earlier net-next pull request. This should get rid
of the xtables related build failure reports.

Patches 6 to 10 are an update to nftables' concatenated-ranges
set type to speed up element insertions.  This series also
compacts a few data structures and cleans up a few oddities such
as reliance on ZERO_SIZE_PTR when asking to allocate a set with
no elements. From myself.

Patches 11 moves the nf_reinject function from the netfilter core
(vmlinux) into the nfnetlink_queue backend, the only location where
this is called from. Also from myself.

Patch 12, from Kees Cook, switches xtables' compat layer to use
unsafe_memcpy because xt_entry_target cannot easily get converted
to a real flexible array (its UAPI and used inside other structs).

The following changes since commit b0117d136bb9e4a1facb7ce354e0580dde876f6b:

  Merge branch 'net-constify-device_type' (2024-02-21 09:45:24 +0000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-24-02-21

for you to fetch changes up to 26f4dac11775a1ca24e2605cb30e828d4dbdea93:

  netfilter: x_tables: Use unsafe_memcpy() for 0-sized destination (2024-02-21 12:03:22 +0100)

----------------------------------------------------------------
netfilter pr 2024-21-02

----------------------------------------------------------------
Florian Westphal (7):
      netfilter: xtables: fix up kconfig dependencies
      netfilter: nft_set_pipapo: constify lookup fn args where possible
      netfilter: nft_set_pipapo: do not rely on ZERO_SIZE_PTR
      netfilter: nft_set_pipapo: shrink data structures
      netfilter: nft_set_pipapo: speed up bulk element insertions
      netfilter: nft_set_pipapo: use GFP_KERNEL for insertions
      netfilter: move nf_reinject into nfnetlink_queue modules

Kees Cook (1):
      netfilter: x_tables: Use unsafe_memcpy() for 0-sized destination

Kunwu Chan (1):
      netfilter: expect: Simplify the allocation of slab caches in nf_conntrack_expect_init

Pablo Neira Ayuso (3):
      netfilter: nf_log: consolidate check for NULL logger in lookup function
      netfilter: nf_log: validate nf_logger_find_get()
      netfilter: nft_osf: simplify init path

 include/linux/netfilter.h           |   1 -
 include/net/netfilter/nf_queue.h    |   1 -
 net/ipv4/netfilter/Kconfig          |   3 +-
 net/netfilter/nf_conntrack_expect.c |   4 +-
 net/netfilter/nf_log.c              |   9 +-
 net/netfilter/nf_queue.c            | 106 --------------------
 net/netfilter/nfnetlink_queue.c     | 142 ++++++++++++++++++++++++++
 net/netfilter/nft_osf.c             |  11 +-
 net/netfilter/nft_set_pipapo.c      | 193 ++++++++++++++++++++++++++----------
 net/netfilter/nft_set_pipapo.h      |  37 +++----
 net/netfilter/nft_set_pipapo_avx2.c |  59 ++++++-----
 net/netfilter/utils.c               |  37 -------
 net/netfilter/x_tables.c            |   3 +-
 13 files changed, 346 insertions(+), 260 deletions(-)
