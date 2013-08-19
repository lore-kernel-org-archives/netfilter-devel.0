From: "Laurence J. Lane" <ljlane@debian.org>
Subject: [PATCH] iptables: extensions/GNUMakefile.in use CPPFLAGS
Date: Mon, 19 Aug 2013 12:02:19 -0400
Message-ID: <1376928139-10273-1-git-send-email-ljlane@debian.org>
Cc: "Laurence J. Lane" <ljlane@debian.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dunimos.ljlane.net ([216.218.223.72]:44763 "EHLO
	dunimos.ljlane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab3HSQCY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:02:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: "Laurence J. Lane" <ljlane@debian.org>

"All other Makefiles add CPPFLAGS to ${COMPILE} (automake), but GNUmakefile.in
 doesn't set it."

http://bugs.debian.org/665286

Signed-off-by: Laurence J. Lane <ljlane@debian.org>
---
 extensions/GNUmakefile.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 14e7c57..be89a17 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -21,7 +21,7 @@ regular_CPPFLAGS   = @regular_CPPFLAGS@
 kinclude_CPPFLAGS  = @kinclude_CPPFLAGS@
 
 AM_CFLAGS       = ${regular_CFLAGS}
-AM_CPPFLAGS     = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_builddir} -I${top_srcdir}/include ${kinclude_CPPFLAGS}
+AM_CPPFLAGS     = ${CPPFLAGS} ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_builddir} -I${top_srcdir}/include ${kinclude_CPPFLAGS}
 AM_DEPFLAGS     = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
 AM_LDFLAGS      = @noundef_LDFLAGS@
 
-- 
1.8.1.2

