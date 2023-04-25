Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CAE9C77B61
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Apr 2023 19:51:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235087AbjDYTvx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Apr 2023 15:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234754AbjDYTvw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Apr 2023 15:51:52 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759D459E5
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2023 12:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9hxo1U9Wg7KcuXfGClxwKXxcuwE4yANjzOk9FDhTuLw=; b=foBI4iZAGbxZBy5iXQJdQOhKGw
        31yHJgh1j6/NzC2eiWLqRDSAVCOlrwwB2fqV4+3NXF8fyCSoPMWTqqq+wcK56AFinfF+sHlYktWd7
        CiJ1m9WWiUXpLZjbr9f+6n090pZH4D2rjF3qyMvMKjrPAE8tdN3hrWPjEgkA+p5d9uDc6/lgVObHG
        oQXp2ME9H7C7uUtSfqphl7wEoyIKr9VX2u4mVkpJ3+snZvKvFhUr5kgpiv04HEQttgddKbNeg4deb
        uh1W/Y0kVZl33kgJIWcq7MOaTDhjp4WXbN3XnqptNKfGrMa2jJHGKyuRpAd4qlphumaUm24LX1b8i
        E1DJVhtg==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1prOhV-009YNl-0H; Tue, 25 Apr 2023 20:51:45 +0100
Date:   Tue, 25 Apr 2023 20:51:43 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nftables 8/8] test: py: add tests for shifted nat
 port-ranges
Message-ID: <20230425195143.GC5944@celephais.dreamlands>
References: <20230305101418.2233910-1-jeremy@azazel.net>
 <20230305101418.2233910-9-jeremy@azazel.net>
 <20230324225904.GB17250@breakpoint.cc>
 <ZCCtjm1rgpa5Z+Sr@salvia>
 <20230411122140.GA1279805@celephais.dreamlands>
 <ZDaQmlLBAnopcqdO@calendula>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="+8kEGTQyjhCAqWiP"
Content-Disposition: inline
In-Reply-To: <ZDaQmlLBAnopcqdO@calendula>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--+8kEGTQyjhCAqWiP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-04-12, at 13:06:02 +0200, Pablo Neira Ayuso wrote:
> On Tue, Apr 11, 2023 at 01:21:40PM +0100, Jeremy Sowden wrote:
> > On 2023-03-26, at 22:39:42 +0200, Pablo Neira Ayuso wrote:
> > > Jeremy, may I suggest you pick up on the bitwise _SREG2 support?
> > > I will post a v4 with small updates for ("mark statement support
> > > for non-constant expression") tomorrow. Probably you don't need
> > > the new AND and OR operations for this? Only the a new _SREG2 to
> > > specify that input comes from non-constant?
> >=20
> > Just to clarify, do you want just the `_SREG2` infrastructure from
> > the last patch series but without the new bitwise ops?  That is to
> > say it would be possible to send two operands to the kernel in
> > registers, but no use would be made of it (yet).  Or are you
> > proposing to update the existing mask-and-xor ops to send right hand
> > operands via registers?
>=20
> I mean, would it be possible to add a NFT_BITWISE_BOOL variant that
> takes _SREG2 via select_ops?

In an earlier version, instead of adding new boolean ops, I added
support for passing the mask and xor arguments in registers:

  https://lore.kernel.org/netfilter-devel/20200224124931.512416-1-jeremy@az=
azel.net/

Doing the same thing with one extra register is straightforward for AND
and XOR:
       =20
  AND(x, y) =3D (x & y) ^ 0
  XOR(x, y) =3D (x & 1) ^ y

since we can pass y in _SREG2 and 0 in _XOR for AND, and 1 in _MASK and
y in _SREG2 for XOR.  For OR:

  OR(x, y) =3D (x & ~y) ^ y

it's a bit more complicated.  Instead of getting both the mask and xor
arguments from user space, we need to do something like passing y in
_SREG2 alone, and then constructing the bitwise negation in the kernel.

Obviously, this means that the kernel is no longer completely agnostic
about the sorts of mask-and-xor expressions user space may send.  Since
that is the case, we could go further and just perform the original ope-
rations.  Thus if we get an boolean op with an _SREG2 argument:

  * if there is an _XOR of 0, compute:

    _SREG & _SREG2

  * if there is a _MASK of 1, compute:

    _SREG ^ _SREG2

  * if there are no _MASK or _XOR arguments, compute:

    _SREG | _SREG2

J.

--+8kEGTQyjhCAqWiP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmRILz8ACgkQKYasCr3x
BA1xIw//c7gol/qA5mYq45U5CGs/FZZQ6L86P0azj9rUq4hLmhcY2k01eq4v6cXR
vpjgzvsNzs7+kfNXBsJKo5iZsjQl4F5hBoodxC9SRVupWGu+lI2w3GOR3Jbxwe2d
AYWm4z8padn7hhSoeDg0d7cbdpDnugrt9hT5a/BqjUqLjsXQcPHJnXWdc+Sfn5NX
CaIHeAQk6IzCNExMqfVgzaKiLc8fZSUOrUUcEi7rYiAndW8BpJe/PIHmqumFEaEU
am07NqIEd00Iy6UgD7iR/GG1bZ+kWYXOiW+rT57D/t8i/eo5yRDEHuLiLpHYvh99
bq+k02UiKEQOR5Y0vnC8n8jtn7mTFblHGDBREVgSTaUBwTgqrTnxMgQjMUX258H/
30B+M1vhohOjEbedVTrswxSbuo4pOyFKX63ifIn6V09AbNjYQDMmyOyq0AJLNLjy
I889LlUJ6DAUg9ih1Ao0RhRSEigDSU2SLMquEC+YOlgXlQVJgSpwUb1GKZ9iZKzH
c3TVcU6vkBvca5EzSVJZaR3KWG16bn+lfhFKw664aOFBbbMK5MHBQcJNJEmUNf5S
wPympebGyZFCbjUu7v4UYWDB9OBoXW3FSen5eCRyX/DIQuLa+dP4o8FIH6CXSDTR
wD28M5PbLG8icBH/3Q/nZMgL68XEsdDYQHVMPUGBgb1NoPlaPZo=
=FWBN
-----END PGP SIGNATURE-----

--+8kEGTQyjhCAqWiP--
