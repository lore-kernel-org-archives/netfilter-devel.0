Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5F1FC7113B
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Aug 2023 12:56:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbjHXM4A (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Aug 2023 08:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241358AbjHXMze (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2023 08:55:34 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C32C19B0
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 05:55:23 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1bf7a6509deso29671495ad.3
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 05:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692881723; x=1693486523;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oTr6Fye9Sd7qJOJPwegEV16I2HL1wvxsXVw3NwKlTI4=;
        b=Dwqz9Yclt7oYfzvU+ZAKf4V4MNlttQwWjb+H2HwE5afS+ASWRsD9y0QGHowyg9ZAoX
         CdXkkj4snOgX83mjmq+qdV3du0w3TI5wVQrNTzN+8oO1DA9S1N2OaC1iAU5yjjM1Wl9K
         jslrSmTfMONpuwbizLbMnM5FEuxOckM5oeh/H2sf9XOaRQA/netnyolQKfJNN5MJRGlV
         RTCzFUBflilbPk7grQZVAZjET2oO8xqjOEqesVlva/sXEdYmlblBRNj05qusrqgCT/js
         AA61WhcKNP4UBe/GJfWH3IvWZM8Api9hx8egTBql26vkn+mA8Yfk17HDF3BghjQ8rB2A
         pVVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692881723; x=1693486523;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oTr6Fye9Sd7qJOJPwegEV16I2HL1wvxsXVw3NwKlTI4=;
        b=SHcyntWUYU/hhVIfMjazX5WEL7vYee5po9OO/7VeNugIQ9Ty86xUJ2d0LTninf6eb5
         fYgqCrTwsZD1vEam4y8FaH5AFm57iJO4g+LeTJihozUoapRkFdasJZbvZoHlXaZ3x4DD
         1LWlUX4Ik4EA1I3Gl3lNwXa799V+Af4yM6HfwBvcf7CsPQKStXeoUn7xldDxqw5EjpFw
         FXTPHyXntrvjcokCL3aFfW13b2ElS5As6qJak9TEPRl59q04jPyG1LgSuYdFM3jU6yok
         TpnO7meSyuIKV40T9ak6NIthmFC80BEFiywWmHbP4EZhdP+T/cRbu4KQyW+uI0YX8frb
         Iv4Q==
X-Gm-Message-State: AOJu0YwVx0qOk9LzasLFlXM2ZwQGN6pJ3b0Kuv1a6ehh0NCRUKcov349
        pHZPa7d9z7uwZVXEkSyilII=
X-Google-Smtp-Source: AGHT+IGQDPHcTCtN2KIlf6tCDqDLynvqrKK+GL/I/RILryE75BLNfdvwFTd2WQzcvwteaOpV0+0b2Q==
X-Received: by 2002:a17:902:f7cb:b0:1c0:9eaa:c65a with SMTP id h11-20020a170902f7cb00b001c09eaac65amr6317251plw.34.1692881722555;
        Thu, 24 Aug 2023 05:55:22 -0700 (PDT)
Received: from debian.me ([103.124.138.83])
        by smtp.gmail.com with ESMTPSA id m13-20020a170902db0d00b001b8a8154f3fsm12711218plx.270.2023.08.24.05.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 05:55:20 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id C541B81A1A74; Thu, 24 Aug 2023 19:55:15 +0700 (WIB)
Date:   Thu, 24 Aug 2023 19:55:15 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Phil Sutter <phil@nwl.cc>,
        Turritopsis Dohrnii Teo En Ming <tdtemccnp@gmail.com>,
        Linux Cluster <cluster-devel@redhat.com>,
        Linux Netfilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Cluster-devel] I have been given the guide with full network
 diagram on configuring High Availability (HA) Cluster and SD-WAN for
 Fortigate firewalls by my boss on 10 May 2023 Wed
Message-ID: <ZOdTMzsw1fuLCt-a@debian.me>
References: <CAD3upLsRxrvG0GAcFZj+BfAb6jbwd-vc2170sZHguWu4mRJpog@mail.gmail.com>
 <ZONwlkirjv2iBFiA@debian.me>
 <ZOXfBivIvWHkprB0@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="8sKYQrMVynUgW6U4"
Content-Disposition: inline
In-Reply-To: <ZOXfBivIvWHkprB0@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--8sKYQrMVynUgW6U4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[fixing up cluster-devel address]

On Wed, Aug 23, 2023 at 12:27:18PM +0200, Phil Sutter wrote:
> [ Dropped lkml and netdev lists.]
>=20
> On Mon, Aug 21, 2023 at 09:11:34PM +0700, Bagas Sanjaya wrote:
> > On Wed, May 10, 2023 at 11:12:26PM +0800, Turritopsis Dohrnii Teo En Mi=
ng wrote:
> > > Good day from Singapore,
> > >=20
> > > I have been given the guide with full network diagram on configuring
> > > High Availability (HA) Cluster and SD-WAN for Fortigate firewalls by
> > > my boss on 10 May 2023 Wed. This involves 2 ISPs, 2 identical
> > > Fortigate firewalls and 3 network switches.
> > >=20
> > > Reference guide: SD-WAN with FGCP HA
> > > Link: https://docs.fortinet.com/document/fortigate/6.2.14/cookbook/23=
145/sd-wan-with-fgcp-ha
> > >=20
> > > I have managed to deploy HA cluster and SD-WAN for a nursing home at
> > > Serangoon Singapore on 9 May 2023 Tue, with some minor hiccups. The
> > > hiccup is due to M1 ISP ONT not accepting connections from 2 Fortigate
> > > firewalls. Singtel ISP ONT accepts connections from 2 Fortigate
> > > firewalls without any problems though. On 9 May 2023 Tue, I was
> > > following the network diagram drawn by my team leader KKK. My team
> > > leader KKK's network diagram matches the network diagram in Fortinet's
> > > guide shown in the link above.
> > >=20
> > > The nursing home purchased the following network equipment:
> > >=20
> > > [1] 2 units of Fortigate 101F firewalls with firmware upgraded to ver=
sion 7.2.4
> > >=20
> > > [2] 3 units of Aruba Instant On 1830 8-port network switches
> > >=20
> > > [3] Multiple 5-meter LAN cables
> > >=20
> >=20
> > Then why did you post Fortigate stuffs here in LKML when these are (obv=
iously)
> > off-topic? Why don't you try netfilter instead? And do you have any
> > kernel-related problems?
>=20
> I am not familiar with fortinet products, but the above neither mentions
> "kernel", nor "netfilter" or even "linux". There's no evidence either of
> the addressed kernel mailing lists should be concerned. I suggest to
> contact fortinet support instead.
>=20

To Teo En Ming: Again you confuse kernel mailing lists (like LKML) with
Fortinet forum. If you really want the latter, you're welcome at its
official community [1].

> > Confused...
>=20
> BtW: Adding yet another unrelated mailing list to Cc is just making
> things worse.

At the time I added netdev since IMO this was a networking topic.

Thanks.

[1]: https://community.fortinet.com/

--=20
An old man doll... just what I always wanted! - Clara

--8sKYQrMVynUgW6U4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZOdTLwAKCRD2uYlJVVFO
o7haAPwIv2sqOziIdG/4ZgXmUpMTvDunB5sjh2luvWHeqV7oFwD/Q63CdVLO/dEx
LrAr4/fQ3YNJvH+nI5JvCe5NBpSTEg8=
=NLZq
-----END PGP SIGNATURE-----

--8sKYQrMVynUgW6U4--
