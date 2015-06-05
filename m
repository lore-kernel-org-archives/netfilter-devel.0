From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft 2/9] headers: sync headers for new register values
Date: Fri,  5 Jun 2015 15:42:44 +0200
Message-ID: <1433511771-4620-3-git-send-email-kaber@trash.net>
References: <1433511771-4620-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59936 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbbFENmz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2015 09:42:55 -0400
In-Reply-To: <1433511771-4620-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/linux/netfilter/nf_tables.h | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 0e96443..33056dc 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -4,16 +4,45 @@
 #define NFT_CHAIN_MAXNAMELEN	32
 #define NFT_USERDATA_MAXLEN	256
 
+/**
+ * enum nft_registers - nf_tables registers
+ *
+ * nf_tables used to have five registers: a verdict register and four data
+ * registers of size 16. The data registers have been changed to 16 registers
+ * of size 4. For compatibility reasons, the NFT_REG_[1-4] registers still
+ * map to areas of size 16, the 4 byte registers are addressed using
+ * NFT_REG32_00 - NFT_REG32_15.
+ */
 enum nft_registers {
 	NFT_REG_VERDICT,
 	NFT_REG_1,
 	NFT_REG_2,
 	NFT_REG_3,
 	NFT_REG_4,
-	__NFT_REG_MAX
+	__NFT_REG_MAX,
+
+	NFT_REG32_00	= 8,
+	MFT_REG32_01,
+	NFT_REG32_02,
+	NFT_REG32_03,
+	NFT_REG32_04,
+	NFT_REG32_05,
+	NFT_REG32_06,
+	NFT_REG32_07,
+	NFT_REG32_08,
+	NFT_REG32_09,
+	NFT_REG32_10,
+	NFT_REG32_11,
+	NFT_REG32_12,
+	NFT_REG32_13,
+	NFT_REG32_14,
+	NFT_REG32_15,
 };
 #define NFT_REG_MAX	(__NFT_REG_MAX - 1)
 
+#define NFT_REG_SIZE	16
+#define NFT_REG32_SIZE	4
+
 /**
  * enum nft_verdicts - nf_tables internal verdicts
  *
@@ -358,6 +387,9 @@ enum nft_data_attributes {
 };
 #define NFTA_DATA_MAX		(__NFTA_DATA_MAX - 1)
 
+/* Maximum length of a value */
+#define NFT_DATA_VALUE_MAXLEN	64
+
 /**
  * enum nft_verdict_attributes - nf_tables verdict netlink attributes
  *
-- 
2.1.0

