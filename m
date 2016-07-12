From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/6] Netfilter/IPVS fixes for net
Date: Tue, 12 Jul 2016 18:10:56 +0200
Message-ID: <1468339862-4028-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter/IPVS fixes for your net tree.
they are:

1) Fix leak in the error path of nft_expr_init(), from Liping Zhang.

2) Tracing from nf_tables cannot be disabled, also from Zhang.

3) Fix an integer overflow on 32bit archs when setting the number of
   hashtable buckets, from Florian Westphal.

4) Fix configuration of ipvs sync in backup mode with IPv6 address,
   from Quentin Armitage via Simon Horman.

5) Fix incorrect timeout calculation in nft_ct NFT_CT_EXPIRATION,
   from Florian Westphal.

6) Skip clash resolution in conntrack insertion races if NAT is in
   place.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

We're rather late in the release cycle of 4.7, so if these cannot get
upstream I'll make sure to submit them to -stable, no problem.

Thanks!

----------------------------------------------------------------

The following changes since commit acd43fe85b2d1dbad55ce211b8817e6d6687246f:

  Merge branch 'mlx4-fixes' (2016-06-22 16:38:17 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 590b52e10d410e1439ae86be9fe19d75fdab628b:

  netfilter: conntrack: skip clash resolution if nat is in place (2016-07-12 16:28:41 +0200)

----------------------------------------------------------------
Florian Westphal (2):
      netfilter: conntrack: avoid integer overflow when resizing
      netfilter: nft_ct: fix expiration getter

Liping Zhang (2):
      netfilter: nf_tables: fix memory leak if expr init fails
      netfilter: nft_meta: set skb->nf_trace appropriately

Pablo Neira Ayuso (2):
      Merge tag 'ipvs-fixes2-for-v4.7' of https://git.kernel.org/.../horms/ipvs
      netfilter: conntrack: skip clash resolution if nat is in place

Quentin Armitage (1):
      ipvs: fix bind to link-local mcast IPv6 address in backup

 include/net/netfilter/nf_conntrack.h | 8 ++++++++
 net/netfilter/ipvs/ip_vs_sync.c      | 6 ++++--
 net/netfilter/nf_conntrack_core.c    | 8 ++++++++
 net/netfilter/nf_tables_api.c        | 4 +++-
 net/netfilter/nft_ct.c               | 6 +-----
 net/netfilter/nft_meta.c             | 2 +-
 6 files changed, 25 insertions(+), 9 deletions(-)
