From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 00/18] Netfilter updates for net-next
Date: Wed, 23 May 2018 20:42:36 +0200
Message-ID: <20180523184254.22599-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter updates for your net-next
tree, they are:

1) Remove obsolete nf_log tracing from nf_tables, from Florian Westphal.

2) Add support for map lookups to numgen, random and hash expressions,
   from Laura Garcia.

3) Allow to register nat hooks for iptables and nftables at the same
   time. Patchset from Florian Westpha.

4) Timeout support for rbtree sets.

5) ip6_rpfilter works needs interface for link-local addresses, from
   Vincent Bernat.

6) Add nf_ct_hook and nf_nat_hook structures and use them.

7) Do not drop packets on packets raceing to insert conntrack entries
   into hashes, this is particularly a problem in nfqueue setups.

8) Address fallout from xt_osf separation to nf_osf, patches
   from Florian Westphal and Fernando Mancera.

9) Remove reference to struct nft_af_info, which doesn't exist anymore.
   From Taehee Yoo.

This batch comes with is a conflict between 25fd386e0bc0 ("netfilter:
core: add missing __rcu annotation") in your tree and 2c205dd3981f
("netfilter: add struct nf_nat_hook and use it") coming in this batch.
This conflict can be solved by leaving the __rcu tag on
__netfilter_net_init() - added by 25fd386e0bc0 - and remove all code
related to nf_nat_decode_session_hook - which is gone after
2c205dd3981f, as described by:

diff --cc net/netfilter/core.c
index e0ae4aae96f5,206fb2c4c319..168af54db975
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@@ -611,7 -580,13 +611,8 @@@ const struct nf_conntrack_zone nf_ct_zo
  EXPORT_SYMBOL_GPL(nf_ct_zone_dflt);
  #endif /* CONFIG_NF_CONNTRACK */
  
- static void __net_init __netfilter_net_init(struct nf_hook_entries **e, int max)
 -#ifdef CONFIG_NF_NAT_NEEDED
 -void (*nf_nat_decode_session_hook)(struct sk_buff *, struct flowi *);
 -EXPORT_SYMBOL(nf_nat_decode_session_hook);
 -#endif
 -
+ static void __net_init
+ __netfilter_net_init(struct nf_hook_entries __rcu **e, int max)
  {
  	int h;
  

I can also merge your net-next tree into nf-next, solve the conflict and
resend the pull request if you prefer so.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks.

----------------------------------------------------------------

The following changes since commit 289e1f4e9e4a09c73a1c0152bb93855ea351ccda:

  net: ipv4: ipconfig: fix unused variable (2018-05-13 20:27:25 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 0c6bca747111dee19aa48c8f73d77fc85fcb8dd0:

  netfilter: nf_tables: remove nft_af_info. (2018-05-23 12:16:25 +0200)

----------------------------------------------------------------
Fernando Fernandez Mancera (1):
      netfilter: make NF_OSF non-visible symbol

Florian Westphal (9):
      netfilter: fix fallout from xt/nf osf separation
      netfilter: nf_tables: remove old nf_log based tracing
      netfilter: nf_nat: move common nat code to nat core
      netfilter: xtables: allow table definitions not backed by hook_ops
      netfilter: nf_tables: allow chain type to override hook register
      netfilter: core: export raw versions of add/delete hook functions
      netfilter: nf_nat: add nat hook register functions to nf_nat
      netfilter: nf_nat: add nat type hooks to nat core
      netfilter: lift one-nat-hook-only restriction

Laura Garcia Liebana (2):
      netfilter: nft_numgen: add map lookups for numgen random operations
      netfilter: nft_hash: add map lookups for hashing operations

Pablo Neira Ayuso (4):
      netfilter: nft_set_rbtree: add timeout support
      netfilter: add struct nf_ct_hook and use it
      netfilter: add struct nf_nat_hook and use it
      netfilter: nfnetlink_queue: resolve clash for unconfirmed conntracks

Taehee Yoo (1):
      netfilter: nf_tables: remove nft_af_info.

Vincent Bernat (1):
      netfilter: ip6t_rpfilter: provide input interface for route lookup

 include/linux/netfilter.h                |  34 +++-
 include/linux/netfilter/nf_osf.h         |   6 +
 include/net/netfilter/nf_nat.h           |   4 +
 include/net/netfilter/nf_nat_core.h      |  11 +-
 include/net/netfilter/nf_nat_l3proto.h   |  52 +-----
 include/net/netfilter/nf_tables.h        |   8 +-
 include/net/netns/nftables.h             |   2 -
 include/uapi/linux/netfilter/nf_osf.h    |   8 +-
 include/uapi/linux/netfilter/nf_tables.h |   4 +
 net/ipv4/netfilter/ip_tables.c           |   5 +-
 net/ipv4/netfilter/iptable_nat.c         |  85 ++++-----
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c | 135 ++++++--------
 net/ipv4/netfilter/nft_chain_nat_ipv4.c  |  52 ++----
 net/ipv6/netfilter/ip6_tables.c          |   5 +-
 net/ipv6/netfilter/ip6t_rpfilter.c       |   2 +
 net/ipv6/netfilter/ip6table_nat.c        |  84 ++++-----
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c | 129 ++++++--------
 net/ipv6/netfilter/nft_chain_nat_ipv6.c  |  48 ++---
 net/netfilter/Kconfig                    |   2 +-
 net/netfilter/core.c                     | 102 +++++++----
 net/netfilter/nf_conntrack_core.c        |  91 +++++++++-
 net/netfilter/nf_conntrack_netlink.c     |  10 +-
 net/netfilter/nf_internals.h             |   5 +
 net/netfilter/nf_nat_core.c              | 294 ++++++++++++++++++++++++++++---
 net/netfilter/nf_tables_api.c            |  87 ++-------
 net/netfilter/nf_tables_core.c           |  29 +--
 net/netfilter/nfnetlink_queue.c          |  28 ++-
 net/netfilter/nft_hash.c                 | 131 +++++++++++++-
 net/netfilter/nft_numgen.c               |  76 +++++++-
 net/netfilter/nft_set_rbtree.c           |  75 +++++++-
 30 files changed, 1033 insertions(+), 571 deletions(-)
