Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A63B382391
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Apr 2026 20:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776802091; cv=none; b=rxNRVVtsRQtkgD7j3ZNDOZpmCF7b6uTk0pdQyc1frSs4maBAUXAB0Wesq0M29IbOBt8qMkyosQbJzpnZIjY+Hd0Lrj1YFijy1nsQ3BLd7M39x9+zQ+hHv+j1rc4YtGlSjEc4OA65AWWQTg5n3jtVEFnbNPi8BRc5yijmSG+S3jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776802091; c=relaxed/simple;
	bh=8xHF7dEWH8gC5oOu5fMiPUOBUmcx/65H1uNj0Vfvgho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NFOwG+5/1i+kviaE9vcsb6Ezbro89TQsJOh1GnlkloWWIobnCwLhWtqF69eLULtMUjBENBlb4EHIzHiozLRbOlexionerIhdaVX292iuxby3Urrjce2VMzSb/OgaIf/ParDbfWNupId0i1PpEF7lDNw71bJ3vCFMQKBGqMfJHwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=WUyWK46u; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="WUyWK46u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=I4kHa3T2sQxFZGqNFgsyL+g/Ld8nU+akMCOuCDmIP7I=; b=WUyWK46uZ6v6MH8RCZMuo/Jykw
	9t6F5b7awvJnq5kxRDUYRZdE5iM0vWGigynVsKFJFv3ywVO/LA6KEMnJKsaY2UXenCaTEJm/MhGLT
	ASRuREAV/LsYI9HXxXW0XgGMf7vaJu5glMUMsRllrIOOcmk4j6PH8sDm0e/lq8kj+YgahE0+v1wLh
	C9stW5/bgdZQgL9bislyw5+0bFHH7Ms6J69cJYPiGJufNOXvAH/j6GAyxynS822UeeK5wYJrb/akc
	KHg5XOGM0I4wNpsK4rNpqBMn/dsh7/m7itau7zCluwxxUTbJ8j967QVT9/BtgDqTpGVXkKEZFKhCY
	v6r5Hr/Q==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <jeremy@azazel.net>)
	id 1wFH6W-00000009lyL-0YCc;
	Tue, 21 Apr 2026 20:49:52 +0100
Date: Tue, 21 Apr 2026 20:49:51 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, phil@nwl.cc,
	fw@strlen.de, pablo@netfilter.org
Subject: Re: [PATCH nf] netfilter: nft_bitwise: fix dst corruption in same
 register shifts
Message-ID: <20260421194951.GA1976704@celephais.dreamlands>
References: <20260421173851.7945-2-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="F81ePTK3g0a3riya"
Content-Disposition: inline
In-Reply-To: <20260421173851.7945-2-fmancera@suse.de>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--F81ePTK3g0a3riya
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2026-04-21, at 19:38:52 +0200, Fernando Fernandez Mancera wrote:
> For lshift and rshift, the shift operations are performed in a loop over
> 32-bit words. The loop calculates the shifted value and write it to dst,
> and then immediately reads from src to calculate the carry for the next
> iteration. Because src and dst could point to the same memory location,
> the carry is incorrectly calculated using the newly modified dst value
> instead of the original src value.
>=20
> Adding a temporal local variable to cache the original value before
            ^^^^^^^^

"Temporary"?

> writing to dst and using it for the carry calculation solves the
> problem. This was tested with the following payload:
>=20
> table test_table ip flags 0 use 1 handle 1
> ip test_table test_chain use 3 type filter hook input prio 0 policy accep=
t packets 0 bytes 0 flags 1
> ip test_table test_chain 2
>   [ immediate reg 1 0x44332211 0x88776655 ]
>   [ bitwise reg 1 =3D ( reg 1 << 0x08000000 ) ]
>   [ cmp eq reg 1 0x66443322 0x00887766 ]
>   [ counter pkts 0 bytes 0 ]
> ip test_table test_chain 4 3
>   [ immediate reg 1 0x44332211 0x88776655 ]
>   [ bitwise reg 1 =3D ( reg 1 << 0x08000000 ) ]
>   [ cmp eq reg 1 0x55443322 0x00887766 ]
>   [ counter pkts 21794 bytes 1917798 ]
>=20
> Fixes: 567d746b55bc ("netfilter: bitwise: add support for shifts.")
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>

Acked-By: Jeremy Sowden <jeremy@azazel.net>

> ---
> Note: I found this issue while digging into the lshift/rshift operation
> ---
>  net/netfilter/nft_bitwise.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>=20
> diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
> index 13808e9cd999..136e8f3a71c5 100644
> --- a/net/netfilter/nft_bitwise.c
> +++ b/net/netfilter/nft_bitwise.c
> @@ -43,8 +43,10 @@ static void nft_bitwise_eval_lshift(u32 *dst, const u3=
2 *src,
>  	u32 carry =3D 0;
>=20
>  	for (i =3D DIV_ROUND_UP(priv->len, sizeof(u32)); i > 0; i--) {
> -		dst[i - 1] =3D (src[i - 1] << shift) | carry;
> -		carry =3D src[i - 1] >> (BITS_PER_TYPE(u32) - shift);
> +		u32 tmp_src =3D src[i - 1];
> +
> +		dst[i - 1] =3D (tmp_src << shift) | carry;
> +		carry =3D tmp_src >> (BITS_PER_TYPE(u32) - shift);
>  	}
>  }
>=20
> @@ -56,8 +58,10 @@ static void nft_bitwise_eval_rshift(u32 *dst, const u3=
2 *src,
>  	u32 carry =3D 0;
>=20
>  	for (i =3D 0; i < DIV_ROUND_UP(priv->len, sizeof(u32)); i++) {
> -		dst[i] =3D carry | (src[i] >> shift);
> -		carry =3D src[i] << (BITS_PER_TYPE(u32) - shift);
> +		u32 tmp_src =3D src[i];
> +
> +		dst[i] =3D carry | (tmp_src >> shift);
> +		carry =3D tmp_src << (BITS_PER_TYPE(u32) - shift);
>  	}
>  }
>=20
> --=20
> 2.53.0
>=20

--F81ePTK3g0a3riya
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

wsG7BAABCgBvBYJp59TPCRAphqwKvfEEDUcUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmepyEWhGcxG5ilGBKyYbzXkTGzocQWwSdk+IinsjGLw
3xYhBGwdtFNj70A3vVbVFymGrAq98QQNAAAxfA//WuabiO8vAq28HQeNrHCiTcBY
XdNBDWwUfzTu2NHHavgTx9qQKUbmcuBSysLdHXT7nHj4rN1AkbBGfWuACB65jz0N
61wjRHpNfTgIV7ZAOsXdEbvZC6L+CNpCdkL/vPX1lzudvpETFIfmJQWnnJEvEPdE
wJlIH7PKn7++dOYYK7Da0iv2GvnQ3rnmTLY7oqM7konVRNJDGDO2WBcRPUjm8JSr
OPCWj8BeA515LThBGNLIFe7cx61Qc6BfphEAq379SJu8ra2PL97esJzYLGy/45nO
vSMD+T+qLmPnaf5a1wmciJHWN3Bm6T8qNu6vLHGaNzAtNFscaZ4JJi+I5S5TSFyA
xnicBcvXzMJPcO2NvbOFctmoI4rXNMLFLlZY7y/EG4BeoBwhzeK0suzZmFeHV+dI
Lo0H2rfxMPlcSSJf64kE0067Gu+zV4SKX2qTxF6FJltPwbZt/o9JxSpKGGS0qt8e
NiybR4zD5MElCBxyasKbwv1XlD7DBUG6h33zhxfdZdInwmjuQP1vfro8de5cDi7q
E013JpvQ4KgA7Kb4T/mhhtOHU6rbSsi1BN7f2A+cxF5tEwM2E3BYagnPir2vkK6N
iWEHUY5PSReSiODW+aRUQb+NYxnqmCAP6crqII6ZXaPRCiysMpbNDwc3PUhABMI7
3Zz1O4dY45ePZ3F/Sxk=
=nTfW
-----END PGP SIGNATURE-----

--F81ePTK3g0a3riya--
