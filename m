From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [PATCH] nft-bridge: translating ebt to ip flags and viceversa
Date: Fri,  8 Nov 2013 09:13:49 +0000
Message-ID: <1383902029-2983-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:49204 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab3KHINU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Nov 2013 03:13:20 -0500
Received: by mail-ea0-f182.google.com with SMTP id o10so896944eaj.27
        for <netfilter-devel@vger.kernel.org>; Fri, 08 Nov 2013 00:13:19 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Tomasz,
this patch permit to translate ebt flags to ip flags, and vice versa.
Could you review it please?
I think I forgetting something, probably you can't compile it since
previous patches are missing.

Thanks

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 include/linux/netfilter_bridge/ebtables.h |  1 -
 iptables/nft-bridge.c                     | 45 ++++++++++++++++++++++++++++++-
 2 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index 8f520c6..c841f58 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -13,7 +13,6 @@
 /* Local copy of the kernel file, needed for Sparc64 support */
 #ifndef __LINUX_BRIDGE_EFF_H
 #define __LINUX_BRIDGE_EFF_H
-#include <linux/if.h>
 #include <linux/netfilter_bridge.h>
 #include <linux/if_ether.h>
 
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 5c28b43..4a1a1e8 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -11,9 +11,52 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <net/if.h>
+#include <stdint.h>
 
+#include <linux/netfilter_bridge/ebtables.h>
+
+#include "nft-shared.h"
 #include "nft.h"
 
+static uint8_t ebt_to_ipt_flags(uint16_t invflags)
+{
+	uint8_t result = 0;
+
+	if (invflags & EBT_IIN)
+		result |= IPT_INV_VIA_IN;
+
+	if (invflags & EBT_IOUT)
+		result |= IPT_INV_VIA_OUT;
+
+	if (invflags & EBT_IPROTO)
+		result |= IPT_INV_PROTO;
+
+	if (invflags & EBT_INV_MASK)
+		result |= IPT_INV_MASK;
+
+	return result;
+}
+
+static uint16_t ipt_to_ebt_flags(uint8_t invflags)
+{
+	uint16_t result = 0;
+
+	if (invflags & IPT_INV_VIA_IN)
+		result |= EBT_IIN;
+
+	if (invflags & IPT_INV_VIA_OUT)
+		result |= EBT_IOUT;
+
+	if (invflags & IPT_INV_PROTO)
+		result |= EBT_IPROTO;
+
+	if (invflags & IPT_INV_MASK)
+		result |= EBT_INV_MASK;
+
+	return result;
+}
+
 /* Be backwards compatible, so don't use '+' in kernel */
 #define IF_WILDCARD 1
 static void print_iface(const char *iface)
@@ -194,4 +237,4 @@ struct nft_family_ops nft_family_ops_bridge = {
 	.post_parse		= NULL,
 	.rule_find		= NULL,
 	.parse_target		= NULL,
-};
\ No newline at end of file
+};
-- 
1.8.1.5

