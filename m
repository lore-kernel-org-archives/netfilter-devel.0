From: Phil Dibowitz <phil@ipom.com>
Subject: [PATCH] libnetfilter_conntrack: add extern C's to public headers
Date: Mon, 19 Mar 2007 23:07:52 -0700
Message-ID: <45FF7A38.8090907@ipom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig4AAD115589164E3F94B76567"
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

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4AAD115589164E3F94B76567
Content-Type: multipart/mixed; boundary="------------000104070006090502060001"

This is a multi-part message in MIME format.
--------------000104070006090502060001
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

The attached patch adds:

  extern "C" {...}

to all of the public headers in libnetfilter_conntrack's public headers. =
It
is, of course, #ifdef __cplusplus'd.

This will make it more straight forward for C++ developers to use
libnetfilter_conntrack in their applications.

--=20
Phil Dibowitz                             phil@ipom.com
Open Source software and tech docs        Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"Never write it in C if you can do it in 'awk';
 Never do it in 'awk' if 'sed' can handle it;
 Never use 'sed' when 'tr' can do the job;
 Never invoke 'tr' when 'cat' is sufficient;
 Avoid using 'cat' whenever possible" -- Taylor's Laws of Programming


--------------000104070006090502060001
Content-Type: text/x-patch; name="libnetfilter_conntrack-0.0.50_extern_c.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="libnetfilter_conntrack-0.0.50_extern_c.patch"

--- libnetfilter_conntrack-0.0.50/include/libnetfilter_conntrack/libnetfi=
lter_conntrack.h.orig	2007-03-19 22:44:24.000000000 -0700
+++ libnetfilter_conntrack-0.0.50/include/libnetfilter_conntrack/libnetfi=
lter_conntrack.h	2007-03-19 23:04:09.000000000 -0700
@@ -13,6 +13,10 @@
 #include <libnfnetlink/libnfnetlink.h>
 #include <libnetfilter_conntrack/linux_nfnetlink_conntrack.h>=20
=20
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 enum {
 	CONNTRACK =3D NFNL_SUBSYS_CTNETLINK,
 	EXPECT =3D NFNL_SUBSYS_CTNETLINK_EXP
@@ -549,4 +553,8 @@
 			    void *req,
 			    unsigned int size);
=20
+#ifdef __cplusplus
+}
+#endif
+
 #endif	/* _LIBNETFILTER_CONNTRACK_H_ */
--- libnetfilter_conntrack-0.0.50/include/libnetfilter_conntrack/libnetfi=
lter_conntrack_icmp.h.orig	2007-03-19 22:47:42.000000000 -0700
+++ libnetfilter_conntrack-0.0.50/include/libnetfilter_conntrack/libnetfi=
lter_conntrack_icmp.h	2007-03-19 22:48:06.000000000 -0700
@@ -8,6 +8,10 @@
 #ifndef _LIBNETFILTER_CONNTRACK_ICMP_H_
 #define _LIBNETFILTER_CONNTRACK_ICMP_H_
=20
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 enum icmp_flags {
 	ICMP_TYPE_BIT =3D 0,
 	ICMP_TYPE =3D (1 << ICMP_TYPE_BIT),
@@ -19,4 +23,8 @@
 	ICMP_ID =3D (1 << ICMP_ID_BIT)
 };
=20
+#ifdef __cplusplus
+}
+#endif
+
 #endif
--- libnetfilter_conntrack-0.0.50/include/libnetfilter_conntrack/libnetfi=
lter_conntrack_ipv4.h.orig	2007-03-19 22:48:16.000000000 -0700
+++ libnetfilter_conntrack-0.0.50/include/libnetfilter_conntrack/libnetfi=
lter_conntrack_ipv4.h	2007-03-19 22:49:51.000000000 -0700
@@ -8,6 +8,10 @@
 #ifndef _LIBNETFILTER_CONNTRACK_IPV4_H_
 #define _LIBNETFILTER_CONNTRACK_IPV4_H_
=20
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 enum ipv4_flags {
 	IPV4_ORIG_SRC_BIT =3D 0,
 	IPV4_ORIG_SRC =3D (1 << IPV4_ORIG_SRC_BIT),
@@ -26,4 +30,8 @@
 	IPV4_REPL =3D (IPV4_REPL_SRC | IPV4_REPL_DST)
 };
=20
+#ifdef __cplusplus
+}
+#endif
+
 #endif
--- libnetfilter_conntrack-0.0.50/include/libnetfilter_conntrack/libnetfi=
lter_conntrack_ipv6.h.orig	2007-03-19 22:49:57.000000000 -0700
+++ libnetfilter_conntrack-0.0.50/include/libnetfilter_conntrack/libnetfi=
lter_conntrack_ipv6.h	2007-03-19 22:50:44.000000000 -0700
@@ -8,6 +8,10 @@
 #ifndef _LIBNETFILTER_CONNTRACK_IPV6_H_
 #define _LIBNETFILTER_CONNTRACK_IPV6_H_
=20
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 enum ipv6_flags {
 	IPV6_ORIG_SRC_BIT =3D 0,
 	IPV6_ORIG_SRC =3D (1 << IPV6_ORIG_SRC_BIT),
@@ -26,4 +30,8 @@
 	IPV6_REPL =3D (IPV6_REPL_SRC | IPV6_REPL_DST)
 };
=20
+#ifdef __cplusplus
+}
+#endif
+
 #endif
--- libnetfilter_conntrack-0.0.50/include/libnetfilter_conntrack/libnetfi=
lter_conntrack_sctp.h.orig	2007-03-19 22:50:52.000000000 -0700
+++ libnetfilter_conntrack-0.0.50/include/libnetfilter_conntrack/libnetfi=
lter_conntrack_sctp.h	2007-03-19 22:51:28.000000000 -0700
@@ -8,6 +8,10 @@
 #ifndef _LIBNETFILTER_CONNTRACK_SCTP_H_
 #define _LIBNETFILTER_CONNTRACK_SCTP_H_
=20
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 enum sctp_flags {
 	SCTP_ORIG_SPORT_BIT =3D 0,
 	SCTP_ORIG_SPORT =3D (1 << SCTP_ORIG_SPORT_BIT),
@@ -37,4 +41,8 @@
 	SCTP_EXPTUPLE_DPORT =3D (1 << SCTP_EXPTUPLE_DPORT_BIT)
 };
=20
+#ifdef __cplusplus
+}
+#endif
+
 #endif
--- libnetfilter_conntrack-0.0.50/include/libnetfilter_conntrack/libnetfi=
lter_conntrack_tcp.h.orig	2007-03-19 22:51:33.000000000 -0700
+++ libnetfilter_conntrack-0.0.50/include/libnetfilter_conntrack/libnetfi=
lter_conntrack_tcp.h	2007-03-19 22:52:08.000000000 -0700
@@ -8,6 +8,10 @@
 #ifndef _LIBNETFILTER_CONNTRACK_TCP_H_
 #define _LIBNETFILTER_CONNTRACK_TCP_H_
=20
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 enum tcp_state {
 	TCP_CONNTRACK_NONE,
 	TCP_CONNTRACK_SYN_SENT,
@@ -52,4 +56,8 @@
 	TCP_EXPTUPLE_DPORT =3D (1 << TCP_EXPTUPLE_DPORT_BIT)
 };
=20
+#ifdef __cplusplus
+}
+#endif
+
 #endif
--- libnetfilter_conntrack-0.0.50/include/libnetfilter_conntrack/libnetfi=
lter_conntrack_udp.h.orig	2007-03-19 22:52:15.000000000 -0700
+++ libnetfilter_conntrack-0.0.50/include/libnetfilter_conntrack/libnetfi=
lter_conntrack_udp.h	2007-03-19 22:52:51.000000000 -0700
@@ -8,6 +8,10 @@
 #ifndef _LIBNETFILTER_CONNTRACK_UDP_H_
 #define _LIBNETFILTER_CONNTRACK_UDP_H_
=20
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 enum udp_flags {
 	UDP_ORIG_SPORT_BIT =3D 0,
 	UDP_ORIG_SPORT =3D (1 << UDP_ORIG_SPORT_BIT),
@@ -34,4 +38,8 @@
 	UDP_EXPTUPLE_DPORT =3D (1 << UDP_EXPTUPLE_DPORT_BIT)
 };
=20
+#ifdef __cplusplus
+}
+#endif
+
 #endif
--- libnetfilter_conntrack-0.0.50/include/libnetfilter_conntrack/linux_nf=
netlink_conntrack.h.orig	2007-03-19 22:53:08.000000000 -0700
+++ libnetfilter_conntrack-0.0.50/include/libnetfilter_conntrack/linux_nf=
netlink_conntrack.h	2007-03-19 22:53:30.000000000 -0700
@@ -2,6 +2,10 @@
 #define _IPCONNTRACK_NETLINK_H
 #include <libnfnetlink/linux_nfnetlink.h>
=20
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 enum cntl_msg_types {
 	IPCTNL_MSG_CT_NEW,
 	IPCTNL_MSG_CT_GET,
@@ -134,4 +138,8 @@
 };
 #define CTA_HELP_MAX (__CTA_HELP_MAX - 1)
=20
+#ifdef __cplusplus
+}
+#endif
+
 #endif /* _IPCONNTRACK_NETLINK_H */

--------------000104070006090502060001--

--------------enig4AAD115589164E3F94B76567
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF/3o4N5XoxaHnMrsRAgh3AJ48mjSda4kecW4DmDkMC97rjkuxQACgoXyv
2llMzsvOdf0u+W2HMdB3NrY=
=qW76
-----END PGP SIGNATURE-----

--------------enig4AAD115589164E3F94B76567--
