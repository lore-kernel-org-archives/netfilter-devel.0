From: Hann-huei Chiou <koala@ascenvision.com>
Subject: [PATCH] let DO_MULTI=1 work for ip6tables* binaries
Date: Mon, 22 Oct 2007 15:40:38 +0800 (CST)
Message-ID: <200710220740.l9M7ecqU063002@mail.ascenvision.com>
To: netfilter-devel list <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gateway1-2.ascenvision.com ([61.64.195.149]:3773 "EHLO
	mail.ascenvision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbXJVIMT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Oct 2007 04:12:19 -0400
Received: from ascenvision.com ([10.8.1.241])
	by mail.ascenvision.com (8.12.11/8.12.11) with SMTP id l9M7ecqU063002
	for netfilter-devel@vger.kernel.org; Mon, 22 Oct 2007 15:40:38 +0800 (CST)
	(envelope-from koala@ascenvision.com)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Hi,

When defining DO_MULTI=1 in Makefile, only iptables is built as
a single multipurpose binary. This patch makes ip6tables also be
built in the same manner.

-- Patch begins here --
Index: ip6tables-restore.c
===================================================================
--- ip6tables-restore.c	(revision 7082)
+++ ip6tables-restore.c	(working copy)
@@ -111,7 +111,11 @@
 		free(newargv[i]);
 }
 
+#ifdef IPTABLES_MULTI
+int ip6tables_restore_main(int argc, char *argv[])
+#else
 int main(int argc, char *argv[])
+#endif
 {
 	ip6tc_handle_t handle = NULL;
 	char buffer[10240];
Index: ip6tables-standalone.c
===================================================================
--- ip6tables-standalone.c	(revision 7082)
+++ ip6tables-standalone.c	(working copy)
@@ -36,8 +36,13 @@
 #include <errno.h>
 #include <ip6tables.h>
 
+#ifdef IPTABLES_MULTI
 int
+ip6tables_main(int argc, char *argv[])
+#else
+int
 main(int argc, char *argv[])
+#endif
 {
 	int ret;
 	char *table = "filter";
Index: ip6tables-multi.c
===================================================================
--- ip6tables-multi.c	(revision 0)
+++ ip6tables-multi.c	(revision 0)
@@ -0,0 +1,31 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <libgen.h>
+
+int ip6tables_main(int argc, char **argv);
+int ip6tables_save_main(int argc, char **argv);
+int ip6tables_restore_main(int argc, char **argv);
+
+int main(int argc, char **argv) {
+  char *progname;
+
+  if (argc == 0) {
+    fprintf(stderr, "no argv[0]?");
+    exit(1);
+  } else {
+    progname = basename(argv[0]);
+
+    if (!strcmp(progname, "ip6tables"))
+      return ip6tables_main(argc, argv);
+    
+    if (!strcmp(progname, "ip6tables-save"))
+      return ip6tables_save_main(argc, argv);
+    
+    if (!strcmp(progname, "ip6tables-restore"))
+      return ip6tables_restore_main(argc, argv);
+    
+    fprintf(stderr, "ip6tables multi-purpose version: unknown applet name %s\n", progname);
+    exit(1);
+  }
+}
Index: ip6tables-save.c
===================================================================
--- ip6tables-save.c	(revision 7082)
+++ ip6tables-save.c	(working copy)
@@ -316,7 +316,11 @@
  * :Chain name POLICY packets bytes
  * rule
  */
+#ifdef IPTABLES_MULTI
+int ip6tables_save_main(int argc, char *argv[])
+#else
 int main(int argc, char *argv[])
+#endif
 {
 	const char *tablename = NULL;
 	int c;
Index: Makefile
===================================================================
--- Makefile	(revision 7082)
+++ Makefile	(working copy)
@@ -61,7 +61,10 @@
 ifeq ($(DO_IPV6), 1)
 EXTRAS+=ip6tables ip6tables.o ip6tables.8
 EXTRA_INSTALLS+=$(DESTDIR)$(BINDIR)/ip6tables $(DESTDIR)$(MANDIR)/man8/ip6tables.8
+
+ifneq ($(DO_MULTI), 1)
 EXTRAS+=ip6tables-save ip6tables-restore
+endif
 EXTRA_INSTALLS+=$(DESTDIR)$(BINDIR)/ip6tables-save $(DESTDIR)$(BINDIR)/ip6tables-restore $(DESTDIR)$(MANDIR)/man8/ip6tables-save.8 $(DESTDIR)$(MANDIR)/man8/ip6tables-restore.8
 endif
 
@@ -156,8 +159,13 @@
 ip6tables.o: ip6tables.c
 	$(CC) $(CFLAGS) -DIP6T_LIB_DIR=\"$(IPT_LIBDIR)\" -c -o $@ $<
 
+ifeq ($(DO_MULTI), 1)
+ip6tables: ip6tables-multi.c ip6tables-save.c ip6tables-restore.c ip6tables-standalone.c ip6tables.o xtables.o $(STATIC6_LIBS) libiptc/libiptc.a
+	$(CC) $(CFLAGS) -DIPTABLES_MULTI -DIP6T_LIB_DIR=\"$(IPT_LIBDIR)\" $(LDFLAGS) -o $@ $^ $(LDLIBS)
+else
 ip6tables: ip6tables-standalone.c ip6tables.o xtables.o $(STATIC6_LIBS) libiptc/libiptc.a
 	$(CC) $(CFLAGS) -DIP6T_LIB_DIR=\"$(IPT_LIBDIR)\" $(LDFLAGS) -o $@ $^ $(LDLIBS)
+endif
 
 $(DESTDIR)$(BINDIR)/ip6tables: ip6tables
 	@[ -d $(DESTDIR)$(BINDIR) ] || mkdir -p $(DESTDIR)$(BINDIR)
@@ -166,16 +174,28 @@
 ip6tables-save: ip6tables-save.c ip6tables.o xtables.o $(STATIC6_LIBS) libiptc/libiptc.a
 	$(CC) $(CFLAGS) -DIP6T_LIB_DIR=\"$(IPT_LIBDIR)\" $(LDFLAGS) -o $@ $^ $(LDLIBS)
 
+ifeq ($(DO_MULTI), 1)
+$(DESTDIR)$(BINDIR)/ip6tables-save: ip6tables
+	@[ -d $(DESTDIR)$(BINDIR) ] || mkdir -p $(DESTDIR)$(BINDIR)
+	ln -sf $< $@
+else
 $(DESTDIR)$(BINDIR)/ip6tables-save: ip6tables-save
 	@[ -d $(DESTDIR)$(BINDIR) ] || mkdir -p $(DESTDIR)$(BINDIR)
 	cp $< $@
+endif
 
 ip6tables-restore: ip6tables-restore.c ip6tables.o xtables.o $(STATIC6_LIBS) libiptc/libiptc.a
 	$(CC) $(CFLAGS) -DIP6T_LIB_DIR=\"$(IPT_LIBDIR)\" $(LDFLAGS) -o $@ $^ $(LDLIBS)
 
+ifeq ($(DO_MULTI), 1)
+$(DESTDIR)$(BINDIR)/ip6tables-restore: ip6tables
+	@[ -d $(DESTDIR)$(BINDIR) ] || mkdir -p $(DESTDIR)$(BINDIR)
+	ln -sf $< $@
+else
 $(DESTDIR)$(BINDIR)/ip6tables-restore: ip6tables-restore
 	@[ -d $(DESTDIR)$(BINDIR) ] || mkdir -p $(DESTDIR)$(BINDIR)
 	cp $< $@
+endif
 
 $(DESTDIR)$(MANDIR)/man8/%.8: %.8
 	@[ -d $(DESTDIR)$(MANDIR)/man8 ] || mkdir -p $(DESTDIR)$(MANDIR)/man8


