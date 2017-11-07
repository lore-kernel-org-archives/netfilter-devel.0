From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 00/23] Netfilter/IPVS updates for net-next
Date: Tue,  7 Nov 2017 01:51:50 +0100
Message-ID: <20171107005213.22618-1-pablo@netfilter.org>
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
tree, they are:

1) Speed up table replacement on busy systems with large tables
   (and many cores) in x_tables. Now xt_replace_table() synchronizes by
   itself by waiting until all cpus had an even seqcount and we use no
   use seqlock when fetching old counters, from Florian Westphal.

2) Add nf_l4proto_log_invalid() and nf_ct_l4proto_log_invalid() to speed
   up packet processing in the fast path when logging is not enabled, from
   Florian Westphal.

3) Precompute masked address from configuration plane in xt_connlimit,
   from Florian.

4) Don't use explicit size for set selection if performance set policy
   is selected.

5) Allow to get elements from an existing set in nf_tables.

6) Fix incorrect check in nft_hash_deactivate(), from Florian.

7) Cache netlink attribute size result in l4proto->nla_size, from
   Florian.

8) Handle NFPROTO_INET in nf_ct_netns_get() from conntrack core.

9) Use power efficient workqueue in conntrack garbage collector, from
   Vincent Guittot.

10) Remove unnecessary parameter, in conntrack l4proto functions, also
    from Florian.

11) Constify struct nf_conntrack_l3proto definitions, from Florian.

12) Remove all typedefs in nf_conntrack_h323 via coccinelle semantic
    patch, from Harsha Sharma.

13) Don't store address in the rbtree nodes in xt_connlimit, they are
    never used, from Florian.

14) Fix out of bound access in the conntrack h323 helper, patch from
    Eric Sesterhenn.

15) Print symbols for the address returned with %pS in IPVS, from
    Helge Deller.

16) Proc output should only display its own netns in IPVS, from
    KUWAZAWA Takuya.

17) Small clean up in size_entry_mwt(), from Colin Ian King.

18) Use test_and_clear_bit from nf_nat_proto_clean() instead of separated
    non-atomic test and then clear bit, from Florian Westphal.

19) Consolidate prefix length maps in ipset, from Aaron Conole.

20) Fix sparse warnings in ipset, from Jozsef Kadlecsik.

21) Simplify list_set_memsize(), from simran singhal.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks!

----------------------------------------------------------------

The following changes since commit 26873308b21654b6e0785b9f9e2c5414d37a4c4c:

  Merge branch 'sctp-stream-schedulers' (2017-10-03 16:27:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to ba0e4d9917b43dfa746cbbcb4477da59aae73bd6:

  netfilter: nf_tables: get set elements via netlink (2017-11-07 01:00:31 +0100)

----------------------------------------------------------------
Aaron Conole (1):
      netfilter: ipset: deduplicate prefixlen maps

Colin Ian King (1):
      netfilter: ebtables: clean up initialization of buf

Eric Sesterhenn (1):
      netfilter: nf_ct_h323: Out Of Bound Read in Netfilter Conntrack

Florian Westphal (11):
      netfilter: nat: use test_and_clear_bit when deleting ct from bysource list
      netfilter: conntrack: add and use nf_l4proto_log_invalid
      netfilter: conntrack: add and use nf_ct_l4proto_log_invalid
      netfilter: conntrack: remove pf argument from l4 packet functions
      netfilter: x_tables: make xt_replace_table wait until old rules are not used anymore
      netfilter: x_tables: don't use seqlock when fetching old counters
      netfilter: conntrack: make l3proto trackers const
      netfilter: xt_connlimit: don't store address in the conn nodes
      netfilter: xt_connlimit: remove mask argument
      netfilter: nft_hash: fix nft_hash_deactivate
      netfilter: conntrack: don't cache nlattr_tuple_size result in nla_size

Harsha Sharma (1):
      netfilter: nf_conntrack_h323: Remove typedef struct

Helge Deller (1):
      netfilter: ipvs: Use %pS printk format for direct addresses

Jozsef Kadlecsik (1):
      netfilter: ipset: Fix sparse warnings

KUWAZAWA Takuya (1):
      netfilter: ipvs: Fix inappropriate output of procfs

Pablo Neira Ayuso (3):
      netfilter: conntrack: move nf_ct_netns_{get,put}() to core
      netfilter: nf_tables: performance set policy skips size description in selection
      netfilter: nf_tables: get set elements via netlink

Vincent Guittot (1):
      netfilter: conntrack: use power efficient workqueue

simran singhal (1):
      netfilter: ipset: Compress return logic

 include/net/netfilter/ipv4/nf_conntrack_ipv4.h |   2 +-
 include/net/netfilter/ipv6/nf_conntrack_ipv6.h |   2 +-
 include/net/netfilter/nf_conntrack_l4proto.h   |  25 +-
 include/net/netfilter/nf_tables.h              |   5 +
 net/bridge/netfilter/ebtables.c                |   3 +-
 net/ipv4/netfilter/arp_tables.c                |  22 +-
 net/ipv4/netfilter/ip_tables.c                 |  23 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   2 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |  28 +-
 net/ipv6/netfilter/ip6_tables.c                |  22 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   2 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |  24 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c    |   2 +-
 net/netfilter/ipset/ip_set_list_set.c          |   5 +-
 net/netfilter/ipset/pfxlen.c                   | 395 +++++++++----------------
 net/netfilter/ipvs/ip_vs_conn.c                |   2 +-
 net/netfilter/ipvs/ip_vs_ctl.c                 |   8 +-
 net/netfilter/nf_conntrack_core.c              |  15 +-
 net/netfilter/nf_conntrack_h323_asn1.c         |  81 ++---
 net/netfilter/nf_conntrack_netlink.c           |  10 +-
 net/netfilter/nf_conntrack_proto.c             |  86 +++++-
 net/netfilter/nf_conntrack_proto_dccp.c        |  21 +-
 net/netfilter/nf_conntrack_proto_generic.c     |   1 -
 net/netfilter/nf_conntrack_proto_gre.c         |   1 -
 net/netfilter/nf_conntrack_proto_sctp.c        |   4 +-
 net/netfilter/nf_conntrack_proto_tcp.c         |  62 ++--
 net/netfilter/nf_conntrack_proto_udp.c         |  41 ++-
 net/netfilter/nf_nat_core.c                    |   9 +-
 net/netfilter/nf_tables_api.c                  | 195 ++++++++----
 net/netfilter/nft_ct.c                         |  39 +--
 net/netfilter/nft_set_bitmap.c                 |  18 ++
 net/netfilter/nft_set_hash.c                   |  41 ++-
 net/netfilter/nft_set_rbtree.c                 |  73 +++++
 net/netfilter/x_tables.c                       |  21 +-
 net/netfilter/xt_connlimit.c                   |  55 ++--
 35 files changed, 767 insertions(+), 578 deletions(-)
