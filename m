From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH 2/3] Move common parts of libext{4,6}.a into libext.a
Date: Tue, 19 Apr 2011 18:44:45 -0700
Message-ID: <1303263886-5665-2-git-send-email-zenczykowski@gmail.com>
References: <BANLkTimsGzmOnXR1otTvnKBYAS7m=91+uA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
To: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43364 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379Ab1DTBpK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Apr 2011 21:45:10 -0400
Received: by pvg12 with SMTP id 12so140852pvg.19
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Apr 2011 18:45:09 -0700 (PDT)
In-Reply-To: <BANLkTimsGzmOnXR1otTvnKBYAS7m=91+uA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Maciej =C5=BBenczykowski <maze@google.com>

Signed-off-by: Maciej Zenczykowski <maze@google.com>
---
 .gitignore                |    1 +
 Makefile.am               |    8 +++++-
 extensions/GNUmakefile.in |   53 ++++++++++++++++++++++++++++++++++---=
--------
 include/xtables.h.in      |    1 +
 ip6tables-restore.c       |    1 +
 ip6tables-save.c          |    1 +
 ip6tables-standalone.c    |    1 +
 iptables-restore.c        |    1 +
 iptables-save.c           |    1 +
 iptables-standalone.c     |    1 +
 10 files changed, 54 insertions(+), 15 deletions(-)

diff --git a/.gitignore b/.gitignore
index e5d3099..9b59e6a 100644
--- a/.gitignore
+++ b/.gitignore
@@ -13,6 +13,7 @@ Makefile
 Makefile.in
=20
 /extensions/GNUmakefile
+/extensions/initext.c
 /extensions/initext?.c
 /extensions/matches?.man
 /extensions/targets?.man
diff --git a/Makefile.am b/Makefile.am
index fbed41f..6affcac 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -45,7 +45,9 @@ if ENABLE_STATIC
 iptables_multi_CFLAGS    +=3D -DALL_INCLUSIVE
 endif
 iptables_multi_LDFLAGS    =3D -rdynamic
-iptables_multi_LDADD      =3D libiptc/libip4tc.la extensions/libext4.a=
 libxtables.la -lm
+iptables_multi_LDADD      =3D libiptc/libip4tc.la \
+                            extensions/libext.a extensions/libext4.a \
+                            libxtables.la -lm
=20
 ip6tables_multi_SOURCES   =3D ip6tables-multi.c ip6tables-save.c \
                             ip6tables-restore.c ip6tables-standalone.c=
 \
@@ -55,7 +57,9 @@ if ENABLE_STATIC
 ip6tables_multi_CFLAGS   +=3D -DALL_INCLUSIVE
 endif
 ip6tables_multi_LDFLAGS   =3D -rdynamic
-ip6tables_multi_LDADD     =3D libiptc/libip6tc.la extensions/libext6.a=
 libxtables.la -lm
+ip6tables_multi_LDADD     =3D libiptc/libip6tc.la \
+                            extensions/libext.a extensions/libext6.a \
+                            libxtables.la -lm
=20
 sbin_PROGRAMS    =3D
 man_MANS         =3D iptables.8 iptables-restore.8 iptables-save.8 \
diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 0e562fb..a511a39 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -51,11 +51,13 @@ pf6_solibs    :=3D $(patsubst %,libip6t_%.so,${pf6_=
build_mod})
 #
 # Building blocks
 #
-targets :=3D libext4.a libext6.a matches4.man matches6.man \
+targets :=3D libext.a libext4.a libext6.a \
+           matches4.man matches6.man \
            targets4.man targets6.man
 targets_install :=3D
-@ENABLE_STATIC_TRUE@ libext4_objs :=3D ${pfx_objs} ${pf4_objs}
-@ENABLE_STATIC_TRUE@ libext6_objs :=3D ${pfx_objs} ${pf6_objs}
+@ENABLE_STATIC_TRUE@ libext_objs :=3D ${pfx_objs}
+@ENABLE_STATIC_TRUE@ libext4_objs :=3D ${pf4_objs}
+@ENABLE_STATIC_TRUE@ libext6_objs :=3D ${pf6_objs}
 @ENABLE_STATIC_FALSE@ targets +=3D ${pfx_solibs} ${pf4_solibs} ${pf6_s=
olibs}
 @ENABLE_STATIC_FALSE@ targets_install +=3D ${pfx_solibs} ${pf4_solibs}=
 ${pf6_solibs}
=20
@@ -70,7 +72,7 @@ install: ${targets_install}
 	if test -n "${targets_install}"; then install -pm0755 $^ "${DESTDIR}$=
{xtlibdir}/"; fi;
=20
 clean:
-	rm -f *.o *.oo *.so *.a {matches,targets}[46].man initext4.c initext6=
=2Ec;
+	rm -f *.o *.oo *.so *.a {matches,targets}[46].man initext.c initext4.=
c initext6.c;
=20
 distclean: clean
 	rm -f .*.d .*.dd;
@@ -101,36 +103,61 @@ lib%.oo: ${srcdir}/lib%.c
 lib%.o: ${srcdir}/lib%.c
 	${AM_VERBOSE_CC} ${CC} ${AM_DEPFLAGS} ${AM_CFLAGS} -DNO_SHARED_LIBS=3D=
1 -D_INIT=3Dlib$*_init ${CFLAGS} -o $@ -c $<;
=20
+libext.a: initext.o ${libext_objs}
+	${AM_VERBOSE_AR} ${AR} crs $@ $^;
+
 libext4.a: initext4.o ${libext4_objs}
 	${AM_VERBOSE_AR} ${AR} crs $@ $^;
=20
 libext6.a: initext6.o ${libext6_objs}
 	${AM_VERBOSE_AR} ${AR} crs $@ $^;
=20
-initext_func  :=3D $(addprefix xt_,${pfx_build_mod}) $(addprefix ipt_,=
${pf4_build_mod})
-initext6_func :=3D $(addprefix xt_,${pfx_build_mod}) $(addprefix ip6t_=
,${pf6_build_mod})
+initext_func  :=3D $(addprefix xt_,${pfx_build_mod})
+initext4_func :=3D $(addprefix ipt_,${pf4_build_mod})
+initext6_func :=3D $(addprefix ip6t_,${pf6_build_mod})
=20
-.initext4.dd: FORCE
+.initext.dd: FORCE
 	@echo "${initext_func}" >$@.tmp; \
 	cmp -s $@ $@.tmp || mv $@.tmp $@; \
 	rm -f $@.tmp;
=20
+.initext4.dd: FORCE
+	@echo "${initext4_func}" >$@.tmp; \
+	cmp -s $@ $@.tmp || mv $@.tmp $@; \
+	rm -f $@.tmp;
+
 .initext6.dd: FORCE
 	@echo "${initext6_func}" >$@.tmp; \
 	cmp -s $@ $@.tmp || mv $@.tmp $@; \
 	rm -f $@.tmp;
=20
-initext4.c: .initext4.dd
+initext.c: .initext.dd
 	${AM_VERBOSE_GEN}
 	@( \
 	echo "" >$@; \
 	for i in ${initext_func}; do \
 		echo "extern void lib$${i}_init(void);" >>$@; \
 	done; \
+	echo "void init_extensions(void);" >>$@; \
+	echo "void init_extensions(void)" >>$@; \
+	echo "{" >>$@; \
+	for i in ${initext_func}; do \
+		echo  " ""lib$${i}_init();" >>$@; \
+	done; \
+	echo "}" >>$@; \
+	);
+
+initext4.c: .initext4.dd
+	${AM_VERBOSE_GEN}
+	@( \
+	echo "" >$@; \
+	for i in ${initext4_func}; do \
+		echo "extern void lib$${i}_init(void);" >>$@; \
+	done; \
 	echo "void init_extensions4(void);" >>$@; \
 	echo "void init_extensions4(void)" >>$@; \
 	echo "{" >>$@; \
-	for i in ${initext_func}; do \
+	for i in ${initext4_func}; do \
 		echo  " ""lib$${i}_init();" >>$@; \
 	done; \
 	echo "}" >>$@; \
@@ -177,14 +204,14 @@ man_run    =3D \
 		fi; \
 	done >$@;
=20
-matches4.man: .initext4.dd $(wildcard ${srcdir}/lib*.man)
+matches4.man: .initext.dd .initext4.dd $(wildcard ${srcdir}/lib*.man)
 	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pf4_build_mod}),i=
p,NFPROTO_IPV4)
=20
-matches6.man: .initext6.dd $(wildcard ${srcdir}/lib*.man)
+matches6.man: .initext.dd .initext6.dd $(wildcard ${srcdir}/lib*.man)
 	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pf6_build_mod}),i=
p6,NFPROTO_IPV6)
=20
-targets4.man: .initext4.dd $(wildcard ${srcdir}/lib*.man)
+targets4.man: .initext.dd .initext4.dd $(wildcard ${srcdir}/lib*.man)
 	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pf4_build_mod}),i=
p,NFPROTO_IPV4)
=20
-targets6.man: .initext6.dd $(wildcard ${srcdir}/lib*.man)
+targets6.man: .initext.dd .initext6.dd $(wildcard ${srcdir}/lib*.man)
 	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pf6_build_mod}),i=
p6,NFPROTO_IPV6)
diff --git a/include/xtables.h.in b/include/xtables.h.in
index b080285..1d91d4d 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -422,6 +422,7 @@ extern void xtables_save_string(const char *value);
 #		undef _init
 #		define _init _INIT
 #	endif
+	extern void init_extensions(void);
 	extern void init_extensions4(void);
 	extern void init_extensions6(void);
 #else
diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index 5531d6e..420bc52 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -137,6 +137,7 @@ int main(int argc, char *argv[])
 		exit(1);
 	}
 #if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
+	init_extensions();
 	init_extensions6();
 #endif
=20
diff --git a/ip6tables-save.c b/ip6tables-save.c
index d9ecc62..39a3325 100644
--- a/ip6tables-save.c
+++ b/ip6tables-save.c
@@ -149,6 +149,7 @@ int main(int argc, char *argv[])
 		exit(1);
 	}
 #if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
+	init_extensions();
 	init_extensions6();
 #endif
=20
diff --git a/ip6tables-standalone.c b/ip6tables-standalone.c
index 7d34684..9d8d5a0 100644
--- a/ip6tables-standalone.c
+++ b/ip6tables-standalone.c
@@ -59,6 +59,7 @@ main(int argc, char *argv[])
 	}
=20
 #if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
+	init_extensions();
 	init_extensions6();
 #endif
=20
diff --git a/iptables-restore.c b/iptables-restore.c
index e4f0604..2624599 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -140,6 +140,7 @@ main(int argc, char *argv[])
 		exit(1);
 	}
 #if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
+	init_extensions();
 	init_extensions4();
 #endif
=20
diff --git a/iptables-save.c b/iptables-save.c
index dee1752..7542bdc 100644
--- a/iptables-save.c
+++ b/iptables-save.c
@@ -149,6 +149,7 @@ main(int argc, char *argv[])
 		exit(1);
 	}
 #if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
+	init_extensions();
 	init_extensions4();
 #endif
=20
diff --git a/iptables-standalone.c b/iptables-standalone.c
index b085946..87f1d31 100644
--- a/iptables-standalone.c
+++ b/iptables-standalone.c
@@ -59,6 +59,7 @@ main(int argc, char *argv[])
 				exit(1);
 	}
 #if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
+	init_extensions();
 	init_extensions4();
 #endif
=20
--=20
1.7.3.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
