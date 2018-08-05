From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 00/21] Netfilter updates for net-next
Date: Sun,  5 Aug 2018 23:21:20 +0200
Message-ID: <20180805212141.3033-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter updates for your net-next tree:

1) Support for transparent proxying for nf_tables, from Mate Eckl.

2) Patchset to add OS passive fingerprint recognition for nf_tables,
   from Fernando Fernandez. This takes common code from xt_osf and
   place it into the new nfnetlink_osf module for codebase sharing.

3) Lightweight tunneling support for nf_tables.

4) meta and lookup are likely going to be used in rulesets, make them
   direct calls. From Florian Westphal.

A bunch of incremental updates:

5) use PTR_ERR_OR_ZERO() from nft_numgen, from YueHaibing.

6) Use kvmalloc_array() to allocate hashtables, from Li RongQing.

7) Explicit dependencies between nfnetlink_cttimeout and conntrack
   timeout extensions, from Harsha Sharma.

8) Simplify NLM_F_CREATE handling in nf_tables.

9) Removed unused variable in the get element command, from
   YueHaibing.

10) Expose bridge hook priorities through uapi, from Mate Eckl.

And a few fixes for previous Netfilter batch for net-next:

11) Use per-netns mutex from flowtable event, from Florian Westphal.

12) Remove explicit dependency on iptables CT target from conntrack
    zones, from Florian.

13) Fix use-after-free in rmmod nf_conntrack path, also from Florian.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks.

----------------------------------------------------------------

The following changes since commit ecbcd689d74a394b711d2360aef7e5d007ec9d98:

  Merge tag 'mlx5e-updates-2018-07-26' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2018-07-26 21:33:24 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 483f3fdcc70b3c3a1f314235ab0066f3dbd4cfbe:

  netfilter: nft_tunnel: fix sparse errors (2018-08-04 00:53:29 +0200)

----------------------------------------------------------------
Fernando Fernandez Mancera (5):
      netfilter: nf_osf: rename nf_osf.c to nfnetlink_osf.c
      netfilter: nfnetlink_osf: extract nfnetlink_subsystem code from xt_osf.c
      netfilter: nf_tables: implement Passive OS fingerprint module in nft_osf
      netfilter: nf_osf: move nf_osf_fingers to non-uapi header file
      netfilter: nfnetlink_osf: rename nf_osf header file to nfnetlink_osf

Florian Westphal (4):
      netfilter: nf_tables: handle meta/lookup with direct call
      netfilter: nf_tables: flow event notifier must use transaction mutex
      netfilter: kconfig: remove ct zone/label dependencies
      netfilter: conntrack: avoid use-after free on rmmod

Harsha Sharma (1):
      netfilter: cttimeout: Make NF_CT_NETLINK_TIMEOUT depend on NF_CONNTRACK_TIMEOUT

Li RongQing (1):
      netfilter: use kvmalloc_array to allocate memory for hashtable

Máté Eckl (3):
      netfilter: nf_tables: Add native tproxy support
      netfilter: nft_tproxy: Add missing config check
      netfilter: bridge: Expose nf_tables bridge hook priorities through uapi

Pablo Neira Ayuso (5):
      netfilter: nf_osf: add nf_osf_find()
      netfilter: nf_tables: add tunnel support
      netfilter: nf_tables: match on tunnel metadata
      netfilter: nf_tables: simplify NLM_F_CREATE handling
      netfilter: nft_tunnel: fix sparse errors

YueHaibing (2):
      netfilter: use PTR_ERR_OR_ZERO()
      netfilter: nf_tables: remove unused variable

 .../linux/netfilter/{nf_osf.h => nfnetlink_osf.h}  |  13 +-
 include/linux/netfilter_bridge.h                   |  11 -
 include/net/netfilter/nf_conntrack.h               |   2 -
 include/net/netfilter/nf_tables_core.h             |   7 +
 include/uapi/linux/netfilter/nf_tables.h           | 107 +++-
 .../linux/netfilter/{nf_osf.h => nfnetlink_osf.h}  |   9 +
 include/uapi/linux/netfilter/xt_osf.h              |  11 +-
 include/uapi/linux/netfilter_bridge.h              |  11 +
 net/bridge/br_netfilter_hooks.c                    |   1 +
 net/bridge/netfilter/ebtable_filter.c              |   1 +
 net/bridge/netfilter/ebtable_nat.c                 |   1 +
 net/core/dst.c                                     |   1 +
 net/netfilter/Kconfig                              |  45 +-
 net/netfilter/Makefile                             |   5 +-
 net/netfilter/nf_conntrack_core.c                  |  29 +-
 net/netfilter/nf_conntrack_expect.c                |   2 +-
 net/netfilter/nf_conntrack_helper.c                |   4 +-
 net/netfilter/nf_conntrack_proto.c                 |   7 +-
 net/netfilter/nf_nat_core.c                        |   4 +-
 net/netfilter/nf_tables_api.c                      |  35 +-
 net/netfilter/nf_tables_core.c                     |  16 +-
 net/netfilter/nfnetlink_cttimeout.c                |   6 -
 net/netfilter/{nf_osf.c => nfnetlink_osf.c}        | 186 ++++++-
 net/netfilter/nft_lookup.c                         |   6 +-
 net/netfilter/nft_meta.c                           |   6 +-
 net/netfilter/nft_numgen.c                         |   4 +-
 net/netfilter/nft_osf.c                            | 106 ++++
 net/netfilter/nft_tproxy.c                         | 316 ++++++++++++
 net/netfilter/nft_tunnel.c                         | 566 +++++++++++++++++++++
 net/netfilter/xt_connlimit.c                       |   4 +-
 net/netfilter/xt_osf.c                             | 149 +-----
 31 files changed, 1417 insertions(+), 254 deletions(-)
 rename include/linux/netfilter/{nf_osf.h => nfnetlink_osf.h} (74%)
 rename include/uapi/linux/netfilter/{nf_osf.h => nfnetlink_osf.h} (94%)
 rename net/netfilter/{nf_osf.c => nfnetlink_osf.c} (58%)
 create mode 100644 net/netfilter/nft_osf.c
 create mode 100644 net/netfilter/nft_tproxy.c
 create mode 100644 net/netfilter/nft_tunnel.c
