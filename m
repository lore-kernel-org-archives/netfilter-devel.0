From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: commit 720350a38b1dbd43c907d5d81decd6edd6725d81
Date: Tue, 25 Mar 2008 19:06:18 +0100
Message-ID: <1206468391-368-16-git-send-email-jengelh@computergmbh.de>
References: <alpine.LNX.1.10.0803251903230.31276@fbirervta.pbzchgretzou.qr>
 <1206468391-368-1-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-2-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-3-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-4-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-5-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-6-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-7-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-8-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-9-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-10-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-11-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-12-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-13-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-14-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-15-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52540 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759210AbYCYSGh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:06:37 -0400
In-Reply-To: <1206468391-368-15-git-send-email-jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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
 
