Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B60FFC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Jan 2022 12:44:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239740AbiAKMoh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Jan 2022 07:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239558AbiAKMoe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Jan 2022 07:44:34 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E8ADC06173F
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Jan 2022 04:44:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=e8wwGC/apYY4lJYRHjxcKnjcHNxo00D5BEnquy+967o=; b=OqbMM2OuDnD8LaTCi7kyoqoHIs
        IBux7q6JHkGCAZSRJjmdAo3AmzeLEAnr11MF4hGzy9ueaSqk+9vT/1BWJBvqSZjfIFrvXGolVxcI3
        JAKXw8AeXYm5XmN/Zb/nKi6laVR802vAkD2PGpeHGD2LJ2WVDyHMAuA6HaygcQEOb9Ng6EP3yBlW9
        P5xXLhwra44P69bYzaTYSdnt9qFS9c3op+YTbzPJPLiqEOH0uFF5Z8nPodITqn/qMZIkjAhKqAryQ
        Poke96WNJi7aXsKhQwMuAHEpVeZ7Kw13IS+AjE4tDMI72B2SBiNLfkXC1PEyZHZ3ZDm3we2D9iFui
        u9YZT/6w==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1n7GVr-004Eac-Gl; Tue, 11 Jan 2022 12:44:31 +0000
Date:   Tue, 11 Jan 2022 12:44:30 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [ulogd2 PATCH 00/10] Add pkg-config support
Message-ID: <Yd17rvBCXyAUSVvw@azazel.net>
References: <20220109115753.1787915-1-jeremy@azazel.net>
 <YdykZPrWzek+3P71@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Fnel5kRslkQXumE2"
Content-Disposition: inline
In-Reply-To: <YdykZPrWzek+3P71@salvia>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--Fnel5kRslkQXumE2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2022-01-10, at 22:25:56 +0100, Pablo Neira Ayuso wrote:
> On Sun, Jan 09, 2022 at 11:57:43AM +0000, Jeremy Sowden wrote:
> > A number of third-party libraries have added pkg-config support over
> > the years.  This patch-set updates configure to make use of it where
> > it is available.  It also fixes some conflicting option definitions
> > and adds checks that cause configure to fail if a plugin has been
> > explicitly requested, but the related third-party library is not
> > available.
> >
> > Patch 1:      switch from `--with-XXX` to `--enable-XXX` for output
> >               plugins.
> > Patches 2-5:  use pkg-config for libdbi, libmysqlclient, libpcap and
> >               libpq if available.
> > Patches 6-10: abort configure when an output plugin has been
> >               explicitly enabled, but the related library is not
> >               available.
> >
> > Changes since v1
> >
> >   * Better commit messages.
> >   * Simpler mysql patch: remove the upstream m4 macro calls, and
> >     look for `mysql_config` the same way we do `pg_config` and
> >     `pcap-config`.  * `AM_CPPFLAGS` fixes for mysql, pcap, and
> >     postgresql.
> >   * `LIBADD` fix for mysql.
> >
> > Jeremy Sowden (10):
> >   build: use `--enable-XXX` options for output plugins
>
> I hesitate about this change from --with-XYZ to --enable-XYZ, it will
> force package maintainers to update their scripts.

True.  However, it is a one-off change, and ulogd2 doesn't change often
-- the last release was in 2018 -- so I would argue that the maintenance
burden isn't very great.

> Althought I agree after reading the documentation that --enable-XYZ
> might make more sense since the input plugins rely on netfilter
> libraries which are supposed to be "external software".
>
> >   build: use pkg-config for libdbi
> >   build: use pkg-config or mysql_config for libmysqlclient
> >   build: use pkg-config or pcap-config for libpcap
> >   build: use pkg-config or pg_config for libpq
> >   build: if `--enable-dbi` is `yes`, abort if libdbi is not found
> >   build: if `--enable-mysql` is `yes`, abort if libmysqlclient is
> >     not found
> >   build: if `--enable-pcap` is `yes`, abort if libpcap is not found
> >   build: if `--enable-pgsql` is `yes`, abort if libpq is not found
> >   build: if `--enable-sqlite3` is `yes`, abort if libsqlite3 is not
> >     found
> >
> >  acinclude.m4             | 351 ---------------------------------------
> >  configure.ac             | 192 +++++++++++++++++----
> >  output/dbi/Makefile.am   |   4 +-
> >  output/mysql/Makefile.am |   4 +-
> >  output/pcap/Makefile.am  |   2 +
> >  output/pgsql/Makefile.am |   4 +-
> >  6 files changed, 165 insertions(+), 392 deletions(-)
> >  delete mode 100644 acinclude.m4
> >
> > --
> > 2.34.1
> >
>

--Fnel5kRslkQXumE2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmHde6YACgkQKYasCr3x
BA1xNg//T0PdkMwLprAfI6tt7TPXaow6uV1R3H2YHkd9dRKLz8Rmjsmchqe1w2/m
C4YHXqJSWJJORIUTlIcznHy9rPHVdMi8cWTZA3Rdfqel3NrKzOasde/EWVewTQ5R
WReeYMM5ECLtXqRVq6v8Wx8e3DZ4FSwoCO6nSy98UXSO1FacEgVwY4KT6HeqJEnh
5oGqW6uLjQ8Lgor/VwBxSGooWDhtzYE3D3h+PsuwOT/WWP0N9jjhUmMyQCDNLirz
J0I/f16+I2sK4YgMgXFUsjPXxpQkrZZpevc/hTsISSXEZqWcDwOroYfFk8GCZkL8
Ex9tjIwN28fvaVRmJyqSIdO/W1KlTh0ZBumLNSbiQDB/VDZqMe9F6USBcigmvmap
AN2+62qvEt2eqzpJBoaCCTU1mZcf2xlZn7JSMGhSYdA+X4ZDpG27D1E2x5Lp6gE7
HAtWCku0XmTsmrzkbMWsv9KbrGnC4yPqzN7gJrxz+YcEfBI0PDnkef7JLHmBh2RZ
ub0FcDduHffkDGckgY3jAFz4UveW0QP12gROFGPS0yg0eJcHNGGJjnJbIGXZ4Eam
ihhc1sx7CEvGbDSo8kLQMbKkWk//SbKYbSL7tt+EAaifTiHMiW41pLph/GDyEwyM
HgEnN37jqYzaGRqC5Zqh9ErDD351Ef95aDegW21BddSrDgFihQE=
=Ao74
-----END PGP SIGNATURE-----

--Fnel5kRslkQXumE2--
