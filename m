Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB537C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Mar 2022 11:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240853AbiCPLtY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Mar 2022 07:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239920AbiCPLtX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Mar 2022 07:49:23 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6BDFD05
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Mar 2022 04:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rYkHlzxRIvJPb76rSwJidTsKG4XPeDO7bbMLIE+mGvI=; b=BZCpwVwtJX1aoGHyHZ4DRAi6UY
        4PmZ8TzeVuDPJPf3GDVaDfFLc+S981uLuBks6zcJDg73dRt7L81xO/KjTKLX6/7lNUG1zWXXTs1MN
        J3Tf0P1/3shdb6yNDfImg+sqdkZkJhPEZLhmJExwE6h/KnB2wEpa2qAFlbE/3MEKj+vt9VXb87quD
        tsaJ2ip8jifDNUMQY9bdHRrIb2MVjg5A9eDTrko8ayUzbCNwskKQCO19PJJkHnG5UWiZximtp3Q3b
        9JHXGDW64mZBgFMaIrWzpgHd2G+Echf15f8GYyIMGhiOmDC4yA4ZSxwEC7M/aLj0PU8vBphuDiXo1
        7AiQyepA==;
Received: from [2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nUS8L-0024KP-NM; Wed, 16 Mar 2022 11:48:05 +0000
Date:   Wed, 16 Mar 2022 11:48:04 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: Feature Request: nft: support non-immediate second operand
Message-ID: <YjHOdHNWINuMcQky@azazel.net>
References: <5893CB79-E204-42CA-98A1-7D3C2FCCE532@darbyshire-bryant.me.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="TRpYZIAKrcoZkkUQ"
Content-Disposition: inline
In-Reply-To: <5893CB79-E204-42CA-98A1-7D3C2FCCE532@darbyshire-bryant.me.uk>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--TRpYZIAKrcoZkkUQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2022-03-15, at 21:15:58 +0000, Kevin 'ldir' Darbyshire-Bryant wrote:
> I=E2=80=99m trying to migrate to using nftables and hitting some good thi=
ngs
> but also a bad thing.  I have a firewall that makes use of conntrack
> marks that get bit-wise manipulated by iptables.  I don=E2=80=99t appear =
to be
> able to get the same functionality in nftables.  eg:
>=20
> The following stores the DSCP into the conntrack mark and sets another
> bit as a flag.  Unfortunately it destroys any prior value stored in
> say the upper 16 bits.
>=20
> meta nfproto ipv4 ct mark set @nh,8,6 or 0x200 counter
>=20
> What I=E2=80=99d like to do instead is something more like:
>=20
> meta nfproto ipv4 ct mark set ct mark or @nh,8,6 ct mark set ct mark or 0=
x200 counter

Funnily enough, I picked the work I did on this two years ago recently.
I was going to post it again last month when I noticed there was a bug
in the ipv6 delinearization.  I'll see if I can fix it this week-end.
If not, I'll post the patches as an RFC to get some feedback at least.

J.

--TRpYZIAKrcoZkkUQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmIxzl4ACgkQKYasCr3x
BA2Tiw//TEeHQrPeHDof465UwC3KESBa3IJJuFjD2N5zbRWGbgFUQ20r+92AqWAW
7l6G1jRrLlDetv3a8JW7SSZZhGrlCA4CBZkkYsm3YB3rmtCxL8QbVaHugjftp16g
jwJphlp0incS2nVOa5j5J98KsB17no2NDOgJgpiNMZgVsEfdp4Jc0zFHD+uR5L9N
UX8GFL9brj7xtAPZgCBPfhRaobVzZ+MvYqSn9rYxLOJ6diKgIU0A1junt1KqGMZo
cO32p63w4A5M683AJ9c96z2jlYYQAShpY6tz+axTc7+8IvNiLuBm3feVvWwY0mRt
FnoB4xqgMcIY1rb/6ZUMDOsb4Wdx2u2De4f11aw9vhK35GZDNLp+76pyP0NMnfYB
58yklfVRGdkbkpD+ilzI56eSvr0K+C5greXUmBBqmAKLCKHymTPEPiqSO+l3dWIr
dP7B0ruQUv5aDGMLm5ddvb0z8OxR6H+X95pgJUb+m43Lsf6sF0r51npIZOYNYlW2
lsHtm3rCo9rormcMHB0lbPpdPz36RMXBBhNb8zrUsZR7c4DuwbrFBDmYv6nlbbOF
HjJ8O/CwGPYVasCXyFZufxP3QAFECvv+p6nvtcefQjUIIjn/nf12LZrPagF20jq1
yGlmsC959BEJI1y7mhCHJ1cd092csH6SWCmauqDiY9505GsZ3DI=
=mvQx
-----END PGP SIGNATURE-----

--TRpYZIAKrcoZkkUQ--
