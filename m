Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F60AC76196
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Mar 2023 20:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjC1UM1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Mar 2023 16:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjC1UM0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Mar 2023 16:12:26 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5026A2D48
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Mar 2023 13:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FCQZy7RQPN0M61FyoFTNc2iH/rkIMtRGCPbpRO/pFBc=; b=YQW8pbEZUv0yuTOOqTwFR+hX7m
        4qUtWc2ldifPmtBAZwV1bryCjMAMIRs9nKjiZjiGHwWEM4G97VzwKsb6MhOP5CVYyAS9gDlKF5umQ
        nqZStURRLJ4prtoZ7pTvV9ocEE5wiBldkX91dj8cZvTVRi7mpQxhFwWPKrlKhj33/QX02VyWnVmc/
        lBtkfFXseMzVtYZyCsZEnn/C4+DTU3l5Xqy3exKZpCV7Jd5p8cAZcpf+EDH1wPXGi2Sj2eJLGxg6e
        4Jyfc9rmqdjLshfEunG2mJhly5Jc/MOsQcGgaHUYDkLw8ug85KYfbaZgPHiYqPDUKLGk2lgU5JXam
        pmEUdagQ==;
Received: from [2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] (helo=celephais.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1phFg6-009Mky-Tm; Tue, 28 Mar 2023 21:12:23 +0100
Date:   Tue, 28 Mar 2023 21:12:21 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nftables] exthdr: add boolean DCCP option matching
Message-ID: <20230328201221.GA622552@celephais.dreamlands>
References: <20230312143707.158928-1-jeremy@azazel.net>
 <20230328152721.GC25361@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5R2aWwaUXOm7+bnB"
Content-Disposition: inline
In-Reply-To: <20230328152721.GC25361@breakpoint.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--5R2aWwaUXOm7+bnB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-03-28, at 17:27:21 +0200, Florian Westphal wrote:
> Jeremy Sowden <jeremy@azazel.net> wrote:
> > Iptables supports the matching of DCCP packets based on the presence
> > or absence of DCCP options.  Extend exthdr expressions to add this
> > functionality to nftables.
> >=20
> > Link: https://bugzilla.netfilter.org/show_bug.cgi?id=3D930
> > Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
>=20
> LGTM, thanks.

Cool.  I've just spotted a data-type ref-count bug.  In `dccp_init_raw`:

  expr->dtype =3D &boolean_type;

should be:

  datatype_set(expr, &boolean_type);

I'll send a new version with that fixed.

I think there are a few more instances of this sort, so I'll send a
follow-up patch for those.

J.

--5R2aWwaUXOm7+bnB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmQjSh4ACgkQKYasCr3x
BA1wShAApUNrGDcSYhy7PQvYK5KzaM+i7LWM8O7+C6mdyyAezThMk2nx2utqPO5C
Rxr21EVJH/X51l+zzMokMeHWIOXpCJxo80VpYt6s/bb1l4lpi1PkdA1VzwqaKQyz
bG47Dtp1JSqL3K4DUFlVbCog22xz/ky5WTb3eDe99SyMg5IXd5HaMDYkAXH9gR9S
6ftNDb//nJ/wfZ4hApmxyygIZTWVDW18UObnnxpDTrK+797bvCdE6cEGsWH2Yd76
7asugO7ZxIwVltmHU/eCzkuUCUiil3PP1GISaAOe2S/QyBPJ+IwoVbSB+Eabp7rb
2VpIC1dUmH6+YZOeiH49AwqYaeD7c+Gd0pbyuElB7XolkHcsauIpdxeZ+9cxUTTa
dvSGKAGHPyUNQxzbM8OeFeIBx4M+UU4YI5/jzb05rxOn55W/UWbP+l+qvUdb14PG
YcQd/vueLjZog6A1N4BZIhuJRXS8h373P2mrG+6u3c0+HwjprKH97rKO/H+ZfyKI
GEA+Bo/YR+enSEhSMVuKHslJ18dUJmOl6b499vK7gLQ7r6Uoy2hVDJZskZgnSsK0
FbHXzyg816OS+mqXXGp2PMbXXj22LZIqSN7f/M9z8g3sIKTwR73LVfn4McynOeL/
qFP4ikWrO2JFwKpYyKsLAWV33BEYuAzU6csgx75aI05ziB7Xi9o=
=vXRP
-----END PGP SIGNATURE-----

--5R2aWwaUXOm7+bnB--
