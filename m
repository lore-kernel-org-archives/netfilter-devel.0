From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] build: fix final report after configuration
Date: Tue, 21 Jan 2014 11:18:52 +0100
Message-ID: <1390299532-18200-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58854 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754204AbaAUKTG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jan 2014 05:19:06 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If no xml/json support is explicitly enabled, the final report
does not show "no". This patch fixes this:

libnftnl configuration:
  XML support:                          no
  JSON support:                         no

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 configure.ac |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/configure.ac b/configure.ac
index 54c66fe..f95b268 100644
--- a/configure.ac
+++ b/configure.ac
@@ -20,12 +20,14 @@ AC_ARG_WITH([xml-parsing],
 AC_ARG_WITH([json-parsing],
 	AS_HELP_STRING([--with-json-parsing], [JSON parsing support]))
 
-AS_IF([test "x$with_xml_parsing" = "xyes"], [
-	PKG_CHECK_MODULES([LIBXML], [mxml >= 2.6])
-])
-AS_IF([test "x$with_json_parsing" = "xyes"], [
-	PKG_CHECK_MODULES([LIBJSON], [jansson >= 2.3])
-])
+AS_IF([test "x$with_xml_parsing" = "xyes"],
+	[PKG_CHECK_MODULES([LIBXML], [mxml >= 2.6])],
+	[with_xml_parsing="no"]
+)
+AS_IF([test "x$with_json_parsing" = "xyes"],
+	[PKG_CHECK_MODULES([LIBJSON], [jansson >= 2.3])],
+	[with_json_parsing="no"]
+)
 AC_PROG_CC
 AM_PROG_CC_C_O
 AC_EXEEXT
-- 
1.7.10.4

