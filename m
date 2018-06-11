From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 00/15] Netfilter/IPVS fixes for net
Date: Mon, 11 Jun 2018 11:22:18 +0200
Message-ID: <20180611092233.3219-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter/IPVS fixes for your net tree:

1) Reject non-null terminated helper names from xt_CT, from Gao Feng.

2) Fix KASAN splat due to out-of-bound access from commit phase, from
   Alexey Kodanev.

3) Missing conntrack hook registration on IPVS FTP helper, from Julian
   Anastasov.

4) Incorrect skbuff allocation size in bridge nft_reject, from Taehee Yoo.

5) Fix inverted check on packet xmit to non-local addresses, also from
   Julian.

6) Fix ebtables alignment compat problems, from Alin Nastac.

7) Hook mask checks are not correct in xt_set, from Serhey Popovych.

8) Fix timeout listing of element in ipsets, from Jozsef.

9) Cap maximum timeout value in ipset, also from Jozsef.

10) Don't allow family option for hash:mac sets, from Florent Fourcot.

11) Restrict ebtables to work with NFPROTO_BRIDGE targets only, this
    Florian.

12) Another bug reported by KASAN in the rbtree set backend, from
    Taehee Yoo.

13) Missing __IPS_MAX_BIT update doesn't include IPS_OFFLOAD_BIT.
    From Gao Feng.

14) Missing initialization of match/target in ebtables, from Florian
    Westphal.

15) Remove useless nft_dup.h file in include path, from C. Labbe.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 664088f8d68178809b848ca450f2797efb34e8e7:

  net-sysfs: Fix memory leak in XPS configuration (2018-05-31 23:02:42 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to d8e87fc6d11c31525430a388317b52f4a98a5328:

  netfilter: remove include/net/netfilter/nft_dup.h (2018-06-08 12:42:24 +0200)

----------------------------------------------------------------
Alexey Kodanev (1):
      netfilter: nf_tables: check msg_type before nft_trans_set(trans)

Alin Nastac (1):
      netfilter: ebtables: fix compat entry padding

Corentin Labbe (1):
      netfilter: remove include/net/netfilter/nft_dup.h

Florent Fourcot (1):
      netfilter: ipset: forbid family for hash:mac sets

Florian Westphal (2):
      netfilter: ebtables: reject non-bridge targets
      netfilter: x_tables: initialise match/target check parameter struct

Gao Feng (2):
      netfilter: xt_CT: Reject the non-null terminated string from user space
      netfilter: nf_conntrack: Increase __IPS_MAX_BIT with new bit IPS_OFFLOAD_BIT

Jozsef Kadlecsik (2):
      netfilter: ipset: List timing out entries with "timeout 1" instead of zero
      netfilter: ipset: Limit max timeout value

Julian Anastasov (2):
      ipvs: register conntrack hooks for ftp
      ipvs: fix check on xmit to non-local addresses

Pablo Neira Ayuso (1):
      Merge git://blackhole.kfki.hu/nf

Serhey Popovych (1):
      netfilter: xt_set: Check hook mask correctly

Taehee Yoo (2):
      netfilter: nft_reject_bridge: fix skb allocation size in nft_reject_br_send_v6_unreach
      netfilter: nft_set_rbtree: fix parameter of __nft_rbtree_lookup()

 include/linux/netfilter/ipset/ip_set_timeout.h     | 20 ++++++++++-----
 include/net/ip_vs.h                                | 30 ++++++++++++++++++++++
 include/net/netfilter/nft_dup.h                    | 10 --------
 include/uapi/linux/netfilter/nf_conntrack_common.h |  2 +-
 net/bridge/netfilter/ebtables.c                    | 25 ++++++++++++++----
 net/bridge/netfilter/nft_reject_bridge.c           |  2 +-
 net/ipv4/netfilter/ip_tables.c                     |  1 +
 net/ipv6/netfilter/ip6_tables.c                    |  1 +
 net/netfilter/ipset/ip_set_hash_gen.h              |  5 +++-
 net/netfilter/ipvs/ip_vs_ctl.c                     |  4 +++
 net/netfilter/ipvs/ip_vs_xmit.c                    |  2 +-
 net/netfilter/nf_tables_api.c                      | 11 ++++----
 net/netfilter/nft_set_rbtree.c                     |  2 +-
 net/netfilter/xt_CT.c                              | 10 ++++++++
 net/netfilter/xt_set.c                             | 10 ++++----
 15 files changed, 99 insertions(+), 36 deletions(-)
 delete mode 100644 include/net/netfilter/nft_dup.h
