From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/7] Netfilter/IPVS fixes for net
Date: Mon, 28 Jan 2019 15:03:58 +0100
Message-ID: <20190128140405.15020-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter/IPVS fixes for your net tree:

1) The nftnl mutex is now per-netns, therefore use reference counter
   for matches and targets to deal with concurrent updates from netns.
   Moreover, place extensions in a pernet list. Patches from Florian Westphal.

2) Bail out with EINVAL in case of negative timeouts via setsockopt()
   through ip_vs_set_timeout(), from ZhangXiaoxu.

3) Spurious EINVAL on ebtables 32bit binary with 64bit kernel, also
   from Florian.

4) Reset TCP option header parser in case of fingerprint mismatch,
   otherwise follow up overlapping fingerprint definitions including
   TCP options do not work, from Fernando Fernandez Mancera.

5) Compilation warning in ipt_CLUSTER with CONFIG_PROC_FS unset.
   From Anders Roxell.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

----------------------------------------------------------------

The following changes since commit 88a8121dc1d3d0dbddd411b79ed236b6b6ea415c:

  af_packet: fix raw sockets over 6in4 tunnel (2019-01-17 15:54:45 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 206b8cc514d7ff2b79dd2d5ad939adc7c493f07a:

  netfilter: ipt_CLUSTERIP: fix warning unused variable cn (2019-01-28 11:09:12 +0100)

----------------------------------------------------------------
Anders Roxell (1):
      netfilter: ipt_CLUSTERIP: fix warning unused variable cn

Fernando Fernandez Mancera (1):
      netfilter: nfnetlink_osf: add missing fmatch check

Florian Westphal (4):
      netfilter: nft_compat: use refcnt_t type for nft_xt reference count
      netfilter: nft_compat: make lists per netns
      netfilter: nft_compat: destroy function must not have side effects
      netfilter: ebtables: compat: un-break 32bit setsockopt when no rules are present

ZhangXiaoxu (1):
      ipvs: Fix signed integer overflow when setsockopt timeout

 net/bridge/netfilter/ebtables.c    |   9 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c |   2 +-
 net/netfilter/ipvs/ip_vs_ctl.c     |  12 +++
 net/netfilter/nfnetlink_osf.c      |   4 +
 net/netfilter/nft_compat.c         | 189 ++++++++++++++++++++++++++++---------
 5 files changed, 165 insertions(+), 51 deletions(-)
