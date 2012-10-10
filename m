From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 1/2] build: remove symlink-only extensions from static object list
Date: Wed, 10 Oct 2012 12:35:13 +0200
Message-ID: <1349865314-27640-2-git-send-email-jengelh@inai.de>
References: <1349865314-27640-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:57230 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944Ab2JJKfR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Oct 2012 06:35:17 -0400
In-Reply-To: <1349865314-27640-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

$ ./configure --enable-static --disable-shared --enable-ipv4
  --enable-ipv6 && make
[...]
make[3]: *** No rule to make target "libxt_NOTRACK.o", needed by
"libext.a". Stop.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/GNUmakefile.in |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 8b38df9..1cef239 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -39,7 +39,7 @@ endif
 #	Wildcard module list
 #
 pfx_build_mod := $(patsubst ${srcdir}/libxt_%.c,%,$(sort $(wildcard ${srcdir}/libxt_*.c)))
-pfx_build_mod += NOTRACK state
+pfx_symlinks  := NOTRACK state
 @ENABLE_IPV4_TRUE@ pf4_build_mod := $(patsubst ${srcdir}/libipt_%.c,%,$(sort $(wildcard ${srcdir}/libipt_*.c)))
 @ENABLE_IPV6_TRUE@ pf6_build_mod := $(patsubst ${srcdir}/libip6t_%.c,%,$(sort $(wildcard ${srcdir}/libip6t_*.c)))
 pfx_build_mod := $(filter-out @blacklist_modules@,${pfx_build_mod})
@@ -48,7 +48,7 @@ pf6_build_mod := $(filter-out @blacklist_modules@,${pf6_build_mod})
 pfx_objs      := $(patsubst %,libxt_%.o,${pfx_build_mod})
 pf4_objs      := $(patsubst %,libipt_%.o,${pf4_build_mod})
 pf6_objs      := $(patsubst %,libip6t_%.o,${pf6_build_mod})
-pfx_solibs    := $(patsubst %,libxt_%.so,${pfx_build_mod})
+pfx_solibs    := $(patsubst %,libxt_%.so,${pfx_build_mod} ${pfx_symlinks})
 pf4_solibs    := $(patsubst %,libipt_%.so,${pf4_build_mod})
 pf6_solibs    := $(patsubst %,libip6t_%.so,${pf6_build_mod})
 
@@ -220,7 +220,7 @@ man_run    = \
 	done >$@;
 
 matches.man: .initext.dd .initext4.dd .initext6.dd $(wildcard ${srcdir}/lib*.man)
-	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pf4_build_mod} ${pf6_build_mod}))
+	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pf4_build_mod} ${pf6_build_mod} ${pfx_symlinks}))
 
 targets.man: .initext.dd .initext4.dd .initext6.dd $(wildcard ${srcdir}/lib*.man)
-	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pf4_build_mod} ${pf6_build_mod}))
+	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pf4_build_mod} ${pf6_build_mod} ${pfx_symlinks}))
-- 
1.7.10.4

