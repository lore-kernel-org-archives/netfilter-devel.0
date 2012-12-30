From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] extensions: fix linking against -lip6tc
Date: Sun, 30 Dec 2012 18:11:47 -0500
Message-ID: <1356909107-9924-1-git-send-email-vapier@gentoo.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:57420 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086Ab2L3XK1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Dec 2012 18:10:27 -0500
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id A1EDD33D77F
	for <netfilter-devel@vger.kernel.org>; Sun, 30 Dec 2012 23:10:26 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The current build forgets to specify a path to find libip6tc which means
it either fails (if there is no libip6tc in the system), or links against
an old version (if there is one in the system).

References: https://bugs.gentoo.org/449262
Reported-by: Mike Gilbert <floppym@gentoo.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 extensions/GNUmakefile.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index e71e3ff..a605474 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -101,7 +101,7 @@ libxt_state.so: libxt_conntrack.so
 	ln -fs $< $@
 
 # Need the LIBADDs in iptables/Makefile.am too for libxtables_la_LIBADD
-ip6t_NETMAP_LIBADD  = -lip6tc
+ip6t_NETMAP_LIBADD  = -L../libiptc/.libs -lip6tc
 xt_RATEEST_LIBADD   = -lm
 xt_statistic_LIBADD = -lm
 
-- 
1.8.0

