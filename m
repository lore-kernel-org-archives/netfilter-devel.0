From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 2/3] nfacct: resolve build failure
Date: Tue,  5 Jun 2012 10:41:02 +0200
Message-ID: <1338885663-30131-3-git-send-email-jengelh@inai.de>
References: <1338885663-30131-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:54615 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757643Ab2FEIlI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jun 2012 04:41:08 -0400
In-Reply-To: <1338885663-30131-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  CC       ulogd_inpflow_NFACCT_la-ulogd_inpflow_NFACCT.lo
ulogd_inpflow_NFACCT.c:24:27: fatal error: libmnl/libmnl.h:
No such file or directory
compilation terminated.

LIBS is not interchangeable with C(PP)FLAGS.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 input/sum/Makefile.am |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/input/sum/Makefile.am b/input/sum/Makefile.am
index f129193..33fa849 100644
--- a/input/sum/Makefile.am
+++ b/input/sum/Makefile.am
@@ -1,8 +1,8 @@
-AM_CPPFLAGS = -I$(top_srcdir)/include
+AM_CPPFLAGS = -I$(top_srcdir)/include $(LIBNETFILTER_ACCT_CFLAGS) $(LIBMNL_CFLAGS)
 AM_CFLAGS = ${regular_CFLAGS}
 
 pkglib_LTLIBRARIES = ulogd_inpflow_NFACCT.la
 
 ulogd_inpflow_NFACCT_la_SOURCES = ulogd_inpflow_NFACCT.c
-ulogd_inpflow_NFACCT_la_LDFLAGS = -avoid-version -module $(LIBMNL_LIBS) $(LIBNETFILTER_ACCT_LIBS)
-ulogd_inpflow_NFACCT_la_CFLAGS = $(AM_CFLAGS) $(LIBMNL_LIBS) $(LIBNETFILTER_ACCT_CFLAGS)
+ulogd_inpflow_NFACCT_la_LDFLAGS = -avoid-version -module
+ulogd_inpflow_NFACCT_la_LIBADD  = $(LIBMNL_LIBS) $(LIBNETFILTER_ACCT_LIBS)
-- 
1.7.7

