From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/2] gmputil: turn mpz_printf into mpz_vfprintf to restore --with-mini-gmp
Date: Wed, 22 Nov 2017 20:36:16 +0100
Message-ID: <20171122193616.31755-2-pablo@netfilter.org>
References: <20171122193616.31755-1-pablo@netfilter.org>
Cc: phil@nwl.cc
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58320 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751273AbdKVTgc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2017 14:36:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8E27620A531
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 20:36:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4DF63DA861
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 20:36:31 +0100 (CET)
In-Reply-To: <20171122193616.31755-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2535ba7006f2 ("src: get rid of printf") uses gmp_vfprintf() which
doesn't exists in mini-gmp.c, this breaks compilation with --mini-gmp.

This patch implements poor man's gmp_vfprintf that takes one single
argument which is what we need.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Phil: We're still hitting a compilation warning, since libnftables is
       in place, it seems -Wno-sign-compare is ignored.

 include/gmputil.h | 7 ++++---
 src/gmputil.c     | 8 +++++---
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/include/gmputil.h b/include/gmputil.h
index 9c372216cc52..084aa6226687 100644
--- a/include/gmputil.h
+++ b/include/gmputil.h
@@ -7,9 +7,10 @@
 #include <gmp.h>
 #else
 #include <mini-gmp.h>
-/* mini-gmp doesn't come with gmp_printf, so we use our own minimal variant */
-extern int mpz_printf(const char *format, const mpz_t value);
-#define gmp_printf mpz_printf
+#include <stdio.h>
+/* mini-gmp doesn't come with gmp_vfprintf, so we use our own minimal variant */
+extern int mpz_vfprintf(FILE *fp, const char *format, va_list args);
+#define gmp_vfprintf mpz_vfprintf
 #endif
 
 #include <asm/byteorder.h>
diff --git a/src/gmputil.c b/src/gmputil.c
index 3cc4e61f5463..098e2ffb8b3e 100644
--- a/src/gmputil.c
+++ b/src/gmputil.c
@@ -145,9 +145,11 @@ void mpz_switch_byteorder(mpz_t rop, unsigned int len)
 /* mini-gmp doesn't have a gmp_printf so we use our own minimal
  * variant here which is able to format a single mpz_t.
  */
-int mpz_printf(const char *f, const mpz_t value)
+int mpz_vfprintf(FILE *fp, const char *f, va_list args)
 {
+	const mpz_t *value = va_arg(args, const mpz_t *);
 	int n = 0;
+
 	while (*f) {
 		if (*f != '%') {
 			if (fputc(*f, stdout) != *f)
@@ -174,7 +176,7 @@ int mpz_printf(const char *f, const mpz_t value)
 			else
 				return -1;
 
-			len = mpz_sizeinbase(value, base);
+			len = mpz_sizeinbase(*value, base);
 			while (prec-- > len) {
 				if (fputc('0', stdout) != '0')
 					return -1;
@@ -182,7 +184,7 @@ int mpz_printf(const char *f, const mpz_t value)
 				++n;
 			}
 
-			str = mpz_get_str(NULL, base, value);
+			str = mpz_get_str(NULL, base, *value);
 			ok = str && fwrite(str, 1, len, stdout) == len;
 			free(str);
 
-- 
2.11.0

