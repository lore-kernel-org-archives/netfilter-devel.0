Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA969EE4996
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Aug 2023 17:55:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235424AbjHURz1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Aug 2023 13:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231528AbjHURz1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2023 13:55:27 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607B6E9
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Aug 2023 10:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GpOcglZgjwxyyEmJ+XwDUvgM2VqALT6DDSOpqT4Ta2g=; b=FJjKLza/qVYq5MVMzwDJNUSUXi
        iCgwKdg5kFYpls3DSS5S9TGc87R2TWEAV0CdVcLGmL1YoNAGVZwXLH305VxFYilJ/3f+U9rGTaO8O
        qivrqaEflA65sqx0yrSCSZQVAyYrApAA2eCxD41pl9THJ9uuG+gNGFWT9z+rSWUKhDGzWS7Jzk8Uj
        ia3rNn/Z8xqGX/dmEaB0c7MZTOyvWbyG7TD89Ba8dod9BW2JPgRyfcBwXKI+xCVLpG0/1yJjoRaBz
        6Qkr/MIEUau2HlyOuTJQYhKj7yRfP9QmXLZ4MSvh3gqbJaWYfKKzgO/h8xCVHlN7AB7Ea5p2iMHaR
        FbfK94rw==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=azazel.net)
        by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qY97b-008xmX-0H;
        Mon, 21 Aug 2023 18:55:23 +0100
Date:   Mon, 21 Aug 2023 18:55:21 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v2] INSTALL: provide examples to install python
 bindings
Message-ID: <20230821175521.GA46797@azazel.net>
References: <20230821112840.27221-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="btKuI8dzd2rcMl5b"
Content-Disposition: inline
In-Reply-To: <20230821112840.27221-1-pablo@netfilter.org>
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--btKuI8dzd2rcMl5b
Content-Type: multipart/mixed; boundary="nqh+74DdzC3jSCo+"
Content-Disposition: inline


--nqh+74DdzC3jSCo+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-08-21, at 13:28:40 +0200, Pablo Neira Ayuso wrote:
> Provide examples to install python bindings with legacy setup.py and pip
> with .toml file.
>=20
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: add Jeremy's feedback.
>=20
>  INSTALL | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>=20
> diff --git a/INSTALL b/INSTALL
> index 53021e5aafc3..6539ebdd6457 100644
> --- a/INSTALL
> +++ b/INSTALL
> @@ -84,10 +84,14 @@ Installation instructions for nftables
>   Python support
>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
> - CPython bindings are available for nftables under the py/ folder.
> + CPython bindings are available for nftables under the py/ folder.  They=
 can be
> + installed using pip:
> =20
> - A pyproject.toml config file and legacy setup.py script are provided to=
 install
> - it.
> +    python -m pip install py/
> +
> + Alternatively, legacy setup.py script is also provided to install it:
> +
> +	python setup.py install
> =20
>   Source code
>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --=20
> 2.30.2
>=20

If you want to retain a reference to setup.py, then how about this
patch?

J.

--nqh+74DdzC3jSCo+
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-INSTALL-provide-examples-to-install-python-bindings.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 415b23098ad9d48bd6f45f3edc589abcb9aaf87a Mon Sep 17 00:00:00 2001
=46rom: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 21 Aug 2023 13:28:40 +0200
Subject: [PATCH] INSTALL: provide examples to install python bindings

Provide examples to install python bindings with legacy setup.py and pip
with .toml file.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 INSTALL | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/INSTALL b/INSTALL
index 53021e5aafc3..5d45ec988c9f 100644
--- a/INSTALL
+++ b/INSTALL
@@ -84,10 +84,16 @@ Installation instructions for nftables
  Python support
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
- CPython bindings are available for nftables under the py/ folder.
+ CPython bindings are available for nftables under the py/ folder.  They c=
an be
+ installed using pip:
=20
- A pyproject.toml config file and legacy setup.py script are provided to i=
nstall
- it.
+	python -m pip install py/
+
+ A legacy setup.py script can also be used:
+
+	( cd py && python setup.py install )
+
+ However, this method is deprecated.
=20
  Source code
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--=20
2.40.1


--nqh+74DdzC3jSCo+--

--btKuI8dzd2rcMl5b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmTjpQkACgkQKYasCr3x
BA3BXA//UJOb2x/R7ZMB1HTkuFUrV23v7P99B71ypZdkASbF3xCPjP9DB5ksxd4c
cwILmculftYCsRnsiCuarQ91VRcQW58datS+mpAFFoZfzsEbwhcW3iLeHQ4/Nw++
LtMP4jkn5T8bKfDYm3G+6JdHna9s8nGIf4wBx6GeyU45vyuyV/RyMSerbXeiSCAv
6C4IlDEMHK1YOaLZxbjtYzJWESZDYk+NBj6c/Tk9kLiYUze/q2pcf4JD2lNogYgv
DBN6OJ+TxB2kQd6a3YEbgaQ/OqmMkcxLs0jj+0VV+0+0w+blE8pkzLJzJeGz1a0s
+L7jBX9tYegNRtib2kggWWwpF09gAlGNzR+7q15DXyajIqyCwFvOte/nvWMB+JME
69EMPKm3BAfzuHxkEvMQf6poB7rQGMsCKcHEjhMvNby2xW3tisMxt1JZCW7XUyiv
1xsn/0psn0KbpaQc6i7HhOV6Qm+9yZxZS9L3S5xwk0Eabf7szQzrJEwHXQGqOWVy
p9+ENdBHb0etkGiaRRKBXBWHEnloFGQ4Bgz9EY5yPd0Ka9wTKtCAf21aCfQ7SaLR
5ur4NFCEdeLXJUf8yNste2a+FOS+L+WL0120CSvMOYTcGtW+qdni8dEd1WqjUGgM
FKXDu5An0P5JZh8TiFGBxqjp2C+MywB+UW0HcwIWT4EZbqWIcSE=
=PWRu
-----END PGP SIGNATURE-----

--btKuI8dzd2rcMl5b--
