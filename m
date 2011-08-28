From: Eric Leblond <eric@regit.org>
Subject: [PATCH 1/2] pcap: fix build on some recent x86_64 platform.
Date: Mon, 29 Aug 2011 00:43:31 +0200
Message-ID: <1314571412-9707-2-git-send-email-eric@regit.org>
References: <1314571412-9707-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:52189 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab1H1XSh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Aug 2011 19:18:37 -0400
In-Reply-To: <1314571412-9707-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 acinclude.m4 |    3 ++-
 configure.ac |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/acinclude.m4 b/acinclude.m4
index 9a8e1ae..56d47b8 100644
--- a/acinclude.m4
+++ b/acinclude.m4
@@ -218,6 +218,7 @@ AC_ARG_WITH(pcap-lib,
 
 AC_SUBST(PCAP_INC)
 AC_SUBST(PCAP_LIB)
+AC_SUBST(HAVE_PCAP_LIB)
 
 if test "$pcap_prefix" != "no"; then
 
@@ -261,7 +262,7 @@ if test "$PCAP_INC" = "" ; then
   AC_CHECK_HEADER([pcap.h], [], AC_MSG_WARN(pcap.h not found))
 fi
 if test "$PCAP_LIB" = "" ; then
-  AC_CHECK_LIB(pcap, pcap_close, [], AC_MSG_WARN(libpcap.so not found))
+  AC_CHECK_LIB(pcap, pcap_close, [HAVE_PCAP_LIB="yes"], AC_MSG_WARN(libpcap.so not found))
 fi
 
 fi
diff --git a/configure.ac b/configure.ac
index f835707..e8f8427 100644
--- a/configure.ac
+++ b/configure.ac
@@ -57,7 +57,7 @@ CT_CHECK_DBI()
 AM_CONDITIONAL(HAVE_DBI, test "x$DBI_LIB" != "x")
 
 CT_CHECK_PCAP()
-AM_CONDITIONAL(HAVE_PCAP, test "x$PCAP_LIB" != "x")
+AM_CONDITIONAL(HAVE_PCAP, test "x$HAVE_PCAP_LIB" != "x")
 
 
 dnl AC_SUBST(DATABASE_DIR)
-- 
1.7.5.4

