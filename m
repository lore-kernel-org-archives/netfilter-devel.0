Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8524219644B
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2025 23:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743030397; cv=none; b=Io0z93XNIgc1mlHVjA8xU8Q9iCNg+kEYdk8y78zGBG7GkvDrFjKhuL5UeLSp56VNUfVsnbbZ7e5MlfXAHaH2d2f9Yj5XWzYOGPS4faFUAaat7NM+MDWYK0bz5nqGzEhys95RTqbbAJlMpFU897lxu8NA+AuLH9xTpPp02HOU7ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743030397; c=relaxed/simple;
	bh=mnEwqb8MKByvt6sSlGPUSrTiDzrpJlKtIN7lNlJk538=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=at7VcneKt3OX6ogRE/6KDzYDYU1RhxUk+uj4/lDFQhXoSdhqE0GbGshwSrLsuc7d9ZR+GSuPoupv73334kkTDsU8V0fHdduMQT9YLv1949AMhEnazCgh3y0F+MubotFb1JQwPP8y9rP6tcsXGCtzRKedNFfrkQNel954qJ6dyxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=LrWgnxVC; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="LrWgnxVC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1743030392; x=1743635192; i=corubba@gmx.de;
	bh=JOueY2aC8Yc6owKAstw3VycIoBE3DJdRnm4RQD7Fwcc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:From:Subject:
	 Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=LrWgnxVCO5Cftnbk4l43zAZHi+zi5T00Cm1hCbj/WiZ8dLnkvVXu8QVngJ+cZnhv
	 RILoNdf2BRqKgGZADGAKVWkzlT3UzePGvaI6YrTzZpHVfyKEKR0x6V79VUnuhtcCT
	 /mlgyRe2Z/0O2MEqECzmlQu57NZey9b+2Npa5PsAM4LUL5ou44wrfmweGsE/qFn4v
	 qZ9OK/Ybg+ql/I8cK/mHRFAQz8/WUC0gH8cVtj5FLRALG6567NlaLqtppyemnSRzY
	 AD17ad665hK2vtdfEM0G/5VylMSF+5D/eKdSUxk6p7vNA+ifu6L4XyuK/OuJgXRLs
	 uTMwdZcd/jKJ4Z1WAw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from 127.0.0.1 ([83.135.90.83]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M2wL0-1tyfky1yXc-004haC for
 <netfilter-devel@vger.kernel.org>; Thu, 27 Mar 2025 00:06:32 +0100
Message-ID: <3f962848-fe38-4869-8422-f54dacc6a9d6@gmx.de>
Date: Thu, 27 Mar 2025 00:06:18 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Language: de-CH
To: netfilter-devel@vger.kernel.org
From: Corubba Smith <corubba@gmx.de>
Subject: [PATCH ulogd2,v3 1/4] ulogd: add linux namespace helper
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:CseZLBMqRPs68eqFWErR5GJr6Oz3l8wPeuXeZMeBsOVu9QJvEu9
 d0gq4+swkcfcjOa77jkl7gNptalAqMPDFqhoJX7kPNwKYhF5NqnES4bFf7/grXTcRUjYXZP
 m1yp8tORxWfd3+uS0Y2OlY8vOMyQ2IXQ43+vawlSj3uupzKzX2MJ1IJdj71l/BjS0koZ2wW
 ig6cdUj31mSwyf/pkXTQw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:y7sk5CXTYdg=;snn05WHTmv8MIbxBh/rWctGdgy4
 a6mgeoV6DTlTeDh3zBVJxmmwMxa5F4Ipte3wGxBW6kJ9LkBt+eFu2dvZKqhnfMm/VgssMU2ej
 1mB+lKWbbsHqfMJ1VfVFxHoP2IZDZAEKe+jedmI9aadxwmyDcd2eg1yrCnYnIYcdNUZ2m3ubE
 krAGbJJ/Jbk2Czaeu9uwedXcrCQrf7QBWCIqqKARXIMZVfwLoflIOB4LPEZzoz3DfjnFnlQoK
 0O6cDWLgbTMC5StPIT/z0OyogUhZWcsUXiySw5uuCsQb9GJlaZvAkuUz0GynbJtOMv4KF13as
 /KdC/3axeN/dAFtd82SGE+W4mgEK5Vc15O6nm0ZBHKJLLU/l6Ha29ZTwvHBbr7nCJX0n/19Wh
 rB7/5JmAebGh63wjcBrGhDrzHYLyXbk58Fo+bCUtlcRWETw/CL7/Vivp8XYG9YFk/zGTK59Id
 lTFI1TbOECTuCcUIW7QdpY7SMbT24DzvmTasR4aSnv13EYVQ+hRSARGHbYnUoD6hQam3XBAYd
 KS0KdFb3OtnemNhwvwC22SeVlbJjLamT1sEpVtc6WHD7sEVVxX2198/BsE6+ZEDt9kGcnfAFG
 amuGEgkvM6gY+nCAozbNOiYWeSX0d/+vffQNyX45kut7C8DeK+u57VnCqYz7LvTwiQL5OLhoe
 v9iK2K2Ib0uhmxUzt0UEdJW8JbtzGHS/e7ZmVbeceeeEnIiVu/xXVkU3Fr2YVCjSUdlogQUPJ
 vTOotSyR8kbleKaoKWnEuZ7j8JDnoTAHFhscjJE4s6ogaof7C1VL+INMfoTrvrWO+pgIkQt17
 0x8LEZmM+mT3Q9ziuv43zO2FkK444sxdfFFWC/IPwTQIhUBmuxPcTN4bIdblu3/LNOG4Q359r
 1Xzyp3eUojyHyfkWFvEN8ox80wdqTHsX3HAp8K1Y1ZjoJjaI0gboOkA0Y0l02hOyN9pKjhowO
 0i1ngDFEEQ7YuWFz9Lk3BQ4J49mHzZqggEzE8nDeRCABMY6m/mk/uV+xpsp484AKCgVVlXJMW
 J/DijjaJjJSFSyck2GaG5CENpKkoDoW7vuatgVFHbULfRM/WWOQiduvSJ7vNKDU3fbxC9fb0W
 N1JCovf7acRwZARCCgUmM5bAM5REZPv26kvpljUa87/fQueIOd3G7S/vJ9amjhKPf8sk9pXCR
 6YdHQiJygrCJ7eJ0KKcWAs7B9vs/oQXwtdudG96dyT+ycd/mCXDPswyMu4HNUpPRmmfldDed1
 aSMH7Rxp+Bd7MIddip1gCGNc+XoZ5Sv+6/UNw5lgdaG43SsUzlu/F2eB2q9sACveCx29zaY40
 T0xIFYesRHI3FZFKCS3gzszDZtKsI5fj/dhqZsHLsqDo3zmjB7e60aipM4sLB0JgDhahiN6co
 1KSK98n59LmMAI1N5YnCZ4qhmUScNDjbuNLBONpq5H+RRm4uoE41nYajpD+1ZsqoHCEmyAQEZ
 7nceBc47U0EQA+SWbviYE5ERJxXs=

The new namespace helper provides an internal stable interface for
plugins to use for switching various linux namespaces. Currently only
network namespaces are supported/implemented, but can easily be extended
if needed. autoconf will enable it automatically if the required symbols
are available. If ulogd is compiled without namespace support, the
functions will simply return an error, there is no need for conditional
compilation or special handling in plugin code.

Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
Changes in v3:
  - Rebased onto master (3461d6da787a ("nfct: add flow end timestamp on ha=
shtable purge"))
  - Replace license boilerplate with SPDX-License-Identifier (Florian West=
phal)
    Feel free to further adjust this to your liking.
  - Add comments about auto-closed fd (Florian Westphal)
  - Add ifndef guard to prevent redefine compiler warning when needed macr=
os are
    available but namespace support explicitly disabled via ./configure
  - Small grammatical corrections to doc comments
  - Link to v2: https://lore.kernel.org/netfilter-devel/c5cd1c3a-3875-4352=
-8181-5081103f96f6@gmx.de/

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
 src/namespace.c           | 224 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 259 insertions(+), 2 deletions(-)
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
index 0000000..d91f1e6
=2D-- /dev/null
+++ b/src/namespace.c
@@ -0,0 +1,224 @@
+// SPDX-License-Identifier: GPL-2.0
+/* ulogd namespace helper
+ *
+ * (C) 2025 The netfilter project
+ *
+ * Helper library to switch linux namespaces, primarily network. Provides
+ * ulogd-internally a stable api regardless whether namespace support is
+ * compiled in. Library-internally uses conditional compilation to allow =
the
+ * wanted level (full/none) of namespace support. Namespaces can be speci=
fied
+ * as open file descriptor or file path.
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
+#ifndef CLONE_NEWNET
+#define CLONE_NEWNET -1
+#endif
+
+#endif /* ENABLE_NAMESPACE */
+
+/**
+ * join_namespace_fd() - Join a namespace by file descriptor.
+ * @nstype: Namespace type, use one of the CLONE_NEW* constants.
+ * @target_ns_fd: Open file descriptor of the namespace to join. Will be =
closed
+ *                after successful join.
+ * @source_ns_fd_ptr: If not NULL, writes an open fd of the previous name=
space
+ *                    to it if join was successful. May point to negative=
 value
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
+ * @source_ns_fd_ptr: If not NULL, writes an open fd of the previous name=
space
+ *                    to it if join was successful. May point to negative=
 value
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
+ * @source_netns_fd_ptr: If not NULL, writes an open fd of the previous n=
etwork
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
+ * @source_netns_fd_ptr: If not NULL, writes an open fd of the previous n=
etwork
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
