From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [conntrackd PATCH 1/2] configure.ac: improve feature selection
Date: Thu, 29 Oct 2015 15:25:39 +0100
Message-ID: <144612873979.2345.143124768646944099.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: jengelh@inai.de, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:44455 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757182AbbJ2OZs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Oct 2015 10:25:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's improve feature selection with feedback from Jan Engelhardt
and Pablo Neira Ayuso.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 configure.ac |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index 70d3729..f326f96 100644
--- a/configure.ac
+++ b/configure.ac
@@ -57,10 +57,10 @@ fi
 
 AC_ARG_ENABLE([cthelper],
         AS_HELP_STRING([--disable-cthelper], [Do not build userspace helper support]),
-        [enable_cthelper="no"], [enable_cthelper="yes"])
+        [enable_cthelper="$enableval"], [enable_cthelper="yes"])
 AC_ARG_ENABLE([cttimeout],
         AS_HELP_STRING([--disable-cttimeout], [Do not build timeout support]),
-        [enable_cttimeout="no"], [enable_cttimeout="yes"])
+        [enable_cttimeout="$enableval"], [enable_cttimeout="yes"])
 
 PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 1.0.1])
 PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])

