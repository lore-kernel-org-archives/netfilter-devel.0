From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/2] gmputil: use MSF/LSF in import/export functions dependant on host byte order
Date: Sat, 12 Apr 2014 11:09:59 +0200
Message-ID: <1397293799-2600-3-git-send-email-kaber@trash.net>
References: <1397293799-2600-1-git-send-email-kaber@trash.net>
Cc: arturo.borrero.glez@gmail.com, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41751 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085AbaDLJKE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Apr 2014 05:10:04 -0400
In-Reply-To: <1397293799-2600-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

For data of byteorder BYTEORDER_HOST_ENDIAN we need to set the word order
dependant on the host byte order.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/gmputil.h | 9 +++++++++
 src/gmputil.c     | 7 +++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/gmputil.h b/include/gmputil.h
index 88be697..63eb0ba 100644
--- a/include/gmputil.h
+++ b/include/gmputil.h
@@ -2,12 +2,21 @@
 #define NFTABLES_GMPUTIL_H
 
 #include <gmp.h>
+#include <asm/byteorder.h>
 
 enum mpz_word_order {
 	MPZ_MSWF		= 1,
 	MPZ_LSWF		= -1,
 };
 
+#ifdef __LITTLE_ENDIAN_BITFIELD
+#define MPZ_HWO	MPZ_LSWF
+#elif defined(__BIG_ENDIAN_BITFIELD)
+#define MPZ_HWO MPZ_MSWF
+#else
+#error "byteorder undefined"
+#endif
+
 enum mpz_byte_order {
 	MPZ_BIG_ENDIAN		= 1,
 	MPZ_HOST_ENDIAN		= 0,
diff --git a/src/gmputil.c b/src/gmputil.c
index f34c077..cb46445 100644
--- a/src/gmputil.c
+++ b/src/gmputil.c
@@ -98,20 +98,23 @@ void *mpz_export_data(void *data, const mpz_t op,
 		      enum byteorder byteorder,
 		      unsigned int len)
 {
+	enum mpz_word_order order;
 	enum mpz_byte_order endian;
 
 	switch (byteorder) {
 	case BYTEORDER_BIG_ENDIAN:
 	default:
+		order = MPZ_MSWF;
 		endian = MPZ_BIG_ENDIAN;
 		break;
 	case BYTEORDER_HOST_ENDIAN:
+		order = MPZ_HWO;
 		endian = MPZ_HOST_ENDIAN;
 		break;
 	}
 
 	memset(data, 0, len);
-	mpz_export(data, NULL, MPZ_MSWF, len, endian, 0, op);
+	mpz_export(data, NULL, order, len, endian, 0, op);
 	return data;
 }
 
@@ -129,7 +132,7 @@ void mpz_import_data(mpz_t rop, const void *data,
 		endian = MPZ_BIG_ENDIAN;
 		break;
 	case BYTEORDER_HOST_ENDIAN:
-		order  = MPZ_LSWF;
+		order  = MPZ_HWO;
 		endian = MPZ_HOST_ENDIAN;
 		break;
 	}
-- 
1.9.0

