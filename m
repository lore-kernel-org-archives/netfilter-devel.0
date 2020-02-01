Return-Path: <SRS0=IEee=3V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8271BC33C9E
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Feb 2020 12:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FE9D20661
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Feb 2020 12:32:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="ED4Mht89"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgBAMcD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Feb 2020 07:32:03 -0500
Received: from kadath.azazel.net ([81.187.231.250]:41220 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbgBAMcD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Feb 2020 07:32:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ocsi8uJvSxDztEiT6qTqf4gPQbjtkMtytcMHxP5iPtQ=; b=ED4Mht89Rv2rKXkHp2A76XrRgX
        FctBvLRmLQbiNnHel37pvCAZHlN8OXYK58odpk2TN7NwveZVEu3UIVDUj9Ya97zy90bGqoEjMOTTN
        u6Cs66ofNxyNSGnVCyuc3HD7T8mUtPaCRNeBrAEs3PnSQ8CIMRNQumcPj2bvInJoQcur9GPRad2tR
        B93P637UL1qQLgCjV7vDkrWJg1o6z/nafDLHttJJjifhqAHaQmxVjao8Z7yg3ud3dkf5Lr9KwsFKm
        zizZL+HWL9rOTdxJ1xX4pDvuW/Xqm/7a2wT1iM2tn/Q694kYHn4Yjm8jaU8DoUQltoFHiBcA/BAJ+
        pfnVuDNg==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1ixrwP-0007ZO-KV; Sat, 01 Feb 2020 12:32:01 +0000
Date:   Sat, 1 Feb 2020 12:32:23 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v3 0/9] bitwise shift support
Message-ID: <20200201123223.GA136286@azazel.net>
References: <20200119225710.222976-1-jeremy@azazel.net>
 <20200128190945.foy5so5ibqecfrqs@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
In-Reply-To: <20200128190945.foy5so5ibqecfrqs@salvia>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-01-28, at 20:09:45 +0100, Pablo Neira Ayuso wrote:
> On Sun, Jan 19, 2020 at 10:57:01PM +0000, Jeremy Sowden wrote:
> > The kernel supports bitwise shift operations.  This patch-set adds
> > the support to nft.  There are a few preliminary housekeeping
> > patches.
>
> Actually, this batch goes in the direction of adding the basic
> lshift/right support.
>
> # nft --debug=netlink add rule x y tcp dport set tcp dport lshift 1
> ip x y
>   [ meta load l4proto => reg 1 ]
>   [ cmp eq reg 1 0x00000006 ]
>   [ payload load 2b @ transport header + 2 => reg 1 ]
>   [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
>   [ bitwise reg 1 = ( reg 1 << 0x00000001 ) ]
>   [ payload write reg 1 => 2b @ transport header + 2 csum_type 1
> csum_off 16 csum_flags 0x0 ]
>
> I'm applying patches 1, 2, 3, 4, 7 and 8.
>
> Regarding patch 5, it would be good to restore the parens when
> listing.

Will do.

> Patch 6, I guess it will break something else. Did you run tests/py to
> check this?

I did and I got the same results before and after applying it.  I'll
take another look.

> Patch 9, I'm skipping until 5 and 6 are sorted out.

J.

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl41b9AACgkQonv1GCHZ
79f7Nwv/Zoxd8wmbjv3GCr5r7wl1dU6G9jRC/lzixTdB7rpWdM54aU9rvJlyUhgV
r4Kdhh7oBD3nVPPlg4VUd/Ee2ewR8/fv+Zthu4Ja78c8re3wl4CxmVL4DVnE405J
TSZ3tk3sAUoP9szX4uKzT5XoUNcZwx8QEWuzat7Rl8g7dIX9ax4EmNGHSf47SzB9
zZM8EVCDyuJJxdLODE/xwRAUCYgsx+fLrcWJ9m9rZOEa5JF5k2iZUzInXRuteDLz
XEhHa7J6qsvc3qaD7TNO6ffxb3Y64UdwuSaFh01daQn83LIgn9oFStc/q1ms98gs
vwznaG5IgmTFtzQp87GkL+29UPq5qzzA4r5y0zRWdDBl6x0/siu8OkupffYFZPxB
zZ3a9m12WsSRk6FRbuV7ekX6F8iapGEp3nd3kqPAE0lcfK15g7Yq7GfE4VjN0rPS
1GEQqR0l9WsgaL0JO7M8EI8FjdxkAyFqsDIfaH/aSJ+qKgdorEdyAuAnrgsGuerz
Zquw7E5Q
=LOkw
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
