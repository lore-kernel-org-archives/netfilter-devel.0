From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/5] libxt_osf: import nfnl_osf program
Date: Tue,  6 Apr 2010 12:52:43 +0200
Message-ID: <1270551164-2945-6-git-send-email-jengelh@medozas.de>
References: <1270551164-2945-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36868 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199Ab0DFKwz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Apr 2010 06:52:55 -0400
In-Reply-To: <1270551164-2945-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

xt_osf is pretty useless without the actual fingerprint loader. Import
nfnl_osf-2009-06-07 and make it a part of the iptables distribution.

Cc: Evgeniy Polyakov <johnpol@2ka.mxt.ru>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am              |    2 +-
 configure.ac             |    6 +-
 extensions/libxt_osf.man |    4 +-
 utils/.gitignore         |    1 +
 utils/Makefile.am        |    6 +
 utils/nfnl_osf.c         |  485 ++++++++++++++++++++++++++++++++
 utils/pf.os              |  687 ++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 1187 insertions(+), 4 deletions(-)
 create mode 100644 utils/.gitignore
 create mode 100644 utils/Makefile.am
 create mode 100644 utils/nfnl_osf.c
 create mode 100644 utils/pf.os

diff --git a/Makefile.am b/Makefile.am
index 6bf40af..3fe4a9e 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -4,7 +4,7 @@ ACLOCAL_AMFLAGS  = -I m4
 AUTOMAKE_OPTIONS = foreign subdir-objects
 
 AM_CFLAGS        = ${regular_CFLAGS} -I${top_builddir}/include -I${top_srcdir}/include ${kinclude_CFLAGS}
-SUBDIRS          = extensions
+SUBDIRS          = extensions utils
 if ENABLE_DEVEL
 SUBDIRS         += include
 endif
diff --git a/configure.ac b/configure.ac
index 4990fa1..68d2169 100644
--- a/configure.ac
+++ b/configure.ac
@@ -62,6 +62,8 @@ AM_CONDITIONAL([ENABLE_IPV6], [test "$enable_ipv6" = "yes"])
 AM_CONDITIONAL([ENABLE_DEVEL], [test "$enable_devel" = "yes"])
 AM_CONDITIONAL([ENABLE_LIBIPQ], [test "$enable_libipq" = "yes"])
 
+PKG_CHECK_MODULES([libnfnetlink], [libnfnetlink >= 1.0])
+
 regular_CFLAGS="-D_LARGEFILE_SOURCE=1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=64 \
 	-D_REENTRANT -Wall -Waggregate-return -Wmissing-declarations \
 	-Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-prototypes \
@@ -74,6 +76,7 @@ fi;
 if [[ -n "$ksourcedir" ]]; then
 	kinclude_CFLAGS="$kinclude_CFLAGS -I $ksourcedir/include";
 fi;
+pkgdatadir='${datadir}/xtables';
 
 AC_SUBST([regular_CFLAGS])
 AC_SUBST([kinclude_CFLAGS])
@@ -81,12 +84,13 @@ AC_SUBST([kbuilddir])
 AC_SUBST([ksourcedir])
 AC_SUBST([xtlibdir])
 AC_SUBST([pkgconfigdir])
+AC_SUBST([pkgdatadir])
 AC_SUBST([libxtables_vcurrent])
 AC_SUBST([libxtables_vage])
 libxtables_vmajor=$(($libxtables_vcurrent - $libxtables_vage));
 AC_SUBST([libxtables_vmajor])
 
 AC_CONFIG_FILES([Makefile extensions/GNUmakefile include/Makefile
-	libipq/Makefile
+	libipq/Makefile utils/Makefile
 	include/xtables.h include/iptables/internal.h libiptc.pc xtables.pc])
 AC_OUTPUT
diff --git a/extensions/libxt_osf.man b/extensions/libxt_osf.man
index ea616a9..f3a85fb 100644
--- a/extensions/libxt_osf.man
+++ b/extensions/libxt_osf.man
@@ -35,11 +35,11 @@ Windows [2000:SP3:Windows XP Pro SP1, 2000 SP3]: 11.22.33.55:4024 ->
 OS fingerprints are loadable using the \fBnfnl_osf\fP program. To load
 fingerprints from a file, use:
 .PP
-\fBnfnl_osf -f ./pf.os\fP
+\fBnfnl_osf -f /usr/share/xtables/pf.os\fP
 .PP
 To remove them again,
 .PP
-\fBnfnl_osf -f ./pf.os -d\fP
+\fBnfnl_osf -f /usr/share/xtables/pf.os -d\fP
 .PP
 The fingerprint database can be downlaoded from
 http://www.openbsd.org/cgi-bin/cvsweb/src/etc/pf.os .
diff --git a/utils/.gitignore b/utils/.gitignore
new file mode 100644
index 0000000..ccfd2ec
--- /dev/null
+++ b/utils/.gitignore
@@ -0,0 +1 @@
+/nfnl_osf
diff --git a/utils/Makefile.am b/utils/Makefile.am
new file mode 100644
index 0000000..d023b0c
--- /dev/null
+++ b/utils/Makefile.am
@@ -0,0 +1,6 @@
+# -*- Makefile -*-
+
+sbin_PROGRAMS = nfnl_osf
+pkgdata_DATA = pf.os
+
+nfnl_osf_LDADD = -lnfnetlink
diff --git a/utils/nfnl_osf.c b/utils/nfnl_osf.c
new file mode 100644
index 0000000..bb5f92d
--- /dev/null
+++ b/utils/nfnl_osf.c
@@ -0,0 +1,485 @@
+/*
+ * Copyright (c) 2005 Evgeniy Polyakov <johnpol@2ka.mxt.ru>
+ * 
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <sys/poll.h>
+#include <sys/time.h>
+
+#include <arpa/inet.h>
+
+#include <ctype.h>
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdarg.h>
+#include <time.h>
+#include <unistd.h>
+
+#include <netinet/ip.h>
+#include <netinet/tcp.h>
+
+#include <linux/connector.h>
+#include <linux/types.h>
+#include <linux/netlink.h>
+#include <linux/rtnetlink.h>
+#include <linux/unistd.h>
+
+#include <libnfnetlink/libnfnetlink.h>
+
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/xt_osf.h>
+
+#define OPTDEL			','
+#define OSFPDEL 		':'
+#define MAXOPTSTRLEN		128
+
+#ifndef NIPQUAD
+#define NIPQUAD(addr) \
+	((unsigned char *)&addr)[0], \
+	((unsigned char *)&addr)[1], \
+	((unsigned char *)&addr)[2], \
+	((unsigned char *)&addr)[3]
+#endif
+
+static struct nfnl_handle *nfnlh;
+static struct nfnl_subsys_handle *nfnlssh;
+
+static struct xt_osf_opt IANA_opts[] = {
+	{ .kind = 0, .length = 1,},
+	{ .kind=1, .length=1,},
+	{ .kind=2, .length=4,},
+	{ .kind=3, .length=3,},
+	{ .kind=4, .length=2,},
+	{ .kind=5, .length=1,},		/* SACK length is not defined */
+	{ .kind=6, .length=6,},
+	{ .kind=7, .length=6,},
+	{ .kind=8, .length=10,},
+	{ .kind=9, .length=2,},
+	{ .kind=10, .length=3,},
+	{ .kind=11, .length=1,},		/* CC: Suppose 1 */
+	{ .kind=12, .length=1,},		/* the same */
+	{ .kind=13, .length=1,},		/* and here too */
+	{ .kind=14, .length=3,},
+	{ .kind=15, .length=1,},		/* TCP Alternate Checksum Data. Length is not defined */
+	{ .kind=16, .length=1,},
+	{ .kind=17, .length=1,},
+	{ .kind=18, .length=3,},
+	{ .kind=19, .length=18,},
+	{ .kind=20, .length=1,},
+	{ .kind=21, .length=1,},
+	{ .kind=22, .length=1,},
+	{ .kind=23, .length=1,},
+	{ .kind=24, .length=1,},
+	{ .kind=25, .length=1,},
+	{ .kind=26, .length=1,},
+};
+
+static FILE *osf_log_stream;
+
+static void uloga(const char *f, ...)
+{
+	va_list ap;
+
+	if (!osf_log_stream)
+		osf_log_stream = stdout;
+
+	va_start(ap, f);
+	vfprintf(osf_log_stream, f, ap);
+	va_end(ap);
+
+	fflush(osf_log_stream);
+}
+
+static void ulog(const char *f, ...)
+{
+	char str[64];
+	struct tm tm;
+	struct timeval tv;
+	va_list ap;
+
+	if (!osf_log_stream)
+		osf_log_stream = stdout;
+
+	gettimeofday(&tv, NULL);
+	localtime_r((time_t *)&tv.tv_sec, &tm);
+	strftime(str, sizeof(str), "%F %R:%S", &tm);
+
+	fprintf(osf_log_stream, "%s.%lu %ld ", str, tv.tv_usec, syscall(__NR_gettid));
+
+	va_start(ap, f);
+	vfprintf(osf_log_stream, f, ap);
+	va_end(ap);
+
+	fflush(osf_log_stream);
+}
+
+#define ulog_err(f, a...) uloga(f ": %s [%d].\n", ##a, strerror(errno), errno)
+
+static char *xt_osf_strchr(char *ptr, char c)
+{
+	char *tmp;
+
+	tmp = strchr(ptr, c);
+	if (tmp)
+		*tmp = '\0';
+
+	while (tmp && tmp + 1 && isspace(*(tmp + 1)))
+		tmp++;
+
+	return tmp;
+}
+
+static void xt_osf_parse_opt(struct xt_osf_opt *opt, __u16 *optnum, char *obuf, int olen)
+{
+	int i, op;
+	char *ptr, wc;
+	unsigned long val;
+
+	ptr = &obuf[0];
+	i = 0;
+	while (ptr != NULL && i < olen && *ptr != 0) {
+		val = 0;
+		op = 0;
+		wc = OSF_WSS_PLAIN;
+		switch (obuf[i]) {
+		case 'N':
+			op = OSFOPT_NOP;
+			ptr = xt_osf_strchr(&obuf[i], OPTDEL);
+			if (ptr) {
+				*ptr = '\0';
+				ptr++;
+				i += (int)(ptr - &obuf[i]);
+			} else
+				i++;
+			break;
+		case 'S':
+			op = OSFOPT_SACKP;
+			ptr = xt_osf_strchr(&obuf[i], OPTDEL);
+			if (ptr) {
+				*ptr = '\0';
+				ptr++;
+				i += (int)(ptr - &obuf[i]);
+			} else
+				i++;
+			break;
+		case 'T':
+			op = OSFOPT_TS;
+			ptr = xt_osf_strchr(&obuf[i], OPTDEL);
+			if (ptr) {
+				*ptr = '\0';
+				ptr++;
+				i += (int)(ptr - &obuf[i]);
+			} else
+				i++;
+			break;
+		case 'W':
+			op = OSFOPT_WSO;
+			ptr = xt_osf_strchr(&obuf[i], OPTDEL);
+			if (ptr) {
+				switch (obuf[i + 1]) {
+				case '%':
+					wc = OSF_WSS_MODULO;
+					break;
+				case 'S':
+					wc = OSF_WSS_MSS;
+					break;
+				case 'T':
+					wc = OSF_WSS_MTU;
+					break;
+				default:
+					wc = OSF_WSS_PLAIN;
+					break;
+				}
+
+				*ptr = '\0';
+				ptr++;
+				if (wc)
+					val = strtoul(&obuf[i + 2], NULL, 10);
+				else
+					val = strtoul(&obuf[i + 1], NULL, 10);
+				i += (int)(ptr - &obuf[i]);
+
+			} else
+				i++;
+			break;
+		case 'M':
+			op = OSFOPT_MSS;
+			ptr = xt_osf_strchr(&obuf[i], OPTDEL);
+			if (ptr) {
+				if (obuf[i + 1] == '%')
+					wc = OSF_WSS_MODULO;
+				*ptr = '\0';
+				ptr++;
+				if (wc)
+					val = strtoul(&obuf[i + 2], NULL, 10);
+				else
+					val = strtoul(&obuf[i + 1], NULL, 10);
+				i += (int)(ptr - &obuf[i]);
+			} else
+				i++;
+			break;
+		case 'E':
+			op = OSFOPT_EOL;
+			ptr = xt_osf_strchr(&obuf[i], OPTDEL);
+			if (ptr) {
+				*ptr = '\0';
+				ptr++;
+				i += (int)(ptr - &obuf[i]);
+			} else
+				i++;
+			break;
+		default:
+			op = OSFOPT_EMPTY;
+			ptr = xt_osf_strchr(&obuf[i], OPTDEL);
+			if (ptr) {
+				ptr++;
+				i += (int)(ptr - &obuf[i]);
+			} else
+				i++;
+			break;
+		}
+
+		if (op != OSFOPT_EMPTY) {
+			opt[*optnum].kind = IANA_opts[op].kind;
+			opt[*optnum].length = IANA_opts[op].length;
+			opt[*optnum].wc.wc = wc;
+			opt[*optnum].wc.val = val;
+			(*optnum)++;
+		}
+	}
+}
+
+static int osf_load_line(char *buffer, int len, int del)
+{
+	int i, cnt = 0;
+	char obuf[MAXOPTSTRLEN];
+	struct xt_osf_user_finger f;
+	char *pbeg, *pend;
+	char buf[NFNL_HEADER_LEN + NFA_LENGTH(sizeof(struct xt_osf_user_finger))];
+	struct nlmsghdr *nmh = (struct nlmsghdr *) buf;
+
+	memset(&f, 0, sizeof(struct xt_osf_user_finger));
+
+	ulog("Loading '%s'.\n", buffer);
+
+	for (i = 0; i < len && buffer[i] != '\0'; ++i) {
+		if (buffer[i] == ':')
+			cnt++;
+	}
+
+	if (cnt != 8) {
+		ulog("Wrong input line '%s': cnt: %d, must be 8, i: %d, must be %d.\n", buffer, cnt, i, len);
+		return -EINVAL;
+	}
+
+	memset(obuf, 0, sizeof(obuf));
+
+	pbeg = buffer;
+	pend = xt_osf_strchr(pbeg, OSFPDEL);
+	if (pend) {
+		*pend = '\0';
+		if (pbeg[0] == 'S') {
+			f.wss.wc = OSF_WSS_MSS;
+			if (pbeg[1] == '%')
+				f.wss.val = strtoul(&pbeg[2], NULL, 10);
+			else if (pbeg[1] == '*')
+				f.wss.val = 0;
+			else
+				f.wss.val = strtoul(&pbeg[1], NULL, 10);
+		} else if (pbeg[0] == 'T') {
+			f.wss.wc = OSF_WSS_MTU;
+			if (pbeg[1] == '%')
+				f.wss.val = strtoul(&pbeg[2], NULL, 10);
+			else if (pbeg[1] == '*')
+				f.wss.val = 0;
+			else
+				f.wss.val = strtoul(&pbeg[1], NULL, 10);
+		} else if (pbeg[0] == '%') {
+			f.wss.wc = OSF_WSS_MODULO;
+			f.wss.val = strtoul(&pbeg[1], NULL, 10);
+		} else if (isdigit(pbeg[0])) {
+			f.wss.wc = OSF_WSS_PLAIN;
+			f.wss.val = strtoul(&pbeg[0], NULL, 10);
+		}
+
+		pbeg = pend + 1;
+	}
+	pend = xt_osf_strchr(pbeg, OSFPDEL);
+	if (pend) {
+		*pend = '\0';
+		f.ttl = strtoul(pbeg, NULL, 10);
+		pbeg = pend + 1;
+	}
+	pend = xt_osf_strchr(pbeg, OSFPDEL);
+	if (pend) {
+		*pend = '\0';
+		f.df = strtoul(pbeg, NULL, 10);
+		pbeg = pend + 1;
+	}
+	pend = xt_osf_strchr(pbeg, OSFPDEL);
+	if (pend) {
+		*pend = '\0';
+		f.ss = strtoul(pbeg, NULL, 10);
+		pbeg = pend + 1;
+	}
+
+	pend = xt_osf_strchr(pbeg, OSFPDEL);
+	if (pend) {
+		*pend = '\0';
+		cnt = snprintf(obuf, sizeof(obuf), "%s,", pbeg);
+		pbeg = pend + 1;
+	}
+
+	pend = xt_osf_strchr(pbeg, OSFPDEL);
+	if (pend) {
+		*pend = '\0';
+		if (pbeg[0] == '@' || pbeg[0] == '*')
+			cnt = snprintf(f.genre, sizeof(f.genre), "%s", pbeg + 1);
+		else
+			cnt = snprintf(f.genre, sizeof(f.genre), "%s", pbeg);
+		pbeg = pend + 1;
+	}
+
+	pend = xt_osf_strchr(pbeg, OSFPDEL);
+	if (pend) {
+		*pend = '\0';
+		cnt = snprintf(f.version, sizeof(f.version), "%s", pbeg);
+		pbeg = pend + 1;
+	}
+
+	pend = xt_osf_strchr(pbeg, OSFPDEL);
+	if (pend) {
+		*pend = '\0';
+		cnt =
+		    snprintf(f.subtype, sizeof(f.subtype), "%s", pbeg);
+		pbeg = pend + 1;
+	}
+
+	xt_osf_parse_opt(f.opt, &f.opt_num, obuf, sizeof(obuf));
+
+	memset(buf, 0, sizeof(buf));
+
+	if (del)
+		nfnl_fill_hdr(nfnlssh, nmh, 0, AF_UNSPEC, 0, OSF_MSG_REMOVE, NLM_F_REQUEST);
+	else
+		nfnl_fill_hdr(nfnlssh, nmh, 0, AF_UNSPEC, 0, OSF_MSG_ADD, NLM_F_REQUEST | NLM_F_CREATE);
+
+	nfnl_addattr_l(nmh, sizeof(buf), OSF_ATTR_FINGER, &f, sizeof(struct xt_osf_user_finger));
+
+	return nfnl_talk(nfnlh, nmh, 0, 0, NULL, NULL, NULL);
+}
+
+static int osf_load_entries(char *path, int del)
+{
+	FILE *inf;
+	int err = 0;
+	char buf[1024];
+
+	inf = fopen(path, "r");
+	if (!inf) {
+		ulog_err("Failed to open file '%s'", path);
+		return -1;
+	}
+
+	while(fgets(buf, sizeof(buf), inf)) {
+		int len;
+
+		if (buf[0] == '#' || buf[0] == '\n' || buf[0] == '\r')
+			continue;
+
+		len = strlen(buf) - 1;
+
+		if (len <= 0)
+			continue;
+
+		buf[len] = '\0';
+
+		err = osf_load_line(buf, len, del);
+		if (err)
+			break;
+
+		memset(buf, 0, sizeof(buf));
+	}
+
+	fclose(inf);
+	return err;
+}
+
+int main(int argc, char *argv[])
+{
+	int ch, del = 0, err;
+	char *fingerprints = NULL;
+
+	while ((ch = getopt(argc, argv, "f:dh")) != -1) {
+		switch (ch) {
+			case 'f':
+				fingerprints = optarg;
+				break;
+			case 'd':
+				del = 1;
+				break;
+			default:
+				fprintf(stderr,
+					"Usage: %s -f fingerprints -d <del rules> -h\n",
+					argv[0]);
+				return -1;
+		}
+	}
+
+	if (!fingerprints) {
+		err = -ENOENT;
+		goto err_out_exit;
+	}
+
+	nfnlh = nfnl_open();
+	if (!nfnlh) {
+		err = -EINVAL;
+		ulog_err("Failed to create nfnl handler");
+		goto err_out_exit;
+	}
+
+#ifndef NFNL_SUBSYS_OSF
+#define NFNL_SUBSYS_OSF	5
+#endif
+
+	nfnlssh = nfnl_subsys_open(nfnlh, NFNL_SUBSYS_OSF, OSF_MSG_MAX, 0);
+	if (!nfnlssh) {
+		err = -EINVAL;
+		ulog_err("Faied to create nfnl subsystem");
+		goto err_out_close;
+	}
+
+	err = osf_load_entries(fingerprints, del);
+	if (err)
+		goto err_out_close_subsys;
+
+	nfnl_subsys_close(nfnlssh);
+	nfnl_close(nfnlh);
+
+	return 0;
+
+err_out_close_subsys:
+	nfnl_subsys_close(nfnlssh);
+err_out_close:
+	nfnl_close(nfnlh);
+err_out_exit:
+	return err;
+}
diff --git a/utils/pf.os b/utils/pf.os
new file mode 100644
index 0000000..44e0014
--- /dev/null
+++ b/utils/pf.os
@@ -0,0 +1,687 @@
+# $OpenBSD: pf.os,v 1.20 2006/06/02 16:54:34 david Exp $
+# passive OS fingerprinting
+# -------------------------
+#
+# SYN signatures. Those signatures work for SYN packets only (duh!).
+#
+# (C) Copyright 2000-2003 by Michal Zalewski <lcamtuf@coredump.cx>
+# (C) Copyright 2003 by Mike Frantzen <frantzen@w4g.org>
+#
+#  Permission to use, copy, modify, and distribute this software for any
+#  purpose with or without fee is hereby granted, provided that the above
+#  copyright notice and this permission notice appear in all copies.
+#
+#  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+#  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+#  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+#  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+#  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+#  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+#  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+#
+#
+# This fingerprint database is adapted from Michal Zalewski's p0f passive
+# operating system package.  The last database sync was from a Nov 3 2003
+# p0f.fp.
+#
+#
+# Each line in this file specifies a single fingerprint. Please read the
+# information below carefully before attempting to append any signatures
+# reported as UNKNOWN to this file to avoid mistakes.
+#
+# We use the following set metrics for fingerprinting:
+#
+# - Window size (WSS) - a highly OS dependent setting used for TCP/IP
+#   performance control (max. amount of data to be sent without ACK).
+#   Some systems use a fixed value for initial packets. On other
+#   systems, it is a multiple of MSS or MTU (MSS+40). In some rare
+#   cases, the value is just arbitrary.
+#
+#   NEW SIGNATURE: if p0f reported a special value of 'Snn', the number
+#   appears to be a multiple of MSS (MSS*nn); a special value of 'Tnn'
+#   means it is a multiple of MTU ((MSS+40)*nn). Unless you notice the
+#   value of nn is not fixed (unlikely), just copy the Snn or Tnn token
+#   literally. If you know this device has a simple stack and a fixed
+#   MTU, you can however multiply S value by MSS, or T value by MSS+40,
+#   and put it instead of Snn or Tnn.
+#
+#   If WSS otherwise looks like a fixed value (for example a multiple
+#   of two), or if you can confirm the value is fixed, please quote
+#   it literally. If there's no apparent pattern in WSS chosen, you
+#   should consider wildcarding this value.
+#
+# - Overall packet size - a function of all IP and TCP options and bugs.
+#
+#   NEW SIGNATURE: Copy this value literally.
+#
+# - Initial TTL - We check the actual TTL of a received packet. It can't
+#   be higher than the initial TTL, and also shouldn't be dramatically
+#   lower (maximum distance is defined as 40 hops).
+#
+#   NEW SIGNATURE: *Never* copy TTL from a p0f-reported signature literally.
+#   You need to determine the initial TTL. The best way to do it is to
+#   check the documentation for a remote system, or check its settings.
+#   A fairly good method is to simply round the observed TTL up to
+#   32, 64, 128, or 255, but it should be noted that some obscure devices
+#   might not use round TTLs (in particular, some shoddy appliances use
+#   "original" initial TTL settings). If not sure, you can see how many
+#   hops you're away from the remote party with traceroute or mtr.
+#
+# - Don't fragment flag (DF) - some modern OSes set this to implement PMTU
+#   discovery. Others do not bother.
+#
+#   NEW SIGNATURE: Copy this value literally.
+#
+# - Maximum segment size (MSS) - this setting is usually link-dependent. P0f
+#   uses it to determine link type of the remote host.
+#
+#   NEW SIGNATURE: Always wildcard this value, except for rare cases when
+#   you have an appliance with a fixed value, know the system supports only
+#   a very limited number of network interface types, or know the system
+#   is using a value it pulled out of nowhere.  Specific unique MSS
+#   can be used to tell Google crawlbots from the rest of the population.
+#
+# - Window scaling (WSCALE) - this feature is used to scale WSS.
+#   It extends the size of a TCP/IP window to 32 bits. Some modern
+#   systems implement this feature.
+#
+#   NEW SIGNATURE: Observe several signatures. Initial WSCALE is often set
+#   to zero or other low value. There's usually no need to wildcard this
+#   parameter.
+#
+# - Timestamp - some systems that implement timestamps set them to
+#   zero in the initial SYN. This case is detected and handled appropriately.
+#
+# - Selective ACK permitted - a flag set by systems that implement
+#   selective ACK functionality.
+#
+# - The sequence of TCP all options (MSS, window scaling, selective ACK
+#   permitted, timestamp, NOP). Other than the options previously
+#   discussed, p0f also checks for timestamp option (a silly
+#   extension to broadcast your uptime ;-), NOP options (used for
+#   header padding) and sackOK option (selective ACK feature).
+#
+#   NEW SIGNATURE: Copy the sequence literally.
+#
+# To wildcard any value (except for initial TTL or TCP options), replace
+# it with '*'. You can also use a modulo operator to match any values
+# that divide by nnn - '%nnn'.
+#
+# Fingerprint entry format:
+#
+# wwww:ttt:D:ss:OOO...:OS:Version:Subtype:Details
+#
+# wwww     - window size (can be *, %nnn, Snn or Tnn).  The special values
+#            "S" and "T" which are a multiple of MSS or a multiple of MTU
+#            respectively.
+# ttt      - initial TTL
+# D        - don't fragment bit (0 - not set, 1 - set)
+# ss       - overall SYN packet size
+# OOO      - option value and order specification (see below)
+# OS       - OS genre (Linux, Solaris, Windows)
+# Version  - OS Version (2.0.27 on x86, etc)
+# Subtype  - OS subtype or patchlevel (SP3, lo0)
+# details  - Generic OS details
+#
+# If OS genre starts with '*', p0f will not show distance, link type
+# and timestamp data. It is useful for userland TCP/IP stacks of
+# network scanners and so on, where many settings are randomized or
+# bogus.
+#
+# If OS genre starts with @, it denotes an approximate hit for a group
+# of operating systems (signature reporting still enabled in this case).
+# Use this feature at the end of this file to catch cases for which
+# you don't have a precise match, but can tell it's Windows or FreeBSD
+# or whatnot by looking at, say, flag layout alone.
+#
+# Option block description is a list of comma or space separated
+# options in the order they appear in the packet:
+#
+# N	   - NOP option
+# Wnnn	   - window scaling option, value nnn (or * or %nnn)
+# Mnnn	   - maximum segment size option, value nnn (or * or %nnn)
+# S	   - selective ACK OK
+# T	   - timestamp
+# T0	   - timestamp with a zero value
+#
+# To denote no TCP options, use a single '.'.
+#
+# Please report any additions to this file, or any inaccuracies or
+# problems spotted, to the maintainers: lcamtuf@coredump.cx,
+# frantzen@openbsd.org and bugs@openbsd.org with a tcpdump packet
+# capture of the relevant SYN packet(s)
+#
+# A test and submission page is available at
+# http://lcamtuf.coredump.cx/p0f-help/
+#
+#
+# WARNING WARNING WARNING
+# -----------------------
+#
+# Do not add a system X as OS Y just because NMAP says so. It is often
+# the case that X is a NAT firewall. While nmap is talking to the
+# device itself, p0f is fingerprinting the guy behind the firewall
+# instead.
+#
+# When in doubt, use common sense, don't add something that looks like
+# a completely different system as Linux or FreeBSD or LinkSys router.
+# Check DNS name, establish a connection to the remote host and look
+# at SYN+ACK - does it look similar?
+#
+# Some users tweak their TCP/IP settings - enable or disable RFC1323
+# functionality, enable or disable timestamps or selective ACK,
+# disable PMTU discovery, change MTU and so on. Always compare a new rule
+# to other fingerprints for this system, and verify the system isn't
+# "customized" before adding it. It is OK to add signature variants
+# caused by a commonly used software (personal firewalls, security
+# packages, etc), but it makes no sense to try to add every single
+# possible /proc/sys/net/ipv4 tweak on Linux or so.
+#
+# KEEP IN MIND: Some packet firewalls configured to normalize outgoing
+# traffic (OpenBSD pf with "scrub" enabled, for example) will, well,
+# normalize packets. Signatures will not correspond to the originating
+# system (and probably not quite to the firewall either).
+#
+# NOTE: Try to keep this file in some reasonable order, from most to
+# least likely systems. This will speed up operation. Also keep most
+# generic and broad rules near the end.
+#
+
+##########################
+# Standard OS signatures #
+##########################
+
+# ----------------- AIX ---------------------
+
+# AIX is first because its signatures are close to NetBSD, MacOS X and
+# Linux 2.0, but it uses a fairly rare MSSes, at least sometimes...
+# This is a shoddy hack, though.
+
+45046:64:0:44:M*:		AIX:4.3::AIX 4.3
+16384:64:0:44:M512:		AIX:4.3:2-3:AIX 4.3.2 and earlier
+
+16384:64:0:60:M512,N,W%2,N,N,T:		AIX:4.3:3:AIX 4.3.3-5.2
+16384:64:0:60:M512,N,W%2,N,N,T:		AIX:5.1-5.2::AIX 4.3.3-5.2
+32768:64:0:60:M512,N,W%2,N,N,T:		AIX:4.3:3:AIX 4.3.3-5.2
+32768:64:0:60:M512,N,W%2,N,N,T:		AIX:5.1-5.2::AIX 4.3.3-5.2
+65535:64:0:60:M512,N,W%2,N,N,T:		AIX:4.3:3:AIX 4.3.3-5.2
+65535:64:0:60:M512,N,W%2,N,N,T:		AIX:5.1-5.2::AIX 4.3.3-5.2
+65535:64:0:64:M*,N,W1,N,N,T,N,N,S:	AIX:5.3:ML1:AIX 5.3 ML1
+
+# ----------------- Linux -------------------
+
+# S1:64:0:44:M*:A:		Linux:1.2::Linux 1.2.x (XXX quirks support)
+512:64:0:44:M*:			Linux:2.0:3x:Linux 2.0.3x
+16384:64:0:44:M*:		Linux:2.0:3x:Linux 2.0.3x
+
+# Endian snafu! Nelson says "ha-ha":
+2:64:0:44:M*:			Linux:2.0:3x:Linux 2.0.3x (MkLinux) on Mac
+64:64:0:44:M*:			Linux:2.0:3x:Linux 2.0.3x (MkLinux) on Mac
+
+
+S4:64:1:60:M1360,S,T,N,W0:	Linux:google::Linux (Google crawlbot)
+
+S2:64:1:60:M*,S,T,N,W0:		Linux:2.4::Linux 2.4 (big boy)
+S3:64:1:60:M*,S,T,N,W0:		Linux:2.4:.18-21:Linux 2.4.18 and newer
+S4:64:1:60:M*,S,T,N,W0:		Linux:2.4::Linux 2.4/2.6 <= 2.6.7
+S4:64:1:60:M*,S,T,N,W0:		Linux:2.6:.1-7:Linux 2.4/2.6 <= 2.6.7
+S4:64:1:60:M*,S,T,N,W7:		Linux:2.6:8:Linux 2.6.8 and newer (?)
+
+S3:64:1:60:M*,S,T,N,W1:		Linux:2.5::Linux 2.5 (sometimes 2.4)
+S4:64:1:60:M*,S,T,N,W1:		Linux:2.5-2.6::Linux 2.5/2.6
+S3:64:1:60:M*,S,T,N,W2:		Linux:2.5::Linux 2.5 (sometimes 2.4)
+S4:64:1:60:M*,S,T,N,W2:		Linux:2.5::Linux 2.5 (sometimes 2.4)
+
+S20:64:1:60:M*,S,T,N,W0:	Linux:2.2:20-25:Linux 2.2.20 and newer
+S22:64:1:60:M*,S,T,N,W0:	Linux:2.2::Linux 2.2
+S11:64:1:60:M*,S,T,N,W0:	Linux:2.2::Linux 2.2
+
+# Popular cluster config scripts disable timestamps and
+# selective ACK:
+S4:64:1:48:M1460,N,W0:		Linux:2.4:cluster:Linux 2.4 in cluster
+
+# This needs to be investigated. On some systems, WSS
+# is selected as a multiple of MTU instead of MSS. I got
+# many submissions for this for many late versions of 2.4:
+T4:64:1:60:M1412,S,T,N,W0:	Linux:2.4::Linux 2.4 (late, uncommon)
+
+# This happens only over loopback, but let's make folks happy:
+32767:64:1:60:M16396,S,T,N,W0:	Linux:2.4:lo0:Linux 2.4 (local)
+S8:64:1:60:M3884,S,T,N,W0:	Linux:2.2:lo0:Linux 2.2 (local)
+
+# Opera visitors:
+16384:64:1:60:M*,S,T,N,W0:	Linux:2.2:Opera:Linux 2.2 (Opera?)
+32767:64:1:60:M*,S,T,N,W0:	Linux:2.4:Opera:Linux 2.4 (Opera?)
+
+# Some fairly common mods:
+S4:64:1:52:M*,N,N,S,N,W0:	Linux:2.4:ts:Linux 2.4 w/o timestamps
+S22:64:1:52:M*,N,N,S,N,W0:	Linux:2.2:ts:Linux 2.2 w/o timestamps
+
+
+# ----------------- FreeBSD -----------------
+
+16384:64:1:44:M*:		FreeBSD:2.0-2.2::FreeBSD 2.0-4.2
+16384:64:1:44:M*:		FreeBSD:3.0-3.5::FreeBSD 2.0-4.2
+16384:64:1:44:M*:		FreeBSD:4.0-4.2::FreeBSD 2.0-4.2
+16384:64:1:60:M*,N,W0,N,N,T:	FreeBSD:4.4::FreeBSD 4.4
+
+1024:64:1:60:M*,N,W0,N,N,T:	FreeBSD:4.4::FreeBSD 4.4
+
+57344:64:1:44:M*:		FreeBSD:4.6-4.8:noRFC1323:FreeBSD 4.6-4.8 (no RFC1323)
+57344:64:1:60:M*,N,W0,N,N,T:	FreeBSD:4.6-4.9::FreeBSD 4.6-4.9
+
+32768:64:1:60:M*,N,W0,N,N,T:	FreeBSD:4.8-4.11::FreeBSD 4.8-5.1 (or MacOS X)
+32768:64:1:60:M*,N,W0,N,N,T:	FreeBSD:5.0-5.1::FreeBSD 4.8-5.1 (or MacOS X)
+65535:64:1:60:M*,N,W0,N,N,T:	FreeBSD:4.8-4.11::FreeBSD 4.8-5.2 (or MacOS X)
+65535:64:1:60:M*,N,W0,N,N,T:	FreeBSD:5.0-5.2::FreeBSD 4.8-5.2 (or MacOS X)
+65535:64:1:60:M*,N,W1,N,N,T:	FreeBSD:4.7-4.11::FreeBSD 4.7-5.2
+65535:64:1:60:M*,N,W1,N,N,T:	FreeBSD:5.0-5.2::FreeBSD 4.7-5.2
+
+# XXX need quirks support
+# 65535:64:1:60:M*,N,W0,N,N,T:Z:FreeBSD:5.1-5.4::5.1-current (1)
+# 65535:64:1:60:M*,N,W1,N,N,T:Z:FreeBSD:5.1-5.4::5.1-current (2)
+# 65535:64:1:60:M*,N,W2,N,N,T:Z:FreeBSD:5.1-5.4::5.1-current (3)
+# 65535:64:1:44:M*:Z:FreeBSD:5.2::FreeBSD 5.2 (no RFC1323)
+
+# 16384:64:1:60:M*,N,N,N,N,N,N,T:FreeBSD:4.4:noTS:FreeBSD 4.4 (w/o timestamps)
+
+# ----------------- NetBSD ------------------
+
+16384:64:0:60:M*,N,W0,N,N,T:	NetBSD:1.3::NetBSD 1.3
+65535:64:0:60:M*,N,W0,N,N,T0:	NetBSD:1.6:opera:NetBSD 1.6 (Opera)
+16384:64:0:60:M*,N,W0,N,N,T0:	NetBSD:1.6::NetBSD 1.6
+16384:64:1:60:M*,N,W0,N,N,T0:	NetBSD:1.6:df:NetBSD 1.6 (DF)
+65535:64:1:60:M*,N,W1,N,N,T0:	NetBSD:1.6::NetBSD 1.6W-current (DF)
+65535:64:1:60:M*,N,W0,N,N,T0:	NetBSD:1.6::NetBSD 1.6X (DF)
+32768:64:1:60:M*,N,W0,N,N,T0:	NetBSD:1.6:randomization:NetBSD 1.6ZH-current (w/ ip_id randomization)
+
+# ----------------- OpenBSD -----------------
+
+16384:64:0:60:M*,N,W0,N,N,T:		OpenBSD:2.6::NetBSD 1.3 (or OpenBSD 2.6)
+16384:64:1:64:M*,N,N,S,N,W0,N,N,T:	OpenBSD:3.0-3.9::OpenBSD 3.0-3.9
+16384:64:0:64:M*,N,N,S,N,W0,N,N,T:	OpenBSD:3.0-3.9:no-df:OpenBSD 3.0-3.9 (scrub no-df)
+57344:64:1:64:M*,N,N,S,N,W0,N,N,T:	OpenBSD:3.3-3.9::OpenBSD 3.3-3.9
+57344:64:0:64:M*,N,N,S,N,W0,N,N,T:	OpenBSD:3.3-3.9:no-df:OpenBSD 3.3-3.9 (scrub no-df)
+
+65535:64:1:64:M*,N,N,S,N,W0,N,N,T:	OpenBSD:3.0-3.9:opera:OpenBSD 3.0-3.9 (Opera)
+
+# ----------------- Solaris -----------------
+
+S17:64:1:64:N,W3,N,N,T0,N,N,S,M*:	Solaris:8:RFC1323:Solaris 8 RFC1323
+S17:64:1:48:N,N,S,M*:			Solaris:8::Solaris 8
+S17:255:1:44:M*:			Solaris:2.5-2.7::Solaris 2.5 to 7
+
+S6:255:1:44:M*:				Solaris:2.6-2.7::Solaris 2.6 to 7
+S23:255:1:44:M*:			Solaris:2.5:1:Solaris 2.5.1
+S34:64:1:48:M*,N,N,S:			Solaris:2.9::Solaris 9
+S44:255:1:44:M*:			Solaris:2.7::Solaris 7
+
+4096:64:0:44:M1460:			SunOS:4.1::SunOS 4.1.x
+
+S34:64:1:52:M*,N,W0,N,N,S:		Solaris:10:beta:Solaris 10 (beta)
+32850:64:1:64:M*,N,N,T,N,W1,N,N,S:	Solaris:10::Solaris 10 1203
+
+# ----------------- IRIX --------------------
+
+49152:64:0:44:M*:			IRIX:6.4::IRIX 6.4
+61440:64:0:44:M*:			IRIX:6.2-6.5::IRIX 6.2-6.5
+49152:64:0:52:M*,N,W2,N,N,S:		IRIX:6.5:RFC1323:IRIX 6.5 (RFC1323)
+49152:64:0:52:M*,N,W3,N,N,S:		IRIX:6.5:RFC1323:IRIX 6.5 (RFC1323)
+
+61440:64:0:48:M*,N,N,S:			IRIX:6.5:12-21:IRIX 6.5.12 - 6.5.21
+49152:64:0:48:M*,N,N,S:			IRIX:6.5:15-21:IRIX 6.5.15 - 6.5.21
+
+49152:60:0:64:M*,N,W2,N,N,T,N,N,S:	IRIX:6.5:IP27:IRIX 6.5 IP27
+
+
+# ----------------- Tru64 -------------------
+
+32768:64:1:48:M*,N,W0:			Tru64:4.0::Tru64 4.0 (or OS/2 Warp 4)
+32768:64:0:48:M*,N,W0:			Tru64:5.0::Tru64 5.0
+8192:64:0:44:M1460:			Tru64:5.1:noRFC1323:Tru64 6.1 (no RFC1323) (or QNX 6)
+61440:64:0:48:M*,N,W0:			Tru64:5.1a:JP4:Tru64 v5.1a JP4 (or OpenVMS 7.x on Compaq 5.x stack)
+
+# ----------------- OpenVMS -----------------
+
+6144:64:1:60:M*,N,W0,N,N,T:		OpenVMS:7.2::OpenVMS 7.2 (Multinet 4.4 stack)
+
+# ----------------- MacOS -------------------
+
+# XXX Need EOL tcp opt support
+# S2:255:1:48:M*,W0,E:.:MacOS:8.6 classic
+
+# XXX some of these use EOL too
+16616:255:1:48:M*,W0:			MacOS:7.3-7.6:OTTCP:MacOS 7.3-8.6 (OTTCP)
+16616:255:1:48:M*,W0:			MacOS:8.0-8.6:OTTCP:MacOS 7.3-8.6 (OTTCP)
+16616:255:1:48:M*,N,N,N:		MacOS:8.1-8.6:OTTCP:MacOS 8.1-8.6 (OTTCP)
+32768:255:1:48:M*,W0,N:			MacOS:9.0-9.2::MacOS 9.0-9.2
+65535:255:1:48:M*,N,N,N,N:		MacOS:9.1::MacOS 9.1 (OT 2.7.4)
+65535:64:1:64:M*,N,W0,N,N,T,S,E,E:	MacOS:10::MacOS X
+
+
+# ----------------- Windows -----------------
+
+# Windows TCP/IP stack is a mess. For most recent XP, 2000 and
+# even 98, the pathlevel, not the actual OS version, is more
+# relevant to the signature. They share the same code, so it would
+# seem. Luckily for us, almost all Windows 9x boxes have an
+# awkward MSS of 536, which I use to tell one from another
+# in most difficult cases.
+
+8192:32:1:44:M*:			Windows:3.11::Windows 3.11 (Tucows)
+S44:64:1:64:M*,N,W0,N,N,T0,N,N,S:	Windows:95::Windows 95
+8192:128:1:64:M*,N,W0,N,N,T0,N,N,S:	Windows:95:b:Windows 95b
+
+# There were so many tweaking tools and so many stack versions for
+# Windows 98 it is no longer possible to tell them from each other
+# without some very serious research. Until then, there's an insane
+# number of signatures, for your amusement:
+
+S44:32:1:48:M*,N,N,S:			Windows:98:lowTTL:Windows 98 (low TTL)
+8192:32:1:48:M*,N,N,S:			Windows:98:lowTTL:Windows 98 (low TTL)
+%8192:64:1:48:M536,N,N,S:		Windows:98::Windows 98
+%8192:128:1:48:M536,N,N,S:		Windows:98::Windows 98
+S4:64:1:48:M*,N,N,S:			Windows:98::Windows 98
+S6:64:1:48:M*,N,N,S:			Windows:98::Windows 98
+S12:64:1:48:M*,N,N,S:			Windows:98::Windows 98
+T30:64:1:64:M1460,N,W0,N,N,T0,N,N,S:	Windows:98::Windows 98
+32767:64:1:48:M*,N,N,S:			Windows:98::Windows 98
+37300:64:1:48:M*,N,N,S:			Windows:98::Windows 98
+46080:64:1:52:M*,N,W3,N,N,S:		Windows:98:RFC1323:Windows 98 (RFC1323)
+65535:64:1:44:M*:			Windows:98:noSack:Windows 98 (no sack)
+S16:128:1:48:M*,N,N,S:			Windows:98::Windows 98
+S16:128:1:64:M*,N,W0,N,N,T0,N,N,S:	Windows:98::Windows 98
+S26:128:1:48:M*,N,N,S:			Windows:98::Windows 98
+T30:128:1:48:M*,N,N,S:			Windows:98::Windows 98
+32767:128:1:52:M*,N,W0,N,N,S:		Windows:98::Windows 98
+60352:128:1:48:M*,N,N,S:		Windows:98::Windows 98
+60352:128:1:64:M*,N,W2,N,N,T0,N,N,S:	Windows:98::Windows 98
+
+# What's with 1414 on NT?
+T31:128:1:44:M1414:			Windows:NT:4.0:Windows NT 4.0 SP6a
+64512:128:1:44:M1414:			Windows:NT:4.0:Windows NT 4.0 SP6a
+8192:128:1:44:M*:			Windows:NT:4.0:Windows NT 4.0 (older)
+
+# Windows XP and 2000. Most of the signatures that were
+# either dubious or non-specific (no service pack data)
+# were deleted and replaced with generics at the end.
+
+65535:128:1:48:M*,N,N,S:		Windows:2000:SP4:Windows 2000 SP4, XP SP1
+65535:128:1:48:M*,N,N,S:		Windows:XP:SP1:Windows 2000 SP4, XP SP1
+%8192:128:1:48:M*,N,N,S:		Windows:2000:SP2+:Windows 2000 SP2, XP SP1 (seldom 98 4.10.2222)
+%8192:128:1:48:M*,N,N,S:		Windows:XP:SP1:Windows 2000 SP2, XP SP1 (seldom 98 4.10.2222)
+S20:128:1:48:M*,N,N,S:			Windows:2000::Windows 2000/XP SP3
+S20:128:1:48:M*,N,N,S:			Windows:XP:SP3:Windows 2000/XP SP3
+S45:128:1:48:M*,N,N,S:			Windows:2000:SP4:Windows 2000 SP4, XP SP 1
+S45:128:1:48:M*,N,N,S:			Windows:XP:SP1:Windows 2000 SP4, XP SP 1
+40320:128:1:48:M*,N,N,S:		Windows:2000:SP4:Windows 2000 SP4
+
+S6:128:1:48:M*,N,N,S:			Windows:2000:SP2:Windows XP, 2000 SP2+
+S6:128:1:48:M*,N,N,S:			Windows:XP::Windows XP, 2000 SP2+
+S12:128:1:48:M*,N,N,S:			Windows:XP:SP1:Windows XP SP1
+S44:128:1:48:M*,N,N,S:			Windows:2000:SP3:Windows Pro SP1, 2000 SP3
+S44:128:1:48:M*,N,N,S:			Windows:XP:SP1:Windows Pro SP1, 2000 SP3
+64512:128:1:48:M*,N,N,S:		Windows:2000:SP3:Windows SP1, 2000 SP3
+64512:128:1:48:M*,N,N,S:		Windows:XP:SP1:Windows SP1, 2000 SP3
+32767:128:1:48:M*,N,N,S:		Windows:2000:SP4:Windows SP1, 2000 SP4
+32767:128:1:48:M*,N,N,S:		Windows:XP:SP1:Windows SP1, 2000 SP4
+
+# Odds, ends, mods:
+
+S52:128:1:48:M1260,N,N,S:		Windows:2000:cisco:Windows XP/2000 via Cisco
+S52:128:1:48:M1260,N,N,S:		Windows:XP:cisco:Windows XP/2000 via Cisco
+65520:128:1:48:M*,N,N,S:		Windows:XP::Windows XP bare-bone
+16384:128:1:52:M536,N,W0,N,N,S:		Windows:2000:ZoneAlarm:Windows 2000 w/ZoneAlarm?
+2048:255:0:40:.:			Windows:.NET::Windows .NET Enterprise Server
+
+44620:64:0:48:M*,N,N,S:			Windows:ME::Windows ME no SP (?)
+S6:255:1:48:M536,N,N,S:			Windows:95:winsock2:Windows 95 winsock 2
+32768:32:1:52:M1460,N,W0,N,N,S:		Windows:2003:AS:Windows 2003 AS
+
+
+# No need to be more specific, it passes:
+# *:128:1:48:M*,N,N,S:U:-Windows:XP/2000 while downloading (leak!) XXX quirk
+# there is an equiv similar generic sig w/o the quirk
+
+# ----------------- HP/UX -------------------
+
+32768:64:1:44:M*:			HP-UX:B.10.20::HP-UX B.10.20
+32768:64:0:48:M*,W0,N:			HP-UX:11.0::HP-UX 11.0
+32768:64:1:48:M*,W0,N:			HP-UX:11.10::HP-UX 11.0 or 11.11
+32768:64:1:48:M*,W0,N:			HP-UX:11.11::HP-UX 11.0 or 11.11
+
+# Whoa. Hardcore WSS.
+0:64:0:48:M*,W0,N:			HP-UX:B.11.00:A:HP-UX B.11.00 A (RFC1323)
+
+# ----------------- RiscOS ------------------
+
+# We don't yet support the ?12 TCP option
+#16384:64:1:68:M1460,N,W0,N,N,T,N,N,?12:	RISCOS:3.70-4.36::RISC OS 3.70-4.36
+12288:32:0:44:M536:				RISC OS:3.70:4.10:RISC OS 3.70 inet 4.10
+
+# XXX quirk
+# 4096:64:1:56:M1460,N,N,T:T:			RISC OS:3.70:freenet:RISC OS 3.70 freenet 2.00
+
+
+
+# ----------------- BSD/OS ------------------
+
+# Once again, power of two WSS is also shared by MacOS X with DF set
+8192:64:1:60:M1460,N,W0,N,N,T:		BSD/OS:3.1::BSD/OS 3.1-4.3 (or MacOS X 10.2 w/DF)
+8192:64:1:60:M1460,N,W0,N,N,T:		BSD/OS:4.0-4.3::BSD/OS 3.1-4.3 (or MacOS X 10.2)
+
+
+# ---------------- NewtonOS -----------------
+
+4096:64:0:44:M1420:		NewtonOS:2.1::NewtonOS 2.1
+
+# ---------------- NeXTSTEP -----------------
+
+S4:64:0:44:M1024:		NeXTSTEP:3.3::NeXTSTEP 3.3
+S8:64:0:44:M512:		NeXTSTEP:3.3::NeXTSTEP 3.3
+
+# ------------------ BeOS -------------------
+
+1024:255:0:48:M*,N,W0:		BeOS:5.0-5.1::BeOS 5.0-5.1
+12288:255:0:44:M1402:		BeOS:5.0::BeOS 5.0.x
+
+# ------------------ OS/400 -----------------
+
+8192:64:1:60:M1440,N,W0,N,N,T:	OS/400:VR4::OS/400 VR4/R5
+8192:64:1:60:M1440,N,W0,N,N,T:	OS/400:VR5::OS/400 VR4/R5
+4096:64:1:60:M1440,N,W0,N,N,T:	OS/400:V4R5:CF67032:OS/400 V4R5 + CF67032
+
+# XXX quirk
+# 28672:64:0:44:M1460:A:OS/390:?
+
+# ------------------ ULTRIX -----------------
+
+16384:64:0:40:.:		ULTRIX:4.5::ULTRIX 4.5
+
+# ------------------- QNX -------------------
+
+S16:64:0:44:M512:		QNX:::QNX demodisk
+
+# ------------------ Novell -----------------
+
+16384:128:1:44:M1460:		Novell:NetWare:5.0:Novel Netware 5.0
+6144:128:1:44:M1460:		Novell:IntranetWare:4.11:Novell IntranetWare 4.11
+6144:128:1:44:M1368:		Novell:BorderManager::Novell BorderManager ?
+
+6144:128:1:52:M*,W0,N,S,N,N:	Novell:Netware:6:Novell Netware 6 SP3
+
+
+# ----------------- SCO ------------------
+S3:64:1:60:M1460,N,W0,N,N,T:	SCO:UnixWare:7.1:SCO UnixWare 7.1
+S17:64:1:60:M1380,N,W0,N,N,T:	SCO:UnixWare:7.1:SCO UnixWare 7.1.3 MP3
+S23:64:1:44:M1380:		SCO:OpenServer:5.0:SCO OpenServer 5.0
+
+# ------------------- DOS -------------------
+
+2048:255:0:44:M536:		DOS:WATTCP:1.05:DOS Arachne via WATTCP/1.05
+T2:255:0:44:M984:		DOS:WATTCP:1.05Arachne:Arachne via WATTCP/1.05 (eepro)
+
+# ------------------ OS/2 -------------------
+
+S56:64:0:44:M512:		OS/2:4::OS/2 4
+28672:64:0:44:M1460:		OS/2:4::OS/2 Warp 4.0
+
+# ----------------- TOPS-20 -----------------
+
+# Another hardcore MSS, one of the ACK leakers hunted down.
+# XXX QUIRK 0:64:0:44:M1460:A:TOPS-20:version 7
+0:64:0:44:M1460:		TOPS-20:7::TOPS-20 version 7
+
+# ----------------- FreeMiNT ----------------
+
+S44:255:0:44:M536:		FreeMiNT:1:16A:FreeMiNT 1 patch 16A (Atari)
+
+# ------------------ AMIGA ------------------
+
+# XXX TCP option 12
+# S32:64:1:56:M*,N,N,S,N,N,?12:.:AMIGA:3.9 BB2 with Miami stack
+
+# ------------------ Plan9 ------------------
+
+65535:255:0:48:M1460,W0,N:	Plan9:4::Plan9 edition 4
+
+# ----------------- AMIGAOS -----------------
+
+16384:64:1:48:M1560,N,N,S:	AMIGAOS:3.9::AMIGAOS 3.9 BB2 MiamiDX
+
+###########################################
+# Appliance / embedded / other signatures #
+###########################################
+
+# ---------- Firewalls / routers ------------
+
+S12:64:1:44:M1460:			@Checkpoint:::Checkpoint (unknown 1)
+S12:64:1:48:N,N,S,M1460:		@Checkpoint:::Checkpoint (unknown 2)
+4096:32:0:44:M1460:			ExtremeWare:4.x::ExtremeWare 4.x
+
+# XXX TCP option 12
+# S32:64:0:68:M512,N,W0,N,N,T,N,N,?12:.:Nokia:IPSO w/Checkpoint NG FP3
+# S16:64:0:68:M1024,N,W0,N,N,T,N,N,?12:.:Nokia:IPSO 3.7 build 026
+
+S4:64:1:60:W0,N,S,T,M1460:		FortiNet:FortiGate:50:FortiNet FortiGate 50
+
+8192:64:1:44:M1460:			Eagle:::Eagle Secure Gateway
+
+S52:128:1:48:M1260,N,N,N,N:		LinkSys:WRV54G::LinkSys WRV54G VPN router
+
+
+
+# ------- Switches and other stuff ----------
+
+4128:255:0:44:M*:			Cisco:::Cisco Catalyst 3500, 7500 etc
+S8:255:0:44:M*:				Cisco:12008::Cisco 12008
+60352:128:1:64:M1460,N,W2,N,N,T,N,N,S:	Alteon:ACEswitch::Alteon ACEswitch
+64512:128:1:44:M1370:			Nortel:Contivity Client::Nortel Conectivity Client
+
+
+# ---------- Caches and whatnots ------------
+
+S4:64:1:52:M1460,N,N,S,N,W0:		AOL:web cache::AOL web cache
+
+32850:64:1:64:N,W1,N,N,T,N,N,S,M*:	NetApp:5.x::NetApp Data OnTap 5.x
+16384:64:1:64:M1460,N,N,S,N,W0,N:	NetApp:5.3:1:NetApp 5.3.1
+65535:64:0:64:M1460,N,N,S,N,W*,N,N,T:	NetApp:5.3-5.5::NetApp 5.3-5.5
+65535:64:0:60:M1460,N,W0,N,N,T:		NetApp:CacheFlow::NetApp CacheFlow
+8192:64:1:64:M1460,N,N,S,N,W0,N,N,T:	NetApp:5.2:1:NetApp NetCache 5.2.1
+20480:64:1:64:M1460,N,N,S,N,W0,N,N,T:	NetApp:4.1::NetApp NetCache4.1
+
+65535:64:0:60:M1460,N,W0,N,N,T:		CacheFlow:4.1::CacheFlow CacheOS 4.1
+8192:64:0:60:M1380,N,N,N,N,N,N,T:	CacheFlow:1.1::CacheFlow CacheOS 1.1
+
+S4:64:0:48:M1460,N,N,S:			Cisco:Content Engine::Cisco Content Engine
+
+27085:128:0:40:.:			Dell:PowerApp cache::Dell PowerApp (Linux-based)
+
+65535:255:1:48:N,W1,M1460:		Inktomi:crawler::Inktomi crawler
+S1:255:1:60:M1460,S,T,N,W0:		LookSmart:ZyBorg::LookSmart ZyBorg
+
+16384:255:0:40:.:			Proxyblocker:::Proxyblocker (what's this?)
+
+65535:255:0:48:M*,N,N,S:		Redline:::Redline T|X 2200
+
+32696:128:0:40:M1460:			Spirent:Avalanche::Spirent Web Avalanche HTTP benchmarking engine
+
+# ----------- Embedded systems --------------
+
+S9:255:0:44:M536:			PalmOS:Tungsten:C:PalmOS Tungsten C
+S5:255:0:44:M536:			PalmOS:3::PalmOS 3/4
+S5:255:0:44:M536:			PalmOS:4::PalmOS 3/4
+S4:255:0:44:M536:			PalmOS:3:5:PalmOS 3.5
+2948:255:0:44:M536:			PalmOS:3:5:PalmOS 3.5.3 (Handera)
+S29:255:0:44:M536:			PalmOS:5::PalmOS 5.0
+16384:255:0:44:M1398:			PalmOS:5.2:Clie:PalmOS 5.2 (Clie)
+S14:255:0:44:M1350:			PalmOS:5.2:Treo:PalmOS 5.2.1 (Treo)
+
+S23:64:1:64:N,W1,N,N,T,N,N,S,M1460:	SymbianOS:7::SymbianOS 7
+
+8192:255:0:44:M1460:			SymbianOS:6048::Symbian OS 6048 (Nokia 7650?)
+8192:255:0:44:M536:			SymbianOS:9210::Symbian OS (Nokia 9210?)
+S22:64:1:56:M1460,T,S:			SymbianOS:P800::Symbian OS ? (SE P800?)
+S36:64:1:56:M1360,T,S:			SymbianOS:6600::Symbian OS 60xx (Nokia 6600?)
+
+
+# Perhaps S4?
+5840:64:1:60:M1452,S,T,N,W1:		Zaurus:3.10::Zaurus 3.10
+
+32768:128:1:64:M1460,N,W0,N,N,T0,N,N,S:	PocketPC:2002::PocketPC 2002
+
+S1:255:0:44:M346:			Contiki:1.1:rc0:Contiki 1.1-rc0
+
+4096:128:0:44:M1460:			Sega:Dreamcast:3.0:Sega Dreamcast Dreamkey 3.0
+T5:64:0:44:M536:			Sega:Dreamcast:HKT-3020:Sega Dreamcast HKT-3020 (browser disc 51027)
+S22:64:1:44:M1460:			Sony:PS2::Sony Playstation 2 (SOCOM?)
+
+S12:64:0:44:M1452:			AXIS:5600:v5.64:AXIS Printer Server 5600 v5.64
+
+3100:32:1:44:M1460:			Windows:CE:2.0:Windows CE 2.0
+
+####################
+# Fancy signatures #
+####################
+
+1024:64:0:40:.:				*NMAP:syn scan:1:NMAP syn scan (1)
+2048:64:0:40:.:				*NMAP:syn scan:2:NMAP syn scan (2)
+3072:64:0:40:.:				*NMAP:syn scan:3:NMAP syn scan (3)
+4096:64:0:40:.:				*NMAP:syn scan:4:NMAP syn scan (4)
+
+# Requires quirks support
+# 1024:64:0:40:.:A:*NMAP:TCP sweep probe (1)
+# 2048:64:0:40:.:A:*NMAP:TCP sweep probe (2)
+# 3072:64:0:40:.:A:*NMAP:TCP sweep probe (3)
+# 4096:64:0:40:.:A:*NMAP:TCP sweep probe (4)
+
+1024:64:0:60:W10,N,M265,T:		*NMAP:OS:1:NMAP OS detection probe (1)
+2048:64:0:60:W10,N,M265,T:		*NMAP:OS:2:NMAP OS detection probe (2)
+3072:64:0:60:W10,N,M265,T:		*NMAP:OS:3:NMAP OS detection probe (3)
+4096:64:0:60:W10,N,M265,T:		*NMAP:OS:4:NMAP OS detection probe (4)
+
+32767:64:0:40:.:			*NAST:::NASTsyn scan
+
+# Requires quirks support
+# 12345:255:0:40:.:A:-p0f:sendsyn utility
+
+
+#####################################
+# Generic signatures - just in case #
+#####################################
+
+#*:64:1:60:M*,N,W*,N,N,T:		@FreeBSD:4.0-4.9::FreeBSD 4.x/5.x
+#*:64:1:60:M*,N,W*,N,N,T:		@FreeBSD:5.0-5.1::FreeBSD 4.x/5.x
+
+*:128:1:52:M*,N,W0,N,N,S:		@Windows:XP:RFC1323:Windows XP/2000 (RFC1323 no tstamp)
+*:128:1:52:M*,N,W0,N,N,S:		@Windows:2000:RFC1323:Windows XP/2000 (RFC1323 no tstamp)
+*:128:1:52:M*,N,W*,N,N,S:		@Windows:XP:RFC1323:Windows XP/2000 (RFC1323 no tstamp)
+*:128:1:52:M*,N,W*,N,N,S:		@Windows:2000:RFC1323:Windows XP/2000 (RFC1323 no tstamp)
+*:128:1:64:M*,N,W0,N,N,T0,N,N,S:	@Windows:XP:RFC1323:Windows XP/2000 (RFC1323)
+*:128:1:64:M*,N,W0,N,N,T0,N,N,S:	@Windows:2000:RFC1323:Windows XP/2000 (RFC1323)
+*:128:1:64:M*,N,W*,N,N,T0,N,N,S:	@Windows:XP:RFC1323:Windows XP (RFC1323, w+)
+*:128:1:48:M536,N,N,S:			@Windows:98::Windows 98
+*:128:1:48:M*,N,N,S:			@Windows:XP::Windows XP/2000
+*:128:1:48:M*,N,N,S:			@Windows:2000::Windows XP/2000
+
+
-- 
1.7.0.2

