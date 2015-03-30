From: Zhang Chunyu <zhangcy@cn.fujitsu.com>
Subject: [PATCH V4 1/3] Add revision field for xt_entry_target
Date: Sun, 29 Mar 2015 22:35:46 -0400
Message-ID: <1427682948-18699-2-git-send-email-zhangcy@cn.fujitsu.com>
References: <1427682948-18699-1-git-send-email-zhangcy@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Zhang Chunyu <zhangcy@cn.fujitsu.com>,
	Gao feng <gaofeng@cn.fujitsu.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49915 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752745AbbC3Cto (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 Mar 2015 22:49:44 -0400
In-Reply-To: <1427682948-18699-1-git-send-email-zhangcy@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This filed is useful if we want to add TARGET which
has revision for arptables rules.

Also make sure xt_entry_target is consistent with
the definition in kernel.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Signed-off-by: Zhang Chunyu <zhangcy@cn.fujitsu.com>
---
 include/linux/netfilter_arp/arp_tables.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 0acda66..0bf2457 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -19,7 +19,7 @@
 
 #include <linux/netfilter_arp.h>
 
-#define ARPT_FUNCTION_MAXNAMELEN 30
+#define ARPT_FUNCTION_MAXNAMELEN 29
 #define ARPT_TABLE_MAXNAMELEN 32
 
 #define ARPT_DEV_ADDR_LEN_MAX 16
@@ -69,6 +69,7 @@ struct arpt_entry_target
 
 			/* Used by userspace */
 			char name[ARPT_FUNCTION_MAXNAMELEN];
+			u_int8_t revision;
 		} user;
 		struct {
 			u_int16_t target_size;
-- 
1.7.12.4

