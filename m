From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 00/37] Netfilter updates for net-next
Date: Fri, 21 Dec 2018 01:28:04 +0100
Message-ID: <20181221002841.28587-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter updates for net-next:

1) Support for destination MAC in ipset, from Stefano Brivio.

2) Disallow all-zeroes MAC address in ipset, also from Stefano.

3) Add IPSET_CMD_GET_BYNAME and IPSET_CMD_GET_BYINDEX commands,
   introduce protocol version number 7, from Jozsef Kadlecsik.
   A follow up patch to fix ip_set_byindex() is also included
   in this batch.

4) Honor CTA_MARK_MASK from ctnetlink, from Andreas Jaggi.

5) Statify nf_flow_table_iterate(), from Taehee Yoo.

6) Use nf_flow_table_iterate() to simplify garbage collection in
   nf_flow_table logic, also from Taehee Yoo.

7) Don't use _bh variants of call_rcu(), rcu_barrier() and
   synchronize_rcu_bh() in Netfilter, from Paul E. McKenney.

8) Remove NFC_* cache definition from the old caching
   infrastructure.

9) Remove layer 4 port rover in NAT helpers, use random port
   instead, from Florian Westphal.

10) Use strscpy() in ipset, from Qian Cai.

11) Remove NF_NAT_RANGE_PROTO_RANDOM_FULLY branch now that
    random port is allocated by default, from Xiaozhou Liu.

12) Ignore NF_NAT_RANGE_PROTO_RANDOM too, from Florian Westphal.

13) Limit port allocation selection routine in NAT to avoid
    softlockup splats when most ports are in use, from Florian.

14) Remove unused parameters in nf_ct_l4proto_unregister_sysctl()
    from Yafang Shao.

15) Direct call to nf_nat_l4proto_unique_tuple() instead of
    indirection, from Florian Westphal.

16) Several patches to remove all layer 4 NAT indirections,
    remove nf_nat_l4proto struct, from Florian Westphal.

17) Fix RTP/RTCP source port translation when SNAT is in place,
    from Alin Nastac.

18) Selective rule dump per chain, from Phil Sutter.

19) Revisit CLUSTERIP target, this includes a deadlock fix from
    netns path, sleep in atomic, remove bogus WARN_ON_ONCE()
    and disallow mismatching IP address and MAC address.
    Patchset from Taehee Yoo.

20) Update UDP timeout to stream after 2 seconds, from Florian.

21) Shrink UDP established timeout to 120 seconds like TCP timewait.

22) Sysctl knobs to set GRE timeouts, from Yafang Shao.

23) Move seq_print_acct() to conntrack core file, from Florian.

24) Add enum for conntrack sysctl knobs, also from Florian.

25) Place nf_conntrack_acct, nf_conntrack_helper, nf_conntrack_events
    and nf_conntrack_timestamp knobs in the core, from Florian Westphal.
    As a side effect, shrink netns_ct structure by removing obsolete
    sysctl anchors, also from Florian.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks!

----------------------------------------------------------------

The following changes since commit 30beabb3c32122d533ce0e2fc712f9d720a82f9f:

  net: phy: marvell: remove set but not used variable 'pause' (2018-11-11 18:19:50 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 8527f9df04a8b5f6ee24ae7bdda5a94d73c7d243:

  netfilter: netns: shrink netns_ct struct (2018-12-21 00:51:56 +0100)

----------------------------------------------------------------
Alin Nastac (1):
      netfilter: nf_nat_sip: fix RTP/RTCP source port translations

Andreas Jaggi (1):
      netfilter: ctnetlink: always honor CTA_MARK_MASK

Florent Fourcot (1):
      netfilter: ipset: fix ip_set_byindex function

Florian Westphal (18):
      netfilter: nat: remove l4 protocol port rovers
      netfilter: nat: limit port clash resolution attempts
      netfilter: remove NF_NAT_RANGE_PROTO_RANDOM support
      netfilter: nat: un-export nf_nat_l4proto_unique_tuple
      netfilter: nat: remove l4proto->unique_tuple
      netfilter: nat: fold in_range indirection into caller
      netfilter: nat: remove l4proto->in_range
      netfilter: nat: remove l4proto->nlattr_to_range
      netfilter: nat: remove l4proto->manip_pkt
      netfilter: nat: remove nf_nat_l4proto struct
      netfilter: conntrack: udp: only extend timeout to stream mode after 2s
      netfilter: conntrack: udp: set stream timeout to 2 minutes
      netfilter: conntrack: un-export seq_print_acct
      netfilter: conntrack: add mnemonics for sysctl table
      netfilter: conntrack: merge acct and helper sysctl table with main one
      netfilter: conntrack: merge ecache and timestamp sysctl tables with main one
      netfilter: conntrack: remove empty pernet fini stubs
      netfilter: netns: shrink netns_ct struct

Jozsef Kadlecsik (1):
      netfilter: ipset: Introduction of new commands and protocol version 7

Pablo Neira Ayuso (2):
      Merge branch 'master' of git://blackhole.kfki.hu/nf-next
      netfilter: remove NFC_* cache bits

Paul E. McKenney (1):
      netfilter: Replace call_rcu_bh(), rcu_barrier_bh(), and synchronize_rcu_bh()

Phil Sutter (1):
      netfilter: nf_tables: Speed up selective rule dumps

Qian Cai (1):
      netfilter: ipset: replace a strncpy() with strscpy()

Stefano Brivio (2):
      netfilter: ipset: Allow matching on destination MAC address for mac and ipmac sets
      netfilter: ipset: Make invalid MAC address checks consistent

Taehee Yoo (6):
      netfilter: nf_flow_table: make nf_flow_table_iterate() static
      netfilter: nf_flow_table: simplify nf_flow_offload_gc_step()
      netfilter: ipt_CLUSTERIP: fix deadlock in netns exit routine
      netfilter: ipt_CLUSTERIP: remove wrong WARN_ON_ONCE in netns exit routine
      netfilter: ipt_CLUSTERIP: fix sleep-in-atomic bug in clusterip_config_entry_put()
      netfilter: ipt_CLUSTERIP: check MAC address when duplicate config is set

Xiaozhou Liu (1):
      netfilter: nat: remove unnecessary 'else if' branch

Yafang Shao (2):
      netfilter: remove unused parameters in nf_ct_l4proto_[un]register_sysctl()
      netfilter: conntrack: register sysctl table for gre

 Documentation/networking/nf_conntrack-sysctl.txt |  11 +-
 include/linux/netfilter/ipset/ip_set.h           |   2 +-
 include/linux/netfilter/nf_conntrack_proto_gre.h |   2 -
 include/net/netfilter/nf_conntrack.h             |   5 +
 include/net/netfilter/nf_conntrack_acct.h        |   6 +-
 include/net/netfilter/nf_conntrack_ecache.h      |   7 +-
 include/net/netfilter/nf_conntrack_helper.h      |   3 +-
 include/net/netfilter/nf_conntrack_timestamp.h   |  13 +-
 include/net/netfilter/nf_flow_table.h            |   4 -
 include/net/netfilter/nf_nat_l3proto.h           |   7 -
 include/net/netfilter/nf_nat_l4proto.h           |  78 +-----
 include/net/netns/conntrack.h                    |   6 +-
 include/uapi/linux/netfilter.h                   |   4 -
 include/uapi/linux/netfilter/ipset/ip_set.h      |  19 +-
 include/uapi/linux/netfilter_decnet.h            |  10 -
 include/uapi/linux/netfilter_ipv4.h              |  28 --
 include/uapi/linux/netfilter_ipv6.h              |  29 --
 net/ipv4/netfilter/Kconfig                       |   5 -
 net/ipv4/netfilter/Makefile                      |   5 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c               | 184 ++++++------
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c         |  43 +--
 net/ipv4/netfilter/nf_nat_pptp.c                 |   2 -
 net/ipv4/netfilter/nf_nat_proto_gre.c            | 150 ----------
 net/ipv4/netfilter/nf_nat_proto_icmp.c           |  83 ------
 net/ipv6/netfilter/Makefile                      |   2 +-
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c         |  43 +--
 net/ipv6/netfilter/nf_nat_proto_icmpv6.c         |  90 ------
 net/netfilter/Kconfig                            |  15 -
 net/netfilter/Makefile                           |   7 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c        |  13 +-
 net/netfilter/ipset/ip_set_core.c                | 170 +++++++++--
 net/netfilter/ipset/ip_set_hash_gen.h            |   4 +-
 net/netfilter/ipset/ip_set_hash_ipmac.c          |  27 +-
 net/netfilter/ipset/ip_set_hash_mac.c            |  10 +-
 net/netfilter/nf_conntrack_acct.c                |  89 +-----
 net/netfilter/nf_conntrack_core.c                |  28 +-
 net/netfilter/nf_conntrack_ecache.c              |  66 +----
 net/netfilter/nf_conntrack_helper.c              |  69 +----
 net/netfilter/nf_conntrack_netlink.c             |  30 +-
 net/netfilter/nf_conntrack_proto.c               |  21 +-
 net/netfilter/nf_conntrack_proto_gre.c           |  42 ++-
 net/netfilter/nf_conntrack_proto_udp.c           |  18 +-
 net/netfilter/nf_conntrack_standalone.c          | 103 ++++++-
 net/netfilter/nf_conntrack_timestamp.c           |  70 +----
 net/netfilter/nf_flow_table_core.c               |  42 +--
 net/netfilter/nf_nat_core.c                      | 327 ++++++++++++---------
 net/netfilter/nf_nat_proto.c                     | 343 +++++++++++++++++++++++
 net/netfilter/nf_nat_proto_common.c              | 120 --------
 net/netfilter/nf_nat_proto_dccp.c                |  82 ------
 net/netfilter/nf_nat_proto_sctp.c                |  77 -----
 net/netfilter/nf_nat_proto_tcp.c                 |  85 ------
 net/netfilter/nf_nat_proto_udp.c                 | 130 ---------
 net/netfilter/nf_nat_proto_unknown.c             |  54 ----
 net/netfilter/nf_nat_sip.c                       |  39 ++-
 net/netfilter/nf_tables_api.c                    |  90 ++++--
 net/netfilter/nfnetlink_log.c                    |   2 +-
 net/netfilter/xt_hashlimit.c                     |   4 +-
 57 files changed, 1166 insertions(+), 1852 deletions(-)
 delete mode 100644 net/ipv4/netfilter/nf_nat_proto_gre.c
 delete mode 100644 net/ipv4/netfilter/nf_nat_proto_icmp.c
 delete mode 100644 net/ipv6/netfilter/nf_nat_proto_icmpv6.c
 create mode 100644 net/netfilter/nf_nat_proto.c
 delete mode 100644 net/netfilter/nf_nat_proto_common.c
 delete mode 100644 net/netfilter/nf_nat_proto_dccp.c
 delete mode 100644 net/netfilter/nf_nat_proto_sctp.c
 delete mode 100644 net/netfilter/nf_nat_proto_tcp.c
 delete mode 100644 net/netfilter/nf_nat_proto_udp.c
 delete mode 100644 net/netfilter/nf_nat_proto_unknown.c
