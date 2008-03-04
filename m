From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 16/19] [NETFILTER]: Explicitly initialize .priority in
 arptable_filter
Date: Tue, 4 Mar 2008 17:37:31 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803041737190.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47336 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765075AbYCDQhc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:37:32 -0500
In-Reply-To: <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit a26e22d56128682e37ebc2106324654783193458
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Thu Feb 14 04:00:29 2008 +0100

    [NETFILTER]: Explicitly initialize .priority in arptable_filter
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 net/ipv4/netfilter/arptable_filter.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 56c8db9..cd69fdc 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -70,18 +70,21 @@ static struct nf_hook_ops arpt_ops[] __read_mostly = {
 		.owner		= THIS_MODULE,
 		.pf		= AF_ARP,
 		.hooknum	= NF_ARP_IN,
+		.priority	= NF_IP_PRI_FILTER,
 	},
 	{
 		.hook		= arpt_hook,
 		.owner		= THIS_MODULE,
 		.pf		= AF_ARP,
 		.hooknum	= NF_ARP_OUT,
+		.priority	= NF_IP_PRI_FILTER,
 	},
 	{
 		.hook		= arpt_hook,
 		.owner		= THIS_MODULE,
 		.pf		= AF_ARP,
 		.hooknum	= NF_ARP_FORWARD,
+		.priority	= NF_IP_PRI_FILTER,
 	},
 };
 
