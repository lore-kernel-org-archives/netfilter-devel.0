Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34C35C74A44
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Mar 2023 19:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbjCGTp4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Mar 2023 14:45:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234513AbjCGTpf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2023 14:45:35 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE77A7A9D
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2023 11:35:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=C8Vo+c7CgFaaxO5dCkubVlGY4x0xb+St6YAwmv8yGso=; b=SATy7NXmwmOjILhAwq3FjhB92M
        Va1N7o3FuVgnaIFAIGjdoEzvBPHIdmkoIAvu4hO3tnut5dQ/6UN/r/ykAm+fvQqc7ez6rAk3HuNxy
        N+azAHxgRwHgCJU1bNz4I0V3ywTkxL8W4ga98oEDqpZOJrKoHS/TJv3/T6v7bcl7VUIkJ2tVm/XUB
        H7Zp2cYlfukI/4cEQqyPmpwEUouQLYpqWp1mmARJbtJXx1Mg1ZPuXi7ZkAFoD0caSRgwCM+OyZJkZ
        ut4zTfpEbDmok4oATIT+1ZYrI2nRQyab9uHegcG/ACDKkNpi48rRMKePr/xwh4A+lsxyEaB+g7ePL
        aWLT5cZg==;
Received: from [2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] (helo=celephais.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pZd6E-00Gspp-Kc; Tue, 07 Mar 2023 19:35:50 +0000
Date:   Tue, 7 Mar 2023 19:35:49 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next 00/13] Support for shifted port-ranges in NAT
Message-ID: <20230307193549.GF226246@celephais.dreamlands>
References: <20230305121817.2234734-1-jeremy@azazel.net>
 <20230307124638.GE13059@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rfcujpT83gJ/h3do"
Content-Disposition: inline
In-Reply-To: <20230307124638.GE13059@breakpoint.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--rfcujpT83gJ/h3do
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-03-07, at 13:46:38 +0100, Florian Westphal wrote:
> Jeremy Sowden wrote:
> > Jeremy Sowden (13):
> >   netfilter: nft_nat: correct length for loading protocol registers
> >   netfilter: nft_masq: correct length for loading protocol registers
> >   netfilter: nft_redir: correct value of inet type `.maxattrs`
> >   netfilter: nft_redir: correct length for loading protocol
> >   registers
>=20
> I think the fixess above should be routed through the 'nf' tree, I
> don't see why we need to hold them in -next trees for another 3
> months.

When I send v2, I'll separate these out.

J.

--rfcujpT83gJ/h3do
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmQHkhUACgkQKYasCr3x
BA2W5hAAktjtn56qon5dKKvsJO9qfZnjm0XecXlCkWNrY/j8uu3BKfRy/x29sPVf
eFzhNBWJVMcPr6G8t4C3wWJFtbM9t7tfVOT+sae/3uOEjEnXqT6iKBV4qlz1RTTT
kZTgIxWzps8PCmRg0p4quDln1FKW/L8TAaIB2/+o3pN5vF1ndnC4qnyj5bMnOGjf
Ta4Kqj+uphEhL3oCcvb3yaSGggfzzWI5InXZMZ2FGsdIKnFojoysc5RgvuCH1GaG
yCsckw642LManSE7Pvxyaj7L7WYcSdaxGUi9I1ilcrgV07OVKEWODybQqgcZ6kEX
40VOtop5l0AeqT07jNYJjePEhzbSFnEyizA8Tkf7PSUCMhPuvEeNdyE1Sc92pg3h
TSlYedryc+9Kc97Um6Oa8H7dK4PnDoPhyaWRLHXtvwhawOYhYc/V34OOagzj5p3R
6yXI6KS/Nq/QPFwxz2J+nu5DwtBCZqsSTc7iADKUIoC4xoHI4qZ8wIaqDEJ+ZPXw
9XgmQzOstuOwmfcOU7uIm4hIaWN7sFMAvw9j1r9cA6yAgnov6213IKl+0Clqtc3q
W8gOXtiQqXOhG1hRiJpfa7njd/MZ/uwrO1j/k+8AFscAEFPKnQtN0j/CD7jxDJNI
T6Wu059DqQH2jD+HuZxKJUSrIQVAlcY97z3CjR/kpy4WfAY7/gI=
=Gc3i
-----END PGP SIGNATURE-----

--rfcujpT83gJ/h3do--
