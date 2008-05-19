From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 6/9] Add some missing files to git repository.
Date: Tue, 20 May 2008 00:31:32 +0200
Message-ID: <1211236295-30207-7-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:38776 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756913AbYESWah (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 May 2008 18:30:37 -0400
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds subversion Rules.make.in and ulogd.8 files. The files were
missing in the git repository.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 Rules.make.in |   43 ++++++++++++++++++++++++++++++++++++++
 ulogd.8       |   64 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 107 insertions(+), 0 deletions(-)
 create mode 100644 Rules.make.in
 create mode 100644 ulogd.8

diff --git a/Rules.make.in b/Rules.make.in
new file mode 100644
index 0000000..21b05d9
--- /dev/null
+++ b/Rules.make.in
@@ -0,0 +1,43 @@
+#
+
+PREFIX=@prefix@
+exec_prefix=@exec_prefix@
+ETCDIR=@sysconfdir@
+BINDIR=@sbindir@
+
+ULOGD_CONFIGFILE=@sysconfdir@/ulogd.conf
+
+ULOGD_LIB_PATH=@libdir@/ulogd
+
+# Path of libipulog (from iptables)
+LIBIPULOG=@top_srcdir@/libipulog
+INCIPULOG=-I@top_srcdir@/libipulog/include
+INCCONFFILE=-I@top_srcdir@/conffile
+
+CC=@CC@
+LD=@LD@
+INSTALL=@INSTALL@
+
+CFLAGS=@CFLAGS@ @CPPFLAGS@ -Wall
+CFLAGS+=-DULOGD_CONFIGFILE=\"$(ULOGD_CONFIGFILE)\"
+# doesn't work for subdirs
+#CFLAGS+=$(INCIPULOG) $(INCCONFFILE)
+CFLAGS+=-I/lib/modules/`uname -r`/build/include
+#CFLAGS+=@DEFS@
+#CFLAGS+=-g -DDEBUG -DDEBUG_MYSQL -DDEBUG_PGSQL
+
+LIBS=@LIBS@
+
+
+# Names of the plugins to be compiled
+ULOGD_SL:=BASE OPRINT PWSNIFF LOGEMU LOCAL SYSLOG
+
+# mysql output support
+#ULOGD_SL+=MYSQL
+MYSQL_CFLAGS=-I@MYSQLINCLUDES@ @EXTRA_MYSQL_DEF@
+MYSQL_LDFLAGS=@DATABASE_LIB_DIR@ @MYSQL_LIB@
+
+# postgreSQL output support
+#ULOGD_SL+=PGSQL
+PGSQL_CFLAGS=-I@PGSQLINCLUDES@ @EXTRA_PGSQL_DEF@
+PGSQL_LDFLAGS=@DATABASE_LIB_DIR@ @PGSQL_LIB@
diff --git a/ulogd.8 b/ulogd.8
new file mode 100644
index 0000000..7dfb2e9
--- /dev/null
+++ b/ulogd.8
@@ -0,0 +1,64 @@
+.\"                                      Hey, EMACS: -*- nroff -*-
+.\" First parameter, NAME, should be all caps
+.\" Second parameter, SECTION, should be 1-8, maybe w/ subsection
+.\" other parameters are allowed: see man(7), man(1)
+.TH ULOGD 8 "November 05, 2002" "Linux Netfilter"
+.\" Please adjust this date whenever revising the manpage.
+.\"
+.\" Some roff macros, for reference:
+.\" .nh        disable hyphenation
+.\" .hy        enable hyphenation
+.\" .ad l      left justify
+.\" .ad b      justify to both left and right margins
+.\" .nf        disable filling
+.\" .fi        enable filling
+.\" .br        insert line break
+.\" .sp <n>    insert n+1 empty lines
+.\" for manpage-specific macros, see man(7)
+.SH NAME
+ulogd \- netfilter/iptables ULOG daemon
+.SH SYNOPSIS
+.B ulogd [options]
+.SH DESCRIPTION
+.B ulogd
+connects to the netlink device of the Linux kernel and reads messages
+from the netfilter that get queued with the iptables ULOG target. For
+this to work you have to compile the ULOG target into your kernel or
+load the respective module.
+.PP
+The received messages can be logged into files or into a mySQL or
+PostgreSQL database.
+.SH OPTIONS
+.TP
+.B -d, --daemon
+fork ulogd into background (start as daemon)
+.TP
+.B -c <filename>, --configfile <filename>
+use <filename> as configuration file instead of
+.I /etc/ulogd.conf
+.TP
+.B -h, --help
+show usage information
+.TP
+.B -V, --version
+show version information and copyright
+.SH FILES
+.I /etc/ulogd.conf
+.br
+.I /var/log/ulogd.log
+.SH SEE ALSO
+There is more documentation about the daemon and the database plugins
+(including examples) in the directories
+.nf 
+.br 
+.I /usr/share/doc/ulogd 
+.br 
+.fi
+.I /usr/share/doc/ulogd-mysql
+and
+.nf 
+.br
+.I /usr/share/doc/ulogd-pgsql
+.SH AUTHOR
+This manual page was written by Joerg Wendland <joergland@debian.org>,
+for the Debian GNU/Linux system (but may be used by others).
-- 
1.5.4.3

