From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 00/52] Netfilter/IPVS updates for net-next
Date: Mon,  8 Jan 2018 21:19:08 +0100
Message-ID: <20180108202000.12989-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter/IPVS updates for your
net-next tree:

1) Free hooks via call_rcu to speed up netns release path, from
   Florian Westphal.

2) Reduce memory footprint of hook arrays, skip allocation if family is
   not present - useful in case decnet support is not compiled built-in.
   Patches from Florian Westphal.

3) Remove defensive check for malformed IPv4 - including ihl field - and
   IPv6 headers in x_tables and nf_tables.

4) Add generic flow table offload infrastructure for nf_tables, this
   includes the netlink control plane and support for IPv4, IPv6 and
   mixed IPv4/IPv6 dataplanes. This comes with NAT support too. This
   patchset adds the IPS_OFFLOAD conntrack status bit to indicate that
   this flow has been offloaded.

5) Add secpath matching support for nf_tables, from Florian.

6) Save some code bytes in the fast path for the nf_tables netdev,
   bridge and inet families.

7) Allow one single NAT hook per point and do not allow to register NAT
   hooks in nf_tables before the conntrack hook, patches from Florian.

8) Seven patches to remove the struct nf_af_info abstraction, instead
   we perform direct calls for IPv4 which is faster. IPv6 indirections
   are still needed to avoid dependencies with the 'ipv6' module, but
   these now reside in struct nf_ipv6_ops.

9) Seven patches to handle NFPROTO_INET from the Netfilter core,
   hence we can remove specific code in nf_tables to handle this
   pseudofamily.

10) No need for synchronize_net() call for nf_queue after conversion
    to hook arrays. Also from Florian.

11) Call cond_resched_rcu() when dumping large sets in ipset to avoid
    softlockup. Again from Florian.

12) Pass lockdep_nfnl_is_held() to rcu_dereference_protected(), patch
    from Florian Westphal.

13) Fix matching of counters in ipset, from Jozsef Kadlecsik.

14) Missing nfnl lock protection in the ip_set_net_exit path, also
    from Jozsef.

15) Move connlimit code that we can reuse from nf_tables into
    nf_conncount, from Florian Westhal.

And asorted cleanups:

16) Get rid of nft_dereference(), it only has one single caller.

17) Add nft_set_is_anonymous() helper function.

18) Remove NF_ARP_FORWARD leftover chain definition in nf_tables_arp.

19) Remove unnecessary comments in nf_conntrack_h323_asn1.c
    From Varsha Rao.

20) Remove useless parameters in frag_safe_skb_hp(), from Gao Feng.

21) Constify layer 4 conntrack protocol definitions, function
    parameters to register/unregister these protocol trackers, and
    timeouts. Patches from Florian Westphal.

22) Remove nlattr_size indirection, from Florian Westphal.

23) Add fall-through comments as -Wimplicit-fallthrough needs this,
    from Gustavo A. R. Silva.

24) Use swap() macro to exchange values in ipset, patch from
    Gustavo A. R. Silva.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks!

PS. I will be preparing a second batch with more updates asap.

----------------------------------------------------------------

The following changes since commit f66faae2f80a45feafc04ce63ef744ac4b6e8c05:

  Merge branch 'ipv6-ipv4-nexthop-align' (2018-01-07 21:29:41 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to f998b6b10144cd9809da6af02758615f789e8aa1:

  netfilter: ipset: Missing nfnl_lock()/nfnl_unlock() is added to ip_set_net_exit() (2018-01-08 18:11:12 +0100)

----------------------------------------------------------------
Florian Westphal (20):
      netfilter: conntrack: remove nlattr_size pointer from l4proto trackers
      netfilter: conntrack: constify list of builtin trackers
      netfilter: conntrack: l4 protocol trackers can be const
      netfilter: conntrack: timeouts can be const
      netfilter: ipset: use nfnl_mutex_is_locked
      netfilter: ipset: add resched points during set listing
      netfilter: core: make nf_unregister_net_hooks simple wrapper again
      netfilter: core: remove synchronize_net call if nfqueue is used
      netfilter: core: free hooks with call_rcu
      netfilter: reduce size of hook entry point locations
      netfilter: add defines for arp/decnet max hooks
      netfilter: reduce hook array sizes to what is needed
      netfilter: don't allocate space for decnet hooks unless needed
      netfilter: don't allocate space for arp/bridge hooks unless needed
      netfilter: reduce NF_MAX_HOOKS define
      netfilter: xtables: add and use xt_request_find_table_lock
      netfilter: core: only allow one nat hook per hook point
      netfilter: nf_tables: reject nat hook registration if prio is before conntrack
      netfilter: connlimit: split xt_connlimit into front and backend
      netfilter: meta: secpath support

Gao Feng (1):
      netfilter: ipvs: Remove useless ipvsh param of frag_safe_skb_hp

Gustavo A. R. Silva (2):
      netfilter: mark expected switch fall-throughs
      netfilter: ipset: use swap macro instead of _manually_ swapping values

Jozsef Kadlecsik (2):
      netfilter: ipset: Fix "don't update counters" mode when counters used at the matching
      netfilter: ipset: Missing nfnl_lock()/nfnl_unlock() is added to ip_set_net_exit()

Pablo Neira Ayuso (26):
      netfilter: nf_tables_arp: don't set forward chain
      netfilter: nf_tables: explicit nft_set_pktinfo() call from hook path
      netfilter: nf_tables: add nft_set_is_anonymous() helper
      netfilter: core: add nf_remove_net_hook
      netfilter: core: pass hook number, family and device to nf_find_hook_list()
      netfilter: core: pass family as parameter to nf_remove_net_hook()
      netfilter: core: support for NFPROTO_INET hook registration
      netfilter: nf_tables_inet: don't use multihook infrastructure anymore
      netfilter: nf_tables: remove multihook chains and families
      netfilter: nf_tables: remove hooks from family definition
      netfilter: move checksum indirection to struct nf_ipv6_ops
      netfilter: move checksum_partial indirection to struct nf_ipv6_ops
      netfilter: remove saveroute indirection in struct nf_afinfo
      netfilter: move route indirection to struct nf_ipv6_ops
      netfilter: move reroute indirection to struct nf_ipv6_ops
      netfilter: remove route_key_size field in struct nf_afinfo
      netfilter: remove struct nf_afinfo and its helper functions
      netfilter: remove defensive check on malformed packets from raw sockets
      netfilter: nf_tables: remove nft_dereference()
      netfilter: nf_conntrack: add IPS_OFFLOAD status bit
      netfilter: nf_tables: add flow table netlink frontend
      netfilter: add generic flow table infrastructure
      netfilter: flow table support for IPv4
      netfilter: flow table support for IPv6
      netfilter: flow table support for the mixed IPv4/IPv6 family
      netfilter: nf_tables: flow offload expression

Varsha Rao (1):
      netfilter: nf_conntrack_h323: Remove unwanted comments.

 include/linux/netfilter.h                          | 116 ++-
 include/linux/netfilter/ipset/ip_set.h             |   6 +
 include/linux/netfilter/ipset/ip_set_counter.h     |  25 +-
 include/linux/netfilter/x_tables.h                 |   2 +
 include/linux/netfilter_defs.h                     |  12 +-
 include/linux/netfilter_ipv4.h                     |  46 ++
 include/linux/netfilter_ipv6.h                     |  19 +
 include/net/ip_vs.h                                |   3 +-
 include/net/ipv6.h                                 |   2 +
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h     |  12 +-
 include/net/netfilter/ipv6/nf_conntrack_ipv6.h     |  12 +-
 include/net/netfilter/nf_conntrack_count.h         |  17 +
 include/net/netfilter/nf_conntrack_l4proto.h       |  19 +-
 include/net/netfilter/nf_flow_table.h              | 122 +++
 include/net/netfilter/nf_queue.h                   |   2 +-
 include/net/netfilter/nf_tables.h                  |  81 +-
 include/net/netfilter/nf_tables_ipv4.h             |  27 +-
 include/net/netfilter/nf_tables_ipv6.h             |  29 +-
 include/net/netns/netfilter.h                      |  12 +-
 include/uapi/linux/netfilter/nf_conntrack_common.h |   6 +-
 include/uapi/linux/netfilter/nf_tables.h           |  66 ++
 include/uapi/linux/netfilter/xt_connlimit.h        |   2 +-
 include/uapi/linux/netfilter_arp.h                 |   3 +
 include/uapi/linux/netfilter_decnet.h              |   4 +-
 net/Kconfig                                        |   1 +
 net/bridge/br_netfilter_hooks.c                    |   2 +-
 net/bridge/netfilter/Kconfig                       |   2 +
 net/bridge/netfilter/nf_tables_bridge.c            |  74 +-
 net/ipv4/netfilter.c                               |  62 +-
 net/ipv4/netfilter/Kconfig                         |  10 +
 net/ipv4/netfilter/Makefile                        |   3 +
 net/ipv4/netfilter/arp_tables.c                    |  26 +-
 net/ipv4/netfilter/ip_tables.c                     |  26 +-
 net/ipv4/netfilter/iptable_filter.c                |   6 -
 net/ipv4/netfilter/iptable_mangle.c                |   5 -
 net/ipv4/netfilter/iptable_nat.c                   |   4 +
 net/ipv4/netfilter/iptable_raw.c                   |   6 -
 net/ipv4/netfilter/iptable_security.c              |   6 -
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c     |   7 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c       |   4 +-
 net/ipv4/netfilter/nf_flow_table_ipv4.c            | 284 +++++++
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c           |  10 -
 net/ipv4/netfilter/nf_tables_arp.c                 |  13 +-
 net/ipv4/netfilter/nf_tables_ipv4.c                |  36 +-
 net/ipv4/netfilter/nft_chain_nat_ipv4.c            |   3 +-
 net/ipv4/netfilter/nft_chain_route_ipv4.c          |   8 +-
 net/ipv6/ip6_output.c                              |   3 +-
 net/ipv6/netfilter.c                               |  44 +-
 net/ipv6/netfilter/Kconfig                         |   8 +
 net/ipv6/netfilter/Makefile                        |   3 +
 net/ipv6/netfilter/ip6_tables.c                    |  26 +-
 net/ipv6/netfilter/ip6table_mangle.c               |   8 -
 net/ipv6/netfilter/ip6table_nat.c                  |   4 +
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c     |   7 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c     |   4 +-
 net/ipv6/netfilter/nf_flow_table_ipv6.c            | 278 +++++++
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c           |   8 -
 net/ipv6/netfilter/nf_tables_ipv6.c                |  35 +-
 net/ipv6/netfilter/nft_chain_nat_ipv6.c            |   3 +-
 net/ipv6/netfilter/nft_chain_route_ipv6.c          |   3 +-
 net/ipv6/netfilter/nft_fib_ipv6.c                  |  12 +-
 net/netfilter/Kconfig                              |  31 +
 net/netfilter/Makefile                             |   9 +-
 net/netfilter/core.c                               | 263 ++++---
 net/netfilter/ipset/ip_set_bitmap_gen.h            |  10 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c             |   8 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c          |   8 +-
 net/netfilter/ipset/ip_set_bitmap_port.c           |   8 +-
 net/netfilter/ipset/ip_set_core.c                  |  33 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |  38 +-
 net/netfilter/ipset/ip_set_list_set.c              |  21 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |   2 +-
 net/netfilter/ipvs/ip_vs_core.c                    |  12 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c               |   1 +
 net/netfilter/ipvs/ip_vs_proto_udp.c               |   1 +
 net/netfilter/nf_conncount.c                       | 373 +++++++++
 net/netfilter/nf_conntrack_core.c                  |  20 +
 net/netfilter/nf_conntrack_h323_asn1.c             |  40 +-
 net/netfilter/nf_conntrack_h323_main.c             |  77 +-
 net/netfilter/nf_conntrack_netlink.c               |  17 +-
 net/netfilter/nf_conntrack_proto.c                 |  18 +-
 net/netfilter/nf_conntrack_proto_dccp.c            |  21 +-
 net/netfilter/nf_conntrack_proto_generic.c         |   4 +-
 net/netfilter/nf_conntrack_proto_gre.c             |   4 +-
 net/netfilter/nf_conntrack_proto_sctp.c            |  21 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |  25 +-
 net/netfilter/nf_conntrack_proto_udp.c             |  10 +-
 net/netfilter/nf_conntrack_standalone.c            |  12 +-
 net/netfilter/nf_flow_table.c                      | 429 ++++++++++
 net/netfilter/nf_flow_table_inet.c                 |  48 ++
 net/netfilter/nf_internals.h                       |   2 +-
 net/netfilter/nf_queue.c                           |  98 ++-
 net/netfilter/nf_tables_api.c                      | 868 +++++++++++++++++++--
 net/netfilter/nf_tables_inet.c                     |  39 +-
 net/netfilter/nf_tables_netdev.c                   |  17 +-
 net/netfilter/nfnetlink_queue.c                    |   9 +-
 net/netfilter/nft_cmp.c                            |   2 +
 net/netfilter/nft_compat.c                         |   8 +-
 net/netfilter/nft_dynset.c                         |   2 +-
 net/netfilter/nft_flow_offload.c                   | 264 +++++++
 net/netfilter/nft_meta.c                           |  43 +
 net/netfilter/nft_rt.c                             |  15 +-
 net/netfilter/utils.c                              |  90 +++
 net/netfilter/x_tables.c                           |  38 +-
 net/netfilter/xt_TCPMSS.c                          |   5 +-
 net/netfilter/xt_addrtype.c                        |  15 +-
 net/netfilter/xt_connlimit.c                       | 369 +--------
 net/netfilter/xt_set.c                             | 119 +--
 108 files changed, 3853 insertions(+), 1403 deletions(-)
 create mode 100644 include/net/netfilter/nf_conntrack_count.h
 create mode 100644 include/net/netfilter/nf_flow_table.h
 create mode 100644 net/ipv4/netfilter/nf_flow_table_ipv4.c
 create mode 100644 net/ipv6/netfilter/nf_flow_table_ipv6.c
 create mode 100644 net/netfilter/nf_conncount.c
 create mode 100644 net/netfilter/nf_flow_table.c
 create mode 100644 net/netfilter/nf_flow_table_inet.c
 create mode 100644 net/netfilter/nft_flow_offload.c
 create mode 100644 net/netfilter/utils.c
