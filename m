Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3029FC4321E
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Nov 2022 16:03:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiK3QDn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Nov 2022 11:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbiK3QDm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2022 11:03:42 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CB447307
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2022 08:03:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wbXrvUhUoJlzEa/t/bSCeRsedAWaIbT54Rn54OH6bTo=; b=oPkB7OLqAknRqZIpMKl3uEAG22
        xGJhR+LZ3ML86/9UhsXrMS6sW51oXIu8BmrU0/3b66d4sgOjy+LCj78KRcBlxdyW/9EZZdzmUEXPN
        hIxpMMTaVVxHLWiWULhTXnO+HarihDku6cvOA4GW00/XT1fyFZviv7acXc5E9IBjCRX9lTFq1Vlii
        Ar6oDRyGfJ6DbN0Ol1I31DQ6gG4BKXFEUqQ/tvRJ2cAn0UUf77nPmtyo2nkJNyrzBP1ZTZV3aSl2d
        UVAAc4N8Utxh1EOmofheSomIj6XDTsNVMTkFZ2VSZCbBON3jtEpkDGhrmkfJsBDq0lIONNJwc9/Lr
        GKXM7C5w==;
Received: from [2001:8b0:fb7d:d6d6:d237:45ff:fe20:4c6f] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p0PYe-00EeBb-2X; Wed, 30 Nov 2022 16:03:36 +0000
Date:   Wed, 30 Nov 2022 16:03:33 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH ulogd2 v2 v2 00/34] Refactor of the DB output plug-ins
Message-ID: <Y4d+1SxctrNhRpJv@azazel.net>
References: <20221129214749.247878-1-jeremy@azazel.net>
 <Y4cwJm/ped79pJ/p@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="k9ZAvz+daMyG54LN"
Content-Disposition: inline
In-Reply-To: <Y4cwJm/ped79pJ/p@salvia>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d6:d237:45ff:fe20:4c6f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--k9ZAvz+daMyG54LN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2022-11-30, at 11:27:50 +0100, Pablo Neira Ayuso wrote:
> On Tue, Nov 29, 2022 at 09:47:15PM +0000, Jeremy Sowden wrote:
> > In his feedback to my last series of clean-up patches at the
> > beginning of the year, Pablo suggested consolidating some parallel
> > implementations of the same functionality in the SQL output
> > plug-ins.  I already had some patches in the works aimed at tidying
> > up the DB API.  This patch-set is the result.  In addition to the
> > suggested de-duping and other tidy-ups, I have added prep & exec
> > support in order to convert the sqlite3 plug-in to the DB API, and
> > updated the MySQL and PostgreSQL plug-ins to use it as well (DBI
> > doesn't do prep & exec).
> >
> > This patch-set is structured as follows.
> >
> >   * Patches 1-4 are bug-fixes.
> >   * Patches 5-13 are miscellaneous tidying.
> >   * Patch 14 does the consolidation Pablo suggested.
> >   * Patches 15-26 refactor and clean up the common DB API.
> >   * Patches 27-28 add prep & exec support to the common DB API.
> >   * Patch 29 converts the MySQL plug-in to use prep & exec.
> >   * Patch 30-33 tidy up and convert the PostgreSQL plug-in to use
> >     prep & exec.
> >   * Patch 34 converts the SQLite plug-in to use the common DB API.
>
> It's great that ulogd2 is getting updates, thanks a lot.
>
> But would it be possible to start with a smaller batch? We review
> integrate and then you follow up with more updates.

No problem.  I didn't expect the series to end up this big. :)

> I'll aim at being swift on it.
>
> I'd suggest 10-15 patches in each round.

J.

--k9ZAvz+daMyG54LN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmOHfs4ACgkQKYasCr3x
BA160A/6A6WbyShan3hdAHaIpoyVrUz5NdvpJFV1RF3dbFeOPR67HVPdSrbBqdqw
odAaegAs8e1loGZbhV8ElrKIyiW1TdgshTV7tCd8Vs6JDp7OsN16YBuDJczyQ+dp
9TwHCqcqbX+cYSU4zdxuBve3innBfkjso96dIAt+5my4BtwjtRAktwi1P6ZtTjEM
W1NLAkkqnTVBuN90vI4CkaAWpEpC0oNQbfR1Jp6zViBzd7+CqWixByxJpJhC7fjY
8j1wEFhAyiqB+q4ZmzglU2aVJXQ2mFC5yuC4AXKBL9IT+XGBHn7RR4y8HWEkvHmg
CAdgBNyCAempb97FcEFWpBnT6+DY5EeWOJjrhZgetT7n9yx4hKEGYiiQqtxSNdBA
vwx09x8FBYL9vV1dv1ja0UMg11skzplehOdeKW390Z7o+u6Nw0dnAShwto4/Ldmj
hHhATmdx1C6dW1PVtN7pnfW/EgqASObyACm5Kk7SOZa25PXFc81G5yJUrRpLA3eU
TCEjCMeoCXwa0xe6PdoMR3b6UUpQjNO7jb0IjMtLbVmJ95tbWvD1BApyttDzAUe7
k2sgmR/in9dMlbNhVTW0KwBj1avoEPLc+54pj3BDNtNoCLbRnCgHrZLLKwRy8F5U
1eYxvTVwmq7zT3FcL6XwjKfnlzox4K9tKKRpNShZaWG3gHLxzNU=
=mnOz
-----END PGP SIGNATURE-----

--k9ZAvz+daMyG54LN--
