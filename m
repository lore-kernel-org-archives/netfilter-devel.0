From: Gustavo Zacarias <gustavo@zacarias.com.ar>
Subject: [PATCH] iptables: link libxtables against libnetfilter_conntrack
Date: Tue, 13 Aug 2013 10:15:23 -0300
Message-ID: <1376399723-9967-1-git-send-email-gustavo@zacarias.com.ar>
Cc: Gustavo Zacarias <gustavo@zacarias.com.ar>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from loknar.toptech.com.ar ([78.46.79.162]:56684 "EHLO
	loknar.toptech.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955Ab3HMN2f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:28:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When libnetfilter_conntrack is available libxtables needs to link
against it otherwise we get build failures.

Signed-off-by: Gustavo Zacarias <gustavo@zacarias.com.ar>
---
 libxtables/Makefile.am | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libxtables/Makefile.am b/libxtables/Makefile.am
index c5795fe..2460815 100644
--- a/libxtables/Makefile.am
+++ b/libxtables/Makefile.am
@@ -18,3 +18,6 @@ libxtables_la_LIBADD += -ldl
 else
 libxtables_la_CFLAGS  = ${AM_CFLAGS} -DNO_SHARED_LIBS=1
 endif
+if HAVE_LIBNETFILTER_CONNTRACK
+libxtables_la_LIBADD += @libnetfilter_conntrack_LIBS@
+endif
-- 
1.8.1.5

