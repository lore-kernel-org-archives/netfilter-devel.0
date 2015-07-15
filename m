From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 1/2] build: resolve build error involving libnftnl
Date: Wed, 15 Jul 2015 14:53:38 +0200
Message-ID: <1436964819-28109-2-git-send-email-jengelh@inai.de>
References: <1436964819-28109-1-git-send-email-jengelh@inai.de>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:33669 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbbGOMxm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jul 2015 08:53:42 -0400
In-Reply-To: <1436964819-28109-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

make[2]: Entering directory '/home/jengelh/code/iptables/extensions'
  CC       libebt_limit.oo
In file included from ../iptables/nft.h:5:0,
                 from libebt_limit.c:21:
../iptables/nft-shared.h:6:27: fatal error: libnftnl/rule.h: No such file or directory
 #include <libnftnl/rule.h>
                           ^
compilation terminated.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/GNUmakefile.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 4e94bd0..181e155 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -21,7 +21,7 @@ regular_CPPFLAGS   = @regular_CPPFLAGS@
 kinclude_CPPFLAGS  = @kinclude_CPPFLAGS@
 
 AM_CFLAGS       = ${regular_CFLAGS}
-AM_CPPFLAGS     = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_builddir} -I${top_srcdir}/include ${kinclude_CPPFLAGS} ${CPPFLAGS} @libnetfilter_conntrack_CFLAGS@
+AM_CPPFLAGS     = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_builddir} -I${top_srcdir}/include ${kinclude_CPPFLAGS} ${CPPFLAGS} @libnetfilter_conntrack_CFLAGS@ @libnftnl_CFLAGS@
 AM_DEPFLAGS     = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
 AM_LDFLAGS      = @noundef_LDFLAGS@
 
-- 
2.4.3

