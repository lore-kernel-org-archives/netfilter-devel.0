From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 04/24] [NETFILTER]: remove unused ARPT_ALIGN indirection macros
Date: Wed,  2 Apr 2008 13:11:46 +0200
Message-ID: <d601451ead14e9a09f25f7dc691609a1aed8ae84.1207134547.git.jengelh@computergmbh.de>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43149 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016AbYDBLMI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:12:08 -0400
In-Reply-To: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <455b3b0ee249d17dff621933f163b8d5e377eb8f.1207134547.git.jengelh@computergmbh.de>
References: <455b3b0ee249d17dff621933f163b8d5e377eb8f.1207134547.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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
-- 
1.5.4.4

