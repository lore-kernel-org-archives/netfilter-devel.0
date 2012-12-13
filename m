From: Jan Engelhardt <jengelh@inai.de>
Subject: Formal submission of Xtables2
Date: Thu, 13 Dec 2012 07:00:07 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1212130601210.9421@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Netfilter user mailing list <netfilter@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:55117 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720Ab2LMGAJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Dec 2012 01:00:09 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Greetings.


This is Xtables2, a collective term used for much-sought enhancements
to the already-existing xtables infrastructure
(net/netfilter/x_tables.c and so on).

In this patch series of size 33, a new Netlink interface that gives
more flexibility for future extending is introduced, as well as a new
family-independent table space that removes the need to have the many
tables that classic {ip,ip6,eb,arp}tables does.

Network namespaces, arbitrary chain nesting and atomic rule
replacement as you know it is also retained/available again. Matches,
targets, verdicts (collectively known as actions) can appear in
arbitrary order. Existing xt_*.ko extensions continue to be usable,
provided they are coded for NFPROTO_UNSPEC operation. Of course,
there are more improvements planned.



Please consider for merging.

The set consists of some 33 patches. Do you want me to post them in 
chunks of ~11-13, or all at once, (or any other arrangement)?


Thanks everybody.

== git toolchain form output ==


The following changes since commit e4e541a84863b6a41f2427f59cc9156c644491a8:

  sock-diag: Report shutdown for inet and unix sockets (v2) (2012-10-23 14:57:52 -0400)

are available in the git repository at:

  git://git.inai.de/linux xtables2_a9

for you to fetch changes up to 1cf0d7b3398109bddf4e8bfb740fcc36a9ed72ed:

  netfilter: xtables2: support for goto action type (2012-12-13 06:30:38 +0100)

----------------------------------------------------------------
[The first two patches are needed for "base chain functionality",
but they live at the front so that I do not (did not)
get whole-kernel recompiles when amending any of the xtables2
commits, which is a relief.]

Jan Engelhardt (33):
      netfilter: add a private member to nf_hook_ops
      netfilter: make nf_hook_ops.priv available to hooks
      netfilter: xtables2: initial table skeletal functions
      netfilter: xtables2: initial Netlink interface
      netfilter: xtables2: chain creation and deletion
      netfilter: xtables2: transaction commit operation
      netfilter: xtables2: (atomic) table replace support
      netfilter: xtables2: transaction abort support
      netfilter: xtables2: redirect writes into transaction buffer
      netfilter: xtables2: supply a revision number
      netfilter: xtables2: chain dump support
      netfilter: xtables2: table dump support
      netfilter: xtables2: prepare for addition of more transaction buffer types
      netfilter: xtables2: implement the splice buffer
      netfilter: xtables2: skeleton for single rules and rule buffer
      netfilter: xtables2: core part for splice operation
      netfilter: xtables2: netlink part for splice operation
      netfilter: xtables2: rule entry handler
      netfilter: xtables2: rule dumping
      netfilter: xtables2: base chain functionality
      netfilter: xtables2: support nomination for chains
      netfilter: xtables2: support for entering/dumping rule verdicts
      netfilter: xtables2: execute verdicts in live rule traversal
      netfilter: xtables2: store netns in table and rule blob
      netfilter: xtables2: iterator for obtain/drop references to actions
      netfilter: xtables2: support for entering/dumping match actions
      netfilter: xtables2: execute matches in live rule traversal
      netfilter: xtables2: support for entering/dumping target actions
      netfilter: xtables2: execute targets in live rule traversal
      netfilter: xtables2: support for entering/dumping jumps
      netfilter: xtables2: provide a jump stack
      netfilter: xtables2: execute jump actions in live rule traversal
      netfilter: xtables2: support for goto action type

 include/linux/netfilter.h                        |   20 +-
 include/net/netfilter/xt_core.h                  |  275 ++++
 include/uapi/linux/netfilter/Kbuild              |    1 +
 include/uapi/linux/netfilter/nfnetlink.h         |    3 +-
 include/uapi/linux/netfilter/nfnetlink_xtables.h |  124 ++
 net/bridge/br_netfilter.c                        |   60 +-
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
 net/netfilter/Kconfig                            |    8 +-
 net/netfilter/Makefile                           |    2 +
 net/netfilter/core.c                             |    2 +-
 net/netfilter/ipvs/ip_vs_core.c                  |   40 +-
 net/netfilter/xt_core.c                          | 1473 +++++++++++++++++++++
 net/netfilter/xt_nfnetlink.c                     | 1520 ++++++++++++++++++++++
 net/netfilter/xt_nfnetlink.h                     |    7 +
 security/selinux/hooks.c                         |   47 +-
 33 files changed, 3646 insertions(+), 239 deletions(-)
 create mode 100644 include/net/netfilter/xt_core.h
 create mode 100644 include/uapi/linux/netfilter/nfnetlink_xtables.h
 create mode 100644 net/netfilter/xt_core.c
 create mode 100644 net/netfilter/xt_nfnetlink.c
 create mode 100644 net/netfilter/xt_nfnetlink.h


== Ohloh Line Count Summary ==

Language  Files       Code    Comment  Comment %      Blank      Total
--------  -----  ---------  ---------  ---------  ---------  ---------
c             4       2097        744      26.2%        283       3124
cpp           1        166         86      34.1%         23        275
--------  -----  ---------  ---------  ---------  ---------  ---------
Total         5       2263        830      26.8%        306       3399
