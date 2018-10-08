From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 00/31] Netfilter updates for net-next
Date: Tue,  9 Oct 2018 01:00:54 +0200
Message-ID: <20181008230125.2330-1-pablo@netfilter.org>
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

1) Support for matching on ipsec policy already set in the route, from
   Florian Westphal.

2) Split set destruction into deactivate and destroy phase to make it
   fit better into the transaction infrastructure, also from Florian.
   This includes a patch to warn on imbalance when setting the new
   activate and deactivate interfaces.

3) Release transaction list from the workqueue to remove expensive
   synchronize_rcu() from configuration plane path. This speeds up
   configuration plane quite a bit. From Florian Westphal.

4) Add new xfrm/ipsec extension, this new extension allows you to match
   for ipsec tunnel keys such as source and destination address, spi and
   reqid. From Máté Eckl and Florian Westphal.

5) Add secmark support, this includes connsecmark too, patches
   from Christian Gottsche.

6) Allow to specify remaining bytes in xt_quota, from Chenbo Feng.
   One follow up patch to calm a clang warning for this one, from
   Nathan Chancellor.

7) Flush conntrack entries based on layer 3 family, from Kristian Evensen.

8) New revision for cgroups2 to shrink the path field.

9) Get rid of obsolete need_conntrack(), as a result from recent
   demodularization works.

10) Use WARN_ON instead of BUG_ON, from Florian Westphal.

11) Unused exported symbol in nf_nat_ipv4_fn(), from Florian.

12) Remove superfluous check for timeout netlink parser and dump
    functions in layer 4 conntrack helpers.

13) Unnecessary redundant rcu read side locks in NAT redirect,
    from Taehee Yoo.

14) Pass nf_hook_state structure to error handlers, patch from
    Florian Westphal.

15) Remove ->new() interface from layer 4 protocol trackers. Place
    them in the ->packet() interface. From Florian.

16) Place conntrack ->error() handling in the ->packet() interface.
    Patches from Florian Westphal.

17) Remove unused parameter in the pernet initialization path,
    also from Florian.

18) Remove additional parameter to specify layer 3 protocol when
    looking up for protocol tracker. From Florian.

19) Shrink array of layer 4 protocol trackers, from Florian.

20) Check for linear skb only once from the ALG NAT mangling
    codebase, from Taehee Yoo.

21) Use rhashtable_walk_enter() instead of deprecated
    rhashtable_walk_init(), also from Taehee.

22) No need to flush all conntracks when only one single address
    is gone, from Tan Hu.

23) Remove redundant check for NAT flags in flowtable code, from
    Taehee Yoo.

24) Use rhashtable_lookup() instead of rhashtable_lookup_fast()
    from netfilter codebase, since rcu read lock side is already
    assumed in this path.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks.

----------------------------------------------------------------

The following changes since commit a82738adff167593bbb9df90b4201ce4b3407d21:

  ip6_gre: simplify gre header parsing in ip6gre_err (2018-09-16 15:32:59 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to ffa0a9a5903e9fcfde71a0200af30692ac223ef7:

  netfilter: xt_quota: Don't use aligned attribute in sizeof (2018-10-09 00:19:25 +0200)

----------------------------------------------------------------
Chenbo Feng (1):
      netfilter: xt_quota: fix the behavior of xt_quota module

Christian Göttsche (2):
      netfilter: nf_tables: add SECMARK support
      netfilter: nf_tables: add requirements for connsecmark support

Florian Westphal (18):
      netfilter: nf_tables: rt: allow checking if dst has xfrm attached
      netfilter: nf_tables: split set destruction in deactivate and destroy phase
      netfilter: nf_tables: warn when expr implements only one of activate/deactivate
      netfilter: nf_tables: asynchronous release
      netfilter: remove obsolete need_conntrack stub
      netfilter: nf_tables: add xfrm expression
      netfilter: nf_tables: avoid BUG_ON usage
      netfilter: xtables: avoid BUG_ON
      netfilter: nf_nat_ipv4: remove obsolete EXPORT_SYMBOL
      netfilter: conntrack: pass nf_hook_state to packet and error handlers
      netfilter: conntrack: remove the l4proto->new() function
      netfilter: conntrack: deconstify packet callback skb pointer
      netfilter: conntrack: avoid using ->error callback if possible
      netfilter: conntrack: remove error callback and handle icmp from core
      netfilter: conntrack: remove unused proto arg from netns init functions
      netfilter: conntrack: remove l3->l4 mapping information
      netfilter: conntrack: clamp l4proto array size at largers supported protocol
      netfilter: ctnetlink: must check mark attributes vs NULL

Kristian Evensen (1):
      netfilter: ctnetlink: Support L3 protocol-filter on flush

Nathan Chancellor (1):
      netfilter: xt_quota: Don't use aligned attribute in sizeof

Pablo Neira Ayuso (2):
      netfilter: xt_cgroup: shrink size of v2 path
      netfilter: cttimeout: remove superfluous check on layer 4 netlink functions

Taehee Yoo (5):
      netfilter: nat: remove unnecessary rcu_read_lock in nf_nat_redirect_ipv{4/6}
      netfilter: nat: remove duplicate skb_is_nonlinear() in __nf_nat_mangle_tcp_packet()
      netfilter: nf_tables: use rhashtable_walk_enter instead of rhashtable_walk_init
      netfilter: nf_flow_table: remove unnecessary nat flag check code
      netfilter: nf_tables: use rhashtable_lookup() instead of rhashtable_lookup_fast()

Tan Hu (1):
      netfilter: masquerade: don't flush all conntracks if only one address deleted on device

 include/linux/netfilter/nf_conntrack_common.h  |   3 -
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h |  13 +-
 include/net/netfilter/ipv6/nf_conntrack_ipv6.h |  13 --
 include/net/netfilter/nf_conntrack_core.h      |   3 +-
 include/net/netfilter/nf_conntrack_l4proto.h   |  36 ++-
 include/net/netfilter/nf_tables.h              |   9 +-
 include/net/netfilter/nf_tables_core.h         |   4 +
 include/uapi/linux/netfilter/nf_tables.h       |  49 ++++-
 include/uapi/linux/netfilter/xt_cgroup.h       |  16 ++
 include/uapi/linux/netfilter/xt_quota.h        |   8 +-
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c       |   1 -
 net/ipv4/netfilter/nf_nat_masquerade_ipv4.c    |  22 +-
 net/ipv6/netfilter/ip6t_ipv6header.c           |   5 +-
 net/ipv6/netfilter/ip6t_rt.c                   |  10 +-
 net/ipv6/netfilter/nf_nat_masquerade_ipv6.c    |  19 +-
 net/netfilter/Kconfig                          |   7 +
 net/netfilter/Makefile                         |   1 +
 net/netfilter/nf_conntrack_core.c              | 105 +++++----
 net/netfilter/nf_conntrack_expect.c            |   3 +-
 net/netfilter/nf_conntrack_netlink.c           |  73 +++---
 net/netfilter/nf_conntrack_proto.c             | 117 +++-------
 net/netfilter/nf_conntrack_proto_dccp.c        | 155 +++++--------
 net/netfilter/nf_conntrack_proto_generic.c     |  28 +--
 net/netfilter/nf_conntrack_proto_gre.c         |  44 ++--
 net/netfilter/nf_conntrack_proto_icmp.c        |  78 +++----
 net/netfilter/nf_conntrack_proto_icmpv6.c      |  80 +++----
 net/netfilter/nf_conntrack_proto_sctp.c        | 253 +++++++++------------
 net/netfilter/nf_conntrack_proto_tcp.c         | 251 +++++++++------------
 net/netfilter/nf_conntrack_proto_udp.c         | 236 +++++++++-----------
 net/netfilter/nf_conntrack_standalone.c        |   9 +-
 net/netfilter/nf_flow_table_core.c             |  41 ++--
 net/netfilter/nf_flow_table_ip.c               |   6 +-
 net/netfilter/nf_nat_helper.c                  |   4 +-
 net/netfilter/nf_nat_redirect.c                |   4 -
 net/netfilter/nf_tables_api.c                  | 120 ++++++++--
 net/netfilter/nf_tables_core.c                 |  28 ++-
 net/netfilter/nfnetlink_cttimeout.c            |  59 ++---
 net/netfilter/nft_cmp.c                        |   6 +-
 net/netfilter/nft_ct.c                         |  22 +-
 net/netfilter/nft_dynset.c                     |  21 +-
 net/netfilter/nft_lookup.c                     |  20 +-
 net/netfilter/nft_meta.c                       | 116 ++++++++++
 net/netfilter/nft_objref.c                     |  20 +-
 net/netfilter/nft_reject.c                     |   6 +-
 net/netfilter/nft_rt.c                         |  11 +
 net/netfilter/nft_set_hash.c                   |  38 +---
 net/netfilter/nft_xfrm.c                       | 293 +++++++++++++++++++++++++
 net/netfilter/xt_CT.c                          |   2 +-
 net/netfilter/xt_IDLETIMER.c                   |   4 -
 net/netfilter/xt_SECMARK.c                     |   2 -
 net/netfilter/xt_cgroup.c                      |  72 ++++++
 net/netfilter/xt_quota.c                       |  55 ++---
 net/openvswitch/conntrack.c                    |   8 +-
 53 files changed, 1555 insertions(+), 1054 deletions(-)
 create mode 100644 net/netfilter/nft_xfrm.c
