From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/2] build: start using Automake for building
Date: Mon, 15 Nov 2010 23:23:04 +0100
Message-ID: <1289859785-3098-3-git-send-email-jengelh@medozas.de>
References: <1289859785-3098-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: stephen.hemminger@vyatta.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43341 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758623Ab0KOWXJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 17:23:09 -0500
In-Reply-To: <1289859785-3098-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

- Fix up some paths in the process.
  - Replace hardcoded /etc/iproute2 by ${sysconfdir}/iproute2
  - Move plugins to ${libexecdir} where they belong
  - Move netem/*.dist to ${datadir}/iproute2 where they belong

- Rename of emp_ematch.* so that their basenames do not collide.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 .gitignore           |   42 ++++++------
 Makefile             |   89 -------------------------
 Makefile.am          |   36 ++++++++++
 autogen.sh           |    4 +
 configure            |  180 --------------------------------------------------
 configure.ac         |   55 +++++++++++++++
 doc/Makefile         |   55 ---------------
 doc/Makefile.am      |   49 ++++++++++++++
 genl/Makefile        |   38 -----------
 genl/Makefile.am     |    8 ++
 ip/Makefile          |   43 ------------
 ip/Makefile.am       |   17 +++++
 ip/iplink.c          |    6 +--
 lib/Makefile         |   19 -----
 lib/Makefile.am      |   13 ++++
 lib/rt_names.c       |   10 ++--
 m4/.gitignore        |    2 +
 misc/.gitignore      |   16 +++--
 misc/Makefile        |   35 ----------
 misc/Makefile.am     |   19 +++++
 netem/.gitignore     |   11 ++--
 netem/Makefile       |   29 --------
 netem/Makefile.am    |   23 +++++++
 tc/.gitignore        |   11 ++--
 tc/Makefile          |  144 ----------------------------------------
 tc/Makefile.am       |   44 ++++++++++++
 tc/emp_ematch.l      |  145 ----------------------------------------
 tc/emp_ematch.y      |  101 ----------------------------
 tc/emp_ematch_lex.l  |  145 ++++++++++++++++++++++++++++++++++++++++
 tc/emp_ematch_yacc.y |  101 ++++++++++++++++++++++++++++
 tc/q_netem.c         |    2 +-
 tc/tc_util.c         |   14 +++--
 tc/tc_util.h         |    1 +
 33 files changed, 575 insertions(+), 932 deletions(-)
 delete mode 100644 Makefile
 create mode 100644 Makefile.am
 create mode 100755 autogen.sh
 delete mode 100755 configure
 create mode 100644 configure.ac
 delete mode 100644 doc/Makefile
 create mode 100644 doc/Makefile.am
 delete mode 100644 genl/Makefile
 create mode 100644 genl/Makefile.am
 delete mode 100644 ip/Makefile
 create mode 100644 ip/Makefile.am
 delete mode 100644 lib/Makefile
 create mode 100644 lib/Makefile.am
 create mode 100644 m4/.gitignore
 delete mode 100644 misc/Makefile
 create mode 100644 misc/Makefile.am
 delete mode 100644 netem/Makefile
 create mode 100644 netem/Makefile.am
 delete mode 100644 tc/Makefile
 create mode 100644 tc/Makefile.am
 delete mode 100644 tc/emp_ematch.l
 delete mode 100644 tc/emp_ematch.y
 create mode 100644 tc/emp_ematch_lex.l
 create mode 100644 tc/emp_ematch_yacc.y

diff --git a/.gitignore b/.gitignore
index 5ee2080..a40062f 100644
--- a/.gitignore
+++ b/.gitignore
@@ -1,22 +1,22 @@
-static-syms.h
-Config
+.deps
+.libs
+Makefile
+Makefile.in
 *.o
-*.a
-*.so
-*~
-\#*#
-# cscope
-cscope.*
-ncscope.*
-# for patch generation
-*.diff
-*.patch
-*.orig
-*.rej
-# for quilt
-patches
-series
-# for gdb
-.gdbinit
-.gdb_history
-*.gdb
+*.la
+*.lo
+
+/aclocal.m4
+/autom4te.cache
+/compile
+/config.*
+/configure
+/depcomp
+/install-sh
+/libtool
+/ltmain.sh
+/missing
+/stamp-h1
+/ylwrap
+
+/cscope.*
diff --git a/Makefile b/Makefile
deleted file mode 100644
index 77a85c6..0000000
--- a/Makefile
+++ /dev/null
@@ -1,89 +0,0 @@
-DESTDIR=/usr/
-ROOTDIR=$(DESTDIR)
-LIBDIR=/usr/lib/
-SBINDIR=/sbin
-CONFDIR=/etc/iproute2
-DOCDIR=/share/doc/iproute2
-MANDIR=/share/man
-ARPDDIR=/var/lib/arpd
-
-# Path to db_185.h include
-DBM_INCLUDE:=$(ROOTDIR)/usr/include
-
-SHARED_LIBS = y
-
-DEFINES= -DRESOLVE_HOSTNAMES -DLIBDIR=\"$(LIBDIR)\"
-ifneq ($(SHARED_LIBS),y)
-DEFINES+= -DNO_SHARED_LIBS
-endif
-
-#options if you have a bind>=4.9.4 libresolv (or, maybe, glibc)
-LDLIBS=-lresolv
-ADDLIB=
-
-#options for decnet
-ADDLIB+=dnet_ntop.o dnet_pton.o
-
-#options for ipx
-ADDLIB+=ipx_ntop.o ipx_pton.o
-
-CC = gcc
-HOSTCC = gcc
-CCOPTS = -D_GNU_SOURCE -O2 -Wstrict-prototypes -Wall
-CFLAGS = $(CCOPTS) -I../include $(DEFINES)
-YACCFLAGS = -d -t -v
-
-LDLIBS += -L../lib -lnetlink -lutil
-
-SUBDIRS=lib ip tc misc netem genl
-
-LIBNETLINK=../lib/libnetlink.a ../lib/libutil.a
-
-all: Config
-	@set -e; \
-	for i in $(SUBDIRS); \
-	do $(MAKE) $(MFLAGS) -C $$i; done
-
-Config:
-	sh configure $(KERNEL_INCLUDE)
-
-install: all
-	install -m 0755 -d $(DESTDIR)$(SBINDIR)
-	install -m 0755 -d $(DESTDIR)$(CONFDIR)
-	install -m 0755 -d $(DESTDIR)$(ARPDDIR)
-	install -m 0755 -d $(DESTDIR)$(DOCDIR)/examples
-	install -m 0755 -d $(DESTDIR)$(DOCDIR)/examples/diffserv
-	install -m 0644 README.iproute2+tc $(shell find examples -maxdepth 1 -type f) \
-		$(DESTDIR)$(DOCDIR)/examples
-	install -m 0644 $(shell find examples/diffserv -maxdepth 1 -type f) \
-		$(DESTDIR)$(DOCDIR)/examples/diffserv
-	@for i in $(SUBDIRS) doc; do $(MAKE) -C $$i install; done
-	install -m 0644 $(shell find etc/iproute2 -maxdepth 1 -type f) $(DESTDIR)$(CONFDIR)
-	install -m 0755 -d $(DESTDIR)$(MANDIR)/man8
-	install -m 0644 $(shell find man/man8 -maxdepth 1 -type f) $(DESTDIR)$(MANDIR)/man8
-	ln -sf tc-bfifo.8  $(DESTDIR)$(MANDIR)/man8/tc-pfifo.8
-	ln -sf lnstat.8  $(DESTDIR)$(MANDIR)/man8/rtstat.8
-	ln -sf lnstat.8  $(DESTDIR)$(MANDIR)/man8/ctstat.8
-	ln -sf rtacct.8  $(DESTDIR)$(MANDIR)/man8/nstat.8
-	ln -sf routel.8  $(DESTDIR)$(MANDIR)/man8/routef.8
-	install -m 0755 -d $(DESTDIR)$(MANDIR)/man3
-	install -m 0644 $(shell find man/man3 -maxdepth 1 -type f) $(DESTDIR)$(MANDIR)/man3
-
-snapshot:
-	echo "static const char SNAPSHOT[] = \""`date +%y%m%d`"\";" \
-		> include/SNAPSHOT.h
-
-clean:
-	rm -f cscope.*
-	@for i in $(SUBDIRS) doc; \
-	do $(MAKE) $(MFLAGS) -C $$i clean; done
-
-clobber: clean
-	rm -f Config
-
-distclean: clobber
-
-cscope:
-	cscope -b -q -R -Iinclude -sip -slib -smisc -snetem -stc
-
-.EXPORT_ALL_VARIABLES:
diff --git a/Makefile.am b/Makefile.am
new file mode 100644
index 0000000..6879da0
--- /dev/null
+++ b/Makefile.am
@@ -0,0 +1,36 @@
+# -*- Makefile -*-
+
+ACLOCAL_AMFLAGS = -I m4
+
+SUBDIRS = doc lib ip tc misc netem genl
+
+#man3_MANS = man/man3/libnetlink.3
+man8_MANS = man/man8/arpd.8 man/man8/ip.8 man/man8/lnstat.8 man/man8/routel.8 \
+            man/man8/rtacct.8 man/man8/rtmon.8 man/man8/ss.8 \
+            man/man8/tc-bfifo.8 man/man8/tc-cbq-details.8 man/man8/tc-cbq.8 \
+            man/man8/tc-drr.8 man/man8/tc-htb.8 man/man8/tc-pfifo.8 \
+            man/man8/tc-pfifo_fast.8 man/man8/tc-prio.8 man/man8/tc-red.8 \
+            man/man8/tc-sfq.8 man/man8/tc-tbf.8 man/man8/tc.8
+
+snapshot:
+	echo "static const char SNAPSHOT[] = \""$(date +%Y%m%d)"\";" \
+		>include/SNAPSHOT.h
+
+arpddir = ${localstatedir}/lib/arpd
+
+install-data-hook:
+	${MKDIR_P} ${DESTDIR}${pkgsysconfdir}
+	${INSTALL} -m 0644 etc/iproute2/* ${DESTDIR}${pkgsysconfdir}/
+	${MKDIR_P} ${DESTDIR}${arpddir}
+	${MKDIR_P} ${DESTDIR}${docdir}/examples/diffserv
+	${INSTALL} -m 0644 README.iproute2+tc \
+		$(shell find examples -maxdepth 1 -type f) \
+		${DESTDIR}${docdir}/examples/
+	${INSTALL} -m 0644 $(shell find examples/diffserv -maxdepth 1 -type f) \
+		${DESTDIR}${docdir}/examples/diffserv/
+
+cscope:
+	cscope -b -q -R -Iinclude -sip -slib -smisc -snetem -stc
+
+clean-local:
+	rm -f cscope.*
diff --git a/autogen.sh b/autogen.sh
new file mode 100755
index 0000000..5e1344a
--- /dev/null
+++ b/autogen.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+
+autoreconf -fi
+rm -Rf autom4te.cache
diff --git a/configure b/configure
deleted file mode 100755
index 600fa96..0000000
--- a/configure
+++ /dev/null
@@ -1,180 +0,0 @@
-#! /bin/bash
-# This is not an autconf generated configure
-#
-INCLUDE=${1:-"$PWD/include"}
-
-TABLES=
-
-check_atm()
-{
-cat >/tmp/atmtest.c <<EOF
-#include <atm.h>
-int main(int argc, char **argv) {
-	struct atm_qos qos;
-	(void) text2qos("aal5,ubr:sdu=9180,rx:none",&qos,0);
-	return 0;
-}
-EOF
-gcc -I$INCLUDE -o /tmp/atmtest /tmp/atmtest.c -latm >/dev/null 2>&1 
-if [ $? -eq 0 ]
-then
-    echo "TC_CONFIG_ATM:=y" >>Config
-    echo yes
-else
-    echo no
-fi
-rm -f /tmp/atmtest.c /tmp/atmtest
-}
-
-check_xt()
-{
-#check if we have xtables from iptables >= 1.4.5.
-cat >/tmp/ipttest.c <<EOF
-#include <xtables.h>
-#include <linux/netfilter.h>
-static struct xtables_globals test_globals = {
-	.option_offset = 0,
-	.program_name = "tc-ipt",
-	.program_version = XTABLES_VERSION,
-	.orig_opts = NULL,
-	.opts = NULL,
-	.exit_err = NULL,
-};
-
-int main(int argc, char **argv)
-{
-	xtables_init_all(&test_globals, NFPROTO_IPV4);
-	return 0;
-}
-
-EOF
-
-if gcc -I$INCLUDE $IPTC -o /tmp/ipttest /tmp/ipttest.c $IPTL -ldl -lxtables >/dev/null 2>&1
-then
-	echo "TC_CONFIG_XT:=y" >>Config
-	echo "using xtables"
-fi
-rm -f /tmp/ipttest.c /tmp/ipttest
-}
-
-check_xt_old()
-{
-# bail if previous XT checks has already succeded.
-if grep TC_CONFIG_XT Config > /dev/null
-then
-	return
-fi
-
-#check if we need dont our internal header ..
-cat >/tmp/ipttest.c <<EOF
-#include <xtables.h>
-char *lib_dir;
-unsigned int global_option_offset = 0;
-const char *program_version = XTABLES_VERSION;
-const char *program_name = "tc-ipt";
-struct afinfo afinfo = {
-	.libprefix      = "libxt_",
-};
-
-void exit_error(enum exittype status, const char *msg, ...)
-{
-}
-
-int main(int argc, char **argv) {
-
-	return 0;
-}
-
-EOF
-gcc -I$INCLUDE $IPTC -o /tmp/ipttest /tmp/ipttest.c $IPTL -ldl >/dev/null 2>&1
-
-if [ $? -eq 0 ]
-then
-	echo "TC_CONFIG_XT_OLD:=y" >>Config
-	echo "using old xtables (no need for xt-internal.h)"
-fi
-rm -f /tmp/ipttest.c /tmp/ipttest
-}
-
-check_xt_old_internal_h()
-{
-# bail if previous XT checks has already succeded.
-if grep TC_CONFIG_XT Config > /dev/null
-then
-	return
-fi
-
-#check if we need our own internal.h
-cat >/tmp/ipttest.c <<EOF
-#include <xtables.h>
-#include "xt-internal.h"
-char *lib_dir;
-unsigned int global_option_offset = 0;
-const char *program_version = XTABLES_VERSION;
-const char *program_name = "tc-ipt";
-struct afinfo afinfo = {
-	.libprefix      = "libxt_",
-};
-
-void exit_error(enum exittype status, const char *msg, ...)
-{
-}
-
-int main(int argc, char **argv) {
-
-	return 0;
-}
-
-EOF
-gcc -I$INCLUDE $IPTC -o /tmp/ipttest /tmp/ipttest.c $IPTL -ldl >/dev/null 2>&1
-
-if [ $? -eq 0 ]
-then
-	echo "using old xtables with xt-internal.h"
-	echo "TC_CONFIG_XT_OLD_H:=y" >>Config
-fi
-rm -f /tmp/ipttest.c /tmp/ipttest
-}
-
-check_ipt()
-{
-	if ! grep TC_CONFIG_XT Config > /dev/null
-	then
-		echo "using iptables"
-		TABLES="iptables"
-	else
-		TABLES="xtables"
-	fi
-}
-
-check_ipt_lib_dir()
-{
-	IPT_LIB_DIR=""
-	for dir in /lib /usr/lib /usr/local/lib
-	do
-		for file in $dir/$TABLES/lib*t_*so ; do
-			if [ -f $file ]; then
-				echo $dir/$TABLES
-				echo "IPT_LIB_DIR:=$dir/$TABLES" >> Config
-				return
-			fi
-		done
-	done
-	echo "not found!"
-}
-
-echo "# Generated config based on" $INCLUDE >Config
-
-echo "TC schedulers"
-
-echo -n " ATM	"
-check_atm
-
-echo -n " IPT	"
-check_xt
-check_xt_old
-check_xt_old_internal_h
-check_ipt
-
-echo -n "iptables modules directory: "
-check_ipt_lib_dir
diff --git a/configure.ac b/configure.ac
new file mode 100644
index 0000000..fb854c3
--- /dev/null
+++ b/configure.ac
@@ -0,0 +1,55 @@
+AC_INIT([iproute2], [2.6.36])
+AC_CONFIG_HEADER([config.h])
+AC_CONFIG_MACRO_DIR([m4])
+AM_INIT_AUTOMAKE([-Wall foreign subdir-objects dist-bzip2 1.10])
+
+AC_PROG_CC
+AM_PROG_CC_C_O
+AC_DISABLE_STATIC
+LT_INIT
+AC_PROG_INSTALL
+AC_PROG_MKDIR_P
+AC_PROG_LEX
+AC_PROG_YACC
+
+AC_ARG_WITH([ssbindir], AS_HELP_STRING([--with-ssbindir=PATH],
+	[Path to the super sbin directory [[/sbin]]]),
+	[ssbindir="$withval"], [ssbindir="/sbin"])
+AC_SUBST([ssbindir])
+
+pkgsysconfdir='${sysconfdir}/${PACKAGE_NAME}'
+AC_SUBST([pkgsysconfdir])
+
+regular_CFLAGS='-D_GNU_SOURCE -Wall -Wstrict-prototypes \
+	-I${top_srcdir}/include -DRESOLVE_HOSTNAMES'
+AC_SUBST([regular_CFLAGS])
+
+AC_SEARCH_LIBS([dlopen], [dl], [libdl_LIBS="$LIBS"], [])
+AC_SUBST([libdl_LIBS])
+LIBS=""
+AC_SEARCH_LIBS([gethostbyaddr], [resolv], [libresolv_LIBS="$LIBS"], [])
+AC_SUBST([libresolv_LIBS])
+LIBS=""
+
+AC_CHECK_HEADERS([atm.h], [have_atm=1])
+AC_SEARCH_LIBS([text2qos], [atm], [libatm_LIBS="$LIBS"], [])
+AC_SUBST([libatm_LIBS])
+AM_CONDITIONAL([TC_CONFIG_ATM], [test "$have_atm" = 1])
+LIBS=""
+
+AC_CHECK_HEADERS([db_185.h], [have_db1=1])
+AM_CONDITIONAL([TC_CONFIG_DB1], [test "$have_db1" = 1])
+
+PKG_CHECK_MODULES([xtables], [xtables >= 1.4.5],
+	[have_xtables=1], [have_xtables=0])
+if test "$have_xtables" != 1; then
+	AC_SEARCH_LIBS([exit_error], [xtables],
+		[libxtables_LIBS="-lxtables"; have_xtables_old=1], [])
+	LIBS=""
+fi
+AM_CONDITIONAL([TC_CONFIG_XT], [test "$have_xtables" = 1])
+AM_CONDITIONAL([TC_CONFIG_XT_OLD], [test "$have_xtables_old" = 1])
+
+AC_CONFIG_FILES([Makefile doc/Makefile lib/Makefile ip/Makefile
+	tc/Makefile misc/Makefile netem/Makefile genl/Makefile])
+AC_OUTPUT
diff --git a/doc/Makefile b/doc/Makefile
deleted file mode 100644
index 84836a2..0000000
--- a/doc/Makefile
+++ /dev/null
@@ -1,55 +0,0 @@
-PSFILES=ip-cref.ps ip-tunnels.ps api-ip6-flowlabels.ps ss.ps nstat.ps arpd.ps rtstat.ps
-# tc-cref.ps
-# api-rtnl.tex api-pmtudisc.tex api-news.tex
-# iki-netdev.ps iki-neighdst.ps
-
-
-LATEX=latex
-DVIPS=dvips
-SGML2DVI=sgml2latex --output=dvi
-SGML2HTML=sgml2html -s 0
-LPR=lpr -Zsduplex
-SHELL=bash
-PAGESIZE=a4
-PAGESPERPAGE=2
-
-HTMLFILES=$(subst .sgml,.html,$(shell echo *.sgml))
-DVIFILES=$(subst .ps,.dvi,$(PSFILES))
-
-
-all: pstwocol
-
-pstwocol: $(PSFILES)
-
-html: $(HTMLFILES)
-
-dvi: $(DVIFILES)
-
-print: $(PSFILES)
-	$(LPR) $(PSFILES)
-
-%.dvi: %.sgml
-	$(SGML2DVI) $<
-
-%.dvi: %.tex
-	@set -e; pass=2; echo "Running LaTeX $<"; \
-	while [ `$(LATEX) $< </dev/null 2>&1 | \
-		 grep -c '^\(LaTeX Warning: Label(s) may\|No file \|! Emergency stop\)'` -ge 1 ]; do \
-		if [ $$pass -gt 3 ]; then \
-			echo "Seems, something is wrong. Try by hands." ; exit 1 ; \
-		fi; \
-		echo "Re-running LaTeX $<, $${pass}d pass"; pass=$$[$$pass + 1]; \
-	done
-
-%.ps: %.dvi
-	$(DVIPS) $< -o $@
-
-%.html: %.sgml
-	$(SGML2HTML) $<
-
-install:
-	install -m 0644 $(shell echo *.tex) $(DESTDIR)$(DOCDIR)
-	install -m 0644 $(shell echo *.sgml) $(DESTDIR)$(DOCDIR)
-
-clean:
-	rm -f *.aux *.log *.toc $(PSFILES) $(DVIFILES) *.html
diff --git a/doc/Makefile.am b/doc/Makefile.am
new file mode 100644
index 0000000..adaab4d
--- /dev/null
+++ b/doc/Makefile.am
@@ -0,0 +1,49 @@
+# -*- Makefile -*-
+
+doc_texfiles  = api-ip6-flowlabels.tex ip-cref.tex ip-tunnels.tex
+doc_sgmlfiles = arpd.sgml nstat.sgml rtstat.sgml ss.sgml
+doc_DATA      = ${doc_texfiles} ${doc_sgmlfiles}
+
+PSFILES   = $(subst .tex,.ps,${doc_texfiles}) $(subst .sgml,.ps,${doc_sgmlfiles})
+HTMLFILES = $(subst .sgml,.html,${doc_sgmlfiles})
+DVIFILES  = $(subst .ps,.dvi,${PSFILES})
+
+LATEX=latex
+DVIPS=dvips
+SGML2DVI=sgml2latex --output=dvi
+SGML2HTML=sgml2html -s 0
+LPR=lpr -Zsduplex
+SHELL=bash
+PAGESIZE=a4
+PAGESPERPAGE=2
+
+pstwocol: $(PSFILES)
+
+html-local: $(HTMLFILES)
+
+dvi-local: $(DVIFILES)
+
+print: $(PSFILES)
+	$(LPR) $(PSFILES)
+
+%.dvi: %.sgml
+	$(SGML2DVI) $<
+
+%.dvi: %.tex
+	@set -e; pass=2; echo "Running LaTeX $<"; \
+	while [ `$(LATEX) $< </dev/null 2>&1 | \
+		 grep -c '^\(LaTeX Warning: Label(s) may\|No file \|! Emergency stop\)'` -ge 1 ]; do \
+		if [ $$pass -gt 3 ]; then \
+			echo "Seems, something is wrong. Try by hands." ; exit 1 ; \
+		fi; \
+		echo "Re-running LaTeX $<, $${pass}d pass"; pass=$$[$$pass + 1]; \
+	done
+
+%.ps: %.dvi
+	$(DVIPS) $< -o $@
+
+%.html: %.sgml
+	$(SGML2HTML) $<
+
+clean-local:
+	rm -f *.aux *.log *.toc $(PSFILES) $(DVIFILES) *.html
diff --git a/genl/Makefile b/genl/Makefile
deleted file mode 100644
index 44bb83c..0000000
--- a/genl/Makefile
+++ /dev/null
@@ -1,38 +0,0 @@
-GENLOBJ=genl.o
-
-include ../Config
-SHARED_LIBS ?= y
-
-GENLMODULES :=
-GENLMODULES += ctrl.o
-
-GENLOBJ += $(GENLMODULES)
-
-GENLLIB :=
-
-ifeq ($(SHARED_LIBS),y)
-LDFLAGS += -Wl,-export-dynamic
-LDLIBS  += -lm -ldl
-endif
-
-all: genl
-
-genl: $(GENLOBJ) $(LIBNETLINK) $(LIBUTIL) $(GENLLIB)
-
-install: all
-	install -m 0755 genl $(DESTDIR)$(SBINDIR)
-
-clean:
-	rm -f $(GENLOBJ) $(GENLLIB) genl
-
-ifneq ($(SHARED_LIBS),y)
-
-genl: static-syms.o
-static-syms.o: static-syms.h
-static-syms.h: $(wildcard *.c)
-	files="$^" ; \
-	for s in `grep -B 3 '\<dlsym' $$files | sed -n '/snprintf/{s:.*"\([^"]*\)".*:\1:;s:%s::;p}'` ; do \
-		sed -n '/'$$s'[^ ]* =/{s:.* \([^ ]*'$$s'[^ ]*\) .*:extern char \1[] __attribute__((weak)); if (!strcmp(sym, "\1")) return \1;:;p}' $$files ; \
-	done > $@
-
-endif
diff --git a/genl/Makefile.am b/genl/Makefile.am
new file mode 100644
index 0000000..c03855a
--- /dev/null
+++ b/genl/Makefile.am
@@ -0,0 +1,8 @@
+# -*- Makefile -*-
+
+AM_CFLAGS = ${regular_CFLAGS}
+
+sbin_PROGRAMS = genl
+
+genl_SOURCES = genl.c ctrl.c
+genl_LDADD   = ../lib/libnetlink.la ../lib/libutil.la ${libdl_LIBS}
diff --git a/ip/Makefile b/ip/Makefile
deleted file mode 100644
index 2f223ca..0000000
--- a/ip/Makefile
+++ /dev/null
@@ -1,43 +0,0 @@
-IPOBJ=ip.o ipaddress.o ipaddrlabel.o iproute.o iprule.o \
-    rtm_map.o iptunnel.o ip6tunnel.o tunnel.o ipneigh.o ipntable.o iplink.o \
-    ipmaddr.o ipmonitor.o ipmroute.o ipprefix.o iptuntap.o \
-    ipxfrm.o xfrm_state.o xfrm_policy.o xfrm_monitor.o \
-    iplink_vlan.o link_veth.o link_gre.o iplink_can.o \
-    iplink_macvlan.o
-
-RTMONOBJ=rtmon.o
-
-ALLOBJ=$(IPOBJ) $(RTMONOBJ)
-SCRIPTS=ifcfg rtpr routel routef
-TARGETS=ip rtmon
-
-all: $(TARGETS) $(SCRIPTS) $(LIBS)
-
-ip: $(IPOBJ) $(LIBNETLINK) $(LIBUTIL)
-
-rtmon: $(RTMONOBJ) $(LIBNETLINK)
-
-install: all
-	install -m 0755 $(TARGETS) $(DESTDIR)$(SBINDIR)
-	install -m 0755 $(SCRIPTS) $(DESTDIR)$(SBINDIR)
-
-clean:
-	rm -f $(ALLOBJ) $(TARGETS)
-
-SHARED_LIBS ?= y
-ifeq ($(SHARED_LIBS),y)
-
-LDLIBS += -ldl
-LDFLAGS += -Wl,-export-dynamic
-
-else
-
-ip: static-syms.o
-static-syms.o: static-syms.h
-static-syms.h: $(wildcard *.c)
-	files="$^" ; \
-	for s in `grep -B 3 '\<dlsym' $$files | sed -n '/snprintf/{s:.*"\([^"]*\)".*:\1:;s:%s::;p}'` ; do \
-		sed -n '/'$$s'[^ ]* =/{s:.* \([^ ]*'$$s'[^ ]*\) .*:extern char \1[] __attribute__((weak)); if (!strcmp(sym, "\1")) return \1;:;p}' $$files ; \
-	done > $@
-
-endif
diff --git a/ip/Makefile.am b/ip/Makefile.am
new file mode 100644
index 0000000..8a7eae1
--- /dev/null
+++ b/ip/Makefile.am
@@ -0,0 +1,17 @@
+# -*- Makefile -*-
+
+AM_CFLAGS = ${regular_CFLAGS} -DCONFIG_PKGLIBEXECDIR=\"${libexecdir}/tc\"
+
+ssbin_PROGRAMS = ip
+sbin_PROGRAMS  = rtmon
+sbin_SCRIPTS   = ifcfg rtpr routel routef
+
+ip_SOURCES = ip.c ipaddress.c ipaddrlabel.c iproute.c iprule.c rtm_map.c \
+             iptunnel.c ip6tunnel.c tunnel.c ipneigh.c ipntable.c iplink.c \
+             ipmaddr.c ipmonitor.c ipmroute.c ipprefix.c iptuntap.c ipxfrm.c \
+             xfrm_state.c xfrm_policy.c xfrm_monitor.c iplink_vlan.c \
+             link_veth.c link_gre.c iplink_can.c iplink_macvlan.c
+ip_LDADD   = ../lib/libnetlink.la ../lib/libutil.la ${libdl_LIBS}
+
+rtmon_SOURCES = rtmon.c
+rtmon_LDADD   = ../lib/libnetlink.la ../lib/libutil.la
diff --git a/ip/iplink.c b/ip/iplink.c
index cb2c4f5..47578f1 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -27,15 +27,11 @@
 #include <string.h>
 #include <sys/ioctl.h>
 #include <linux/sockios.h>
-
 #include "rt_names.h"
 #include "utils.h"
 #include "ip_common.h"
 
 #define IPLINK_IOCTL_COMPAT	1
-#ifndef LIBDIR
-#define LIBDIR "/usr/lib/"
-#endif
 
 static void usage(void) __attribute__((noreturn));
 static int iplink_have_newlink(void);
@@ -104,7 +100,7 @@ struct link_util *get_link_kind(const char *id)
 		if (strcmp(l->id, id) == 0)
 			return l;
 
-	snprintf(buf, sizeof(buf), LIBDIR "/ip/link_%s.so", id);
+	snprintf(buf, sizeof(buf), CONFIG_PKGLIBEXECDIR "/link_%s.so", id);
 	dlh = dlopen(buf, RTLD_LAZY);
 	if (dlh == NULL) {
 		/* look in current binary, only open once */
diff --git a/lib/Makefile b/lib/Makefile
deleted file mode 100644
index da2f0fc..0000000
--- a/lib/Makefile
+++ /dev/null
@@ -1,19 +0,0 @@
-CFLAGS += -fPIC
-
-UTILOBJ=utils.o rt_names.o ll_types.o ll_proto.o ll_addr.o inet_proto.o
-
-NLOBJ=ll_map.o libnetlink.o
-
-all: libnetlink.a libutil.a
-
-libnetlink.a: $(NLOBJ)
-	$(AR) rcs $@ $(NLOBJ)
-
-libutil.a: $(UTILOBJ) $(ADDLIB)
-	$(AR) rcs $@ $(UTILOBJ) $(ADDLIB)
-
-install:
-
-clean:
-	rm -f $(NLOBJ) $(UTILOBJ) $(ADDLIB) libnetlink.a libutil.a
-
diff --git a/lib/Makefile.am b/lib/Makefile.am
new file mode 100644
index 0000000..a054d78
--- /dev/null
+++ b/lib/Makefile.am
@@ -0,0 +1,13 @@
+# -*- Makefile -*-
+
+AM_CFLAGS = ${regular_CFLAGS} -DCONFIG_PKGSYSCONFDIR=\"${pkgsysconfdir}\"
+
+noinst_LTLIBRARIES = libnetlink.la libutil.la
+
+libnetlink_la_SOURCES = ll_map.c libnetlink.c
+
+libutil_la_SOURCES = utils.c rt_names.c ll_types.c ll_proto.c \
+                     ll_addr.c inet_proto.c \
+                     dnet_ntop.c dnet_pton.c \
+                     ipx_ntop.c ipx_pton.c
+libutil_la_LIBADD  = ${libresolv_LIBS}
diff --git a/lib/rt_names.c b/lib/rt_names.c
index 52edfe3..4e0c164 100644
--- a/lib/rt_names.c
+++ b/lib/rt_names.c
@@ -127,7 +127,7 @@ static int rtnl_rtprot_init;
 static void rtnl_rtprot_initialize(void)
 {
 	rtnl_rtprot_init = 1;
-	rtnl_tab_initialize("/etc/iproute2/rt_protos",
+	rtnl_tab_initialize(CONFIG_PKGSYSCONFDIR "/rt_protos",
 			    rtnl_rtprot_tab, 256);
 }
 
@@ -194,7 +194,7 @@ static void rtnl_rtscope_initialize(void)
 	rtnl_rtscope_tab[254] = "host";
 	rtnl_rtscope_tab[253] = "link";
 	rtnl_rtscope_tab[200] = "site";
-	rtnl_tab_initialize("/etc/iproute2/rt_scopes",
+	rtnl_tab_initialize(CONFIG_PKGSYSCONFDIR "/rt_scopes",
 			    rtnl_rtscope_tab, 256);
 }
 
@@ -257,7 +257,7 @@ static int rtnl_rtrealm_init;
 static void rtnl_rtrealm_initialize(void)
 {
 	rtnl_rtrealm_init = 1;
-	rtnl_tab_initialize("/etc/iproute2/rt_realms",
+	rtnl_tab_initialize(CONFIG_PKGSYSCONFDIR "/rt_realms",
 			    rtnl_rtrealm_tab, 256);
 }
 
@@ -326,7 +326,7 @@ static int rtnl_rttable_init;
 static void rtnl_rttable_initialize(void)
 {
 	rtnl_rttable_init = 1;
-	rtnl_hash_initialize("/etc/iproute2/rt_tables",
+	rtnl_hash_initialize(CONFIG_PKGSYSCONFDIR "/rt_tables",
 			     rtnl_rttable_hash, 256);
 }
 
@@ -394,7 +394,7 @@ static int rtnl_rtdsfield_init;
 static void rtnl_rtdsfield_initialize(void)
 {
 	rtnl_rtdsfield_init = 1;
-	rtnl_tab_initialize("/etc/iproute2/rt_dsfield",
+	rtnl_tab_initialize(CONFIG_PKGSYSCONFDIR "/rt_dsfield",
 			    rtnl_rtdsfield_tab, 256);
 }
 
diff --git a/m4/.gitignore b/m4/.gitignore
new file mode 100644
index 0000000..64d9bbc
--- /dev/null
+++ b/m4/.gitignore
@@ -0,0 +1,2 @@
+/libtool.m4
+/lt*.m4
diff --git a/misc/.gitignore b/misc/.gitignore
index f73f7f2..6045527 100644
--- a/misc/.gitignore
+++ b/misc/.gitignore
@@ -1,7 +1,9 @@
-arpd
-ifstat
-ss
-ssfilter.c
-nstat
-lnstat
-rtacct
+/ssfilter.c
+/ssfilter.output
+
+/arpd
+/ifstat
+/ss
+/nstat
+/lnstat
+/rtacct
diff --git a/misc/Makefile b/misc/Makefile
deleted file mode 100644
index 8c25381..0000000
--- a/misc/Makefile
+++ /dev/null
@@ -1,35 +0,0 @@
-SSOBJ=ss.o ssfilter.o
-LNSTATOBJ=lnstat.o lnstat_util.o
-
-TARGETS=ss nstat ifstat rtacct arpd lnstat
-
-include ../Config
-
-all: $(TARGETS)
-
-ss: $(SSOBJ) $(LIBUTIL)
-
-nstat: nstat.c
-	$(CC) $(CFLAGS) $(LDFLAGS) -o nstat nstat.c -lm
-
-ifstat: ifstat.c
-	$(CC) $(CFLAGS) $(LDFLAGS) -o ifstat ifstat.c $(LIBNETLINK) -lm
-
-rtacct: rtacct.c
-	$(CC) $(CFLAGS) $(LDFLAGS) -o rtacct rtacct.c $(LIBNETLINK) -lm
-
-arpd: arpd.c
-	$(CC) $(CFLAGS) -I$(DBM_INCLUDE) $(LDFLAGS) -o arpd arpd.c $(LIBNETLINK) -ldb -lpthread
-
-ssfilter.c: ssfilter.y
-	bison ssfilter.y -o ssfilter.c
-
-lnstat: $(LNSTATOBJ)
-
-install: all
-	install -m 0755 $(TARGETS) $(DESTDIR)$(SBINDIR)
-	ln -sf lnstat $(DESTDIR)$(SBINDIR)/rtstat
-	ln -sf lnstat $(DESTDIR)$(SBINDIR)/ctstat
-
-clean:
-	rm -f *.o $(TARGETS) ssfilter.c
diff --git a/misc/Makefile.am b/misc/Makefile.am
new file mode 100644
index 0000000..81cbc24
--- /dev/null
+++ b/misc/Makefile.am
@@ -0,0 +1,19 @@
+# -*- Makefile -*-
+
+AM_CFLAGS = ${regular_CFLAGS}
+
+sbin_PROGRAMS = ss nstat ifstat rtacct lnstat
+
+ss_SOURCES = ss.c ssfilter.y
+ss_LDADD   = ../lib/libnetlink.la ../lib/libutil.la
+
+nstat_LDADD  = -lm
+ifstat_LDADD = ../lib/libnetlink.la -lm
+rtacct_LDADD = ../lib/libnetlink.la ../lib/libutil.la -lm
+
+lnstat_SOURCES = lnstat.c lnstat_util.c
+
+if TC_CONFIG_DB1
+sbin_PROGRAMS += arpd
+arpd_LDADD = ../lib/libnetlink.la ../lib/libutil.la -ldb
+endif
diff --git a/netem/.gitignore b/netem/.gitignore
index e36f396..2cbdc38 100644
--- a/netem/.gitignore
+++ b/netem/.gitignore
@@ -1,5 +1,6 @@
-*.dist
-maketable
-normal
-pareto
-paretonormal
+/*.dist
+/maketable
+/normal
+/pareto
+/paretonormal
+/stats
diff --git a/netem/Makefile b/netem/Makefile
deleted file mode 100644
index e52e125..0000000
--- a/netem/Makefile
+++ /dev/null
@@ -1,29 +0,0 @@
-DISTGEN = maketable normal pareto paretonormal
-DISTDATA = normal.dist pareto.dist paretonormal.dist experimental.dist
-
-HOSTCC ?= $(CC)
-CCOPTS  = $(CBUILD_CFLAGS)
-LDLIBS += -lm 
-
-all: $(DISTGEN) $(DISTDATA)
-
-$(DISTGEN):
-	$(HOSTCC) $(CCOPTS) -I../include -o $@ $@.c -lm
-
-%.dist: %
-	./$* > $@
-
-experimental.dist: maketable experimental.dat
-	./maketable experimental.dat > experimental.dist
-
-stats: stats.c
-	$(HOSTCC) $(CCOPTS) -I../include -o $@ $@.c -lm
-
-install: all
-	mkdir -p $(DESTDIR)$(LIBDIR)/tc
-	for i in $(DISTDATA); \
-	do install -m 644 $$i $(DESTDIR)$(LIBDIR)/tc; \
-	done
-
-clean:
-	rm -f $(DISTDATA) $(DISTGEN)
diff --git a/netem/Makefile.am b/netem/Makefile.am
new file mode 100644
index 0000000..316861d
--- /dev/null
+++ b/netem/Makefile.am
@@ -0,0 +1,23 @@
+# -*- Makefile -*-
+
+pkgdata_DATA    = normal.dist pareto.dist paretonormal.dist experimental.dist
+noinst_PROGRAMS = maketable normal pareto paretonormal stats
+CLEANFILES      = ${pkgdata_DATA}
+
+maketable_LDADD    = -lm
+normal_LDADD       = -lm
+pareto_LDADD       = -lm
+paretonormal_LDADD = -lm
+stats_LDADD        = -lm
+
+normal.dist: normal
+	./normal >$@
+
+pareto.dist: pareto
+	./pareto >$@
+
+paretonormal.dist: paretonormal
+	./paretonormal >$@
+
+experimental.dist: maketable experimental.dat
+	./maketable experimental.dat >$@
diff --git a/tc/.gitignore b/tc/.gitignore
index e8e86c9..05d0928 100644
--- a/tc/.gitignore
+++ b/tc/.gitignore
@@ -1,5 +1,6 @@
-*.yacc.c
-*.lex.c
-*.output
-*.yacc.h
-tc
+/emp_ematch_lex.c
+/emp_ematch_yacc.c
+/emp_ematch_yacc.h
+/emp_ematch_yacc.output
+
+/tc
diff --git a/tc/Makefile b/tc/Makefile
deleted file mode 100644
index 3aa9f26..0000000
--- a/tc/Makefile
+++ /dev/null
@@ -1,144 +0,0 @@
-TCOBJ= tc.o tc_qdisc.o tc_class.o tc_filter.o tc_util.o \
-       tc_monitor.o m_police.o m_estimator.o m_action.o \
-       m_ematch.o emp_ematch.yacc.o emp_ematch.lex.o
-
-include ../Config
-SHARED_LIBS ?= y
-
-TCMODULES :=
-TCMODULES += q_fifo.o
-TCMODULES += q_sfq.o
-TCMODULES += q_red.o
-TCMODULES += q_prio.o
-TCMODULES += q_tbf.o
-TCMODULES += q_cbq.o
-TCMODULES += q_rr.o
-TCMODULES += q_multiq.o
-TCMODULES += q_netem.o
-TCMODULES += f_rsvp.o
-TCMODULES += f_u32.o
-TCMODULES += f_route.o
-TCMODULES += f_fw.o
-TCMODULES += f_basic.o
-TCMODULES += f_flow.o
-TCMODULES += f_cgroup.o
-TCMODULES += q_dsmark.o
-TCMODULES += q_gred.o
-TCMODULES += f_tcindex.o
-TCMODULES += q_ingress.o
-TCMODULES += q_hfsc.o
-TCMODULES += q_htb.o
-TCMODULES += q_drr.o
-TCMODULES += m_gact.o
-TCMODULES += m_mirred.o
-TCMODULES += m_nat.o
-TCMODULES += m_pedit.o
-TCMODULES += m_skbedit.o
-TCMODULES += p_ip.o
-TCMODULES += p_icmp.o
-TCMODULES += p_tcp.o
-TCMODULES += p_udp.o
-TCMODULES += em_nbyte.o
-TCMODULES += em_cmp.o
-TCMODULES += em_u32.o
-TCMODULES += em_meta.o
-
-TCSO :=
-ifeq ($(TC_CONFIG_ATM),y)
-  TCSO += q_atm.so
-endif
-
-ifeq ($(TC_CONFIG_XT),y)
-  TCSO += m_xt.so
-else
-  ifeq ($(TC_CONFIG_XT_OLD),y)
-    TCSO += m_xt_old.so
-  else
-    ifeq ($(TC_CONFIG_XT_OLD_H),y)
-	CFLAGS += -DTC_CONFIG_XT_H
-	TCSO += m_xt_old.so
-    else
-      TCMODULES += m_ipt.o
-    endif
-  endif
-endif
-
-TCOBJ += $(TCMODULES)
-LDLIBS += -L. -ltc -lm
-
-ifeq ($(SHARED_LIBS),y)
-LDLIBS += -ldl
-LDFLAGS += -Wl,-export-dynamic
-endif
-
-TCLIB := tc_core.o
-TCLIB += tc_red.o
-TCLIB += tc_cbq.o
-TCLIB += tc_estimator.o
-TCLIB += tc_stab.o
-
-CFLAGS += -DCONFIG_GACT -DCONFIG_GACT_PROB
-ifneq ($(IPT_LIB_DIR),)
-	CFLAGS += -DIPT_LIB_DIR=\"$(IPT_LIB_DIR)\"
-endif
-
-YACC := bison
-LEX := flex
-
-MODDESTDIR := $(DESTDIR)$(patsubst /usr%,%,$(LIBDIR))/tc
-
-%.so: %.c
-	$(CC) $(CFLAGS) $(LDFLAGS) -shared -fpic $< -o $@
-
-
-all: libtc.a tc $(TCSO)
-
-tc: $(TCOBJ) $(LIBNETLINK) $(LIBUTIL) $(TCLIB)
-
-libtc.a: $(TCLIB)
-	$(AR) rcs $@ $(TCLIB)
-
-install: all
-	mkdir -p $(MODDESTDIR)
-	install -m 0755 tc $(DESTDIR)$(SBINDIR)
-	for i in $(TCSO); \
-	do install -m 755 $$i $(MODDESTDIR); \
-	done
-	if [ ! -f $(MODDESTDIR)/m_ipt.so ]; then \
-	if [ -f $(MODDESTDIR)/m_xt.so ]; \
-		then ln -s m_xt.so $(MODDESTDIR)/m_ipt.so ; \
-	elif [ -f $(MODDESTDIR)/m_xt_old.so ]; \
-		then ln -s m_xt_old.so $(MODDESTDIR)/m_ipt.so ; \
-	fi; \
-	fi
-
-clean:
-	rm -f $(TCOBJ) $(TCLIB) libtc.a tc *.so emp_ematch.yacc.h; \
-	rm -f emp_ematch.yacc.output
-
-q_atm.so: q_atm.c
-	$(CC) $(CFLAGS) $(LDFLAGS) -shared -fpic -o q_atm.so q_atm.c -latm
-
-m_xt.so: m_xt.c
-	$(CC) $(CFLAGS) $(LDFLAGS) -shared -fpic -o m_xt.so m_xt.c -lxtables
-
-m_xt_old.so: m_xt_old.c
-	$(CC) $(CFLAGS) $(LDFLAGS) -shared -fpic -o m_xt_old.so m_xt_old.c -lxtables
-
-%.yacc.c: %.y
-	$(YACC) $(YACCFLAGS) -o $@ $<
-
-%.lex.c: %.l
-	$(LEX) $(LEXFLAGS) -o$@ $<
-
-ifneq ($(SHARED_LIBS),y)
-
-tc: static-syms.o
-static-syms.o: static-syms.h
-static-syms.h: $(wildcard *.c)
-	files="$^" ; \
-	for s in `grep -B 3 '\<dlsym' $$files | sed -n '/snprintf/{s:.*"\([^"]*\)".*:\1:;s:%s::;p}'` ; do \
-		sed -n '/'$$s'[^ ]* =/{s:.* \([^ ]*'$$s'[^ ]*\) .*:extern char \1[] __attribute__((weak)); if (!strcmp(sym, "\1")) return \1;:;p}' $$files ; \
-	done > $@
-
-endif
diff --git a/tc/Makefile.am b/tc/Makefile.am
new file mode 100644
index 0000000..3846f1b
--- /dev/null
+++ b/tc/Makefile.am
@@ -0,0 +1,44 @@
+# -*- Makefile -*-
+
+AM_CFLAGS = ${regular_CFLAGS} -DCONFIG_GACT -DCONFIG_GACT_PROB \
+            -DCONFIG_PKGLIBEXECDIR=\"${libexecdir}/tc\" \
+            -DCONFIG_PKGDATADIR=\"${pkgdatadir}\"
+AM_YFLAGS = -d -t -v
+AM_LFLAGS = -o lex.yy.c
+
+tclibexecdir = ${libexecdir}/tc
+
+noinst_LTLIBRARIES = libtc.la
+sbin_PROGRAMS = tc
+
+libtc_la_SOURCES = tc_core.c tc_red.c tc_cbq.c tc_estimator.c tc_stab.c
+
+tc_SOURCES = tc.c tc_qdisc.c tc_class.c tc_filter.c tc_util.c tc_monitor.c \
+             m_police.c m_estimator.c m_action.c m_ematch.c \
+             emp_ematch_yacc.y emp_ematch_lex.l \
+             q_fifo.c q_sfq.c q_red.c q_prio.c q_tbf.c q_cbq.c q_rr.c \
+             q_multiq.c q_netem.c f_rsvp.c f_u32.c f_route.c f_fw.c f_basic.c \
+             f_flow.c f_cgroup.c q_dsmark.c q_gred.c f_tcindex.c q_ingress.c \
+             q_hfsc.c q_htb.c q_drr.c m_gact.c m_mirred.c m_nat.c m_pedit.c \
+             m_skbedit.c p_ip.c p_icmp.c p_tcp.c p_udp.c em_nbyte.c em_cmp.c \
+             em_u32.c em_meta.c
+tc_LDADD   = libtc.la ../lib/libnetlink.la ../lib/libutil.la ${libdl_LIBS} -lm
+
+tclibexec_LTLIBRARIES = m_ipt.la
+m_ipt_la_LDFLAGS = -avoid-version -module
+
+if TC_CONFIG_XT
+tclibexec_LTLIBRARIES += m_xt.la
+m_xt_la_LDFLAGS = -avoid-version -module
+else
+if TC_CONFIG_XT_OLD
+tclibexec_LTLIBRARIES += m_xt_old.la
+m_xt_old_la_LDFLAGS = -avoid-version -module
+endif
+endif
+
+if TC_CONFIG_ATM
+tclibexec_LTLIBRARIES += q_atm.la
+q_atm_la_LDFLAGS = -avoid-version -module
+q_atm_la_LIBADD  = ${libatm_LIBS}
+endif
diff --git a/tc/emp_ematch.l b/tc/emp_ematch.l
deleted file mode 100644
index d9b45be..0000000
--- a/tc/emp_ematch.l
+++ /dev/null
@@ -1,145 +0,0 @@
-%{
- #include "emp_ematch.yacc.h"
- #include "m_ematch.h"
-
- extern int ematch_argc;
- extern char **ematch_argv;
-
- #define yylval ematch_lval
-
- #define NEXT_EM_ARG() do { ematch_argc--; ematch_argv++; } while(0);
-
- #define YY_INPUT(buf, result, max_size)				\
- {									\
- next:									\
- 	if (ematch_argc <= 0)						\
-		result = YY_NULL;					\
-	else if (**ematch_argv == '\0') {				\
-		NEXT_EM_ARG();						\
-		goto next;						\
-	} else {							\
-		if (max_size <= strlen(*ematch_argv) + 1) {		\
-			fprintf(stderr, "match argument too long.\n");	\
-			result = YY_NULL;				\
-		} else {						\
-			strcpy(buf, *ematch_argv);			\
-			result = strlen(*ematch_argv) + 1;		\
-			buf[result-1] = ' ';				\
-			buf[result] = '\0';				\
-			NEXT_EM_ARG();					\
-		}							\
-	}								\
- }
-
- static void __attribute__ ((unused)) yyunput (int c,char *buf_ptr  );
- static void __attribute__ ((unused)) yy_push_state (int  new_state );
- static void __attribute__ ((unused)) yy_pop_state  (void);
- static int  __attribute__ ((unused)) yy_top_state (void );
-
- static char *strbuf;
- static unsigned int strbuf_size;
- static unsigned int strbuf_index;
-
- static void strbuf_enlarge(void)
- {
- 	strbuf_size += 512;
- 	strbuf = realloc(strbuf, strbuf_size);
- }
-
- static void strbuf_append_char(char c)
- {
- 	while (strbuf_index >= strbuf_size)
- 		strbuf_enlarge();
- 	strbuf[strbuf_index++] = c;
- }
-
- static void strbuf_append_charp(char *s)
- {
- 	while (strbuf_index >= strbuf_size)
- 		strbuf_enlarge();
- 	memcpy(strbuf + strbuf_index, s, strlen(s));
- 	strbuf_index += strlen(s);
- }
-
-%}
-
-%x lexstr
-
-%option 8bit stack warn noyywrap prefix="ematch_"
-%%
-[ \t\r\n]+
-
-\"					{
-						if (strbuf == NULL) {
-							strbuf_size = 512;
-							strbuf = calloc(1, strbuf_size);
-							if (strbuf == NULL)
-								return ERROR;
-						}
-						strbuf_index = 0;
-
-						BEGIN(lexstr);
-					}
-
-<lexstr>\"					{
-						BEGIN(INITIAL);
-						yylval.b = bstr_new(strbuf, strbuf_index);
-						yylval.b->quoted = 1;
-						return ATTRIBUTE;
-					}
-
-<lexstr>\\[0-7]{1,3}			{ /* octal escape sequence */
-						int res;
-
-						sscanf(yytext + 1, "%o", &res);
-						if (res > 0xFF) {
-							fprintf(stderr, "error: octal escape sequence" \
-							" out of range\n");
-							return ERROR;
-						}
-						strbuf_append_char((unsigned char) res);
-					}
-
-<lexstr>\\[0-9]+				{ /* catch wrong octal escape seq. */
-						fprintf(stderr, "error: invalid octale escape sequence\n");
-						return ERROR;
-					}
-
-<lexstr>\\x[0-9a-fA-F]{1,2}		{
-						int res;
-
-						sscanf(yytext + 2, "%x", &res);
-
-						if (res > 0xFF) {
-							fprintf(stderr, "error: hexadecimal escape " \
-							"sequence out of range\n");
-							return ERROR;
-						}
-						strbuf_append_char((unsigned char) res);
-					}
-
-<lexstr>\\n				strbuf_append_char('\n');
-<lexstr>\\r				strbuf_append_char('\r');
-<lexstr>\\t				strbuf_append_char('\t');
-<lexstr>\\v				strbuf_append_char('\v');
-<lexstr>\\b				strbuf_append_char('\b');
-<lexstr>\\f				strbuf_append_char('\f');
-<lexstr>\\a				strbuf_append_char('\a');
-
-<lexstr>\\(.|\n)			strbuf_append_char(yytext[1]);
-<lexstr>[^\\\n\"]+			strbuf_append_charp(yytext);
-
-[aA][nN][dD]				return AND;
-[oO][rR]				return OR;
-[nN][oO][tT]				return NOT;
-"("					|
-")"					{
-						return yylval.i = *yytext;
-					}
-[^ \t\r\n()]+				{
-						yylval.b = bstr_alloc(yytext);
-						if (yylval.b == NULL)
-							return ERROR;
-						return ATTRIBUTE;
-					}
-%%
diff --git a/tc/emp_ematch.y b/tc/emp_ematch.y
deleted file mode 100644
index e8d1671..0000000
--- a/tc/emp_ematch.y
+++ /dev/null
@@ -1,101 +0,0 @@
-%{
- #include <stdio.h>
- #include <stdlib.h>
- #include <malloc.h>
- #include <string.h>
- #include "m_ematch.h"
-%}
-
-%locations
-%token-table
-%error-verbose
-%name-prefix="ematch_"
-
-%union {
-	unsigned int i;
-	struct bstr *b;
-	struct ematch *e;
-}
-
-%{
- extern int ematch_lex(void);
- extern void yyerror(char *s);
- extern struct ematch *ematch_root;
- extern char *ematch_err;
-%}
-
-%token <i> ERROR
-%token <b> ATTRIBUTE
-%token <i> AND OR NOT
-%type <i> invert relation
-%type <e> match expr
-%type <b> args
-%right AND OR
-%start input
-%%
-input:
-	/* empty */
-	| expr
-		{ ematch_root = $1; }
-	| expr error
-		{
-			ematch_root = $1;
-			YYACCEPT;
-		}
-	;
-
-expr:
-	match
-		{ $$ = $1; }
-	| match relation expr
-		{
-			$1->relation = $2;
-			$1->next = $3;
-			$$ = $1;
-		}
-	;
-
-match:
-	invert ATTRIBUTE '(' args ')'
-		{
-			$2->next = $4;
-			$$ = new_ematch($2, $1);
-			if ($$ == NULL)
-				YYABORT;
-		}
-	| invert '(' expr ')'
-		{
-			$$ = new_ematch(NULL, $1);
-			if ($$ == NULL)
-				YYABORT;
-			$$->child = $3;
-		}
-	;
-
-args:
-	ATTRIBUTE
-		{ $$ = $1; }
-	| ATTRIBUTE args
-		{ $1->next = $2; }
-	;
-
-relation:
-	AND
-		{ $$ = TCF_EM_REL_AND; }
-	| OR
-		{ $$ = TCF_EM_REL_OR; }
-	;
-
-invert:
-	/* empty */
-		{ $$ = 0; }
-	| NOT
-		{ $$ = 1; }
-	;
-%%
-
- void yyerror(char *s)
- {
-	 ematch_err = strdup(s);
- }
-
diff --git a/tc/emp_ematch_lex.l b/tc/emp_ematch_lex.l
new file mode 100644
index 0000000..3c38648
--- /dev/null
+++ b/tc/emp_ematch_lex.l
@@ -0,0 +1,145 @@
+%{
+ #include "emp_ematch_yacc.h"
+ #include "m_ematch.h"
+
+ extern int ematch_argc;
+ extern char **ematch_argv;
+
+ #define yylval ematch_lval
+
+ #define NEXT_EM_ARG() do { ematch_argc--; ematch_argv++; } while(0);
+
+ #define YY_INPUT(buf, result, max_size)				\
+ {									\
+ next:									\
+ 	if (ematch_argc <= 0)						\
+		result = YY_NULL;					\
+	else if (**ematch_argv == '\0') {				\
+		NEXT_EM_ARG();						\
+		goto next;						\
+	} else {							\
+		if (max_size <= strlen(*ematch_argv) + 1) {		\
+			fprintf(stderr, "match argument too long.\n");	\
+			result = YY_NULL;				\
+		} else {						\
+			strcpy(buf, *ematch_argv);			\
+			result = strlen(*ematch_argv) + 1;		\
+			buf[result-1] = ' ';				\
+			buf[result] = '\0';				\
+			NEXT_EM_ARG();					\
+		}							\
+	}								\
+ }
+
+ static void __attribute__ ((unused)) yyunput (int c,char *buf_ptr  );
+ static void __attribute__ ((unused)) yy_push_state (int  new_state );
+ static void __attribute__ ((unused)) yy_pop_state  (void);
+ static int  __attribute__ ((unused)) yy_top_state (void );
+
+ static char *strbuf;
+ static unsigned int strbuf_size;
+ static unsigned int strbuf_index;
+
+ static void strbuf_enlarge(void)
+ {
+ 	strbuf_size += 512;
+ 	strbuf = realloc(strbuf, strbuf_size);
+ }
+
+ static void strbuf_append_char(char c)
+ {
+ 	while (strbuf_index >= strbuf_size)
+ 		strbuf_enlarge();
+ 	strbuf[strbuf_index++] = c;
+ }
+
+ static void strbuf_append_charp(char *s)
+ {
+ 	while (strbuf_index >= strbuf_size)
+ 		strbuf_enlarge();
+ 	memcpy(strbuf + strbuf_index, s, strlen(s));
+ 	strbuf_index += strlen(s);
+ }
+
+%}
+
+%x lexstr
+
+%option 8bit stack warn noyywrap prefix="ematch_"
+%%
+[ \t\r\n]+
+
+\"					{
+						if (strbuf == NULL) {
+							strbuf_size = 512;
+							strbuf = calloc(1, strbuf_size);
+							if (strbuf == NULL)
+								return ERROR;
+						}
+						strbuf_index = 0;
+
+						BEGIN(lexstr);
+					}
+
+<lexstr>\"					{
+						BEGIN(INITIAL);
+						yylval.b = bstr_new(strbuf, strbuf_index);
+						yylval.b->quoted = 1;
+						return ATTRIBUTE;
+					}
+
+<lexstr>\\[0-7]{1,3}			{ /* octal escape sequence */
+						int res;
+
+						sscanf(yytext + 1, "%o", &res);
+						if (res > 0xFF) {
+							fprintf(stderr, "error: octal escape sequence" \
+							" out of range\n");
+							return ERROR;
+						}
+						strbuf_append_char((unsigned char) res);
+					}
+
+<lexstr>\\[0-9]+				{ /* catch wrong octal escape seq. */
+						fprintf(stderr, "error: invalid octale escape sequence\n");
+						return ERROR;
+					}
+
+<lexstr>\\x[0-9a-fA-F]{1,2}		{
+						int res;
+
+						sscanf(yytext + 2, "%x", &res);
+
+						if (res > 0xFF) {
+							fprintf(stderr, "error: hexadecimal escape " \
+							"sequence out of range\n");
+							return ERROR;
+						}
+						strbuf_append_char((unsigned char) res);
+					}
+
+<lexstr>\\n				strbuf_append_char('\n');
+<lexstr>\\r				strbuf_append_char('\r');
+<lexstr>\\t				strbuf_append_char('\t');
+<lexstr>\\v				strbuf_append_char('\v');
+<lexstr>\\b				strbuf_append_char('\b');
+<lexstr>\\f				strbuf_append_char('\f');
+<lexstr>\\a				strbuf_append_char('\a');
+
+<lexstr>\\(.|\n)			strbuf_append_char(yytext[1]);
+<lexstr>[^\\\n\"]+			strbuf_append_charp(yytext);
+
+[aA][nN][dD]				return AND;
+[oO][rR]				return OR;
+[nN][oO][tT]				return NOT;
+"("					|
+")"					{
+						return yylval.i = *yytext;
+					}
+[^ \t\r\n()]+				{
+						yylval.b = bstr_alloc(yytext);
+						if (yylval.b == NULL)
+							return ERROR;
+						return ATTRIBUTE;
+					}
+%%
diff --git a/tc/emp_ematch_yacc.y b/tc/emp_ematch_yacc.y
new file mode 100644
index 0000000..e8d1671
--- /dev/null
+++ b/tc/emp_ematch_yacc.y
@@ -0,0 +1,101 @@
+%{
+ #include <stdio.h>
+ #include <stdlib.h>
+ #include <malloc.h>
+ #include <string.h>
+ #include "m_ematch.h"
+%}
+
+%locations
+%token-table
+%error-verbose
+%name-prefix="ematch_"
+
+%union {
+	unsigned int i;
+	struct bstr *b;
+	struct ematch *e;
+}
+
+%{
+ extern int ematch_lex(void);
+ extern void yyerror(char *s);
+ extern struct ematch *ematch_root;
+ extern char *ematch_err;
+%}
+
+%token <i> ERROR
+%token <b> ATTRIBUTE
+%token <i> AND OR NOT
+%type <i> invert relation
+%type <e> match expr
+%type <b> args
+%right AND OR
+%start input
+%%
+input:
+	/* empty */
+	| expr
+		{ ematch_root = $1; }
+	| expr error
+		{
+			ematch_root = $1;
+			YYACCEPT;
+		}
+	;
+
+expr:
+	match
+		{ $$ = $1; }
+	| match relation expr
+		{
+			$1->relation = $2;
+			$1->next = $3;
+			$$ = $1;
+		}
+	;
+
+match:
+	invert ATTRIBUTE '(' args ')'
+		{
+			$2->next = $4;
+			$$ = new_ematch($2, $1);
+			if ($$ == NULL)
+				YYABORT;
+		}
+	| invert '(' expr ')'
+		{
+			$$ = new_ematch(NULL, $1);
+			if ($$ == NULL)
+				YYABORT;
+			$$->child = $3;
+		}
+	;
+
+args:
+	ATTRIBUTE
+		{ $$ = $1; }
+	| ATTRIBUTE args
+		{ $1->next = $2; }
+	;
+
+relation:
+	AND
+		{ $$ = TCF_EM_REL_AND; }
+	| OR
+		{ $$ = TCF_EM_REL_OR; }
+	;
+
+invert:
+	/* empty */
+		{ $$ = 0; }
+	| NOT
+		{ $$ = 1; }
+	;
+%%
+
+ void yyerror(char *s)
+ {
+	 ematch_err = strdup(s);
+ }
+
diff --git a/tc/q_netem.c b/tc/q_netem.c
index 6aaaded..00f8b15 100644
--- a/tc/q_netem.c
+++ b/tc/q_netem.c
@@ -62,7 +62,7 @@ static int get_distribution(const char *type, __s16 *data, int maxdata)
 	char *line = NULL;
 	char name[128];
 
-	snprintf(name, sizeof(name), "%s/%s.dist", get_tc_lib(), type);
+	snprintf(name, sizeof(name), "%s/%s.dist", get_tc_datadir(), type);
 	if ((f = fopen(name, "r")) == NULL) {
 		fprintf(stderr, "No distribution data for %s (%s: %s)\n",
 			type, name, strerror(errno));
diff --git a/tc/tc_util.c b/tc/tc_util.c
index fe2c7eb..f65847b 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -24,21 +24,25 @@
 #include "utils.h"
 #include "tc_util.h"
 
-#ifndef LIBDIR
-#define LIBDIR "/usr/lib/"
-#endif
-
 const char *get_tc_lib(void)
 {
 	const char *lib_dir;
 
 	lib_dir = getenv("TC_LIB_DIR");
 	if (!lib_dir)
-		lib_dir = LIBDIR "/tc/";
+		lib_dir = CONFIG_PKGLIBEXECDIR;
 
 	return lib_dir;
 }
 
+const char *get_tc_datadir(void)
+{
+	const char *d;
+
+	d = getenv("TC_DATA_DIR");
+	return (d != NULL) ? d : CONFIG_PKGDATADIR;
+}
+
 int get_qdisc_handle(__u32 *h, const char *str)
 {
 	__u32 maj;
diff --git a/tc/tc_util.h b/tc/tc_util.h
index d84b09a..186b299 100644
--- a/tc/tc_util.h
+++ b/tc/tc_util.h
@@ -52,6 +52,7 @@ struct action_util
 };
 
 extern const char *get_tc_lib(void);
+extern const char *get_tc_datadir(void);
 
 extern struct qdisc_util *get_qdisc_kind(const char *str);
 extern struct filter_util *get_filter_kind(const char *str);
-- 
1.7.1

