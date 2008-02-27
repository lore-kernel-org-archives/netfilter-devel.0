From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/05]: Netfilter fixes
Date: Wed, 27 Feb 2008 14:14:19 +0100 (MET)
Message-ID: <20080227131427.26831.51195.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53797 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998AbYB0NOW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2008 08:14:22 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

these patches for 2.6.25 fix a couple of netfilter bugs: the
smp_processor_id() warning when using preemptible RCU reported
by multiple people, address and state matching in the new
xt_conntrack revision, and improper use of parenthesis in
the NF_QUEUE_NR macro.

Additionally there is a patch to make the NAT core behave similar
to the recently removed SAME target for SNAT, which fixes problems
when accesing certain multihomed sites.

Please apply, thanks.


 include/linux/netfilter.h         |    2 +-
 net/ipv4/netfilter/nf_nat_core.c  |   11 +++++++----
 net/netfilter/nf_conntrack_core.c |   15 ++++++++++++---
 net/netfilter/xt_conntrack.c      |    4 ++--
 4 files changed, 22 insertions(+), 10 deletions(-)

Jan Engelhardt (2):
      [NETFILTER]: xt_conntrack: fix missing boolean clamping
      [NETFILTER]: xt_conntrack: fix IPv4 address comparison

Patrick McHardy (3):
      [NETFILTER]: nf_conntrack: fix smp_processor_id() in preemptible code warning
      [NETFILTER]: nf_nat: always select same SNAT source for same host
      [NETFILTER]: Fix NF_QUEUE_NR() parenthesis
