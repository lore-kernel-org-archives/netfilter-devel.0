From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/6] Netfilter fixes for net
Date: Mon,  9 Jul 2018 19:18:58 +0200
Message-ID: <20180709171904.2460-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter fixes for your net tree:

1) Missing module autoloadfor icmp and icmpv6 x_tables matches,
   from Florian Westphal.

2) Possible non-linear access to TCP header from tproxy, from
   Mate Eckl.

3) Do not allow rbtree to be used for single elements, this patch
   moves all set backend into one single module since such thing
   can only happen if hashtable module is explicitly blacklisted,
   which should not ever be done.

4) Reject error and standard targets from nft_compat for sanity
   reasons, they are never used from there.

5) Don't crash on double hashsize module parameter, from Andrey
   Ryabinin.

6) Drop dst on skb before placing it in the fragmentation
   reassembly queue, from Florian Westphal.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

----------------------------------------------------------------

The following changes since commit d461e3da905332189aad546b2ad9adbe6071c7cc:

  smsc75xx: Add workaround for gigabit link up hardware errata. (2018-07-04 22:12:59 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 84379c9afe011020e797e3f50a662b08a6355dcf:

  netfilter: ipv6: nf_defrag: drop skb dst before queueing (2018-07-09 18:04:12 +0200)

----------------------------------------------------------------
Andrey Ryabinin (1):
      netfilter: nf_conntrack: Fix possible possible crash on module loading.

Florian Westphal (3):
      netfilter: x_tables: set module owner for icmp(6) matches
      netfilter: nft_compat: explicitly reject ERROR and standard target
      netfilter: ipv6: nf_defrag: drop skb dst before queueing

Máté Eckl (1):
      netfilter: nf_tproxy: fix possible non-linear access to transport header

Pablo Neira Ayuso (1):
      netfilter: nf_tables: place all set backends in one single module

 include/net/netfilter/nf_tables_core.h  |  6 ++++++
 include/net/netfilter/nf_tproxy.h       |  4 ++--
 net/ipv4/netfilter/ip_tables.c          |  1 +
 net/ipv4/netfilter/nf_tproxy_ipv4.c     | 18 ++++++++++++------
 net/ipv6/netfilter/ip6_tables.c         |  1 +
 net/ipv6/netfilter/nf_conntrack_reasm.c |  2 ++
 net/ipv6/netfilter/nf_tproxy_ipv6.c     | 18 ++++++++++++------
 net/netfilter/Kconfig                   | 25 +++++++------------------
 net/netfilter/Makefile                  |  7 ++++---
 net/netfilter/nf_conntrack_core.c       |  2 +-
 net/netfilter/nf_tables_set_core.c      | 28 ++++++++++++++++++++++++++++
 net/netfilter/nft_compat.c              | 13 +++++++++++++
 net/netfilter/nft_set_bitmap.c          | 19 +------------------
 net/netfilter/nft_set_hash.c            | 29 +++--------------------------
 net/netfilter/nft_set_rbtree.c          | 19 +------------------
 net/netfilter/xt_TPROXY.c               |  8 ++++----
 16 files changed, 98 insertions(+), 102 deletions(-)
 create mode 100644 net/netfilter/nf_tables_set_core.c
