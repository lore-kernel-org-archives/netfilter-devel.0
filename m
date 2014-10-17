From: Neutron Soutmun <neo.neutron@gmail.com>
Subject: [PATCH] ipset: Adjust the maximum timeout jiffies of set timeout
 extension
Date: Fri, 17 Oct 2014 10:35:44 +0700
Message-ID: <20141017033544.GA26660@nitrogen.neutroncom.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Cc: kadlec@blackhole.kfki.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:41770 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbaJQDfu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Oct 2014 23:35:50 -0400
Received: by mail-pa0-f44.google.com with SMTP id et14so4701157pad.31
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Oct 2014 20:35:50 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Refer to: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D764328

Marek Luk=E1cs has reported that the set with huge default timeout,
2419200 as an example, is replaced by 4294967 which is non-sense.

The msecs_to_jiffies() in kernel/time/time.c has a condition that

500 unsigned long msecs_to_jiffies(const unsigned int m)
501 {
502         /*
503          * Negative value, means infinite timeout:
504          */
505         if ((int)m < 0)
506                 return MAX_JIFFY_OFFSET;

Therefore, the maximum timeout jiffies should be less than or equal to
((UINT_MAX >> 1)) / MSEC_PER_SEC.

Signed-off-by: Neutron Soutmun <neo.neutron@gmail.com>
---
 include/linux/netfilter/ipset/ip_set_timeout.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set_timeout.h b/include/linux=
/netfilter/ipset/ip_set_timeout.h
index 83c2f9e..b1798df 100644
--- a/include/linux/netfilter/ipset/ip_set_timeout.h
+++ b/include/linux/netfilter/ipset/ip_set_timeout.h
@@ -23,6 +23,9 @@
 /* Set is defined with timeout support: timeout value may be 0 */
 #define IPSET_NO_TIMEOUT	UINT_MAX
=20
+/* Set maximum jiffies offset, msecs_to_jiffies() condition */
+#define IPSET_MAX_JIFFY_OFFSET  ((UINT_MAX >> 1))
+
 #define ip_set_adt_opt_timeout(opt, set)	\
 ((opt)->ext.timeout !=3D IPSET_NO_TIMEOUT ? (opt)->ext.timeout : (set)->ti=
meout)
=20
@@ -32,8 +35,8 @@ ip_set_timeout_uget(struct nlattr *tb)
 	unsigned int timeout =3D ip_set_get_h32(tb);
=20
 	/* Normalize to fit into jiffies */
-	if (timeout > UINT_MAX/MSEC_PER_SEC)
-		timeout =3D UINT_MAX/MSEC_PER_SEC;
+	if (msecs_to_jiffies(timeout * MSEC_PER_SEC) =3D=3D MAX_JIFFY_OFFSET)
+		timeout =3D IPSET_MAX_JIFFY_OFFSET / MSEC_PER_SEC;
=20
 	/* Userspace supplied TIMEOUT parameter: adjust crazy size */
 	return timeout =3D=3D IPSET_NO_TIMEOUT ? IPSET_NO_TIMEOUT - 1 : timeout;
--=20
2.1.1


--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJUQI6QAAoJEJ0EcL2mzcRXkTwP/2B2YYZSMGf8iKbTSsLOVPIq
LaLyDg41zv4Hp5BbZ5YBJquWeAVeN4OY05yRVP6jNmCPw5W9MxjDWOmQhmx2fvH9
bN2JXolaqE4rRCqxxr/rGKJp+waLVHbu36DYcSWLqwV6uXKizpUvW8ThqUb6LygW
BJdQ2m/6T4r+Hol2xnEk7qj6YWKkNLPzXXxqJ4hPQAxTHBGtr0S3UMWgOmqW02Qc
aNWsTkblJiMdNvgHWf/LbFgB1Pa56WJ3Wjnc3QHm3qnr8jaAu3lc7LXI0uKGTLol
lAht5CBvf5OP9Ae8QFtgcG1HNa27abMgE17t9wdAFwixgmKofyXggEzWxezmsfRl
QJJeh5JpjXKWSLLfHGAoi21FOjcla983hkQoIerE4AYXz5uqxcwp2eQ7F2rbFj2D
6dvG3pCLoluZk94mzABn8pSBJtUzxyvMrMda6wcTv9+FtwftFQb0PvdF0+3rHOEU
vFB+xuqjBJjC+mpoyOB6FdWW5mEDgJlGQK1XGEV5zkeBHhDSTLRNR/yf9Y4LtQbd
sWAt7Qu2htGVuho4b3nNY7qcNcEHrTO7nP5XS7OU7WdhH4Gxfyn4/zx3hi/n8lzJ
yq/xb0eSrtMQ7o5JCgBTzc0dEj6pSG9ddwsXzbBpzZ+3u4mPHiaUpHd39SBv2QY0
eJF9ykpKXFznKxdhBZPX
=BvFb
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
