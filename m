From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/5] Netfilter fixes for net
Date: Thu, 13 Dec 2018 02:06:26 +0100
Message-ID: <20181213010631.9753-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter fixes for net:

1) Fix warnings suspicious rcu usage when handling base chain
   statistics, from Taehee Yoo.

2) Refetch pointer to tcp header from nf_ct_sack_adjust() since
   skb_make_writable() may reallocate data area, reported by Google
   folks patch from Florian.

3) Incorrect netlink nest end after previous cancellation from error
   path in ipset, from Pan Bian.

4) Use dst_hold_safe() from nf_xfrm_me_harder(), from Florian.

5) Use rb_link_node_rcu() for rcu-protected rbtree node in
   nf_conncount, from Taehee Yoo.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

----------------------------------------------------------------

The following changes since commit 986103e7920cabc0b910749e77ae5589d3934d52:

  net/ibmvnic: Fix RTNL deadlock during device reset (2018-12-03 15:53:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to d4e7df16567b80836a78d31b42f1a9355a636d67:

  netfilter: nf_conncount: use rb_link_node_rcu() instead of rb_link_node() (2018-12-13 01:14:58 +0100)

----------------------------------------------------------------
Florian Westphal (2):
      netfilter: seqadj: re-load tcp header pointer after possible head reallocation
      netfilter: nat: can't use dst_hold on noref dst

Pan Bian (1):
      netfilter: ipset: do not call ipset_nest_end after nla_nest_cancel

Taehee Yoo (2):
      netfilter: nf_tables: fix suspicious RCU usage in nft_chain_stats_replace()
      netfilter: nf_conncount: use rb_link_node_rcu() instead of rb_link_node()

 include/linux/netfilter/nfnetlink.h   | 12 ------------
 net/netfilter/ipset/ip_set_list_set.c |  2 +-
 net/netfilter/nf_conncount.c          |  2 +-
 net/netfilter/nf_conntrack_seqadj.c   |  7 ++++---
 net/netfilter/nf_nat_core.c           |  3 ++-
 net/netfilter/nf_tables_api.c         | 21 +++++++++++++--------
 net/netfilter/nf_tables_core.c        |  2 +-
 7 files changed, 22 insertions(+), 27 deletions(-)
