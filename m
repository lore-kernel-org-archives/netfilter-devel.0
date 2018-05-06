From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 00/51] Netfilter/IPVS updates for net-next
Date: Mon,  7 May 2018 00:46:18 +0200
Message-ID: <20180506224709.29100-1-pablo@netfilter.org>
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
tree, more relevant updates in this batch are:

1) Add Maglev support to IPVS. Moreover, store lastest server weight in
   IPVS since this is needed by maglev, patches from from Inju Song.

2) Preparation works to add iptables flowtable support, patches
   from Felix Fietkau.

3) Hand over flows back to conntrack slow path in case of TCP RST/FIN
   packet is seen via new teardown state, also from Felix.

4) Add support for extended netlink error reporting for nf_tables.

5) Support for larger timeouts that 23 days in nf_tables, patch from
   Florian Westphal.

6) Always set an upper limit to dynamic sets, also from Florian.

7) Allow number generator to make map lookups, from Laura Garcia.

8) Use hash_32() instead of opencode hashing in IPVS, from Vicent Bernat.

9) Extend ip6tables SRH match to support previous, next and last SID,
   from Ahmed Abdelsalam.

10) Move Passive OS fingerprint nf_osf.c, from Fernando Fernandez.

11) Expose nf_conntrack_max through ctnetlink, from Florent Fourcot.

12) Several housekeeping patches for xt_NFLOG, x_tables and ebtables,
   from Taehee Yoo.

13) Unify meta bridge with core nft_meta, then make nft_meta built-in.
   Make rt and exthdr built-in too, again from Florian.

14) Missing initialization of tbl->entries in IPVS, from Cong Wang.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks.

----------------------------------------------------------------

The following changes since commit 415787d7799f4fccbe8d49cb0b8e5811be6b0389:

  ipv6: frags: fix a lockdep false positive (2018-04-18 23:19:39 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to b13468dc577498002cf4e62978359ff97ffcd187:

  netfilter: nft_dynset: fix timeout updates on 32bit (2018-05-07 00:05:22 +0200)

----------------------------------------------------------------
Ahmed Abdelsalam (1):
      netfilter: ip6t_srh: extend SRH matching for previous, next and last SID

Arvind Yadav (1):
      netfilter: ipvs: Fix space before '[' error.

Cong Wang (2):
      ipvs: initialize tbl->entries after allocation
      ipvs: initialize tbl->entries in ip_vs_lblc_init_svc()

Felix Fietkau (19):
      netfilter: nf_flow_table: use IP_CT_DIR_* values for FLOW_OFFLOAD_DIR_*
      netfilter: nf_flow_table: clean up flow_offload_alloc
      ipv6: make ip6_dst_mtu_forward inline
      netfilter: nf_flow_table: cache mtu in struct flow_offload_tuple
      netfilter: nf_flow_table: rename nf_flow_table.c to nf_flow_table_core.c
      netfilter: nf_flow_table: move ipv4 offload hook code to nf_flow_table
      netfilter: nf_flow_table: move ip header check out of nf_flow_exceeds_mtu
      netfilter: nf_flow_table: move ipv6 offload hook code to nf_flow_table
      netfilter: nf_flow_table: relax mixed ipv4/ipv6 flowtable dependencies
      netfilter: nf_flow_table: move init code to nf_flow_table_core.c
      netfilter: nf_flow_table: fix priv pointer for netdev hook
      netfilter: nf_flow_table: track flow tables in nf_flow_table directly
      netfilter: nf_flow_table: make flow_offload_dead inline
      netfilter: nf_flow_table: add a new flow state for tearing down offloading
      netfilter: nf_flow_table: in flow_offload_lookup, skip entries being deleted
      netfilter: nf_flow_table: add support for sending flows back to the slow path
      netfilter: nf_flow_table: tear down TCP flows if RST or FIN was seen
      netfilter: nf_flow_table: add missing condition for TCP state check
      netfilter: nf_flow_table: fix offloading connections with SNAT+DNAT

Fernando Fernandez Mancera (1):
      netfilter: extract Passive OS fingerprint infrastructure from xt_osf

Florent Fourcot (1):
      netfilter: ctnetlink: export nf_conntrack_max

Florian Westphal (8):
      netfilter: nf_tables: support timeouts larger than 23 days
      netfilter: nf_tables: always use an upper set size for dynsets
      netfilter: merge meta_bridge into nft_meta
      netfilter: nf_tables: make meta expression builtin
      netfilter: nf_tables: merge rt expression into nft core
      netfilter: nf_tables: merge exthdr expression into nft core
      netfilter: nf_nat: remove unused ct arg from lookup functions
      netfilter: nft_dynset: fix timeout updates on 32bit

Inju Song (3):
      netfilter: ipvs: Keep latest weight of destination
      netfilter: ipvs: Add Maglev hashing scheduler
      netfilter: ipvs: Add configurations of Maglev hashing

Laura Garcia Liebana (2):
      netfilter: nft_numgen: add map lookups for numgen statements
      netfilter: nft_numgen: enable hashing of one element

Pablo Neira Ayuso (3):
      netfilter: nf_tables: simplify lookup functions
      netfilter: nf_tables: initial support for extended ACK reporting
      Merge tag 'ipvs-for-v4.18' of http://git.kernel.org/.../horms/ipvs-next

Phil Sutter (2):
      netfilter: nf_tables: Simplify set backend selection
      netfilter: nf_tables: Provide NFT_{RT,CT}_MAX for userspace

Taehee Yoo (7):
      netfilter: xt_NFLOG: use nf_log_packet instead of nfulnl_log_packet.
      netfilter: add __exit mark to helper modules
      netfilter: ebtables: add ebt_free_table_info function
      netfilter: ebtables: remove EBT_MATCH and EBT_NOMATCH
      netfilter: x_tables: remove duplicate ip6t_get_target function call
      netfilter: ebtables: add ebt_get_target and ebt_get_target_c
      netfilter: xtables: use ipt_get_target_c instead of ipt_get_target

Thierry Du Tre (1):
      netfilter: add NAT support for shifted portmap ranges

Vincent Bernat (1):
      ipvs: fix multiplicative hashing in sh/dh/lblc/lblcr algorithms

 include/linux/netfilter/nf_osf.h                   |  27 +
 include/linux/netfilter_bridge/ebtables.h          |   4 -
 include/net/ip6_route.h                            |  21 +
 include/net/ip_vs.h                                |   1 +
 include/net/ipv6.h                                 |   2 -
 include/net/netfilter/ipv4/nf_nat_masquerade.h     |   2 +-
 include/net/netfilter/ipv6/nf_nat_masquerade.h     |   2 +-
 include/net/netfilter/nf_flow_table.h              |  24 +-
 include/net/netfilter/nf_nat.h                     |   2 +-
 include/net/netfilter/nf_nat_l3proto.h             |  28 +-
 include/net/netfilter/nf_nat_l4proto.h             |   8 +-
 include/net/netfilter/nf_nat_redirect.h            |   2 +-
 include/net/netfilter/nf_tables.h                  |  53 +-
 include/net/netfilter/nf_tables_core.h             |   3 +
 include/net/netfilter/nfnetlink_log.h              |  17 -
 include/net/netfilter/nft_meta.h                   |  44 --
 include/uapi/linux/netfilter/nf_nat.h              |  12 +-
 include/uapi/linux/netfilter/nf_osf.h              |  90 +++
 include/uapi/linux/netfilter/nf_tables.h           |   8 +
 include/uapi/linux/netfilter/nfnetlink_conntrack.h |   1 +
 include/uapi/linux/netfilter/xt_osf.h              | 106 +---
 include/uapi/linux/netfilter_bridge/ebtables.h     |   6 +
 include/uapi/linux/netfilter_ipv6/ip6t_srh.h       |  43 +-
 net/bridge/netfilter/Kconfig                       |   7 -
 net/bridge/netfilter/Makefile                      |   1 -
 net/bridge/netfilter/ebtables.c                    |  63 +--
 net/bridge/netfilter/nft_meta_bridge.c             | 135 -----
 net/ipv4/netfilter/ip_tables.c                     |   2 +-
 net/ipv4/netfilter/ipt_MASQUERADE.c                |   2 +-
 net/ipv4/netfilter/iptable_nat.c                   |   3 +-
 net/ipv4/netfilter/nf_flow_table_ipv4.c            | 255 +--------
 net/ipv4/netfilter/nf_nat_h323.c                   |   4 +-
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c           |  18 +-
 net/ipv4/netfilter/nf_nat_masquerade_ipv4.c        |   4 +-
 net/ipv4/netfilter/nf_nat_pptp.c                   |   2 +-
 net/ipv4/netfilter/nf_nat_proto_gre.c              |   2 +-
 net/ipv4/netfilter/nf_nat_proto_icmp.c             |   2 +-
 net/ipv4/netfilter/nft_chain_nat_ipv4.c            |   3 +-
 net/ipv4/netfilter/nft_masq_ipv4.c                 |   2 +-
 net/ipv6/ip6_output.c                              |  22 -
 net/ipv6/netfilter/ip6_tables.c                    |   1 -
 net/ipv6/netfilter/ip6t_MASQUERADE.c               |   2 +-
 net/ipv6/netfilter/ip6t_srh.c                      | 173 +++++-
 net/ipv6/netfilter/ip6table_nat.c                  |   3 +-
 net/ipv6/netfilter/nf_flow_table_ipv6.c            | 246 +-------
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c           |  18 +-
 net/ipv6/netfilter/nf_nat_masquerade_ipv6.c        |   4 +-
 net/ipv6/netfilter/nf_nat_proto_icmpv6.c           |   2 +-
 net/ipv6/netfilter/nft_chain_nat_ipv6.c            |   3 +-
 net/ipv6/netfilter/nft_masq_ipv6.c                 |   2 +-
 net/ipv6/netfilter/nft_redir_ipv6.c                |   2 +-
 net/netfilter/Kconfig                              |  25 +-
 net/netfilter/Makefile                             |   8 +-
 net/netfilter/ipvs/Kconfig                         |  37 ++
 net/netfilter/ipvs/Makefile                        |   1 +
 net/netfilter/ipvs/ip_vs_ctl.c                     |   4 +
 net/netfilter/ipvs/ip_vs_dh.c                      |   3 +-
 net/netfilter/ipvs/ip_vs_lblc.c                    |   4 +-
 net/netfilter/ipvs/ip_vs_lblcr.c                   |   4 +-
 net/netfilter/ipvs/ip_vs_mh.c                      | 540 ++++++++++++++++++
 net/netfilter/ipvs/ip_vs_proto_tcp.c               |   4 +-
 net/netfilter/ipvs/ip_vs_sh.c                      |   3 +-
 net/netfilter/nf_conntrack_core.c                  |   1 +
 net/netfilter/nf_conntrack_ftp.c                   |   3 +-
 net/netfilter/nf_conntrack_irc.c                   |   6 +-
 net/netfilter/nf_conntrack_netlink.c               |   3 +
 net/netfilter/nf_conntrack_sane.c                  |   3 +-
 net/netfilter/nf_conntrack_sip.c                   |   2 +-
 net/netfilter/nf_conntrack_tftp.c                  |   2 +-
 .../{nf_flow_table.c => nf_flow_table_core.c}      | 309 ++++++----
 net/netfilter/nf_flow_table_inet.c                 |   3 +-
 net/netfilter/nf_flow_table_ip.c                   | 487 ++++++++++++++++
 net/netfilter/nf_nat_core.c                        |  27 +-
 net/netfilter/nf_nat_helper.c                      |   2 +-
 net/netfilter/nf_nat_proto_common.c                |   9 +-
 net/netfilter/nf_nat_proto_dccp.c                  |   2 +-
 net/netfilter/nf_nat_proto_sctp.c                  |   2 +-
 net/netfilter/nf_nat_proto_tcp.c                   |   2 +-
 net/netfilter/nf_nat_proto_udp.c                   |   4 +-
 net/netfilter/nf_nat_proto_unknown.c               |   2 +-
 net/netfilter/nf_nat_redirect.c                    |   6 +-
 net/netfilter/nf_nat_sip.c                         |   2 +-
 net/netfilter/nf_osf.c                             | 218 +++++++
 net/netfilter/nf_tables_api.c                      | 624 +++++++++++----------
 net/netfilter/nf_tables_core.c                     |   3 +
 net/netfilter/nfnetlink_log.c                      |   8 +-
 net/netfilter/nft_dynset.c                         |   7 +-
 net/netfilter/nft_exthdr.c                         |  23 +-
 net/netfilter/nft_flow_offload.c                   |   5 +-
 net/netfilter/nft_hash.c                           |   2 +-
 net/netfilter/nft_meta.c                           | 112 ++--
 net/netfilter/nft_nat.c                            |   2 +-
 net/netfilter/nft_numgen.c                         |  85 ++-
 net/netfilter/nft_objref.c                         |   4 +-
 net/netfilter/nft_rt.c                             |  22 +-
 net/netfilter/nft_set_bitmap.c                     |  34 +-
 net/netfilter/nft_set_hash.c                       | 153 ++---
 net/netfilter/nft_set_rbtree.c                     |  36 +-
 net/netfilter/xt_NETMAP.c                          |   8 +-
 net/netfilter/xt_NFLOG.c                           |  15 +-
 net/netfilter/xt_REDIRECT.c                        |   2 +-
 net/netfilter/xt_nat.c                             |  72 ++-
 net/netfilter/xt_osf.c                             | 202 +------
 net/openvswitch/conntrack.c                        |   4 +-
 104 files changed, 2753 insertions(+), 1887 deletions(-)
 create mode 100644 include/linux/netfilter/nf_osf.h
 delete mode 100644 include/net/netfilter/nft_meta.h
 create mode 100644 include/uapi/linux/netfilter/nf_osf.h
 delete mode 100644 net/bridge/netfilter/nft_meta_bridge.c
 create mode 100644 net/netfilter/ipvs/ip_vs_mh.c
 rename net/netfilter/{nf_flow_table.c => nf_flow_table_core.c} (67%)
 create mode 100644 net/netfilter/nf_flow_table_ip.c
 create mode 100644 net/netfilter/nf_osf.c
