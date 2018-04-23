From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 00/12] Netfilter/IPVS fixes for net
Date: Mon, 23 Apr 2018 19:57:02 +0200
Message-ID: <20180423175714.9794-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter/IPVS fixes for your net tree,
they are:

1) Fix SIP conntrack with phones sending session descriptions for different
   media types but same port numbers, from Florian Westphal.

2) Fix incorrect rtnl_lock mutex logic from IPVS sync thread, from Julian
   Anastasov.

3) Skip compat array allocation in ebtables if there is no entries, also
   from Florian.

4) Do not lose left/right bits when shifting marks from xt_connmark, from
   Jack Ma.

5) Silence false positive memleak in conntrack extensions, from Cong Wang.

6) Fix CONFIG_NF_REJECT_IPV6=m link problems, from Arnd Bergmann.

7) Cannot kfree rule that is already in list in nf_tables, switch order
   so this error handling is not required, from Florian Westphal.

8) Release set name in error path, from Florian.

9) include kmemleak.h in nf_conntrack_extend.c, from Stepheh Rothwell.

10) NAT chain and extensions depend on NF_TABLES.

11) Out of bound access when renaming chains, from Taehee Yoo.

12) Incorrect casting in xt_connmark leads to wrong bitshifting.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit a2ac99905f1ea8b15997a6ec39af69aa28a3653b:

  vhost-net: set packet weight of tx polling to 2 * vq size (2018-04-09 11:01:37 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 5a786232eb69a1f870ddc0cfd69d5bdef241a2ea:

  netfilter: xt_connmark: do not cast xt_connmark_tginfo1 to xt_connmark_tginfo2 (2018-04-19 16:19:28 +0200)

----------------------------------------------------------------
Arnd Bergmann (1):
      netfilter: fix CONFIG_NF_REJECT_IPV6=m link error

Cong Wang (1):
      netfilter: conntrack: silent a memory leak warning

Florian Westphal (4):
      netfilter: nf_conntrack_sip: allow duplicate SDP expectations
      netfilter: ebtables: don't attempt to allocate 0-sized compat array
      netfilter: nf_tables: can't fail after linking rule into active rule list
      netfilter: nf_tables: free set name in error path

Jack Ma (1):
      netfilter: xt_connmark: Add bit mapping for bit-shift operation.

Julian Anastasov (1):
      ipvs: fix rtnl_lock lockups caused by start_sync_thread

Pablo Neira Ayuso (2):
      netfilter: nf_tables: NAT chain and extensions require NF_TABLES
      netfilter: xt_connmark: do not cast xt_connmark_tginfo1 to xt_connmark_tginfo2

Stephen Rothwell (1):
      netfilter: conntrack: include kmemleak.h for kmemleak_not_leak()

Taehee Yoo (1):
      netfilter: nf_tables: fix out-of-bounds in nft_chain_commit_update

 net/bridge/netfilter/ebtables.c     |  11 +--
 net/ipv6/netfilter/Kconfig          |  55 ++++++-------
 net/netfilter/Kconfig               |   1 +
 net/netfilter/ipvs/ip_vs_ctl.c      |   8 --
 net/netfilter/ipvs/ip_vs_sync.c     | 155 +++++++++++++++++++-----------------
 net/netfilter/nf_conntrack_expect.c |   5 +-
 net/netfilter/nf_conntrack_extend.c |   2 +
 net/netfilter/nf_conntrack_sip.c    |  16 +++-
 net/netfilter/nf_tables_api.c       |  69 ++++++++--------
 net/netfilter/xt_connmark.c         |  49 +++++++-----
 10 files changed, 200 insertions(+), 171 deletions(-)
