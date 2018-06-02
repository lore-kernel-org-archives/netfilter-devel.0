From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/9,v2] Netfilter updates for net-next
Date: Sun,  3 Jun 2018 01:25:39 +0200
Message-ID: <20180602232539.10574-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

v2: Please scratch the previous pull request, it was missing the
    nft_connlimit.c file in diffstat. Sorry about that.

-o-

The following patchset contains Netfilter updates for your net-next tree:

1) Get rid of nf_sk_is_transparent(), use inet_sk_transparent() instead.
   From Máté Eckl.

2) Move shared tproxy infrastructure to nf_tproxy_ipv4 and nf_tproxy_ipv6.
   Also from Máté.

3) Add hashtable to speed up chain lookups by name, from Florian Westphal.

4) Patch series to add connlimit support reusing part of the
   nf_conncount infrastructure. This includes preparation changes such
   passing context to the object and expression destroy interface;
   garbage collection for expressions embedded into set elements, and
   the introduction of the clone_destroy interface for expressions.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks.

----------------------------------------------------------------

The following changes since commit 1ffdd8e1643f6ce28792edd3314be84167faabf1:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next (2018-06-02 09:04:21 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 1b2470e59fb1e983a3655feba30cdfc03e609d51:

  netfilter: nf_tables: handle chain name lookups via rhltable (2018-06-03 01:18:37 +0200)

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: nf_tables: handle chain name lookups via rhltable

Máté Eckl (2):
      netfilter: Decrease code duplication regarding transparent socket option
      netfilter: Libify xt_TPROXY

Pablo Neira Ayuso (6):
      netfilter: nf_tables: pass context to object destroy indirection
      netfilter: nf_conncount: expose connection list interface
      netfilter: nf_tables: pass ctx to nf_tables_expr_destroy()
      netfilter: nf_tables: garbage collection for stateful expressions
      netfilter: nf_tables: add destroy_clone expression
      netfilter: nf_tables: add connlimit support

 include/net/netfilter/nf_conntrack_count.h |  11 +
 include/net/netfilter/nf_socket.h          |  13 -
 include/net/netfilter/nf_tables.h          |  20 +-
 include/net/netfilter/nf_tproxy.h          | 113 +++++++++
 include/uapi/linux/netfilter/nf_tables.h   |  21 +-
 net/ipv4/netfilter/Kconfig                 |   5 +-
 net/ipv4/netfilter/Makefile                |   1 +
 net/ipv4/netfilter/nf_tproxy_ipv4.c        | 147 ++++++++++++
 net/ipv6/netfilter/Kconfig                 |   5 +-
 net/ipv6/netfilter/Makefile                |   1 +
 net/ipv6/netfilter/nf_tproxy_ipv6.c        | 146 ++++++++++++
 net/netfilter/Kconfig                      |  11 +
 net/netfilter/Makefile                     |   1 +
 net/netfilter/nf_conncount.c               |  36 ++-
 net/netfilter/nf_tables_api.c              | 151 ++++++++++--
 net/netfilter/nft_connlimit.c              | 297 +++++++++++++++++++++++
 net/netfilter/nft_counter.c                |   4 +-
 net/netfilter/nft_ct.c                     |   3 +-
 net/netfilter/nft_dynset.c                 |   9 +
 net/netfilter/nft_set_hash.c               |  21 +-
 net/netfilter/nft_socket.c                 |   3 +-
 net/netfilter/xt_TPROXY.c                  | 366 ++---------------------------
 net/netfilter/xt_socket.c                  |   4 +-
 23 files changed, 977 insertions(+), 412 deletions(-)
 create mode 100644 include/net/netfilter/nf_tproxy.h
 create mode 100644 net/ipv4/netfilter/nf_tproxy_ipv4.c
 create mode 100644 net/ipv6/netfilter/nf_tproxy_ipv6.c
 create mode 100644 net/netfilter/nft_connlimit.c
