Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D30BC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 13:52:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F22F3611EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 13:52:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbhKFNym (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 09:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbhKFNym (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 09:54:42 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E8FC061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 06:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jIdhr4tm1fX5CiHRy2c7jfbxX9IctPlcXEEyEkkon9c=; b=l8a7wnTOJqYy2yk4y/UKquOE9L
        2nBmmb9CV6IDNSXgUTYf3RCwTp2CwnLf86qbY4LV/lvwsC77FcZ1nihs1OsUClosUqOe8fZr9URpa
        y7b/nCBpoU4BcU3YLZFjuOXAlOBwZr6w8xRini87qNV5PLVLKmRyeoXVlP4YzSWIA1Tpc2+0/KxBz
        WwIV1v6XQE8WMPWdauC/gkfB0r3exvgWGDJUT7dU8nTkANDNYB8mHF2LaD14lRAWGtNGeBCSar/57
        ThkqUaAKN+77Oa+My6jTfF8Fp1zHZFBM5sHMEDy1Qv8OdeNCaC0gXqDCTUa3pV6GrBeLngCaxaLb/
        aw2W3iRg==;
Received: from ec2-18-200-185-153.eu-west-1.compute.amazonaws.com ([18.200.185.153] helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjM6x-004ieZ-89; Sat, 06 Nov 2021 13:51:59 +0000
Date:   Sat, 6 Nov 2021 13:51:54 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [ulogd2 PATCH 13/26] input: UNIXSOCK: stat socket-path first
 before creating the socket.
Message-ID: <YYaIemfQJokeB9r/@azazel.net>
References: <20211030164432.1140896-1-jeremy@azazel.net>
 <20211030164432.1140896-14-jeremy@azazel.net>
 <521n426p-7nn-655-nq5r-6364po1or38@vanv.qr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="XdTg12n6xRbuyoBP"
Content-Disposition: inline
In-Reply-To: <521n426p-7nn-655-nq5r-6364po1or38@vanv.qr>
X-SA-Exim-Connect-IP: 18.200.185.153
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--XdTg12n6xRbuyoBP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-10-30, at 19:33:13 +0200, Jan Engelhardt wrote:
> On Saturday 2021-10-30 18:44, Jeremy Sowden wrote:
> > If the path is already bound, we close the socket immediately.
> > diff --git a/input/packet/ulogd_inppkt_UNIXSOCK.c b/input/packet/ulogd_inppkt_UNIXSOCK.c
> > index f97c2e174b2d..d88609f203c4 100644
> > --- a/input/packet/ulogd_inppkt_UNIXSOCK.c
> > +++ b/input/packet/ulogd_inppkt_UNIXSOCK.c
> > @@ -479,10 +479,17 @@ static int _create_unix_socket(const char *unix_path)
> >  	int s;
> >  	struct stat st_dummy;
> >
> > +	if (stat(unix_path, &st_dummy) == 0 && st_dummy.st_size > 0) {
> > +		ulogd_log(ULOGD_ERROR,
> > +			  "ulogd2: unix socket '%s' already exists\n",
> > +			  unix_path);
> > +		return -1;
> > +	}
> > +
>
> That stat call should just be entirely deleted.
>
> I fully expect that Coverity's static analyzer (or something like it)
> is going to flag this piece of code as running afoul of TOCTOU.

Good point.  Will remove it instead.

J.

--XdTg12n6xRbuyoBP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmGGiHoACgkQKYasCr3x
BA2nnRAAoGrFuAjxz/qZZ2CaJQagbJbCxHZcc+UzD9g/9E/rr9AEgSp7cEuUj/DQ
4x+JqVrYpt0kALUBHh7/ksfgNAzKDb31EUa42LxS33JxZ+SDtuQW7H7xF9AC/T4F
5rmEL1FtM371TaxRjJ3ORSa0AA27+VO1Qcx9qQLyLLobQ+Qr4wg/fdA4taQIrSyG
M5MYSlnXFZLObTeP+vpG/Rr1P6+XJZqlbXKAY7xvT9I4V6dco4TZ/MpSgnSbc2xF
ywZg12qQumaWyAsio4Mc8+NUBL2mEfadI8LCtK3xiEZi6C5Uy3ehTvwvbOzEqG34
54FPmY1sIUZaLLzXPxVKIX8LTzzL6t7sJlzWgTwsW9+iGvo3kYMOEOO0fO0Dk8t1
voLxw+PYDJLljRtUej9cNjFjnN+CqsOg6mD3SzH/gUYifF9U/95ibygVZYoI/Vvd
l69ztuL8Ig8EogOOX2gsR3sFTpvH/sUaU4oNjRFJEIgRhiWixstf400PF6QK/gRg
SGRm/vq5sx3xApX0LhZatb2MUDAmsthhTo7PHUQvmwsaGBh/hlzXnc9+ZzqOg+jf
Hl5T9s09mYlYOoBSR/TOXqqsRk9Oq2lGkWsO/ArywU/+r1SiMsHvoZw/rkaiEibP
MDP5dmP6a0cn9aSRWhOfpKIy+2p+TmDc50NogKP67oIbIgheJ5o=
=IkeJ
-----END PGP SIGNATURE-----

--XdTg12n6xRbuyoBP--
