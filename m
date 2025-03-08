Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A833C14A8B
	for <netfilter-devel@vger.kernel.org>; Sat,  8 Mar 2025 23:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741475701; cv=none; b=hjWl+YFR7p4PmZUTplQfELe0WKWOJqD5gLNfBYn9Pm/Eg/o7vt/7B/ix2YF5Rza3BgNgjgU70MrOWa56irIUy0MXhKCVd7bjXgz01kO/XY4Z84e5DSu7fZ+7bx8k8iPqFa2e4xex5Y6emEmnTbYuXkvxw4kva/SSOUci+oZ1O3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741475701; c=relaxed/simple;
	bh=PY2zzZgo1OhGiQf7s1v5LP2XN0ALarkcRvlaaklT9C0=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=ir6pBQuf8LZZuULj17xf+/n7BLeF4L8zrGNbHWIfiySnNBy3ATl5o3wto3+WJCSxMCnfROyCiyfJBCZLaBpKH5yEpnvxNMC1PA0HnPV8TFfMIVZv6/aBJn3A8gesIyfbtHVS0mwNDrBXOc89GOPSSrFBU5ZpRyYSja3B/ZSLcv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=QnrdxGii; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="QnrdxGii"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1741475696; x=1742080496; i=corubba@gmx.de;
	bh=aRkEqYj+Djzco8shv8YirkTqCQm58po97p+s/6dNotM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:From:Subject:
	 Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=QnrdxGiiic0VTXVIwnLMMmhkrA0yRc7yl7XiUfDEzz9U1T9ipCJW6lwOI3BU0iO3
	 anZc0pVtFy0AKE/aCs0E0cJJZOYiYmRpphg0cdUkUNYsErnb1J9a/ekszOSKDJcoj
	 aWQeqtWxIwLuutjjqJAN6TG6WOXpCRdc91HYbhHY7AfMJjzDmwbEz3uCOv7uoDvfE
	 0zDg6tOt5JWX3PVZkH40Pa0NQ0ie1j4wf4P6BtpFLbEdJOCcIJbLje0rTwdtXSjKo
	 y1M9pFuLCULLBQMG9zHQeMgBXVYL2K5iieuYpPgi1pWbNwGSSwHnCAm0anYAtLoXD
	 yKkxvm5lLb54pIc/yQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.44.3] ([83.135.91.164]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M9Wyy-1tuMlQ37Ku-00A5Ir for
 <netfilter-devel@vger.kernel.org>; Sun, 09 Mar 2025 00:14:56 +0100
Message-ID: <7d1478b6-ec25-4286-a365-ce28293f4a40@gmx.de>
Date: Sun, 9 Mar 2025 00:14:56 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: de-CH
To: netfilter-devel@vger.kernel.org
From: Corubba Smith <corubba@gmx.de>
Subject: [PATCH ulogd2] nfct: add network namespace support
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:6sRnzRqsnI6YmneKqssbWskyShLR14y/feNN2P8twFr2p3tsl5H
 x76lh8vzlLoF7FtC7qg9C6721iavybswxoq2aSTIFASdcCFjjRZoQxczB+Sb2rdxnZPc7wE
 fZstgVagdpembGPOTYfGj0l8sD5SQ3WWP10pyAyjoRpPXVRvzqwu9dDlqJTrlc5GdIVELgx
 HZuJ+w8Z2KUX8RO9+SIxA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:2H6LYnB4Mcw=;XF+Owghiv1xGVN/dgQMCCzcbGx9
 d5YON22H7B4YVTtfYVQLic+E/MlLGeCHg64nTJX9UDTIhe9uBr0o8DXl9yx0bmRjfaEqgm9vo
 pe/lyRvOabIshc5cVaSzG6Q9h0a9VBIUU+sjUVuPEZOLFcZLdfM1FMMAFn7YzspHbf5VISfIf
 JXufGxRvZrUheBhDPFyBgKYjCGYL41Hul/6UNnQtwFU9joFnrmq25lwXnH1X2ECo5QpiyIjR4
 Ky+qzHK1slRcFYxETG3BDX8oReTS6yofZXH9JUcRUzWE0QI2osVdkIluzydSkennqCF9kLmsh
 H0X5C+E4pL/C4lNc/dmHuAxbVqskbWVQXig2HzHswsnPvcgtRgkW2g8KVVMeqSzvJbMCjscFE
 wesfmEgApUdEX5VVGWxOEANfowO2NDJTp10YPVfyJqTVBFWRktMLxfTnkdE8A4JoLe2GWvJYz
 D/+pDK1cpKh3XkJU9LY4uzkKNl2qyNRZPJvFRYP5Gj6p8oo+1raEJxJcvxHFhA9U94sQVWCl/
 Ri+fEyTKtjlVHusKB6QuXGQ97ATNUQA7e0AlSSSuxdJget29fr/CqDFaxBaKbRB9JZ66tHMQ+
 5qTB/8P1b8tXSvNIVLeZnrsBd+WRRuNRHs8GjAEssXh6Gt2PPfO4ZV4O0PPh6+ECEfRfKbXxo
 FFw8JuWD2/aS4K5e3w9pwtvZ06+8M0c5icJu1Nmwftz2SxorqFzpbwE1tnymBND+u8hKIhajv
 2vM1rhPZGLL9zyihU9VYxLyEDMWu5ZJYEBCtzoW5f8cWfLg/yfYQ/pidjNJrRqeOzJ+cB5BiG
 PgkooSOkm7qOL0YrIYhz+G4woWYte6RxFwrjD7JgRrFqWxZF8uVwx+78yZgpGdH05cECtrebJ
 yep+7bso0ITDRAbtIHkQjcggwXF90Q1Xz/oja/AGkeX2oduYHah/53WZ0hKl4h0uJLf6uXdkW
 Pw22h8lRjAjTBX7d7E7uXQhEZ2DS119K0fAEV1OftCTEu/k/1D79djfOw/CIaki4PWHJUitx4
 QBA0dF3peXihmpub+0Km96hL0E/o+PDy/HqszcV/FRPWvd7KyAGS2Rjip7TM3hxqYKtUGPMuQ
 XyiUw0iJbCcIb+GRTvfl2w88BFtwdcty/YAVxwY2uhuRD1zY97dEpfuMFlDOF2ZHALKYi9S61
 +e6pW456igROBGTb/KHCTwT6GzxQzDfSm2yn9X9RfXlv7V1a8ZT6YfnRQuRgUSXMf/d9Jqk4V
 J/j0qRczRshk5YG45HaUfaXNt1fu6D0O/l1TAPLsUxJtlJNBistsSxI3h2VYoKDkwOcK7wGbI
 I+Uo2raSF2zgYOeJrfsCQmIgZTSP/9NH/zOBLQNfhWtwrzXYcCwU5stY62fbx+bP5GL86FwSv
 cK4btbjbDu5sx1Tygz0fOSrp94GNGh4yciDzQy3s+MyM0o2yfCWmVpONa6

Add a new option which allows opening the netlink socket in a different
network namespace. This way you can run ulogd in one (management)
network namespace which is able to talk with your export target (e.g.
database or IPFIX collector), and import flows from multiple (customer)
network namespaces.

The config option is a path and not just a name so you can also use
anonymous network namespaces (e.g. `/proc/20/ns/net`)

Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
Since the required `setns()` syscall is part of the libc GNU extension,
`_GNU_SOURCE` needs to be defined before importing the headers. Even
after reading about it, I am still unsure about the ramifications of
that with regard to compatibility. That is why I maybe went a bit
overboard with the autoconf feature toggle, autodetection and
conditional compilation. Any feedback is appreciated.

Also tested to compile and run against musl.

This commit only implements it for NFCT. I wanted to gather some
feedback before also implementing it for the other netlink-based
plugins.


 configure.ac                    | 39 ++++++++++++++++++
 input/flow/ulogd_inpflow_NFCT.c | 72 ++++++++++++++++++++++++++++++++-
 2 files changed, 109 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index 3c9249e..70aa1d7 100644
=2D-- a/configure.ac
+++ b/configure.ac
@@ -243,6 +243,44 @@ AS_IF([test "x$enable_json" !=3D "xno"],
 AS_IF([test "x$libjansson_LIBS" !=3D "x"], [enable_json=3Dyes], [enable_j=
son=3Dno])
 AM_CONDITIONAL([HAVE_JANSSON], [test "x$libjansson_LIBS" !=3D "x"])

+AC_ARG_ENABLE([netns],
+              [AS_HELP_STRING([--enable-netns], [Enable network namespace=
 support for netlink-based plugins [default=3Dtest]])])
+AS_IF([test "x$enable_netns" !=3D "xno"], [
+  AC_CHECK_DECLS([setns, CLONE_NEWNET], [
+    enable_netns=3Dyes
+  ], [], [[#include <fcntl.h>], [#include <sched.h>]])
+])
+AS_IF([test "x$enable_netns" !=3D "xno"], [
+  AC_MSG_CHECKING([whether setns and CLONE_NEWNET are declared using _GNU=
_SOURCE])
+  AC_LINK_IFELSE([
+    AC_LANG_SOURCE([
+      #define _GNU_SOURCE
+      #include <fcntl.h>
+      #include <sched.h>
+      int main() {
+        setns(0, CLONE_NEWNET);
+        return 0;
+      }
+    ])
+  ],[
+    AC_MSG_RESULT([yes])
+    enable_netns=3Dyes
+    AC_DEFINE([HAVE_DECL_SETNS], [1], [])
+    AC_DEFINE([HAVE_DECL_CLONE_NEWNET], [1], [])
+    AC_DEFINE([NETNS_REQUIRES_GNUSOURCE], [1], [Define if network namespa=
ce functionality requires _GNU_SOURCE])
+  ],[
+    AC_MSG_RESULT([no])
+    AS_IF([test "x$enable_netns" =3D "xyes"], [
+      AC_MSG_ERROR([network namespace support enabled, but required symbo=
ls not available])
+    ], [
+      enable_netns=3Dno
+    ])
+  ])
+])
+AS_IF([test "x$enable_netns" =3D "xyes"], [
+  AC_DEFINE([NETNS_SUPPORT], [1], [Define if network namespace support is=
 enabled])
+], [])
+
 AC_ARG_WITH([ulogd2libdir],
             [AS_HELP_STRING([--with-ulogd2libdir=3DPATH], [Default direct=
ory to load ulogd2 plugin from [[LIBDIR/ulogd]]])],
             [ulogd2libdir=3D"$withval"],
@@ -293,6 +331,7 @@ EXPAND_VARIABLE(ulogd2libdir, e_ulogd2libdir)
 echo "
 Ulogd configuration:
   Default plugins directory:		${e_ulogd2libdir}
+  Network namespace support:		${enable_netns}
   Input plugins:
     NFLOG plugin:			${enable_nflog}
     NFCT plugin:			${enable_nfct}
diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NF=
CT.c
index 899b7e3..61f9f71 100644
=2D-- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -29,6 +29,12 @@
  * 	  network wide connection hash table.
  */

+#include "config.h"
+
+#ifdef NETNS_REQUIRES_GNUSOURCE
+#define _GNU_SOURCE
+#endif /* NETNS_REQUIRES_GNUSOURCE */
+
 #include <stdlib.h>
 #include <string.h>
 #include <errno.h>
@@ -37,6 +43,8 @@
 #include <time.h>
 #include <netinet/in.h>
 #include <netdb.h>
+#include <fcntl.h>
+#include <sched.h>
 #include <ulogd/linuxlist.h>
 #include <ulogd/jhash.h>
 #include <ulogd/hash.h>
@@ -78,7 +86,7 @@ struct nfct_pluginstance {
 #define EVENT_MASK	NF_NETLINK_CONNTRACK_NEW | NF_NETLINK_CONNTRACK_DESTRO=
Y

 static struct config_keyset nfct_kset =3D {
-	.num_ces =3D 12,
+	.num_ces =3D 13,
 	.ces =3D {
 		{
 			.key	 =3D "pollinterval",
@@ -149,6 +157,11 @@ static struct config_keyset nfct_kset =3D {
 			.type	 =3D CONFIG_TYPE_STRING,
 			.options =3D CONFIG_OPT_NONE,
 		},
+		{
+			.key     =3D "network_namespace_path",
+			.type    =3D CONFIG_TYPE_STRING,
+			.options =3D CONFIG_OPT_NONE,
+		},
 	},
 };
 #define pollint_ce(x)	(x->ces[0])
@@ -163,6 +176,7 @@ static struct config_keyset nfct_kset =3D {
 #define src_filter_ce(x)	((x)->ces[9])
 #define dst_filter_ce(x)	((x)->ces[10])
 #define proto_filter_ce(x)	((x)->ces[11])
+#define network_namespace_path_ce(x)	((x)->ces[12])

 enum nfct_keys {
 	NFCT_ORIG_IP_SADDR =3D 0,
@@ -1286,6 +1300,40 @@ static int constructor_nfct_events(struct ulogd_plu=
ginstance *upi)
 	struct nfct_pluginstance *cpi =3D
 			(struct nfct_pluginstance *)upi->private;

+	const char *const target_netns_path =3D network_namespace_path_ce(upi->c=
onfig_kset).u.string;
+	int original_netns_fd =3D -1, target_netns_fd =3D -1;
+
+#ifdef NETNS_SUPPORT
+	if (strlen(target_netns_path) > 0) {
+		errno =3D 0;
+		original_netns_fd =3D open("/proc/self/ns/net", O_RDONLY | O_CLOEXEC);
+		if (original_netns_fd < 0) {
+			ulogd_log(ULOGD_FATAL, "error opening original network namespace: %s\n=
", strerror(errno));
+			goto err_ons;
+		}
+
+		target_netns_fd =3D open(target_netns_path, O_RDONLY | O_CLOEXEC);
+		if (target_netns_fd < 0) {
+			ulogd_log(ULOGD_FATAL, "error opening target network namespace: %s\n",=
 strerror(errno));
+			goto err_tns;
+		}
+
+		if (setns(target_netns_fd, CLONE_NEWNET) < 0) {
+			ulogd_log(ULOGD_FATAL, "error joining target network namespace: %s\n",=
 strerror(errno));
+			goto err_cth;
+		}
+
+		if (close(target_netns_fd) < 0) {
+			ulogd_log(ULOGD_NOTICE, "error closing target network namespace: %s\n"=
, strerror(errno));
+		}
+		target_netns_fd =3D -1;
+	}
+#else
+	if (strlen(target_netns_path) > 0) {
+		ulogd_log(ULOGD_FATAL, "network namespace support is not compiled in.\n=
");
+		goto err_ons;
+	}
+#endif /* NETNS_SUPPORT */

 	cpi->cth =3D nfct_open(NFNL_SUBSYS_CTNETLINK,
 			     eventmask_ce(upi->config_kset).u.value);
@@ -1294,13 +1342,28 @@ static int constructor_nfct_events(struct ulogd_pl=
uginstance *upi)
 		goto err_cth;
 	}

+#ifdef NETNS_SUPPORT
+	if (strlen(target_netns_path) > 0) {
+		errno =3D 0;
+		if (setns(original_netns_fd, CLONE_NEWNET) < 0) {
+			ulogd_log(ULOGD_FATAL, "error joining original network namespace: %s\n=
", strerror(errno));
+			goto err_nsr;
+		}
+
+		if (close(original_netns_fd) < 0) {
+			ulogd_log(ULOGD_NOTICE, "error closing original network namespace: %s\=
n", strerror(errno));
+		}
+		original_netns_fd =3D -1;
+	}
+#endif /* NETNS_SUPPORT */
+
 	if ((strlen(src_filter_ce(upi->config_kset).u.string) !=3D 0) ||
 		(strlen(dst_filter_ce(upi->config_kset).u.string) !=3D 0) ||
 		(strlen(proto_filter_ce(upi->config_kset).u.string) !=3D 0)
 	   ) {
 		if (build_nfct_filter(upi) !=3D 0) {
 			ulogd_log(ULOGD_FATAL, "error creating NFCT filter\n");
-			goto err_cth;
+			goto err_nsr;
 		}
 	}

@@ -1408,8 +1471,13 @@ err_hashtable:
 	nfct_destroy(cpi->ct);
 err_nfctobj:
 	ulogd_unregister_fd(&cpi->nfct_fd);
+err_nsr:
 	nfct_close(cpi->cth);
 err_cth:
+	if (target_netns_fd >=3D 0) close(target_netns_fd);
+err_tns:
+	if (original_netns_fd >=3D 0) close(original_netns_fd);
+err_ons:
 	return -1;
 }

=2D-
2.48.1

