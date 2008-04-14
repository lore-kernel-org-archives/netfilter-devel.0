From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 14/41]: Explicitly initialize .priority in arptable_filter
Date: Mon, 14 Apr 2008 12:16:37 +0200 (MEST)
Message-ID: <20080414101634.32717.61803.sendpatchset@localhost.localdomain>
References: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36272 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbYDNKQi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:16:38 -0400
In-Reply-To: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: Explicitly initialize .priority in arptable_filter

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 598490926dcfaf23b34ceb0330b03767e2c8b25c
tree 1a7c46102699f331b22e4ae72768c3c6cc2c3e1c
parent 1915da7080f836cb560552d3a5949eee60fb6e5e
author Jan Engelhardt <jengelh@computergmbh.de> Mon, 14 Apr 2008 12:10:46 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:46 +0200

 net/ipv4/netfilter/arptable_filter.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 9f6526c..3be4d07 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -70,18 +70,21 @@ static struct nf_hook_ops arpt_ops[] __read_mostly = {
 		.owner		= THIS_MODULE,
 		.pf		= NF_ARP,
 		.hooknum	= NF_ARP_IN,
+		.priority	= NF_IP_PRI_FILTER,
 	},
 	{
 		.hook		= arpt_hook,
 		.owner		= THIS_MODULE,
 		.pf		= NF_ARP,
 		.hooknum	= NF_ARP_OUT,
+		.priority	= NF_IP_PRI_FILTER,
 	},
 	{
 		.hook		= arpt_hook,
 		.owner		= THIS_MODULE,
 		.pf		= NF_ARP,
 		.hooknum	= NF_ARP_FORWARD,
+		.priority	= NF_IP_PRI_FILTER,
 	},
 };
 
