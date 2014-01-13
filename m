From: Kevin Fenzi <kevin@scrye.com>
Subject: [PATCH] nftables: Drop hard coded install using root user owner and
 group.
Date: Sun, 12 Jan 2014 19:42:11 -0700
Message-ID: <20140112194211.0570d298@voldemort.scrye.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/NVDrQ8nTHS2JB4w/g0KiO4j"; protocol="application/pgp-signature"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from scrye.com ([75.148.32.185]:47870 "EHLO mail.scrye.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbaAMCmc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Jan 2014 21:42:32 -0500
Received: from voldemort.scrye.com (localhost [IPv6:::1])
	by voldemort.scrye.com (Postfix) with ESMTP id 828C7200EF
	for <netfilter-devel@vger.kernel.org>; Sun, 12 Jan 2014 19:42:14 -0700 (MST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--Sig_/NVDrQ8nTHS2JB4w/g0KiO4j
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

 Packaging systems build as a non priv user, so can't install as root. Users
 installing from source can 'sudo make install' or run 'make install' as ro=
ot

Signed-off-by: Kevin Fenzi <kevin@scrye.com>
---
 Makefile.rules.in | 2 +-
 doc/Makefile.in   | 4 ++--
 files/Makefile.in | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Makefile.rules.in b/Makefile.rules.in
index a93a26b..4a5d413 100644
--- a/Makefile.rules.in
+++ b/Makefile.rules.in
@@ -61,7 +61,7 @@ clean_targets         +=3D $(1)-clean
 $(1)-install:
                        @echo -e "  INSTALL\t$1"
                        $(MKDIR_P) $$(DESTDIR)/$$($(1)-destdir)
-                       $(INSTALL) -m 755 -o root -g root \
+                       $(INSTALL) -m 755 \
                                $(SUBDIR)$(1) \
                                $$(DESTDIR)/$$($(1)-destdir)/$(1)
 install_targets                +=3D $(1)-install
diff --git a/doc/Makefile.in b/doc/Makefile.in
index 2c42d7e..c8c5743 100644
--- a/doc/Makefile.in
+++ b/doc/Makefile.in
@@ -10,11 +10,11 @@ install:    $(mandocs-y) $(pdfdocs-y)
                @echo -e "  INSTALL\tdoc"
                if test -n "$(mandocs-y)"; then \
                        $(MKDIR_P) $(DESTDIR)/${mandir}/man8 ;\
-                       $(INSTALL) -m 755 -o root -g root $(mandocs-y) \
+                       $(INSTALL) -m 755 $(mandocs-y) \
                                        $(DESTDIR)/${mandir}/man8/ ;\
                fi
                if test -n "$(pdfdocs-y)"; then \
                        $(MKDIR_P) $(DESTDIR)/${pdfdir} ;\
-                       $(INSTALL) -m 755 -o root -g root $(pdfdocs-y) \
+                       $(INSTALL) -m 755 $(pdfdocs-y) \
                                        $(DESTDIR)/${pdfdir}/ ;\
                fi
diff --git a/files/Makefile.in b/files/Makefile.in
index cd67c37..0d3390e 100644
--- a/files/Makefile.in
+++ b/files/Makefile.in
@@ -1,4 +1,4 @@
 install:
        @echo -e "  INSTALL\tfiles"
        $(MKDIR_P) $(DESTDIR)/$(confdir)
-       $(INSTALL) -m 755 -o root -g root $(SUBDIR)nftables/* $(DESTDIR)/$(=
confdir)/
+       $(INSTALL) -m 755 $(SUBDIR)nftables/* $(DESTDIR)/$(confdir)/
--=20
1.8.5.2

--Sig_/NVDrQ8nTHS2JB4w/g0KiO4j
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCgAGBQJS01KGAAoJEEs3sNgP+7teOEkP/29VhaQH81/xEBibcswKgrxY
T37AY37sA0Ggy72/cKWkI6n1nBny+sfv9zGR1VtlsV/o1EDKjFwln4iDc6Lpqtx+
2fOx9HlkjUqd1KdpMynXXvkkxpMpcNPJDR6yw8Dj8nIqFxcg82uMRL+bcWcz8+HY
YVczcu9aGeyiInfgJCaY3OMhTXMqdHOxOFjDP1wOKI3ozapNJIuiJjz1/EFI1b37
9TNreQTiOg8D4n+y4FmGiaoPY4KHzPqzpR9FFI6WPsNISK+L0rmdaIfrSaHKi39E
zBi8LeVcbiUHHgmeqV3A8Ch9dSYCV7mJkykqz6BqadJ0r0DZSgwtsy3yEzMXUZzt
JvkABBNIn9pamRjbqZ517QA0oFMDXxV4LnubYDvgkc7aze/YWfG6ej3e1H0tlo8m
Vqmm00EQ0e+9gqFiyKZ8cEzv7Q+2Lgm2gWrzsSELOoCSQBcC1gYkwvlGVKXbbFuo
UJjN0OHAOl6cxJoOygppD/vb+cbxS1hWIUL7gYCEvHSxEkeh2TaMEfGw2G2jwuGF
ldpn5C5+69Ymj0mkWPvRCsGkpKRmjyCzM4YrGQH4c1IXz9a1Efe5rzzNtVN4Kz9/
9qlryUexF/JN94E5p38bNLjfk2bN+iFYY+HJ1V1s+JDWP8192ArjWxRA1Qt+Ppm2
ZS15p6fTkcKbuOdm3HLm
=bpyT
-----END PGP SIGNATURE-----

--Sig_/NVDrQ8nTHS2JB4w/g0KiO4j--
