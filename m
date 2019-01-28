From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 00/33] Netfilter/IPVS updates for net-next
Date: Tue, 29 Jan 2019 00:57:17 +0100
Message-ID: <20190128235750.18412-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter/IPVS updates for your net-next tree:

1) Introduce a hashtable to speed up object lookups, from Florian Westphal.

2) Make direct calls to built-in extension, also from Florian.

3) Call helper before confirming the conntrack as it used to be originally,
   from Florian.

4) Call request_module() to autoload br_netfilter when physdev is used
   to relax the dependency, also from Florian.

5) Allow to insert rules at a given position ID that is internal to the
   batch, from Phil Sutter.

6) Several patches to replace conntrack indirections by direct calls,
   and to reduce modularization, from Florian. This also includes
   several follow up patches to deal with minor fallout from this
   rework.

7) Use RCU from conntrack gre helper, from Florian.

8) GRE conntrack module becomes built-in into nf_conntrack, from Florian.

9) Replace nf_ct_invert_tuplepr() by calls to nf_ct_invert_tuple(),
   from Florian.

10) Unify sysctl handling at the core of nf_conntrack, from Florian.

11) Provide modparam to register conntrack hooks.

12) Allow to match on the interface kind string, from wenxu.

13) Remove several exported symbols, not required anymore now after
    a bit of de-modulatization work has been done, from Florian.

14) Remove built-in map support in the hash extension, this can be
    done with the existing userspace infrastructure, from laura.

15) Remove indirection to calculate checksums in IPVS, from Matteo Croce.

16) Use call wrappers for indirection in IPVS, also from Matteo.

17) Remove superfluous __percpu parameter in nft_counter, patch from
    Luc Van Oostenryck.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks!

----------------------------------------------------------------

The following changes since commit 435f3f267780321a1aff41bdade257722328ead5:

  Merge branch 'tcp_openreq_child' (2019-01-17 22:19:05 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 83f529281d7aa42b10c2c5cb64fcbd2c7cab4409:

  netfilter: ipv4: remove useless export_symbol (2019-01-28 11:32:58 +0100)

----------------------------------------------------------------
Cong Wang (1):
      netfilter: conntrack: fix error path in nf_conntrack_pernet_init()

Florian Westphal (25):
      netfilter: nf_tables: prepare nft_object for lookups via hashtable
      netfilter: nf_tables: handle nft_object lookups via rhltable
      netfilter: nf_tables: add direct calls for all builtin expressions
      netfilter: conntrack: remove helper hook again
      netfilter: physdev: relax br_netfilter dependency
      netfilter: conntrack: handle builtin l4proto packet functions via direct calls
      netfilter: conntrack: handle icmp pkt_to_tuple helper via direct calls
      netfilter: conntrack: gre: convert rwlock to rcu
      netfilter: conntrack: gre: switch module to be built-in
      netfilter: conntrack: remove net_id
      netfilter: conntrack: remove pkt_to_tuple callback
      netfilter: conntrack: remove invert_tuple callback
      netfilter: conntrack: remove module owner field
      netfilter: conntrack: remove remaining l4proto indirect packet calls
      netfilter: conntrack: remove pernet l4 proto register interface
      netfilter: conntrack: avoid unneeded nf_conntrack_l4proto lookups
      netfilter: conntrack: unify sysctl handling
      netfilter: conntrack: remove sysctl registration helpers
      netfilter: conntrack: remove l4proto init and get_net callbacks
      netfilter: conntrack: remove l4proto destroy hook
      netfilter: conntrack: remove nf_ct_l4proto_find_get
      netfilter: nat: un-export nf_nat_used_tuple
      netfilter: conntrack: fix IPV6=n builds
      netfilter: conntrack: fix bogus port values for other l4 protocols
      netfilter: ipv4: remove useless export_symbol

Laura Garcia Liebana (1):
      Revert "netfilter: nft_hash: add map lookups for hashing operations"

Luc Van Oostenryck (1):
      netfilter: nft_counter: remove wrong __percpu of nft_counter_resest()'s arg

Matteo Croce (2):
      ipvs: avoid indirect calls when calculating checksums
      ipvs: use indirect call wrappers

Pablo Neira Ayuso (1):
      netfilter: nf_conntrack: provide modparam to always register conntrack hooks

Phil Sutter (1):
      netfilter: nf_tables: Support RULE_ID reference in new rule

wenxu (1):
      netfilter: nft_meta: Add NFT_META_I/OIFKIND meta type

 include/linux/netfilter/nf_conntrack_proto_gre.h |  17 +-
 include/linux/netfilter_ipv4.h                   |   6 -
 include/net/ip_vs.h                              |   3 -
 include/net/netfilter/br_netfilter.h             |   1 -
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h   |   3 +
 include/net/netfilter/nf_conntrack.h             |   2 -
 include/net/netfilter/nf_conntrack_core.h        |   5 +-
 include/net/netfilter/nf_conntrack_l4proto.h     | 122 +++---
 include/net/netfilter/nf_nat.h                   |   4 -
 include/net/netfilter/nf_tables.h                |  26 +-
 include/net/netfilter/nf_tables_core.h           |  16 +
 include/net/netns/conntrack.h                    |  30 +-
 include/uapi/linux/netfilter/nf_tables.h         |  10 +-
 net/bridge/br_netfilter_hooks.c                  |   5 -
 net/ipv4/netfilter.c                             |  18 -
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c         |   2 +-
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c         |   2 +-
 net/netfilter/Kconfig                            |   2 +-
 net/netfilter/Makefile                           |   3 +-
 net/netfilter/ipvs/ip_vs_core.c                  |  49 ++-
 net/netfilter/ipvs/ip_vs_proto_ah_esp.c          |   2 -
 net/netfilter/ipvs/ip_vs_proto_sctp.c            |   8 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c             |  15 +-
 net/netfilter/ipvs/ip_vs_proto_udp.c             |  15 +-
 net/netfilter/nf_conntrack_core.c                | 210 +++++----
 net/netfilter/nf_conntrack_expect.c              |   2 +-
 net/netfilter/nf_conntrack_netlink.c             |  14 +-
 net/netfilter/nf_conntrack_pptp.c                |   2 +-
 net/netfilter/nf_conntrack_proto.c               | 514 ++++-------------------
 net/netfilter/nf_conntrack_proto_dccp.c          | 134 +-----
 net/netfilter/nf_conntrack_proto_generic.c       |  85 +---
 net/netfilter/nf_conntrack_proto_gre.c           | 196 ++-------
 net/netfilter/nf_conntrack_proto_icmp.c          |  67 +--
 net/netfilter/nf_conntrack_proto_icmpv6.c        |  69 +--
 net/netfilter/nf_conntrack_proto_sctp.c          | 128 +-----
 net/netfilter/nf_conntrack_proto_tcp.c           | 160 +------
 net/netfilter/nf_conntrack_proto_udp.c           |  80 +---
 net/netfilter/nf_conntrack_standalone.c          | 427 ++++++++++++++++++-
 net/netfilter/nf_flow_table_core.c               |   2 +-
 net/netfilter/nf_nat_core.c                      |  15 +-
 net/netfilter/nf_tables_api.c                    | 137 +++++-
 net/netfilter/nf_tables_core.c                   |  25 +-
 net/netfilter/nfnetlink_cttimeout.c              |  19 +-
 net/netfilter/nft_bitwise.c                      |   5 +-
 net/netfilter/nft_byteorder.c                    |   6 +-
 net/netfilter/nft_cmp.c                          |   6 +-
 net/netfilter/nft_counter.c                      |   2 +-
 net/netfilter/nft_ct.c                           |   4 +-
 net/netfilter/nft_dynset.c                       |   5 +-
 net/netfilter/nft_hash.c                         | 121 ------
 net/netfilter/nft_immediate.c                    |   6 +-
 net/netfilter/nft_meta.c                         |  12 +
 net/netfilter/nft_objref.c                       |   5 +-
 net/netfilter/nft_payload.c                      |   6 +-
 net/netfilter/nft_quota.c                        |   2 +-
 net/netfilter/nft_range.c                        |   5 +-
 net/netfilter/nft_rt.c                           |   6 +-
 net/netfilter/utils.c                            |  19 +
 net/netfilter/xt_CT.c                            |   2 +-
 net/netfilter/xt_physdev.c                       |   9 +-
 net/openvswitch/conntrack.c                      |   2 +-
 61 files changed, 1178 insertions(+), 1697 deletions(-)
