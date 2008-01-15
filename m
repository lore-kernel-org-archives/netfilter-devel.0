From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/38]: remove ipt_TOS.c
Date: Tue, 15 Jan 2008 07:19:16 +0100 (MET)
Message-ID: <20080115061911.3184.57409.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62162 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbYAOGTR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:19:17 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: remove ipt_TOS.c

Commit 88c85d81f74f92371745158aebc5cbf490412002 forgot to remove the
old ipt_TOS file (whose code has been merged into xt_DSCP). Remove
it now.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 97522ed78f619506ef818b7a7b1160735b47c367
tree db654ff7ce108e2e277ebeeec7678c4603d60621
parent 9eef50d726e834652abc7aca9740b62fbb89c124
author Jan Engelhardt <jengelh@computergmbh.de> Mon, 14 Jan 2008 06:51:09 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:23:22 +0100

 net/ipv4/netfilter/ipt_TOS.c |   82 ------------------------------------------
 1 files changed, 0 insertions(+), 82 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_TOS.c b/net/ipv4/netfilter/ipt_TOS.c
deleted file mode 100644
index 1a92441..0000000
--- a/net/ipv4/netfilter/ipt_TOS.c
+++ /dev/null
@@ -1,82 +0,0 @@
-/* This is a module which is used for setting the TOS field of a packet. */
-
-/* (C) 1999-2001 Paul `Rusty' Russell
- * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/ip.h>
-#include <net/checksum.h>
-
-#include <linux/netfilter/x_tables.h>
-#include <linux/netfilter_ipv4/ipt_TOS.h>
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
-MODULE_DESCRIPTION("iptables TOS mangling module");
-
-static unsigned int
-tos_tg(struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, unsigned int hooknum,
-       const struct xt_target *target, const void *targinfo)
-{
-	const struct ipt_tos_target_info *tosinfo = targinfo;
-	struct iphdr *iph = ip_hdr(skb);
-
-	if ((iph->tos & IPTOS_TOS_MASK) != tosinfo->tos) {
-		__u8 oldtos;
-		if (!skb_make_writable(skb, sizeof(struct iphdr)))
-			return NF_DROP;
-		iph = ip_hdr(skb);
-		oldtos = iph->tos;
-		iph->tos = (iph->tos & IPTOS_PREC_MASK) | tosinfo->tos;
-		csum_replace2(&iph->check, htons(oldtos), htons(iph->tos));
-	}
-	return XT_CONTINUE;
-}
-
-static bool
-tos_tg_check(const char *tablename, const void *e_void,
-             const struct xt_target *target, void *targinfo,
-             unsigned int hook_mask)
-{
-	const u_int8_t tos = ((struct ipt_tos_target_info *)targinfo)->tos;
-
-	if (tos != IPTOS_LOWDELAY
-	    && tos != IPTOS_THROUGHPUT
-	    && tos != IPTOS_RELIABILITY
-	    && tos != IPTOS_MINCOST
-	    && tos != IPTOS_NORMALSVC) {
-		printk(KERN_WARNING "TOS: bad tos value %#x\n", tos);
-		return false;
-	}
-	return true;
-}
-
-static struct xt_target tos_tg_reg __read_mostly = {
-	.name		= "TOS",
-	.family		= AF_INET,
-	.target		= tos_tg,
-	.targetsize	= sizeof(struct ipt_tos_target_info),
-	.table		= "mangle",
-	.checkentry	= tos_tg_check,
-	.me		= THIS_MODULE,
-};
-
-static int __init tos_tg_init(void)
-{
-	return xt_register_target(&tos_tg_reg);
-}
-
-static void __exit tos_tg_exit(void)
-{
-	xt_unregister_target(&tos_tg_reg);
-}
-
-module_init(tos_tg_init);
-module_exit(tos_tg_exit);
