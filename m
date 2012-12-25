From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 13/13] build: resolve link failure for ip6t_NETMAP
Date: Wed, 26 Dec 2012 00:11:29 +0100
Message-ID: <1356477089-13241-14-git-send-email-jengelh@inai.de>
References: <1356477089-13241-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:38913 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549Ab2LYXLg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Dec 2012 18:11:36 -0500
In-Reply-To: <1356477089-13241-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Link stage of libip6t_NETMAP failed since recently.

  CCLD     libip6t_NETMAP.so
/usr/lib64/gcc/x86_64-suse-linux/4.7/../../../../x86_64-suse-linux/bin/ld:
cannot find -lip6tc

libip6t_NETMAP.c uses the "ipv6_prefix_length" function from
libip6tc.so; "-lip6tc" is used in the Makefile, but, the directory to
it is not specified.

Why does the link succeed for some people? Because
/usr/lib(64)/libip6tc.so satisfies -lip6tc, but not all environments,
especially those without iptables development files, have that file,
hence this link error can happen.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/GNUmakefile.in |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index e71e3ff..68e0b9b 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -101,7 +101,8 @@ libxt_state.so: libxt_conntrack.so
 	ln -fs $< $@
 
 # Need the LIBADDs in iptables/Makefile.am too for libxtables_la_LIBADD
-ip6t_NETMAP_LIBADD  = -lip6tc
+ip6t_NETMAP_LIBADD  = -L${top_builddir}/libiptc/.libs \
+                      -L${top_builddir}/libiptc -lip6tc
 xt_RATEEST_LIBADD   = -lm
 xt_statistic_LIBADD = -lm
 
-- 
1.7.10.4

