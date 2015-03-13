From: Neutron Soutmun <neo.neutron@gmail.com>
Subject: [PATCH] ipset: propose rewording in manpage
Date: Fri, 13 Mar 2015 09:00:19 +0700
Message-ID: <20150313020019.GA25141@oxygen>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Cc: kadlec@blackhole.kfki.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:36807 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247AbbCMCAZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Mar 2015 22:00:25 -0400
Received: by pdbnh10 with SMTP id nh10so24797820pdb.3
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2015 19:00:24 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I have prepared the patch which refers to
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D780336,
reported and proposed by H. Renault <hr@herverenault.fr>.

man ipset reads:

    del SETNAME DEL-ENTRY [ DEL-OPTIONS ]
        Delete an entry from a set. If the -exist option is specified,
        ipset ignores if the entry does not added to  (already expired
        from)  the set.

Proposed rewording:

        Delete an entry from a set. If the -exist option is specified
        and the entry is not in the set (maybe already expired), then
        the command is ignored.

Signed-off-by: Neutron Soutmun <neo.neutron@gmail.com>
---
 src/ipset.8 | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/src/ipset.8 b/src/ipset.8
index c923956..7c8f56e 100644
--- a/src/ipset.8
+++ b/src/ipset.8
@@ -95,9 +95,8 @@ ignores if the entry already added to the set.
 \fBdel\fP \fISETNAME\fP \fIDEL\-ENTRY\fP [ \fIDEL\-OPTIONS\fP ]
 Delete an entry from a set. If the
 \fB\-exist\fR
-option is specified,
-\fBipset\fR
-ignores if the entry does not added to (already expired from) the set.
+option is specified and the entry is not in the set (maybe already expired=
),
+then the command is ignored.
 .TP=20
 \fBtest\fP \fISETNAME\fP \fITEST\-ENTRY\fP [ \fITEST\-OPTIONS\fP ]
 Test wether an entry is in a set or not. Exit status number is zero
--=20
2.1.4


--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJVAkSzAAoJEJ0EcL2mzcRX/QMP/j/VkuxDHgHUhM0hmidsOaMv
6O/G5am3UzEvlR/fWj69EBAHnumpJgs9n5uqCDZVH3Ciwly2Qnb0waQVdNa8TX27
pbqblHYhnH/IaXb+7Jl6db2wnIBNbqUwXudEHEnWhBk5x+hZK73OjQxbC8vfuhZ9
AFABTAQylp8xZ88XSPF3OqeHA5T6a2IEdRVljxXwv1E/wsHiBFw0Lc6GgIWS+1E+
zD0df5KjKAh0mTykaOOyNfd9+olbWx9dLtyt2babHwpWOH+uTL1qj9yJUqbjaazq
dKi/QdxnusPU+Ekk2i2yvA55h1if6clQllo4JHMYF6zgIW0uh26Zq8cxaUgm2+vh
xSVC6bPLNepH3c8G1+jx5DlYqPTLKUob8cW93qxDpJK3GaQvhxTYa5pMZtGhdnbp
uLecIu8+r6PUpM3KfnYl/2FUe66AexhL2WU/FOCWfsE+0Om8nofwQiLVI6/Gr/S5
aXYeYeYHVlFBfXV+xT0CrGuU3C5zeedBf6nS7OyBnkNsxW1nAAJPhCsntpQr229i
uIVSICWIEFPo3SRFXyC8dVI7hR1RaPacZkUJVe8T9L2PialM1aP8k/vZbiLorFGI
nSf85XQ1GQo16dBdmARfxTxZeFcJ47ud9Rp299jNEPDGBaKAso32cPNg5gZqBfMF
QmN/g9vRjudbr/1+7VjY
=duSk
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
