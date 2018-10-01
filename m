From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/6] Netfilter fixes for net
Date: Tue,  2 Oct 2018 00:37:39 +0200
Message-ID: <20181001223745.29010-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter fixes for your net tree:

1) Skip ip_sabotage_in() for packet making into the VRF driver,
   otherwise packets are dropped, from David Ahern.

2) Clang compilation warning uncovering typo in the
   nft_validate_register_store() call from nft_osf, from Stefan Agner.

3) Double sizeof netlink message length calculations in ctnetlink,
   from zhong jiang.

4) Missing rb_erase() on batch full in rbtree garbage collector,
   from Taehee Yoo.

5) Calm down compilation warning in nf_hook(), from Florian Westphal.

6) Missing check for non-null sk in xt_socket before validating
   netns procedence, from Flavio Leitner.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 56ce3c5a50f4d8cc95361b1ec7f152006c6320d8:

  smc: generic netlink family should be __ro_after_init (2018-09-20 07:49:55 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 40e4f26e6a14fc1496eabb8b0004a547303114e6:

  netfilter: xt_socket: check sk before checking for netns. (2018-09-28 14:47:41 +0200)

----------------------------------------------------------------
David Ahern (1):
      netfilter: bridge: Don't sabotage nf_hook calls from an l3mdev

Flavio Leitner (1):
      netfilter: xt_socket: check sk before checking for netns.

Florian Westphal (1):
      netfilter: avoid erronous array bounds warning

Stefan Agner (1):
      netfilter: nft_osf: use enum nft_data_types for nft_validate_register_store

Taehee Yoo (1):
      netfilter: nft_set_rbtree: add missing rb_erase() in GC routine

zhong jiang (1):
      netfilter: conntrack: get rid of double sizeof

 include/linux/netfilter.h              |  2 ++
 net/bridge/br_netfilter_hooks.c        |  3 ++-
 net/netfilter/nf_conntrack_proto_tcp.c |  4 ++--
 net/netfilter/nft_osf.c                |  2 +-
 net/netfilter/nft_set_rbtree.c         | 28 ++++++++++++++--------------
 net/netfilter/xt_socket.c              |  4 ++--
 6 files changed, 23 insertions(+), 20 deletions(-)
