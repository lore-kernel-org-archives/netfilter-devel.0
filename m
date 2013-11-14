From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH V2] arptables: Add man pages for arptables-{save,restore}
Date: Thu, 14 Nov 2013 14:05:31 +0100
Message-ID: <20131114130448.23243.44905.stgit@localhost>
References: <20131114121412.20830.46585.stgit@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: bdschuym@pandora.be
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559Ab3KNNFg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Nov 2013 08:05:36 -0500
In-Reply-To: <20131114121412.20830.46585.stgit@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Also fixed up the Makefile to install these man pages.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

---
V2: Don't add man8 to $MANDIR as it can be user redefined

 userspace/arptables/Makefile            |   14 +++++++----
 userspace/arptables/arptables-restore.8 |   41 +++++++++++++++++++++++++++++++
 userspace/arptables/arptables-save.8    |   37 ++++++++++++++++++++++++++++
 3 files changed, 87 insertions(+), 5 deletions(-)
 create mode 100644 userspace/arptables/arptables-restore.8
 create mode 100644 userspace/arptables/arptables-save.8

diff --git a/userspace/arptables/Makefile b/userspace/arptables/Makefile
index 38158d9..7bead0d 100644
--- a/userspace/arptables/Makefile
+++ b/userspace/arptables/Makefile
@@ -6,10 +6,13 @@ PREFIX:=/usr/local
 LIBDIR:=$(PREFIX)/lib
 BINDIR:=$(PREFIX)/sbin
 MANDIR:=$(PREFIX)/man
+man8dir=$(MANDIR)/man8
 INITDIR:=/etc/rc.d/init.d
 SYSCONFIGDIR:=/etc/sysconfig
 DESTDIR:=
 
+MANS = arptables.8 arptables-save.8 arptables-restore.8
+
 COPT_FLAGS:=-O2
 CFLAGS:=$(COPT_FLAGS) -Wall -Wunused -I$(KERNEL_DIR)/include/ -Iinclude/ -DARPTABLES_VERSION=\"$(ARPTABLES_VERSION)\" #-g -DDEBUG #-pg # -DARPTC_DEBUG
 
@@ -36,10 +39,6 @@ libarptc/libarptc.a: libarptc/libarptc.o
 arptables: arptables-standalone.o arptables.o libarptc/libarptc.o $(EXT_OBJS)
 	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^
 
-$(DESTDIR)$(MANDIR)/man8/arptables.8: arptables.8
-	mkdir -p $(@D)
-	install -m 0644 $< $@
-
 $(DESTDIR)$(BINDIR)/arptables: arptables
 	mkdir -p $(DESTDIR)$(BINDIR)
 	install -m 0755 $< $@
@@ -57,8 +56,13 @@ scripts: arptables-save arptables-restore arptables.sysv
 	if test -d $(DESTDIR)$(INITDIR); then install -m 0755 arptables.sysv_ $(DESTDIR)$(INITDIR)/arptables; fi
 	rm -f arptables-save_ arptables-restore_ arptables.sysv_
 
+.PHONY: install-man
+install-man: $(MANS)
+	[ -d "$(DESTDIR)$(man8dir)" ] || mkdir -p "$(DESTDIR)$(man8dir)"
+	install -m 0644 $^ $(DESTDIR)$(man8dir)/
+
 .PHONY: install
-install: $(DESTDIR)$(MANDIR)/man8/arptables.8 $(DESTDIR)$(BINDIR)/arptables scripts
+install: install-man $(DESTDIR)$(BINDIR)/arptables scripts
 
 .PHONY: clean
 clean:
diff --git a/userspace/arptables/arptables-restore.8 b/userspace/arptables/arptables-restore.8
new file mode 100644
index 0000000..4f2f623
--- /dev/null
+++ b/userspace/arptables/arptables-restore.8
@@ -0,0 +1,41 @@
+.TH ARPTABLES-RESTORE 8 "Nov 07, 2013" "" ""
+.\"
+.\" Man page written by Jesper Dangaard Brouer <brouer@redhat.com> based on a
+.\" Man page written by Harald Welte <laforge@gnumonks.org>
+.\" It is based on the iptables-restore man page.
+.\"
+.\"	This program is free software; you can redistribute it and/or modify
+.\"	it under the terms of the GNU General Public License as published by
+.\"	the Free Software Foundation; either version 2 of the License, or
+.\"	(at your option) any later version.
+.\"
+.\"	This program is distributed in the hope that it will be useful,
+.\"	but WITHOUT ANY WARRANTY; without even the implied warranty of
+.\"	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+.\"	GNU General Public License for more details.
+.\"
+.\"	You should have received a copy of the GNU General Public License
+.\"	along with this program; if not, write to the Free Software
+.\"	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+.\"
+.\"
+.SH NAME
+arptables-restore \(em Restore ARP Tables
+.SH SYNOPSIS
+\fBarptables\-restore
+.SH DESCRIPTION
+.PP
+.B arptables-restore
+is used to restore ARP Tables from data specified on STDIN or
+via a file as first argument.
+Use I/O redirection provided by your shell to read from a file
+.TP
+.B arptables-restore
+flushes (deletes) all previous contents of the respective ARP Table.
+.SH BUGS
+None known as of arptables-0.0.4 release
+.SH AUTHOR
+Jesper Dangaard Brouer <brouer@redhat.com>
+.SH SEE ALSO
+\fBarptables\-save\fP(8), \fBarptables\fP(8)
+.PP
diff --git a/userspace/arptables/arptables-save.8 b/userspace/arptables/arptables-save.8
new file mode 100644
index 0000000..34791a9
--- /dev/null
+++ b/userspace/arptables/arptables-save.8
@@ -0,0 +1,37 @@
+.TH ARPTABLES-SAVE 8 "Nov 07, 2013" "" ""
+.\"
+.\" Man page written by Jesper Dangaard Brouer <brouer@redhat.com> based on a
+.\" Man page written by Harald Welte <laforge@gnumonks.org>
+.\" It is based on the iptables-save man page.
+.\"
+.\"	This program is free software; you can redistribute it and/or modify
+.\"	it under the terms of the GNU General Public License as published by
+.\"	the Free Software Foundation; either version 2 of the License, or
+.\"	(at your option) any later version.
+.\"
+.\"	This program is distributed in the hope that it will be useful,
+.\"	but WITHOUT ANY WARRANTY; without even the implied warranty of
+.\"	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+.\"	GNU General Public License for more details.
+.\"
+.\"	You should have received a copy of the GNU General Public License
+.\"	along with this program; if not, write to the Free Software
+.\"	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+.\"
+.\"
+.SH NAME
+arptables-save \(em dump arptables rules to stdout
+.SH SYNOPSIS
+\fBarptables\-save
+.SH DESCRIPTION
+.PP
+.B arptables-save
+is used to dump the contents of an ARP Table in easily parseable format
+to STDOUT. Use I/O-redirection provided by your shell to write to a file.
+.SH BUGS
+None known as of arptables-0.0.4 release
+.SH AUTHOR
+Jesper Dangaard Brouer <brouer@redhat.com>
+.SH SEE ALSO
+\fBarptables\-restore\fP(8), \fBarptables\fP(8)
+.PP

