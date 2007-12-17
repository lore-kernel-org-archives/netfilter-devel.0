From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 33/64]: xt_TCPMSS: don't allow netfilter --setmss to increase mss
Date: Tue, 18 Dec 2007 00:46:58 +0100 (MET)
Message-ID: <20071217234657.23601.69949.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38978 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875AbXLQXrA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:00 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: xt_TCPMSS: don't allow netfilter --setmss to increase mss

When terminating DSL connections for an assortment of random customers, I've
found it necessary to use iptables to clamp the MSS used for connections to
work around the various ICMP blackholes in the greater net.  Unfortunately,
the current behaviour in Linux is imperfect and actually make things worse,
so I'm proposing the following: increasing the MSS in a packet can never be
a good thing, so make --set-mss only lower the MSS in a packet.

Yes, I am aware of --clamp-mss-to-pmtu, but it doesn't work for outgoing
connections from clients (ie web traffic), as it only looks at the PMTU on
the destination route, not the source of the packet (the DSL interfaces in
question have a 1442 byte MTU while the destination ethernet interface is
1500 -- there are problematic hosts which use a 1300 byte MTU).  Reworking
that is probably a good idea at some point, but it's more work than this is.

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9e9b510cb6ca4fd63e7dea2ded5ff87f84897498
tree 4103474d644ca4cc684a40fd8a042e52cc14df23
parent 0e08f9705361e4b662dad414c2c4a20c30f92d31
author Benjamin LaHaise <bcrl@kvack.org> Mon, 17 Dec 2007 14:58:17 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:56 +0100

 net/netfilter/xt_TCPMSS.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index e4ee4bc..a1bc77f 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -88,8 +88,11 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 
 			oldmss = (opt[i+2] << 8) | opt[i+3];
 
-			if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
-			    oldmss <= newmss)
+			/* Never increase MSS, even when setting it, as
+			 * doing so results in problems for hosts that rely
+			 * on MSS being set correctly.
+			 */
+			if (oldmss <= newmss)
 				return 0;
 
 			opt[i+2] = (newmss & 0xff00) >> 8;
