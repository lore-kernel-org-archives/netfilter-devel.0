From: Neutron Soutmun <neo.neutron@gmail.com>
Subject: [PATCH] ipset: Fix ipset command replacement in runtest.sh
Date: Tue, 30 May 2017 17:46:33 +0700
Message-ID: <20170530104633.xb3urujnizjkc4n6@hydrogen>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rbjgjx2rcdrygtym"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:34585 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751024AbdE3Kqi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 May 2017 06:46:38 -0400
Received: by mail-pf0-f182.google.com with SMTP id 9so69004197pfj.1
        for <netfilter-devel@vger.kernel.org>; Tue, 30 May 2017 03:46:38 -0700 (PDT)
Received: from hydrogen ([180.183.101.225])
        by smtp.gmail.com with ESMTPSA id q135sm27466729pgq.41.2017.05.30.03.46.36
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 30 May 2017 03:46:36 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--rbjgjx2rcdrygtym
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

  Fix the ipset command replacement.

  For ipset=3D"/sbin/ipset"

  Actual:
    /sbin//sbin/ipset 2>.foo.err | ... | xargs -n1 ipset
  Expected:
    /sbin/ipset 2>.foo.err | ... | xargs -n1 /sbin/ipset
---
 tests/runtest.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/runtest.sh b/tests/runtest.sh
index 186f11d..8f4c02a 100755
--- a/tests/runtest.sh
+++ b/tests/runtest.sh
@@ -96,7 +96,7 @@ for types in $tests; do
 	echo -ne "$types: $what: "
 	cmd=3D`echo $cmd | sed "s|ipset|$ipset 2>.foo.err|"`
 	# For the case: ipset list | ... | xargs -n1 ipset
-	cmd=3D`echo $cmd | sed "s|ipset|$ipset|"`
+	cmd=3D`echo $cmd | sed "s|ipset|$ipset|2g"`
 	eval $cmd
 	r=3D$?
 	# echo $ret $r
--=20
2.11.0


--rbjgjx2rcdrygtym
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE9TLaEOVj7oRECXehnQRwvabNxFcFAlktTYUACgkQnQRwvabN
xFcJNg/+LLMdZbjREt0tgAM53681zZ5AoMXHmvKF9svpUfOLkbeWVkH0E4lnTYAq
I7EGVnoTtcKE2VGwF30qGnyfYCZ/ne0YObMdp/2U3vtNibP0uFQjykTUbTj6gKny
f2cuKOUD7eoZZ59l492OxYiAJPr04HIb18UcDeRg6MtAazlhVkK3K/2CNm798NZl
39FauOZebDV2VoB3vAuT3uDAMkGKwdtvk+hkrjY3+/GCLCuvzP3gertaMgp3IdJu
uadFVgBwot9bG7vxXnFAaUc2khxoSXfihULpgFsr9UJmsuYhkEGV4bT51qVZP4EZ
zwCFKXk4rPi86EOdGpZkUJ5NFpw/LeLdz8iBxnEQaAHYZP03sm9hH6FXsTCpOZpV
gKpil3j3CGeXksJ8jLEGMJaH29cQgNKP6xUSx33eW4KCGJe+WdmHKKkzeWuWolW8
3zYnXoM/y06KfSONBljfUDIqxRfMr8n/R0uvp3qD0ADEvsg84AyXPo+iemjsX2w2
75zU4Ee7nD+xneRQqS8HuVFFNWeXJC+Vfz6S5/UeDssjCfN1qjTDHn9n+Eqbu2b7
YL8E4fSBwUtyGEAHxzrpC1moOEdGCdlVyRQDvHTMj36kEGZ4N9JZ6rfOAW1EiqXb
9ax1iHd6ZCetTSD0rPziQwA1Kb/VwzvAPaUB6z/Ypwpe/sHyT68=
=lmLV
-----END PGP SIGNATURE-----

--rbjgjx2rcdrygtym--
