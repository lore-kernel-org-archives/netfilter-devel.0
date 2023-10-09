Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23001E95A91
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Oct 2023 11:44:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346266AbjJILoz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Oct 2023 07:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346222AbjJILoz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Oct 2023 07:44:55 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57DDB94
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Oct 2023 04:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nbgcCYnG35mBuj2dm0MFKg7Nw2HWQFaKj1a0/pztP5s=; b=o/p+3ikuiZvbUamVjp1fM43iqe
        OUbD4Dzv4h5VSD7yN7nc/pGwzgoJhiRqxX8VYhPuj34gaIU0x8F45HU441YoWEUMNwP9CaVp/SKYL
        zsYxvQw2l0Dgim4wvla5WPI2nKDkUONJ4gzUJ0kG5Y2St8rQuSwiOFycHVJkctj3q5QWb6He3zP4W
        +KNWzj5OXkyGnVugLoAOX+t7Q/JgJ1yYAF2VEwp17NPXayZ7sbIbyYoRc90SGbCjBXOkHgV2S8XJB
        EjUDxuKrYq0p3nTCcowJNfg2PrTB3XMLZ+0xkQEcZ2lSI5nUgHQsFop2E4rWsIRJ6CTzPeOHPV6Yb
        Md2qUTCg==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
        by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qpogs-000z3X-1t;
        Mon, 09 Oct 2023 12:44:50 +0100
Date:   Mon, 9 Oct 2023 12:44:49 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Arturo Borrero Gonzalez <arturo@debian.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, fw@strlen.de, phil@nwl.cc
Subject: Re: [RFC] nftables 1.0.6 -stable backports
Message-ID: <20231009114449.GA1135389@celephais.dreamlands>
References: <ZSPZiekbEmjDfIF2@calendula>
 <e11f0179-6738-4b6f-8238-585fffad9a57@debian.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2q/o8gXo96XI0xST"
Content-Disposition: inline
In-Reply-To: <e11f0179-6738-4b6f-8238-585fffad9a57@debian.org>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--2q/o8gXo96XI0xST
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-10-09, at 13:05:32 +0200, Arturo Borrero Gonzalez wrote:
> On 10/9/23 12:44, Pablo Neira Ayuso wrote:
> > - Another possibility is to make a nftables 1.0.6.1 or 1.0.6a -stable
> > release from netfilter.org. netfilter.org did not follow this procedure
> > very often (a few cases in the past in iptables IIRC).
>=20
> Given the amount of patches, this would be the preferred method from the
> Debian point of view.

Agreed.

J.

> 1.0.6.1 as version should be fine.
>=20
> Please note the Debian Stable (1.0.6) package already includes some patch=
es
> [0], so I strongly suggest this new 1.0.6.1 contains them as well.
>=20
> regards.
>=20
> [0] https://salsa.debian.org/pkg-netfilter-team/pkg-nftables/-/tree/debia=
n/bookworm/debian/patches

--2q/o8gXo96XI0xST
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmUj56sACgkQKYasCr3x
BA3eBg/9FmPz6THWkphfnOFL7SZM3SmWhjd5gT39DHahx/vhXnoZd6+oyRQHLlTX
LPHyACPHB6QdvzHJLYH3OkKHlBkMIRJejnIBJSxMlIG/AQCWgDHCkXCuqGpr5Z1q
lTh47AHofwuJWBa7ZW9cTQp33qgLfxaqQTuKa2HcEtZ390bARZq/Y9FHfM1Oj0/O
dHgKCMF0pucy/WFKtz5KsMAVKRVkoMDDwCFsIJQxdejHKbBD9chcy0z2Jq6y3bat
qjhdzGY6hil4e+HTlsU69Jf0/SUxLG+3WgStDgORdYSkxU6H3NDgIRW2o1NmHGR2
iJmSkTiADFkjMQ1TV7x4v0eqSAaUq+04y+0ay1udZEWt7i+8IdcGF/bHRTRVGF/s
CiFJfi3CcmuH6CrrPpnwqf2Bhbzi2vy86ZwTdgd7IowpfXB8fBVS3k00CgnX5XaB
gR/8TWbK8fGlEQhmQz+1j+Sg4qHCuhnjzakyHofThTVD7m3B9/++P+E2NepDIkX7
0dVuIov1n6OMd5044vr7TMHBxpjpqeMXZvW+xyNahNSLVr0sb2qVLTyqxLLu0AyT
4849dgqcOdrdq9xOcDAv7+PydHdu7sl/8Tj7T6Wymu6zEYnSz3VHPQPxV//lLrY2
ppPkf6DHpkxNarGrXulWGA6hUQSF6UQ4cq1CWP5k4UmqS4Tgz0Y=
=o26D
-----END PGP SIGNATURE-----

--2q/o8gXo96XI0xST--
