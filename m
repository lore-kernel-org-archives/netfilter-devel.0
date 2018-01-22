From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH] build: do install libipset/args.h
Date: Mon, 22 Jan 2018 22:50:33 +0100
Message-ID: <20180122215033.28643-1-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a3.inai.de ([88.198.180.161]:45610 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750892AbeAVVuf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jan 2018 16:50:35 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

libipset/types.h includes args.h, therefore args.h must be installed
too.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/libipset/Makefile.am | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/libipset/Makefile.am b/include/libipset/Makefile.am
index 3b47518..79a1357 100644
--- a/include/libipset/Makefile.am
+++ b/include/libipset/Makefile.am
@@ -1,5 +1,6 @@
 pkgincludedir = ${includedir}/libipset
 pkginclude_HEADERS = \
+	args.h \
 	data.h \
 	errcode.h \
 	linux_ip_set_bitmap.h \
-- 
2.13.6

