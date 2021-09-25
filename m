Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A56AC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Sep 2021 17:29:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 622276109D
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Sep 2021 17:29:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbhIYRay (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 25 Sep 2021 13:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhIYRax (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Sep 2021 13:30:53 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F67FC061570
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Sep 2021 10:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EJyvbWaIUB2rH3KkJBmI2y4ha1OBAPtGNxhfdpv1XhM=; b=PouLWbKQ3HKxn3J8zS1TbOkeqm
        oCJ9Icn0CKdG5Fik3r+4XsbLoRsC4ZJ2Q2Ar1gL2O3Nq27SL6sQIW+7uXXJ50z78pVOBzF/bE5dHf
        0jAROOLmKPxS23YF9QiOwOOSkf8BcDDpa3FG10ETg86y2I/7qvheAP2O10XHASfzqaKaMebGMhoAz
        N+AtOqu3NigQtBzUgzxOLlSqXAgQnj4NIHBnn9F0efPvxPP5j8YQb0+Cc55YrshIQT+KvNIifOEHA
        U1Yb8wxAhhIdECQ15vM/fKvTKskc8b9uSpD0k5ynydANFo2lL+hq5Sj/7lQtQTVPr6Zn+l0IVYCGr
        g105gDew==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mUBUA-00Cw4o-Qa; Sat, 25 Sep 2021 18:29:14 +0100
Date:   Sat, 25 Sep 2021 18:29:13 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [conntrack-tools 6/6] build: fix dependency-tracking of
 yacc-generated header
Message-ID: <YU9caae8KEdskfVp@azazel.net>
References: <20210925151035.850310-1-jeremy@azazel.net>
 <20210925151035.850310-7-jeremy@azazel.net>
 <4626n855-s692-r9sn-30rn-rosr6s179sn@vanv.qr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dGczh2Lg6y/E/lOq"
Content-Disposition: inline
In-Reply-To: <4626n855-s692-r9sn-30rn-rosr6s179sn@vanv.qr>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--dGczh2Lg6y/E/lOq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2021-09-25, at 17:49:27 +0200, Jan Engelhardt wrote:
> On Saturday 2021-09-25 17:10, Jeremy Sowden wrote:
> > List it as a built source in order to force make to create it before
> > compilation.  Otherwise, a parallel make can end up attempting to
> > compile the output of lex before yacc has finished generating its
> > own output:
> >
> > --- a/src/Makefile.am
> > +++ b/src/Makefile.am
> > @@ -6,6 +6,7 @@ endif
> >
> >  AM_YFLAGS =3D -d
> >
> > +BUILT_SOURCES =3D read_config_yy.h
> >  MAINTAINERCLEANFILES =3D read_config_yy.c read_config_yy.h read_config=
_lex.c
>
> I have a strong reason to believe that you could just write
>
>  read_config_yy.h: read_config_yy.y
>
> (detail https://lists.gnu.org/archive/html/automake/2021-09/msg00011.html=
 )

Automake complains:

  src/Makefile.am:65: warning: user target 'read_config_yy.h' defined here =
=2E..
  automake: ... overrides Automake target 'read_config_yy.h' defined here

=46rom the documentation (https://www.gnu.org/software/automake/manual/auto=
make.html#Extending):

  Note that Automake does not make any distinction between rules with
  commands and rules that only specify dependencies. So it is not
  possible to append new dependencies to an automake-defined target
  without redefining the entire rule.

In this case, adding the rule you suggest to Makefile.am suppresses the
rule that automake would normally generate:

  read_config_yy.h: read_config_yy.c
          @if test ! -f $@; then rm -f read_config_yy.c; else :; fi
          @if test ! -f $@; then $(MAKE) $(AM_MAKEFLAGS) read_config_yy.c; =
else :; fi

J.

--dGczh2Lg6y/E/lOq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmFPXGMACgkQKYasCr3x
BA1JiA//XssQ2nob/L9NISovRpS7t+Bv5r1Yz3AYFUp4G8WvRKPBCg0uysanVLPo
1/hzNvtkdOUOXppsmC1PgOBe0V2vzAmMKy62uy8XGlJ5rjFppj5RxpFz1hPpWl0a
iwRt3EsswHvlyNKPnHTQDjG+HcaqKkxb0mNY+GNU71aCdt4/ZjrAdr3/vdsw10Ms
6GNgRpOC773oZiheyT5EocsfbhwwVLFuEVd81sAGWJ5HF/WPsIGfvNga5HV6GIgN
2obXGM73j41ErFe7lwyn9VudqXfY/ZdZKiwbz6Tgj6F6lcUUT1r3FLwE77ZGm7N6
CS399aneB+TXqxzVGNGaQjvJWWXyTLXogYYaviLd5eTsb8jpa2nUW1HiTyXdtFZx
sdDmXA5FymzYvZh33nQUCdKlZA3jNJAdvDHTt3Cc9CjM9Mb1d/F7o1NDsGaMDHok
KIMyhX1WSODu0YM8D4s8IMMdmZv+S0sNDNiXzBg7li35Zbo/lhWhZxu2WewKa9ee
X+O35LjYpcNfRsePJwdhq08p6iB7jJqmZpEHK9e4/0GPr0EhYqyJpGS7Kwi3VOgy
HzbLdpAqLEI26DUFDvBIaD3Klklqn9D4eqtPQ8Mjh+TSsNn9cFjaxKh8R57kRg5q
GypSGwL/MfESdBo/HwVPoDXB1JwHsKIztfAmvpxEIEg9+yehpC4=
=coUR
-----END PGP SIGNATURE-----

--dGczh2Lg6y/E/lOq--
