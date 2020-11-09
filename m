Return-Path: <SRS0=wVpJ=EP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5440C388F7
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Nov 2020 11:38:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03EC1206B6
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Nov 2020 11:38:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="UqC2EQwI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729654AbgKILiz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Nov 2020 06:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729597AbgKILiz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Nov 2020 06:38:55 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A17EC0613CF
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Nov 2020 03:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xsgzBVZeLSMvrQCoazmZ3y1IgWWpeEi/sG6kUaNYh5I=; b=UqC2EQwIfTuKTddebw9SD3+/7X
        NyzufPVh4nzkygkiT+6u3E82c9i7BUSAwnyXZR+t+hbBcf1vCRlLbg7mVu+qCq1/WFXQ0YVeKuOBe
        q/AI3rbOgvgxB6ol8Yd33pBSgXsC088J9FS5K0ph3QMCgjTxWBQOXV2dcGVIOfr5a2LjX6n903Z/9
        DI9X8ytf4++yk3ymxwdvyXQI+NicJW8nTdUHMDksUOgN443UOXcv1JW/YcYEDkGgzU44yqiMtTnOt
        QogQf0w2WRHvtSC3EaUyUqP36qS8hCFACbYLTJUlo029kEg/f6BkLgRmFxGruv17ulrTDhKO6NQbG
        K4aPKvDQ==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:5ec5:d4ff:fe95:cee6] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kc5Vb-0006wI-K4; Mon, 09 Nov 2020 11:38:51 +0000
Date:   Mon, 9 Nov 2020 11:38:50 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 5/7] tcpopt: allow to check for presence of any tcp
 option
Message-ID: <20201109113850.GA13390@azazel.net>
References: <20201105141144.31430-1-fw@strlen.de>
 <20201105141144.31430-6-fw@strlen.de>
 <20201105191146.GA49955@ulthar.dreamlands>
 <20201105205742.GB49955@ulthar.dreamlands>
 <20201109111014.GC23619@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <20201109111014.GC23619@breakpoint.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:5ec5:d4ff:fe95:cee6
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-11-09, at 12:10:14 +0100, Florian Westphal wrote:
> Jeremy Sowden <jeremy@azazel.net> wrote:
> > This seems to dedup' the payloads correctly:
> >
> >   perl -nle '
> >     our @payload;
> >     our $rule;
> >     if (/^# (.+)/) {
> >       if ($rule ne $1) {
> >         print for @payload;
> >         $rule = $1
> >       }
> >       @payload = ()
> >     }
> >     push @payload, $_;
> >     END { print for @payload }
> >   ' tests/py/any/tcpopt.t.payload > tests/py/any/tcpopt.t.payload.tmp
> >   mv tests/py/any/tcpopt.t.payload.tmp tests/py/any/tcpopt.t.payload
> >
> > One could use perl's -i switch, but the printing of the final payload
> > will be to stdout and not in-place.
>
> Feel free to send a patch that weeds out all duplicates.

Yup, will do.

J.

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl+pKjgACgkQonv1GCHZ
79cvfgv/V2zhI5aLcCRiOt3z4JjksMiGpLUl4qvfaP2a+1D8BBovZK7SYi365ay6
xC9xXHBq7rWeuwHK7FxqT+tMfg+atrlhdPtsKEILGZ2uNNqD9WMaIAPBlqiQX47O
gN2vAaV5XvJgNgtAIgDJHWJ3V1O0xQ3DVfJLREojJnNZ2ETTzS815thSSOJPhl7w
7YWdxO1QlkaZjCIkgUByyoJuLNB1pkJc7/sY8PXaGKVZvueC8yJTG4RNjItoz3ra
g79PtiS4yavhVQ1V1eVH9KNDOF/I4WyOzEuGAMJGKAsNqGt6WrdiQjPXW+Dxhh4x
5yenkqJMZwmBeE36dnWFxubLJodUE2JI6cFeRHKkFeFdHcSqI5w+hPVQ1gLDLxgD
TNHyQUu7psTYtZuvIRhb4J0GsTz5iyCIAo6vQ21fQhjDEz0EJ18ipH87zANvn+fC
YWz8WaBiCMcDO7M41pqcTJxHtYxT70Ec9lGxzLpkduogQDoK92/VS3gsu4MHKl1C
+UGXmPen
=n9vT
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
