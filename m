From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 00/16] Netfilter fixes for net
Date: Wed, 28 Nov 2018 11:17:25 +0100
Message-ID: <20181128101741.20924-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter fixes for net:

1) Disable BH while holding list spinlock in nf_conncount, from
   Taehee Yoo.

2) List corruption in nf_conncount, also from Taehee.

3) Fix race that results in leaving around an empty list node in
   nf_conncount, from Taehee Yoo.

4) Proper chain handling for inactive chains from the commit path,
   from Florian Westphal. This includes a selftest for this.

5) Do duplicate rule handles when replacing rules, also from Florian.

6) Remove net_exit path in xt_RATEEST that results in splat, from Taehee.

7) Possible use-after-free in nft_compat when releasing extensions.
   From Florian.

8) Memory leak in xt_hashlimit, from Taehee.

9) Call ip_vs_dst_notifier after ipv6_dev_notf, from Xin Long.

10) Fix cttimeout with udplite and gre, from Florian.

11) Preserve oif for IPv6 link-local generated traffic from mangle
    table, from Alin Nastac.

12) Missing error handling in masquerade notifiers, from Taehee Yoo.

13) Use mutex to protect registration/unregistration of masquerade
    extensions in order to prevent a race, from Taehee.

14) Incorrect condition check in tree_nodes_free(), also from Taehee.

15) Fix chain counter leak in rule replacement path, from Taehee.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit ccda4af0f4b92f7b4c308d3acc262f4a7e3affad:

  Linux 4.20-rc2 (2018-11-11 17:12:31 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to ca08987885a147643817d02bf260bc4756ce8cd4:

  netfilter: nf_tables: deactivate expressions in rule replecement routine (2018-11-28 10:56:40 +0100)

----------------------------------------------------------------
Alin Nastac (1):
      netfilter: ipv6: Preserve link scope traffic original oif

Florian Westphal (5):
      netfilter: nf_tables: don't skip inactive chains during update
      selftests: add script to stress-test nft packet path vs. control plane
      netfilter: nf_tables: don't use position attribute on rule replacement
      netfilter: nf_tables: fix use-after-free when deleting compat expressions
      netfilter: nfnetlink_cttimeout: fetch timeouts for udplite and gre, too

Taehee Yoo (9):
      netfilter: nf_conncount: use spin_lock_bh instead of spin_lock
      netfilter: nf_conncount: fix list_del corruption in conn_free
      netfilter: nf_conncount: fix unexpected permanent node of list.
      netfilter: xt_RATEEST: remove netns exit routine
      netfilter: xt_hashlimit: fix a possible memory leak in htable_create()
      netfilter: add missing error handling code for register functions
      netfilter: nat: fix double register in masquerade modules
      netfilter: nf_conncount: remove wrong condition check routine
      netfilter: nf_tables: deactivate expressions in rule replecement routine

Xin Long (1):
      ipvs: call ip_vs_dst_notifier earlier than ipv6_dev_notf

 include/linux/netfilter/nf_conntrack_proto_gre.h   | 13 ++++
 include/net/netfilter/ipv4/nf_nat_masquerade.h     |  2 +-
 include/net/netfilter/ipv6/nf_nat_masquerade.h     |  2 +-
 net/ipv4/netfilter/ipt_MASQUERADE.c                |  7 +-
 net/ipv4/netfilter/nf_nat_masquerade_ipv4.c        | 38 ++++++++---
 net/ipv4/netfilter/nft_masq_ipv4.c                 |  4 +-
 net/ipv6/netfilter.c                               |  3 +-
 net/ipv6/netfilter/ip6t_MASQUERADE.c               |  8 ++-
 net/ipv6/netfilter/nf_nat_masquerade_ipv6.c        | 49 ++++++++++----
 net/ipv6/netfilter/nft_masq_ipv6.c                 |  4 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |  3 +
 net/netfilter/nf_conncount.c                       | 44 +++++++-----
 net/netfilter/nf_conntrack_proto_gre.c             | 14 +---
 net/netfilter/nf_tables_api.c                      | 46 +++++--------
 net/netfilter/nfnetlink_cttimeout.c                | 15 ++++-
 net/netfilter/nft_compat.c                         |  3 +-
 net/netfilter/nft_flow_offload.c                   |  5 +-
 net/netfilter/xt_RATEEST.c                         | 10 ---
 net/netfilter/xt_hashlimit.c                       |  9 +--
 tools/testing/selftests/Makefile                   |  1 +
 tools/testing/selftests/netfilter/Makefile         |  6 ++
 tools/testing/selftests/netfilter/config           |  2 +
 .../selftests/netfilter/nft_trans_stress.sh        | 78 ++++++++++++++++++++++
 23 files changed, 259 insertions(+), 107 deletions(-)
 create mode 100644 tools/testing/selftests/netfilter/Makefile
 create mode 100644 tools/testing/selftests/netfilter/config
 create mode 100755 tools/testing/selftests/netfilter/nft_trans_stress.sh
