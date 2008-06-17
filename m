From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 00/03: netfilter fixes
Date: Tue, 17 Jun 2008 16:03:51 +0200 (MEST)
Message-ID: <20080617140351.1355.59710.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65207 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757838AbYFQODx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Jun 2008 10:03:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

following are three fixes for netfilter:

- fix for NAT RCU races related to ct_extend
- fix for a memory leak in a H.323 module init error path
- fix for a crash when unloading the H.323 module while H.245 expectation
  or connections are active

Please apply, thanks.


 include/net/netfilter/nf_conntrack_extend.h |    1 +
 net/ipv4/netfilter/nf_nat_core.c            |    3 +--
 net/netfilter/nf_conntrack_extend.c         |    9 ++++++++-
 net/netfilter/nf_conntrack_h323_main.c      |   22 +++++++++++++++-------
 4 files changed, 25 insertions(+), 10 deletions(-)

Patrick McHardy (3):
      netfilter: nf_nat: fix RCU races
      netfilter: nf_conntrack_h323: fix memory leak in module initialization error path
      netfilter: nf_conntrack_h323: fix module unload crash
