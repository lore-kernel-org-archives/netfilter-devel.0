From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] build: libnftnl 1.0.9 release
Date: Thu, 28 Dec 2017 19:39:02 +0100
Message-ID: <20171228183902.2312-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33038 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750950AbdL1SjN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Dec 2017 13:39:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 12262249C1
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Dec 2017 19:39:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 026B8DA3A6
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Dec 2017 19:39:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9CBBDDA3A6
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Dec 2017 19:39:05 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 67DFB4265A31
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Dec 2017 19:39:05 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Make_global.am | 2 +-
 configure.ac   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index 718442ffe490..ca05da32d96a 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -18,7 +18,7 @@
 # set age to 0.
 # </snippet>
 #
-LIBVERSION=7:0:0
+LIBVERSION=8:0:1
 
 AM_CPPFLAGS = ${regular_CPPFLAGS} -I${top_srcdir}/include ${LIBMNL_CFLAGS} ${LIBMXML_CFLAGS}
 AM_CFLAGS = ${regular_CFLAGS} ${GCC_FVISIBILITY_HIDDEN}
diff --git a/configure.ac b/configure.ac
index f994ccd878a1..d098571073bc 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,6 +1,6 @@
 dnl Process this file with autoconf to create configure.
 
-AC_INIT([libnftnl], [1.0.8])
+AC_INIT([libnftnl], [1.0.9])
 AC_CONFIG_AUX_DIR([build-aux])
 AC_CANONICAL_HOST
 AC_CONFIG_MACRO_DIR([m4])
-- 
2.11.0

