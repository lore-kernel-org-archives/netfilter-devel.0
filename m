Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB662045B7
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2025 11:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736766731; cv=none; b=RKLx+kGrhYqrp+7pUBWNFQhI9JnWuMvtq6e02PYSUXRH2dfNI22Sq04bOmnfNv8RM2qjkItjTof5nlvoNViFi5zR/L7Muko5TDGi1FAoySIsrVnslTAd4XIPAcHaobLCywSy2T+0rIRnXxx+p9MUyZ1eY7inlX6wJ/SMM2K5U+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736766731; c=relaxed/simple;
	bh=DTqruevd0MEN8iHAdk70cEUHqIP9gUW5LpwidtT3OuE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V8QciaYwfg75wjWQ11QVJfY9QUb6BepJ9DtZrdj6cykiH8IQB15Fne+yCSvDsPlQCH7UGzFUiH761mUYNzy7OuNn4u95/dc5iozlUWxTzJb9SZuWT92MlxF54a7GkwpjjjY1q59A5tEY68DLeR3upkEuvTZuusiBS8Biw9JvIeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=bTUPIIQ4; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="bTUPIIQ4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NzlTA0T1J2wbqU3Ee4dkoN5mOP97c0Ir4cCJY+06CA0=; b=bTUPIIQ4U1IqJ2c2Trjtel4i6k
	PMVI4dfW2cGJpe4AbTV1ixTtafF1h/IRP/PWMcnt7xa1AtwOjrPtWM+D9VxECqzYuWV4NXVYwm6XQ
	TURi978I7piX0Qzayx/8zTZ77U7+B8FleDmeruVITFiTELkDlHolTWlyZmVTFU05op5oTwP+nrjMY
	fYV3O0gIJUyndMXKdVN1xSb51tfZvq0mpDEXEB2oIwrE5ZQbOo9FohvOuq/LtY6zZC/tV+Xys77NH
	UgxYk6jkkZHd7ZrKAMnD4kvvszGiXzt3TYX0tmByuDXi8naotB0IeGIIKo43cIzcK6vjjts9FEsb4
	RrMXYA2A==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <azazel@debian.org>)
	id 1tXIMV-00025z-Lp; Mon, 13 Jan 2025 11:12:04 +0000
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <azazel@debian.org>)
	id 1tXIMU-001EWY-2v;
	Mon, 13 Jan 2025 11:12:02 +0000
Date: Mon, 13 Jan 2025 11:12:01 +0000
From: Jeremy Sowden <azazel@debian.org>
To: James Dingwall <james@dingwall.me.uk>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: ulogd: out of bounds array access in ulogd_filter_HWHDR
Message-ID: <20250113111201.GB2068886@celephais.dreamlands>
References: <Z4Tr5p19Uoc1UEcg@dingwall.me.uk>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="pkw5chjoOcsEkeaK"
Content-Disposition: inline
In-Reply-To: <Z4Tr5p19Uoc1UEcg@dingwall.me.uk>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: azazel@debian.org
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
X-Debian-User: azazel


--pkw5chjoOcsEkeaK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2025-01-13, at 10:33:10 +0000, James Dingwall wrote:
> This report relates to https://bugs.launchpad.net/ubuntu/+source/ulogd2/+=
bug/2080677.
>=20
> # apt-cache policy ulogd2
> ulogd2:
>   Installed: 2.0.8-2build1
>   Candidate: 2.0.8-2build1
>   Version table:
>  *** 2.0.8-2build1 500
>         500 http://gb.archive.ubuntu.com/ubuntu noble/universe amd64 Pack=
ages
>         100 /var/lib/dpkg/status
>=20
> # lsb_release -a
> No LSB modules are available.
> Distributor ID: Ubuntu
> Description: Ubuntu 24.04.1 LTS
> Release: 24.04
> Codename: noble
>=20
> It seems that there is an out of bounds array access in ulogd_filter_HWHD=
R.c
> which leads to ulogd2 being terminated with SIGABRT and the following mes=
sage
> when it is compiled with -D_FORTIFY_SOURCE=3D3:
>=20
> *** buffer overflow detected ***
>=20
> The hwac_str array is defined as:
>=20
>   static char hwmac_str[MAX_KEY - START_KEY][HWADDR_LENGTH];
>=20
> Which translates to:
>=20
>   static char hwmac_str[4 - 2][128];
>=20
> i.e. an array of two elements, valid indexes 0, 1.
>=20
> Adding a debug print statement in the parse_mac2str function:
>=20
>   fprintf(stderr, "using hwmac_str index %d\n", okey - START_KEY);
>=20
> will result in the following message: =20
>=20
>   using hwmac_str index 2
>=20
> So the for loop attempts to format the mac address in to an invalid index=
 in
> hwmac_str.
>=20
> As a simple test I made the definition of hwmac_str an array of 3 elements
> which prevented the crash.  I don't know if it is correct to simply make
> the array longer or if the bug is actually in the value of 'okey' passed =
to
> the function.  However based on the final return in interp_mac2str I think
> the array definition is too short.  The attached patch allows ulog2 to
> run after rebuilding with dpkg-buildpackage.

> --- filter/ulogd_filter_HWHDR.c.orig	2025-01-13 09:25:18.937977335 +0000
> +++ filter/ulogd_filter_HWHDR.c	2025-01-13 09:25:51.337824820 +0000
> @@ -109,7 +109,7 @@
>  	},
>  };
> =20
> -static char hwmac_str[MAX_KEY - START_KEY][HWADDR_LENGTH];
> +static char hwmac_str[(MAX_KEY + 1) - START_KEY][HWADDR_LENGTH];
> =20
>  static int parse_mac2str(struct ulogd_key *ret, unsigned char *mac,
>  			 int okey, int len)

This was fixed a couple of years ago:

  https://git.netfilter.org/ulogd2/commit/?id=3D49f6def6fcbaf01f395fbe00543=
a9ab2c4bb106e

and the fix should have made it into the Debian & Ubuntu packages.  I
will investigate.

J.

--pkw5chjoOcsEkeaK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

wsG7BAABCgBvBYJnhPT5CRAphqwKvfEEDUcUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmc7axJPyH4+hYPrIrGKkXmW9RuqygjiCj9R+xIQW/xV
gRYhBGwdtFNj70A3vVbVFymGrAq98QQNAACPAg/+OUzdR/um6Nmy/QE/NkakQOIM
3bWZnlCTGu964P5cOBGlUDyoKrnkWDcpT7Kg8x0q8GZakgmue1VUwYAzJ0NT8nau
hCR/89Q2lTtsu7KurruDGIJTiY//aYRWiOFBYhNIpzASUWPOH6nvarglepn05dbK
FrWppoJrO+UlHvq5ODagdBvjMbaz+IAAmWjJkD17mvy+HlPFrZzGv0PPDZcJIIte
zDUX/CTNTOaBnn4ObEWCyxKTsYhxAto48kgcJsPfJwRTpu7sCV1//W8f4jvSe+b+
OHGBCmEoPjhIV2i0gZEmhmg9bDXZT07QFHOuignnzw/5OL14S5a4TtD7PzePiJLA
eCoWeOjVP9Pze4XGhAQrqqHXKoaTATL+GmNaQgWNMIRylje1gGEhGFUYi2PZm9SH
MeaZBAudELTGJU7oAZFtijWMXX+ziSXXwNBGcpViFcVQ8NZn4h2/+V54MHvjw+bg
69vIMaSs76AQ6npUxm5TxGmp7Hwjphpp+CPObQqhRsz9iGabzeMsGZgbYc9UhdL6
veojksa1WKj5iaI6YlzdWn2YG4VVkRrbqIpumzNWH63PyRTGV1v1zaoK8JjRqvxe
eTvE0CYp9fL3xSMIRxUEC3OkCpIFz3Hv1wgP3CNdFA/Ydgr8NKbF918D46H3gmse
u7UbX+8zWTTGUi8SgpY=
=5A/c
-----END PGP SIGNATURE-----

--pkw5chjoOcsEkeaK--
