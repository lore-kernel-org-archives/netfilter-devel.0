From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH libnftnl 2/5] data: increase maximum possible data size
Date: Tue, 14 Apr 2015 08:00:34 +0100
Message-ID: <1428994837-22120-3-git-send-email-kaber@trash.net>
References: <1428994837-22120-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44035 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbbDNHAm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Apr 2015 03:00:42 -0400
In-Reply-To: <1428994837-22120-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/data_reg.h                  | 3 ++-
 include/linux/netfilter/nf_tables.h | 3 +++
 src/expr/data_reg.c                 | 2 +-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/data_reg.h b/include/data_reg.h
index e7375b8..cf14988 100644
--- a/include/data_reg.h
+++ b/include/data_reg.h
@@ -1,6 +1,7 @@
 #ifndef _DATA_H_
 #define _DATA_H_
 
+#include <linux/netfilter/nf_tables.h>
 #include <stdint.h>
 #include <unistd.h>
 
@@ -13,7 +14,7 @@ enum {
 
 union nft_data_reg {
 	struct {
-		uint32_t	val[4];
+		uint32_t	val[NFT_DATA_VALUE_MAXLEN / sizeof(uint32_t)];
 		uint32_t	len;
 	};
 	struct {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 4221a6c..be8584c 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -388,6 +388,9 @@ enum nft_data_attributes {
 };
 #define NFTA_DATA_MAX		(__NFTA_DATA_MAX - 1)
 
+/* Maximum length of a value */
+#define NFT_DATA_VALUE_MAXLEN	64
+
 /**
  * enum nft_verdict_attributes - nf_tables verdict netlink attributes
  *
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index b4e553e..b5fbdf2 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -467,7 +467,7 @@ __nft_parse_data(union nft_data_reg *data, const struct nlattr *attr)
 	if (data_len == 0)
 		return -1;
 
-	if (data_len > sizeof(uint32_t) * 4)
+	if (data_len > sizeof(data->val))
 		return -1;
 
 	memcpy(data->val, orig, data_len);
-- 
2.1.0

