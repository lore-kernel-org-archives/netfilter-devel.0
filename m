From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 2/2] build: resolve compile error due to missing nfacct CPPFLAGS
Date: Tue, 27 Nov 2012 00:54:59 +0100
Message-ID: <1353974099-19891-3-git-send-email-jengelh@inai.de>
References: <1353974099-19891-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: eric@regit.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:48986 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932076Ab2KZXzK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2012 18:55:10 -0500
In-Reply-To: <1353974099-19891-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fixes this error:

make[3]: Entering directory "/home/jengelh/code/ulogd2/output"
  CC       ulogd_output_XML.lo
ulogd_output_XML.c:31:49: fatal error:
libnetfilter_acct/libnetfilter_acct.h: No such file or directory

(Note that pkgconfig-provided cflags are actually cppflags, so
I add ${LIBNETFILTER_ACCT_CFLAGS} to AM_CPPFLAGS.)

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 output/Makefile.am |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/output/Makefile.am b/output/Makefile.am
index 630aee6..61d827a 100644
--- a/output/Makefile.am
+++ b/output/Makefile.am
@@ -1,4 +1,4 @@
-AM_CPPFLAGS = -I$(top_srcdir)/include
+AM_CPPFLAGS = -I$(top_srcdir)/include ${LIBNETFILTER_ACCT_CFLAGS}
 AM_CFLAGS = ${regular_CFLAGS} ${LIBNETFILTER_LOG_CFLAGS} \
 	    ${LIBNETFILTER_CONNTRACK_CFLAGS}
 
-- 
1.7.10.4

