From: Peter Volkov <pva@gentoo.org>
Subject: ebtables-2.0.9-2: build fixes
Date: Tue, 16 Mar 2010 10:52:57 +0300
Message-ID: <1268725978.19121.3.camel@tablet>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-++C7r43Eq8tTV+/mODRS"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:52254 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757659Ab0CPHxK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Mar 2010 03:53:10 -0400
Received: from [192.168.1.35] (unknown [77.246.104.171])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.gentoo.org (Postfix) with ESMTP id F009B67D3A
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Mar 2010 07:53:08 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-++C7r43Eq8tTV+/mODRS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hello. I hope this is correct mailing list to post patches for ebtables.
Please, review and apply attached patches for ebtables:

1. ebtables-v2.0.9-2-LDFLAGS.diff - respect LDFLAGS during ebtables
build.
2. ebtables-v2.0.8-2-ethertype-DESTDIR-mkdir.patch - create directories
to avoid build failure when DESTDIR is supplied.

With best regards,
-- 
Peter.

--=-++C7r43Eq8tTV+/mODRS
Content-Disposition: attachment; filename="ebtables-v2.0.8-2-ethertype-DESTDIR-mkdir.patch"
Content-Type: text/x-patch; name="ebtables-v2.0.8-2-ethertype-DESTDIR-mkdir.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

=== modified file 'Makefile'
--- Makefile	2008-08-13 04:20:07 +0000
+++ Makefile	2008-08-13 04:28:51 +0000
@@ -153,10 +153,13 @@
 .PHONY: scripts
 scripts: ebtables-save ebtables.sysv ebtables-config
 	cat ebtables-save | sed 's/__EXEC_PATH__/$(tmp1)/g' > ebtables-save_
+	mkdir -p $(DESTDIR)$(BINDIR)
 	install -m 0755 -o root -g root ebtables-save_ $(DESTDIR)$(BINDIR)/ebtables-save
 	cat ebtables.sysv | sed 's/__EXEC_PATH__/$(tmp1)/g' | sed 's/__SYSCONFIG__/$(tmp2)/g' > ebtables.sysv_
+	mkdir -p $(DESTDIR)$(INITDIR)
 	install -m 0755 -o root -g root ebtables.sysv_ $(DESTDIR)$(INITDIR)/ebtables
 	cat ebtables-config | sed 's/__SYSCONFIG__/$(tmp2)/g' > ebtables-config_
+	mkdir -p $(DESTDIR)$(SYSCONFIGDIR)
 	install -m 0600 -o root -g root ebtables-config_ $(DESTDIR)$(SYSCONFIGDIR)/ebtables-config
 	rm -f ebtables-save_ ebtables.sysv_ ebtables-config_
 
@@ -166,9 +169,9 @@
 	install -m 0644 -o root -g root ebtables.8_ $(DESTDIR)$@
 	rm -f ebtables.8_
 
-$(ETHERTYPESFILE): ethertypes
-	mkdir -p $(DESTDIR)$(@D)
-	install -m 0644 -o root -g root $< $(DESTDIR)$@
+$(DESTDIR)$(ETHERTYPESFILE): ethertypes
+	mkdir -p $(@D)
+	install -m 0644 -o root -g root $< $@
 
 .PHONY: exec
 exec: ebtables ebtables-restore
@@ -177,7 +180,7 @@
 	install -m 0755 -o root -g root ebtables-restore $(DESTDIR)$(BINDIR)/ebtables-restore
 
 .PHONY: install
-install: $(MANDIR)/man8/ebtables.8 $(ETHERTYPESFILE) exec scripts
+install: $(MANDIR)/man8/ebtables.8 $(DESTDIR)$(ETHERTYPESFILE) exec scripts
 	mkdir -p $(DESTDIR)$(LIBDIR)
 	install -m 0755 extensions/*.so $(DESTDIR)$(LIBDIR)
 	install -m 0755 *.so $(DESTDIR)$(LIBDIR)


--=-++C7r43Eq8tTV+/mODRS
Content-Disposition: attachment; filename="ebtables-v2.0.9-2-LDFLAGS.diff"
Content-Type: text/x-patch; name="ebtables-v2.0.9-2-LDFLAGS.diff"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

=== modified file 'Makefile'
--- Makefile	2010-03-16 07:37:01 +0000
+++ Makefile	2010-03-16 07:39:15 +0000
@@ -18,7 +18,6 @@
 CFLAGS:=-Wall -Wunused
 CFLAGS_SH_LIB:=-fPIC
 CC:=gcc
-LD:=ld
 
 ifeq ($(shell uname -m),sparc64)
 CFLAGS+=-DEBT_MIN_ALIGN=8 -DKERNEL_64_USERSPACE_32
@@ -85,10 +84,10 @@
 
 .PHONY: libebtc
 libebtc: $(OBJECTS2)
-	$(CC) -shared -Wl,-soname,libebtc.so -o libebtc.so -lc $(OBJECTS2)
+	$(CC) -shared $(LDFLAGS) -Wl,-soname,libebtc.so -o libebtc.so -lc $(OBJECTS2)
 
 ebtables: $(OBJECTS) ebtables-standalone.o libebtc
-	$(CC) $(CFLAGS) $(CFLAGS_SH_LIB) -o $@ ebtables-standalone.o -I$(KERNEL_INCLUDES) -L. -Lextensions -lebtc $(EXT_LIBSI) \
+	$(CC) $(CFLAGS) $(CFLAGS_SH_LIB) $(LDFLAGS) -o $@ ebtables-standalone.o -I$(KERNEL_INCLUDES) -L. -Lextensions -lebtc $(EXT_LIBSI) \
 	-Wl,-rpath,$(LIBDIR)
 
 ebtablesu: ebtablesu.c
@@ -105,7 +104,7 @@
 	$(CC) $(CFLAGS) $(PROGSPECS) -c $< -o $@  -I$(KERNEL_INCLUDES)
 
 ebtables-restore: $(OBJECTS) ebtables-restore.o libebtc
-	$(CC) $(CFLAGS) -o $@ ebtables-restore.o -I$(KERNEL_INCLUDES) -L. -Lextensions -lebtc $(EXT_LIBSI) \
+	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ ebtables-restore.o -I$(KERNEL_INCLUDES) -L. -Lextensions -lebtc $(EXT_LIBSI) \
 	-Wl,-rpath,$(LIBDIR)
 
 .PHONY: daemon

=== modified file 'extensions/Makefile'
--- extensions/Makefile	2010-03-16 07:37:01 +0000
+++ extensions/Makefile	2010-03-16 07:37:43 +0000
@@ -11,13 +11,13 @@
 EXT_LIBSI+=$(foreach T,$(EXT_TABLES), -lebtable_$(T))
 
 extensions/ebt_%.so: extensions/ebt_%.o
-	$(CC) -shared -o $@ -lc $< -nostartfiles
+	$(CC) $(LDFLAGS) -shared -o $@ -lc $< -nostartfiles
 
 extensions/libebt_%.so: extensions/ebt_%.so
 	mv $< $@
 
 extensions/ebtable_%.so: extensions/ebtable_%.o
-	$(CC) -shared -o $@ -lc $< -nostartfiles
+	$(CC) $(LDFLAGS) -shared -o $@ -lc $< -nostartfiles
 
 extensions/libebtable_%.so: extensions/ebtable_%.so
 	mv $< $@


--=-++C7r43Eq8tTV+/mODRS--

