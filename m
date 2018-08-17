From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 00/15] Netfilter/IPVS fixes for net
Date: Fri, 17 Aug 2018 21:38:35 +0200
Message-ID: <20180817193850.2796-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter/IPVS fixes for your net tree:

1) Infinite loop in IPVS when net namespace is released, from
   Tan Hu.

2) Do not show negative timeouts in ip_vs_conn by using the new
   jiffies_delta_to_msecs(), patches from Matteo Croce.

3) Set F_IFACE flag for linklocal addresses in ip6t_rpfilter,
   from Florian Westphal.

4) Fix overflow in set size allocation, from Taehee Yoo.

5) Use netlink_dump_start() from ctnetlink to fix memleak from
   the error path, again from Florian.

6) Register nfnetlink_subsys in last place, otherwise netns
   init path may lose race and see net->nft uninitialized data.
   This also reverts previous attempt to fix this by increase
   netns refcount, patches from Florian.

7) Remove conntrack entries on layer 4 protocol tracker module
   removal, from Florian.

8) Use GFP_KERNEL_ACCOUNT for xtables blob allocation, from
   Michal Hocko.

9) Get tproxy documentation in sync with existing codebase,
   from Mate Eckl.

10) Honor preset layer 3 protocol via ctx->family in the new nft_ct
    timeout infrastructure, from Harsha Sharma.

11) Let uapi nfnetlink_osf.h compile standalone with no errors,
    from Dmitry V. Levin.

12) Missing braces compilation warning in nft_tproxy, patch from
    Mate Eclk.

13) Disregard bogus check to bail out on non-anonymous sets from
    the dynamic set update extension.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 9a76aba02a37718242d7cdc294f0a3901928aa57:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next (2018-08-15 15:04:25 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to feb9f55c33e5114127238a2c87c069b4f30d1f23:

  netfilter: nft_dynset: allow dynamic updates of non-anonymous set (2018-08-16 19:37:11 +0200)

----------------------------------------------------------------
Dmitry V. Levin (1):
      netfilter: uapi: fix linux/netfilter/nf_osf.h userspace compilation errors

Florian Westphal (5):
      netfilter: ip6t_rpfilter: set F_IFACE for linklocal addresses
      netfilter: fix memory leaks on netlink_dump_start error
      netfilter: nf_tables: fix register ordering
      netfilter: nf_tables: don't prevent event handler from device cleanup on netns exit
      netfilter: conntrack: fix removal of conntrack entries when l4tracker is removed

Harsha Sharma (1):
      netfilter: nft_ct: make l3 protocol field optional for timeout object

Matteo Croce (2):
      jiffies: add utility function to calculate delta in ms
      ipvs: don't show negative times in ip_vs_conn

Michal Hocko (1):
      netfilter: x_tables: do not fail xt_alloc_table_info too easilly

Máté Eckl (2):
      netfilter: doc: Add nf_tables part in tproxy.txt
      netfilter: nft_tproxy: Fix missing-braces warning

Pablo Neira Ayuso (1):
      netfilter: nft_dynset: allow dynamic updates of non-anonymous set

Taehee Yoo (1):
      netfilter: nft_set: fix allocation size overflow in privsize callback.

Tan Hu (1):
      ipvs: fix race between ip_vs_conn_new() and ip_vs_del_dest()

 Documentation/networking/tproxy.txt          | 34 ++++++++++++++++++++-----
 include/linux/jiffies.h                      |  5 ++++
 include/net/netfilter/nf_tables.h            |  6 ++---
 include/uapi/linux/netfilter/nfnetlink_osf.h |  2 ++
 include/uapi/linux/netfilter/xt_osf.h        |  2 --
 net/ipv6/netfilter/ip6t_rpfilter.c           | 12 ++++++++-
 net/netfilter/ipvs/ip_vs_conn.c              | 22 ++++++++++------
 net/netfilter/ipvs/ip_vs_core.c              | 15 ++++++++---
 net/netfilter/nf_conntrack_netlink.c         | 26 ++++++++++++-------
 net/netfilter/nf_conntrack_proto.c           | 15 +++++++----
 net/netfilter/nf_tables_api.c                | 38 ++++++++++++++++++----------
 net/netfilter/nfnetlink_acct.c               | 29 ++++++++++-----------
 net/netfilter/nft_chain_filter.c             | 14 +++++-----
 net/netfilter/nft_ct.c                       |  7 ++---
 net/netfilter/nft_dynset.c                   |  2 --
 net/netfilter/nft_set_bitmap.c               |  6 ++---
 net/netfilter/nft_set_hash.c                 |  8 +++---
 net/netfilter/nft_set_rbtree.c               |  4 +--
 net/netfilter/nft_tproxy.c                   |  4 ++-
 net/netfilter/x_tables.c                     |  7 +----
 20 files changed, 163 insertions(+), 95 deletions(-)
