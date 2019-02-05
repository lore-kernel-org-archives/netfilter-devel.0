From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/6] Netfilter fixes for net
Date: Tue,  5 Feb 2019 20:04:09 +0100
Message-ID: <20190205190415.25041-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter fixes for net:

1) Use CONFIG_NF_TABLES_INET from seltests, not NF_TABLES_INET.
   From Naresh Kamboju.

2) Add a test to cover masquerading and redirect case, from Florian
   Westphal.

3) Two packets coming from the same socket may race to set up NAT,
   ending up with different tuples and the packet losing race being
   dropped. Update nf_conntrack_tuple_taken() to exercise clash
   resolution for this case. From Martynas Pumputis and Florian
   Westphal.

4) Unbind anonymous sets from the commit and abort path, this fixes
   a splat due to double set list removal/release in case that the
   transaction needs to be aborted.

5) Do not preserve original output interface for packets that are
   redirected in the output chain when ip6_route_me_harder() is
   called. Otherwise packets end up going not going to the loopback
   device. From Eli Cooper.

6) Fix bogus splat in nft_compat with CONFIG_REFCOUNT_FULL=y, this
   also simplifies the existing logic to deal with the list insertions
   of the xtables extensions. From Florian Westphal.

Diffstat look rather larger than usual because of the new selftest, but
Florian and I consider that having tests soon into the tree is good to
improve coverage. If there's a different policy in this regard, please,
let me know.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

----------------------------------------------------------------

The following changes since commit cfe4bd7a257f6d6f81d3458d8c9d9ec4957539e6:

  sctp: check and update stream->out_curr when allocating stream_out (2019-02-03 14:27:47 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 947e492c0fc2132ae5fca081a9c2952ccaab0404:

  netfilter: nft_compat: don't use refcount_inc on newly allocated entry (2019-02-05 14:10:33 +0100)

----------------------------------------------------------------
Eli Cooper (1):
      netfilter: ipv6: Don't preserve original oif for loopback address

Florian Westphal (2):
      selftests: netfilter: add simple masq/redirect test cases
      netfilter: nft_compat: don't use refcount_inc on newly allocated entry

Martynas Pumputis (1):
      netfilter: nf_nat: skip nat clash resolution for same-origin entries

Naresh Kamboju (1):
      selftests: netfilter: fix config fragment CONFIG_NF_TABLES_INET

Pablo Neira Ayuso (1):
      netfilter: nf_tables: unbind set in rule from commit path

 include/net/netfilter/nf_tables.h            |  17 +-
 net/ipv6/netfilter.c                         |   4 +-
 net/netfilter/nf_conntrack_core.c            |  16 +
 net/netfilter/nf_tables_api.c                |  85 ++-
 net/netfilter/nft_compat.c                   |  62 +--
 net/netfilter/nft_dynset.c                   |  18 +-
 net/netfilter/nft_immediate.c                |   6 +-
 net/netfilter/nft_lookup.c                   |  18 +-
 net/netfilter/nft_objref.c                   |  18 +-
 tools/testing/selftests/netfilter/Makefile   |   2 +-
 tools/testing/selftests/netfilter/config     |   2 +-
 tools/testing/selftests/netfilter/nft_nat.sh | 762 +++++++++++++++++++++++++++
 12 files changed, 888 insertions(+), 122 deletions(-)
 create mode 100755 tools/testing/selftests/netfilter/nft_nat.sh
