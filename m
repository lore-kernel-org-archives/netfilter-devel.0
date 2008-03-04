From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 10/19] [NETFILTER]: remove unused ARPT_ALIGN indirection
 macros
Date: Tue, 4 Mar 2008 17:33:41 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803041733210.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47318 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765631AbYCDQdm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:33:42 -0500
In-Reply-To: <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit ac5544297553bc0caa32489e0028ed6cce60a29f
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Sat Feb 9 00:45:44 2008 +0100

    [NETFILTER]: remove unused ARPT_ALIGN indirection macros
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 include/linux/netfilter_arp/arp_tables.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 0e6b5e1..1cb698b 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -274,8 +274,6 @@ extern unsigned int arpt_do_table(struct sk_buff *skb,
 				  const struct net_device *out,
 				  struct xt_table *table);
 
-#define ARPT_ALIGN(s) XT_ALIGN(s)
-
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
 
@@ -295,8 +293,6 @@ compat_arpt_get_target(struct compat_arpt_entry *e)
 	return (void *)e + e->target_offset;
 }
 
-#define COMPAT_ARPT_ALIGN(s)	COMPAT_XT_ALIGN(s)
-
 /* fn returns 0 to continue iteration */
 #define COMPAT_ARPT_ENTRY_ITERATE(entries, size, fn, args...) \
 	XT_ENTRY_ITERATE(struct compat_arpt_entry, entries, size, fn, ## args)
