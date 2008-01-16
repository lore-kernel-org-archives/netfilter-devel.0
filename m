From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [01/19] use automake
Date: Wed, 16 Jan 2008 14:48:08 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801161446580.4953@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48674 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbYAPNsL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Jan 2008 08:48:11 -0500
In-Reply-To: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Converts the iptables build infrastructure to autotools.

	- Can build both static and dynamic at the same time

	- iptables-static will be a multi-binary, semi-static
	(link against libc but w/o dynamic plugins)

	- Always build IPv6 modules

	- consider INSTALL

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>


---
Patch instructions:
 create autogen.sh with mode 0755

 INSTALL                         |   47 +++---
 Makefile                        |  272 ----------------------------------
 Makefile.am                     |   92 +++++++++++
 Rules.make                      |   58 -------
 autogen.sh                      |    4 
 configure.ac                    |   55 +++++++
 extensions/.condition-test      |    5 
 extensions/.condition-test6     |    5 
 extensions/.set-test            |    4 
 extensions/GNUmakefile.in       |  204 ++++++++++++++++++++++++++
 extensions/Makefile             |  311 ----------------------------------------
 extensions/dscp_helper.c        |   81 ++++++++++
 extensions/libipt_dscp_helper.c |   81 ----------
 extensions/libxt_DSCP.c         |    2 
 extensions/libxt_dscp.c         |    2 
 include/xtables.h               |   13 -
 libipq/Makefile                 |   28 ---
 libipq/Makefile.am              |   11 +
 18 files changed, 491 insertions(+), 784 deletions(-)

Index: iptables-modules/INSTALL
===================================================================
--- iptables-modules.orig/INSTALL
+++ iptables-modules/INSTALL
@@ -5,15 +5,21 @@ FOLLOW THESE STEPS:
    in a seperate package, called patch-o-matic.  It is available from
    ftp://ftp.netfilter.org/pub/patch-o-matic/
 
-1) Next, make the package.
-	% make KERNEL_DIR=<<where-you-built-your-kernel>>
+1) Next, make the package. If you use a standard distribution kernel,
+   just run ./configure.
 
-2) Finally, you need to to install the shared libraries, and the binary:
-	# make install KERNEL_DIR=<<where-you-built-your-kernel>>
+   If you want to build against an own kernel tree:
 
-If you are a developer, you can install the headers, development libraries
-and associated development man pages, with:
-	# make install-devel
+	$ ./configure --with-kernel=/home/jengelh/mykernel
+
+   or whereever you put it. If you are using a dedicated kernel build
+   directory, you use:
+
+	$ ./configure --with-kbuild=<<where-built>> --with-ksource=<<source>>
+
+2) Finally, you need to install the binaries and shared libraries:
+
+	# make install
 
 That's it!
 ================================================================
@@ -21,27 +27,26 @@ PROBLEMS YOU MAY ENCOUNTER:
 
 1) This package requires a 2.4.4 kernel, or above.
 
-2) If you get the kernel directory wrong, you may see a message like:
-	Please try `make KERNEL_DIR=path-to-correct-kernel'
+2) If you get the kernel directory wrong, you may get compile failures.
 
 3) If you want to specify alternate directories for installation
 (instead of /usr/local/ bin lib man), do this:
 
-	% make BINDIR=/usr/bin LIBDIR=/usr/lib MANDIR=/usr/man
-	# make BINDIR=/usr/bin LIBDIR=/usr/lib MANDIR=/usr/man install
+	$ ./configure --prefix=/usr
+	$ make
+	# make install
+
+4) The make process will automatically build a multipurpose binary under the
+   names iptables-multi and ip6tables-multi.
 
-4) If you want to build a statically linked version of the iptables binary,
+5) If you want to build a statically linked version of the iptables binary,
    without the need for loading the plugins at runtime (e.g. for an embedded
    device or router-on-a-disk), please use
 
-	% make NO_SHARED_LIBS=1
-
-5) If you want to build a single BusyBox style multipurpose binary instead of
-   the individual iptables, iptables-save and iptables-restore binaries, then
-   please use
+	$ ./configure --enable-static
 
-	% make DO_MULTI=1
+   which will build both a semi-static multi binary (iptables-mtss, uses
+   libc but not plugins) and a fully static multi binary (iptables-static).
 
-NOTE: make sure you build with at least the correct LIBDIR=
-specification, otherwise iptables(8) won't know where to find the
-dynamic objects.
+6) If you want to install libipq (old interface), add --enable-devel to
+   ./configure.
Index: iptables-modules/Makefile
===================================================================
--- iptables-modules.orig/Makefile
+++ /dev/null
@@ -1,272 +0,0 @@
-# uncomment this to get a fully statically linked version
-# NO_SHARED_LIBS = 1
-
-# uncomment this to disable IPv6 support
-# DO_IPV6 = 0
-
-######################################################################
-# YOU SHOULD NOT NEED TO TOUCH ANYTHING BELOW THIS LINE
-######################################################################
-
-# Standard part of Makefile for topdir.
-TOPLEVEL_INCLUDED=YES
-
-# For recent kernels we only need the source in KERNEL_DIR to build. Older
-# kernels have a bug, where linux/netfilter_ipv4.h includes linux/config.h,
-# which includes linux/autoconf.h, which is placed into KBUILD_OUTPUT.
-ifndef KERNEL_DIR
-KERNEL_DIR="/lib/modules/$(shell uname -r)/source"
-endif
-ifndef KBUILD_OUTPUT
-KBUILD_OUTPUT="/lib/modules/$(shell uname -r)/build"
-endif
-IPTABLES_VERSION:=1.4.0
-OLD_IPTABLES_VERSION:=1.4.0rc1
-
-PREFIX:=/usr/local
-LIBDIR:=$(PREFIX)/lib
-BINDIR:=$(PREFIX)/sbin
-MANDIR:=$(PREFIX)/man
-INCDIR:=$(PREFIX)/include
-
-# directory for new iptables releases
-RELEASE_DIR:=/tmp
-
-# Need libc6 for this.  FIXME: Should covert to autoconf.
-ifeq ($(shell [ -f /usr/include/netinet/ip6.h ] && echo YES), YES)
-DO_IPV6:=1
-endif
-
-# Enable linking to libselinux via enviornment 'DO_SELINUX=1'
-ifndef DO_SELINUX
-DO_SELINUX=0
-endif
-
-COPT_FLAGS:=-O2
-CFLAGS:=$(COPT_FLAGS) -Wall -Wunused -I$(KBUILD_OUTPUT)/include -I$(KERNEL_DIR)/include -Iinclude/ -DIPTABLES_VERSION=\"$(IPTABLES_VERSION)\" #-g -DDEBUG #-pg # -DIPTC_DEBUG
-
-ifdef NO_SHARED_LIBS
-CFLAGS += -DNO_SHARED_LIBS=1
-endif
-
-EXTRAS+=iptables iptables.o iptables.8
-EXTRA_INSTALLS+=$(DESTDIR)$(BINDIR)/iptables $(DESTDIR)$(MANDIR)/man8/iptables.8
-
-# No longer experimental.
-ifneq ($(DO_MULTI), 1)
-EXTRAS+=iptables-save iptables-restore iptables-xml
-endif
-EXTRA_INSTALLS+=$(DESTDIR)$(BINDIR)/iptables-save $(DESTDIR)$(BINDIR)/iptables-restore $(DESTDIR)$(BINDIR)/iptables-xml $(DESTDIR)$(MANDIR)/man8/iptables-restore.8 $(DESTDIR)$(MANDIR)/man8/iptables-save.8
-
-ifeq ($(DO_IPV6), 1)
-EXTRAS+=ip6tables ip6tables.o ip6tables.8
-EXTRA_INSTALLS+=$(DESTDIR)$(BINDIR)/ip6tables $(DESTDIR)$(MANDIR)/man8/ip6tables.8
-
-ifneq ($(DO_MULTI), 1)
-EXTRAS+=ip6tables-save ip6tables-restore
-endif
-EXTRA_INSTALLS+=$(DESTDIR)$(BINDIR)/ip6tables-save $(DESTDIR)$(BINDIR)/ip6tables-restore $(DESTDIR)$(MANDIR)/man8/ip6tables-save.8 $(DESTDIR)$(MANDIR)/man8/ip6tables-restore.8
-endif
-
-ifndef IPT_LIBDIR
-IPT_LIBDIR:=$(LIBDIR)/iptables
-endif
-DEST_IPT_LIBDIR:=$(DESTDIR)$(LIBDIR)/iptables
-
-ifndef NO_SHARED_LIBS
-DEPFILES = $(SHARED_LIBS:%.so=%.d)
-DEPFILES += $(SHARED_SE_LIBS:%.so=%.d)
-SH_CFLAGS:=$(CFLAGS) -fPIC
-STATIC_LIBS  =
-STATIC6_LIBS =
-LDFLAGS      = -rdynamic
-LDLIBS       = -ldl -lm
-ifeq ($(DO_SELINUX), 1)
-LDLIBS       += -lselinux
-endif
-else
-DEPFILES = $(EXT_OBJS:%.o=%.d)
-STATIC_LIBS  = extensions/libext.a
-STATIC6_LIBS = extensions/libext6.a
-LDFLAGS      = -static
-LDLIBS	     = -lm
-ifeq ($(DO_SELINUX), 1)
-LDLIBS       += -lselinux
-endif
-endif
-
-.PHONY: default
-default: print-extensions all
-
-.PHONY: print-extensions
-print-extensions:
-	@[ -n "$(OPTIONALS)" ] && echo Extensions found: $(OPTIONALS)
-
-iptables.o: iptables.c
-	$(CC) $(CFLAGS) -DIPT_LIB_DIR=\"$(IPT_LIBDIR)\" -c -o $@ $<
-
-ifeq ($(DO_MULTI), 1)
-iptables: iptables-multi.c iptables-save.c iptables-restore.c iptables-xml.c iptables-standalone.c iptables.o xtables.o $(STATIC_LIBS) libiptc/libiptc.a
-	$(CC) $(CFLAGS) -DIPTABLES_MULTI -DIPT_LIB_DIR=\"$(IPT_LIBDIR)\" $(LDFLAGS) -o $@ $^ $(LDLIBS)
-else
-iptables: iptables-standalone.c iptables.o xtables.o $(STATIC_LIBS) libiptc/libiptc.a
-	$(CC) $(CFLAGS) -DIPT_LIB_DIR=\"$(IPT_LIBDIR)\" $(LDFLAGS) -o $@ $^ $(LDLIBS)
-endif
-
-$(DESTDIR)$(BINDIR)/iptables: iptables
-	@[ -d $(DESTDIR)$(BINDIR) ] || mkdir -p $(DESTDIR)$(BINDIR)
-	cp $< $@
-
-iptables-save: iptables-save.c iptables.o xtables.o $(STATIC_LIBS) libiptc/libiptc.a
-	$(CC) $(CFLAGS) -DIPT_LIB_DIR=\"$(IPT_LIBDIR)\" $(LDFLAGS) -o $@ $^ $(LDLIBS)
-
-ifeq ($(DO_MULTI), 1)
-$(DESTDIR)$(BINDIR)/iptables-save: iptables
-	@[ -d $(DESTDIR)$(BINDIR) ] || mkdir -p $(DESTDIR)$(BINDIR)
-	ln -sf $< $@
-else
-$(DESTDIR)$(BINDIR)/iptables-save: iptables-save
-	@[ -d $(DESTDIR)$(BINDIR) ] || mkdir -p $(DESTDIR)$(BINDIR)
-	cp $< $@
-endif
-
-iptables-restore: iptables-restore.c iptables.o xtables.o $(STATIC_LIBS) libiptc/libiptc.a
-	$(CC) $(CFLAGS) -DIPT_LIB_DIR=\"$(IPT_LIBDIR)\" $(LDFLAGS) -o $@ $^ $(LDLIBS)
-
-ifeq ($(DO_MULTI), 1)
-$(DESTDIR)$(BINDIR)/iptables-restore: iptables
-	@[ -d $(DESTDIR)$(BINDIR) ] || mkdir -p $(DESTDIR)$(BINDIR)
-	ln -sf $< $@
-else
-$(DESTDIR)$(BINDIR)/iptables-restore: iptables-restore
-	@[ -d $(DESTDIR)$(BINDIR) ] || mkdir -p $(DESTDIR)$(BINDIR)
-	cp $< $@
-endif
-
-iptables-xml: iptables-xml.c #iptables.o # $(STATIC_LIBS) libiptc/libiptc.a
-	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)
-
-ifeq ($(DO_MULTI), 1)
-$(DESTDIR)$(BINDIR)/iptables-xml: iptables
-	@[ -d $(DESTDIR)$(BINDIR) ] || mkdir -p $(DESTDIR)$(BINDIR)
-	ln -sf $< $@
-else
-$(DESTDIR)$(BINDIR)/iptables-xml: iptables-xml
-	@[ -d $(DESTDIR)$(BINDIR) ] || mkdir -p $(DESTDIR)$(BINDIR)
-	cp $< $@
-endif
-
-ip6tables.o: ip6tables.c
-	$(CC) $(CFLAGS) -DIP6T_LIB_DIR=\"$(IPT_LIBDIR)\" -c -o $@ $<
-
-ifeq ($(DO_MULTI), 1)
-ip6tables: ip6tables-multi.c ip6tables-save.c ip6tables-restore.c ip6tables-standalone.c ip6tables.o xtables.o $(STATIC6_LIBS) libiptc/libiptc.a
-	$(CC) $(CFLAGS) -DIPTABLES_MULTI -DIP6T_LIB_DIR=\"$(IPT_LIBDIR)\" $(LDFLAGS) -o $@ $^ $(LDLIBS)
-else
-ip6tables: ip6tables-standalone.c ip6tables.o xtables.o $(STATIC6_LIBS) libiptc/libiptc.a
-	$(CC) $(CFLAGS) -DIP6T_LIB_DIR=\"$(IPT_LIBDIR)\" $(LDFLAGS) -o $@ $^ $(LDLIBS)
-endif
-
-$(DESTDIR)$(BINDIR)/ip6tables: ip6tables
-	@[ -d $(DESTDIR)$(BINDIR) ] || mkdir -p $(DESTDIR)$(BINDIR)
-	cp $< $@
-
-ip6tables-save: ip6tables-save.c ip6tables.o xtables.o $(STATIC6_LIBS) libiptc/libiptc.a
-	$(CC) $(CFLAGS) -DIP6T_LIB_DIR=\"$(IPT_LIBDIR)\" $(LDFLAGS) -o $@ $^ $(LDLIBS)
-
-ifeq ($(DO_MULTI), 1)
-$(DESTDIR)$(BINDIR)/ip6tables-save: ip6tables
-	@[ -d $(DESTDIR)$(BINDIR) ] || mkdir -p $(DESTDIR)$(BINDIR)
-	ln -sf $< $@
-else
-$(DESTDIR)$(BINDIR)/ip6tables-save: ip6tables-save
-	@[ -d $(DESTDIR)$(BINDIR) ] || mkdir -p $(DESTDIR)$(BINDIR)
-	cp $< $@
-endif
-
-ip6tables-restore: ip6tables-restore.c ip6tables.o xtables.o $(STATIC6_LIBS) libiptc/libiptc.a
-	$(CC) $(CFLAGS) -DIP6T_LIB_DIR=\"$(IPT_LIBDIR)\" $(LDFLAGS) -o $@ $^ $(LDLIBS)
-
-ifeq ($(DO_MULTI), 1)
-$(DESTDIR)$(BINDIR)/ip6tables-restore: ip6tables
-	@[ -d $(DESTDIR)$(BINDIR) ] || mkdir -p $(DESTDIR)$(BINDIR)
-	ln -sf $< $@
-else
-$(DESTDIR)$(BINDIR)/ip6tables-restore: ip6tables-restore
-	@[ -d $(DESTDIR)$(BINDIR) ] || mkdir -p $(DESTDIR)$(BINDIR)
-	cp $< $@
-endif
-
-$(DESTDIR)$(MANDIR)/man8/%.8: %.8
-	@[ -d $(DESTDIR)$(MANDIR)/man8 ] || mkdir -p $(DESTDIR)$(MANDIR)/man8
-	cp $< $@
-
-EXTRA_DEPENDS+=iptables-standalone.d iptables.d
-
-iptables-standalone.d iptables.d: %.d: %.c
-	@-$(CC) -M -MG $(CFLAGS) $< | sed -e 's@^.*\.o:@$*.d $*.o:@' > $@
-
-iptables.8: iptables.8.in extensions/libipt_matches.man extensions/libipt_targets.man
-	@sed -e '/@MATCH@/ r extensions/libipt_matches.man' -e '/@TARGET@/ r extensions/libipt_targets.man' iptables.8.in >iptables.8
-
-ip6tables.8: ip6tables.8.in extensions/libip6t_matches.man extensions/libip6t_targets.man
-	@sed -e '/@MATCH@/ r extensions/libip6t_matches.man' -e '/@TARGET@/ r extensions/libip6t_targets.man' ip6tables.8.in >ip6tables.8
-
-# Development Targets
-.PHONY: install-devel-man3
-install-devel-man3: $(DEVEL_MAN3)
-	@[ -d $(DESTDIR)$(MANDIR)/man3 ] || mkdir -p $(DESTDIR)$(MANDIR)/man3
-	@cp -v $(DEVEL_MAN3) $(DESTDIR)$(MANDIR)/man3
-
-.PHONY: install-devel-headers
-install-devel-headers: $(DEVEL_HEADERS)
-	@[ -d $(DESTDIR)$(INCDIR) ] || mkdir -p $(DESTDIR)$(INCDIR)
-	@cp -v $(DEVEL_HEADERS) $(DESTDIR)$(INCDIR)
-
-.PHONY: install-devel-libs
-install-devel-libs: $(DEVEL_LIBS)
-	@[ -d $(DESTDIR)$(LIBDIR) ] || mkdir -p $(DESTDIR)$(LIBDIR)
-	@cp -v $(DEVEL_LIBS) $(DESTDIR)$(LIBDIR)
-
-.PHONY: install-devel
-install-devel: all install-devel-man3 install-devel-headers install-devel-libs
-
-.PHONY: distclean
-distclean: clean
-	@rm -f TAGS `find . -name '*~' -o -name '.*~'` `find . -name '*.rej'` `find . -name '*.d'` .makefirst
-
-# Rusty's distro magic.
-.PHONY: distrib
-distrib: check distclean delrelease $(RELEASE_DIR)/iptables-$(IPTABLES_VERSION).tar.bz2 diff md5sums # nowhitespace
-
-# Makefile must not define:
-# -g -pg -DIPTC_DEBUG
-.PHONY: check
-check:
-	@if echo $(CFLAGS) | egrep -e '(^|[[:space:]])(-g|-pg|-DIPTC_DEBUG)([[:space:]]|$)' >/dev/null; then echo Remove debugging flags; exit 1; else exit 0; fi
-
-.PHONY: nowhitespace
-nowhitespace:
-	@if grep -n '[ 	]$$' `find . -name 'Makefile' -o -name '*.[ch]'`; then exit 1; else exit 0; fi
-
-.PHONY: delrelease
-delrelease:
-	rm -f $(RELEASE_DIR)/iptables-$(IPTABLES_VERSION).tar.bz2
-
-$(RELEASE_DIR)/iptables-$(IPTABLES_VERSION).tar.bz2:
-	cd .. && ln -sf iptables iptables-$(IPTABLES_VERSION) && tar cvf - --exclude .svn iptables-$(IPTABLES_VERSION)/. | bzip2 -9 > $@ && rm iptables-$(IPTABLES_VERSION)
-
-.PHONY: diff
-diff: $(RELEASE_DIR)/iptables-$(IPTABLES_VERSION).tar.bz2
-	@mkdir /tmp/diffdir
-	@cd /tmp/diffdir && tar -x --bzip2 -f $(RELEASE_DIR)/iptables-$(IPTABLES_VERSION).tar.bz2
-	@set -e; cd /tmp/diffdir; tar -x --bzip2 -f $(RELEASE_DIR)/iptables-$(OLD_IPTABLES_VERSION).tar.bz2; echo Creating patch-iptables-$(OLD_IPTABLES_VERSION)-$(IPTABLES_VERSION).bz2; diff -urN iptables-$(OLD_IPTABLES_VERSION) iptables-$(IPTABLES_VERSION) | bzip2 -9 > $(RELEASE_DIR)/patch-iptables-$(OLD_IPTABLES_VERSION)-$(IPTABLES_VERSION).bz2
-	@rm -rf /tmp/diffdir
-
-.PHONY: md5sums
-md5sums:
-	cd $(RELEASE_DIR)/ && md5sum patch-iptables-*-$(IPTABLES_VERSION).bz2 iptables-$(IPTABLES_VERSION).tar.bz2
-
-# $(wildcard) fails wierdly with make v.3.78.1.
-include $(shell echo */Makefile)
-include Rules.make
Index: iptables-modules/Makefile.am
===================================================================
--- /dev/null
+++ iptables-modules/Makefile.am
@@ -0,0 +1,92 @@
+# -*- Makefile -*-
+
+AUTOMAKE_OPTIONS = foreign subdir-objects
+AM_CFLAGS        = ${regular_CFLAGS} -I${top_srcdir}/include
+SUBDIRS         := extensions
+if ENABLE_DEVEL
+SUBDIRS         += libipq
+endif
+
+# libiptc
+libiptc_libiptc_a_SOURCES = libiptc/libip4tc.c libiptc/libip6tc.c
+
+# iptables, dynamic
+iptables_SOURCES          = iptables-standalone.c iptables.c xtables.c
+iptables_LDFLAGS          = -rdynamic
+iptables_LDADD            = -ldl -lm libiptc/libiptc.a extensions/libext4.a
+
+iptables_multi_SOURCES    = iptables-multi.c iptables-save.c \
+                            iptables-restore.c iptables-xml.c \
+                            iptables-standalone.c iptables.c xtables.c
+iptables_multi_CFLAGS     = ${AM_CFLAGS} -DIPTABLES_MULTI
+iptables_multi_LDFLAGS    = ${iptables_LDFLAGS}
+iptables_multi_LDADD      = ${iptables_LDADD}
+
+iptables_restore_SOURCES  = iptables-restore.c iptables.c xtables.c
+iptables_restore_LDFLAGS  = ${iptables_LDFLAGS}
+iptables_restore_LDADD    = ${iptables_LDADD}
+
+iptables_save_SOURCES     = iptables-save.c iptables.c xtables.c
+iptables_save_LDFLAGS     = ${iptables_LDFLAGS}
+iptables_save_LDADD       = ${iptables_LDADD}
+
+# iptables-multi, semi-static
+iptables_static_SOURCES   = ${iptables_multi_SOURCES}
+iptables_static_CFLAGS    = ${iptables_multi_CFLAGS} -DNO_SHARED_LIBS=1
+iptables_static_LDADD     = -lm libiptc/libiptc.a extensions/libext4.a
+
+iptables_xml_SOURCES      = iptables-xml.c
+
+# ip6tables, dynamic
+ip6tables_SOURCES         = ip6tables-standalone.c ip6tables.c xtables.c
+ip6tables_LDFLAGS         = -rdynamic
+ip6tables_LDADD           = -ldl -lm libiptc/libiptc.a extensions/libext6.a
+
+ip6tables_multi_SOURCES   = ip6tables-multi.c ip6tables-save.c \
+                            ip6tables-restore.c ip6tables-standalone.c \
+                            ip6tables.c xtables.c
+ip6tables_multi_CFLAGS    = ${AM_CFLAGS} -DIPTABLES_MULTI
+ip6tables_multi_LDFLAGS   = ${ip6tables_LDFLAGS}
+ip6tables_multi_LDADD     = ${ip6tables_LDADD}
+
+ip6tables_restore_SOURCES = ip6tables-restore.c ip6tables.c xtables.c
+ip6tables_restore_LDFLAGS = ${ip6tables_LDFLAGS}
+ip6tables_restore_LDADD   = ${ip6tables_LDADD}
+
+ip6tables_save_SOURCES    = ip6tables-save.c ip6tables.c xtables.c
+ip6tables_save_LDFLAGS    = ${ip6tables_LDFLAGS}
+ip6tables_save_LDADD      = ${ip6tables_LDADD}
+
+# iptables-multi, semi-static
+ip6tables_static_SOURCES    = ${ip6tables_multi_SOURCES}
+ip6tables_static_CFLAGS     = ${ip6tables_multi_CFLAGS} -DNO_SHARED_LIBS=1
+ip6tables_static_LDADD      = -lm libiptc/libiptc.a extensions/libext6.a
+
+noinst_LIBRARIES := libiptc/libiptc.a
+bin_PROGRAMS     := iptables-xml
+sbin_PROGRAMS    :=
+noinst_PROGRAMS  :=
+man_MANS         := iptables.8 iptables-restore.8 iptables-save.8 \
+                    iptables-xml.8 ip6tables.8 ip6tables-restore.8 \
+                    ip6tables-save.8
+CLEANFILES       := iptables.8 ip6tables.8
+if ENABLE_DEVEL
+include_HEADERS  := include/xtables.h include/iptables.h include/ip6tables.h
+endif
+
+if ENABLE_STATIC
+sbin_PROGRAMS += iptables-static ip6tables-static
+endif
+if ENABLE_SHARED
+sbin_PROGRAMS += iptables iptables-multi iptables-restore iptables-save \
+                 ip6tables ip6tables-multi ip6tables-restore ip6tables-save
+endif
+
+iptables.8: ${srcdir}/iptables.8.in extensions/matches4.man extensions/targets4.man
+	${AM_VERBOSE_GEN} sed -e '/@MATCH@/ r extensions/matches4.man' -e '/@TARGET@/ r extensions/targets4.man' $< >$@;
+
+ip6tables.8: ${srcdir}/ip6tables.8.in extensions/matches6.man extensions/targets6.man
+	${AM_VERBOSE_GEN} sed -e '/@MATCH@/ r extensions/matches6.man' -e '/@TARGET@/ r extensions/targets6.man' $< >$@;
+
+extensions/%:
+	${MAKE} ${AM_MAKEFLAGS} -C $(@D) $(@F)
Index: iptables-modules/Rules.make
===================================================================
--- iptables-modules.orig/Rules.make
+++ /dev/null
@@ -1,58 +0,0 @@
-#! /usr/bin/make
-
-all: $(SHARED_LIBS) $(SHARED_SE_LIBS) $(EXTRAS)
-
-experimental: $(EXTRAS_EXP)
-
-# Have to handle extensions which no longer exist.
-clean: $(EXTRA_CLEANS)
-	rm -f $(SHARED_LIBS) $(SHARED_SE_LIBS) $(EXTRAS) $(EXTRAS_EXP) $(SHARED_LIBS:%.so=%_sh.o) $(SHARED_SE_LIBS:%.so=%_sh.o)
-	rm -f extensions/initext.c extensions/initext6.c
-	@find . -name '*.[ao]' -o -name '*.so' | xargs rm -f
-
-install: all $(EXTRA_INSTALLS)
-	@if [ -f /usr/local/bin/iptables -a "$(BINDIR)" = "/usr/local/sbin" ];\
-	then echo 'Erasing iptables from old location (now /usr/local/sbin).';\
-	rm -f /usr/local/bin/iptables;\
-	fi
-
-install-experimental: $(EXTRA_INSTALLS_EXP)
-
-TAGS:
-	@rm -f $@
-	find . -name '*.[ch]' | xargs etags -a
-
-dep: $(DEPFILES) $(EXTRA_DEPENDS)
-	@echo Dependencies will be generated on next make.
-	rm -f $(DEPFILES) $(EXTRA_DEPENDS) .makefirst
-
-$(SHARED_LIBS:%.so=%.d): %.d: %.c
-	@-$(CC) -M -MG $(CFLAGS) $< | \
-	    sed -e 's@^.*\.o:@$*.d $*_sh.o:@' > $@
-
-$(SHARED_LIBS): %.so : %_sh.o
-	$(CC) -shared $(EXT_LDFLAGS) -o $@ $<
-
-$(SHARED_SE_LIBS:%.so=%.d): %.d: %.c
-	@-$(CC) -M -MG $(CFLAGS) $< | \
-		sed -e 's@^.*\.o:@$*.d $*_sh.o:@' > $@
-
-$(SHARED_SE_LIBS): %.so : %_sh.o
-	$(LD) -shared $(EXT_LDFLAGS) -o $@ $< $(LDLIBS)
-
-%_sh.o : %.c
-	$(CC) $(SH_CFLAGS) -o $@ -c $<
-
-.makefirst:
-	@echo Making dependencies: please wait...
-	@touch .makefirst
-
-# This is useful for when dependencies completely screwed
-%.h::
-	@echo "Unable to resolve dependency on $@. Try 'make clean'."
-	@-rm -f $(DEPFILES) $(EXTRA_DEPENDS) .makefirst
-	@[ -d $(KERNEL_DIR)/include/linux/netfilter_ipv4 ] || echo -e '\n\n    Please try `make KERNEL_DIR=path-to-correct-kernel'\'.'\n\n'
-	@exit 1
-
--include $(DEPFILES) $(EXTRA_DEPENDS)
--include .makefirst
Index: iptables-modules/autogen.sh
===================================================================
--- /dev/null
+++ iptables-modules/autogen.sh
@@ -0,0 +1,4 @@
+#!/bin/bash
+
+autoreconf -fi;
+rm -Rf autom4te*.cache;
Index: iptables-modules/configure.ac
===================================================================
--- /dev/null
+++ iptables-modules/configure.ac
@@ -0,0 +1,55 @@
+
+AC_INIT([iptables], [1.4.0])
+AC_CONFIG_HEADERS([config.h])
+AC_PROG_INSTALL
+AM_INIT_AUTOMAKE
+AC_PROG_CC
+AM_PROG_CC_C_O
+AC_DISABLE_STATIC
+AC_PROG_LIBTOOL
+
+kbuilddir="/lib/modules/$(uname -r)/build";
+ksourcedir="/lib/modules/$(uname -r)/source";
+AC_ARG_WITH([kernel],
+	AS_HELP_STRING([--with-kernel=PATH],
+	[Path to kernel source/build directory]),
+	[kbuilddir="$withval"; ksourcedir="$withval";])
+AC_ARG_WITH([kbuild],
+	AS_HELP_STRING([--with-kbuild=PATH],
+	[Path to kernel build directory [[/lib/modules/CURRENT/build]]]),
+	[kbuilddir="$withval"])
+AC_ARG_WITH([ksource],
+	AS_HELP_STRING([--with-ksource=PATH],
+	[Path to kernel source directory [[/lib/modules/CURRENT/source]]]),
+	[ksourcedir="$withval"])
+AC_ARG_WITH([iptdir],
+	AS_HELP_STRING([--with-iptdir=PATH],
+	[Path to iptables modules [[LIBEXECDIR/iptables]]]),
+	[iptdir="$withval"],
+	[iptdir="${libexecdir}/iptables"])
+AC_ARG_ENABLE([devel],
+	AS_HELP_STRING([--enable-devel],
+	[Build and install development files (libipq, libipq-devel, iptables-devel)]))
+
+AC_CHECK_HEADER([netinet/ip6.h], [], [AC_MSG_ERROR(but we need that for IPv6)])
+AM_CONDITIONAL([ENABLE_STATIC], [test "$enable_static" == "yes"])
+AM_CONDITIONAL([ENABLE_SHARED], [test "$enable_shared" == "yes"])
+AM_CONDITIONAL([ENABLE_DEVEL], [test "$enable_devel" == "yes"])
+
+regular_CFLAGS="-D_LARGEFILE_SOURCE=1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=64 \
+	-D_REENTRANT -Wall -Waggregate-return -Wmissing-declarations \
+	-Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-prototypes \
+	-Winline -pipe -DIPTABLES_VERSION=\\\"$PACKAGE_VERSION\\\" \
+	-DIPT_LIB_DIR=\\\"\${iptdir}\\\" \
+	-I\"$kbuilddir/include\" -I\"$ksourcedir/include\""
+
+# Remove workarounds soon
+regular_CFLAGS="$regular_CFLAGS -Wno-aggregate-return \
+	-Wno-missing-declarations -Wno-missing-prototypes \
+	-Wno-redundant-decls -Wno-shadow -Wno-strict-prototypes -Wno-inline"
+
+AC_SUBST([regular_CFLAGS])
+AC_SUBST([kbuilddir])
+AC_SUBST([ksourcedir])
+AC_SUBST([iptdir])
+AC_OUTPUT([Makefile extensions/GNUmakefile libipq/Makefile])
Index: iptables-modules/extensions/.condition-test
===================================================================
--- iptables-modules.orig/extensions/.condition-test
+++ iptables-modules/extensions/.condition-test
@@ -1,3 +1,4 @@
 #!/bin/sh
-# True if condition is applied.
-[ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_condition.h ] && echo condition
+[ "$1" == "provides" -o \
+-f "$KERNEL_DIR/include/linux/netfilter_ipv4/ipt_condition.h" ] && \
+echo "condition";
Index: iptables-modules/extensions/.condition-test6
===================================================================
--- iptables-modules.orig/extensions/.condition-test6
+++ iptables-modules/extensions/.condition-test6
@@ -1,3 +1,4 @@
 #!/bin/sh
-# True if condition6 is applied.
-[ -f $KERNEL_DIR/include/linux/netfilter_ipv6/ip6t_condition.h ] && echo condition
+[ "$1" == "provides" -o \
+-f "$KERNEL_DIR/include/linux/netfilter_ipv6/ip6t_condition.h" ] && \
+echo "condition";
Index: iptables-modules/extensions/.set-test
===================================================================
--- iptables-modules.orig/extensions/.set-test
+++ iptables-modules/extensions/.set-test
@@ -1,2 +1,4 @@
 #! /bin/sh
-[ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ip_set.h ] && echo set SET
+[ "$1" == "provides" -o \
+-f "$KERNEL_DIR/include/linux/netfilter_ipv4/ip_set.h" ] && \
+echo "set SET";
Index: iptables-modules/extensions/GNUmakefile.in
===================================================================
--- /dev/null
+++ iptables-modules/extensions/GNUmakefile.in
@@ -0,0 +1,204 @@
+# -*- Makefile -*-
+
+top_srcdir  := @top_srcdir@
+srcdir      := @srcdir@
+ksourcedir  := @ksourcedir@
+prefix      := @prefix@
+exec_prefix := @exec_prefix@
+libdir      := @libdir@
+libexecdir  := @libexecdir@
+iptdir      := @iptdir@
+
+CC             := @CC@
+CCLD           := ${CC}
+CFLAGS         := @CFLAGS@
+LDFLAGS        := @LDFLAGS@
+regular_CFLAGS := @regular_CFLAGS@
+
+AM_CFLAGS      := ${regular_CFLAGS} -I${top_srcdir}/include
+AM_DEPFLAGS     = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
+
+ifeq (${V},)
+AM_LIBTOOL_SILENT = --silent
+AM_VERBOSE_CC     = @echo "  CC      " $@;
+AM_VERBOSE_CCLD   = @echo "  CCLD    " $@;
+AM_VERBOSE_CXX    = @echo "  CXX     " $@;
+AM_VERBOSE_CXXLD  = @echo "  CXXLD   " $@;
+AM_VERBOSE_AR     = @echo "  AR      " $@;
+AM_VERBOSE_GEN    = @echo "  GEN     " $@;
+endif
+
+#
+#	Wildcard module list
+#
+pfx_all_mod := $(patsubst ${srcdir}/libxt_%.c,%,$(wildcard ${srcdir}/libxt_*.c))
+pf4_all_mod := $(patsubst ${srcdir}/libipt_%.c,%,$(wildcard ${srcdir}/libipt_*.c))
+pf6_all_mod := $(patsubst ${srcdir}/libip6t_%.c,%,$(wildcard ${srcdir}/libip6t_*.c))
+
+#
+#	Conditional module list
+#
+pfx_cond_mod := $(foreach i,$(wildcard ${srcdir}/.*-testx),$(shell KERNEL_DIR=${ksourcedir} ${i} provides))
+pf4_cond_mod := $(foreach i,$(wildcard ${srcdir}/.*-test),$(shell KERNEL_DIR=${ksourcedir} ${i} provides))
+pf6_cond_mod := $(foreach i,$(wildcard ${srcdir}/.*-test6),$(shell KERNEL_DIR=${ksourcedir} ${i} provides))
+
+#
+#	Conditional modules to build
+#
+pfx_bc_mod := $(foreach i,$(wildcard ${srcdir}/.*-testx),$(shell KERNEL_DIR=${ksourcedir} ${i}))
+pf4_bc_mod := $(foreach i,$(wildcard ${srcdir}/.*-test),$(shell KERNEL_DIR=${ksourcedir} ${i}))
+pf6_bc_mod := $(foreach i,$(wildcard ${srcdir}/.*-test6),$(shell KERNEL_DIR=${ksourcedir} ${i}))
+
+#
+#	Total list of modules to build
+#
+pfx_build_mod := $(filter-out ${pfx_cond_mod},${pfx_all_mod}) ${pfx_bc_mod}
+pf4_build_mod := $(filter-out ${pf4_cond_mod},${pf4_all_mod}) ${pf4_bc_mod}
+pf6_build_mod := $(filter-out ${pf6_cond_mod},${pf6_all_mod}) ${pf6_bc_mod}
+pfx_objs      := $(patsubst %,libxt_%.o,${pfx_build_mod})
+pf4_objs      := $(patsubst %,libipt_%.o,${pf4_build_mod})
+pf6_objs      := $(patsubst %,libip6t_%.o,${pf6_build_mod})
+pfx_solibs    := $(patsubst %,libxt_%.so,${pfx_build_mod})
+pf4_solibs    := $(patsubst %,libipt_%.so,${pf4_build_mod})
+pf6_solibs    := $(patsubst %,libip6t_%.so,${pf6_build_mod})
+
+
+#
+# Building blocks
+#
+targets := libext4.a libext6.a matches4.man matches6.man \
+           targets4.man targets6.man
+targets_install :=
+@ENABLE_STATIC_TRUE@ libext4_objs := ${pfx_objs} ${pf4_objs}
+@ENABLE_STATIC_TRUE@ libext6_objs := ${pfx_objs} ${pf6_objs}
+@ENABLE_SHARED_TRUE@ targets += ${pfx_solibs} ${pf4_solibs} ${pf6_solibs}
+@ENABLE_SHARED_TRUE@ targets_install += ${pfx_solibs} ${pf4_solibs} ${pf6_solibs}
+
+.SECONDARY:
+
+.PHONY: all install clean distclean FORCE
+
+all: ${targets}
+
+install: ${targets_install}
+	@mkdir -p "${DESTDIR}${iptdir}";
+	install -pm0755 $^ "${DESTDIR}${iptdir}/";
+
+clean:
+	rm -f *.o *.oo *.so *.a {matches,targets}[46].man initext4.c initext6.c;
+
+distclean: clean
+	rm -f .*.d *.dd;
+
+%.o: %.c
+	${AM_VERBOSE_CC} ${CC} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=$*_init ${CFLAGS} -o $@ -c $<;
+
+-include .*.d
+
+
+#
+#	Shared libraries
+#
+lib%.so: lib%.oo
+	${AM_VERBOSE_CCLD} ${CCLD} ${AM_LDFLAGS} -shared ${LDFLAGS} -o $@ $<;
+
+lib%.oo: ${srcdir}/lib%.c
+	${AM_VERBOSE_CC} ${CC} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=$*_init -DPIC -fPIC ${CFLAGS} -o $@ -c $<;
+
+
+#
+#	Static bits
+#
+#	If static building is disabled, libext*.a will still be generated,
+#	but will be empty. This is good since we can do with less case
+#	handling code in the Makefiles.
+#
+lib%.o: ${srcdir}/lib%.c
+	${AM_VERBOSE_CC} ${CC} ${AM_DEPFLAGS} ${AM_CFLAGS} -DNO_SHARED_LIBS=1 -D_INIT=$*_init ${CFLAGS} -o $@ -c $<;
+
+libext4.a: initext4.o ${libext4_objs}
+	${AM_VERBOSE_AR} ${AR} crs $@ $^;
+
+libext6.a: initext6.o ${libext6_objs}
+	${AM_VERBOSE_AR} ${AR} crs $@ $^;
+
+initext_func  := $(addprefix xt_,${pfx_build_mod}) $(addprefix ipt_,${pf4_build_mod})
+initext6_func := $(addprefix xt_,${pfx_build_mod}) $(addprefix ip6t_,${pf6_build_mod})
+
+.initext4.dd: FORCE
+	@echo "${initext_func}" >$@.tmp; \
+	cmp -s $@ $@.tmp || mv $@.tmp $@; \
+	rm -f $@.tmp;
+
+.initext6.dd: FORCE
+	@echo "${initext6_func}" >$@.tmp; \
+	cmp -s $@ $@.tmp || mv $@.tmp $@; \
+	rm -f $@.tmp;
+
+initext4.c: .initext4.dd
+	${AM_VERBOSE_GEN}
+	@( \
+	echo "" >$@; \
+	for i in ${initext_func}; do \
+		echo "extern void lib$${i}_init(void);" >>$@; \
+	done; \
+	echo -en "void init_extensions(void)\n""{\n" >>$@; \
+	for i in ${initext_func}; do \
+		echo -e "\t""lib$${i}_init();" >>$@; \
+	done; \
+	echo "}" >>$@; \
+	);
+
+initext6.c: .initext6.dd
+	${AM_VERBOSE_GEN}
+	@( \
+	echo "" >$@; \
+	for i in ${initext6_func}; do \
+		echo "extern void lib$${i}_init(void);" >>$@; \
+	done; \
+	echo -en "void init_extensions(void)\n""{\n" >>$@; \
+	for i in ${initext6_func}; do \
+		echo -e "\t""lib$${i}_init();" >>$@; \
+	done; \
+	echo "}" >>$@; \
+	);
+
+#
+#	Manual pages
+#
+ex_matches = $(sort $(shell echo $(1) | grep -Eo '\b[a-z0-9]+\b'))
+ex_targets = $(sort $(shell echo $(1) | grep -Eo '\b[A-Z0-9]+\b'))
+man_run    = \
+	${AM_VERBOSE_GEN} \
+	for ext in $(1); do \
+		f="${srcdir}/libxt_$$ext.man"; \
+		if [ -f "$$f" ]; then \
+			echo ".SS $$ext"; \
+			cat "$$f"; \
+			continue; \
+		fi; \
+		f="${srcdir}/libipt_$$ext.man"; \
+		if [ -f "$$f" ]; then \
+			echo ".SS $$ext"; \
+			cat "$$f"; \
+			continue; \
+		fi; \
+		f="${srcdir}/libip6t_$$ext.man"; \
+		if [ -f "$$f" ]; then \
+			echo ".SS $$ext"; \
+			cat "$$f"; \
+			continue; \
+		fi; \
+	done >$@;
+
+matches4.man: .initext4.dd $(wildcard lib*.man)
+	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pf4_build_mod}))
+
+matches6.man: .initext6.dd $(wildcard lib*.man)
+	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pf6_build_mod}))
+
+targets4.man: .initext4.dd $(wildcard lib*.man)
+	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pf4_build_mod}))
+
+targets6.man: .initext6.dd $(wildcard lib*.man)
+	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pf6_build_mod}))
Index: iptables-modules/extensions/Makefile
===================================================================
--- iptables-modules.orig/extensions/Makefile
+++ /dev/null
@@ -1,311 +0,0 @@
-#! /usr/bin/make
-
-# WARNING:
-# only add extensions here that are either present in the kernel, or whose
-# header files are present in the include/linux directory of this iptables
-# package (HW)
-#
-PF_EXT_SLIB:=ah addrtype conntrack ecn icmp iprange owner policy realm recent tos ttl unclean CLUSTERIP DNAT ECN LOG MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL ULOG
-PF6_EXT_SLIB:=ah dst eui64 frag hbh hl icmp6 ipv6header mh owner policy rt HL LOG REJECT
-PFX_EXT_SLIB:=connbytes connmark connlimit comment dccp dscp esp hashlimit helper length limit mac mark multiport physdev pkttype quota rateest sctp state statistic standard string tcp tcpmss time u32 udp CLASSIFY CONNMARK DSCP MARK NFLOG NFQUEUE NOTRACK RATEEST TCPMSS TRACE
-
-PF_EXT_SELINUX_SLIB:=
-PF6_EXT_SELINUX_SLIB:=
-PFX_EXT_SELINUX_SLIB:=CONNSECMARK SECMARK
-
-ifeq ($(DO_SELINUX), 1)
-PF_EXT_SE_SLIB:=$(PF_EXT_SELINUX_SLIB)
-PF6_EXT_SE_SLIB:=$(PF6_EXT_SELINUX_SLIB)
-PFX_EXT_SE_SLIB:=$(PFX_EXT_SELINUX_SLIB)
-endif
-
-# Optionals
-PF_EXT_SLIB_OPTS:=$(foreach T,$(wildcard extensions/.*-test),$(shell KERNEL_DIR=$(KERNEL_DIR) $(T)))
-PF6_EXT_SLIB_OPTS:=$(foreach T,$(wildcard extensions/.*-test6),$(shell KERNEL_DIR=$(KERNEL_DIR) $(T)))
-PFX_EXT_SLIB_OPTS:=$(foreach T,$(wildcard extensions/.*-testx),$(shell KERNEL_DIR=$(KERNEL_DIR) $(T)))
-
-PF_EXT_ALL_SLIB:=$(PF_EXT_SLIB) $(PF_EXT_SE_SLIB) $(PF_EXT_SLIB_OPTS)
-PF6_EXT_ALL_SLIB:=$(PF6_EXT_SLIB) $(PF6_EXT_SE_SLIB) $(PF6_EXT_SLIB_OPTS)
-PFX_EXT_ALL_SLIB:=$(PFX_EXT_SLIB) $(PFX_EXT_SE_SLIB) $(PFX_EXT_SLIB_OPTS)
-
-# libipt*.c with libipt*.man
-PF_EXT_MAN_ALL_MATCHES:=$(foreach T,$(PF_EXT_ALL_SLIB),$(shell test -f extensions/libipt_$(T).man && grep -q register_match extensions/libipt_$(T).c  && echo $(T)))
-PF_EXT_MAN_ALL_TARGETS:=$(foreach T,$(PF_EXT_ALL_SLIB),$(shell test -f extensions/libipt_$(T).man && grep -q register_target extensions/libipt_$(T).c && echo $(T)))
-PF6_EXT_MAN_ALL_MATCHES:=$(foreach T,$(PF6_EXT_ALL_SLIB),$(shell test -f extensions/libip6t_$(T).man && grep -q register_match6 extensions/libip6t_$(T).c  && echo $(T)))
-PF6_EXT_MAN_ALL_TARGETS:=$(foreach T,$(PF6_EXT_ALL_SLIB),$(shell test -f extensions/libip6t_$(T).man && grep -q register_target6 extensions/libip6t_$(T).c && echo $(T)))
-
-# libxt*.c with libipt*.man
-PF_EXT_MAN_ALL_MATCHES+=$(foreach T,$(PFX_EXT_ALL_SLIB),$(shell test -f extensions/libipt_$(T).man && grep -q xtables_register_match extensions/libxt_$(T).c  && echo $(T)))
-PF_EXT_MAN_ALL_TARGETS+=$(foreach T,$(PFX_EXT_ALL_SLIB),$(shell test -f extensions/libipt_$(T).man && grep -q xtables_register_target extensions/libxt_$(T).c && echo $(T)))
-PF6_EXT_MAN_ALL_MATCHES+=$(foreach T,$(PFX_EXT_ALL_SLIB),$(shell test -f extensions/libip6t_$(T).man && grep -q xtables_register_match extensions/libxt_$(T).c  && echo $(T)))
-PF6_EXT_MAN_ALL_TARGETS+=$(foreach T,$(PFX_EXT_ALL_SLIB),$(shell test -f extensions/libip6t_$(T).man && grep -q xtables_register_target extensions/libxt_$(T).c && echo $(T)))
-
-# libxt*.c with libxt*.man
-PFX_EXT_MAN_ALL_MATCHES=$(foreach T,$(PFX_EXT_ALL_SLIB),$(shell test -f extensions/libxt_$(T).man && grep -q xtables_register_match extensions/libxt_$(T).c  && echo $(T)))
-PFX_EXT_MAN_ALL_TARGETS=$(foreach T,$(PFX_EXT_ALL_SLIB),$(shell test -f extensions/libxt_$(T).man && grep -q xtables_register_target extensions/libxt_$(T).c && echo $(T)))
-
-# libipt*.man
-PF_EXT_MAN_MATCHES:=$(filter $(PF_EXT_SLIB), $(PF_EXT_MAN_ALL_MATCHES))
-PF_EXT_MAN_MATCHES+=$(filter $(PFX_EXT_SLIB), $(PF_EXT_MAN_ALL_MATCHES))
-PF_EXT_MAN_MATCHES+=$(filter $(PF_EXT_SE_SLIB), $(PF_EXT_MAN_ALL_MATCHES))
-PF_EXT_MAN_MATCHES+=$(filter $(PFX_EXT_SE_SLIB), $(PF_EXT_MAN_ALL_MATCHES))
-
-# libipt*.man
-PF_EXT_MAN_TARGETS:=$(filter $(PF_EXT_SLIB), $(PF_EXT_MAN_ALL_TARGETS))
-PF_EXT_MAN_TARGETS+=$(filter $(PFX_EXT_SLIB), $(PF_EXT_MAN_ALL_TARGETS))
-PF_EXT_MAN_TARGETS+=$(filter $(PF_EXT_SE_SLIB), $(PF_EXT_MAN_ALL_TARGETS))
-PF_EXT_MAN_TARGETS+=$(filter $(PFX_EXT_SE_SLIB), $(PF_EXT_MAN_ALL_TARGETS))
-
-# libipt*.man
-PF_EXT_MAN_EXTRA_MATCHES:=$(filter-out $(PF_EXT_MAN_MATCHES), $(PF_EXT_MAN_ALL_MATCHES))
-PF_EXT_MAN_EXTRA_TARGETS:=$(filter-out $(PF_EXT_MAN_TARGETS), $(PF_EXT_MAN_ALL_TARGETS))
-
-# libip6t*.man
-PF6_EXT_MAN_MATCHES:=$(filter $(PF6_EXT_SLIB), $(PF6_EXT_MAN_ALL_MATCHES))
-PF6_EXT_MAN_MATCHES+=$(filter $(PFX_EXT_SLIB), $(PF6_EXT_MAN_ALL_MATCHES))
-PF6_EXT_MAN_MATCHES+=$(filter $(PF6_EXT_SE_SLIB), $(PF6_EXT_MAN_ALL_MATCHES))
-PF6_EXT_MAN_MATCHES+=$(filter $(PFX_EXT_SE_SLIB), $(PF6_EXT_MAN_ALL_MATCHES))
-
-# libip6t*.man
-PF6_EXT_MAN_TARGETS:=$(filter $(PF6_EXT_SLIB), $(PF6_EXT_MAN_ALL_TARGETS))
-PF6_EXT_MAN_TARGETS+=$(filter $(PFX_EXT_SLIB), $(PF6_EXT_MAN_ALL_TARGETS))
-PF6_EXT_MAN_TARGETS+=$(filter $(PF6_EXT_SE_SLIB), $(PF6_EXT_MAN_ALL_TARGETS))
-PF6_EXT_MAN_TARGETS+=$(filter $(PFX_EXT_SE_SLIB), $(PF6_EXT_MAN_ALL_TARGETS))
-
-# libip6t*.man
-PF6_EXT_MAN_EXTRA_MATCHES:=$(filter-out $(PF6_EXT_MAN_MATCHES), $(PF6_EXT_MAN_ALL_MATCHES))
-PF6_EXT_MAN_EXTRA_TARGETS:=$(filter-out $(PF6_EXT_MAN_TARGETS), $(PF6_EXT_MAN_ALL_TARGETS))
-
-# libxt*.man
-PFX_EXT_MAN_MATCHES:=$(filter $(PFX_EXT_SLIB), $(PFX_EXT_MAN_ALL_MATCHES))
-PFX_EXT_MAN_MATCHES+=$(filter $(PFX_EXT_SE_SLIB), $(PFX_EXT_MAN_ALL_MATCHES))
-PFX_EXT_MAN_TARGETS:=$(filter $(PFX_EXT_SLIB), $(PFX_EXT_MAN_ALL_TARGETS))
-PFX_EXT_MAN_TARGETS+=$(filter $(PFX_EXT_SE_SLIB), $(PFX_EXT_MAN_ALL_TARGETS))
-
-# libxt*.man
-PFX_EXT_MAN_EXTRA_MATCHES:=$(filter-out $(PFX_EXT_MAN_MATCHES), $(PFX_EXT_MAN_ALL_MATCHES))
-PFX_EXT_MAN_EXTRA_TARGETS:=$(filter-out $(PFX_EXT_MAN_TARGETS), $(PFX_EXT_MAN_ALL_TARGETS))
-
-ifneq ($(DO_SELINUX), 1)
-PF_EXT_MAN_EXTRA_MATCHES:=$(filter-out $(PF_EXT_SELINUX_SLIB), $(PF_EXT_MAN_EXTRA_MATCHES))
-PF_EXT_MAN_EXTRA_TARGETS:=$(filter-out $(PF_EXT_SELINUX_SLIB), $(PF_EXT_MAN_EXTRA_TARGETS))
-PF_EXT_MAN_EXTRA_MATCHES:=$(filter-out $(PFX_EXT_SELINUX_SLIB), $(PF_EXT_MAN_EXTRA_MATCHES))
-PF_EXT_MAN_EXTRA_TARGETS:=$(filter-out $(PFX_EXT_SELINUX_SLIB), $(PF_EXT_MAN_EXTRA_TARGETS))
-
-PF6_EXT_MAN_EXTRA_MATCHES:=$(filter-out $(PF6_EXT_SELINUX_SLIB), $(PF6_EXT_MAN_EXTRA_MATCHES))
-PF6_EXT_MAN_EXTRA_TARGETS:=$(filter-out $(PF6_EXT_SELINUX_SLIB), $(PF6_EXT_MAN_EXTRA_TARGETS))
-PF6_EXT_MAN_EXTRA_MATCHES:=$(filter-out $(PFX_EXT_SELINUX_SLIB), $(PF6_EXT_MAN_EXTRA_MATCHES))
-PF6_EXT_MAN_EXTRA_TARGETS:=$(filter-out $(PFX_EXT_SELINUX_SLIB), $(PF6_EXT_MAN_EXTRA_TARGETS))
-
-PFX_EXT_MAN_EXTRA_MATCHES:=$(filter-out $(PFX_EXT_SELINUX_SLIB), $(PFX_EXT_MAN_EXTRA_MATCHES))
-PFX_EXT_MAN_EXTRA_TARGETS:=$(filter-out $(PFX_EXT_SELINUX_SLIB), $(PFX_EXT_MAN_EXTRA_TARGETS))
-endif
-
-# extra man pages requires this (really _A_ll)
-PFA4_EXT_MAN_EXTRA_MATCHES:=$(PF_EXT_MAN_EXTRA_MATCHES) $(PFX_EXT_MAN_EXTRA_MATCHES)
-PFA4_EXT_MAN_EXTRA_TARGETS:=$(PF_EXT_MAN_EXTRA_TARGETS) $(PFX_EXT_MAN_EXTRA_TARGETS)
-PFA6_EXT_MAN_EXTRA_MATCHES:=$(PF6_EXT_MAN_EXTRA_MATCHES) $(PFX_EXT_MAN_EXTRA_MATCHES)
-PFA6_EXT_MAN_EXTRA_TARGETS:=$(PF6_EXT_MAN_EXTRA_TARGETS) $(PFX_EXT_MAN_EXTRA_TARGETS)
-
-
-allman:
-	@echo 'ALL_SLIB (IPv4):' $(PF_EXT_ALL_SLIB)
-	@echo 'ALL_SLIB (IPv6):' $(PF6_EXT_ALL_SLIB)
-	@echo 'ALL_SLIB (both):' $(PFX_EXT_ALL_SLIB)
-	@echo 'ALL_MATCH (IPv4):' $(PF_EXT_MAN_ALL_MATCHES)
-	@echo 'ALL_MATCH (IPv6):' $(PF6_EXT_MAN_ALL_MATCHES)
-	@echo 'ALL_MATCH (both):' $(PFX_EXT_MAN_ALL_MATCHES)
-	@echo 'ALL_TARGET (IPv4):' $(PF_EXT_MAN_ALL_TARGETS)
-	@echo 'ALL_TARGET (IPv6):' $(PF6_EXT_MAN_ALL_TARGETS)
-	@echo 'ALL_TARGET (both):' $(PFX_EXT_MAN_ALL_TARGETS)
-
-PF_EXT_SLIB+=$(PF_EXT_SLIB_OPTS)
-PF6_EXT_SLIB+=$(PF6_EXT_SLIB_OPTS)
-PFX_EXT_SLIB+=$(PFX_EXT_SLIB_OPTS)
-
-OPTIONALS+=$(patsubst %,XT:%,$(PFX_EXT_SLIB_OPTS))
-OPTIONALS+=$(patsubst %,IPv4:%,$(PF_EXT_SLIB_OPTS))
-OPTIONALS+=$(patsubst %,IPv6:%,$(PF6_EXT_SLIB_OPTS))
-
-ifndef NO_SHARED_LIBS
-SHARED_LIBS+=$(foreach T,$(PF_EXT_SLIB),extensions/libipt_$(T).so)
-SHARED_SE_LIBS+=$(foreach T,$(PF_EXT_SE_SLIB),extensions/libipt_$(T).so)
-EXTRA_INSTALLS+=$(foreach T, $(PF_EXT_SLIB), $(DEST_IPT_LIBDIR)/libipt_$(T).so)
-EXTRA_INSTALLS+=$(foreach T, $(PF_EXT_SE_SLIB), $(DEST_IPT_LIBDIR)/libipt_$(T).so)
-
-ifeq ($(DO_IPV6), 1)
-SHARED_LIBS+=$(foreach T,$(PF6_EXT_SLIB),extensions/libip6t_$(T).so)
-SHARED_SE_LIBS+=$(foreach T,$(PF6_EXT_SE_SLIB),extensions/libip6t_$(T).so)
-EXTRA_INSTALLS+=$(foreach T, $(PF6_EXT_SLIB), $(DEST_IPT_LIBDIR)/libip6t_$(T).so)
-EXTRA_INSTALLS+=$(foreach T, $(PF6_EXT_SE_SLIB), $(DEST_IPT_LIBDIR)/libip6t_$(T).so)
-endif
-
-SHARED_LIBS+=$(foreach T,$(PFX_EXT_SLIB),extensions/libxt_$(T).so)
-SHARED_SE_LIBS+=$(foreach T,$(PFX_EXT_SE_SLIB),extensions/libxt_$(T).so)
-EXTRA_INSTALLS+=$(foreach T, $(PFX_EXT_SLIB), $(DEST_IPT_LIBDIR)/libxt_$(T).so)
-EXTRA_INSTALLS+=$(foreach T, $(PFX_EXT_SE_SLIB), $(DEST_IPT_LIBDIR)/libxt_$(T).so)
-
-else 	# NO_SHARED_LIBS
-EXT_OBJS+=$(foreach T,$(PF_EXT_SLIB),extensions/libipt_$(T).o)
-EXT_OBJS+=$(foreach T,$(PF_EXT_SE_SLIB),extensions/libipt_$(T).o)
-EXT_OBJS+=$(foreach T,$(PFX_EXT_SLIB),extensions/libxt_$(T).o)
-EXT_OBJS+=$(foreach T,$(PFX_EXT_SE_SLIB),extensions/libxt_$(T).o)
-EXT_FUNC+=$(foreach T,$(PF_EXT_SLIB),ipt_$(T))
-EXT_FUNC+=$(foreach T,$(PF_EXT_SE_SLIB),ipt_$(T))
-EXT_FUNC+=$(foreach T,$(PFX_EXT_SLIB),xt_$(T))
-EXT_FUNC+=$(foreach T,$(PFX_EXT_SE_SLIB),xt_$(T))
-EXT_OBJS+= extensions/initext.o
-ifeq ($(DO_IPV6), 1)
-EXT6_OBJS+=$(foreach T,$(PF6_EXT_SLIB),extensions/libip6t_$(T).o)
-EXT6_OBJS+=$(foreach T,$(PF6_EXT_SE_SLIB),extensions/libip6t_$(T).o)
-EXT6_OBJS+=$(foreach T,$(PFX_EXT_SLIB),extensions/libxt_$(T).o)
-EXT6_FUNC+=$(foreach T,$(PF6_EXT_SLIB),ip6t_$(T))
-EXT6_FUNC+=$(foreach T,$(PF6_EXT_SE_SLIB),ip6t_$(T))
-EXT6_FUNC+=$(foreach T,$(PFX_EXT_SLIB),xt_$(T))
-EXT6_OBJS+=$(foreach T,$(PFX_EXT_SE_SLIB),extensions/libxt_$(T).o)
-EXT6_FUNC+=$(foreach T,$(PFX_EXT_SE_SLIB),xt_$(T))
-EXT6_OBJS+= extensions/initext6.o
-endif	# DO_IPV6
-endif	# NO_SHARED_LIBS
-
-ifndef TOPLEVEL_INCLUDED
-local:
-	cd .. && $(MAKE) $(SHARED_LIBS) $(SHARED_SE_LIBS)
-endif
-
-ifdef NO_SHARED_LIBS
-extensions/libext.a: $(EXT_OBJS)
-	rm -f $@; ar crv $@ $(EXT_OBJS)
-
-extensions/libext6.a: $(EXT6_OBJS)
-	rm -f $@; ar crv $@ $(EXT6_OBJS)
-
-extensions/initext.o: extensions/initext.c
-extensions/initext6.o: extensions/initext6.c
-
-extensions/initext.c: extensions/Makefile
-	echo "" > $@
-	for i in $(EXT_FUNC); do \
-		echo "extern void $${i}_init(void);" >> $@; \
-	done
-	echo "void init_extensions(void) {" >> $@
-	for i in $(EXT_FUNC); do \
-		echo "	$${i}_init();" >> $@; \
-	done
-	echo "}" >> $@
-
-extensions/initext6.c: extensions/Makefile
-	echo "" > $@
-	for i in $(EXT6_FUNC); do \
-		echo "extern void $${i}_init(void);" >> $@; \
-	done
-	echo "void init_extensions(void) {" >> $@
-	for i in $(EXT6_FUNC); do \
-		echo "	$${i}_init();" >> $@; \
-	done
-	echo "}" >> $@
-
-extensions/lib%.o: extensions/lib%.c
-	$(CC) $(CFLAGS) -D_INIT=$*_init -c -o $@ $<
-
-endif
- 
-EXTRAS += extensions/libipt_targets.man
-extensions/libipt_targets.man: $(patsubst %,extensions/libipt_%.man,$(PF_EXT_MAN_ALL_TARGETS)) $(patsubst %,extensions/libxt_%.man,$(PFX_EXT_MAN_ALL_TARGETS))
-	@for ext in `echo $(PF_EXT_MAN_TARGETS) $(PFX_EXT_MAN_TARGETS) | sed 's/ /\n/g' | sort`; do \
-	    echo ".SS $$ext" ;\
-	    if test -f extensions/libipt_$$ext.man; then \
-		cat extensions/libipt_$$ext.man ;\
-	    else \
-		cat extensions/libxt_$$ext.man ;\
-	    fi; \
-	done >extensions/libipt_targets.man
-	@if [ -n "$(PFA4_EXT_MAN_EXTRA_TARGETS)" ]; then \
-	    extra="$(PFA4_EXT_MAN_EXTRA_TARGETS)" ;\
-	    for ext in `echo $${extra:-""} | sed 's/ /\n/g' | sort`; do \
-		echo ".SS $$ext (not supported, see Patch-O-Matic)" ;\
-		if test -f extensions/libipt_$$ext.man; then \
-		    cat extensions/libipt_$$ext.man ;\
-		else \
-		    cat extensions/libxt_$$ext.man ;\
-		fi; \
-	    done ;\
-       	fi >>extensions/libipt_targets.man
-
-EXTRAS += extensions/libipt_matches.man
-extensions/libipt_matches.man: $(patsubst %,extensions/libipt_%.man,$(PF_EXT_MAN_ALL_MATCHES)) $(patsubst %,extensions/libxt_%.man,$(PFX_EXT_MAN_ALL_MATCHES))
-	@for ext in `echo $(PF_EXT_MAN_MATCHES) $(PFX_EXT_MAN_MATCHES) | sed 's/ /\n/g' | sort`; do \
-	    echo ".SS $$ext" ;\
-	    if test -f extensions/libipt_$$ext.man; then \
-		cat extensions/libipt_$$ext.man ;\
-	    else \
-		cat extensions/libxt_$$ext.man ;\
-	    fi; \
-	done >extensions/libipt_matches.man
-	@if [ -n "$(PFA4_EXT_MAN_EXTRA_MATCHES)" ]; then \
-	    extra="$(PFA4_EXT_MAN_EXTRA_MATCHES)" ;\
-	    for ext in `echo $${extra:-""} | sed 's/ /\n/g' | sort`; do \
-		echo ".SS $$ext (not supported, see Patch-O-Matic)" ;\
-		if test -f extensions/libipt_$$ext.man; then \
-		    cat extensions/libipt_$$ext.man ;\
-		else \
-		    cat extensions/libxt_$$ext.man ;\
-		fi; \
-	    done ;\
-       	fi >>extensions/libipt_matches.man
-
-EXTRAS += extensions/libip6t_targets.man
-extensions/libip6t_targets.man: $(patsubst %, extensions/libip6t_%.man, $(PF6_EXT_MAN_ALL_TARGETS)) $(patsubst %,extensions/libxt_%.man,$(PFX_EXT_MAN_ALL_TARGETS))
-	@for ext in `echo $(PF6_EXT_MAN_TARGETS) $(PFX_EXT_MAN_TARGETS) | sed 's/ /\n/g' | sort`; do \
-	    echo ".SS $$ext" ;\
-	    if test -f extensions/libip6t_$$ext.man; then \
-		cat extensions/libip6t_$$ext.man ;\
-	    else \
-		cat extensions/libxt_$$ext.man ;\
-	    fi; \
-	done >extensions/libip6t_targets.man
-	@if [ -n "$(PFA6_EXT_MAN_EXTRA_TARGETS)" ]; then \
-	    extra="$(PFA6_EXT_MAN_EXTRA_TARGETS)" ;\
-	    for ext in `echo $${extra:-""} | sed 's/ /\n/g' | sort`; do \
-		echo ".SS $$ext (not supported, see Patch-O-Matic)" ;\
-		if test -f extensions/libip6t_$$ext.man; then \
-		    cat extensions/libip6t_$$ext.man ;\
-		else \
-		    cat extensions/libxt_$$ext.man ;\
-		fi; \
-	    done ;\
-       	fi >>extensions/libip6t_targets.man
-
-EXTRAS += extensions/libip6t_matches.man
-extensions/libip6t_matches.man: $(patsubst %, extensions/libip6t_%.man, $(PF6_EXT_MAN_ALL_MATCHES)) $(patsubst %,extensions/libxt_%.man,$(PFX_EXT_MAN_ALL_MATCHES))
-	@for ext in `echo $(PF6_EXT_MAN_MATCHES) $(PFX_EXT_MAN_MATCHES) | sed 's/ /\n/g' | sort`; do \
-	    echo ".SS $$ext" ;\
-	    if test -f extensions/libip6t_$$ext.man; then \
-		cat extensions/libip6t_$$ext.man ;\
-	    else \
-		cat extensions/libxt_$$ext.man ;\
-	    fi; \
-	done >extensions/libip6t_matches.man
-	@if [ -n "$(PFA6_EXT_MAN_EXTRA_MATCHES)" ]; then \
-	    extra="$(PFA6_EXT_MAN_EXTRA_MATCHES)" ;\
-	    for ext in `echo $${extra:-""} | sed 's/ /\n/g' | sort`; do \
-		echo ".SS $$ext (not supported, see Patch-O-Matic)" ;\
-		if test -f extensions/libip6t_$$ext.man; then \
-		    cat extensions/libip6t_$$ext.man ;\
-		else \
-		    cat extensions/libxt_$$ext.man ;\
-		fi; \
-	    done ;\
-       	fi >>extensions/libip6t_matches.man
-
-$(DEST_IPT_LIBDIR)/libipt_%.so: extensions/libipt_%.so
-	@[ -d $(DEST_IPT_LIBDIR)/ ] || mkdir -p $(DEST_IPT_LIBDIR)/
-	cp $< $@
-
-$(DEST_IPT_LIBDIR)/libip6t_%.so: extensions/libip6t_%.so
-	@[ -d $(DEST_IPT_LIBDIR)/ ] || mkdir -p $(DEST_IPT_LIBDIR)/
-	cp $< $@
-
-$(DEST_IPT_LIBDIR)/libxt_%.so: extensions/libxt_%.so
-	@[ -d $(DEST_IPT_LIBDIR)/ ] || mkdir -p $(DEST_IPT_LIBDIR)/
-	cp $< $@
Index: iptables-modules/extensions/dscp_helper.c
===================================================================
--- /dev/null
+++ iptables-modules/extensions/dscp_helper.c
@@ -0,0 +1,81 @@
+/*
+ * DiffServ classname <-> DiffServ codepoint mapping functions.
+ *
+ * The latest list of the mappings can be found at:
+ * <http://www.iana.org/assignments/dscp-registry>
+ *
+ * This code is released under the GNU GPL v2, 1991
+ *
+ * Author: Iain Barnes
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <xtables.h>
+
+
+static const struct ds_class
+{
+	const char *name;
+	unsigned int dscp;
+} ds_classes[] =
+{
+	{ "CS0", 0x00 },
+	{ "CS1", 0x08 },
+	{ "CS2", 0x10 },
+	{ "CS3", 0x18 },
+	{ "CS4", 0x20 },
+	{ "CS5", 0x28 },
+	{ "CS6", 0x30 },
+	{ "CS7", 0x38 },
+	{ "BE", 0x00 },
+	{ "AF11", 0x0a },
+	{ "AF12", 0x0c },
+	{ "AF13", 0x0e },
+	{ "AF21", 0x12 },
+	{ "AF22", 0x14 },
+	{ "AF23", 0x16 },
+	{ "AF31", 0x1a },
+	{ "AF32", 0x1c },
+	{ "AF33", 0x1e },
+	{ "AF41", 0x22 },
+	{ "AF42", 0x24 },
+	{ "AF43", 0x26 },
+	{ "EF", 0x2e }
+};
+
+
+
+static unsigned int
+class_to_dscp(const char *name)
+{
+	int i;
+
+	for (i = 0; i < sizeof(ds_classes) / sizeof(struct ds_class); i++) {
+		if (!strncasecmp(name, ds_classes[i].name,
+					strlen(ds_classes[i].name)))
+			return ds_classes[i].dscp;
+	}
+
+	exit_error(PARAMETER_PROBLEM,
+			"Invalid DSCP value `%s'\n", name);
+}
+
+
+#if 0
+static const char *
+dscp_to_name(unsigned int dscp)
+{
+	int i;
+
+	for (i = 0; i < sizeof(ds_classes) / sizeof(struct ds_class); i++) {
+		if (dscp == ds_classes[i].dscp)
+			return ds_classes[i].name;
+	}
+
+
+	exit_error(PARAMETER_PROBLEM,
+			"Invalid DSCP value `%d'\n", dscp);
+}
+#endif
+
Index: iptables-modules/extensions/libipt_dscp_helper.c
===================================================================
--- iptables-modules.orig/extensions/libipt_dscp_helper.c
+++ /dev/null
@@ -1,81 +0,0 @@
-/*
- * DiffServ classname <-> DiffServ codepoint mapping functions.
- *
- * The latest list of the mappings can be found at:
- * <http://www.iana.org/assignments/dscp-registry>
- *
- * This code is released under the GNU GPL v2, 1991
- * 
- * Author: Iain Barnes
- */
-
-#include <stdio.h>
-#include <string.h>
-#include <xtables.h>
-
-
-static const struct ds_class
-{
-	const char *name;
-	unsigned int dscp;
-} ds_classes[] = 
-{
-	{ "CS0", 0x00 },
-	{ "CS1", 0x08 },
-	{ "CS2", 0x10 },
-	{ "CS3", 0x18 },
-	{ "CS4", 0x20 },
-	{ "CS5", 0x28 },
-	{ "CS6", 0x30 },
-	{ "CS7", 0x38 },
-	{ "BE", 0x00 },
-	{ "AF11", 0x0a },
-	{ "AF12", 0x0c },
-	{ "AF13", 0x0e },
-	{ "AF21", 0x12 },
-	{ "AF22", 0x14 },
-	{ "AF23", 0x16 },
-	{ "AF31", 0x1a },
-	{ "AF32", 0x1c },
-	{ "AF33", 0x1e },
-	{ "AF41", 0x22 },
-	{ "AF42", 0x24 },
-	{ "AF43", 0x26 },
-	{ "EF", 0x2e }
-};
-
-
-
-static unsigned int 
-class_to_dscp(const char *name)
-{
-	int i;
-
-	for (i = 0; i < sizeof(ds_classes) / sizeof(struct ds_class); i++) {
-		if (!strncasecmp(name, ds_classes[i].name,
-					strlen(ds_classes[i].name))) 
-			return ds_classes[i].dscp;
-	}
-
-	exit_error(PARAMETER_PROBLEM, 
-			"Invalid DSCP value `%s'\n", name);
-}
-
-
-#if 0
-static const char *
-dscp_to_name(unsigned int dscp)
-{
-	int i;
-
-	for (i = 0; i < sizeof(ds_classes) / sizeof(struct ds_class); i++) {
-		if (dscp == ds_classes[i].dscp)
-			return ds_classes[i].name;
-	}
-
-	
-	exit_error(PARAMETER_PROBLEM,
-			"Invalid DSCP value `%d'\n", dscp);
-}
-#endif
-
Index: iptables-modules/extensions/libxt_DSCP.c
===================================================================
--- iptables-modules.orig/extensions/libxt_DSCP.c
+++ iptables-modules/extensions/libxt_DSCP.c
@@ -19,7 +19,7 @@
 #include <linux/netfilter/xt_DSCP.h>
 
 /* This is evil, but it's my code - HW*/
-#include "libipt_dscp_helper.c"
+#include "dscp_helper.c"
 
 static void DSCP_help(void)
 {
Index: iptables-modules/extensions/libxt_dscp.c
===================================================================
--- iptables-modules.orig/extensions/libxt_dscp.c
+++ iptables-modules/extensions/libxt_dscp.c
@@ -22,7 +22,7 @@
 #include <linux/netfilter/xt_dscp.h>
 
 /* This is evil, but it's my code - HW*/
-#include "libipt_dscp_helper.c"
+#include "dscp_helper.c"
 
 static void dscp_help(void)
 {
Index: iptables-modules/include/xtables.h
===================================================================
--- iptables-modules.orig/include/xtables.h
+++ iptables-modules/include/xtables.h
@@ -226,13 +226,14 @@ void exit_error(enum exittype, const cha
 							  format(printf,2,3)));
 extern const char *program_name, *program_version;
 
-#define _init __attribute__((constructor)) my_init
 #ifdef NO_SHARED_LIBS
-# ifdef _INIT
-#  undef _init
-#  define _init _INIT
-# endif
-  extern void init_extensions(void);
+#	ifdef _INIT
+#		undef _init
+#		define _init _INIT
+#	endif
+	extern void init_extensions(void);
+#else
+#	define _init __attribute__((constructor)) _INIT
 #endif
 
 #endif /* _XTABLES_H */
Index: iptables-modules/libipq/Makefile
===================================================================
--- iptables-modules.orig/libipq/Makefile
+++ /dev/null
@@ -1,28 +0,0 @@
-#! /usr/bin/make
-
-EXTRAS+=libipq/libipq.a
-#CFLAGS+=-DDEBUG_LIBIPTQ
-
-DEVEL_MAN3+=libipq/ipq_create_handle.3 \
-	libipq/ipq_destroy_handle.3 \
-	libipq/ipq_errstr.3 \
-	libipq/ipq_get_msgerr.3 \
-	libipq/ipq_get_packet.3 \
-	libipq/ipq_message_type.3 \
-	libipq/ipq_perror.3 \
-	libipq/ipq_read.3 \
-	libipq/ipq_set_mode.3 \
-	libipq/ipq_set_verdict.3 \
-	libipq/libipq.3
-
-DEVEL_LIBS+=libipq/libipq.a
-
-DEVEL_HEADERS+=include/libipq/libipq.h
-
-ifndef TOPLEVEL_INCLUDED
-local:
-	cd .. && $(MAKE) $(SHARED_LIBS) $(EXTRAS)
-else
-libipq/libipq.a: libipq/libipq.a(libipq/libipq.o)
-endif
-
Index: iptables-modules/libipq/Makefile.am
===================================================================
--- /dev/null
+++ iptables-modules/libipq/Makefile.am
@@ -0,0 +1,11 @@
+# -*- Makefile -*-
+
+AM_CFLAGS = ${regular_CFLAGS} -I${top_srcdir}/include
+
+libipq_a_SOURCES = libipq.c
+lib_LIBRARIES    = libipq.a
+include_HEADERS  = ${top_srcdir}/include/libipq/libipq.h
+man_MANS         = ipq_create_handle.3 ipq_destroy_handle.3 ipq_errstr.3 \
+                   ipq_get_msgerr.3 ipq_get_packet.3 ipq_message_type.3 \
+                   ipq_perror.3 ipq_read.3 ipq_set_mode.3 ipq_set_verdict.3 \
+                   libipq.3
