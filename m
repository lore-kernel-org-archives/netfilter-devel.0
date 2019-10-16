Return-Path: <SRS0=cZSN=YJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03468FA372A
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Oct 2019 13:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC30A2168B
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Oct 2019 13:34:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="HoMRjxqn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405464AbfJPNeh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Oct 2019 09:34:37 -0400
Received: from kadath.azazel.net ([81.187.231.250]:33718 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729612AbfJPNeh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Oct 2019 09:34:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=F8gVZ7zXFRQSOUmIyUtupdtMu7+/WmsJYlxyDn/3kp8=; b=HoMRjxqnUlDLAfM7EjQL+9dFrO
        KzkNrSjo99Ar8GK/jWR6L34WLfna4TAGtiAl9Bt7WjPCW4fZEaX0UZYnmtA4wqkjcTfm+ScdqXGoM
        qmaSbGofvQoudBnWOX/mAMaOAZcjHN6k7sl96tjyZ5ZYDZUhWj99dqGmVAabBM/2VD4MzLNiH/kpU
        oZyfyIvDFTXLdQecoX6TXGv1iDHSq/HY+I0UFG5LUKTVDu5riVdyvHvgj6URZTgjPq52fjWlo84Pg
        tUyh88Jn0VdAmLfceVvhwzFejp1sNJhdSnxOlkwg5B7EHU6p9DVS83IWC+5EqJTy+fFTPQARX35Va
        YbEmwl8w==;
Received: from pnakotus.dreamlands ([192.168.96.5] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iKjRk-00065E-0r; Wed, 16 Oct 2019 14:34:36 +0100
Date:   Wed, 16 Oct 2019 14:34:36 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Sebastian Priebe <sebastian.priebe@de.sii.group>
Subject: Re: [PATCH nftables v2 1/2] cli: add linenoise CLI implementation.
Message-ID: <20191016133435.GB5825@azazel.net>
References: <20190924074055.4146-1-jeremy@azazel.net>
 <20190924074055.4146-2-jeremy@azazel.net>
 <20191015083252.rm22hgssh4inezq4@salvia>
 <20191016105501.GA5825@azazel.net>
 <20191016121930.ufjztmd7ep4kyq4r@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="i0/AhcQY5QxfSsSZ"
Content-Disposition: inline
In-Reply-To: <20191016121930.ufjztmd7ep4kyq4r@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 192.168.96.5
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-10-16, at 14:19:30 +0200, Pablo Neira Ayuso wrote:
> On Wed, Oct 16, 2019 at 11:55:02AM +0100, Jeremy Sowden wrote:
> > On 2019-10-15, at 10:32:52 +0200, Pablo Neira Ayuso wrote:
> > > On Tue, Sep 24, 2019 at 08:40:54AM +0100, Jeremy Sowden wrote:
> > > > By default, continue to use libreadline, but if
> > > > `--with-cli=linenoise` is passed to configure, build the
> > > > linenoise implementation instead.
> > >
> > > Applied, thanks Jeremy.
> >
> > Thanks, Pablo.  Don't know whether you change your mind about it,
> > but there was a second patch with changes to `nft -v` that you
> > suggested:
> >
> >   https://lore.kernel.org/netfilter-devel/20190924074055.4146-3-jeremy@azazel.net/
> >
> > Need to find something else to do now. :) Will go and have a poke
> > about in Bugzilla.
>
> This might be useful:
>
> https://bugzilla.netfilter.org/show_bug.cgi?id=1374

Cheers.  I'll pick that up.

J.

--i0/AhcQY5QxfSsSZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl2nHGcACgkQ0Z7UzfnX
9sN2rhAAlqOaUS/CYej0kcoOCTNe1YalB5jX29iEC2y6+yetXfhapZYqxcWs4YP2
f19mzD6xe9xY36YcrbdUs6/osMOK8AD3lECwki8cW1/tzUQk2uAuG/aMRz+VMAI8
jftcuKeXVja3nam4M4hkQtH+DbNbKelaGfmv6j+jE6yIHHaLJmZQn+0KzX1A+gRh
QR3tCXTLoSN+S2DofErnSuJIpjwi8mt1jzzS5Vc1jBFgANk9Du2+VrJOn7zeMaNg
+6T4UzL0bboTsejwKzwnmWNCY4f8NSMMTTsTa2JfR/y735/36s2VK/ec0mHgZJ+c
Qnpb3CvW507gI2Qq8xZ/kWscraTeYjOycJMJAk2mtbUJV2d8F9UdEJf3iXIFYcGD
JBLSK7Kc4IOgmbISBF6FaZ9f9Ij3zL6giGwVhBaP/TN8ttWY4u1GmTyyY4xYe10+
4NQ36yHnXBD1YppK+l88iGx+Q+eVZHr+A1NCT07nnnMsZcUph0r3xjV0jSpbgxas
7pOziFDDsnKF6Rdc5JYZPC3Elw6FiGMwQCHEXW7YofF8Xz5idrdXM6DT2f0dzwVK
N4Byg8ppD3f08/SMKadH7cwQSJWCETADf/FSpzUN1kOv4StSaMVZ40vpN64QXroi
Y4EnDQKJVgCYOictiiIq93JqELEH9PtfqFjl36PfPxwsRc2bKPc=
=eJOp
-----END PGP SIGNATURE-----

--i0/AhcQY5QxfSsSZ--
