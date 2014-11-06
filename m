From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/5] build: use PKG_CHECK_MODULES to check for libmnl and libnftnl
Date: Thu,  6 Nov 2014 19:25:45 +0100
Message-ID: <1415298349-985-2-git-send-email-pablo@netfilter.org>
References: <1415298349-985-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38975 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbaKFSYJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:24:09 -0500
In-Reply-To: <1415298349-985-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Also check for required library versions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Makefile.defs.in |    2 +-
 configure.ac     |    7 ++-----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/Makefile.defs.in b/Makefile.defs.in
index 915d3d8..b9b115f 100644
--- a/Makefile.defs.in
+++ b/Makefile.defs.in
@@ -19,7 +19,7 @@ docdir		= @docdir@
 pdfdir		= @pdfdir@
 confdir		= @sysconfdir@/nftables
 
-LDFLAGS		+= @LDFLAGS@
+LDFLAGS		+= -lmnl -lnftnl
 LDFLAGS		+= @LIBS@
 
 CPPFLAGS	+= @CPPFLAGS@
diff --git a/configure.ac b/configure.ac
index 4aa14e3..e68d59f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -62,11 +62,8 @@ then
 fi
 
 # Checks for libraries.
-AC_CHECK_LIB([mnl], [mnl_socket_open], ,
-	     AC_MSG_ERROR([No suitable version of libmnl found]))
-
-AC_CHECK_LIB([nftnl], [nft_rule_alloc], ,
-	     AC_MSG_ERROR([No suitable version of libnftnl found]))
+PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
+PKG_CHECK_MODULES([LIBNFTNL], [libnftnl >= 1.0.2])
 
 AC_CHECK_LIB([gmp], [__gmpz_init], ,
 	     AC_MSG_ERROR([No suitable version of libgmp found]))
-- 
1.7.10.4

