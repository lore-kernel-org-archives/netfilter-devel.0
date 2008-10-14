From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 00/03: netfilter fixes
Date: Tue, 14 Oct 2008 16:48:44 +0200 (MEST)
Message-ID: <20081014144843.27355.98898.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38311 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbYJNOsq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Oct 2008 10:48:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

following are some netfilter fixes for 2.6.28, containing:

- restauration of a lost #ifdef to fix user-triggerable WARN_ONs in the
  NAT code. Also queued for -stable.

- restauration of ebtables dependencies that got lost during a Kconfig
  restructuring

- a slightly more involved patch from Pablo to remove the bogus NAT module
  dependencies from ctnetlink. It could be argued whether this qualifies as
  a real bugfix since its mainly a "it shouldn't be like this" thing and
  everything works properly, in my opinion it does though because of all
  the side effects that even just loading the NAT module causes. A somewhat
  fitting analogy would be an IPv6 module dependency in, lets say, TCP :)

Please apply, thanks.


 include/linux/netfilter/nfnetlink.h  |    3 +
 include/net/netfilter/nf_nat_core.h  |    8 ++
 net/bridge/netfilter/Kconfig         |    1 +
 net/ipv4/netfilter/nf_defrag_ipv4.c  |    3 +-
 net/ipv4/netfilter/nf_nat_core.c     |   97 ++++++++++++++++++++++
 net/netfilter/nf_conntrack_core.c    |    7 ++
 net/netfilter/nf_conntrack_netlink.c |  151 ++++++++++++++--------------------
 net/netfilter/nfnetlink.c            |   12 ++-
 8 files changed, 188 insertions(+), 94 deletions(-)

Pablo Neira Ayuso (1):
      netfilter: ctnetlink: remove bogus module dependency between ctnetlink and nf_nat

Patrick McHardy (2):
      netfilter: restore lost #ifdef guarding defrag exception
      netfilter: fix ebtables dependencies
