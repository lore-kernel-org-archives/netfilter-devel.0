From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [ebtables-compat PATCH] build ebtables extensions
Date: Mon, 10 Nov 2014 20:03:08 +0100
Message-ID: <1415646188-2549-1-git-send-email-giuseppelng@gmail.com>
Cc: pablo@netfilter.org, Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33033 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaKJTDX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2014 14:03:23 -0500
Received: by mail-wi0-f171.google.com with SMTP id r20so11546053wiv.16
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Nov 2014 11:03:19 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This permits to build extensions for ebtables-compat layer.

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 extensions/GNUmakefile.in | 40 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 5 deletions(-)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 5291572..7b4f891 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -39,16 +39,20 @@ endif
 #	Wildcard module list
 #
 pfx_build_mod := $(patsubst ${srcdir}/libxt_%.c,%,$(sort $(wildcard ${srcdir}/libxt_*.c)))
+pfb_build_mod := $(patsubst ${srcdir}/libebt_%.c,%,$(sort $(wildcard ${srcdir}/libebt_*.c)))
 pfx_symlinks  := NOTRACK state
 @ENABLE_IPV4_TRUE@ pf4_build_mod := $(patsubst ${srcdir}/libipt_%.c,%,$(sort $(wildcard ${srcdir}/libipt_*.c)))
 @ENABLE_IPV6_TRUE@ pf6_build_mod := $(patsubst ${srcdir}/libip6t_%.c,%,$(sort $(wildcard ${srcdir}/libip6t_*.c)))
 pfx_build_mod := $(filter-out @blacklist_modules@,${pfx_build_mod})
+pfb_build_mod := $(filter-out @blacklist_modules@,${pfb_build_mod})
 pf4_build_mod := $(filter-out @blacklist_modules@,${pf4_build_mod})
 pf6_build_mod := $(filter-out @blacklist_modules@,${pf6_build_mod})
 pfx_objs      := $(patsubst %,libxt_%.o,${pfx_build_mod})
+pfb_objs      := $(patsubst %,libebt_%.o,${pfb_build_mod})
 pf4_objs      := $(patsubst %,libipt_%.o,${pf4_build_mod})
 pf6_objs      := $(patsubst %,libip6t_%.o,${pf6_build_mod})
 pfx_solibs    := $(patsubst %,libxt_%.so,${pfx_build_mod} ${pfx_symlinks})
+pfb_solibs    := $(patsubst %,libebt_%.so,${pfb_build_mod})
 pf4_solibs    := $(patsubst %,libipt_%.so,${pf4_build_mod})
 pf6_solibs    := $(patsubst %,libip6t_%.so,${pf6_build_mod})
 
@@ -59,10 +63,11 @@ pf6_solibs    := $(patsubst %,libip6t_%.so,${pf6_build_mod})
 targets := libext.a libext4.a libext6.a matches.man targets.man
 targets_install :=
 @ENABLE_STATIC_TRUE@ libext_objs := ${pfx_objs}
+@ENABLE_STATIC_TRUE@ libextb_objs := ${pfb_objs}
 @ENABLE_STATIC_TRUE@ libext4_objs := ${pf4_objs}
 @ENABLE_STATIC_TRUE@ libext6_objs := ${pf6_objs}
-@ENABLE_STATIC_FALSE@ targets += ${pfx_solibs} ${pf4_solibs} ${pf6_solibs}
-@ENABLE_STATIC_FALSE@ targets_install += ${pfx_solibs} ${pf4_solibs} ${pf6_solibs}
+@ENABLE_STATIC_FALSE@ targets += ${pfx_solibs} ${pfb_solibs} ${pf4_solibs} ${pf6_solibs}
+@ENABLE_STATIC_FALSE@ targets_install += ${pfx_solibs} ${pfb_solibs} ${pf4_solibs} ${pf6_solibs}
 
 .SECONDARY:
 
@@ -118,6 +123,9 @@ lib%.o: ${srcdir}/lib%.c
 libext.a: initext.o ${libext_objs}
 	${AM_VERBOSE_AR} ${AR} crs $@ $^;
 
+libextb.a: initextb.o ${libextb_objs}
+	${AM_VERBOSE_AR} ${AR} crs $@ $^;
+
 libext4.a: initext4.o ${libext4_objs}
 	${AM_VERBOSE_AR} ${AR} crs $@ $^;
 
@@ -125,6 +133,7 @@ libext6.a: initext6.o ${libext6_objs}
 	${AM_VERBOSE_AR} ${AR} crs $@ $^;
 
 initext_func  := $(addprefix xt_,${pfx_build_mod})
+initextb_func := $(addprefix ebt_,${pfb_build_mod})
 initext4_func := $(addprefix ipt_,${pf4_build_mod})
 initext6_func := $(addprefix ip6t_,${pf6_build_mod})
 
@@ -133,6 +142,11 @@ initext6_func := $(addprefix ip6t_,${pf6_build_mod})
 	cmp -s $@ $@.tmp || mv $@.tmp $@; \
 	rm -f $@.tmp;
 
+.initextb.dd: FORCE
+	@echo "${initextb_func}" >$@.tmp; \
+	cmp -s $@ $@.tmp || mv $@.tmp $@; \
+	rm -f $@.tmp;
+
 .initext4.dd: FORCE
 	@echo "${initext4_func}" >$@.tmp; \
 	cmp -s $@ $@.tmp || mv $@.tmp $@; \
@@ -159,6 +173,22 @@ initext.c: .initext.dd
 	echo "}" >>$@; \
 	);
 
+initextb.c: .initextb.dd
+	${AM_VERBOSE_GEN}
+	@( \
+	echo "" >$@; \
+	for i in ${initextb_func}; do \
+		echo "extern void lib$${i}_init(void);" >>$@; \
+	done; \
+	echo "void init_extensions(void);" >>$@; \
+	echo "void init_extensions(void)" >>$@; \
+	echo "{" >>$@; \
+	for i in ${initextb_func}; do \
+		echo  " ""lib$${i}_init();" >>$@; \
+	done; \
+	echo "}" >>$@; \
+	);
+
 initext4.c: .initext4.dd
 	${AM_VERBOSE_GEN}
 	@( \
@@ -219,8 +249,8 @@ man_run    = \
 		fi; \
 	done >$@;
 
-matches.man: .initext.dd .initext4.dd .initext6.dd $(wildcard ${srcdir}/lib*.man)
-	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pf4_build_mod} ${pf6_build_mod} ${pfx_symlinks}))
+matches.man: .initext.dd .initextb.dd .initext4.dd .initext6.dd $(wildcard ${srcdir}/lib*.man)
+	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pfb_build_mod} ${pf4_build_mod} ${pf6_build_mod} ${pfx_symlinks}))
 
 targets.man: .initext.dd .initext4.dd .initext6.dd $(wildcard ${srcdir}/lib*.man)
-	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pf4_build_mod} ${pf6_build_mod} ${pfx_symlinks}))
+	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pfb_build_mod} ${pf4_build_mod} ${pf6_build_mod} ${pfx_symlinks}))
-- 
1.9.1

