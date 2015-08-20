From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [conntrack-tools PATCH] nfct: don't link against
 libnetfilter_conntrack
Date: Thu, 20 Aug 2015 13:38:42 +0200
Message-ID: <20150820113841.3543.68437.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:60133 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751584AbbHTMsE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2015 08:48:04 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The nfct program uses none of the symbols of libnetfilter_conntrack.

Linking against it means that distributors have to maintain an useless
depedency.

This was spotted by the dpkg-shlibdeps tool.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/Makefile.am |    1 -
 1 file changed, 1 deletion(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index 1bc3622..a1d00f8 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -25,7 +25,6 @@ nfct_SOURCES += nfct-extensions/timeout.c
 endif
 
 nfct_LDADD = ${LIBMNL_LIBS} 			\
-	     ${LIBNETFILTER_CONNTRACK_LIBS}	\
 	     ${libdl_LIBS}
 
 if HAVE_CTTIMEOUT

