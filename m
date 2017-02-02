From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft] configure: Require newer version of libxtables
Date: Thu, 2 Feb 2017 09:22:55 -0200
Message-ID: <20170202112255.GA18694@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:36816 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751131AbdBBLXD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Feb 2017 06:23:03 -0500
Received: by mail-qt0-f195.google.com with SMTP id h53so3190609qth.3
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Feb 2017 03:23:02 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently, the configure script requires xtables v1.6.0 when the option
--with-xtables is given. However, nftables-0.7 build fails with this
version, xtables v1.6.1 is the minimum required to have libxtables
support.

Fixes(Bug 1110 - Build failure if --with-xtables).

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index f1bca05..bef6c0b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -102,7 +102,7 @@ AC_ARG_WITH([xtables], [AS_HELP_STRING([--with-xtables],
             [Use libxtables for iptables interaction)])],
 	    [with_libxtables=yes], [with_libxtables=no])
 AS_IF([test "x$with_libxtables" != xno], [
-PKG_CHECK_MODULES([XTABLES], [xtables >= 1.6.0])
+PKG_CHECK_MODULES([XTABLES], [xtables >= 1.6.1])
 AC_DEFINE([HAVE_LIBXTABLES], [1], [0])
 ])
 AC_SUBST(with_libxtables)
-- 
2.7.4

