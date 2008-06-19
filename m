From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 00/03: netfilter -stable fixes
Date: Thu, 19 Jun 2008 15:05:42 +0200 (MEST)
Message-ID: <20080619130541.26204.54310.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65324 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbYFSNFp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2008 09:05:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These three patches fix some bugs in netfilter:

- a crash when setting up a conntrack with NAT mappings through ctnetlink
  fails after the NAT mappings are set up. Regression present since a
  couple of versions.

- a module unload crash in the H.323 conntrack helper

- a memory leak in the module init function, which is not very important
  itself, but it made easier to use the upstream patch for the module
  unload crash

Please apply, thanks.


 net/netfilter/nf_conntrack_core.c      |    3 +--
 net/netfilter/nf_conntrack_h323_main.c |   22 +++++++++++++++-------
 2 files changed, 16 insertions(+), 9 deletions(-)

Patrick McHardy (3):
      netfilter: nf_conntrack: fix ctnetlink related crash in nf_nat_setup_info()
      netfilter: nf_conntrack_h323: fix memory leak in module initialization error path
      netfilter: nf_conntrack_h323: fix module unload crash
