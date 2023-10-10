Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34D0DCD8CB8
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Oct 2023 20:09:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343764AbjJJUJT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Oct 2023 16:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344216AbjJJUJH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Oct 2023 16:09:07 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E35D40
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Oct 2023 13:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tIv8LN6zuIRnuHQiOe1eyot3EDdR5qZ8EczA5YWVM3s=; b=P0Cn0ByMW/7LrruYf7kHMvV4fi
        cp6eWOSs2Z5Sc8GAKXayNJAW+Tb5w9HOVlnsDUNJ0VRApDGWqZ1p0ymO+j5KYzcc1kG82lisuVV6A
        O6VDZGhtYFskwAgqnwyazauvG5oqJGJiwfDwK0yilP9a6tHAAZZIzVfkGIKJN0yv/LQ1lPyBeld/r
        SYGzbV14w5e7VhkQKvad/jXgV/Iy2D7UeXfiDC2jVGFrcHl5aCn4H5ccrXK5Qh3eKTqPE2/TgQDtj
        cBkrHq532sz7vb4IoJo5JrOyUsLsHVko1sYAqPBbm8iPpRhs+xviZd48xAbqeY3onSqXwheBD0Psm
        AQy8wFBA==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
        by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qqJ1z-0027oa-23;
        Tue, 10 Oct 2023 21:08:39 +0100
Date:   Tue, 10 Oct 2023 21:08:38 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Arturo Borrero Gonzalez <arturo@debian.org>,
        netfilter-devel@vger.kernel.org, fw@strlen.de, phil@nwl.cc
Subject: Re: [RFC] nftables 0.9.8 -stable backports
Message-ID: <20231010200838.GA1438255@celephais.dreamlands>
References: <ZSPZiekbEmjDfIF2@calendula>
 <ZSPltyxV10hYvsr+@calendula>
 <ZSUPsdpvPNDOl8TY@calendula>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="1w629qLQL5IJRtxS"
Content-Disposition: inline
In-Reply-To: <ZSUPsdpvPNDOl8TY@calendula>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--1w629qLQL5IJRtxS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-10-10, at 10:54:51 +0200, Pablo Neira Ayuso wrote:
> On Mon, Oct 09, 2023 at 01:36:29PM +0200, Pablo Neira Ayuso wrote:
> > This is a small batch offering fixes for nftables 0.9.8. It only
> > includes the fixes for the implicit chain regression in recent
> > kernels.
> >=20
> > This is a few dependency patches that are missing in 0.9.8 are
> > required:
> >=20
> >         3542e49cf539 ("evaluate: init cmd pointer for new on-stack cont=
ext")
> >         a3ac2527724d ("src: split chain list in table")
> >         4e718641397c ("cache: rename chain_htable to cache_chain_ht")
> >=20
> > a3ac2527724d is fixing an issue with the cache that is required by the
> > fixes. Then, the backport fixes for the implicit chain regression with
> > Linux -stable:
> >=20
> >         3975430b12d9 ("src: expand table command before evaluation")
> >         27c753e4a8d4 ("rule: expand standalone chain that contains rule=
s")
> >         784597a4ed63 ("rule: add helper function to expand chain rules =
into commands")
> >=20
> > I tested with tests/shell at the time of the nftables 0.9.8 release
> > (*I did not use git HEAD tests/shell as I did for 1.0.6*).
> >=20
> > I have kept back the backport of this patch intentionally:
> >=20
> >         56c90a2dd2eb ("evaluate: expand sets and maps before evaluation=
")
> >=20
> > this depends on the new src/interval.c code, in 0.9.8 overlap and
> > automerge come a later stage and cache is not updated incrementally,
> > I tried the tests coming in this patch and it works fine.
> >=20
> > I did run a few more tests with rulesets that I have been collecting
> > from people that occasionally send them to me for my personal ruleset
> > repo.
> >=20
> > I: results: [OK] 266 [FAILED] 0 [TOTAL] 266
> >=20
> > This has been tested with latest Linux kernel 5.10 -stable.
>=20
> Amendment:
>=20
> I: results: [OK] 264 [FAILED] 2 [TOTAL] 266
>=20
> But this is because stateful expression in sets are not available in 5.10.
>=20
> W: [FAILED]     ././testcases/sets/0059set_update_multistmt_0
> W: [FAILED]     ././testcases/sets/0060set_multistmt_0
>
> and tests/shell in 0.9.8 has not feature detection support.

This is very helpful.  Thanks.

My immediate interest is getting the implicit chain regression fixes
into Debian 11, so for that I'm going to cherry-pick:

  4e718641397c ("cache: rename chain_htable to cache_chain_ht")
  a3ac2527724d ("src: split chain list in table")
  784597a4ed63 ("rule: add helper function to expand chain rules into comma=
nds")
  27c753e4a8d4 ("rule: expand standalone chain that contains rules")
  3975430b12d9 ("src: expand table command before evaluation")

J.

--1w629qLQL5IJRtxS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmUlrz8ACgkQKYasCr3x
BA3+Zg//cGgV44KKp3UsR7N++hqGWG1yIrVYu3Bxee3z9PlAprJEimZvOYhWE0vf
j3lOcH7vm86z9laKjGMJJjwprErhGz70GFZZcG12XFjbrrQ1skYJRiGN76I5bNkN
HDHhP/kcJA/YTBWZBUpkkF0xifkVzOPix0gkGv8Gwk4e+f6sD+sfhZpXDih393KQ
4PANlHmxB4UeGxek5mZ8UKXwbG/3qKW5l+OHXgUxVXgCOsMbPJKjP399Viw22/4V
NSt++yCtUGsoZZzHGJvhlrjQdR9EfjaKb3es45FEi6kCETp/CGjiu2li7yiAEXDt
BCcICLua6SPQrMXDqOkQ3OwOa5TXZPafHZskvRIgXz00MDjpFlgHb+Uo5GPUBEU+
zKbYY2m/8PL2Liw9v4nxmxxEEr/xhFckASMmB7MUFrXrZYs7lzBG41B+EMQyRHzi
FGD3PvrJua2YrMJ305Y3oIIqF2HpP5pXGOeikT/nYFbn3916zzTOBaVHKEM42osr
KniQKi9b7xI1XceVF0BHKks+NRODTRxUA7N57ON8FDFh+BQZZYPY1f+YG4SjtMjR
/4zzmHde4oc5Alt0YITGieezzUr4TFLmn5S+chKVHSeBB9Uv0CNoxcxDqr3fxNXJ
v7/WLIeTCvKIPoxkpAjCoQGOE2rGc/HViswr8Q+yF1OF6BtsuI0=
=tZtG
-----END PGP SIGNATURE-----

--1w629qLQL5IJRtxS--
