From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 00/06: netfilter update
Date: Sun, 27 Jul 2008 01:37:06 +0200 (MEST)
Message-ID: <20080726233705.15283.38364.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43526 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbYGZXhI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Jul 2008 19:37:08 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

the following patchset contains a small netfilter update, consisting of:

- the nf_iterate bugfix from Pekka

- minor ct_extend cleanups for issues pointed out by Linus

- two cleanup patches from Alexey to make use of nf_register_hooks where possible

- a bugfix from Alexey for a section mismatch in the security tables that will
  be noticable once NET_NS and SECURITY won't be mutually exclusive anymore

- a patch to make arp_tables net_ns aware. I already had this one queued and
  it doesn't seem worth postponing.

Please apply, thanks.


 include/linux/slab.h                   |    1 +
 mm/util.c                              |   44 ++++++++++++++++++++++++-------
 net/bridge/netfilter/ebtable_filter.c  |   18 +++---------
 net/bridge/netfilter/ebtable_nat.c     |   18 +++---------
 net/ipv4/netfilter/arptable_filter.c   |   39 +++++++++++++++++++++------
 net/ipv4/netfilter/iptable_security.c  |    2 +-
 net/ipv6/netfilter/ip6table_security.c |    2 +-
 net/netfilter/nf_conntrack_extend.c    |   10 +++---
 security/selinux/hooks.c               |   27 ++++++-------------
 9 files changed, 90 insertions(+), 71 deletions(-)

Alexey Dobriyan (4):
      netfilter: ebtables: use nf_register_hooks()
      selinux: use nf_register_hooks()
      netfilter: ip{,6}tables_security: fix future section mismatch
      netfilter: arptables in netns for real

Patrick McHardy (1):
      netfilter: nf_conntrack_extend: avoid unnecessary "ct->ext" dereferences

Pekka Enberg (1):
      netfilter: fix double-free and use-after free
