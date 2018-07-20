From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 00/38] Netfilter/IPVS updates for net-next
Date: Fri, 20 Jul 2018 15:08:28 +0200
Message-ID: <20180720130906.27687-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter/IPVS updates for your net-next
tree:

1) No need to set ttl from reject action for the bridge family, from
   Taehee Yoo.

2) Use a fixed timeout for flow that are passed up from the flowtable
   to conntrack, from Florian Westphal.

3) More preparation patches for tproxy support for nf_tables, from Mate
   Eckl.

4) Remove unnecessary indirection in core IPv6 checksum function, from
   Florian Westphal.

5) Use nf_ct_get_tuplepr() from openvswitch, instead of opencoding it.
   From Florian Westphal.

6) socket match now selects socket infrastructure, instead of depending
   on it. From Mate Eckl.

7) Patch series to simplify conntrack tuple building/parsing from packet
   path and ctnetlink, from Florian Westphal.

8) Fetch timeout policy from protocol helpers, instead of doing it from
   core, from Florian Westphal.

9) Merge IPv4 and IPv6 protocol trackers into conntrack core, from
   Florian Westphal.

10) Depend on CONFIG_NF_TABLES_IPV6 and CONFIG_IP6_NF_IPTABLES
    respectively, instead of IPV6. Patch from Mate Eckl.

11) Add specific function for garbage collection in conncount,
    from Yi-Hung Wei.

12) Catch number of elements in the connlimit list, from Yi-Hung Wei.

13) Move locking to nf_conncount, from Yi-Hung Wei.

14) Series of patches to add lockless tree traversal in nf_conncount,
    from Yi-Hung Wei.

15) Resolve clash in matching conntracks when race happens, from
    Martynas Pumputis.

16) If connection entry times out, remove template entry from the
    ip_vs_conn_tab table to improve behaviour under flood, from
    Julian Anastasov.

17) Remove useless parameter from nf_ct_helper_ext_add(), from Gao feng.

18) Call abort from 2-phase commit protocol before requesting modules,
    make sure this is done under the mutex, from Florian Westphal.

19) Grab module reference when starting transaction, also from Florian.

20) Dynamically allocate expression info array for pre-parsing, from
    Florian.

21) Add per netns mutex for nf_tables, from Florian Westphal.

22) A couple of patches to simplify and refactor nf_osf code to prepare
    for nft_osf support.

23) Break evaluation on missing socket, from Mate Eckl.

24) Allow to match socket mark from nft_socket, from Mate Eckl.

25) Remove dependency on nf_defrag_ipv6, now that IPv6 tracker is
    built-in into nf_conntrack. From Florian Westphal.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks!

----------------------------------------------------------------

The following changes since commit aea06eb276d99590f400c877ca2bd74b4db91330:

  Merge branch 'TLS-offload-rx-netdev-and-mlx5' (2018-07-16 00:13:40 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 24c458c485c87eef97e91d2e180f222555528b11:

  netfilter: nf_osf: add missing definitions to header file (2018-07-18 11:26:55 +0200)

----------------------------------------------------------------
Fernando Fernandez Mancera (1):
      netfilter: nf_osf: add missing definitions to header file

Florian Westphal (18):
      netfilter: flowtables: use fixed renew timeout on teardown
      netfilter: utils: move nf_ip_checksum* from ipv4 to utils
      netfilter: utils: move nf_ip6_checksum* from ipv6 to utils
      openvswitch: use nf_ct_get_tuplepr, invert_tuplepr
      netfilter: conntrack: remove ctnetlink callbacks from l3 protocol trackers
      netfilter: conntrack: remove pkt_to_tuple indirection from l3 protocol trackers
      netfilter: conntrack: remove invert_tuple indirection from l3 protocol trackers
      netfilter: conntrack: remove get_l4proto indirection from l3 protocol trackers
      netfilter: conntrack: avoid calls to l4proto invert_tuple
      netfilter: conntrack: avoid l4proto pkt_to_tuple calls
      netfilter: conntrack: remove get_timeout() indirection
      netfilter: conntrack: remove l3proto abstraction
      netfilter: nf_tables: add and use helper for module autoload
      netfilter: nf_tables: make valid_genid callback mandatory
      netfilter: nf_tables: take module reference when starting a batch
      netfilter: nf_tables: avoid global info storage
      netfilter: nf_tables: use dedicated mutex to guard transactions
      ipv6: remove dependency of nf_defrag_ipv6 on ipv6 module

Gao Feng (1):
      netfilter: Remove useless param helper of nf_ct_helper_ext_add

Julian Anastasov (3):
      ipvs: provide just conn to ip_vs_state_name
      ipvs: add assured state for conn templates
      ipvs: drop conn templates under attack

Martynas Pumputis (1):
      netfilter: nf_conntrack: resolve clash for matching conntracks

Máté Eckl (5):
      netfilter: nft_tproxy: Move nf_tproxy_assign_sock() to nf_tproxy.h
      netfilter: Kconfig: Make NETFILTER_XT_MATCH_SOCKET select NF_SOCKET_IPV4/6
      netfilter: Kconfig: Change select IPv6 dependencies
      netfilter: nft_socket: Break evaluation if no socket found
      netfilter: nft_socket: Expose socket mark

Pablo Neira Ayuso (2):
      netfilter: nf_osf: add nf_osf_match_one()
      netfilter: nf_osf: add struct nf_osf_hdr_ctx

Taehee Yoo (1):
      netfilter: nft_reject_bridge: remove unnecessary ttl set

Yi-Hung Wei (6):
      netfilter: nf_conncount: Early exit for garbage collection
      netfilter: nf_conncount: Switch to plain list
      netfilter: nf_conncount: Early exit in nf_conncount_lookup() and cleanup
      netfilter: nf_conncount: Move locking into count_tree()
      netfilter: nf_conncount: Split insert and traversal
      netfilter: nf_conncount: Add list lock and gc worker, and RCU for init tree search

 include/linux/netfilter/nfnetlink.h                |   1 +
 include/linux/netfilter_ipv4.h                     |  11 -
 include/linux/netfilter_ipv6.h                     |   5 -
 include/net/ip_vs.h                                |  18 +-
 include/net/ipv6.h                                 |  28 -
 include/net/ipv6_frag.h                            | 104 +++
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h     |   3 -
 include/net/netfilter/nf_conntrack.h               |   5 +
 include/net/netfilter/nf_conntrack_core.h          |  15 +-
 include/net/netfilter/nf_conntrack_count.h         |  37 +-
 include/net/netfilter/nf_conntrack_helper.h        |   4 +-
 include/net/netfilter/nf_conntrack_l3proto.h       |  84 --
 include/net/netfilter/nf_conntrack_l4proto.h       |  14 +-
 include/net/netfilter/nf_conntrack_timeout.h       |  18 +-
 include/net/netfilter/nf_tproxy.h                  |   8 +
 include/net/netns/nftables.h                       |   1 +
 include/uapi/linux/netfilter/nf_osf.h              |  11 +
 include/uapi/linux/netfilter/nf_tables.h           |   4 +-
 include/uapi/linux/netfilter/xt_osf.h              |  10 +-
 net/bridge/netfilter/nft_reject_bridge.c           |   3 +-
 net/ieee802154/6lowpan/reassembly.c                |   2 +-
 net/ipv4/netfilter.c                               |  53 --
 net/ipv4/netfilter/Kconfig                         |  22 +-
 net/ipv4/netfilter/Makefile                        |   6 -
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c     | 472 ------------
 net/ipv6/netfilter.c                               |  62 --
 net/ipv6/netfilter/Kconfig                         |  27 +-
 net/ipv6/netfilter/Makefile                        |   6 -
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c     | 460 -----------
 net/ipv6/netfilter/nf_conntrack_reasm.c            |  17 +-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c          |   4 +-
 net/ipv6/reassembly.c                              |  92 +--
 net/netfilter/Kconfig                              |  12 +-
 net/netfilter/Makefile                             |   7 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |  67 +-
 net/netfilter/ipvs/ip_vs_proto.c                   |  19 +-
 net/netfilter/ipvs/ip_vs_proto_sctp.c              |   2 +
 net/netfilter/ipvs/ip_vs_proto_tcp.c               |   2 +
 net/netfilter/ipvs/ip_vs_proto_udp.c               |   2 +
 net/netfilter/ipvs/ip_vs_sync.c                    |  18 +-
 net/netfilter/nf_conncount.c                       | 386 +++++++---
 net/netfilter/nf_conntrack_core.c                  | 252 ++++--
 net/netfilter/nf_conntrack_expect.c                |   1 -
 net/netfilter/nf_conntrack_helper.c                |   6 +-
 net/netfilter/nf_conntrack_l3proto_generic.c       |  66 --
 net/netfilter/nf_conntrack_netlink.c               |  98 ++-
 net/netfilter/nf_conntrack_proto.c                 | 845 +++++++++++++++------
 net/netfilter/nf_conntrack_proto_dccp.c            |  44 +-
 net/netfilter/nf_conntrack_proto_generic.c         |  32 +-
 net/netfilter/nf_conntrack_proto_gre.c             |  24 +-
 net/{ipv4 => }/netfilter/nf_conntrack_proto_icmp.c |  19 +-
 .../netfilter/nf_conntrack_proto_icmpv6.c          |  17 +-
 net/netfilter/nf_conntrack_proto_sctp.c            |  46 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |  52 +-
 net/netfilter/nf_conntrack_proto_udp.c             |  55 +-
 net/netfilter/nf_conntrack_standalone.c            |  28 +-
 net/netfilter/nf_flow_table_core.c                 |  13 +-
 net/netfilter/nf_nat_core.c                        |   8 -
 net/netfilter/nf_osf.c                             | 252 +++---
 net/netfilter/nf_tables_api.c                      | 194 +++--
 net/netfilter/nfnetlink.c                          |  23 +-
 net/netfilter/nfnetlink_cttimeout.c                |  13 +-
 net/netfilter/nft_chain_filter.c                   |   4 +-
 net/netfilter/nft_connlimit.c                      |  36 +-
 net/netfilter/nft_ct.c                             |   2 +-
 net/netfilter/nft_dynset.c                         |   2 +
 net/netfilter/nft_socket.c                         |  17 +-
 net/netfilter/utils.c                              | 131 +++-
 net/netfilter/xt_CT.c                              |   2 +-
 net/netfilter/xt_TEE.c                             |   4 +-
 net/netfilter/xt_TPROXY.c                          |   9 -
 net/openvswitch/conntrack.c                        |  20 +-
 72 files changed, 2029 insertions(+), 2408 deletions(-)
 create mode 100644 include/net/ipv6_frag.h
 delete mode 100644 include/net/netfilter/nf_conntrack_l3proto.h
 delete mode 100644 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
 delete mode 100644 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
 delete mode 100644 net/netfilter/nf_conntrack_l3proto_generic.c
 rename net/{ipv4 => }/netfilter/nf_conntrack_proto_icmp.c (96%)
 rename net/{ipv6 => }/netfilter/nf_conntrack_proto_icmpv6.c (96%)
