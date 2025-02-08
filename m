Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047D01AA1C4
	for <netfilter-devel@vger.kernel.org>; Sat,  8 Feb 2025 21:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739051308; cv=none; b=Rhn3EIQuVut/ZFku+XZGMkaXf1Poejb4UYEL9tTSfkw5gwAVDM0daU7CbWeR6AXXV0Ttyav9rr2Enn15YHEGsWphZ08JiFFsDvgnCIycTrcdPGGq41jeQP3HlzeB+Sj6pLxois44qiBgg+BaTvYwimzYpc4Pw7N6yXJJb9vTMVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739051308; c=relaxed/simple;
	bh=xS2EfHjzQJ7IFe72xi2yXBD8H9h75fwCTskOU87AyVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MgMciNuXBVQy1lL+H48Nn19IkoAU241udGX4ySGnRbjuoj5IGXaTaH7oFNObnJQxAQQtjkJQ1tjCX/M0kFLS+XKuWRKJ4RvO9g744sU7FPv1QaOZpMaMxhEscsUUZKdAvmGeUhc26r2TuBkHwqDgd1NAHLz/vVNet9kp2qcaajk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=cG/r7URI; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="cG/r7URI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nBqXSMbcMwblsWqDu/RYPrNsFxToL625tOP2nuAH0q0=; b=cG/r7URIUGuKUBSW0HnHoa4cOA
	bJ8l+VjLlk0KdVxhY36fY5NJwBXqq0nW6vo2xgASJu5iW6/xdLMO40a5Ok0ezRBeT4ocz+9M39b+2
	zj7yWRjkO6VERztNVMIKAYvP1EZDkpbHeS+EMTtLqeVXAsOWuRYx4oR6O8DYwePna/9fb2YhArJVK
	xsbXB6KiQ2dUcRcs203z3TEYVxXHQ9AXszrjnKg1w3XmqUAV1tzWvTb+ZP9pmrrKcViLA56OCAmWK
	kOOrt4JjS0XG/JLo6WKYeZFS4uPv/dM4PuvZ+sWAL/mL6CFtLoI3Isvy1+0AzEmTz/qTvIgemNzcW
	pu/GVnMw==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1tgsgX-00D0DL-38;
	Sat, 08 Feb 2025 21:48:21 +0000
Date: Sat, 8 Feb 2025 21:48:20 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: corubba <corubba@gmx.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ulogd2 2/3] gprint: fix comma after ip addresses
Message-ID: <20250208214820.GD2199200@celephais.dreamlands>
References: <0a983b51-9a51-47a7-bbdc-9bf163a88bbd@gmx.de>
 <2e047e50-e689-4fbb-ae58-bc522a758e40@gmx.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="NtI3C4l7E94pyhnK"
Content-Disposition: inline
In-Reply-To: <2e047e50-e689-4fbb-ae58-bc522a758e40@gmx.de>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--NtI3C4l7E94pyhnK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2025-02-08, at 14:49:49 +0100, corubba wrote:
> Gone missing in f04bf679.
>=20
> Signed-off-by: Corubba Smith <corubba@gmx.de>
> ---
>  output/ulogd_output_GPRINT.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/output/ulogd_output_GPRINT.c b/output/ulogd_output_GPRINT.c
> index 37829fa..d95ca9d 100644
> --- a/output/ulogd_output_GPRINT.c
> +++ b/output/ulogd_output_GPRINT.c
> @@ -179,9 +179,15 @@ static int gprint_interp(struct ulogd_pluginstance *=
upi)
>  			if (!inet_ntop(family, addr, buf + size, rem))
>  				break;
>  			ret =3D strlen(buf + size);
> +			rem -=3D ret;
> +			size +=3D ret;
>=20
> +			ret =3D snprintf(buf+size, rem, ",");
> +			if (ret < 0)
> +				break;
>  			rem -=3D ret;
>  			size +=3D ret;
> +
>  			break;
>  		}
>  		default:

My suggestion would be to follow ulgod_output_OPRINT.c (completely
untested):

diff --git a/output/ulogd_output_GPRINT.c b/output/ulogd_output_GPRINT.c
index 37829fa49e9d..b18fe3a0838c 100644
--- a/output/ulogd_output_GPRINT.c
+++ b/output/ulogd_output_GPRINT.c
@@ -155,6 +155,7 @@ static int gprint_interp(struct ulogd_pluginstance *upi)
                        size +=3D ret;
                        break;
                case ULOGD_RET_IPADDR: {
+                       char addrbuf[INET6_ADDRSTRLEN + 1] =3D "";
                        struct in6_addr ipv6addr;
                        struct in_addr ipv4addr;
                        int family;
@@ -176,10 +177,11 @@ static int gprint_interp(struct ulogd_pluginstance *u=
pi)
                                addr =3D &ipv4addr;
                                family =3D AF_INET;
                        }
-                       if (!inet_ntop(family, addr, buf + size, rem))
+                       if (!inet_ntop(family, addr, addrbuf, sizeof(addrbu=
f)))
+                               break;
+                       ret =3D snprintf(buf + size, rem, "%s,", addrbuf);
+                       if (ret < 0)
                                break;
-                       ret =3D strlen(buf + size);
-
                        rem -=3D ret;
                        size +=3D ret;
                        break;

J.

--NtI3C4l7E94pyhnK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

wsG7BAABCgBvBYJnp9EjCRAphqwKvfEEDUcUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmcRln+XJeC/W9dyY/UEWBn93iLX6Qbg5XJ0WOrLx97q
WxYhBGwdtFNj70A3vVbVFymGrAq98QQNAAAsURAA0nvbufXnG6W/vZN3sVyMBFK9
Pd4Oegr65csZm4FhY7sF5fzCzuLZgPc5rfb3AT25BwAxTzaByEMwr0HG+woUOQSV
xGclYLe5ooqvbagGV4zqZpqgEao3jiGpULJkL7j3bqrsjxT6HP6Gr/bKrXEty3nU
N4hnJOXS4ZyFuv2Anadg2PGkDSNPDGB3/Kms78Q6YGpuOrSUSnuFsvH0GsW0EAOT
4zjU0in0QIp7lAgP4uXI4W60PpffKVUG7ZUBKiQvETH/gkbyGBHeg7zxJWHFc+4Y
Efo1oqqN1pVmJxqLha71I/7smKhHJfv5liK5CXjA0IkXm0Y4b9zElFOeVXGQOnWE
4SHZINqIJVU4nNVk+gGwLaNdznuqbJmQs338QuTUdZa/03lNULYAIlQ/nNoLjWG0
aV7nKhX7k6h8PAoZ5dR4AWE0MQjipaZ8pOONdALOC49+toLqIJQnYz3B//DqW4cC
colOQyWaEoScfiBLZUJjzQ/qlia6oRGeqmc2IE+ZSHvocSpmJupJQvvcXhCEVgHy
5mgzUmDR3YuPBSJvd708Yv60VRUCPwCQ7P/GowwjV6iemoNboO53IZb85DxOEFH1
O3LHULNu3fEEzaVTEdOUZ2Y7FBU4FuEhPNlk3znlSvJHJOMxULjT1JL6rcBCmz57
1FmPjFquzV9+eUqx6lI=
=s23x
-----END PGP SIGNATURE-----

--NtI3C4l7E94pyhnK--
