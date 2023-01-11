Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90B84C5479D
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Jan 2023 18:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234282AbjAKSet (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Jan 2023 13:34:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234294AbjAKSeg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Jan 2023 13:34:36 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B176333D51
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Jan 2023 10:34:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=f4crEjQ6lnZyRMxAmi/ESArBnf/iOu4hQV/G822XuCE=; b=OrIIyeWDSZjdOZC682lZmfl5ix
        ekvQlptlvFeEF2gzK5jok0p+PXYEjTzpKBbTLK/rlJk2l+2fs2POANZZKHTKY3zwkxYiIsSg/B2d1
        jxCebWqS+y5xamgGBp5u3IxADOTH26jiKZHJJ7ki7ILkDxgU2fDkodx7I9bV6rVnAM7tGD/UkUuT2
        l6j/0nmMjAG2BtY0F9aRjssC3GglLm/I2sl4niK8vdS9Zo4pCT222nLhZ40WSt+l588Q43vV4+bWg
        3p2a6+yspm38UkQpMT9sYfGPJ06eXwywTJvFv7yVCx/8LggB6D7s/UerntzxnWMKPscGDsVKE0fM6
        Y6LjngWw==;
Received: from [2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] (helo=celephais.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pFfvd-00C9SI-Do; Wed, 11 Jan 2023 18:34:25 +0000
Date:   Wed, 11 Jan 2023 18:34:24 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [libnetfilter_conntrack PATCH] conntrack: increase the length of
 `l4proto_map`
Message-ID: <Y78BMDGFGJow0Hcz@celephais.dreamlands>
References: <20221223123806.2685611-1-jeremy@azazel.net>
 <Y7758rNEafF9XurG@salvia>
 <20230111180818.GD27644@breakpoint.cc>
 <Y77+FQ06j+gRFURI@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="/jr57AbP05ebXEZ/"
Content-Disposition: inline
In-Reply-To: <Y77+FQ06j+gRFURI@salvia>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--/jr57AbP05ebXEZ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-01-11, at 19:21:09 +0100, Pablo Neira Ayuso wrote:
> On Wed, Jan 11, 2023 at 07:08:18PM +0100, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > On Fri, Dec 23, 2022 at 12:38:06PM +0000, Jeremy Sowden wrote:
> > > > With addition of MPTCP `IPPROTO_MAX` is greater than 256, so extend=
 the
> > > > array to account for the new upper bound.
> > >=20
> > > Applied, thanks.
> > >=20
> > > I don't expect we will ever see IPPROTO_MPTCP in this path though.
> > > To my understanding, this definition is targeted at the
> > > setsockopt/getsockopt() use-case. IP headers and the ctnetlink
> > > interface also assumes 8-bits protocol numbers.
> >=20
> > Yes, this is an uapi thing:
> >=20
> > socket(AF_INET, SOCK_STREAM, IPPROTO_TCP); vs.
> > socket(AF_INET, SOCK_STREAM, IPPROTO_MPTCP);
> >=20
> > Only second version results in a multipath-tcp aware socket.
> >=20
> > If mptcp is active (both peers need to support it), tcp frames will
> > have an 'mptcp' option, but its still tcp (6) on wire.
>=20
> Thanks for confirming.
>=20
> Probably I'll post a patch to add an internal __IPPROTO_MAX definition
> that sticks to 255, so libnetfilter_conntrack maps don't start
> increasing if more IPPROTO_* definitions show up in the future for the
> setsockopt/getsockopt interface.
>=20

Fbm.

Just to be clear, the problem I wanted to fix (why I didn't put this
in the commit message I don't know) was this from bsf.c (ll. 473ff.):

        for (i =3D 0; i < IPPROTO_MAX; i++) {
                if (test_bit(i, f->l4proto_map)) {
                        j +=3D nfct_bsf_cmp_k_stack(this, i, jt - j, j, s);
                }
        }

where we are currently reading past the end of array.

J.

--/jr57AbP05ebXEZ/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmO/ASkACgkQKYasCr3x
BA0VtxAAx3uJtTN8fhv1ECKauFXYYdvrdoDi6+sJy5DOB5R5/3jljm38gspp3zUv
JyA/K6LeyostQFrCnTqUl/HafO/3TtBgsaqt/uYcMnoYc9LJg/CH1P8ce1rPS7V1
8rN8jF+khjGMieiAi44jSej64KmLgWSVyzSUPgZoW2x9uS9tsz9sXoWa8Gi6x2Ex
c6fsFXp4rsHkH4tq/wX3InNWFx8RQiSw6j/ZIwb+TySha6yD7wu6uBb9iL/+BL2d
MFuha726rWArNIItbnrtaxwfeiZ66sD0WqEW/ReCnBFxGBNthUekbMbWETI1G3/+
knrcJjPgvcmHeN3d462Oed7Z5jQ1PcKOp3DpFTUuM5njBbZi6m3ATdrzLhtuGRKU
PWcqUTPLcuukYLOuHpS6dB9S+WGw8P5E1KJP/Sws390es32cIimx72SUlIEKmPV8
+09k+FGxXzU8fmgqu+zbdJfsjAgTyNSUCkc2FpyjlvaBVuOPN86ESjGCl7fT0ZQ2
eH5fPZto7yM+0NXR8S7be84H5nbqdVC5PnX23LTOAmUt+Ibc5Y1OxTZlTl8Ho9a5
8iFGSZwLZfxoOLOmQjlynYS7tx2BVtD5GwVyYJTnjpJjpTLOU96GVVhQ7jFj3Sc3
YRw21q9KnbaVdHFlkSLFLo6HvWjZw8V4yayRn9q5wT+NOAbPfc0=
=5w1j
-----END PGP SIGNATURE-----

--/jr57AbP05ebXEZ/--
