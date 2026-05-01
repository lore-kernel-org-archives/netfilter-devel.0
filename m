Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA772C0299;
	Fri,  1 May 2026 12:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777638166; cv=none; b=cqWe1b9FNv2C5HjDr56C57GCLcdAqtjYWMtc93wG7lbC48l2kXOIHzf5Zswtifws2rLNNqNpRsykxar0nQvfn7lyzdxbX4g1VvrXiFZXKy52nuEZNzhGZpIKSqmYUlp4s05QhyosFtVt7hp905Oh5d8E9kqckLf01kjan+ssJBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777638166; c=relaxed/simple;
	bh=x+jo6M4gpez/T9wNfinw4JPM0YFJ/ocRTT+SsiIfYSw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HGr8AtyUa/g5PhGlMzpFGR4nCCLcKA8nzoOSYpbykf2e+UplIdSsrekAr0vC3W91a9RhHNxZNplpdNlldPkFHn6kjIA0j58agTWTsvI3GMQXo/9oRLnMdhw0tollfEG6Am9kbiEYmaMD0pfppwrsFcfr240sIkneWEl55pX+vBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UWr9/9b9; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UWr9/9b9"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AA401600B9;
	Fri,  1 May 2026 14:22:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777638162;
	bh=jZZJvItWoQZw+BJX7xl0B7sj/2R/wM6H+07bOlYl3so=;
	h=From:To:Cc:Subject:Date:From;
	b=UWr9/9b9ZaJOUWILXVpebhrcF0wK4r8BwFT9LyL/8j7e9NrwDhtzbnjkyKToKx50y
	 3nKsRxKzkNDt145CXfpNPjJ1VKmqsnxTTsLuhepllCilqAkA6OoB8AaxCNAbbOL7hv
	 Gi385L6SqHzsXW/s19vtWbmHbzKV3RfOicERLrydHeNg1goXyp6BX9OoXZ/ef6hIMo
	 x6xbt8NTSu2/SUOG1HfI2TqGOos8OTXEc1X9DgaV80uI9XD12f1r/FJQR5mFMDoKTl
	 FGmpOlAog4AQqdDsDqcPtk9inOqT4daanHdLXwa8FiyK6xZnckb3L6z1YkEWpUv71G
	 LY6YU/jTuVNow==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 00/14] Netfilter fixes for net
Date: Fri,  1 May 2026 14:22:23 +0200
Message-ID: <20260501122237.296262-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following batch contains Netfilter fixes for net:

1) Replace skb_try_make_writable() by skb_ensure_writable() in
   nft_fwd_netdev and the flowtable to deal with uncloned packets
   having their network header in paged fragments.

2) Drop packet if output device does not exist and ensure sufficient
   headroom in nft_fwd_netdev before transmitting the skb.

3) Use the existing dup recursion counter in nft_fwd_netdev for the
   neigh_xmit variant, from Weiming Shi.

4) Add .check_hooks interface to x_tables to detach the control plane
   hook check based on the match/target configuration. Then, update
   nft_compat to use .check_hooks from .validate path, this fixes a
   lack of hook validation for several match/targets.

5) Fix incorrect .usersize in xt_CT, from Florian Westphal.

6) Fix a memleak with netdev tables in dormant state,
   from Florian Westphal.

7) Several patches to check if the packet is a fragment, then skip
   layer 4 inspection, for x_tables and nf_tables; as well as common
   nf_socket infrastructure. The xt_hashlimit match drops fragments
   to stay consistent with the existing approach when failing to parse
   the layer 4 protocol header.

8) Ensure sufficient headroom in the flowtable before transmitting
   the skb.

9) Fix the flowtable inline vlan approach for double-tagged vlan:
   Reverse the iteration over .encap[] since it represents the
   encapsulation as seen from the ingress path. Postpone pushing
   layer 2 header so output device is available to calculate needed
   headroom. Finally, add and use nf_flow_vlan_push() to fix it.

10) Fix flowtable inline pppoe with GSO packets. Moreover, use
    FLOW_OFFLOAD_XMIT_DIRECT to fill up destination hardware
    address since neighbour cache does not exist in pppoe.

11) Use skb_pull_rcsum() to decapsulate vlan and pppoe headers, for
    double-tagged vlan in particular this should provide some benefits
    in certain scenarios.

More notes regarding 9-11):

- sashiko is also signalling to use it for IPIP headers, but that needs
  more adjustments such setting skb->protocol after removing the IPIP
  header, will follow up in a separated patch.
- I plan to submit selftests to cover double-tagged-vlan. As for pppoe,
  it should be possible but that would mandate a few userspace dependencies.
  This has been semi-automatically  tested by me and reporters describing
  broken double-vlan-tagged and pppoe currently in the flowtable.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-05-01

Thanks.

----------------------------------------------------------------

The following changes since commit 0c7a5ba011d336df4fcd1f667fcc16ea5549be12:

  Merge branch 'mptcp-misc-fixes-for-v7-1-rc2' (2026-04-28 18:36:29 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-05-01

for you to fetch changes up to baa3c65435fb3f450b262672bc06db887a92d397:

  netfilter: flowtable: use skb_pull_rcsum() to pop vlan/pppoe header (2026-05-01 12:39:23 +0200)

----------------------------------------------------------------
netfilter pull request 26-05-01

----------------------------------------------------------------
Fernando Fernandez Mancera (3):
      netfilter: nf_socket: skip socket lookup for non-first fragments
      netfilter: nf_tables: skip L4 header parsing for non-first fragments
      netfilter: xtables: fix L4 header parsing for non-first fragments

Florian Westphal (2):
      netfilter: xt_CT: fix usersize for v1 and v2 revision
      netfilter: nf_tables: fix netdev hook allocation memleak with dormant tables

Pablo Neira Ayuso (8):
      netfilter: replace skb_try_make_writable() by skb_ensure_writable()
      netfilter: nft_fwd_netdev: add device and headroom validate with neigh forwarding
      netfilter: x_tables: add .check_hooks to matches and targets
      netfilter: nft_compat: run xt_check_hooks_{match,target}() from .validate
      netfilter: flowtable: ensure sufficient headroom in xmit path
      netfilter: flowtable: fix inline vlan encapsulation in xmit path
      netfilter: flowtable: fix inline pppoe encapsulation in xmit path
      netfilter: flowtable: use skb_pull_rcsum() to pop vlan/pppoe header

Weiming Shi (1):
      netfilter: nft_fwd_netdev: use recursion counter in neigh egress path

 include/linux/netfilter/x_tables.h    |   8 ++
 include/net/netfilter/nf_dup_netdev.h |  13 +++
 include/net/netfilter/nf_flow_table.h |   4 +-
 net/ipv4/netfilter/nf_socket_ipv4.c   |   3 +
 net/ipv6/netfilter/nf_socket_ipv6.c   |   5 +-
 net/netfilter/nf_dup_netdev.c         |  16 ----
 net/netfilter/nf_flow_table_core.c    |   1 +
 net/netfilter/nf_flow_table_ip.c      | 151 ++++++++++++++++++++++++++--------
 net/netfilter/nf_flow_table_path.c    |   7 +-
 net/netfilter/nf_tables_api.c         |  35 ++++----
 net/netfilter/nf_tables_core.c        |   2 +-
 net/netfilter/nft_compat.c            |  45 +++++++---
 net/netfilter/nft_exthdr.c            |   2 +-
 net/netfilter/nft_fwd_netdev.c        |  29 ++++++-
 net/netfilter/nft_osf.c               |   2 +-
 net/netfilter/nft_tproxy.c            |   8 +-
 net/netfilter/x_tables.c              |  79 ++++++++++++++++--
 net/netfilter/xt_CT.c                 |   8 +-
 net/netfilter/xt_TCPMSS.c             |  33 ++++----
 net/netfilter/xt_TPROXY.c             |  11 ++-
 net/netfilter/xt_addrtype.c           |  25 ++++--
 net/netfilter/xt_devgroup.c           |  18 ++--
 net/netfilter/xt_ecn.c                |   4 +
 net/netfilter/xt_hashlimit.c          |   4 +-
 net/netfilter/xt_osf.c                |   3 +
 net/netfilter/xt_physdev.c            |  20 +++--
 net/netfilter/xt_policy.c             |  24 ++++--
 net/netfilter/xt_set.c                |  39 +++++----
 net/netfilter/xt_tcpmss.c             |   4 +
 29 files changed, 447 insertions(+), 156 deletions(-)
