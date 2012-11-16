From: Jan Engelhardt <jengelh@inai.de>
Subject: Xtables2 status for Nov 15 (RFC)
Date: Fri, 16 Nov 2012 02:23:34 +0100
Message-ID: <1353029025-31635-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:45169 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab2KPBXx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 20:23:53 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



This is the second set of patches in the list that makes up Xtables2 so far
that I like to elicit comments for.
(The parent thread is at
http://www.spinics.net/lists/netfilter-devel/msg23925.html )

"highlights":
* Atomic replace of a contiguous set of rules within a chain.
  This is actually a side-effect of chain packing.
* Arbitrary chains can become base chains (the magic INPUT, OUTPUT, etc.).
  [Inspirted by Patrick's original nftables. No credit for me there.], but:
* Table replace remains fully atomic during the nf_hook
  deregister-register cycle. (NB: Chain-level replacements do not
  require a hook change.)



== userspace library and test utilities ==
Updated and available as before in

	git://git.inai.de/libnetfilter_xtables


== kernel side ==
The following changes since commit e41d937ea3b35cca3f636861e520bc9f51dbc720:
  netfilter: xtables2: table dump support (2012-11-15 23:22:21 +0100)
are available in the git repository at:

  git://git.inai.de/linux  xt2-20121115-2315

for you to fetch changes up to adef2d8b21ac2cab08948e252d71620d02525ec0:
  netfilter: xtables2: support nomination for chains (2012-11-15 23:26:28 +0100)
----------------------------------------------------------------
      netfilter: xtables2: prepare for addition of more transaction b~~
      netfilter: xtables2: implement the splice buffer
      netfilter: xtables2: skeleton for single rules and rule buffer
      netfilter: xtables2: core part for splice operation
      netfilter: xtables2: netlink part for splice operation
      netfilter: xtables2: rule entry handler
      netfilter: xtables2: rule dumping
      netfilter: add a private member to nf_hook_ops
      netfilter: make nf_hook_ops.priv available to hooks
      netfilter: xtables2: base chain functionality
      netfilter: xtables2: support nomination for chains

 include/linux/netfilter.h                        |   20 +-
 include/net/netfilter/xt_core.h                  |   75 +++
 include/uapi/linux/netfilter/nfnetlink_xtables.h |   24 +-
 net/bridge/br_netfilter.c                        |   60 +--
 net/bridge/netfilter/ebtable_filter.c            |   16 +-
 net/bridge/netfilter/ebtable_nat.c               |   16 +-
 net/decnet/netfilter/dn_rtmsg.c                  |    9 +-
 net/ipv4/netfilter/arptable_filter.c             |    5 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c               |    6 +-
 net/ipv4/netfilter/iptable_filter.c              |    7 +-
 net/ipv4/netfilter/iptable_mangle.c              |   16 +-
 net/ipv4/netfilter/iptable_nat.c                 |   38 +-
 net/ipv4/netfilter/iptable_raw.c                 |    6 +-
 net/ipv4/netfilter/iptable_security.c            |    7 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c   |   42 +-
 net/ipv4/netfilter/nf_defrag_ipv4.c              |   14 +-
 net/ipv6/netfilter/ip6table_filter.c             |    5 +-
 net/ipv6/netfilter/ip6table_mangle.c             |   10 +-
 net/ipv6/netfilter/ip6table_nat.c                |   39 +-
 net/ipv6/netfilter/ip6table_raw.c                |    5 +-
 net/ipv6/netfilter/ip6table_security.c           |    5 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c   |   44 +-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c        |   13 +-
 net/netfilter/core.c                             |    2 +-
 net/netfilter/ipvs/ip_vs_core.c                  |   40 +-
 net/netfilter/xt_core.c                          |  539 +++++++++++++++++++++-
 net/netfilter/xt_nfnetlink.c                     |  377 ++++++++++++++-
 security/selinux/hooks.c                         |   47 +-
 28 files changed, 1226 insertions(+), 261 deletions(-)

                          Ohloh Line Count Summary
Language          Files       Code    Comment  Comment %      Blank      Total
----------------  -----  ---------  ---------  ---------  ---------  ---------
c                     7       1775        634      26.3%        274       2683
