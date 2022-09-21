Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C092ECAAD8
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Sep 2022 19:46:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiIUTqW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Sep 2022 15:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiIUTqW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Sep 2022 15:46:22 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B77CA00FB
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Sep 2022 12:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YG+KsAQr1sY7VKjlGFeOsq1mewMoQF3n6qdO4exPPXQ=; b=W/4iv4+8tdDCZeF/TtH3H4EJvE
        OSwuZozdR93kVweefmDmrFn8Gh7kdgZiHOCJ7SyS8oQzMboHH25V7z+C+kc+reVGZLfhZqJkkZgNa
        QrxWRjtDMLehvsPl12DxA+Lrg2tLuoX6s8RH5615t+MYNJRI21RQLkP4ZzR1iaUwi0yKRjj83Bz07
        qRniMNcVK10Fyf7BeTv5AT/rKw39VWB+2Zi/nOkUZ0qmQLCD2fCcfWFWdmQqxRWaoSxEtwrrqA5PK
        0LSC6Ot5rVFfKCPYlW5ghgLOtNostrzWH41YJp4DTb35TodoIM7Uy7qlx+u9sr0K2caM8h7VDxYvV
        jPFr6hZQ==;
Received: from [2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1ob5fk-006xQf-It; Wed, 21 Sep 2022 20:46:16 +0100
Date:   Wed, 21 Sep 2022 20:46:15 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 2/2] segtree: fix decomposition of unclosed intervals
 containing address prefixes
Message-ID: <YytqB90MypDn7gHr@azazel.net>
References: <20220918172212.3681553-1-jeremy@azazel.net>
 <20220918172212.3681553-3-jeremy@azazel.net>
 <Yyr6C+IKMrCM0hQJ@strlen.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="/izIYpxAJPlnt6dR"
Content-Disposition: inline
In-Reply-To: <Yyr6C+IKMrCM0hQJ@strlen.de>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--/izIYpxAJPlnt6dR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2022-09-21, at 13:48:27 +0200, Florian Westphal wrote:
> Jeremy Sowden <jeremy@azazel.net> wrote:
> > @@ -619,24 +622,12 @@ void interval_map_decompose(struct expr *set)
> >
> >  	if (!mpz_cmp(i->value, expr_value(low)->value)) {
> >  		expr_free(i);
> > -		i = low;
> > +		compound_expr_add(set, low);
> >  	} else {
> > -		i = range_expr_alloc(&low->location,
> > -				     expr_clone(expr_value(low)), i);
> > -		i = set_elem_expr_alloc(&low->location, i);
> > -		if (low->etype == EXPR_MAPPING) {
> > -			i = mapping_expr_alloc(&i->location, i,
> > -					       expr_clone(low->right));
> > -			interval_expr_copy(i->left, low->left);
> > -		} else {
> > -			interval_expr_copy(i, low);
> > -		}
> > -		i->flags |= EXPR_F_KERNEL;
> > -
> > +		add_interval(set, low, i);
> >  		expr_free(low);
> >  	}
> >
> > -	compound_expr_add(set, i);
>
> This results in a memory leak:
>
> __interceptor_malloc libsanitizer/asan/asan_malloc_linux.cpp:145
> xmalloc src/utils.c:36
> xzalloc src/utils.c:75
> expr_alloc src/expression.c:46
> constant_expr_alloc src/expression.c:420
> interval_map_decompose src/segtree.c:619

I did try running the new shell test under valgrind: lots of noise, not
a lot of signal. :)

> Before, 'i' was assigned to the compund expr, but thats no longer the
> case.

> Does this look good to you?

Yes, LTGM.

> If so, I will sqash this before applying:
>
> diff --git a/src/segtree.c b/src/segtree.c
> --- a/src/segtree.c
> +++ b/src/segtree.c
> @@ -621,13 +621,14 @@ void interval_map_decompose(struct expr *set)
>  	mpz_bitmask(i->value, i->len);
>
>  	if (!mpz_cmp(i->value, expr_value(low)->value)) {
> -		expr_free(i);
>  		compound_expr_add(set, low);
>  	} else {
>  		add_interval(set, low, i);
>  		expr_free(low);
>  	}
>
> +	expr_free(i);
> +
>  out:
>  	if (catchall)
>  		compound_expr_add(set, catchall);
>

Thanks,

J.

--/izIYpxAJPlnt6dR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmMragAACgkQKYasCr3x
BA1nFg//VO/Cymutv9QgRfD9okpdzIykBRUkF5PKtG1I88osG+mBRzSHdXtsmsmZ
CywcXqDTwO/SDE9pt92lQgtF3PRT5gXtOiUBFrf5e0BpeKf6El50NFKt+WGqrbjX
VwVumts1DHU95XYDNylK5DMEzKe02KpuzqfJUOU6nr1f5QLug7JdrrGgYXPl87vB
zvX3u4FjlMx6SkHPPClenLnt2jndw+nCskvuL5go1ITW34e2EDxLxsvGraFyy5m/
ZoRWCXm9kDB0B9TkiUkOgeFntH9Y2dtYNRnTlZmX0SHsHASdqSDQ9Fj1gFPCi/cJ
aGeVefeTxYDqgHUXZOWf3JVOYmJgzUJCmH2KPE/IZ1HBgV+T8Hz4nLZJaK4bWCHE
ezC4jGHww2HMeIJfXbmGxS3iy3q8iuEHJkSEHhHKugG4v+zDvwJKBs4kZ7JymaFk
ASl3QEbQDzxS1F5I4ZvIN1Bbdn0+B+nm+uMdc3UEjkFr+CV2M1v7mBwldcmRf6rj
8iYyZYRYdf93GC/347BCMpc5T1RLKv5o9SSgqCOtcD8RaXXUml5Ec8TCbkkdVH9l
SouRuVjFQf2B7L9lhvFzsSszGhjTnVXZUumna+Shb+pmK90YbXGw7STO+jfIG/nN
6k2gHeK64rnR7lxOmwYP2K10T2Bd4aMgiPOKILL4eDpKK/0uUsU=
=ul1Z
-----END PGP SIGNATURE-----

--/izIYpxAJPlnt6dR--
