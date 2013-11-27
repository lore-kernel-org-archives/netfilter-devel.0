From: Gustavo Zacarias <gustavo@zacarias.com.ar>
Subject: [PATCH iptables] iptables/Makefile.am: fix more static linking issues
Date: Wed, 27 Nov 2013 09:31:33 -0300
Message-ID: <1385555493-25856-1-git-send-email-gustavo@zacarias.com.ar>
Cc: Gustavo Zacarias <gustavo@zacarias.com.ar>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from loknar.toptech.com.ar ([78.46.79.162]:43207 "EHLO
	loknar.toptech.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab3K0Mbq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Nov 2013 07:31:46 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On uClibc-based targets dlfcn.h isn't available when built for
static-only targets.
Add up -DNO_SHARED_LIBS when building static so as to guard off the
include.

Signed-off-by: Gustavo Zacarias <gustavo@zacarias.com.ar>
---
 iptables/Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index a4246eb..1122d72 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -7,7 +7,7 @@ xtables_multi_SOURCES  = xtables-multi.c iptables-xml.c
 xtables_multi_CFLAGS   = ${AM_CFLAGS}
 xtables_multi_LDADD    = ../extensions/libext.a
 if ENABLE_STATIC
-xtables_multi_CFLAGS  += -DALL_INCLUSIVE
+xtables_multi_CFLAGS  += -DALL_INCLUSIVE -DNO_SHARED_LIBS
 endif
 if ENABLE_IPV4
 xtables_multi_SOURCES += iptables-save.c iptables-restore.c \
-- 
1.8.3.2

