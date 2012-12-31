From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH] build: resolve link failure for ip6t_NETMAP
Date: Mon, 31 Dec 2012 06:54:06 +0100
Message-ID: <1356933246-20336-1-git-send-email-jengelh@inai.de>
References: <201212301951.47241.vapier@gentoo.org>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: vapier@gentoo.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:52815 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab2LaFyJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Dec 2012 00:54:09 -0500
In-Reply-To: <201212301951.47241.vapier@gentoo.org>
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

By suggestion of Mike Frysinger, this patch uses libtool to produce
and link the plugins.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---

Like this? We cannot really get rid of mentioning .libs without involving
libltdl, and there I really do not want to go.

If you ask me, we should just move ipv6_prefix_length into libxtables.


 extensions/GNUmakefile.in |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index e71e3ff..6020ff6 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -33,6 +33,7 @@ AM_VERBOSE_CXX    = @echo "  CXX     " $@;
 AM_VERBOSE_CXXLD  = @echo "  CXXLD   " $@;
 AM_VERBOSE_AR     = @echo "  AR      " $@;
 AM_VERBOSE_GEN    = @echo "  GEN     " $@;
+AM_VERBOSE_NULL   = @
 endif
 
 #
@@ -75,7 +76,7 @@ install: ${targets_install}
 	if test -n "${targets_install}"; then install -pm0755 $^ "${DESTDIR}${xtlibdir}/"; fi;
 
 clean:
-	rm -f *.o *.oo *.so *.a {matches,targets}.man initext.c initext4.c initext6.c;
+	rm -f *.la *.o *.lo *.so *.a {matches,targets}.man initext.c initext4.c initext6.c;
 	rm -f .*.d .*.dd;
 
 distclean: clean
@@ -89,11 +90,14 @@ init%.o: init%.c
 #
 #	Shared libraries
 #
-lib%.so: lib%.oo
-	${AM_VERBOSE_CCLD} ${CCLD} ${AM_LDFLAGS} -shared ${LDFLAGS} -o $@ $< -L../libxtables/.libs -lxtables ${$*_LIBADD};
+lib%.so: lib%.la
+	${AM_VERBOSE_NULL} ln -fs .libs/$@ $@;
 
-lib%.oo: ${srcdir}/lib%.c
-	${AM_VERBOSE_CC} ${CC} ${AM_CPPFLAGS} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=lib$*_init -DPIC -fPIC ${CFLAGS} -o $@ -c $<;
+lib%.la: lib%.lo
+	${AM_VERBOSE_CCLD} ../libtool ${AM_LIBTOOL_SILENT} --tag=CC --mode=link ${CCLD} ${AM_LDFLAGS} -module ${LDFLAGS} -o $@ $< -L../libxtables -lxtables ${$*_LIBADD} -rpath ${xtlibdir};
+
+lib%.lo: ${srcdir}/lib%.c
+	${AM_VERBOSE_CC} ../libtool ${AM_LIBTOOL_SILENT} --tag=CC --mode=compile ${CC} ${AM_CPPFLAGS} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=lib$*_init ${CFLAGS} -o $@ -c $<;
 
 libxt_NOTRACK.so: libxt_CT.so
 	ln -fs $< $@
@@ -101,7 +105,7 @@ libxt_state.so: libxt_conntrack.so
 	ln -fs $< $@
 
 # Need the LIBADDs in iptables/Makefile.am too for libxtables_la_LIBADD
-ip6t_NETMAP_LIBADD  = -lip6tc
+ip6t_NETMAP_LIBADD  = ../libiptc/libip6tc.la
 xt_RATEEST_LIBADD   = -lm
 xt_statistic_LIBADD = -lm
 
-- 
1.7.10.4

