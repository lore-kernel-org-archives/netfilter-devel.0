From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: fix arptable_filter wrong hook registering
Date: Thu, 16 Oct 2008 03:24:52 +0200
Message-ID: <20081016012451.6126.34071.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49548 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753156AbYJPBY7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Oct 2008 21:24:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch replaces NFPROTO_ARP by NF_ARP in the hooks registered
by arptable_filter, otherwise the arptables tool does not work.
Thus, we use NF_ARP to register ARP hooks to match the NF_HOOK
invocation in net/ipv4/arp.c and NFPROTO_ARP for internal xtables
handling, ie. matches, targets and tables.

This patch also fixes the ARP mangling in the ipt_CLUSTERIP target.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 net/ipv4/netfilter/arptable_filter.c |    6 +++---
 net/ipv4/netfilter/ipt_CLUSTERIP.c   |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index bee3d11..984d05d 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -89,21 +89,21 @@ static struct nf_hook_ops arpt_ops[] __read_mostly = {
 	{
 		.hook		= arpt_in_hook,
 		.owner		= THIS_MODULE,
-		.pf		= NFPROTO_ARP,
+		.pf		= NF_ARP,
 		.hooknum	= NF_ARP_IN,
 		.priority	= NF_IP_PRI_FILTER,
 	},
 	{
 		.hook		= arpt_out_hook,
 		.owner		= THIS_MODULE,
-		.pf		= NFPROTO_ARP,
+		.pf		= NF_ARP,
 		.hooknum	= NF_ARP_OUT,
 		.priority	= NF_IP_PRI_FILTER,
 	},
 	{
 		.hook		= arpt_forward_hook,
 		.owner		= THIS_MODULE,
-		.pf		= NFPROTO_ARP,
+		.pf		= NF_ARP,
 		.hooknum	= NF_ARP_FORWARD,
 		.priority	= NF_IP_PRI_FILTER,
 	},
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 7ac1677..af8b1bb 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -541,7 +541,7 @@ arp_mangle(unsigned int hook,
 
 static struct nf_hook_ops cip_arp_ops __read_mostly = {
 	.hook = arp_mangle,
-	.pf = NFPROTO_ARP,
+	.pf = NF_ARP,
 	.hooknum = NF_ARP_OUT,
 	.priority = -1
 };

