From: Sven Wegener <sven.wegener@stealer.net>
Subject: [PATCH 4/6] ipset/iptreemap: Update description of set type
Date: Sun, 29 Jun 2008 19:45:01 +0200
Message-ID: <1214761503-1713-5-git-send-email-sven.wegener@stealer.net>
References: <1214761503-1713-1-git-send-email-sven.wegener@stealer.net>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.stealer.net ([88.198.224.204]:44957 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbYF2RpT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 Jun 2008 13:45:19 -0400
In-Reply-To: <1214761503-1713-1-git-send-email-sven.wegener@stealer.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Update description of set type.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
---
 .../net/ipv4/netfilter/ip_set_iptreemap.c          |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/patchlets/set/linux-2.6/net/ipv4/netfilter/ip_set_iptreemap.c b/patchlets/set/linux-2.6/net/ipv4/netfilter/ip_set_iptreemap.c
index 6045741..62e8334 100644
--- a/patchlets/set/linux-2.6/net/ipv4/netfilter/ip_set_iptreemap.c
+++ b/patchlets/set/linux-2.6/net/ipv4/netfilter/ip_set_iptreemap.c
@@ -6,9 +6,9 @@
  */
 
 /* This modules implements the iptreemap ipset type. It uses bitmaps to
- * represent every single IPv4 address as a single bit. The bitmaps are managed
- * in a tree structure, where the first three octets of an addresses are used
- * as an index to find the bitmap and the last octet is used as the bit number.
+ * represent every single IPv4 address as a bit. The bitmaps are managed in a
+ * tree structure, where the first three octets of an address are used as an
+ * index to find the bitmap and the last octet is used as the bit number.
  */
 
 #include <linux/version.h>
-- 
1.5.6.1

