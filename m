Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80B2AC6FD1C
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Mar 2023 18:10:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjCWSKC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Mar 2023 14:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbjCWSKB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Mar 2023 14:10:01 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A598A270
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Mar 2023 11:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DtUme4fJgYhI985ZkYvWe8YPC1SV5Ly5A1doMMXDKzk=; b=RWmGzakOQdK5KRmsKqrHKrdAsP
        uOreLMxbiVua7+hoOpb+8YMKNblsVcmSksciZjtFdtFg3fL+BTfyh9Be/WjXWXzZ5zdiCZhnYDk3f
        RjIhgNU6htBz1WjyS+2uaIaf9mkYonvfCxeeSIO8lpJmJyv5waF598g7C+6y8CjlEvL+7wUVKC/L9
        GTfLwJf1xU6ubqsoMDdCB5yzMOeHTGRB9g3cR8t9lDuSMAhPeh33uq4LzQrTeEk4HVH+s4XjqQdm3
        J0jmIOSM8VzuznHry/gPHmu6TuDYUYOOYl0N1LC+MKn6w2iWmnyYc1JHJT6fpQolS9Wjn1Zb0yemX
        sQnyeYag==;
Received: from [2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] (helo=celephais.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pfPNu-002nHw-6a; Thu, 23 Mar 2023 18:09:58 +0000
Date:   Thu, 23 Mar 2023 18:09:57 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] payload: set byteorder when completing expression
Message-ID: <20230323180957.GE80565@celephais.dreamlands>
References: <20230323174733.635835-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="tMPLFXjbWykFME/9"
Content-Disposition: inline
In-Reply-To: <20230323174733.635835-1-pablo@netfilter.org>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--tMPLFXjbWykFME/9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-03-23, at 18:47:33 +0100, Pablo Neira Ayuso wrote:
> Otherwise payload expression remains in invalid byteorder which is
> handled as network byteorder for historical reason.
>=20
> No functional change is intended.
>=20
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> IIRC, Jeremy posted a similar patch.

Indeed:

  https://lore.kernel.org/netfilter-devel/20220404121410.188509-13-jeremy@a=
zazel.net/

>  src/payload.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/src/payload.c b/src/payload.c
> index ed76623c9393..f67b54078792 100644
> --- a/src/payload.c
> +++ b/src/payload.c
> @@ -991,6 +991,7 @@ void payload_expr_complete(struct expr *expr, const s=
truct proto_ctx *ctx)
> =20
>  		expr->dtype	   =3D tmpl->dtype;
>  		expr->payload.desc =3D desc;
> +		expr->byteorder =3D tmpl->byteorder;
>  		expr->payload.tmpl =3D tmpl;
>  		return;
>  	}
> --=20
> 2.30.2
>=20
>=20

--tMPLFXjbWykFME/9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmQclfUACgkQKYasCr3x
BA0VtRAAzdgOX4ArKtTbSbLblm1KkTzJ7uO54ObjyGDiJ05ZBGGIRmP4xiK8/Iuy
BFkfw1PQjmN/bAfoiIn4Y33I9/tsGFEOXeoFr4UjfS4nTi5VUyN5Kq4zU8Y31VYf
Fj6IBLrsUdGBwqLTiPj7Y4OAdBeycdEU5ZiCuqWtbTKecVzaKOquOZ8WPUmMCcs9
R7co96lahVX4k29Av8+81XTvPMp+HfhVId+6VKHelZjir5eZpAWzdyCVzP63SlQt
+2HeLVDl2tlPGHw2I6MaaWBXtxP3mFqXpiZLCwasdTR9t4LU2ufhdJCxYdDPdjEA
Q/SHWKUEELyz/cUU0omN2gtXtTxBI/IyomMeFgkWkwWSWhsFH+wYacU3CkQpmbvE
myEX3eStFFDbXmiixPONv8SuDr0NpEyFPyhBMojK9WsivO/6M3CECWcT8ROqpKd2
1+gHqhCcSI6Q1sc5HfwB3R/r8qasqI+hll3UIBjTIJJlZ/PNccMOYAbLJPmc0f6v
dNmH+twi6cLppwWpqyKfiz13DLAzrXjBGCfal84wFLftPgaLkGoAJ38tlrpCKlkb
Xye6YcmLk2P2Lms47SKAwwK91gFq5U22T0NiKH818X3JJMayYW+2oYvfqqKN9SG2
Lo2GrUOK50M2ZQNBUEhUgV7XTBpXKdFTvn7Q6eLYd9R9aWh9hDA=
=XH20
-----END PGP SIGNATURE-----

--tMPLFXjbWykFME/9--
