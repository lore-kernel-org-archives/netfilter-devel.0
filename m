From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 00/20] Netfilter/IPVS updates for net-next
Date: Sat,  2 Jun 2018 02:22:39 +0200
Message-ID: <20180602002259.4024-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter/IPVS updates for your net-next
tree, the most relevant things in this batch are:

1) Compile masquerade infrastructure into NAT module, from Florian Westphal.
   Same thing with the redirection support.

2) Abort transaction if early initialization of the commit phase fails.
   Also from Florian.

3) Get rid of synchronize_rcu() by using rule array in nf_tables, from
   Florian.

4) Abort nf_tables batch if fatal signal is pending, from Florian.

5) Use .call_rcu nfnetlink from nf_tables to make dumps fully lockless.
   From Florian Westphal.

6) Support to match transparent sockets from nf_tables, from Máté Eckl.

7) Audit support for nf_tables, from Phil Sutter.

8) Validate chain dependencies from commit phase, fall back to fine grain
   validation only in case of errors.

9) Attach dst to skbuff from netfilter flowtable packet path, from
   Jason A. Donenfeld.

10) Use artificial maximum attribute cap to remove VLA from nfnetlink.
    Patch from Kees Cook.

11) Add extension to allow to forward packets through neighbour layer.

12) Add IPv6 conntrack helper support to IPVS, from Julian Anastasov.

13) Add IPv6 FTP conntrack support to IPVS, from Julian Anastasov.

Plus patches including small incremental improvements.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks.

----------------------------------------------------------------

The following changes since commit 5b79c2af667c0e2684f2a6dbf6439074b78f490c:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2018-05-26 19:46:15 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to d12e12299a6915fc10131602cca41170e46ae755:

  ipvs: add ipv6 support to ftp (2018-06-01 14:01:54 +0200)

----------------------------------------------------------------
Florian Westphal (8):
      netfilter: nat: merge ipv4/ipv6 masquerade code into main nat module
      netfilter: nat: merge nf_nat_redirect into nf_nat
      netfilter: nfnetlink: allow commit to fail
      netfilter: nf_tables: remove synchronize_rcu in commit phase
      netfilter: nft_compat: use call_rcu for nfnl_compat_get
      netfilter: nf_tables: fix endian mismatch in return type
      netfilter: nf_tables: fail batch if fatal signal is pending
      netfilter: nf_tables: use call_rcu in netlink dumps

Jason A. Donenfeld (1):
      netfilter: nf_flow_table: attach dst to skbs

Julian Anastasov (2):
      ipvs: add full ipv6 support to nfct
      ipvs: add ipv6 support to ftp

Kees Cook (1):
      netfilter: nfnetlink: Remove VLA usage

Máté Eckl (2):
      netfilter: add includes to nf_socket.h
      netfilter: nf_tables: add support for native socket matching

Pablo Neira Ayuso (2):
      netfilter: nf_tables: fix chain dependency validation
      netfilter: nft_fwd_netdev: allow to forward packets via neighbour layer

Phil Sutter (1):
      netfilter: nf_tables: Add audit support to log statement

Taehee Yoo (1):
      netfilter: nf_tables: remove unused variables

Wei Yongjun (1):
      netfilter: nat: make symbol nat_hook static

kbuild test robot (1):
      netfilter: fix ptr_ret.cocci warnings

 include/linux/netfilter/nfnetlink.h         |   1 +
 include/net/ip_vs.h                         |  10 +-
 include/net/netfilter/nf_socket.h           |   6 +-
 include/net/netfilter/nf_tables.h           |   7 +
 include/net/netfilter/nf_tables_core.h      |   8 +
 include/net/netns/nftables.h                |   1 +
 include/uapi/linux/netfilter/nf_tables.h    |  34 ++
 net/ipv4/netfilter/Kconfig                  |   5 +-
 net/ipv4/netfilter/Makefile                 |   4 +-
 net/ipv4/netfilter/nf_nat_masquerade_ipv4.c |   4 -
 net/ipv6/netfilter/Kconfig                  |   5 +-
 net/ipv6/netfilter/Makefile                 |   2 +-
 net/ipv6/netfilter/nf_nat_masquerade_ipv6.c |   4 -
 net/netfilter/Kconfig                       |  15 +-
 net/netfilter/Makefile                      |   3 +-
 net/netfilter/ipvs/ip_vs_app.c              |  24 +-
 net/netfilter/ipvs/ip_vs_ftp.c              | 467 +++++++++++++++++----------
 net/netfilter/ipvs/ip_vs_nfct.c             | 101 +++---
 net/netfilter/ipvs/ip_vs_proto_sctp.c       |   4 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c        |   4 +-
 net/netfilter/ipvs/ip_vs_proto_udp.c        |   4 +-
 net/netfilter/nf_flow_table_ip.c            |   6 +-
 net/netfilter/nf_nat_core.c                 |   2 +-
 net/netfilter/nf_nat_redirect.c             |   4 -
 net/netfilter/nf_tables_api.c               | 469 +++++++++++++++++++++++-----
 net/netfilter/nf_tables_core.c              |  40 +--
 net/netfilter/nfnetlink.c                   |  44 ++-
 net/netfilter/nft_compat.c                  |  29 +-
 net/netfilter/nft_fwd_netdev.c              | 146 ++++++++-
 net/netfilter/nft_hash.c                    |  10 +-
 net/netfilter/nft_immediate.c               |  27 +-
 net/netfilter/nft_log.c                     |  92 +++++-
 net/netfilter/nft_lookup.c                  |  47 +++
 net/netfilter/nft_numgen.c                  |   5 +-
 net/netfilter/nft_socket.c                  | 143 +++++++++
 35 files changed, 1372 insertions(+), 405 deletions(-)
 create mode 100644 net/netfilter/nft_socket.c
