From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 4/5] build: do not dereference symlinks on installation
Date: Tue,  5 Mar 2013 02:08:14 +0100
Message-ID: <1362445695-15952-5-git-send-email-jengelh@inai.de>
References: <1362445695-15952-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:45717 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758916Ab3CEBIR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Mar 2013 20:08:17 -0500
In-Reply-To: <1362445695-15952-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

By using install(1), libxt_NOTRACK.so was inadvertently installed as
an actual file to /usr/lib/xtables rather than as a symlink. Switch to
using cp(1).

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/GNUmakefile.in |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index adad4d6..781ac6d 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -40,7 +40,7 @@ endif
 #	Wildcard module list
 #
 pfx_build_mod := $(patsubst ${srcdir}/libxt_%.c,%,$(sort $(wildcard ${srcdir}/libxt_*.c)))
-pfx_symlinks  := NOTRACK state
+pfx_symlinks  := libxt_NOTRACK.so libxt_state.so
 @ENABLE_IPV4_TRUE@ pf4_build_mod := $(patsubst ${srcdir}/libipt_%.c,%,$(sort $(wildcard ${srcdir}/libipt_*.c)))
 @ENABLE_IPV6_TRUE@ pf6_build_mod := $(patsubst ${srcdir}/libip6t_%.c,%,$(sort $(wildcard ${srcdir}/libip6t_*.c)))
 pfx_build_mod := $(filter-out @blacklist_modules@,${pfx_build_mod})
@@ -49,7 +49,7 @@ pf6_build_mod := $(filter-out @blacklist_modules@,${pf6_build_mod})
 pfx_objs      := $(patsubst %,libxt_%.o,${pfx_build_mod})
 pf4_objs      := $(patsubst %,libipt_%.o,${pf4_build_mod})
 pf6_objs      := $(patsubst %,libip6t_%.o,${pf6_build_mod})
-pfx_solibs    := $(patsubst %,libxt_%.so,${pfx_build_mod} ${pfx_symlinks})
+pfx_solibs    := $(patsubst %,libxt_%.so,${pfx_build_mod})
 pf4_solibs    := $(patsubst %,libipt_%.so,${pf4_build_mod})
 pf6_solibs    := $(patsubst %,libip6t_%.so,${pf6_build_mod})
 
@@ -59,11 +59,13 @@ pf6_solibs    := $(patsubst %,libip6t_%.so,${pf6_build_mod})
 #
 targets := libext.a libext4.a libext6.a matches.man targets.man
 targets_install :=
+targets_instlink :=
 @ENABLE_STATIC_TRUE@ libext_objs := ${pfx_objs}
 @ENABLE_STATIC_TRUE@ libext4_objs := ${pf4_objs}
 @ENABLE_STATIC_TRUE@ libext6_objs := ${pf6_objs}
-@ENABLE_STATIC_FALSE@ targets += ${pfx_solibs} ${pf4_solibs} ${pf6_solibs}
+@ENABLE_STATIC_FALSE@ targets += ${pfx_solibs} ${pfx_symlinks} ${pf4_solibs} ${pf6_solibs}
 @ENABLE_STATIC_FALSE@ targets_install += ${pfx_solibs} ${pf4_solibs} ${pf6_solibs}
+@ENABLE_STATIC_FALSE@ targets_instlink += ${pfx_symlinks}
 
 .SECONDARY:
 
@@ -71,9 +73,12 @@ targets_install :=
 
 all: ${targets}
 
-install: ${targets_install}
+install: ${targets_install} ${targets_instlink}
 	@mkdir -p "${DESTDIR}${xtlibdir}";
-	if test -n "${targets_install}"; then install -pm0755 $^ "${DESTDIR}${xtlibdir}/"; fi;
+	if test -n "${targets_install}"; then \
+		install -pm0755 ${targets_install} "${DESTDIR}${xtlibdir}/"; \
+		cp -a ${pfx_symlinks} "${DESTDIR}${xtlibdir}/"; \
+	fi;
 
 clean:
 	rm -f *.la *.o *.lo *.so *.a {matches,targets}.man initext.c initext4.c initext6.c;
-- 
1.7.10.4

