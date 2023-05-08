Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EEA3C77B75
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 May 2023 18:29:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjEHS3s (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 May 2023 14:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjEHS3q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 May 2023 14:29:46 -0400
X-Greylist: delayed 1874 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 08 May 2023 11:29:44 PDT
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2021759F3
        for <netfilter-devel@vger.kernel.org>; Mon,  8 May 2023 11:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=I3ShQzV9cWE2hJIns/SAA72mtvqFh+tSgRtLwbUD9CE=; b=Zc3CcxBtCqwx5hPHh/lA/Ynavf
        j0BcFnWhMEb6V16EQ3wo7jafu3v4BnykGOShwSKBW2ktauHHFQQb9pT5vUmsijnUGfZLBnNPHg5/i
        npz6bDqrCN38WlqtM147nZcj3CMFnONeKb/6hgvt7DLCuMknFxfwxHAj7c/sq5tJtvagFjvS9tWHH
        EYENy/K/CAMeNRbOIvt6p2bTrvqtSeh3MUCrN5Icp/Lftzga4CDBA26sVsHZFM2JFjvjWYwsEakvt
        ZaxZtpXQb9uAynGcxvvgq2ffCJePlkAWS0+iS5MYJ/6RwPljDAHjn4dqxJ+mZ+ErJENvBfounggW1
        Nxko7qhw==;
Received: from dreamlands.azazel.net ([81.187.231.252] helo=celephais.dreamlands)
        by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1pw57z-0063aq-38;
        Mon, 08 May 2023 18:58:28 +0100
Date:   Mon, 8 May 2023 18:58:23 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nftables 8/8] test: py: add tests for shifted nat
 port-ranges
Message-ID: <20230508175823.GA979099@celephais.dreamlands>
References: <20230305101418.2233910-1-jeremy@azazel.net>
 <20230305101418.2233910-9-jeremy@azazel.net>
 <20230324225904.GB17250@breakpoint.cc>
 <ZCCtjm1rgpa5Z+Sr@salvia>
 <20230411122140.GA1279805@celephais.dreamlands>
 <ZDaQmlLBAnopcqdO@calendula>
 <20230425195143.GC5944@celephais.dreamlands>
 <ZFLJ886DVa1d53kc@calendula>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cju7F/A77M210AJN"
Content-Disposition: inline
In-Reply-To: <ZFLJ886DVa1d53kc@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--cju7F/A77M210AJN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-05-03, at 22:54:11 +0200, Pablo Neira Ayuso wrote:
> On Tue, Apr 25, 2023 at 08:51:43PM +0100, Jeremy Sowden wrote:
> > On 2023-04-12, at 13:06:02 +0200, Pablo Neira Ayuso wrote:
> > > I mean, would it be possible to add a NFT_BITWISE_BOOL variant that
> > > takes _SREG2 via select_ops?
> >=20
> > In an earlier version, instead of adding new boolean ops, I added
> > support for passing the mask and xor arguments in registers:
> >=20
> >   https://lore.kernel.org/netfilter-devel/20200224124931.512416-1-jerem=
y@azazel.net/
> >=20
> > Doing the same thing with one extra register is straightforward for AND
> > and XOR:
> >=20
> >   AND(x, y) =3D (x & y) ^ 0
> >   XOR(x, y) =3D (x & 1) ^ y
> >=20
> > since we can pass y in _SREG2 and 0 in _XOR for AND, and 1 in _MASK and
> > y in _SREG2 for XOR.  For OR:
> >=20
> >   OR(x, y) =3D (x & ~y) ^ y
> >=20
> > it's a bit more complicated.  Instead of getting both the mask and xor
> > arguments from user space, we need to do something like passing y in
> > _SREG2 alone, and then constructing the bitwise negation in the kernel.
> >
> > Obviously, this means that the kernel is no longer completely agnostic
> > about the sorts of mask-and-xor expressions user space may send.
> >
> > Since that is the case, we could go further and just perform the
> > original ope- rations.  Thus if we get an boolean op with an _SREG2
> > argument:
> >=20
> >   * if there is an _XOR of 0, compute:
> >=20
> >     _SREG & _SREG2
> >=20
> >   * if there is a _MASK of 1, compute:
> >=20
> >     _SREG ^ _SREG2
> >=20
> >   * if there are no _MASK or _XOR arguments, compute:
> >=20
> >     _SREG | _SREG2
>=20
> OK, if my understanding is correct, these are the two options:
>=20
> 1) Infer from arguments the type of operation.
> 2) Have explicit NFT_BITWISE_{AND,OR,XOR} operations.
>=20
> If so, I think it is better to stick to your original patch, where
> explicit bitwise operations NFT_BITWISE_{_AND,_OR,_XOR} are added
> (which is what you proposed last time IIRC).
>=20
> Thanks for explaining.

No problem.  I'll get rebasing.

J.

--cju7F/A77M210AJN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmRZODcACgkQKYasCr3x
BA3x0A//bTdevaS3/G8LrLeqZKj1Fz+cb9vyaX5ClGfUwxRVrcKjP5VcsM5gaTvM
pxYqRkwrNCLHB5xkR9kEuU+XXSzMw529e9deLGsvFkRBVQ8pXyKnjd7kpQSrMLoc
8UDa7fOa72fy9T4E+d8/bAMnFMjnYLl5tRaOAl07YSjTIkN5e+VgyfcmrIKHm7Pd
fb3rM25DX1vv+RZeX2e6Sups/uS2qBkruMarfWb5PbYX6oQfajQmnFeodBEgqNVN
JXUgQe2Y1ERNopEsWv62rlxrLY8ixaluXcZAxJ99cNEM98GrIR+lpyOXXhuYnRFU
CbeTiaDs7fs5kxQHeOovrgQ71sLxJJZTKoDTxLKUIlC2OVopagy0PxrZ9CBcQpWa
hqNeIPzEU90XvQ/hDdHGfL/LNQ27Q5EK6cnlirpJv18lSFG4a1e2FRKhoIaTBqCV
SLRM6IRZ+ZH+2OIfLCdTrBVFd6BwjcsEPUPUILdax3LU9Ytlehtz6l2BhqW8o0b4
ygNvJa0KcEPXf1T9S/+YApYaV/3MZVlul64zXtONswLIRVOE6B9r5Pzw5wHwrE15
HoDQEqgNyGpL+cWBTfJ4IaSTv/r+4X9yiz2NV2OAFXRGm1RWhT0HOTCVK1RHHYog
ji51G8mvqUebx5Ea8PHJObGU74Tew2NnSxfcHXRtH2nLfYSXraw=
=IwU1
-----END PGP SIGNATURE-----

--cju7F/A77M210AJN--
