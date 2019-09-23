Return-Path: <SRS0=FqmY=XS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71149C4CED0
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Sep 2019 18:15:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49E7D20856
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Sep 2019 18:15:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="T7LecIMS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440368AbfIWSPQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Sep 2019 14:15:16 -0400
Received: from kadath.azazel.net ([81.187.231.250]:44534 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394280AbfIWSPQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Sep 2019 14:15:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qaE3AancGsXcD24abjS9u02RSPw6Io0g/1z1IzBReZo=; b=T7LecIMS7O5H0U4RsTXAmR9Q2R
        +DvbaJIuy8ebSukng3v4b3yAuJzYt6lj8cVfn3jnPoT8DM+2cOYmYvrBCUXcaZvJs/MX7BRcHVbkJ
        oW8W+awXT7PXGKXvdYKMcWOmGHTe25X2zGwbiw4iQoKQZZVhmKfDNfXAXPm8wG48D1WxS2Y/7df8Z
        +0vRz0UEyyBOH8+z7wkFRLCpqjx4vsVPL3c33fPAKJjmXY+zQbYmPtwD6O+0oGcGfcVTVbTkiO8H+
        +udjE6dMxG1dS7YQYdRMtbUXaioNaYnDhfDAr/6gNfW+BrRw29csJhFx7bCqPcuPdeF6IaQr4uG09
        Zww0ub/A==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iCSrg-0002UY-EK; Mon, 23 Sep 2019 19:15:12 +0100
Date:   Mon, 23 Sep 2019 19:15:11 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Sebastian Priebe <sebastian.priebe@de.sii.group>
Subject: Re: [PATCH nftables 1/3] src, include: add upstream linenoise source.
Message-ID: <20190923181511.GE28617@azazel.net>
References: <20190921122100.3740-1-jeremy@azazel.net>
 <20190921122100.3740-2-jeremy@azazel.net>
 <nycvar.YFH.7.76.1909212114010.6443@n3.vanv.qr>
 <20190922070924.uzfjofvga3nufulb@salvia>
 <nycvar.YFH.7.76.1909231041310.14433@n3.vanv.qr>
 <20190923092756.p5563jdmp2wljnex@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zjcmjzIkjQU2rmur"
Content-Disposition: inline
In-Reply-To: <20190923092756.p5563jdmp2wljnex@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--zjcmjzIkjQU2rmur
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-09-23, at 11:27:56 +0200, Pablo Neira Ayuso wrote:
> On Mon, Sep 23, 2019 at 10:47:40AM +0200, Jan Engelhardt wrote:
> > On Sunday 2019-09-22 09:09, Pablo Neira Ayuso wrote:
> > >> > src/linenoise.c     | 1201 +++++++++++++++++++++++++++++++++++++++++++
> > >>
> > >> That seems like a recipe to end up with stale code. For a
> > >> distribution, it's static linking worsened by another degree.
> > >>
> > >> (https://fedoraproject.org/wiki/Bundled_Libraries?rd=Packaging:Bundled_Libraries)
> > >
> > >I thought this is like mini-gmp.c? Are distributors packaging this
> > >as a library?
> >
> > Yes; No.
> >
> > After an update to a static library, a distro would have to rebuild
> > dependent packages and then distribute that. Doable, but cumbersome.
> >
> > But bundled code evades even that. If there is a problem, all
> > instances of the "static library" would need updating. Doable, but
> > even more cumbersome.
> >
> > Basically the question is: how is NF going to guarantee that
> > linenoise (or mini-gmp for that matter) are always up to date?
>
> It seems to me that mini-gmp.c was designed to be used like we do.
>
> For the linenoise case, given that there's already a package in
> Fedora, I'm fine to go for AC_CHECK_LIB([linenoise], ...) and _not_
> including the copy in our tree.

Righto.  Will send out v2 in a bit.

> Probably other distributions might provide a package soon for this
> library.

I've nearly finished a package for Debian.  Will see if anyone fancies
sponsoring it.

J.

--zjcmjzIkjQU2rmur
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl2JC6cACgkQ0Z7UzfnX
9sNo2Q/+LpuvTUKTWqH4vy0zNt4zTSA/ti+zVyglBRWDMnm/yuC7ts8W8TVdN3qY
Rp7+6tWLnBi8TSxXJ8EjVg3/+KGfUdHZGdmMDfVuRyV02VHWu7WB56oW8vcb1gv9
Mc9nMtYKAq5xW7rxvS+zRIa0a/PkFjWSC0W7l6jXE9vquxv9QtZRIGW8OWeskEbC
297POy9FrUlKz3adHtL65jmEYjsZUWhBNKLA3STR3WNvPzCILQRjihHdl3rKHYxm
jxUmr0M86twzddxoYQT/vd56X7RpwZttXSivto/bu4uSM6Tkrh+zOpGYrJ0HMyUp
ljgJ5qodn2y/EzWsgqeJbNFgABqP+DZlEgqQ4MvaN2Q6nRevuGHeLuSqk84z315v
sWC87vH3/v1jfZdlUEOqOQqrjDg23uPVShXZMLDsicjfj2Ex/HQ8J5AL460tDHxz
dhz084D0GH/RdUlIOEoZoXvhQfm77Jw7lkvU8+EUZgJ+ENpqeMSoy6RVVwuFK9+Z
6DNvGNtT2cAshLgV5xtmpOLn0XO7dzLol00FOI2bx4Wr8SuhtZvAxlgo2UkdYc3+
/WE/9xvbnrDfUib943/uydeATqAxoPeuaTTbP7UgFR/alte2ryk48yBH7Jll8Tnz
WODrGll979qR7hOHFV0wsusTgdBakE+0BZ6nP7pzwyNcOtn2tzs=
=HPyo
-----END PGP SIGNATURE-----

--zjcmjzIkjQU2rmur--
