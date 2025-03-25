Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DDE2E3381
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Mar 2025 01:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742864753; cv=none; b=PSQwgDdXikBDicfNteEcptBGTfXjTZoRUB4/H7EO2RQFYzFjEzUbptbdwNkct3TJlPuQaL+NXCoueAHBIk/9xUF+yMlTC/781DYZ8pc+Ixi24isV4hVPJpRp9/l9g27bz90RathSuvXnNSmgu1ZyyPNM4VmYZgiiM1XqkcxWjBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742864753; c=relaxed/simple;
	bh=ayoAjS8zNWHgxYfwLFLf4pHNmthAk0cNiFLpdcg11dA=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=TNlEjc4Zr3PPOrJ+0tpZGYAtCEMwyh19JE/CdRfaYkLcSw/90YNcOzcOVMSGOcAQYRFLRr+yeqb6THd7K8F5JRCXrtagHNAAhGPH49xqrt1ydnGspNs/wTrRYuA0cEiZdkVEJeitEvh821QToBJoeKoUF9IuOTlnkyqcHTtafNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=iegqrq3h; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="iegqrq3h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1742864748; x=1743469548; i=corubba@gmx.de;
	bh=d8HNSUqstUmAllyzjldFCzsqLqvdTf86WpcksaXt42c=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:From:Subject:
	 Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=iegqrq3h799SW3r9DL/jXrAJuQvNn0FqHQYJK+mRHchY7FNNkMoSmFEJwupcmz4O
	 B09WDWT+lSDwVpE42oIXxEdV5HryASXifoqTeLryrZJcRRtF6hJ0V2nrdw8uxovot
	 DI/l2Jk9/Tm7K/s0IocUCer5t01yPhiO9mKFOsnyzQSpiTg7mGvXHovzZ0rlLvjMo
	 4H2R/RFVZlsNdX+pnL4gHqb9q3RDCmGD2oJ3ci0eAsC6mo7mbb8RE7YQXQCp27Yr7
	 J5PTu9lYl6y9i/CNOlSnZoLbOFEIKENB3am4gX+c5lbzMGWCKXxXn4timcPs9aewk
	 ko2YKW0yEmFx7ZFVxA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from 127.0.0.1 ([83.135.90.83]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MysRu-1tAA2Q0mfa-018HE1 for
 <netfilter-devel@vger.kernel.org>; Tue, 25 Mar 2025 02:05:48 +0100
Message-ID: <c5cd1c3a-3875-4352-8181-5081103f96f6@gmx.de>
Date: Tue, 25 Mar 2025 02:05:47 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Language: de-CH
To: netfilter-devel@vger.kernel.org
From: Corubba Smith <corubba@gmx.de>
Subject: [PATCH ulogd2,v2 1/4] ulogd: add linux namespace helper
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:WOx53CVn1mQU8sRkufreOvX21PbNxl1L5zZK2kLAu3YMOYaUzYx
 aPG03AvdP7BEOdGpl1cpYZxjS59fDsWF7kHsg6YMpF0QAchdSLefQ/M05U0g66fDS5ZXQpe
 0HIxwo1E4vYeyU4Pd7s+VepsZNsKT6tovnyR+pMec6bbFT7CXmWvfmGN9+NB+Cmrg1Hbrv6
 oHfKV8AfLakhvH9oMu0fA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:82/J06A3kFE=;G6I4Cz5MGPfTHaS/EBZO8j19d/G
 opcN+WiFSSB1zONA0+jWKT2Pdi8EDXrnuktuOW+nkU4YP7u+ryFcvorU9Ru8sB0vXMN8Rh2mg
 9hVuEy/RDRnbJH028ykSxFnXhpiUxAnr7tptJhjumfHf1zoxl9BiTGb0UM/p1N+8VbMUVr63J
 IoLFUxWrBp5uCw1sjHjjgG9P8V6rviF/yUAiuyNHO+t45YsxQacr0cFAT3t1RZ/I2dc/3QXvT
 r8zcEtRXSqOCAkF0GlWFKSfuXZYCEiI2t9zbYWgnyzy05iGWYcepDbLqKa72iNPvynMNaITmx
 hy/l0byM+/s2rn3TByPDX8u64CGcibmE/XrGIg6X8UX3SzRq0G6vqguBCRBtvaHZNFuIvsW7S
 gB/NUQ2tN02uc48xONUH5Pz39CBA7z15R6wdSkQqeAAbmdIG/oN/bM4l4vFuyBlBetjBAb90n
 DdX0X2ZUhxWghtd3rjqpIJxttMOGutp3HTlunJzWor2hJAWpykwcYwXLI82ko+A8xRjVjux1g
 wrFSUIZl7+v1FsVJ3923Jnc9kc/n9sV/NVmDPc5niJJfdXjHjIZp/phXHXzj2SArlskMsM9GA
 zTRclgKFoTA+JKz1nZzJnXvNJB/jAUIUDung2+QqNUCzurwao13mx6HpOzDzNOrQpwf8IjF90
 MOJHCRpraRUYm4HA77ensuCCMi/oB6wqGTxoZ1keBpcXSvFLEqfpZgUP2+1KY7L9fGEr8CjY1
 kpzWUIauYlAoHXCKDnh//aZqvAUEq2js4ZzZ5x3ZREg4IXxXdrZerp8GAqxp06+dVNq+2vyUO
 QWAY4r+GANxHtqQ/jLKmWmHowSeRMxBuzFQKX0inqDpDXny1wJ5WMBpg6JwP9XiRtGDZvcxkN
 KO3pCOi4UbwuighxHOkCgoXqL9aS1VYb3j/+bz5NGx1Rb/wNA3jC8nkWGcUlCST+QojjJmNxE
 2l2izw9yh0VC+E2GZLzG0/vE8Pr5Os8hCbf55ihzW9rHMw4Qk+y1YqVadF1y1QH4sx3BvAc7C
 HKTtKXd3gj/ASBv08eGG6f5VP3/PwEorZ1fqDSVgKfUvY06YSWcpxe7/auQnL2xiicQLlSV+p
 WtUUJR3tbKbhR1XLF/XBASlkJqkRdLgHjXTgMSxGFoeI3EBSJOHErcuiQ8sZAJWuVp822yN8M
 7rIbs+wpg2xlz/ThvutAmBy0A6VDi2omGPCiindEDgmWjdDOVQ0ZB/Qsc9u6IiaLvXU3X0Kyt
 ybR4IisTzi+L/9jUod4hfAdAqGxYc4kzlwRB1hTbBCkUPHkwClQXuOdqNQvMgjPvnrKon2mRM
 qxVn54dfgewe+c7wFdWlwGspde9oOsVlm9ivlGtX0epLggp1/ByGg1+5wMiiJ9ARyWJrrl+xr
 9gCXxipFDEiMvsk5iQkNLTQMnH4ss4dRt4+IfWTcNjuoc4QmWN2JDOdoEpWprFND5PMjtWnlq
 f+iivYR1cQKXfyEC+AVVlAprxXzc=

The new namespace helper provides an internal stable interface for
plugins to use for switching various linux namespaces. Currently only
network namespaces are supported/implemented, but can easily be extended
if needed. autoconf will enable it automatically if the required symbols
are available. If ulogd is compiled without namespace support, the
functions will simply return an error, there is no need for conditional
compilation or special handling in plugin code.

Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
Changes in v2:
  - Split the single patch into multiple
  - Moved the namespace code to a dedicated helper (Florian Westphal)
  - Implemented network namespace support for NFCT polling mode, NFLOG
    and NFACCT plugins. I skipped ULOG because it's removed from the
    kernel since 7200135bc1e6 ("netfilter: kill ulog targets") aka v3.17
  - Link to v1: https://lore.kernel.org/netfilter-devel/7d1478b6-ec25-4286=
-a365-ce28293f4a40@gmx.de/

 configure.ac              |  22 ++++
 include/ulogd/Makefile.am |   4 +-
 include/ulogd/namespace.h |   8 ++
 src/Makefile.am           |   3 +-
 src/namespace.c           | 237 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 272 insertions(+), 2 deletions(-)
 create mode 100644 include/ulogd/namespace.h
 create mode 100644 src/namespace.c

diff --git a/configure.ac b/configure.ac
index 3c9249e..2b193d8 100644
=2D-- a/configure.ac
+++ b/configure.ac
@@ -243,6 +243,27 @@ AS_IF([test "x$enable_json" !=3D "xno"],
 AS_IF([test "x$libjansson_LIBS" !=3D "x"], [enable_json=3Dyes], [enable_j=
son=3Dno])
 AM_CONDITIONAL([HAVE_JANSSON], [test "x$libjansson_LIBS" !=3D "x"])

+AC_ARG_ENABLE([namespace],
+              [AS_HELP_STRING([--enable-namespace], [Enable linux namespa=
ce functionality in plugins supporting it [default=3Dtest]])])
+AS_IF([test "x$enable_namespace" !=3D "xno"], [
+  AC_CHECK_DECLS([setns, CLONE_NEWNET], [
+    enable_namespace=3Dyes
+  ], [
+    AS_IF([test "x$enable_namespace" =3D "xyes"], [
+      AC_MSG_ERROR([linux namespace support enabled, but required symbols=
 not available])
+    ], [
+      enable_namespace=3Dno
+    ])
+  ], [[
+    #define _GNU_SOURCE 1
+    #include <fcntl.h>
+    #include <sched.h>
+  ]])
+])
+AS_IF([test "x$enable_namespace" =3D "xyes"], [
+  AC_DEFINE([ENABLE_NAMESPACE], [1], [Define to 1 if you want linux names=
pace support.])
+])
+
 AC_ARG_WITH([ulogd2libdir],
             [AS_HELP_STRING([--with-ulogd2libdir=3DPATH], [Default direct=
ory to load ulogd2 plugin from [[LIBDIR/ulogd]]])],
             [ulogd2libdir=3D"$withval"],
@@ -293,6 +314,7 @@ EXPAND_VARIABLE(ulogd2libdir, e_ulogd2libdir)
 echo "
 Ulogd configuration:
   Default plugins directory:		${e_ulogd2libdir}
+  Linux namespace support:		${enable_namespace}
   Input plugins:
     NFLOG plugin:			${enable_nflog}
     NFCT plugin:			${enable_nfct}
diff --git a/include/ulogd/Makefile.am b/include/ulogd/Makefile.am
index e4b41c4..65d74ba 100644
=2D-- a/include/ulogd/Makefile.am
+++ b/include/ulogd/Makefile.am
@@ -1 +1,3 @@
-noinst_HEADERS =3D conffile.h db.h ipfix_protocol.h linuxlist.h ulogd.h p=
rintpkt.h printflow.h common.h linux_rbtree.h timer.h slist.h hash.h jhash=
.h addr.h
+noinst_HEADERS =3D addr.h common.h conffile.h db.h hash.h ipfix_protocol.=
h \
+                 jhash.h linux_rbtree.h linuxlist.h namespace.h printflow=
.h \
+                 printpkt.h slist.h timer.h ulogd.h
diff --git a/include/ulogd/namespace.h b/include/ulogd/namespace.h
new file mode 100644
index 0000000..48e2e9a
=2D-- /dev/null
+++ b/include/ulogd/namespace.h
@@ -0,0 +1,8 @@
+#ifndef _NAMESPACE_H_
+#define _NAMESPACE_H_
+
+int join_netns_fd(const int target_netns_fd, int *const source_netns_fd_p=
tr);
+int join_netns_path(const char *const target_netns_path,
+                    int *const source_netns_fd_ptr);
+
+#endif
diff --git a/src/Makefile.am b/src/Makefile.am
index 7a12a72..4004c2b 100644
=2D-- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -6,6 +6,7 @@ AM_CPPFLAGS +=3D -DULOGD_CONFIGFILE=3D'"$(sysconfdir)/ulog=
d.conf"' \

 sbin_PROGRAMS =3D ulogd

-ulogd_SOURCES =3D ulogd.c select.c timer.c rbtree.c conffile.c hash.c add=
r.c
+ulogd_SOURCES =3D ulogd.c select.c timer.c rbtree.c conffile.c hash.c \
+                addr.c namespace.c
 ulogd_LDADD   =3D ${libdl_LIBS} ${libpthread_LIBS}
 ulogd_LDFLAGS =3D -export-dynamic
diff --git a/src/namespace.c b/src/namespace.c
new file mode 100644
index 0000000..f9f23d4
=2D-- /dev/null
+++ b/src/namespace.c
@@ -0,0 +1,237 @@
+/* namespace helper
+ *
+ * userspace logging daemon for the netfilter subsystem
+ *
+ * (C) 2025 The netfilter project
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ * Description:
+ *  Helper library to switch linux namespaces, primarily network. Provide=
s
+ *  ulogd-internally a stable api regardless whether namespace support is
+ *  compiled in. Library-internally uses conditional compilation to allow=
 the
+ *  wanted level (full/none) of namespace support. Namespaces can be spec=
ified
+ *  as open file descriptor or file path.
+ */
+
+#include "config.h"
+
+/* Enable GNU extension */
+#define _GNU_SOURCE 1
+
+#include <errno.h>
+#include <fcntl.h>
+#include <sched.h>
+#include <string.h>
+#include <unistd.h>
+
+#include "ulogd/ulogd.h"
+#include "ulogd/namespace.h"
+
+
+#ifdef ENABLE_NAMESPACE
+/**
+ * open_namespace_path() - Open a namespace link by path.
+ * @ns_path: Path of the file to open.
+ *
+ * Effectively just a wrapper around the open() syscall with fixed flags
+ * suitable for namespaces.
+ *
+ * Return: Open fd on success, -1 on error (and set errno).
+ */
+static int open_namespace_path(const char *const ns_path) {
+	return open(ns_path, O_RDONLY | O_CLOEXEC);
+}
+
+/**
+ * SELF_NAMESPACE_PATH() - Path for own current namespace.
+ * @x: Name of the namespace link.
+ *
+ * Return: String-constant of the absolute path to the namespace link.
+ */
+#define SELF_NAMESPACE_PATH(x) "/proc/self/ns/" #x
+
+/**
+ * open_source_namespace() - Get file descriptor to current namespace.
+ * @nstype: Namespace type, use one of the CLONE_NEW* constants.
+ *
+ * Return: Open fd on success, -1 on error.
+ */
+static int open_source_namespace(const int nstype) {
+	const char *ns_path =3D NULL;
+	int ns_fd =3D -1;
+
+	switch (nstype) {
+	case CLONE_NEWNET:
+		ns_path =3D SELF_NAMESPACE_PATH(net);
+		break;
+	default:
+		ulogd_log(ULOGD_FATAL,
+		          "unsupported namespace type: %d\n", nstype);
+		return -1;
+	}
+
+	ns_fd =3D open_namespace_path(ns_path);
+	if (ns_fd < 0) {
+		ulogd_log(ULOGD_FATAL,
+		          "error opening namespace '%s': %s\n",
+		          ns_path, strerror(errno));
+		return -1;
+	}
+
+	return ns_fd;
+}
+#else
+
+/* These constants are used by the nstype-specific functions, and need to=
 be
+ * defined even when no namespace support is available because only the g=
eneric
+ * functions will error.
+ */
+#define CLONE_NEWNET -1
+
+#endif /* ENABLE_NAMESPACE */
+
+/**
+ * join_namespace_fd() - Join a namespace by file descriptor.
+ * @nstype: Namespace type, use one of the CLONE_NEW* constants.
+ * @target_ns_fd: Open file descriptor of the namespace to join. Will be =
closed
+ *                after successful join.
+ * @source_ns_fd_ptr: If not NULL, write an open fd of the previous names=
pace to
+ *                    it if join was successful. May point to negative va=
lue
+ *                    after return.
+ *
+ * Return: ULOGD_IRET_OK on success, ULOGD_IRET_ERR otherwise.
+ */
+static int join_namespace_fd(const int nstype, const int target_ns_fd,
+                             int *const source_ns_fd_ptr)
+{
+#ifdef ENABLE_NAMESPACE
+	if (target_ns_fd < 0) {
+		ulogd_log(ULOGD_DEBUG, "invalid target namespace fd\n");
+		return ULOGD_IRET_ERR;
+	}
+
+	if (source_ns_fd_ptr !=3D NULL) {
+		*source_ns_fd_ptr =3D open_source_namespace(nstype);
+		if (*source_ns_fd_ptr < 0) {
+			ulogd_log(ULOGD_FATAL,
+			          "error opening source namespace\n");
+			return ULOGD_IRET_ERR;
+		}
+	}
+
+	if (setns(target_ns_fd, nstype) < 0) {
+		ulogd_log(ULOGD_FATAL, "error joining target namespace: %s\n",
+		          strerror(errno));
+
+		if (source_ns_fd_ptr !=3D NULL) {
+			if (close(*source_ns_fd_ptr) < 0) {
+				ulogd_log(ULOGD_NOTICE,
+				          "error closing source namespace: %s\n",
+				          strerror(errno));
+			}
+			*source_ns_fd_ptr =3D -1;
+		}
+
+		return ULOGD_IRET_ERR;
+	}
+	ulogd_log(ULOGD_DEBUG, "successfully switched namespace\n");
+
+	if (close(target_ns_fd) < 0) {
+		ulogd_log(ULOGD_NOTICE, "error closing target namespace: %s\n",
+		          strerror(errno));
+	}
+
+	return ULOGD_IRET_OK;
+#else
+	if (source_ns_fd_ptr !=3D NULL) {
+		*source_ns_fd_ptr =3D -1;
+	}
+	ulogd_log(ULOGD_FATAL,
+	          "ulogd was compiled without linux namespace support.\n");
+	return ULOGD_IRET_ERR;
+#endif /* ENABLE_NAMESPACE */
+}
+
+/**
+ * join_namespace_path() - Join a namespace by path.
+ * @nstype: Namespace type, use one of the CLONE_NEW* constants.
+ * @target_ns_path: Path of the namespace to join.
+ * @source_ns_fd_ptr: If not NULL, write an open fd of the previous names=
pace to
+ *                    it if join was successful. May point to negative va=
lue
+ *                    after return.
+ *
+ * Return: ULOGD_IRET_OK on success, ULOGD_IRET_ERR otherwise.
+ */
+static int join_namespace_path(const int nstype, const char *const target=
_ns_path,
+                               int *const source_ns_fd_ptr)
+{
+#ifdef ENABLE_NAMESPACE
+	int target_ns_fd, ret;
+
+	target_ns_fd =3D open_namespace_path(target_ns_path);
+	if (target_ns_fd < 0) {
+		ulogd_log(ULOGD_FATAL, "error opening target namespace: %s\n",
+		          strerror(errno));
+		return ULOGD_IRET_ERR;
+	}
+
+	ret =3D join_namespace_fd(nstype, target_ns_fd, source_ns_fd_ptr);
+	if (ret !=3D ULOGD_IRET_OK) {
+		if (close(target_ns_fd) < 0) {
+			ulogd_log(ULOGD_NOTICE,
+			          "error closing target namespace: %s\n",
+			          strerror(errno));
+		}
+		return ULOGD_IRET_ERR;
+	}
+
+	return ULOGD_IRET_OK;
+#else
+	return join_namespace_fd(nstype, -1, source_ns_fd_ptr);
+#endif /* ENABLE_NAMESPACE */
+}
+
+
+/**
+ * join_netns_fd() - Join a network namespace by file descriptor.
+ * @target_netns_fd: Open file descriptor of the network namespace to joi=
n. Will
+ *                   be closed after successful join.
+ * @source_netns_fd_ptr: If not NULL, write an open fd of the previous ne=
twork
+ *                       namespace to it if join was successful. May poin=
t to
+ *                       negative value after return.
+ *
+ * Return: ULOGD_IRET_OK on success, ULOGD_IRET_ERR otherwise.
+ */
+int join_netns_fd(const int target_netns_fd, int *const source_netns_fd_p=
tr)
+{
+	return join_namespace_fd(CLONE_NEWNET, target_netns_fd,
+	                         source_netns_fd_ptr);
+}
+
+/**
+ * join_netns_path() - Join a network namespace by path.
+ * @target_netns_path: Path of the network namespace to join.
+ * @source_netns_fd_ptr: If not NULL, write an open fd of the previous ne=
twork
+ *                       namespace to it if join was successful. May poin=
t to
+ *                       negative value after return.
+ *
+ * Return: ULOGD_IRET_OK on success, ULOGD_IRET_ERR otherwise.
+ */
+int join_netns_path(const char *const target_netns_path,
+                    int *const source_netns_fd_ptr)
+{
+	return join_namespace_path(CLONE_NEWNET, target_netns_path,
+	                           source_netns_fd_ptr);
+}
=2D-
2.49.0
