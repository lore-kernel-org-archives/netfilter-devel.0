From: "Vadim A. Misbakh-Soloviov" <mva@mva.name>
Subject: Re: [iptables PATCH] extensions/libxt_tcp: fix nftables translate flags value, 'none' vs '0x0'
Date: Wed, 06 Apr 2016 19:54:01 +0600
Message-ID: <1664957.l7oG8eJ0uH@note>
References: <145994465193.22717.2137088538000837721.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2326905.DJ3x0Ny6tn"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward20m.cmail.yandex.net ([5.255.216.151]:48081 "EHLO
	forward20m.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750792AbcDFOBh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Apr 2016 10:01:37 -0400
In-Reply-To: <145994465193.22717.2137088538000837721.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--nextPart2326905.DJ3x0Ny6tn
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"

Tested-by: Vadim A. Misbakh-Soloviov <netfilter@mva.name>

--
// now it generates valid nftables rule
--nextPart2326905.DJ3x0Ny6tn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXBRT5AAoJECZQPTSbOzNL368QAJXfgIEZ1wqreKt2g8imXWk0
VhPrsB6bHJyL53smBbpb3A0AwT0+qbMWn/Tisse9XwDfFSiP2rFqYJN/jvK/ZLNE
PUpm11XAgRjdSTFIdfm0zH4tBzDChqiMG40KnBcbxrkq5+opGDH2gnbUsQ1i/kgf
PDGqzzR/RPkQc3LWJKKMzvKfvV0uQstF85/o590ynw5WKEni2GurB0cw67Y/5TZU
Acp5dvu71/IDWjEWaN7r9N06JpdYLoTKfBi8uZhpcXy8wHoRdtDS4zFEmL8ioYDL
/ZOuPu4y0Hs1merlSorRGrtXZCxOmUXdUyaP2mm5TvsUU5SNddriDwIUhvaHg7Pk
YQl3SShjgZUa9YaoXEmFrm9+WoqG50YfSBioSE5ZJ8rG83cO1R/8+grWpwwiySfc
vVMxa+XTJ0ZbpIUQCqk8vw6h06wPQCEgfziQmlzhq9hbK8vQq49Op1rkHrTxU39f
1KQHpfGqh2r3Te2DbGObAwsBlMSvyqqEBJQUnZrvcvqboZwnn8wV/4joT0CXHgKo
iqXlxLSlkzHD1n4oXLG9HHwweqA06OhkxZb6UQVPn5YXWEPBwKA8atfYzay90zP3
rSRprfVFoqfUeRWFSJTk0OY6DhkynOB6LaievR/K5ngTFVVcAvvJS24TEykHJAcA
PbqAnckKHtsY+rYMheY9
=+P+X
-----END PGP SIGNATURE-----

--nextPart2326905.DJ3x0Ny6tn--

