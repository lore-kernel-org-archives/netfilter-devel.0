From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 2/5] src: gmputil: Remove mpz_get_be64() function.
Date: Wed, 16 Aug 2017 19:48:14 +0530
Message-ID: <20170816141817.20179-3-rvarsha016@gmail.com>
References: <20170816141817.20179-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:37813 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdHPOTG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Aug 2017 10:19:06 -0400
Received: by mail-pf0-f194.google.com with SMTP id p13so1493659pfd.4
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Aug 2017 07:19:06 -0700 (PDT)
In-Reply-To: <20170816141817.20179-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

mpz_get_be64() is not used anywhere in source code. So remove it.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 include/gmputil.h | 1 -
 src/gmputil.c     | 5 -----
 2 files changed, 6 deletions(-)

diff --git a/include/gmputil.h b/include/gmputil.h
index 1bf696a..9c37221 100644
--- a/include/gmputil.h
+++ b/include/gmputil.h
@@ -45,7 +45,6 @@ extern uint32_t mpz_get_uint32(const mpz_t op);
 extern uint16_t mpz_get_uint16(const mpz_t op);
 extern uint8_t mpz_get_uint8(const mpz_t op);
 
-extern uint64_t mpz_get_be64(const mpz_t op);
 extern uint32_t mpz_get_be32(const mpz_t op);
 extern uint16_t mpz_get_be16(const mpz_t op);
 
diff --git a/src/gmputil.c b/src/gmputil.c
index 844ea61..3cc4e61 100644
--- a/src/gmputil.c
+++ b/src/gmputil.c
@@ -77,11 +77,6 @@ uint8_t mpz_get_uint8(const mpz_t op)
 	return mpz_get_type(uint8_t, MPZ_HOST_ENDIAN, op);
 }
 
-uint64_t mpz_get_be64(const mpz_t op)
-{
-	return mpz_get_type(uint64_t, MPZ_BIG_ENDIAN, op);
-}
-
 uint32_t mpz_get_be32(const mpz_t op)
 {
 	return mpz_get_type(uint32_t, MPZ_BIG_ENDIAN, op);
-- 
2.13.5

