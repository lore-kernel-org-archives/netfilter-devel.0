From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/9] Netfilter fixes for net
Date: Wed, 13 Jun 2018 12:56:51 +0200
Message-ID: <20180613105700.12894-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter patches for your net tree:

1) Fix NULL pointer dereference from nf_nat_decode_session() if NAT is
   not loaded, from Prashant Bhole.

2) Fix socket extension module autoload.

3) Don't bogusly reject sets with the NFT_SET_EVAL flag set on from
   the dynset extension.

4) Fix races with nf_tables module removal and netns exit path,
   patches from Florian Westphal.

5) Don't hit BUG_ON if jumpstack goes too deep, instead hit
   WARN_ON_ONCE, from Taehee Yoo.

6) Another NULL pointer dereference from ctnetlink, again if NAT is
   not loaded, from Florian Westphal.

7) Fix x_tables match list corruption in xt_connmark module removal
   path, also from Florian.

8) nf_conncount doesn't properly deal with conntrack zones, hence
   garbage collector may get rid of entries in a different zone.
   From Yi-Hung Wei.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 6892286e9c09925780fe2cb6db3585b56b71fe8e:

  tcp: Do not reload skb pointer after skb_gro_receive(). (2018-06-11 20:00:56 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 21ba8847f857028dc83a0f341e16ecc616e34740:

  netfilter: nf_conncount: Fix garbage collection with zones (2018-06-12 20:07:07 +0200)

----------------------------------------------------------------
Florian Westphal (4):
      netfilter: nf_tables: fix module unload race
      netfilter: nf_tables: close race between netns exit and rmmod
      netfilter: ctnetlink: avoid null pointer dereference
      netfilter: xt_connmark: fix list corruption on rmmod

Pablo Neira Ayuso (2):
      netfilter: nft_socket: fix module autoload
      netfilter: nft_dynset: do not reject set updates with NFT_SET_EVAL

Prashant Bhole (1):
      netfilter: fix null-ptr-deref in nf_nat_decode_session

Taehee Yoo (1):
      netfilter: nf_tables: use WARN_ON_ONCE instead of BUG_ON in nft_do_chain()

Yi-Hung Wei (1):
      netfilter: nf_conncount: Fix garbage collection with zones

 include/linux/netfilter.h                  |  2 +-
 include/net/netfilter/nf_conntrack_count.h |  3 ++-
 include/uapi/linux/netfilter/nf_tables.h   |  2 +-
 net/netfilter/nf_conncount.c               | 13 +++++++++----
 net/netfilter/nf_conntrack_netlink.c       |  3 ++-
 net/netfilter/nf_tables_api.c              | 25 +++++++++++++++++++------
 net/netfilter/nf_tables_core.c             |  3 ++-
 net/netfilter/nfnetlink.c                  | 10 +++++++---
 net/netfilter/nft_chain_filter.c           |  5 +++++
 net/netfilter/nft_connlimit.c              |  2 +-
 net/netfilter/nft_dynset.c                 |  4 +---
 net/netfilter/nft_socket.c                 |  1 +
 net/netfilter/xt_connmark.c                |  2 +-
 13 files changed, 52 insertions(+), 23 deletions(-)
