From: Karl Hiramoto <karl@hiramoto.org>
Subject: [PATCH] iptables: optionally disable largefile support.
Date: Mon, 10 May 2010 09:30:38 +0200
Message-ID: <1273476638-31417-1-git-send-email-karl@hiramoto.org>
Cc: kaber@trash.net, Karl Hiramoto <karl@hiramoto.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:34523 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab0EJHb5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 May 2010 03:31:57 -0400
Received: from homiemail-a33.g.dreamhost.com (caiajhbdcahe.dreamhost.com [208.97.132.74])
	by hapkido.dreamhost.com (Postfix) with ESMTP id B8A76186D0C
	for <netfilter-devel@vger.kernel.org>; Mon, 10 May 2010 00:31:57 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Many toolchains for embedded systems don't have largefile support.

Signed-off-by: Karl Hiramoto <karl@hiramoto.org>
---
 configure.ac |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/configure.ac b/configure.ac
index f26facb..e8fe031 100644
--- a/configure.ac
+++ b/configure.ac
@@ -37,6 +37,11 @@ AC_ARG_ENABLE([ipv4],
 AC_ARG_ENABLE([ipv6],
 	AS_HELP_STRING([--disable-ipv6], [Do not build ip6tables]),
 	[enable_ipv6="$enableval"], [enable_ipv6="yes"])
+AC_ARG_ENABLE([largefile],
+	AS_HELP_STRING([--disable-largefile], [Do not build largefile support]),
+	[enable_largefile="$enableval"],
+	[enable_largefile="yes";
+	largefile_cflags='-D_LARGEFILE_SOURCE=1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=64'])
 AC_ARG_ENABLE([devel],
 	AS_HELP_STRING([--enable-devel],
 	[Install Xtables development headers]),
@@ -59,6 +64,7 @@ AM_CONDITIONAL([ENABLE_STATIC], [test "$enable_static" = "yes"])
 AM_CONDITIONAL([ENABLE_SHARED], [test "$enable_shared" = "yes"])
 AM_CONDITIONAL([ENABLE_IPV4], [test "$enable_ipv4" = "yes"])
 AM_CONDITIONAL([ENABLE_IPV6], [test "$enable_ipv6" = "yes"])
+AM_CONDITIONAL([ENABLE_LARGEFILE], [test "$enable_largefile" = "yes"])
 AM_CONDITIONAL([ENABLE_DEVEL], [test "$enable_devel" = "yes"])
 AM_CONDITIONAL([ENABLE_LIBIPQ], [test "$enable_libipq" = "yes"])
 
@@ -66,7 +72,7 @@ PKG_CHECK_MODULES([libnfnetlink], [libnfnetlink >= 1.0],
 	[nfnetlink=1], [nfnetlink=0])
 AM_CONDITIONAL([HAVE_LIBNFNETLINK], [test "$nfnetlink" = 1])
 
-regular_CFLAGS="-D_LARGEFILE_SOURCE=1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=64 \
+regular_CFLAGS="${largefile_cflags} \
 	-D_REENTRANT -Wall -Waggregate-return -Wmissing-declarations \
 	-Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-prototypes \
 	-Winline -pipe \
-- 
1.6.6.2

