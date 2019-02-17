From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 00/11] Netfilter/IPVS updates for net-next
Date: Mon, 18 Feb 2019 00:23:46 +0100
Message-ID: <20190217232357.29858-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter/IPVS updates for you net-next
tree:

1) Missing NFTA_RULE_POSITION_ID netlink attribute validation,
   from Phil Sutter.

2) Restrict matching on tunnel metadata to rx/tx path, from wenxu.

3) Avoid indirect calls for IPV6=y, from Florian Westphal.

4) Add two indirections to prepare merger of IPV4 and IPV6 nat
   modules, from Florian Westphal.

5) Broken indentation in ctnetlink, from Colin Ian King.

6) Patches to use struct_size() from netfilter and IPVS,
   from Gustavo A. R. Silva.

7) Display kernel splat only once in case of racing to confirm
   conntrack from bridge plus nfqueue setups, from Chieh-Min Wang.

8) Skip checksum validation for layer 4 protocols that don't need it,
   patch from Alin Nastac.

9) Sparse warning due to symbol that should be static in CLUSTERIP,
   from Wei Yongjun.

10) Add new toggle to disable SDP payload translation when media
    endpoint is reachable though the same interface as the signalling
    peer, from Alin Nastac.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks!

----------------------------------------------------------------

The following changes since commit bbcbf2eede69c5f54a431fb96c11248a7910748c:

  enetc: include linux/vmalloc.h for vzalloc etc (2019-01-28 22:43:34 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to a3419ce3356cf1fdc69a0524eced84cef730b3bf:

  netfilter: nf_conntrack_sip: add sip_external_media logic (2019-02-16 10:49:12 +0100)

----------------------------------------------------------------
Alin Nastac (2):
      netfilter: reject: skip csum verification for protocols that don't support it
      netfilter: nf_conntrack_sip: add sip_external_media logic

Chieh-Min Wang (1):
      netfilter: conntrack: fix cloned unconfirmed skb->_nfct race in __nf_conntrack_confirm

Colin Ian King (1):
      netfilter: conntrack: fix indentation issue

Florian Westphal (3):
      netfilter: nf_tables: add NFTA_RULE_POSITION_ID to nla_policy
      netfilter: nat: remove module dependency on ipv6 core
      netfilter: ipv6: avoid indirect calls for IPV6=y case

Gustavo A. R. Silva (2):
      ipvs: Use struct_size() helper
      netfilter: xt_recent: Use struct_size() in kvzalloc()

Wei Yongjun (1):
      netfilter: ipt_CLUSTERIP: make symbol 'cip_netdev_notifier' static

wenxu (1):
      netfilter: nft_tunnel: Add NFTA_TUNNEL_MODE options

 include/linux/netfilter_ipv6.h              | 60 +++++++++++++++++++++++++----
 include/net/netfilter/ipv4/nf_reject.h      |  1 +
 include/net/netfilter/ipv6/nf_reject.h      |  1 +
 include/net/netfilter/nf_reject.h           | 27 +++++++++++++
 include/uapi/linux/netfilter/nf_tables.h    |  9 +++++
 net/bridge/netfilter/nft_reject_bridge.c    | 10 ++---
 net/ipv4/netfilter/ipt_CLUSTERIP.c          |  2 +-
 net/ipv4/netfilter/nf_reject_ipv4.c         |  9 +----
 net/ipv6/netfilter.c                        | 13 +++++--
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c    | 17 +++++++-
 net/ipv6/netfilter/nf_nat_masquerade_ipv6.c | 21 +++++++++-
 net/ipv6/netfilter/nf_reject_ipv6.c         |  3 ++
 net/ipv6/netfilter/nft_fib_ipv6.c           |  9 +----
 net/netfilter/ipvs/ip_vs_ctl.c              |  6 +--
 net/netfilter/nf_conntrack_core.c           | 14 +++++--
 net/netfilter/nf_conntrack_netlink.c        |  2 +-
 net/netfilter/nf_conntrack_sip.c            | 42 ++++++++++++++++++++
 net/netfilter/nf_tables_api.c               |  1 +
 net/netfilter/nft_tunnel.c                  | 34 +++++++++++++++-
 net/netfilter/utils.c                       |  6 +--
 net/netfilter/xt_addrtype.c                 | 16 +++-----
 net/netfilter/xt_recent.c                   |  4 +-
 22 files changed, 244 insertions(+), 63 deletions(-)
 create mode 100644 include/net/netfilter/nf_reject.h
