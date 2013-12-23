From: Douglas Freed <dwfreed@mtu.edu>
Subject: [libnftables PATCH] build: properly handle --without-{xml,json}-parsing
Date: Mon, 23 Dec 2013 09:14:57 +0000
Message-ID: <1387790097-9314-1-git-send-email-dwfreed@mtu.edu>
Cc: Douglas Freed <dwfreed@mtu.edu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:55144 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169Ab3LWJOM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Dec 2013 04:14:12 -0500
Received: by mail-pa0-f48.google.com with SMTP id rd3so5084058pab.7
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Dec 2013 01:14:12 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes how --without-{xml,json}-parsing (and subsequently
--with-{xml,json}-parsing=no) is handled.  Prior to this,
--without-{xml,json}-parsing actually resulted in libnftables being
built with that parsing enabled.

Signed-off-by: Douglas Freed <dwfreed@mtu.edu>
---
 configure.ac | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/configure.ac b/configure.ac
index b023755..6219737 100644
--- a/configure.ac
+++ b/configure.ac
@@ -16,11 +16,9 @@ m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
 dnl Dependencies
 PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.0])
 AC_ARG_WITH([xml-parsing],
-	AS_HELP_STRING([--with-xml-parsing], [XML parsing support]),
-	[with_xml_parsing="yes"], [with_xml_parsing="no"])
+	AS_HELP_STRING([--with-xml-parsing], [XML parsing support]))
 AC_ARG_WITH([json-parsing],
-	AS_HELP_STRING([--with-json-parsing], [JSON parsing support]),
-	[with_json_parsing="yes"], [with_json_parsing="no"])
+	AS_HELP_STRING([--with-json-parsing], [JSON parsing support]))
 
 AS_IF([test "x$with_xml_parsing" = "xyes"], [
 	PKG_CHECK_MODULES([LIBXML], [mxml >= 2.6])
-- 
1.8.5.2

