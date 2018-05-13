From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 00/15] Netfilter/IPVS fixes for net
Date: Mon, 14 May 2018 00:36:41 +0200
Message-ID: <20180513223656.10077-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter/IPVS fixes for your net tree,
they are:

1) Fix handling of simultaneous open TCP connection in conntrack,
   from Jozsef Kadlecsik.

2) Insufficient sanitify check of xtables extension names, from
   Florian Westphal.

3) Skip unnecessary synchronize_rcu() call when transaction log
   is already empty, from Florian Westphal.

4) Incorrect destination mac validation in ebt_stp, from Stephen
   Hemminger.

5) xtables module reference counter leak in nft_compat, from
   Florian Westphal.

6) Incorrect connection reference counting logic in IPVS
   one-packet scheduler, from Julian Anastasov.

7) Wrong stats for 32-bits CPU in IPVS, also from Julian.

8) Calm down sparse error in netfilter core, also from Florian.

9) Use nla_strlcpy to fix compilation warning in nfnetlink_acct
   and nfnetlink_cthelper, again from Florian.

10) Missing module alias in icmp and icmp6 xtables extensions,
    from Florian Westphal.

11) Base chain statistics in nf_tables may be unset/null, from Florian.

12) Fix handling of large matchinfo size in nft_compat, this includes
    one preparation for before this fix. From Florian.

13) Fix bogus EBUSY error when deleting chains due to incorrect reference
    counting from the preparation phase of the two-phase commit protocol.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 25eb0ea7174c6e84f21fa59dccbddd0318b17b12:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf (2018-04-25 22:55:33 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to f0dfd7a2b35b02030949100247d851b793cb275f:

  netfilter: nf_tables: fix memory leak on error exit return (2018-05-14 00:21:59 +0200)

----------------------------------------------------------------
Colin Ian King (1):
      netfilter: nf_tables: fix memory leak on error exit return

Florian Westphal (9):
      netfilter: x_tables: check name length in find_match/target, too
      netfilter: nf_tables: skip synchronize_rcu if transaction log is empty
      netfilter: nf_tables: nft_compat: fix refcount leak on xt module
      netfilter: core: add missing __rcu annotation
      netfilter: prefer nla_strlcpy for dealing with NLA_STRING attributes
      netfilter: x_tables: add module alias for icmp matches
      netfilter: nf_tables: don't assume chain stats are set when jumplabel is set
      netfilter: nft_compat: prepare for indirect info storage
      netfilter: nft_compat: fix handling of large matchinfo size

Jozsef Kadlecsik (1):
      netfilter: Fix handling simultaneous open in TCP conntrack

Julian Anastasov (2):
      ipvs: fix refcount usage for conns in ops mode
      ipvs: fix stats update from local clients

Pablo Neira Ayuso (1):
      netfilter: nf_tables: bogus EBUSY in chain deletions

Stephen Hemminger (1):
      netfilter: bridge: stp fix reference to uninitialized data

 include/net/netfilter/nf_tables.h               |   5 +
 include/uapi/linux/netfilter/nf_conntrack_tcp.h |   3 +
 net/bridge/netfilter/ebt_stp.c                  |   4 +-
 net/ipv4/netfilter/ip_tables.c                  |   1 +
 net/ipv6/netfilter/ip6_tables.c                 |   1 +
 net/netfilter/core.c                            |   3 +-
 net/netfilter/ipvs/ip_vs_conn.c                 |  17 +-
 net/netfilter/ipvs/ip_vs_core.c                 |  12 ++
 net/netfilter/nf_conntrack_proto_tcp.c          |  11 ++
 net/netfilter/nf_tables_api.c                   |  77 +++++++--
 net/netfilter/nf_tables_core.c                  |  21 ++-
 net/netfilter/nfnetlink_acct.c                  |   2 +-
 net/netfilter/nfnetlink_cthelper.c              |   7 +-
 net/netfilter/nft_compat.c                      | 201 ++++++++++++++++++------
 net/netfilter/nft_immediate.c                   |  15 +-
 net/netfilter/x_tables.c                        |   6 +
 16 files changed, 299 insertions(+), 87 deletions(-)
