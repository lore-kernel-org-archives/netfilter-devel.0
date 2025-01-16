Received: from mail.netfilter.org (unknown [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9CEB22DC49;
	Thu, 16 Jan 2025 17:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737047961; cv=none; b=C9ggl4H8n6P/uDiPLM4qVEhVOBbs3QUbMkm6xLXyim6r2PIEz4KKH7PPRG4QpWIwg9AQ/ZPnq+ZNpsHwUy+zGbaBWzUprMJZwjYTgPKSm3889fc+fM9/a1WjOaBRrSbuj2sx5iimEiYC62Oo2MDb53LHJBsftvhmzhlIlQrn9Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737047961; c=relaxed/simple;
	bh=ZqRPox1nnhKrUsxW2lG/Oo6fKK4L/00h6UYGchpMDmY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Y+G3YHZeAdr0nZ00NKbqbedJA0wpVw4InJ7emMTElGO5jmN18LG8GiFHqZn/SwdhvWkF1FX2Ffq8faegB5QhCN5rKj5XLmsEAHILp1kvPCaok2OUZALCr57GYuBX7fXoinQc/wEzW2dk6XJLofESPi1hicMo0PrBXhoA9nxR8+s=
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
Subject: [PATCH net-next 00/14] Netfilter updates for net-next
Date: Thu, 16 Jan 2025 18:18:48 +0100
Message-Id: <20250116171902.1783620-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following batch contains Netfilter updates for net-next:

1) Unbreak set size settings for rbtree set backend, intervals in
   rbtree are represented as two elements, this detailed is leaked
   to userspace leading to bogus ENOSPC from control plane.

2) Remove dead code in br_netfilter's br_nf_pre_routing_finish()
   due to never matching error when looking up for route,
   from Antoine Tenart.

3) Simplify check for device already in use in flowtable,
   from Phil Sutter.

4) Three patches to restore interface name field in struct nft_hook
   and use it, this is to prepare for wildcard interface support.
   From Phil Sutter.

5) Do not remove netdev basechain when last device is gone, this is
   for consistency with the flowtable behaviour. This allows for netdev
   basechains without devices. Another patch to simplify netdev event
   notifier after this update. Also from Phil.

6) Two patches to add missing spinlock when flowtable updates TCP
   state flags, from Florian Westphal.

7) Simplify __nf_ct_refresh_acct() by removing skbuff parameter,
   also from Florian.

8) Flowtable gc now extends ct timeout for offloaded flow. This
   is to address a possible race that leads to handing over flow
   to classic path with long ct timeouts.

9) Tear down flow if cached rt_mtu is stale, before this patch,
   packet is handed over to classic path but flow entry still remained
   in place.

10) Revisit flowtable teardown strategy, that is originally conceived
    to release flowtable hardware entries early. Add a new CLOSING flag
    which still allows hardware to release entries when fin/rst from
    hardware, but keep flow entry in place when the TCP connection is
    shutting down. Release the flow after the timeout expires or a new
    syn packet for TCP reopen scenario is seen.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-25-01-16

Thanks.

----------------------------------------------------------------

The following changes since commit 9c7ad35632297edc08d0f2c7b599137e9fb5f9ff:

  Merge branch 'arrange-pse-core-and-update-tps23881-driver' (2025-01-14 13:56:37 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-25-01-16

for you to fetch changes up to e8dcdaa9dec9475f0a156cc998d40552cff071d7:

  netfilter: flowtable: add CLOSING state (2025-01-15 17:21:03 +0100)

----------------------------------------------------------------
netfilter pull request 25-01-16

----------------------------------------------------------------
Antoine Tenart (1):
      netfilter: br_netfilter: remove unused conditional and dead code

Florian Westphal (4):
      netfilter: nft_flow_offload: clear tcp MAXACK flag before moving to slowpath
      netfilter: nft_flow_offload: update tcp state flags under lock
      netfilter: conntrack: remove skb argument from nf_ct_refresh
      netfilter: conntrack: rework offload nf_conn timeout extension logic

Pablo Neira Ayuso (3):
      netfilter: nf_tables: fix set size with rbtree backend
      netfilter: flowtable: teardown flow if cached mtu is stale
      netfilter: flowtable: add CLOSING state

Phil Sutter (6):
      netfilter: nf_tables: Flowtable hook's pf value never varies
      netfilter: nf_tables: Store user-defined hook ifname
      netfilter: nf_tables: Use stored ifname in netdev hook dumps
      netfilter: nf_tables: Compare netdev hooks based on stored name
      netfilter: nf_tables: Tolerate chains with no remaining hooks
      netfilter: nf_tables: Simplify chain netdev notifier

 include/net/netfilter/nf_conntrack.h   |  18 +---
 include/net/netfilter/nf_flow_table.h  |   1 +
 include/net/netfilter/nf_tables.h      |   7 +-
 net/bridge/br_netfilter_hooks.c        |  30 +-----
 net/netfilter/nf_conntrack_amanda.c    |   2 +-
 net/netfilter/nf_conntrack_broadcast.c |   2 +-
 net/netfilter/nf_conntrack_core.c      |  13 +--
 net/netfilter/nf_conntrack_h323_main.c |   4 +-
 net/netfilter/nf_conntrack_sip.c       |   4 +-
 net/netfilter/nf_flow_table_core.c     | 183 +++++++++++++++++++++++++++++----
 net/netfilter/nf_flow_table_ip.c       |  14 ++-
 net/netfilter/nf_tables_api.c          | 123 +++++++++++-----------
 net/netfilter/nft_chain_filter.c       |  48 +++------
 net/netfilter/nft_ct.c                 |   2 +-
 net/netfilter/nft_flow_offload.c       |  16 ++-
 net/netfilter/nft_set_rbtree.c         |  43 ++++++++
 16 files changed, 325 insertions(+), 185 deletions(-)
