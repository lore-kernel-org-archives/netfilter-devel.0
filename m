Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0B14EB64D7
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Jun 2023 18:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjFTSKy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Jun 2023 14:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjFTSKy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Jun 2023 14:10:54 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C130198
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Jun 2023 11:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GeH09Ch9zC7FBqTz9iZ2VYifE14z/QI1KFOkCyAmRYM=; b=ibV3QSZT+XVH0uJBlGQ7QJPS6K
        lwRa0aAIANdf0wI8ZCn+87LaB49vc7/FmFZJrAvwVJXqHENrONwvEmd1WpdAXqkkO+08TvpO0/GyL
        ca+S9GiYVBTFSLIL/lDMrbgHgojTWM1OlFolO8cnQTn8WZ7DAUNJo8UqGIMtDj40MA30OVvPMN1tL
        WZi0kp/RhpiVDzaHb7VYW6pQAczzakDUBWN+1vrJ9taPQ+B1OPBvAGbJMK4ehgYUSBJX0VFXWwzF6
        O7KKUTdq2KC1nuxYB7DarJkX7KWErct5r7LK7i1RBsh5OiOZiH+Rup2Ke2Mm9vV+qU0iFKFZnAw6S
        rLk9sMMQ==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=azazel.net)
        by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qBfoZ-009DPe-33
        for netfilter-devel@vger.kernel.org;
        Tue, 20 Jun 2023 19:10:51 +0100
Date:   Tue, 20 Jun 2023 19:10:50 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next] lib/ts_bm: add helper to reduce indentation and
 improve readability
Message-ID: <20230620181050.GF82872@azazel.net>
References: <20230620180925.2010176-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gjtYfXbF2I75emOU"
Content-Disposition: inline
In-Reply-To: <20230620180925.2010176-1-jeremy@azazel.net>
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--gjtYfXbF2I75emOU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-06-20, at 19:09:25 +0100, Jeremy Sowden wrote:
> The flow-control of `bm_find` is very deeply nested with a conditional
> comparing a ternary expression against the pattern inside a for-loop
> inside a while-loop inside a for-loop.
>=20
> Move the inner for-loop into a helper function to reduce the amount of
> indentation and make the code easier to read.
>=20
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  lib/ts_bm.c | 42 +++++++++++++++++++++++++++++-------------
>  1 file changed, 29 insertions(+), 13 deletions(-)

Sent the wrong version.  Apologies.

J.

> diff --git a/lib/ts_bm.c b/lib/ts_bm.c
> index 1f2234221dd1..d74fdb87d269 100644
> --- a/lib/ts_bm.c
> +++ b/lib/ts_bm.c
> @@ -55,6 +55,24 @@ struct ts_bm
>  	unsigned int	good_shift[];
>  };
> =20
> +static bool patmtch(const u8 *pattern, const u8 *text, unsigned int patl=
en,
> +		    bool icase)
> +{
> +	unsigned int i;
> +
> +	for (i =3D 0; i < patlen; i++) {
> +		u8 t =3D *(text-i);
> +
> +		if (icase)
> +			t =3D toupper(t);
> +
> +		if (t !=3D *(pattern-i))
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
>  static unsigned int bm_find(struct ts_config *conf, struct ts_state *sta=
te)
>  {
>  	struct ts_bm *bm =3D ts_config_priv(conf);
> @@ -70,19 +88,17 @@ static unsigned int bm_find(struct ts_config *conf, s=
truct ts_state *state)
>  			break;
> =20
>  		while (shift < text_len) {
> -			DEBUGP("Searching in position %d (%c)\n",=20
> -				shift, text[shift]);
> -			for (i =3D 0; i < bm->patlen; i++)=20
> -				if ((icase ? toupper(text[shift-i])
> -				    : text[shift-i])
> -					!=3D bm->pattern[bm->patlen-1-i])
> -				     goto next;
> -
> -			/* London calling... */
> -			DEBUGP("found!\n");
> -			return consumed + (shift-(bm->patlen-1));
> -
> -next:			bs =3D bm->bad_shift[text[shift-i]];
> +			DEBUGP("Searching in position %d (%c)\n",
> +			       shift, text[shift]);
> +
> +			if (patmtch(&bm->pattern[bm->patlen-1], &text[shift],
> +				    bm->patlen, icase)) {
> +				/* London calling... */
> +				DEBUGP("found!\n");
> +				return consumed + (shift-(bm->patlen-1));
> +			}
> +
> +			bs =3D bm->bad_shift[text[shift-i]];
> =20
>  			/* Now jumping to... */
>  			shift =3D max_t(int, shift-i+bs, shift+bm->good_shift[i]);
> --=20
> 2.39.2
>=20

--gjtYfXbF2I75emOU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmSR66oACgkQKYasCr3x
BA0pxhAAww3TWvHuSImtoKB1dSpVYEtbhfwpdzEq3AR8JHbeNQIbWcEIpplVLS0C
UzrVkprHx7pX+KTe0HAID3aB2YhLT4TDVrwby4tzh88QW4SPT3zukHLUlKKLvksu
ER5f3BKPukxP/L6eOpv2V6OrHD0RSuc2aKTAgl5MG+64SJ5ZWXOciLp+Z709rK7A
v1/B2f/lLlcmCu92rGxJUDqy753AIWe/Se3k3PY69vhpIqj3UQjIlu4WmRzH5s4C
KPJfsaPxQwsAsO8zU6611NysICbcmF6p+UB61StACfkek60G4jae9BReJ+ef5hxB
9VoTepWHHn9Mw/MIR+jsuAa5hMOQge6nsL64q04kloiVyw/WcNCv3z5qgBlrRxeE
XIg1f4lSFU/HXdRmTJPuwelqMghQGgtz5AuuEg8AQf28GBWgGwKECYhX9I8yoCTP
PheQOULpcQ+YCKhLAj7D7AR7p39oqLbhGJxKG5N3jmzSj+Yv6lmD0IwIHYa/4lJz
ayxSQuOc7ONBOZ3z5Y1Mdr1TbloqQ/sz6hWQnxMnMRlQDXAi2xl8crziajfvRhSe
KeyyHIz3W50p/iej94rQMpPdzNQZYqEQhyQDIgS87RYynSTS1Nro5mGnjKpzH4k1
+Q3D1FLw11/o8VF13F9up3MZOU72fGmWM/Fx+CiO5qU9w5g5JBk=
=eSRR
-----END PGP SIGNATURE-----

--gjtYfXbF2I75emOU--
