From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 00/12] Netfilter fixes for net
Date: Tue, 11 Sep 2018 02:20:32 +0200
Message-ID: <20180911002044.9100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter fixes for you net tree:

1) Remove duplicated include at the end of UDP conntrack, from Yue Haibing.

2) Restore conntrack dependency on xt_cluster, from Martin Willi.

3) Fix splat with GSO skbs from the checksum target, from Florian Westphal.

4) Rework ct timeout support, the template strategy to attach custom timeouts
   is not correct since it will not work in conjunction with conntrack zones
   and we have a possible free after use when removing the rule due to missing
   refcounting. To fix these problems, do not use conntrack template at all
   and set custom timeout on the already valid conntrack object. This
   fix comes with a preparation patch to simplify timeout adjustment by
   initializating the first position of the timeout array for all of the
   existing trackers. Patchset from Florian Westphal.

5) Fix missing dependency on from IPv4 chain NAT type, from Florian.

6) Release chain reference counter from the flush path, from Taehee Yoo.

7) After flushing an iptables ruleset, conntrack hooks are unregistered
   and entries are left stale to be cleaned up by the timeout garbage
   collector. No TCP tracking is done on established flows by this time.
   If ruleset is reloaded, then hooks are registered again and TCP
   tracking is restored, which considers packets to be invalid. Clear
   window tracking to exercise TCP flow pickup from the middle given that
   history is lost for us. Again from Florian.

8) Fix crash from netlink interface with CONFIG_NF_CONNTRACK_TIMEOUT=y
   and CONFIG_NF_CT_NETLINK_TIMEOUT=n.

9) Broken CT target due to returning incorrect type from
   ctnl_timeout_find_get().

10) Solve conntrack clash on NF_REPEAT verdicts too, from Michal Vaner.

11) Missing conversion of hashlimit sysctl interface to new API, from
    Cong Wang.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 0d092f06faa46b95a8e07b9bb5737b7c0f1176ee:

  Merge branch 'for-upstream' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth (2018-08-22 22:43:11 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 1286df269f498165061e0cf8092ca212545dbb5a:

  netfilter: xt_hashlimit: use s->file instead of s->private (2018-09-11 01:35:32 +0200)

----------------------------------------------------------------
Cong Wang (1):
      netfilter: xt_hashlimit: use s->file instead of s->private

Florian Westphal (5):
      netfilter: xt_checksum: ignore gso skbs
      netfilter: conntrack: place 'new' timeout in first location too
      netfilter: nf_tables: rework ct timeout set support
      netfilter: kconfig: nat related expression depend on nftables core
      netfilter: conntrack: reset tcp maxwin on re-register

Martin Willi (1):
      netfilter: xt_cluster: add dependency on conntrack module

Michal 'vorner' Vaner (1):
      netfilter: nfnetlink_queue: Solve the NFQUEUE/conntrack clash for NF_REPEAT

Pablo Neira Ayuso (2):
      netfilter: conntrack: timeout interface depend on CONFIG_NF_CONNTRACK_TIMEOUT
      netfilter: cttimeout: ctnl_timeout_find_get() returns incorrect pointer to type

Taehee Yoo (1):
      netfilter: nf_tables: release chain in flushing set

Yue Haibing (1):
      netfilter: conntrack: remove duplicated include from nf_conntrack_proto_udp.c

 include/net/netfilter/nf_conntrack_timeout.h |  2 +-
 net/ipv4/netfilter/Kconfig                   |  8 ++--
 net/netfilter/Kconfig                        | 12 +++---
 net/netfilter/nf_conntrack_proto.c           | 26 ++++++++++++
 net/netfilter/nf_conntrack_proto_dccp.c      | 19 ++++++---
 net/netfilter/nf_conntrack_proto_generic.c   |  8 ++--
 net/netfilter/nf_conntrack_proto_gre.c       |  8 ++--
 net/netfilter/nf_conntrack_proto_icmp.c      |  8 ++--
 net/netfilter/nf_conntrack_proto_icmpv6.c    |  8 ++--
 net/netfilter/nf_conntrack_proto_sctp.c      | 21 ++++++----
 net/netfilter/nf_conntrack_proto_tcp.c       | 19 ++++++---
 net/netfilter/nf_conntrack_proto_udp.c       | 21 +++++-----
 net/netfilter/nf_tables_api.c                |  1 +
 net/netfilter/nfnetlink_cttimeout.c          |  6 +--
 net/netfilter/nfnetlink_queue.c              |  1 +
 net/netfilter/nft_ct.c                       | 59 ++++++++++++++--------------
 net/netfilter/xt_CHECKSUM.c                  | 22 ++++++++++-
 net/netfilter/xt_cluster.c                   | 14 ++++++-
 net/netfilter/xt_hashlimit.c                 | 18 ++++-----
 19 files changed, 181 insertions(+), 100 deletions(-)
