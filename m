From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/3] Netfilter/IPVS fixes for net
Date: Wed, 13 Feb 2019 18:47:55 +0100
Message-ID: <20190213174758.17275-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter/IPVS fixes for net:

1) Missing structure initialization in ebtables causes splat with
   32-bit user level on a 64-bit kernel, from Francesco Ruggeri.

2) Missing dependency on nf_defrag in IPVS IPv6 codebase, from
   Andrea Claudi.

3) Fix possible use-after-free from release path of target extensions.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

----------------------------------------------------------------

The following changes since commit cf657d22ee1f0e887326a92169f2e28dc932fd10:

  net/x25: do not hold the cpu too long in x25_new_lci() (2019-02-11 13:20:14 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 753c111f655e38bbd52fc01321266633f022ebe2:

  netfilter: nft_compat: use-after-free when deleting targets (2019-02-13 18:14:54 +0100)

----------------------------------------------------------------
Andrea Claudi (1):
      ipvs: fix dependency on nf_defrag_ipv6

Francesco Ruggeri (1):
      netfilter: compat: initialize all fields in xt_init

Pablo Neira Ayuso (1):
      netfilter: nft_compat: use-after-free when deleting targets

 net/netfilter/ipvs/Kconfig      |  1 +
 net/netfilter/ipvs/ip_vs_core.c | 10 ++++------
 net/netfilter/ipvs/ip_vs_ctl.c  | 10 ++++++++++
 net/netfilter/nft_compat.c      |  3 ++-
 net/netfilter/x_tables.c        |  2 +-
 5 files changed, 18 insertions(+), 8 deletions(-)
