Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67FC1C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Oct 2021 19:48:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AFA961A7D
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Oct 2021 19:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhJATt4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Oct 2021 15:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhJATtz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Oct 2021 15:49:55 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7678C061775
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Oct 2021 12:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
        From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kxj1b0HMwngSNCGGPqzFYKu1OHkgA2WeZtQKAqnmuwM=; b=qHKhyPyUODrdUIgyPu3EPVFvCv
        5udBUHlpcTwK8CFgdt0PeHTrQsWb7dFv40hvfsEuVwRkuwsDEwiQJPqdLx7Gh8QGPRBuCwJsUesul
        sWi0kDXCEsBn77D+NSpOIUbzd6FlOKq7GR5aHQxJNl2sJvr8g1U+I7zmxVHckGXEaf7nL4JRWL03u
        2+nq0RVnr9RIv4kcH/nhNtVyZoMGS73tC9MczJ/BYZxUAAD6uyIwQNgm682oFh9/fus2G0Az5/adC
        /baMBNGXB27JDNOPg9AkFidkrOTcJglC7QNqKfdMn5Y43iFpEOqqeKAuabLk+aM++MR8Knd0PEpZM
        fxsolhxw==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mWOVr-002UnI-Io; Fri, 01 Oct 2021 20:48:07 +0100
Date:   Fri, 1 Oct 2021 20:48:06 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     kaskada@email.cz
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [xtables-addons] xt_ipp2p: add ipv6 module alias
Message-ID: <YVdl9kDSbUl/bOUM@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="SjuhU+D1kpcxGKyN"
Content-Disposition: inline
In-Reply-To: <6px.aVLX.4UiUlbqe9QP.1XLsGC@seznam.cz>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--SjuhU+D1kpcxGKyN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-10-01, at 21:39:56 +0200, kaskada@email.cz wrote:
> On 2021-09-16, at 20:08:05 +0100, Jeremy Sowden wrote:
> > On 2021-09-16, at 14:25:00 +0200, kaskada@email.cz wrote:
> > > How can I check where iptables/ip6tables searches for
> > > plugins/modules please?
> > >
> > > Actually the problem is not with iptables but with ip6tables. I
> > > can use IPP2P module on the same Debian with no problems with
> > > iptables, but ip6tables give this error (still the same):
> > >
> > > ip6tables -t mangle -A PREROUTING -m ipp2p --dc -j ACCEPT
> > > ip6tables v1.8.4 (legacy): Couldn't load match `ipp2p':No such
> > > file or directory
> > >
> > > Try `ip6tables -h' or 'ip6tables --help' for more information.
> > >
> > > BTW I`m using legacy (not nf_tables) iptables and ip6tables
> > > (changed with update-alternatives --config iptables,
> > > update-alternatives --config ip6tables).
> >
> > [...]
>
> now I most likely found out where the problem was. Sometimes in the
> past I probably installed theese 2 packages with apt:
>
> xtables-addons-common
> xtables-addons-source
>
> Until I removed them, I was not able to install/use xtables for IPv6
> from source. But now, it seems it works. Thank you so much for your
> patience.

Happy to help.

J.

--SjuhU+D1kpcxGKyN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmFXZe4ACgkQKYasCr3x
BA3U0RAAiZ0WJzmY2BjpB2W3ECcbM/NKqlXKaC4UazoMd9Mn/R84L8Ie+0EfJzzF
SfmnhBCxj5Gy9cM/+tN3BGGgQ27XrbyuH5vR9avhoIGJZ+I0XWP786rxoK+kQrWk
lAWdiFd9aYTzb0SAFNMQFyN65/RKvGhyeSKfFD7e9Gcxylm6RHepZFXz4ug/z1fF
TQoyONlI3MBnh1XcMYf2CBde4yg5d2qd3OgX2xlK6aqEbXmUUChuetDG4sStLqho
jP9wpRAaGVIURLXq8pwKsx6VIUzT5+nzuh0DId0Q7xhy0Y2qghwFLKDj6EHt7lZm
F2DYiUPQ2JuD9/DyLQLSd+4Ei2oe4Gq2+FRpKwLoejnXRxR8xpF4s/N4hyZrMeqo
HFlO4e7dlmLiCXVd4ltFxYUGTVbXAbHkKaPkdXFZRG7tZwH8l4Gp1V06c9CuJOC2
0IU4hvVLKu751Io0Ut7b6miyBQzDh0NM3mKNTzFxMLgJrG4uO1X0Yxc7gCgr8Q3R
jkrzLvbdsw1CL3rjyOGxcrEy/98jzDD2YGFQlHHUd2bJTi9+GyhJlNRZ3p1rxXny
HI0hTNyqGwyQsT+Z22ns76lj8DY0RTzZvncrUTjG7UflY/zEutikwvzJlti+mYE4
lC7ErbeEa4ibpvjaXFCcjNG9LO8efYOARUk8UT9dh2r6g2qNda4=
=3Y6E
-----END PGP SIGNATURE-----

--SjuhU+D1kpcxGKyN--
