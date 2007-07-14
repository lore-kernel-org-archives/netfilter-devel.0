From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 01/43] add xtables.[ch] and change Makefile to compile it
Date: Sun, 15 Jul 2007 02:21:41 +0900 (JST)
Message-ID: <200707141721.l6EHLgrG021289@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


---
 Makefile          |   14 +++++++-------
 include/xtables.h |    4 ++++
 xtables.c         |   19 +++++++++++++++++++
 3 files changed, 30 insertions(+), 7 deletions(-)
 create mode 100644 include/xtables.h
 create mode 100644 xtables.c

diff --git a/Makefile b/Makefile
index 76d8e40..1cadaf5 100644
--- a/Makefile
+++ b/Makefile
@@ -96,10 +96,10 @@ iptables.o: iptables.c
 	$(CC) $(CFLAGS) -DIPT_LIB_DIR=\"$(IPT_LIBDIR)\" -c -o $@ $<
 
 ifeq ($(DO_MULTI), 1)
-iptables: iptables-multi.c iptables-save.c iptables-restore.c iptables-xml.c iptables-standalone.c iptables.o $(STATIC_LIBS) libiptc/libiptc.a
+iptables: iptables-multi.c iptables-save.c iptables-restore.c iptables-xml.c iptables-standalone.c iptables.o xtables.o $(STATIC_LIBS) libiptc/libiptc.a
 	$(CC) $(CFLAGS) -DIPTABLES_MULTI -DIPT_LIB_DIR=\"$(IPT_LIBDIR)\" $(LDFLAGS) -o $@ $^ $(LDLIBS)
 else
-iptables: iptables-standalone.c iptables.o $(STATIC_LIBS) libiptc/libiptc.a
+iptables: iptables-standalone.c iptables.o xtables.o $(STATIC_LIBS) libiptc/libiptc.a
 	$(CC) $(CFLAGS) -DIPT_LIB_DIR=\"$(IPT_LIBDIR)\" $(LDFLAGS) -o $@ $^ $(LDLIBS)
 endif
 
@@ -107,7 +107,7 @@ $(DESTDIR)$(BINDIR)/iptables: iptables
 	@[ -d $(DESTDIR)$(BINDIR) ] || mkdir -p $(DESTDIR)$(BINDIR)
 	cp $< $@
 
-iptables-save: iptables-save.c iptables.o $(STATIC_LIBS) libiptc/libiptc.a
+iptables-save: iptables-save.c iptables.o xtables.o $(STATIC_LIBS) libiptc/libiptc.a
 	$(CC) $(CFLAGS) -DIPT_LIB_DIR=\"$(IPT_LIBDIR)\" $(LDFLAGS) -o $@ $^ $(LDLIBS)
 
 ifeq ($(DO_MULTI), 1)
@@ -120,7 +120,7 @@ $(DESTDIR)$(BINDIR)/iptables-save: iptables-save
 	cp $< $@
 endif
 
-iptables-restore: iptables-restore.c iptables.o $(STATIC_LIBS) libiptc/libiptc.a
+iptables-restore: iptables-restore.c iptables.o xtables.o $(STATIC_LIBS) libiptc/libiptc.a
 	$(CC) $(CFLAGS) -DIPT_LIB_DIR=\"$(IPT_LIBDIR)\" $(LDFLAGS) -o $@ $^ $(LDLIBS)
 
 ifeq ($(DO_MULTI), 1)
@@ -149,21 +149,21 @@ endif
 ip6tables.o: ip6tables.c
 	$(CC) $(CFLAGS) -DIP6T_LIB_DIR=\"$(IPT_LIBDIR)\" -c -o $@ $<
 
-ip6tables: ip6tables-standalone.c ip6tables.o $(STATIC6_LIBS) libiptc/libiptc.a
+ip6tables: ip6tables-standalone.c ip6tables.o xtables.o $(STATIC6_LIBS) libiptc/libiptc.a
 	$(CC) $(CFLAGS) -DIP6T_LIB_DIR=\"$(IPT_LIBDIR)\" $(LDFLAGS) -o $@ $^ $(LDLIBS)
 
 $(DESTDIR)$(BINDIR)/ip6tables: ip6tables
 	@[ -d $(DESTDIR)$(BINDIR) ] || mkdir -p $(DESTDIR)$(BINDIR)
 	cp $< $@
 
-ip6tables-save: ip6tables-save.c ip6tables.o $(STATIC6_LIBS) libiptc/libiptc.a
+ip6tables-save: ip6tables-save.c ip6tables.o xtables.o $(STATIC6_LIBS) libiptc/libiptc.a
 	$(CC) $(CFLAGS) -DIP6T_LIB_DIR=\"$(IPT_LIBDIR)\" $(LDFLAGS) -o $@ $^ $(LDLIBS)
 
 $(DESTDIR)$(BINDIR)/ip6tables-save: ip6tables-save
 	@[ -d $(DESTDIR)$(BINDIR) ] || mkdir -p $(DESTDIR)$(BINDIR)
 	cp $< $@
 
-ip6tables-restore: ip6tables-restore.c ip6tables.o $(STATIC6_LIBS) libiptc/libiptc.a
+ip6tables-restore: ip6tables-restore.c ip6tables.o xtables.o $(STATIC6_LIBS) libiptc/libiptc.a
 	$(CC) $(CFLAGS) -DIP6T_LIB_DIR=\"$(IPT_LIBDIR)\" $(LDFLAGS) -o $@ $^ $(LDLIBS)
 
 $(DESTDIR)$(BINDIR)/ip6tables-restore: ip6tables-restore
diff --git a/include/xtables.h b/include/xtables.h
new file mode 100644
index 0000000..eed1dff
--- /dev/null
+++ b/include/xtables.h
@@ -0,0 +1,4 @@
+#ifndef _XTABLES_H
+#define _XTABLES_H
+
+#endif /* _XTABLES_H */
diff --git a/xtables.c b/xtables.c
new file mode 100644
index 0000000..cc4d218
--- /dev/null
+++ b/xtables.c
@@ -0,0 +1,19 @@
+/*
+ * (C) 2000-2006 by the netfilter coreteam <coreteam@netfilter.org>:
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation; either version 2 of the License, or
+ *	(at your option) any later version.
+ *
+ *	This program is distributed in the hope that it will be useful,
+ *	but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *	GNU General Public License for more details.
+ *
+ *	You should have received a copy of the GNU General Public License
+ *	along with this program; if not, write to the Free Software
+ *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <xtables.h>
-- 
1.5.2.2
