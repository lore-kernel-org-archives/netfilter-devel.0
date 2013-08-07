From: Lutz Jaenicke <ljaenicke@innominate.com>
Subject: [PATCH] iptables: correctly reference generated file
Date: Wed,  7 Aug 2013 10:09:16 +0200
Message-ID: <1375862956-22870-1-git-send-email-ljaenicke@innominate.com>
Cc: Lutz Jaenicke <ljaenicke@innominate.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.innominate.com ([77.245.32.75]:52049 "EHLO
	home.innominate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282Ab3HGIJg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Aug 2013 04:09:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since
  iptables: use autoconf to process .in man pages
the file "iptables-extensions.8.tmpl" is generated from
"iptables-extensions.8.tmpl.in" and is consequently no
longer found in ${srcdir} but in the build directory.
(Becomes visible with builddir != srcdir)

Signed-off-by: Lutz Jaenicke <ljaenicke@innominate.com>
---
 iptables/Makefile.am |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index 46d2463..501e825 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -38,7 +38,7 @@ if ENABLE_IPV6
 v6_sbin_links  = ip6tables ip6tables-restore ip6tables-save
 endif
 
-iptables-extensions.8: ${srcdir}/iptables-extensions.8.tmpl ../extensions/matches.man ../extensions/targets.man
+iptables-extensions.8: iptables-extensions.8.tmpl ../extensions/matches.man ../extensions/targets.man
 	${AM_VERBOSE_GEN} sed \
 		-e '/@MATCH@/ r ../extensions/matches.man' \
 		-e '/@TARGET@/ r ../extensions/targets.man' $< >$@;
-- 
1.7.10.4

