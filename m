From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] build: update LIBVERSION to prepare a new release
Date: Mon, 19 Dec 2016 19:16:12 +0100
Message-ID: <1482171372-11716-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35538 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755298AbcLSSQZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Dec 2016 13:16:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9F66C12095
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Dec 2016 19:16:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B0D8FDA3AB
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Dec 2016 19:16:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5E2A7DA804
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Dec 2016 19:16:16 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

New interfaces has been added (bump revision), and no interfaces were
removed (bump age). Update version: 1.0.7.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Make_global.am | 2 +-
 configure.ac   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index 94c5dfc23994..b66ff08aec71 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -18,7 +18,7 @@
 # set age to 0.
 # </snippet>
 #
-LIBVERSION=5:0:1
+LIBVERSION=6:0:2
 
 AM_CPPFLAGS = ${regular_CPPFLAGS} -I${top_srcdir}/include ${LIBMNL_CFLAGS} ${LIBMXML_CFLAGS}
 AM_CFLAGS = ${regular_CFLAGS} ${GCC_FVISIBILITY_HIDDEN}
diff --git a/configure.ac b/configure.ac
index 813523d53e59..4777c5e26b3f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,6 +1,6 @@
 dnl Process this file with autoconf to create configure.
 
-AC_INIT([libnftnl], [1.0.6])
+AC_INIT([libnftnl], [1.0.7])
 AC_CONFIG_AUX_DIR([build-aux])
 AC_CANONICAL_HOST
 AC_CONFIG_MACRO_DIR([m4])
-- 
2.1.4

