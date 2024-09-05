Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BAE4539A;
	Thu,  5 Sep 2024 23:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725578976; cv=none; b=F8Uoukv/JGmiHxRIMQ0CsoAH2rB4hWPRSLHUwDjVJROZz6+lwtI3ztrEgP4gTS6bNng0wE50wXyxrG/7DZBEQZwkGdWv9A1/VM0Ul+Rr6uvUnI7Dh8BxAUwYdSiyccgdE3sFvqFrO2nb7RyFloq9gFxmhU9wrMJ3gtFy61hfTx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725578976; c=relaxed/simple;
	bh=41NEfH6wtII/P1JwajZXEbPb4txWupZUbbh0ST+9Zo4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uTjlyDkpNwv9h2TT7jDJWC+5KcASJ2bNYO+5ZcaF1DdmyIIjtUgxz+HtTUDz4qfD5XnH3xLY4bjsbElYvlFHen4k73geb7FiFIMv2q6Zz+rLUe6zkuVUc2ck86MGdd6B/bBb2GNrRP3Jwx6wYWOlJFlhAfYFiVUBKqZ7pcQLW3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 00/16] Netfilter updates for net-next
Date: Fri,  6 Sep 2024 01:29:04 +0200
Message-Id: <20240905232920.5481-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

@netdev maintainers: Please, kindly allow me to exceed in one patch the
maximum series length, there are a few trivial oneliners in this series.

-o-

Hi,

The following patchset contains Netfilter updates for net-next:

Patch #1 adds ctnetlink support for kernel side filtering for
	 deletions, from Changliang Wu.

Patch #2 updates nft_counter support to Use u64_stats_t,
	 from Sebastian Andrzej Siewior.

Patch #3 uses kmemdup_array() in all xtables frontends,
	 from Yan Zhen.

Patch #4 is a oneliner to use ERR_CAST() in nf_conntrack instead
	 opencoded casting, from Shen Lichuan.

Patch #5 removes unused argument in nftables .validate interface,
	 from Florian Westphal.

Patch #6 is a oneliner to correct a typo in nftables kdoc,
	 from Simon Horman.

Patch #7 fixes missing kdoc in nftables, also from Simon.

Patch #8 updates nftables to handle timeout less than CONFIG_HZ.

Patch #9 rejects element expiration if timeout is zero,
	 otherwise it is silently ignored.

Patch #10 disallows element expiration larger than timeout.

Patch #11 removes unnecessary READ_ONCE annotation while mutex is held.

Patch #12 adds missing READ_ONCE/WRITE_ONCE annotation in dynset.

Patch #13 annotates data-races around element expiration.

Patch #14 allocates timeout and expiration in one single set element
	  extension, they are tighly couple, no reason to keep them
	  separated anymore.

Patch #15 updates nftables to interpret zero timeout element as never
	  times out. Note that it is already possible to declare sets
	  with elements that never time out but this generalizes to all
	  kind of set with timeouts.

Patch #16 supports for element timeout and expiration updates.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-24-09-06

Thanks.

----------------------------------------------------------------

The following changes since commit 55ddb6c5a3aef8d8658fe31b1ddda007693ae797:

  net: stmmac: drop the ethtool begin() callback (2024-09-02 13:44:09 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-24-09-06

for you to fetch changes up to 4201f3938914d8df3c761754b9726770c4225d66:

  netfilter: nf_tables: set element timeout update support (2024-09-03 18:19:44 +0200)

----------------------------------------------------------------
netfilter pull request 24-09-06

----------------------------------------------------------------
Changliang Wu (1):
      netfilter: ctnetlink: support CTA_FILTER for flush

Florian Westphal (1):
      netfilter: nf_tables: drop unused 3rd argument from validate callback ops

Pablo Neira Ayuso (9):
      netfilter: nf_tables: elements with timeout below CONFIG_HZ never expire
      netfilter: nf_tables: reject element expiration with no timeout
      netfilter: nf_tables: reject expiration higher than timeout
      netfilter: nf_tables: remove annotation to access set timeout while holding lock
      netfilter: nft_dynset: annotate data-races around set timeout
      netfilter: nf_tables: annotate data-races around element expiration
      netfilter: nf_tables: consolidate timeout extension for elements
      netfilter: nf_tables: zero timeout means element never times out
      netfilter: nf_tables: set element timeout update support

Sebastian Andrzej Siewior (1):
      netfilter: nft_counter: Use u64_stats_t for statistic.

Shen Lichuan (1):
      netfilter: conntrack: Convert to use ERR_CAST()

Simon Horman (2):
      netfilter: nf_tables: Correct spelling in nf_tables.h
      netfilter: nf_tables: Add missing Kernel doc

Yan Zhen (1):
      netfilter: Use kmemdup_array instead of kmemdup for multiple allocation

 include/net/netfilter/nf_tables.h        |  42 +++++++----
 include/net/netfilter/nf_tproxy.h        |   1 +
 include/net/netfilter/nft_fib.h          |   4 +-
 include/net/netfilter/nft_meta.h         |   3 +-
 include/net/netfilter/nft_reject.h       |   3 +-
 include/uapi/linux/netfilter/nf_tables.h |   2 +-
 net/bridge/netfilter/ebtables.c          |   2 +-
 net/bridge/netfilter/nft_meta_bridge.c   |   5 +-
 net/bridge/netfilter/nft_reject_bridge.c |   3 +-
 net/ipv4/netfilter/arp_tables.c          |   2 +-
 net/ipv4/netfilter/ip_tables.c           |   2 +-
 net/ipv6/netfilter/ip6_tables.c          |   2 +-
 net/netfilter/nf_conntrack_core.c        |   2 +-
 net/netfilter/nf_conntrack_netlink.c     |   9 +--
 net/netfilter/nf_nat_core.c              |   2 +-
 net/netfilter/nf_tables_api.c            | 126 ++++++++++++++++++++-----------
 net/netfilter/nft_compat.c               |   6 +-
 net/netfilter/nft_counter.c              |  90 +++++++++++-----------
 net/netfilter/nft_dynset.c               |  18 ++---
 net/netfilter/nft_fib.c                  |   3 +-
 net/netfilter/nft_flow_offload.c         |   3 +-
 net/netfilter/nft_fwd_netdev.c           |   3 +-
 net/netfilter/nft_immediate.c            |   3 +-
 net/netfilter/nft_lookup.c               |   3 +-
 net/netfilter/nft_masq.c                 |   3 +-
 net/netfilter/nft_meta.c                 |   6 +-
 net/netfilter/nft_nat.c                  |   3 +-
 net/netfilter/nft_osf.c                  |   3 +-
 net/netfilter/nft_queue.c                |   3 +-
 net/netfilter/nft_redir.c                |   3 +-
 net/netfilter/nft_reject.c               |   3 +-
 net/netfilter/nft_reject_inet.c          |   3 +-
 net/netfilter/nft_reject_netdev.c        |   3 +-
 net/netfilter/nft_rt.c                   |   3 +-
 net/netfilter/nft_socket.c               |   3 +-
 net/netfilter/nft_synproxy.c             |   3 +-
 net/netfilter/nft_tproxy.c               |   3 +-
 net/netfilter/nft_xfrm.c                 |   3 +-
 38 files changed, 206 insertions(+), 178 deletions(-)
