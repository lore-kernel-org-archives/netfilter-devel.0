Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E51DAEE49AB
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Aug 2023 11:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbjHULMp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Aug 2023 07:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjHULMo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2023 07:12:44 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F0C91
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Aug 2023 04:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zvzR2rPF3OLFzVsSeAAacAI94PpjqdOQhpMH0X4bd74=; b=BtIG+RmA4o/eLOl3VoBJXxJNTj
        lRrnRPiCSPLvCEC3NqdjZOjgxkzVIetWhLUibBY9l3B1MvkYvcRcEEyjo7uyJMtii3kf5iEKYoEoO
        DrRmt22CC2lWgBk+QDk8TyjjRjw56QOLcFwcVUZDH5bFAqH3LjBF24wDOJlMjFbMH/nrMUt0vayVV
        1hgosuIrD8t3PSwzqtEgYpePD6N3pEiIPVWjifC4ifchje7ML3D9IpogchDmriucsIsvCb8ps6S40
        gNAYrlonjjW7wzrpa2obhG4bEBWuNoG1nZ0RDDRU4s6yBWs0lQIx5jskb8Je+E+CWIzmLh0M/LBHb
        lnNET4DA==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=azazel.net)
        by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qY2pn-008qHt-2a;
        Mon, 21 Aug 2023 12:12:35 +0100
Date:   Mon, 21 Aug 2023 12:12:34 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nft] INSTALL: provide examples to install python bindings
Message-ID: <20230821111234.GA5268@azazel.net>
References: <20230820220720.49615-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="WxA6ZslHHLFnm3Dy"
Content-Disposition: inline
In-Reply-To: <20230820220720.49615-1-pablo@netfilter.org>
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--WxA6ZslHHLFnm3Dy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-08-21, at 00:07:20 +0200, Pablo Neira Ayuso wrote:
> Provide examples to install python bindings with legacy setup.py and pip
> with .toml file.
>=20
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> Florian noticed that `make install` does install python bindings anymore
> when running tests/py. Provide a bit more information on how to manually
> install python bindings in the INSTALL file.
>=20
>  INSTALL | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/INSTALL b/INSTALL
> index 53021e5aafc3..6b026e2c20c1 100644
> --- a/INSTALL
> +++ b/INSTALL
> @@ -86,8 +86,13 @@ Installation instructions for nftables
> =20
>   CPython bindings are available for nftables under the py/ folder.
> =20
> - A pyproject.toml config file and legacy setup.py script are provided to=
 install
> - it.
> + A legacy setup.py script are provided to install:
> +
> +	python setup.py install
> +
> + Alternatively, a pyproject.toml config file is also provided install:
> +
> +	python -m pip install .

How about just:

  CPython bindings are available for nftables under the py/ folder.  They c=
an be
  installed using pip:
  =20
    python -m pip install py/


J.

>   Source code
>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --=20
> 2.30.2
>=20

--WxA6ZslHHLFnm3Dy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmTjRpQACgkQKYasCr3x
BA1tCRAAzzLPjU0CLuQ4x2Rx7aWjIN1MEqJaOSoH/C2RKo9uf1deocYtM2Cdi58i
ur6xeeEWYw/2WKoWhVxUJDjf9STHvEzS3ifrLa1AOFsGeGbmphyfhIY1FvGpY4Nr
m/tSH0mIZUNtsjczHK2RCT/OFZ7MWLh+56dK5nWEyZhNrlWbLj4rxU4ybKu5+Y6j
3f472Bu+yJPmwJpMzkM15fUDfQLsBoOTE6REFzTJmhbY1pHZml0j9eToQKt0ZJoF
Ov5Hug3K5f5zFf0xVnZIE0IQEuvPK2Iqhw+0HtwEndEXb/5PIld29aggpAQuQsNO
wLOS3gPidtlwlu2fVjf3ewRO+g69jVkteInvqpZI9weg0uTKLQHccuOwxNP2+7do
2oQcBOAyt9Bj07teilN9wy0g/YNm3oA14t9cT+qatCs29Q+LM+/1NeNU3Ppiwis9
/1Y8/39YFDiPGLz4KZeu83QcJkGvPVQkv3ObDwHy/UUG6V1kLN2LO/OXv1VDCgfc
75d+LKBbWOSwa9B7BFmUo9+ziSuVwf3fQIfR2VmYJVzZRx/KbrSLX1R6FuphjEHs
gR75pGizViPxeKI/k/YP/qptMu4eDYsfzvXF8g3SuCQwnOSVNey7ehnR/bS93WJx
dFrS/LNBYy1GjAfeeGGIoX26arAM357N+2GoncgTsr6BsjRXKrQ=
=p52w
-----END PGP SIGNATURE-----

--WxA6ZslHHLFnm3Dy--
