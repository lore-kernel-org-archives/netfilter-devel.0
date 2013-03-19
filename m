From: pablo@netfilter.org
Subject: [PATCH 2/2] Revert "build: resolve link failure for ip6t_NETMAP"
Date: Wed, 20 Mar 2013 00:43:06 +0100
Message-ID: <1363736586-4313-2-git-send-email-pablo@netfilter.org>
References: <1363736586-4313-1-git-send-email-pablo@netfilter.org>
Cc: ldv@altlinux.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39733 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756530Ab3CSXnP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Mar 2013 19:43:15 -0400
In-Reply-To: <1363736586-4313-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This reverts commit 68e77a26111ee6b8f10c735a76891a7de6d57ee6.

The use of libtool was introduced to resolve linking problems
in NETMAP (IPv6 version), but that resulted in RPATH problems
reported from distributors and warnings spotted by libtool at
linking stage.

Since (0ca548b libip6t_NETMAP: Use xtables_ip6mask_to_cidr and
get rid of libip6tc dependency) fixed the NETMAP issue, let's
roll back to our previous stage.

A small conflicts in extensions/GNUmakefile.in has been resolved
in this revert.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 extensions/GNUmakefile.in |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 3db6985..1ae7f74 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -33,7 +33,6 @@ AM_VERBOSE_CXX    = @echo "  CXX     " $@;
 AM_VERBOSE_CXXLD  = @echo "  CXXLD   " $@;
 AM_VERBOSE_AR     = @echo "  AR      " $@;
 AM_VERBOSE_GEN    = @echo "  GEN     " $@;
-AM_VERBOSE_NULL   = @
 endif
 
 #
@@ -76,7 +75,7 @@ install: ${targets_install}
 	if test -n "${targets_install}"; then install -pm0755 $^ "${DESTDIR}${xtlibdir}/"; fi;
 
 clean:
-	rm -f *.la *.o *.lo *.so *.a {matches,targets}.man initext.c initext4.c initext6.c;
+	rm -f *.o *.oo *.so *.a {matches,targets}.man initext.c initext4.c initext6.c;
 	rm -f .*.d .*.dd;
 
 distclean: clean
@@ -90,19 +89,16 @@ init%.o: init%.c
 #
 #	Shared libraries
 #
-lib%.so: lib%.la
-	${AM_VERBOSE_NULL} ln -fs .libs/$@ $@
+lib%.so: lib%.oo
+	${AM_VERBOSE_CCLD} ${CCLD} ${AM_LDFLAGS} -shared ${LDFLAGS} -o $@ $< -L../libxtables/.libs -lxtables ${$*_LIBADD};
 
-lib%.la: lib%.lo
-	${AM_VERBOSE_CCLD} ../libtool ${AM_LIBTOOL_SILENT} --tag=CC --mode=link ${CCLD} ${AM_LDFLAGS} -module ${LDFLAGS} -o $@ $< ../libxtables/libxtables.la ${$*_LIBADD} -rpath ${xtlibdir}
-
-lib%.lo: ${srcdir}/lib%.c
-	${AM_VERBOSE_CC} ../libtool ${AM_LIBTOOL_SILENT} --tag=CC --mode=compile ${CC} ${AM_CPPFLAGS} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=lib$*_init ${CFLAGS} -o $@ -c $<
+lib%.oo: ${srcdir}/lib%.c
+	${AM_VERBOSE_CC} ${CC} ${AM_CPPFLAGS} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=lib$*_init -DPIC -fPIC ${CFLAGS} -o $@ -c $<;
 
 libxt_NOTRACK.so: libxt_CT.so
-	${AM_VERBOSE_GEN} ln -fs $< $@
+	ln -fs $< $@
 libxt_state.so: libxt_conntrack.so
-	${AM_VERBOSE_GEN} ln -fs $< $@
+	ln -fs $< $@
 
 # Need the LIBADDs in iptables/Makefile.am too for libxtables_la_LIBADD
 xt_RATEEST_LIBADD   = -lm
-- 
1.7.10.4

