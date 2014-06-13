From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libmnl] include: cache copy of include/linux/socket.h
Date: Fri, 13 Jun 2014 11:23:33 +0200
Message-ID: <1402651413-10059-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57348 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064AbaFMJXn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jun 2014 05:23:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This fixes compilation in Debian Squeeze:

  CC     attr.lo
In file included from ../include/libmnl/libmnl.h:9,
                 from socket.c:10:
=2E./include/linux/netlink.h:35: error: expected specifier-qualifier-li=
st before =E2=80=98__kernel_sa_family_t=E2=80=99
In file included from ../include/libmnl/libmnl.h:9,
                 from callback.c:11:
=2E./include/linux/netlink.h:35: error: expected specifier-qualifier-li=
st before =E2=80=98__kernel_sa_family_t=E2=80=99
socket.c: In function =E2=80=98mnl_socket_get_portid=E2=80=99:
socket.c:102: error: =E2=80=98const struct sockaddr_nl=E2=80=99 has no =
member named =E2=80=98nl_pid=E2=80=99
socket.c: In function =E2=80=98mnl_socket_bind=E2=80=99:
socket.c:146: error: =E2=80=98struct sockaddr_nl=E2=80=99 has no member=
 named =E2=80=98nl_family=E2=80=99
socket.c:147: error: =E2=80=98struct sockaddr_nl=E2=80=99 has no member=
 named =E2=80=98nl_groups=E2=80=99
socket.c:148: error: =E2=80=98struct sockaddr_nl=E2=80=99 has no member=
 named =E2=80=98nl_pid=E2=80=99
socket.c:163: error: =E2=80=98struct sockaddr_nl=E2=80=99 has no member=
 named =E2=80=98nl_family=E2=80=99
socket.c: In function =E2=80=98mnl_socket_sendto=E2=80=99:
socket.c:184: error: unknown field =E2=80=98nl_family=E2=80=99 specifie=
d in initializer
socket.c:185: warning: excess elements in struct initializer
socket.c:185: warning: (near initialization for =E2=80=98snl=E2=80=99)

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/Makefile.am |    2 +-
 include/linux/socket.h    |   21 +++++++++++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/socket.h

diff --git a/include/linux/Makefile.am b/include/linux/Makefile.am
index 95f82d2..08c600b 100644
--- a/include/linux/Makefile.am
+++ b/include/linux/Makefile.am
@@ -1,2 +1,2 @@
 SUBDIRS =3D netfilter
-noinst_HEADERS =3D netlink.h
+noinst_HEADERS =3D netlink.h socket.h
diff --git a/include/linux/socket.h b/include/linux/socket.h
new file mode 100644
index 0000000..8c1e501
--- /dev/null
+++ b/include/linux/socket.h
@@ -0,0 +1,21 @@
+#ifndef _LINUX_SOCKET_H
+#define _LINUX_SOCKET_H
+
+/*
+ * Desired design of maximum size and alignment (see RFC2553)
+ */
+#define _K_SS_MAXSIZE	128	/* Implementation specific max size */
+#define _K_SS_ALIGNSIZE	(__alignof__ (struct sockaddr *))
+				/* Implementation specific desired alignment */
+
+typedef unsigned short __kernel_sa_family_t;
+
+struct __kernel_sockaddr_storage {
+	__kernel_sa_family_t	ss_family;		/* address family */
+	/* Following field(s) are implementation specific */
+	char		__data[_K_SS_MAXSIZE - sizeof(unsigned short)];
+				/* space to achieve desired size, */
+				/* _SS_MAXSIZE value minus size of ss_family */
+} __attribute__ ((aligned(_K_SS_ALIGNSIZE)));	/* force desired alignme=
nt */
+
+#endif /* _LINUX_SOCKET_H */
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
