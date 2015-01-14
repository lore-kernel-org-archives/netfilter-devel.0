From: Gustavo Zacarias <gustavo@zacarias.com.ar>
Subject: [libnetfilter_conntrack PATCH] src/Makefile.am: drop hardcoded -ldl
Date: Wed, 14 Jan 2015 12:29:50 -0300
Message-ID: <1421249390-11620-1-git-send-email-gustavo@zacarias.com.ar>
Cc: Gustavo Zacarias <gustavo@zacarias.com.ar>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.zacarias.com.ar ([62.210.192.172]:47971 "EHLO
	www.zacarias.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbbANPaC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Jan 2015 10:30:02 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This breaks static builds where the toolchain completely lacks libdl.

Signed-off-by: Gustavo Zacarias <gustavo@zacarias.com.ar>
---
 src/Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index 7d6c905..374598a 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -11,6 +11,6 @@ lib_LTLIBRARIES = libnetfilter_conntrack.la
 libnetfilter_conntrack_la_LIBADD = conntrack/libnfconntrack.la \
 				   expect/libnfexpect.la \
 				   ${LIBNFNETLINK_LIBS} ${LIBMNL_LIBS}
-libnetfilter_conntrack_la_LDFLAGS = -Wc,-nostartfiles -lnfnetlink -ldl 	\
+libnetfilter_conntrack_la_LDFLAGS = -Wc,-nostartfiles -lnfnetlink \
 				    -version-info $(LIBVERSION)
 libnetfilter_conntrack_la_SOURCES = main.c callback.c
-- 
2.0.5

