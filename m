Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E745C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Dec 2021 18:47:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343970AbhLOSr3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Dec 2021 13:47:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343977AbhLOSrZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Dec 2021 13:47:25 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A99C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Dec 2021 10:47:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zi3BYaZjeKMlSutxLDxih9oi2rGSKu9mxFOnWXtk8+Q=; b=mreY+UIVrFHz/+oN/Y6kWaZ/IH
        YNfDgipEiCbxgasekokycj3FVZ641pHM10Wk8VBkjDC01Zkxc1N/Y2NFzpH/uktW6IntbTfEQV3Gg
        z1gnuvGPRmEZgLf0TDpIpL2dR7RdxM/ewnF/VaWSwJYZpejPqEaHbqrLakvFSovAUB5YQ36lvptIO
        BTlqbexu332Ky59ebjEE5TwoEs0ycKMEqAkA4ZWWjtWFf8lh+ug5inz3wCQ1VrtHg8EKXWzHo74zO
        tQuCbM8dRswob2Rz4iBL/28w/7x/tIAkGHc2AhixmZZNomwk3T58AS146jagEOWRGnHvGzklpPScX
        ZhPLFCOw==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mxZJD-008YcJ-4e
        for netfilter-devel@vger.kernel.org; Wed, 15 Dec 2021 18:47:23 +0000
Date:   Wed, 15 Dec 2021 18:47:19 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] tests: shell: remove stray debug flag.
Message-ID: <Ybo4N6NsO/kpA3rJ@azazel.net>
References: <20211215184341.39427-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cVs18uzJBrf4WnZs"
Content-Disposition: inline
In-Reply-To: <20211215184341.39427-1-jeremy@azazel.net>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--cVs18uzJBrf4WnZs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-12-15, at 18:43:41 +0000, Jeremy Sowden wrote:
> 0040mark_shift_0 was passing --debug=eval to nft.  Remove it.
>
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  tests/shell/testcases/chains/0040mark_shift_0 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tests/shell/testcases/chains/0040mark_shift_0 b/tests/shell/testcases/chains/0040mark_shift_0
> index 55447f0b9737..ef3dccfa049a 100755
> --- a/tests/shell/testcases/chains/0040mark_shift_0
> +++ b/tests/shell/testcases/chains/0040mark_shift_0
> @@ -8,4 +8,4 @@ RULESET="
>    add rule t c oif lo ct mark set (meta mark | 0x10) << 8
>  "
>
> -$NFT --debug=eval -f - <<< "$RULESET"
> +$NFT -f - <<< "$RULESET"
> --
> 2.34.1
>
>

Forgot to set the subject-prefix to "nft".

Apologies,

J.

--cVs18uzJBrf4WnZs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmG6OCgACgkQKYasCr3x
BA1VCQ/+LTK46qwrO2/bC6eHfa4t9G+DslVGxjE6oV1dx78Kcpexc+vTOsmPWXJA
3H9AskHdWKeMd4phiyWoyRRTjjavTw0LtNukWAU84a5ucmFSGIC5wDTG+6pwwHEd
FxLPesaKGqX4OuM6S4bGiUjeQafAVZ2ZOoDovkybFFb5aId9sL+YYt3vZgCTYWwy
4sK6eKZHO5qXZEqIDsmQSAg9ZxhgdNaabA1xAz+evB22kOKxribSVSEue/yaQlM+
hGApsqZapyqpJ793OdXNMIMO5q+KhuhC5i2BHHE7X48QZL0tFkM7p2CQitZkWLZ6
g8iPiYnwxLA2TrrQZVlEC5s+RStr2dxsLbaWrhGs9dySxeYITB659n8sWEwgdu6G
8qYp/dvb8fCkLXwy/S4KdEcqyg01gf8ET3e0kLdG7mIx2muV2WMgUTWNoXO2eZLZ
z3vhVG3dhjktQHwczNewxYHMgPMNFkKbis7PBHhZ7g/+m9lvhHnm67xeAIdgk0ll
MM+MwTWPE7m2CKmyQLvfuMiUxwX6pSAVCl6cKBwTKnmVrWZVzU417HUN3mBvzZix
TKI16GRJIVTT9LoxWrhwtew22ZRM9XP2BGi2WVTPKeQo9tnsETiUcE6OsvdOFlv+
mnglgpjhth4FTrVjh3CTu2c9JGiHAXV3FzQjIPwJJVFW5mol14E=
=TybH
-----END PGP SIGNATURE-----

--cVs18uzJBrf4WnZs--
