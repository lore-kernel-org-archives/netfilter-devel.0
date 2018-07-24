From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/9] Netfilter fixes for net
Date: Tue, 24 Jul 2018 18:31:24 +0200
Message-ID: <20180724163133.14586-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter fixes for net:

1) Make sure we don't go over the maximum jump stack boundary,
   from Taehee Yoo.

2) Missing rcu_barrier() in hash and rbtree sets, also from Taehee.

3) Missing check to nul-node in rbtree timeout routine, from Taehee.

4) Use dev->name from flowtable to fix a memleak, from Florian.

5) Oneliner to free flowtable object on removal, from Florian.

6) Memleak in chain rename transaction, again from Florian.

7) Don't allow two chains to use the same name in the same
   transaction, from Florian.

8) handle DCCP SYNC/SYNCACK as invalid, this triggers an
   uninitialized timer in conntrack reported by syzbot, from Florian.

9) Fix leak in case netlink_dump_start() fails, from Florian.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 1992d99882afda6dc17f9d49c06150856a91282f:

  net/smc: take sock lock in smc_ioctl() (2018-07-16 14:45:13 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 90fd131afc565159c9e0ea742f082b337e10f8c6:

  netfilter: nf_tables: move dumper state allocation into ->start (2018-07-24 00:36:33 +0200)

----------------------------------------------------------------
Florian Westphal (6):
      netfilter: nf_tables: use dev->name directly
      netfilter: nf_tables: free flow table struct too
      netfilter: nf_tables: fix memory leaks on chain rename
      netfilter: nf_tables: don't allow to rename to already-pending name
      netfilter: conntrack: dccp: treat SYNC/SYNCACK as invalid if no prior state
      netfilter: nf_tables: move dumper state allocation into ->start

Taehee Yoo (3):
      netfilter: nf_tables: fix jumpstack depth validation
      netfilter: nft_set_hash: add rcu_barrier() in the nft_rhash_destroy()
      netfilter: nft_set_rbtree: fix panic when destroying set by GC

 include/net/netfilter/nf_tables.h       |   5 +-
 net/netfilter/nf_conntrack_proto_dccp.c |   8 +-
 net/netfilter/nf_tables_api.c           | 304 +++++++++++++++++---------------
 net/netfilter/nft_immediate.c           |   3 +
 net/netfilter/nft_lookup.c              |  13 +-
 net/netfilter/nft_set_hash.c            |   1 +
 net/netfilter/nft_set_rbtree.c          |   7 +-
 7 files changed, 191 insertions(+), 150 deletions(-)
