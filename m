From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/8] Netfilter updates for net-next
Date: Fri, 10 Aug 2018 13:16:14 +0200
Message-ID: <20180810111622.3981-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following batch contains netfilter updates for your net-next tree:

1) Expose NFT_OSF_MAXGENRELEN maximum OS name length from the new OS
   passive fingerprint matching extension, from Fernando Fernandez.

2) Add extension to support for fine grain conntrack timeout policies
   from nf_tables. As preparation works, this patchset moves
   nf_ct_untimeout() to nf_conntrack_timeout and it also decouples the
   timeout policy from the ctnl_timeout object, most work done by
   Harsha Sharma.

3) Enable connection tracking when conntrack helper is in place.

4) Missing enumeration in uapi header when splitting original xt_osf
   to nfnetlink_osf, also from Fernando.

5) Fix a sparse warning due to incorrect typing in the nf_osf_find(),
   from Wei Yongjun.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks.

----------------------------------------------------------------

The following changes since commit 981467033a37d916649647fa3afe1fe99bba1817:

  tc-testing: remove duplicate spaces in skbedit match patterns (2018-08-05 17:39:24 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to e7ea2a52ffaf60a211edc0df97dcf194d1257714:

  netfilter: nfnetlink_osf: fix using plain integer as NULL warning (2018-08-08 19:05:39 +0200)

----------------------------------------------------------------
Fernando Fernandez Mancera (2):
      netfilter: nft_osf: use NFT_OSF_MAXGENRELEN instead of IFNAMSIZ
      netfilter: nfnetlink_osf: add missing enum in nfnetlink_osf uapi header

Harsha Sharma (2):
      netfilter: cttimeout: move ctnl_untimeout to nf_conntrack
      netfilter: nft_ct: add ct timeout support

Pablo Neira Ayuso (3):
      netfilter: cttimeout: decouple timeout policy from nfnetlink_cttimeout object
      netfilter: remove ifdef around cttimeout in struct nf_conntrack_l4proto
      netfilter: nft_ct: enable conntrack for helpers

Wei Yongjun (1):
      netfilter: nfnetlink_osf: fix using plain integer as NULL warning

 include/linux/netfilter/nfnetlink_osf.h      |  12 --
 include/net/netfilter/nf_conntrack_l4proto.h |   2 -
 include/net/netfilter/nf_conntrack_timeout.h |  21 ++-
 include/uapi/linux/netfilter/nf_tables.h     |  15 +-
 include/uapi/linux/netfilter/nfnetlink_osf.h |  12 ++
 include/uapi/linux/netfilter/xt_osf.h        |   1 +
 net/netfilter/nf_conntrack_timeout.c         |  21 ++-
 net/netfilter/nfnetlink_cttimeout.c          |  55 +++----
 net/netfilter/nfnetlink_osf.c                |   2 +-
 net/netfilter/nft_ct.c                       | 218 ++++++++++++++++++++++++++-
 net/netfilter/nft_osf.c                      |   8 +-
 net/netfilter/xt_CT.c                        |   4 +-
 12 files changed, 304 insertions(+), 67 deletions(-)
