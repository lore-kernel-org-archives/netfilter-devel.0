Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD19CC6FD1D
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Mar 2023 11:36:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbjCQLgG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Mar 2023 07:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjCQLgF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Mar 2023 07:36:05 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B813A6746
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2023 04:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Fh0UEC/r40PKR/akV2ylyHq599e3uMQ1DCkmYtUqA9c=; b=a8caMaJy+ZWMaEjphqv0MERna+
        Et53TDI5RKf9blVcwqzGGUZHjzr+P+twIdwQa7abtEC1zreLTxggnPJXpNCyxnTWtrGaUYNxoIZSz
        LCKhjD1MJaGdX9DoePOZZ1SlY5kEfbCeHCof2kztvmiL52zDhgvWlHHX8/mtHqt85z6OPdROOKgoT
        gO0zKkVin1tw16mJ93mnQfnimWsxz9cgkp/3Okb6jUzbae6yAuoYWoRF2/g8eyPGHwOaG1QDstspW
        d3TyY4GwMhqAYW6XfvBw1sjx5DlIueM1tdrEZ1jFTEmnNFhLk5UynDTI4TZfedLrl3UW6bgzn2BNc
        nmDP9PjA==;
Received: from [2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] (helo=celephais.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pd8MC-00CJdY-FT; Fri, 17 Mar 2023 11:34:48 +0000
Date:   Fri, 17 Mar 2023 11:34:47 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH ulogd2 v3 0/2] pcap: prevent crashes when output `FILE *`
 is null
Message-ID: <20230317113447.GD51110@celephais.dreamlands>
References: <20230316110754.260967-1-jeremy@azazel.net>
 <20230316233619.GA26650@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7auWc5uidSXjspos"
Content-Disposition: inline
In-Reply-To: <20230316233619.GA26650@breakpoint.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--7auWc5uidSXjspos
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-03-17, at 00:36:19 +0100, Florian Westphal wrote:
> Jeremy Sowden <jeremy@azazel.net> wrote:
> > If ulogd2 receives a signal it will attempt to re-open the pcap output
> > file.  If this fails (because the permissions or ownership have changed
> > for example), the FILE pointer will be null and when the next packet
> > comes in, the null pointer will be passed to fwrite and ulogd will
> > crash.
> >=20
> > The first patch simplifies the logic of the code that opens the output
> > file, and the second avoids closing the existing stream if `fopen`
> > fails.
> >=20
> > Link: https://bugs.launchpad.net/ubuntu/+source/ulogd2/+bug/1429778
> >=20
> > Change since v2
> >=20
> >  * The first patch is new.
> >  * In the second patch, just keep the old stream open, rather than
> >    disabling output and trying to reopen at intervals.
>=20
> Applied, please double-check the mangling done in patch #1 and send
> a followup fix if needed.

Thanks, Florian.  LGTM.

J.

--7auWc5uidSXjspos
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmQUUFcACgkQKYasCr3x
BA1ecBAAz+0WAU2IXRmJWC3AOcRlo2d8/O1KleisyYXbxDBqBDorDgjD8SGj2dmB
OpSmhq/7Oct5Ni4aLwQdXMNNPPgHfYaHS1E6Tws3vfeEO4yohUjlEy5yCvkFvgFQ
FzlCqJ/S7yrUJlme1/97ZR34ACTGL/3+Ba9krRV/AbBHGtX4NlK8nVH1bOnQ9xYT
jWbtWDnjUVkKghhhUTKl/8K3iau2vBzPo8td1kAjJ6PytZai98t1Bs85LwelaBrg
2mOpRtWMgnisXcNQiBcnBrbtZmDzLN3/UQCm/cqYitjvCaL+Tt1PvT4oG0m9w8tw
vRAnEsamer0Yvq3/hJSqByLO8czrPeWqkdxVJhoqL4Js9C57Njjew8TvUlle2BMN
3Fsa6mjje7v36jWWB6dSV05SjGW4m1ML4aIZDzT+Y706tOy9x0Up/mjcq+nJGNZQ
wNJbEo1/blWb4PVOZrD/YaE+/JV9fW2T4XiUJaMnUc1JYmZiCOf1RmtNIwlDt002
MYy1h+2XdBcoiwtLfS7SDqMNpwz8hdMHnrE0zwPtBrxoN5i2e6OS7LA5nsnwTzmz
cecN5PexpRk2a8QJw9Ofs6UhaPud/vyE3MecD8JZs05lVdWuGezOFBUHhr5UWGa5
uXUcAaplFiyrrJYq3DMGrx665fag5woDGN2YU8uCfXGy6jGxMTc=
=mazX
-----END PGP SIGNATURE-----

--7auWc5uidSXjspos--
