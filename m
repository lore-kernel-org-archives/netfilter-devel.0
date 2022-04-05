Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A68A0C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Apr 2022 04:47:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241019AbiDFEtN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Apr 2022 00:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444343AbiDEWVE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Apr 2022 18:21:04 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D87276
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Apr 2022 13:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GF9pVey4GOSbJSHjPnHizS4JcVdW1NogAJadg+1oYLM=; b=qu8mdlm8tWh9fPGAM/T+XBtc1w
        mgYqdQH4bAQNAzeuQI2lP3IIzqAv9N53I/QHA/U0JFrnHuT2/JTIrSKxCfSf/jw3Q1C72Ub/LShYC
        LUpdM6mndJ/Qf5XWkH+nux2n71C7CJxYMGhaUk1XO8dzbMx2S/mkdXSMwkSgYnLkaUMh6oeOSKxRD
        Gcu1+dTRf/dV67wMNnYy8ICN6VVnNG0hjEVTWpbuhFdLXm54wK2gwBOR/eTn/6/Y8bIz0brvZeoGv
        ESPmAzU9JHZxtG2pqmH8KYhOmOjomtmelhBT3rk2o7xfS50YhN9whUSQO98nEa3vQyQoGDhTF5PIS
        Wd1DkllQ==;
Received: from [2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbq5h-008PVm-JI; Tue, 05 Apr 2022 21:47:53 +0100
Date:   Tue, 5 Apr 2022 21:47:52 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nf-next PATCH v2 1/5] netfilter: bitwise: keep track of
 bit-length of expressions
Message-ID: <Ykyq+JE0/nTM/de0@azazel.net>
References: <20220404120417.188410-1-jeremy@azazel.net>
 <20220404120417.188410-2-jeremy@azazel.net>
 <20220405112850.GE12048@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kxiQ6lrF9coAupSL"
Content-Disposition: inline
In-Reply-To: <20220405112850.GE12048@breakpoint.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--kxiQ6lrF9coAupSL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2022-04-05, at 13:28:50 +0200, Florian Westphal wrote:
> Jeremy Sowden <jeremy@azazel.net> wrote:
> > Some bitwise operations are generated in user space when munging
> > paylod expressions.  During delinearization, user space attempts to
> > eliminate these operations.  However, it does this before deducing
> > the byte-order or the correct length in bits of the operands, which
> > means that it doesn't always handle multi-byte host-endian
> > operations correctly.  Therefore, add support for storing the
> > bit-length of the expression, even though the kernel doesn't use it,
> > in order to be able to pass it back to user space.
>=20
> Can rule udata be used for this, or is that too much work?
> The udata infra is already used to store comments and it would not
> need kernel changes.

It wouldn't be straightforward.  Expression udata might make more sense
than adding a new bitwise attribute, but that doesn't currently exist.
Would it be worth adding?  I seem to recall considering something along
those lines for passing type information with expressions as a way to
implement casting.

J.

--kxiQ6lrF9coAupSL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmJMqvgACgkQKYasCr3x
BA1GFQ/+IwR8MgK3Zz7QJQy/lFqxb7KEzNxwfUEHZsWvybKWH/dGanpoPY+VVcGk
rQGxJtXE39q6i1kQEXsFokJ3wuihGD18FiDE1J32iDaipETCiUixc2ByFgdNEfQP
kDiJZgu/sFoySFrExYaK74igCXnv48Ax4K82PfpmRCmqJuMAJ4oUR/3aSLp3XN1M
+TaIKA1sgXmuNDNDIbB0Op+HmID0fubaRSJiDckpaeez8IVgpsn4wILoemQiIGEa
flb6USCJnKAAf1u1j/KKZg6QjM2hrDsVid5BUYFKGaS9WeUmHtGDvVCBx3rMGy+/
3cNS/ralX/6boXnW6qPAI9uDrAyR9AClp+b1v7HPzA5OCbrYAS3+fOzRLN2vTb0z
QfTe4sAvaJUCQp+XG9Ig9+I3L1nJXqrMA/hxa/tPu8r1YUohjiVRlLknalSDnYPH
o5KvzjcUz/j0Y0+EHXtACiCaqJp2j3Xi1bDcPbFMn49/G0qIb7Q5TPow552aOr7A
H27jF8IoZ55EqBjHC8nRRc0AuadztEuduOvTzc6I4uDkLB1qWZ8bfN6gYtvPhiIy
uZe6xJOFJ7MdyGpqc3NmoWEpjy1gXqtUmYS6zXUW1Iv6weH4QMYDEZfFMpia+6ax
RK9oq+LngInI+KU9RLnKpwOVXyJWJVNNjOapZ4dY22B8fSx4SsI=
=4YLn
-----END PGP SIGNATURE-----

--kxiQ6lrF9coAupSL--
