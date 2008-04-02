From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 10/24] [NETFILTER]: Explicitly initialize .priority in arptable_filter
Date: Wed,  2 Apr 2008 13:11:52 +0200
Message-ID: <724a5601d76a12d33143434f007e427f45fc6692.1207134547.git.jengelh@computergmbh.de>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43159 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788AbYDBLMK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:12:10 -0400
In-Reply-To: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <455b3b0ee249d17dff621933f163b8d5e377eb8f.1207134547.git.jengelh@computergmbh.de>
References: <455b3b0ee249d17dff621933f163b8d5e377eb8f.1207134547.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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
 
-- 
1.5.4.4

