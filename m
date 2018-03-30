From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 00/47] Netfilter/IPVS updates for net-next
Date: Fri, 30 Mar 2018 13:36:42 +0200
Message-ID: <20180330113729.18335-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter/IPVS updates for your net-next
tree. This batch comes with more input sanitization for xtables to
address bug reports from fuzzers, preparation works to the flowtable
infrastructure and assorted updates. In no particular order, they are:

1) Make sure userspace provides a valid standard target verdict, from
   Florian Westphal.

2) Sanitize error target size, also from Florian.

3) Validate that last rule in basechain matches underflow/policy since
   userspace assumes this when decoding the ruleset blob that comes
   from the kernel, from Florian.

4) Consolidate hook entry checks through xt_check_table_hooks(),
   patch from Florian.

5) Cap ruleset allocations at 512 mbytes, 134217728 rules and reject
   very large compat offset arrays, so we have a reasonable upper limit
   and fuzzers don't exercise the oom-killer. Patches from Florian.

6) Several WARN_ON checks on xtables mutex helper, from Florian.

7) xt_rateest now has a hashtable per net, from Cong Wang.

8) Consolidate counter allocation in xt_counters_alloc(), from Florian.

9) Earlier xt_table_unlock() call in {ip,ip6,arp,eb}tables, patch
   from Xin Long.

10) Set FLOW_OFFLOAD_DIR_* to IP_CT_DIR_* definitions, patch from
    Felix Fietkau.

11) Consolidate code through flow_offload_fill_dir(), also from Felix.

12) Inline ip6_dst_mtu_forward() just like ip_dst_mtu_maybe_forward()
    to remove a dependency with flowtable and ipv6.ko, from Felix.

13) Cache mtu size in flow_offload_tuple object, this is safe for
    forwarding as f87c10a8aa1e describes, from Felix.

14) Rename nf_flow_table.c to nf_flow_table_core.o, to simplify too
    modular infrastructure, from Felix.

15) Add rt0, rt2 and rt4 IPv6 routing extension support, patch from
    Ahmed Abdelsalam.

16) Remove unused parameter in nf_conncount_count(), from Yi-Hung Wei.

17) Support for counting only to nf_conncount infrastructure, patch
    from Yi-Hung Wei.

18) Add strict NFT_CT_{SRC_IP,DST_IP,SRC_IP6,DST_IP6} key datatypes
    to nft_ct.

19) Use boolean as return value from ipt_ah and from IPVS too, patch
    from Gustavo A. R. Silva.

20) Remove useless parameters in nfnl_acct_overquota() and
    nf_conntrack_broadcast_help(), from Taehee Yoo.

21) Use ipv6_addr_is_multicast() from xt_cluster, also from Taehee Yoo.

22) Statify nf_tables_obj_lookup_byhandle, patch from Fengguang Wu.

23) Fix typo in xt_limit, from Geert Uytterhoeven.

24) Do no use VLAs in Netfilter code, again from Gustavo.

25) Use ADD_COUNTER from ebtables, from Taehee Yoo.

26) Bitshift support for CONNMARK and MARK targets, from Jack Ma.

27) Use pr_*() and add pr_fmt(), from Arushi Singhal.

28) Add synproxy support to ctnetlink.

29) ICMP type and IGMP matching support for ebtables, patches from
    Matthias Schiffer.

30) Support for the revision infrastructure to ebtables, from
    Bernie Harris.

31) String match support for ebtables, also from Bernie.

32) Documentation for the new flowtable infrastructure.

33) Use generic comparison functions in ebt_stp, from Joe Perches.

34) Demodularize filter chains in nftables.

35) Register conntrack hooks in case nftables NAT chain is added.

36) Merge assignments with return in a couple of spots in the
    Netfilter codebase, also from Arushi.

37) Document that xtables percpu counters are stored in the same
    memory area, from Ben Hutchings.

38) Revert mark_source_chains() sanity checks that break existing
    rulesets, from Florian Westphal.

39) Use is_zero_ether_addr() in the ipset codebase, from Joe Perches.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks!

----------------------------------------------------------------

The following changes since commit ef3f6c256f0b4711a3ef1489797b95820be5ab01:

  Merge branch 'mvpp2-jumbo-frames-support' (2018-03-05 12:55:55 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 26c97c5d8dac6bc56d4360561a286f52543ac07e:

  netfilter: ipset: Use is_zero_ether_addr instead of static and memcmp (2018-03-30 12:20:44 +0200)

----------------------------------------------------------------
Arushi Singhal (2):
      netfilter: Replace printk() with pr_*() and define pr_fmt()
      netfilter: Merge assignment with return

Ben Hutchings (1):
      netfilter: x_tables: Add note about how to free percpu counters

Bernie Harris (2):
      netfilter: ebtables: Add support for specifying match revision
      netfilter: ebtables: Add string filter

Cong Wang (1):
      netfilter: make xt_rateest hash table per net

Florian Westphal (13):
      netfilter: x_tables: check standard verdicts in core
      netfilter: x_tables: check error target size too
      netfilter: x_tables: move hook entry checks into core
      netfilter: x_tables: enforce unique and ascending entry points
      netfilter: x_tables: cap allocations at 512 mbyte
      netfilter: x_tables: limit allocation requests for blob rule heads
      netfilter: x_tables: add counters allocation wrapper
      netfilter: compat: prepare xt_compat_init_offsets to return errors
      netfilter: compat: reject huge allocation requests
      netfilter: x_tables: make sure compat af mutex is held
      netfilter: x_tables: ensure last rule in base chain matches underflow/policy
      netfilter: x_tables: fix build with CONFIG_COMPAT=n
      Revert "netfilter: x_tables: ensure last rule in base chain matches underflow/policy"

Geert Uytterhoeven (1):
      netfilter: xt_limit: Spelling s/maxmum/maximum/

Gustavo A. R. Silva (5):
      netfilter: ipt_ah: return boolean instead of integer
      ipvs: use true and false for boolean values
      netfilter: cttimeout: remove VLA usage
      netfilter: nfnetlink_cthelper: Remove VLA usage
      netfilter: nf_tables: remove VLA usage

Jack Ma (1):
      netfilter: xt_conntrack: Support bit-shifting for CONNMARK & MARK targets.

Joe Perches (2):
      netfilter: ebt_stp: Use generic functions for comparisons
      netfilter: ipset: Use is_zero_ether_addr instead of static and memcmp

Matthias Schiffer (2):
      netfilter: ebtables: add support for matching ICMP type and code
      netfilter: ebtables: add support for matching IGMP type

Pablo Neira Ayuso (9):
      netfilter: nft_ct: add NFT_CT_{SRC,DST}_{IP,IP6}
      netfilter: ctnetlink: synproxy support
      netfilter: add flowtable documentation
      netfilter: nf_tables: rename struct nf_chain_type
      netfilter: nf_tables: nft_register_chain_type() returns void
      netfilter: nf_tables: build-in filter chain type
      netfilter: nf_tables: enable conntrack if NAT chain is registered
      netfilter: nf_tables: rename to nft_set_lookup_global()
      netfilter: nf_tables: use nft_set_lookup_global from nf_tables_newsetelem()

Taehee Yoo (4):
      netfilter: nfnetlink_acct: remove useless parameter
      netfilter: xt_cluster: get rid of xt_cluster_ipv6_is_multicast
      netfilter: nf_conntrack_broadcast: remove useless parameter
      netfilter: ebtables: use ADD_COUNTER macro

Xin Long (1):
      netfilter: unlock xt_table earlier in __do_replace

Yi-Hung Wei (2):
      netfilter: Refactor nf_conncount
      netfilter: conncount: Support count only use case

kbuild test robot (1):
      netfilter: nf_tables: nf_tables_obj_lookup_byhandle() can be static

 Documentation/networking/nf_flowtable.txt          | 112 ++++++
 include/linux/netfilter/nfnetlink_acct.h           |   3 +-
 include/linux/netfilter/x_tables.h                 |   5 +-
 include/net/netfilter/nf_conntrack_count.h         |   1 -
 include/net/netfilter/nf_conntrack_helper.h        |   3 +-
 include/net/netfilter/nf_tables.h                  |  33 +-
 include/net/netfilter/xt_rateest.h                 |   4 +-
 include/uapi/linux/netfilter/nf_conntrack_common.h |   1 +
 include/uapi/linux/netfilter/nf_tables.h           |  12 +-
 include/uapi/linux/netfilter/nfnetlink_conntrack.h |  10 +
 include/uapi/linux/netfilter/xt_connmark.h         |  10 +
 include/uapi/linux/netfilter_bridge/ebt_ip.h       |  15 +-
 include/uapi/linux/netfilter_bridge/ebtables.h     |  16 +-
 net/bridge/netfilter/Kconfig                       |   2 +-
 net/bridge/netfilter/Makefile                      |   1 -
 net/bridge/netfilter/ebt_ip.c                      |  58 ++-
 net/bridge/netfilter/ebt_stp.c                     |   6 +-
 net/bridge/netfilter/ebtables.c                    |  74 ++--
 net/bridge/netfilter/nf_tables_bridge.c            |  79 ----
 net/ipv4/netfilter/Kconfig                         |   4 +-
 net/ipv4/netfilter/Makefile                        |   2 -
 net/ipv4/netfilter/arp_tables.c                    |  33 +-
 net/ipv4/netfilter/ip_tables.c                     |  31 +-
 net/ipv4/netfilter/ipt_SYNPROXY.c                  |   8 +-
 net/ipv4/netfilter/ipt_ah.c                        |   2 +-
 net/ipv4/netfilter/nf_tables_arp.c                 |  58 ---
 net/ipv4/netfilter/nf_tables_ipv4.c                |  67 ----
 net/ipv4/netfilter/nft_chain_nat_ipv4.c            |  20 +-
 net/ipv4/netfilter/nft_chain_route_ipv4.c          |   6 +-
 net/ipv6/netfilter/Kconfig                         |   2 +-
 net/ipv6/netfilter/Makefile                        |   1 -
 net/ipv6/netfilter/ip6_tables.c                    |  33 +-
 net/ipv6/netfilter/ip6t_SYNPROXY.c                 |   8 +-
 net/ipv6/netfilter/nf_tables_ipv6.c                |  65 ----
 net/ipv6/netfilter/nft_chain_nat_ipv6.c            |  20 +-
 net/ipv6/netfilter/nft_chain_route_ipv6.c          |   6 +-
 net/netfilter/Kconfig                              |   4 +-
 net/netfilter/Makefile                             |   9 +-
 net/netfilter/ipset/ip_set_hash_mac.c              |   7 +-
 net/netfilter/ipvs/ip_vs_lblc.c                    |   4 +-
 net/netfilter/ipvs/ip_vs_lblcr.c                   |   4 +-
 net/netfilter/nf_conncount.c                       |  14 +-
 net/netfilter/nf_conntrack_acct.c                  |   6 +-
 net/netfilter/nf_conntrack_broadcast.c             |   1 -
 net/netfilter/nf_conntrack_ecache.c                |   6 +-
 net/netfilter/nf_conntrack_netbios_ns.c            |   5 +-
 net/netfilter/nf_conntrack_netlink.c               |  92 ++++-
 net/netfilter/nf_conntrack_snmp.c                  |   5 +-
 net/netfilter/nf_conntrack_timestamp.c             |   6 +-
 net/netfilter/nf_nat_core.c                        |   4 +-
 net/netfilter/nf_nat_ftp.c                         |   7 +-
 net/netfilter/nf_nat_irc.c                         |   7 +-
 net/netfilter/nf_tables_api.c                      | 115 +++---
 net/netfilter/nf_tables_inet.c                     |  75 ----
 net/netfilter/nf_tables_netdev.c                   | 142 --------
 net/netfilter/nfnetlink_acct.c                     |   3 +-
 net/netfilter/nfnetlink_cthelper.c                 |  25 +-
 net/netfilter/nfnetlink_cttimeout.c                |  26 +-
 net/netfilter/nfnetlink_queue.c                    |  14 +-
 net/netfilter/nft_chain_filter.c                   | 398 +++++++++++++++++++++
 net/netfilter/nft_ct.c                             |  38 ++
 net/netfilter/nft_dynset.c                         |   5 +-
 net/netfilter/nft_lookup.c                         |   4 +-
 net/netfilter/nft_objref.c                         |   5 +-
 net/netfilter/x_tables.c                           | 191 +++++++++-
 net/netfilter/xt_RATEEST.c                         |  91 +++--
 net/netfilter/xt_cluster.c                         |  10 +-
 net/netfilter/xt_connlimit.c                       |   4 +-
 net/netfilter/xt_connmark.c                        |  77 +++-
 net/netfilter/xt_hashlimit.c                       |   3 +-
 net/netfilter/xt_limit.c                           |   2 +-
 net/netfilter/xt_nfacct.c                          |   2 +-
 net/netfilter/xt_rateest.c                         |  10 +-
 net/netfilter/xt_string.c                          |   1 +
 net/netfilter/xt_time.c                            |  13 +-
 75 files changed, 1384 insertions(+), 862 deletions(-)
 create mode 100644 Documentation/networking/nf_flowtable.txt
 delete mode 100644 net/bridge/netfilter/nf_tables_bridge.c
 delete mode 100644 net/ipv4/netfilter/nf_tables_arp.c
 delete mode 100644 net/ipv4/netfilter/nf_tables_ipv4.c
 delete mode 100644 net/ipv6/netfilter/nf_tables_ipv6.c
 delete mode 100644 net/netfilter/nf_tables_inet.c
 delete mode 100644 net/netfilter/nf_tables_netdev.c
 create mode 100644 net/netfilter/nft_chain_filter.c
