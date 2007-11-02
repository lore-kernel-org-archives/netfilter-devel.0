From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 07/07]: ebt_arp: fix --arp-gratuitous matching dependence on --arp-ip-{src,dst}
Date: Fri,  2 Nov 2007 12:23:20 +0100 (MET)
Message-ID: <20071102112009.22803.31470.sendpatchset@localhost.localdomain>
References: <20071102112000.22803.92699.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45745 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbXKBLXV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Nov 2007 07:23:21 -0400
In-Reply-To: <20071102112000.22803.92699.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: ebt_arp: fix --arp-gratuitous matching dependence on --arp=
-ip-{src,dst}

=46ix --arp-gratuitous matching dependence on --arp-ip-{src,dst}

Signed-off-by: Bart De Schuymer <bdschuym@pandora.be>
Signed-off-by: Lutz Pre=DFler <Lutz.Pressler@SerNet.DE>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f7cfef5c02de8bbd3421cbc90d0734eef78872bb
tree 67c36f2b2768d7067cd90e3425c4ae61bf8d9d32
parent 430f032387ee5ed1babaac827c116493d79217d8
author Bart De Schuymer <bdschuym@pandora.be> Fri, 02 Nov 2007 11:58:58=
 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 02 Nov 2007 11:58:58 +=
0100

 net/bridge/netfilter/ebt_arp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/bridge/netfilter/ebt_arp.c b/net/bridge/netfilter/ebt_=
arp.c
index 1a46952..1814139 100644
--- a/net/bridge/netfilter/ebt_arp.c
+++ b/net/bridge/netfilter/ebt_arp.c
@@ -34,7 +34,7 @@ static int ebt_filter_arp(const struct sk_buff *skb, =
const struct net_device *in
 	   ah->ar_pro, EBT_ARP_PTYPE))
 		return EBT_NOMATCH;
=20
-	if (info->bitmask & (EBT_ARP_SRC_IP | EBT_ARP_DST_IP)) {
+	if (info->bitmask & (EBT_ARP_SRC_IP | EBT_ARP_DST_IP | EBT_ARP_GRAT))=
 {
 		__be32 saddr, daddr, *sap, *dap;
=20
 		if (ah->ar_pln !=3D sizeof(__be32) || ah->ar_pro !=3D htons(ETH_P_IP=
))
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
