From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 00/12] Netfilter fixes for net
Date: Wed, 13 Dec 2017 19:45:08 +0100
Message-ID: <20171213184520.8193-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The follow patchset contains Netfilter fixes for your net tree,
they are:

1) Fix compilation warning in x_tables with clang due to useless
   redundant reassignment, from Colin Ian King.

2) Add bugtrap to net_exit to catch uninitialized lists, patch
   from Vasily Averin.

3) Fix out of bounds memory reads in H323 conntrack helper, this
   comes with an initial patch to remove replace the obscure
   CHECK_BOUND macro as a dependency. From Eric Sesterhenn.

4) Reduce retransmission timeout when window is 0 in TCP conntrack,
   from Florian Westphal.

6) ctnetlink clamp timeout to INT_MAX if timeout is too large,
   otherwise timeout wraps around and it results in killing the
   entry that is being added immediately.

7) Missing CAP_NET_ADMIN checks in cthelper and xt_osf, due to
   no netns support. From Kevin Cernekee.

8) Missing maximum number of instructions checks in xt_bpf, patch
   from Jann Horn.

9) With no CONFIG_PROC_FS ipt_CLUSTERIP compilation breaks,
   patch from Arnd Bergmann.

10) Missing netlink attribute policy in nftables exthdr, from
    Florian Westphal.

11) Enable conntrack with IPv6 MASQUERADE rules, as a357b3f80bc8
    should have done in first place, from Konstantin Khlebnikov.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks a lot!

----------------------------------------------------------------

The following changes since commit 32a72bbd5da2411eab591bf9bc2e39349106193a:

  net: vxge: Fix some indentation issues (2017-11-20 11:36:30 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 23715275e4fb6f64358a499d20928a9e93819f2f:

  netfilter: ip6t_MASQUERADE: add dependency on conntrack module (2017-12-11 17:04:50 +0100)

----------------------------------------------------------------
Arnd Bergmann (1):
      netfilter: ipt_CLUSTERIP: fix clusterip_net_exit build regression

Colin Ian King (1):
      netfilter: remove redundant assignment to e

Eric Sesterhenn (2):
      netfilter: nf_ct_h323: Convert CHECK_BOUND macro to function
      netfilter: nf_ct_h323: Extend nf_h323_error_boundary to work on bits as well

Florian Westphal (2):
      netfilter: conntrack: lower timeout to RETRANS seconds if window is 0
      netfilter: exthdr: add missign attributes to policy

Jann Horn (1):
      netfilter: xt_bpf: add overflow checks

Jay Elliott (1):
      netfilter: conntrack: clamp timeouts to INT_MAX

Kevin Cernekee (2):
      netfilter: nfnetlink_cthelper: Add missing permission checks
      netfilter: xt_osf: Add missing permission checks

Konstantin Khlebnikov (1):
      netfilter: ip6t_MASQUERADE: add dependency on conntrack module

Vasily Averin (1):
      netfilter: exit_net cleanup check added

 net/ipv4/netfilter/arp_tables.c        |   1 -
 net/ipv4/netfilter/ip_tables.c         |   1 -
 net/ipv4/netfilter/ipt_CLUSTERIP.c     |   3 +-
 net/ipv6/netfilter/ip6_tables.c        |   1 -
 net/ipv6/netfilter/ip6t_MASQUERADE.c   |   8 ++-
 net/netfilter/nf_conntrack_h323_asn1.c | 128 +++++++++++++++++++++++++--------
 net/netfilter/nf_conntrack_netlink.c   |  12 +++-
 net/netfilter/nf_conntrack_proto_tcp.c |   3 +
 net/netfilter/nf_tables_api.c          |   7 ++
 net/netfilter/nfnetlink_cthelper.c     |  10 +++
 net/netfilter/nfnetlink_log.c          |   5 ++
 net/netfilter/nfnetlink_queue.c        |   5 ++
 net/netfilter/nft_exthdr.c             |   2 +
 net/netfilter/x_tables.c               |   9 +++
 net/netfilter/xt_bpf.c                 |   6 ++
 net/netfilter/xt_osf.c                 |   7 ++
 16 files changed, 170 insertions(+), 38 deletions(-)
