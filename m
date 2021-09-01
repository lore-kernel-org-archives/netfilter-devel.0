Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01B72C432BE
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Sep 2021 10:03:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8B1761026
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Sep 2021 10:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbhIAKEg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Sep 2021 06:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhIAKEf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Sep 2021 06:04:35 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED45C061575
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Sep 2021 03:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=T5emCGNiBG3eke8e+ljIBNC8rd/5TSY1BBCw7COTT5A=; b=Zxj6hdJf5q4wIkID5N73fhp37E
        DyN61P0d3Hklmr8Jb1/7Blpg92zAj5F0/aovPcmThi8L0hKDwAQVhEVEhgVXTs/eIhHspqKwXqbPE
        y+tsXl81YDnktbhNY32onsAXkf+D7eiCMDKJENLFDdCc1ZuSPSPDmes/ROGAaKaXLCISGdU2QeNvs
        y8kOz6xasM3KtI7xBqokleh2u3ZuQ0r9CsbQ1dxxKWO2T7nRVH6B4B/0rV1Ngwj9vtG3LbKWBlhnv
        DXuwY+LTrTyFH0p3dbeTOev/pOxNXYEX5uKq/uDLggUB+fxCjraf/R4v3LE+1F3EzTz0+GGVdloXz
        cNn3I4ZQ==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mLN5k-002RgK-29; Wed, 01 Sep 2021 11:03:36 +0100
Date:   Wed, 1 Sep 2021 11:03:34 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnetfilter_log 0/6] Implementation of some fields
 omitted by `ipulog_get_packet`.
Message-ID: <YS9P9kGwXCohlhDy@azazel.net>
References: <20210828193824.1288478-1-jeremy@azazel.net>
 <20210830001621.GA15908@salvia>
 <YSw1dN3aO6GeIPWq@slk1.local.net>
 <YSysxcqZ7iSZsPjZ@azazel.net>
 <YS3vksGnGEchZZxq@slk1.local.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="HSFFw9SVei6azwE8"
Content-Disposition: inline
In-Reply-To: <YS3vksGnGEchZZxq@slk1.local.net>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--HSFFw9SVei6azwE8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-08-31, at 19:00:02 +1000, Duncan Roe wrote:
> On Mon, Aug 30, 2021 at 11:02:45AM +0100, Jeremy Sowden wrote:
> > On 2021-08-30, at 11:33:40 +1000, Duncan Roe wrote:
> > > On Mon, Aug 30, 2021 at 02:16:21AM +0200, Pablo Neira Ayuso wrote:
> > > > On Sat, Aug 28, 2021 at 08:38:18PM +0100, Jeremy Sowden wrote:
> > > > > The first four patches contain some miscellaneous improvements,
> > > > > then the last two add code to retrieve time-stamps and interface
> > > > > names from packets.
> > > >
> > > > Applied, thanks.
> > > >
> > > > > Incidentally, I notice that the last release of libnetfilter_log
> > > > > was in 2012.  Time for 1.0.2, perhaps?
> > > >
> > > > I'll prepare for release, thanks for signalling.
> > >
> > > With man pages?
> >
> > I was waiting for you and Pablo to finalize the changes to
> > libnetfilter_queue with the intention of then looking at porting them to
> > libnetfilter_log. :)
>
> The are at least 3 areas which could be worked on in the meantime:
>  1. Fix the remaining doxygen warnings (attached)
>  2. Insert the SYNOPSIS sections with required #include stmts. I've
>     found that to be a bit of a black art e.g. pktb_alloc() doesn't
>     actually need libmnl.h but if you leave it out then you need
>     stdint.h which libmnl.h drags in. So specify libmnl.h because
>     other functions in the program will need it anyway.
>  3. The doxygen code will need a bit of "tightening" so man pages look
>     better: ensure all functions that return something have a
>     \returns; add \sa (see also) where appropriate; list possible
>     errno values in an Errors paragraph (or detail the underlying
>     system calls that might set errno); maybe clarify wording where
>     appropriate.
> >
> > The most recent Debian release included a -doc package with the HTML
> > doc's in it, and the next one will include the test programmes as
> > examples, but I think the man-pages need a bit of work first.
>
> Yes the 3 items above should be most of it.  I'm happy to work on them
> or would you rather?

I dare say that the work will probably go more quickly if you do it.

J.

--HSFFw9SVei6azwE8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmEvT/AACgkQKYasCr3x
BA0BeRAAwBIeZV2Y0TeyiNhZX6TliAozi/9Psq49mHGSBimWuJqfxm7r1+4FLvV1
O4HCGz4+MIY/YphfHvhBy95/RKevurB+uz1qX3tPqgZCqG/zD/SCVZsdVS3JeGJO
yViS7L+qLSRtsfvJwJoNM3bapvMjcWb6GPCTFXzv9layF/RMSvhPKTY7NCLHohq1
yqImo/lMFeW5sjLV/kiNRKz+A/KfJDw1C8t+gqfV3g4lhLSkhPhXGtgQU+NBBKUV
A+MA2GW3jeMS0ToDd8Ez6eOWOFzRCKhjtugXD6cB+e2Z2n5oln8hnIOH41QGzy8e
3MaR+ij5bcKGEjzRkFy5tu2hWUH5+gMslpUCuaptQ5fx4qbPdpAq7fkbNB8bAx66
410NvLSbUo1vnxw20YsEOq/AVi+Al/IdUBIREe1YDx0GgQIgiHA++pZHuSLHsZk1
P4/m6vpfQfs3Zi+Isu71yhXu2zv9radxWDGN+YTLFIDIJm3wSQ+M68S+B9plM6zj
qkaEZVAw8VQcoPaT1/Ey2p0MRuZ/O0ETiB3aAoq4mpZvwh7GZUgwAPu9DHoOL3Fw
ga2To/pfDtSgOoHA74yMAl3jssZU3Bix9tGoAY35SMhIZVMROsENltWZLYzm3y5Y
g/dKuJZvEx1goEg32WaLGxXdEZ6h8asLVyz8WQ/HGsjwRi6qDEs=
=54MA
-----END PGP SIGNATURE-----

--HSFFw9SVei6azwE8--
