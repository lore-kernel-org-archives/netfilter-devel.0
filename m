From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 1/3] Add revision field for xt_entry_target
Date: Fri, 6 Feb 2015 15:26:28 +0800
Message-ID: <1423207590-13423-1-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <pablo@netfilter.org>, Gao feng <gaofeng@cn.fujitsu.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21570 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750788AbbBFH0s (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Feb 2015 02:26:48 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This filed is useful if we want to add TARGET which
has revision for arptables rules.

Also make sure xt_entry_target is consistent with
the definition in kernel.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 include/linux/netfilter_arp/arp_tables.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 0acda66..ccf8cd0 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -19,7 +19,7 @@
 
 #include <linux/netfilter_arp.h>
 
-#define ARPT_FUNCTION_MAXNAMELEN 30
+#define ARPT_FUNCTION_MAXNAMELEN 29
 #define ARPT_TABLE_MAXNAMELEN 32
 
 #define ARPT_DEV_ADDR_LEN_MAX 16
@@ -69,6 +69,8 @@ struct arpt_entry_target
 
 			/* Used by userspace */
 			char name[ARPT_FUNCTION_MAXNAMELEN];
+
+			u_int8_t revision;
 		} user;
 		struct {
 			u_int16_t target_size;
-- 
2.1.0

