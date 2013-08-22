From: "Laurence J. Lane" <ljlane@debian.org>
Subject: [PATCH v2] iptables: extensions/GNUMakefile.in use CPPFLAGS
Date: Thu, 22 Aug 2013 12:44:47 -0400
Message-ID: <1377189887-12537-1-git-send-email-ljlane@debian.org>
References: <alpine.LSU.2.10.9.1308200149450.1576@nerf07.vanv.qr>
Cc: "Laurence J. Lane" <ljlane@debian.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ankh.ljlane.net ([71.19.149.249]:40596 "EHLO ankh.ljlane.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368Ab3HVQzc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Aug 2013 12:55:32 -0400
In-Reply-To: <alpine.LSU.2.10.9.1308200149450.1576@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

"All other Makefiles add CPPFLAGS to ${COMPILE} (automake), but GNUmakefile.in
 doesn't set it."

http://bugs.debian.org/665286

Signed-off-by: Laurence J. Lane <ljlane@debian.org>
---
 extensions/GNUmakefile.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 14e7c57..c5d8844 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -21,7 +21,7 @@ regular_CPPFLAGS   = @regular_CPPFLAGS@
 kinclude_CPPFLAGS  = @kinclude_CPPFLAGS@
 
 AM_CFLAGS       = ${regular_CFLAGS}
-AM_CPPFLAGS     = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_builddir} -I${top_srcdir}/include ${kinclude_CPPFLAGS}
+AM_CPPFLAGS     = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_builddir} -I${top_srcdir}/include ${kinclude_CPPFLAGS} ${CPPFLAGS}
 AM_DEPFLAGS     = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
 AM_LDFLAGS      = @noundef_LDFLAGS@
 
-- 
1.8.4.rc3

