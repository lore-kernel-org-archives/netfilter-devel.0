Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E861BC7619A
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Mar 2023 11:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbjC0LI7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Mar 2023 07:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbjC0LIs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Mar 2023 07:08:48 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42DA5B9B
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Mar 2023 04:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YLl7zX8+KHrVTLvdYKP3aU71p0Z69iY+mlcPKEfYqHk=; b=c5dOjGzaXo8ugSDrsTSPvl20Az
        Nb64LGQIXKgaimZO+uzEXE8R2i73aNqY1TEVoviBi5X6CgB+p9CbXjomF6+8H6jS0Svx8bCiIH18i
        BXxlh7EYkpY2Xlhc/M2XDhH7TvB3yHlEq2xB4AMqnnFhhHAXEbMr7bEj6M8M0TJ97buvKR80oWcKF
        Nk+Vxy1VAyTeHpFbYetycTzXqK4eXAyHxXGlZQrN2OK11qlUjPygdtZeq6+W+Vkit21EIr6cp+VC4
        O8MeX3BSVEvZzxzNVSKaF4qAT8+e1epdaioajMXaZPfahQqLgWpmPBFjEkrXJrOC/9hxyzfxyjPIO
        aLo8mJAw==;
Received: from [2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] (helo=celephais.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pgki8-007gZ6-03; Mon, 27 Mar 2023 12:08:24 +0100
Date:   Mon, 27 Mar 2023 12:08:22 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nftables 8/8] test: py: add tests for shifted nat
 port-ranges
Message-ID: <20230327110822.GL80565@celephais.dreamlands>
References: <20230305101418.2233910-1-jeremy@azazel.net>
 <20230305101418.2233910-9-jeremy@azazel.net>
 <20230324225904.GB17250@breakpoint.cc>
 <ZCCtjm1rgpa5Z+Sr@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kTvZhV+3SainGJE9"
Content-Disposition: inline
In-Reply-To: <ZCCtjm1rgpa5Z+Sr@salvia>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--kTvZhV+3SainGJE9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-03-26, at 22:39:42 +0200, Pablo Neira Ayuso wrote:
> On Fri, Mar 24, 2023 at 11:59:04PM +0100, Florian Westphal wrote:
> > Jeremy Sowden <jeremy@azazel.net> wrote:
> > > +ip daddr 10.0.0.1 tcp dport 55900-55910 dnat ip to 192.168.127.1:590=
0-5910/55900;ok
> > > +ip6 daddr 10::1 tcp dport 55900-55910 dnat ip6 to [::c0:a8:7f:1]:590=
0-5910/55900;ok
> >=20
> > This syntax is horrible (yes, I know, xtables fault).
> >=20
> > Do you think this series could be changed to grab the offset register f=
rom the
> > left edge of the range rather than requiring the user to specify it a
> > second time?  Something like:
> >=20
> > ip daddr 10.0.0.1 tcp dport 55900-55910 dnat ip to 192.168.127.1:5900-5=
910
> >=20
> > I'm open to other suggestions of course.
>=20
> Not only syntax, main problema is that this port shift support has to
> work with NAT maps, otherwise this needs N rules for different
> mappings which takes us back to linear rule inspection.
>=20
> Jeremy, may I suggest you pick up on the bitwise _SREG2 support?  I
> will post a v4 with small updates for ("mark statement support for
> non-constant expression") tomorrow. Probably you don't need the new
> AND and OR operations for this? Only the a new _SREG2 to specify that
> input comes from non-constant?

Cool, I will focus on this for the moment.

J.

--kTvZhV+3SainGJE9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmQheRgACgkQKYasCr3x
BA2DIw/9EXEIFafYYyx3BDVvfPujk3ouKCr65uyFGU53xQL2JOQoK3vcD/55Tg81
PlxTY6WJocY5nfoK/X4U6sgeklRkLfeHKE8/Gkltgb5T9vnW+652yOkJ8cF3u9tE
bGhAEkatm5irYXGTB2tnMJk1an0dtk3CAHC48lsYX00klHl/MfaSt8229qGOHGHt
IXH9GD2ioUMLV8mtMv+SfW7MlnKd/HKcyMVWBXtMuOQdhJ8tK796B1PT/biXFTdR
FyBfOkgqgt7pTKj9W/UurRkZbzOr5lalCxwrKVLl51GbUtDLXa5D0Ib57qAHXa7r
5MFImqD+ELcnUlK+L++4eKbd5o/sI4+F32StEyRQQPzlvPSy2tPDD8Ch+p7z0c3Z
KH1/mHnoMuSzVM1CKuZlM1ZNKnVLXSvDJ2odp9dB0EGlVH60bntAMRHXa9uB2e3+
PDMGeeXlvp0miHUZHDzDugGPWpqeAdWbzfblbSXvXzgsC+T9txO6wIXkcJtZDTYj
2AgDYEIL+IYVKTkLLjk6M4/fKljrhHGD/pB9UI02G7+7aUZ6QfMMEkGjkyWpTaIH
ph9HUUvPl0rQ1c0xvrFulIdxbrB1k83Q6w2weXTbfjmoGbVQA3UAaBAEjo6rER64
lKoqbsuesITxW6mybYsKYfo1vYscnHsv+LcVoiIbb+P5yDN+y8Q=
=PWET
-----END PGP SIGNATURE-----

--kTvZhV+3SainGJE9--
