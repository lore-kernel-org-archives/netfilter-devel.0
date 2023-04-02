Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D329C7619A
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 Apr 2023 18:30:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbjDBSah (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 2 Apr 2023 14:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDBSah (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 2 Apr 2023 14:30:37 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3152B45E
        for <netfilter-devel@vger.kernel.org>; Sun,  2 Apr 2023 11:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yL0JvS0ThkL0FGdCHwXVx0R534sNd8KA9MlaTXbWHGM=; b=WcWafyDY34woFLzo5lRzlcu1cJ
        CKnlMMOWzgUNRejbi73WBCfcdg0ft0C/X3yHnUHyadIaw1E0O6YF1qy37jTO+iB1WJ5D3nC9CnufB
        NOddU4onnz4+siSe9wkmNu9DIcEWI+1YkyklJiNhu4+qHOgwXDxcVxmsehM3P9U4eITNZUcg/UDiJ
        AALJuVvuarq1z4rtLaqTktSN31P5f2LFR86rEfWzk/LiIIQGuNzTW6wzsLqrlTueLqNTrRJLi8mPl
        C4IK5pn9mOyib5i3sEgVwRd4r6k5bUmskQ7LaooxKnUC8odFJpEgR0Z8pAb5JHGDGptpphIw8nP/5
        iBxufHoA==;
Received: from [2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] (helo=celephais.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pj2TK-00Fg5g-7G; Sun, 02 Apr 2023 19:30:34 +0100
Date:   Sun, 2 Apr 2023 19:30:33 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Alyssa Ross <hi@alyssa.is>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables] build: use pkg-config for libpcap
Message-ID: <20230402183033.GF730228@celephais.dreamlands>
References: <20230331223601.315215-1-hi@alyssa.is>
 <20230401114304.GB730228@celephais.dreamlands>
 <20230401123018.GC730228@celephais.dreamlands>
 <20230401195412.gjradx2lisntbk7z@x220>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="b2o5uZ9ptPCvvm1F"
Content-Disposition: inline
In-Reply-To: <20230401195412.gjradx2lisntbk7z@x220>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--b2o5uZ9ptPCvvm1F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-04-01, at 19:54:12 +0000, Alyssa Ross wrote:
> On Sat, Apr 01, 2023 at 01:30:18PM +0100, Jeremy Sowden wrote:
> > > > diff --git a/configure.ac b/configure.ac
> > > > index bc2ed47b..e0bb26aa 100644
> > > > --- a/configure.ac
> > > > +++ b/configure.ac
> > > > @@ -114,7 +114,8 @@ AM_CONDITIONAL([ENABLE_NFTABLES], [test "$enabl=
e_nftables" =3D "yes"])
> > > >  AM_CONDITIONAL([ENABLE_CONNLABEL], [test "$enable_connlabel" =3D "=
yes"])
> > > >
> > > >  if test "x$enable_bpfc" =3D "xyes" || test "x$enable_nfsynproxy" =
=3D "xyes"; then
> > > > -	AC_CHECK_LIB(pcap, pcap_compile,, AC_MSG_ERROR(missing libpcap li=
brary required by bpf compiler or nfsynproxy tool))
> > > > +	PKG_CHECK_MODULES([libpcap], [libpcap], [], [
> > > > +		AC_MSG_ERROR(missing libpcap library required by bpf compiler or=
 nfsynproxy tool)])
> > > >  fi
> >
> > When autoconf first encounters `PKG_CHECK_MODULES`, if `$PKG_CONFIG` is
> > not already defined it will execute `PKG_PROG_PKG_CONFIG` to find it.
> > However, because you are calling `PKG_CHECK_MODULES` in a conditional,
> > if `$enable_bpfc` and `$enable_nfsynproxy` are not `yes`, the expansion
> > of `PKG_PROG_PKG_CONFIG` will not be executed and so the following
> > pkg-config checks will fail:
> >
> >   checking for libnfnetlink >=3D 1.0... no
> >   checking for libmnl >=3D 1.0... no
> >   *** Error: No suitable libmnl found. ***
> >       Please install the 'libmnl' package
> >       Or consider --disable-nftables to skip
> >       iptables-compat over nftables support.
> >
> > Something like this will fix it:
> >
> >   @@ -14,6 +14,7 @@ AC_PROG_CC
> >    AM_PROG_CC_C_O
> >    m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
> >    LT_INIT([disable-static])
> >   +PKG_PROG_PKG_CONFIG
> >
> >    AC_ARG_WITH([kernel],
> >           AS_HELP_STRING([--with-kernel=3DPATH],
> >
> > > >  PKG_CHECK_MODULES([libnfnetlink], [libnfnetlink >=3D 1.0],
>=20
> Another option would be to just move the libpcap change after this
> unconditional one, avoiding the manual initialization.  Do you have a
> preference?

Not really.  Atm, I am marginally inclined to think that the explicit
initialization is more robust, but I don't remember ever having done it
myself in the past, so if you prefer to move the conditional that's fine
by me.

J.


--b2o5uZ9ptPCvvm1F
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmQpyckACgkQKYasCr3x
BA2lzxAAoE95FVp+PRU2dX2tMTngWTprwezGSpmcg3b6ArGB33Of5gfgMjjU4kO9
QpgDZwAXSlo5DzsqUzoxPkqjBSvD0DpFHseRAxByt1xBGbAsy33K8a2jpqHS8req
XOVu2EqvVVZrROqkOf/wH/IRxfpPtnUWdctTSthlPtVMZjwvNJmOeZpEIe38pHY5
koaoZi1SWT+oIenhN2f23KZTA3NN2M68mVOhp9jefX/aJMpoaZnpzSWWgk5ts2tN
XoRrScBAVvt31k20Y9rYbpJieDkChCJNA6nltP8XnSMJ53bxCSWBHghxyfrf7XBp
ceTkXGcmLOnR7OOjqbA0piUoG5qacT3yxT41itcerRrAvpuw/hpwv/YdGf56ul9y
JnkkVJg4pj14o6mlCR0f7dz5GV+8GCnJAjwg25apkRBcjmVlBYBmqF/QqHQT68AK
EC3S78ss9lCKTF+siuwdfvVnLY6rBV5ltk6Qv1mAnSFOenoaV9pdCr6EP1Vg0k9B
RPIvjzA/AQnjUaeuSIcHLxijw9wIaT3haW0UZL6in/qqs+t+L3LsLHuE5lZcf/or
eKuTXyvOvIKSOk61WEj25PkMhH+M0e6ZFOPiKdX4nFoZlsKJk7eiMFa5heKpne6Z
C0u7ZiIWFGw5JzOm1aFjEy8oG1DBN2ymUlFHDGi6T3ywrPRky+4=
=dK4y
-----END PGP SIGNATURE-----

--b2o5uZ9ptPCvvm1F--
