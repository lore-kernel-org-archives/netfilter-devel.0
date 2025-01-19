Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FDAF2A1BF;
	Sun, 19 Jan 2025 17:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737307267; cv=none; b=V3CKOjGT9GF8MdP27xLabU5MexwvPVLENOHQAXEK0rfncjkOEs1W0WpiINy3Je0ka+zpWHMmRHX8CN41rHB6R6t+HDsZak+IbJtGVoQxgxGsVRCs5PISWyt6p7wLaSVla38jCdsKYALEKC0BrGzWv8r1VA3MX4ge+nXJT19tkuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737307267; c=relaxed/simple;
	bh=VI3PpbpjnbVsG3ydd3CT9VebcNHzpQ+pXosWMcAnVkI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VJpB+xYvxD/n84TANFD3L+86UaUXNFzX0s590M9ORzXqdtvfJC8qlT9Nk0SgL8PKSt7ane272EE00H5iRV/cQKJrtL7ErFWQO8tD38JPAW9fc9dJvjhJJFVun6CwzkVATWL3ZpUnM5i3h/PEFQd8gX2F3dC7ZwJXct7W2yZ1QXM=
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
Subject: [PATCH net-next,v2 00/14] Netfilter updates for net-next
Date: Sun, 19 Jan 2025 18:20:37 +0100
Message-Id: <20250119172051.8261-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2: - addressing kdoc issues reported by Simon Horman and Jakub Kicinski
      as well as missing SoB, related to patches 1/14, 2/14 and 8/14.
    - set on IP_CT_TCP_FLAG_CLOSE_INIT when setting _CLOSE
      conntrack state from flowtable in patch 14/14.

-o-

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

10) Revisit the flowtable teardown strategy, which was originally
    designed to release flowtable hardware entries early. Add a new
    CLOSING flag that still allows hardware to release entries when
    fin/rst is seen, but keeps the flow entry in place when the
    TCP connection is closed. Release flow after timeout or when a new
    syn packet is seen for TCP reopen scenario.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-25-01-19

Thanks.

----------------------------------------------------------------

The following changes since commit 9c7ad35632297edc08d0f2c7b599137e9fb5f9ff:

  Merge branch 'arrange-pse-core-and-update-tps23881-driver' (2025-01-14 13:56:37 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-25-01-19

for you to fetch changes up to fdbaf5163331342e90a2c29b87629021f4c15f0c:

  netfilter: flowtable: add CLOSING state (2025-01-19 16:41:56 +0100)

----------------------------------------------------------------
netfilter pull request 25-01-19

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
 include/net/netfilter/nf_tables.h      |  10 +-
 net/bridge/br_netfilter_hooks.c        |  30 +-----
 net/netfilter/nf_conntrack_amanda.c    |   2 +-
 net/netfilter/nf_conntrack_broadcast.c |   2 +-
 net/netfilter/nf_conntrack_core.c      |  13 +--
 net/netfilter/nf_conntrack_h323_main.c |   4 +-
 net/netfilter/nf_conntrack_sip.c       |   4 +-
 net/netfilter/nf_flow_table_core.c     | 187 +++++++++++++++++++++++++++++----
 net/netfilter/nf_flow_table_ip.c       |  14 ++-
 net/netfilter/nf_tables_api.c          | 123 ++++++++++++----------
 net/netfilter/nft_chain_filter.c       |  48 +++------
 net/netfilter/nft_ct.c                 |   2 +-
 net/netfilter/nft_flow_offload.c       |  16 ++-
 net/netfilter/nft_set_rbtree.c         |  43 ++++++++
 16 files changed, 332 insertions(+), 185 deletions(-)
