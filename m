Return-Path: <SRS0=d85k=XR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5E91C3A5A2
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Sep 2019 09:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4468D2070C
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Sep 2019 09:22:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="P9gl1t5b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbfIVJWp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Sep 2019 05:22:45 -0400
Received: from kadath.azazel.net ([81.187.231.250]:59108 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727943AbfIVJWo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Sep 2019 05:22:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=joQD4rs3aZSU9STcgMyFUSQACkHE49n9ySXFViziTiQ=; b=P9gl1t5by+IoDqEirTK5O0DJX2
        B/jz2i5g0SpxQZaJdSFiTVi5aNz9ao2FiQK3KR+KdWEm/+uIJ8mUtvwPX68FuLXXJT4GnQRgviBst
        GiSPJOL+zBjT8SIjW4lRnEd39iBx1fGscpYnT8gPbIRk4+egMYI5L2kUDgtpQglBgZoXoGYWeQBGO
        XZ9emM2ZomJCKky7JGTCZs7s4RoBI3gxx6PDbtcT1Xee5hVDZHD1qhQd7RhxmyOfb6BI8RCoL5Shh
        Ymk0iE8pbHqgfJ46JFqTw3Y9+Bfpvcc8L4jbZmqnxMSo3mLdneTMtS85Klc3cNBKLytN3UQ+VdbIH
        Hjx+EBtw==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iBy4m-0001DE-4l; Sun, 22 Sep 2019 10:22:40 +0100
Date:   Sun, 22 Sep 2019 10:22:38 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Sebastian Priebe <sebastian.priebe@de.sii.group>
Subject: Re: [PATCH nftables 1/3] src, include: add upstream linenoise source.
Message-ID: <20190922092237.GC28617@azazel.net>
References: <20190921122100.3740-1-jeremy@azazel.net>
 <20190921122100.3740-2-jeremy@azazel.net>
 <nycvar.YFH.7.76.1909212114010.6443@n3.vanv.qr>
 <20190922070924.uzfjofvga3nufulb@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kVXhAStRUZ/+rrGn"
Content-Disposition: inline
In-Reply-To: <20190922070924.uzfjofvga3nufulb@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--kVXhAStRUZ/+rrGn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-09-22, at 09:09:24 +0200, Pablo Neira Ayuso wrote:
> On Sat, Sep 21, 2019 at 09:19:23PM +0200, Jan Engelhardt wrote:
> >
> > On Saturday 2019-09-21 14:20, Jeremy Sowden wrote:
> >
> > >  https://github.com/antirez/linenoise/
> > >
> > >The upstream repo doesn't contain the infrastructure for building or
> > >installing libraries.  There was a 1.0 release made in 2015, but there
> > >have been a number of bug-fixes committed since.  Therefore, add the
> > >latest upstream source:
> >
> > > src/linenoise.c     | 1201 +++++++++++++++++++++++++++++++++++++++++++
> >
> > That seems like a recipe to end up with stale code. For a distribution,
> > it's static linking worsened by another degree.
> >
> > (https://fedoraproject.org/wiki/Bundled_Libraries?rd=Packaging:Bundled_Libraries)
>
> I thought this is like mini-gmp.c?

That was also my impression.

> Are distributors packaging this as a library?

It turns out that Fedora has packaged an old fork of it, which is also
available in EPEL, and I missed it.  Apologies.  There's nothing in
Debian or Ubuntu.

How about adding an `AC_CHECK_LIB([linenoise], ...)` check and falling
back to the bundled copy?

J.

--kVXhAStRUZ/+rrGn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl2HPVQACgkQ0Z7UzfnX
9sPIOBAAxr9HFzPakI9IkokSYz33uP2e1IAt324vOhKUxh0EJZLsdZG6aj7/cDMT
o3vGc4n69x8eL7wzye6Xa1SM2WwdcJVnpvIWv6JLEEaRXFczcHGo0kylDfKbuvHL
/dNeytwF2GOhfTc4+WUzaB6ZQCTye1jU+5uHITUf9CI2bqLhZtrs/K1oRo2Ux0jA
ZQPiTSIqXLdtGoR6g0aZpPBAtEiyCXwl+95mhBmLUluy5GF+gvlx6L4wm3F5yuOK
t/l0axGAUdb3+bXSOx5NbhRJ+QPSUvYhoI5FEe2/4H8PJddMsG3xWA+rbSKFiJlv
hMBCBX5Dx/U6v/YEC02tw0446HwtHHwD0Qsnnz8CUFA9VL2zyBvuHxkrGaUap/n7
N8cCnzOrfdW54etQeraF9tixJ3abHU14HYQx3HIEM14cfzUdXCLo0239DdSfKkjM
J8rbXrRMJLKUFQVyaco9vmBtm29bOsNtyyBKZcmCivoudt59T+JeJHCXYpKIvXqF
AiKlWF7vEO7pHR7mSIDmm9thgueIT3s1uINMdfAOAVHhgmiYEPsUpBJkwP7kQFDg
O81QJSRe5FlmbTooX2Mx4bDi9cxLymXkJaGo0Gr8UJ3fmIkYrGidVrYD6hjXctNi
oM7Grxqd00uG3ENg/CEP+JfaigwHXGpZWg1wQm73UZrU2gAIQss=
=4aj7
-----END PGP SIGNATURE-----

--kVXhAStRUZ/+rrGn--
