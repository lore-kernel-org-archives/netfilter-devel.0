From: Neutron Soutmun <neo.neutron@gmail.com>
Subject: [PATCH] Fix grammar error in manpage
Date: Mon, 20 Jul 2015 17:21:56 +0700
Message-ID: <20150720102156.GA4932@oxygen>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Cc: kadlec@blackhole.kfki.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35576 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbbGTKWC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jul 2015 06:22:02 -0400
Received: by pabkd10 with SMTP id kd10so27456550pab.2
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jul 2015 03:22:01 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Refer to: https://bugs.launchpad.net/ubuntu/+source/lintian/+bug/608231

The "allows to" is a common grammar error which it will probably be
replaced by "allows one to" as a suggestion in above bug report page.

Signed-off-by: Neutron Soutmun <neo.neutron@gmail.com>
---
 src/ipset.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/ipset.8 b/src/ipset.8
index a718f98..d0d7ac0 100644
--- a/src/ipset.8
+++ b/src/ipset.8
@@ -321,7 +321,7 @@ ipset add foo 192.168.1.1/24 comment "allow access to S=
MB share on \\\\\\\\files
 the above would appear as: "allow access to SMB share on \\\\fileserv\\"
 .PP
 .SS "skbinfo, skbmark, skbprio, skbqueue"
-All set types support the optional \fBskbinfo\fR extension. This extension=
 allow to
+All set types support the optional \fBskbinfo\fR extension. This extension=
 allows you to
 store the metainfo (firewall mark, tc class and hardware queue) with every=
 entry and map it to
 packets by usage of SET netfilter target with \-\-map\-set option.
 \fBskbmark\fR option format: \fBMARK\fR or \fBMARK/MASK\fR, where \fBMARK\=
fR and \fBMASK\fR are 32bit hex
--=20
2.1.4


--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJVrMvEAAoJEJ0EcL2mzcRXX80P/j8DQjoUKFpkrqknwhuV0j9w
reYM15PwFkazfmnxZmZgmhTQTRknlTcHV9S548H7qr12EfY+ic+2h52uJSzUDn9n
CwI8hjZz3CwlPiZAwKGpOe3D7bxLGyzVocWTtxbEXh8GWvRz7/8xmxBIw/4A/ThK
ttluA1GdgHORGCVV9+pFNDY+h37T2eXfr7ZDJCYEw5ZR8zlbVa84NFa+uxJyM88I
ztDhhjQcZoqutW5IMWD9dJZM7OaRJKBpR1GozdyRyY1hzMXrDOpjGY0HxJHxPsEz
rKOXu8CvG5X1Ivpkr9Zzl+PtwN8CsXR6FUrATBgOptJcY3Ibie0efLVu8v62vpf+
JCGSsfYSG6ZiXXcvjlXGq5hHCAUSPZg+khP0dbQWdRWcPtUWwLTQJXkyvR8qNTgC
/47/CDss7PQX9ra5KCQ+wskdDTERh5k6rD3rYmUfAdY3rNhg3+VPx8lZRLx5CJme
/a50yN0MzGqnG2r/+JkO+Fe7d6eiAhkLByTiVXz3Ou1Ak9nHFxARRU2ua9W7amai
gFcwfderHsjskYSRmct3AAvuOdbMGKB8smxWHdd5N5KE19n8ULBR0qb3CNR5ZkRh
iEW8XN3Lou9txe8SSA+DBJ8Oy3Yg2Lllkbo+5B/7nO2LNCjvbKEqnYJ4OxByZatd
I1TS3ueUTlW62ANiQk2Z
=LxbD
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
