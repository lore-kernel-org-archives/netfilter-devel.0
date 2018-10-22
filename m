From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/8] Netfilter fixes for net
Date: Mon, 22 Oct 2018 22:07:16 +0200
Message-ID: <20181022200724.25806-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter fixes for your net tree:

1) rbtree lookup from control plane returns the left-hand side element
   of the range when the interval end flag is set on.

2) osf extension is not supported from the input path, reject this from
   the control plane, from Fernando Fernandez Mancera.

3) xt_TEE is leaving output interface unset due to a recent incorrect
   netns rework, from Taehee Yoo.

4) xt_TEE allows to select an interface which does not belong to this
   netnamespace, from Taehee Yoo.

5) Zero private extension area in nft_compat, just like we do in x_tables,
   otherwise we leak kernel memory to userspace.

6) Missing .checkentry and .destroy entries in new DNAT extensions breaks
   it since we never load nf_conntrack dependencies, from Paolo Abeni.

7) Do not remove flowtable hook from netns exit path, the netdevice handler
   already deals with this, also from Taehee Yoo.

8) Only cleanup flowtable entries that reside in this netnamespace, also
   from Taehee Yoo.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 9a4890bd6d6325a1c88564a20ab310b2d56f6094:

  rds: RDS (tcp) hangs on sendto() to unresponding address (2018-10-10 22:19:52 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to a3fb3698cadf27dc142b24394c401625e14d80d0:

  netfilter: nf_flow_table: do not remove offload when other netns's interface is down (2018-10-19 13:30:48 +0200)

----------------------------------------------------------------
Fernando Fernandez Mancera (1):
      netfilter: nft_osf: usage from output path is not valid

Pablo Neira Ayuso (2):
      netfilter: nft_set_rbtree: allow loose matching of closing element in interval
      netfilter: nft_compat: do not dump private area

Paolo Abeni (1):
      netfilter: xt_nat: fix DNAT target for shifted portmap ranges

Taehee Yoo (4):
      netfilter: xt_TEE: fix wrong interface selection
      netfilter: xt_TEE: add missing code to get interface index in checkentry.
      netfilter: nf_flow_table: remove flowtable hook flush routine in netns exit routine
      netfilter: nf_flow_table: do not remove offload when other netns's interface is down

 net/netfilter/nf_flow_table_core.c |  9 +++--
 net/netfilter/nf_tables_api.c      |  3 --
 net/netfilter/nft_compat.c         | 24 +++++++++++-
 net/netfilter/nft_osf.c            | 10 +++++
 net/netfilter/nft_set_rbtree.c     | 10 ++++-
 net/netfilter/xt_TEE.c             | 76 +++++++++++++++++++++++++++++---------
 net/netfilter/xt_nat.c             |  2 +
 7 files changed, 107 insertions(+), 27 deletions(-)
