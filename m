From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/2] utils: fix one compilation error with --with-mini-gmp
Date: Wed, 22 Nov 2017 20:36:15 +0100
Message-ID: <20171122193616.31755-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: phil@nwl.cc
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58284 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751260AbdKVTgc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2017 14:36:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B5DDC20A539
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 20:36:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 96F8BDA38C
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 20:36:30 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Restore some code that is needed, until we have a version of gmp_printf
that takes variable arguments.

In file included from ../include/utils.h:12:0,
                 from ../include/nftables.h:6,
                 from ../include/rule.h:5,
                 from segtree.c:15:
segtree.c: In function ‘ei_insert’:
../include/gmputil.h:12:20: error: too many arguments to function ‘mpz_printf’
 #define gmp_printf mpz_printf

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/utils.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/utils.h b/include/utils.h
index 369195240e24..310389c22fab 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -15,7 +15,11 @@
 
 #define pr_debug(fmt, arg...) printf(fmt, ##arg)
 
+#if defined(HAVE_LIBGMP)
 #define pr_gmp_debug(fmt, arg...) gmp_printf(fmt, ##arg)
+#else
+#define pr_gmp_debug(fmt, arg...) ({ if (false) {}; 0; })
+#endif
 
 #define __fmtstring(x, y)	__attribute__((format(printf, x, y)))
 #if 0
-- 
2.11.0

