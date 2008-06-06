From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 00/03: netfilter -stable update
Date: Fri,  6 Jun 2008 19:18:40 +0200 (MEST)
Message-ID: <20080606171839.28097.47793.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51317 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbYFFRSm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 13:18:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[ Sorry for the resend, I forgot to CC netfilter-devel ]

Following are three netfilter patches for -stable, fixing

- a NULL argument to kmem_cache_destroy() in a conntrack error
  path (would cause a BUG_ON)

- incorrect accounting of closed connections in the iptables connlimit match

- incorrect locking in IPv6 connection tracking defragmentation

Please apply, thanks.


 net/ipv6/netfilter/nf_conntrack_reasm.c |    8 +++++---
 net/netfilter/nf_conntrack_expect.c     |    4 ++--
 net/netfilter/xt_connlimit.c            |    3 ++-
 3 files changed, 9 insertions(+), 6 deletions(-)

Alexey Dobriyan (1):
      netfilter: nf_conntrack_expect: fix error path unwind in nf_conntrack_expect_init()

Dong Wei (1):
      netfilter: xt_connlimit: fix accouning when receive RST packet in ESTABLISHED state

Jarek Poplawski (1):
      netfilter: nf_conntrack_ipv6: fix inconsistent lock state in nf_ct_frag6_gather()
