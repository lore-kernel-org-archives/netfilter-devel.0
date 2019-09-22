Return-Path: <SRS0=d85k=XR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_SBL,URIBL_SBL_A,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C28EC3A5A2
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Sep 2019 22:29:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D981D20882
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Sep 2019 22:29:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="kpsR9c4y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729447AbfIVW3D (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Sep 2019 18:29:03 -0400
Received: from kadath.azazel.net ([81.187.231.250]:47420 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbfIVW3C (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Sep 2019 18:29:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/5ncIhb3QY48zU2wxbB3SP7FQ+l3idl0mEiBj/FtlFU=; b=kpsR9c4yCpHpoOBCecGHAkIyW0
        5oGuiMG6ev9cqGCJLrn8j6YdTBqPDdKUeDCTd/MLK2H1JB3bUTXrx8VyjZ0J86niNthyv+wh1khGB
        7NIjIUDV5fFdw4GQOa3PzgIGuSS5J8sgGlLnHn1l5IW1Zf/4R/i27qOS7wo1XkS471rFfaer7vh3l
        YQAf+PDTj01p35REyMbjS2EI8lqUxNz2GbDucvS4ZL+PxnHq+1MU3E6hSyDZ3/TK5HWf7AR+lOhSE
        lNOvKayJEp1O4MyO8VS9VdEYmNaleNOINWvQXxIdz3yMZ4o5QlAMWHU7N/yHczdRalNoGpx6O4uIy
        kjgohK1g==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iCALj-0000rR-3h; Sun, 22 Sep 2019 23:28:59 +0100
Date:   Sun, 22 Sep 2019 23:28:57 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Sebastian Priebe <sebastian.priebe@de.sii.group>
Subject: Re: [PATCH nftables 1/3] src, include: add upstream linenoise source.
Message-ID: <20190922222857.GD28617@azazel.net>
References: <20190921122100.3740-1-jeremy@azazel.net>
 <20190921122100.3740-2-jeremy@azazel.net>
 <nycvar.YFH.7.76.1909212114010.6443@n3.vanv.qr>
 <20190922070924.uzfjofvga3nufulb@salvia>
 <20190922092237.GC28617@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="EY/WZ/HvNxOox07X"
Content-Disposition: inline
In-Reply-To: <20190922092237.GC28617@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--EY/WZ/HvNxOox07X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-09-22, at 10:22:37 +0100, Jeremy Sowden wrote:
> On 2019-09-22, at 09:09:24 +0200, Pablo Neira Ayuso wrote:
> > On Sat, Sep 21, 2019 at 09:19:23PM +0200, Jan Engelhardt wrote:
> > > On Saturday 2019-09-21 14:20, Jeremy Sowden wrote:
> > >
> > > >  https://github.com/antirez/linenoise/
> > > >
> > > >The upstream repo doesn't contain the infrastructure for building
> > > >or installing libraries.  There was a 1.0 release made in 2015,
> > > >but there have been a number of bug-fixes committed since.
> > > >Therefore, add the latest upstream source:
> > >
> > > > src/linenoise.c     | 1201 +++++++++++++++++++++++++++++++++++++++++++
> > >
> > > That seems like a recipe to end up with stale code. For a
> > > distribution, it's static linking worsened by another degree.
> > >
> > > (https://fedoraproject.org/wiki/Bundled_Libraries?rd=Packaging:Bundled_Libraries)
> >
> > I thought this is like mini-gmp.c?
>
> That was also my impression.

The other thing I forgot to reiterate this morning is that linenoise
support was requested for embedded environments where readline is not an
option.  I don't expect it to be used in general-purpose distro's which
_do_ have readline available.

J.

--EY/WZ/HvNxOox07X
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl2H9ZcACgkQ0Z7UzfnX
9sNsiQ//dhOQrHCndwpnf8PGUyy91+ajXnWTlUBCMgSq8LptyIX0Io14VuAovGt6
fYnYKY13pAkA4WnZTCDbBCmimCYUY1+T7QqSPnoxDM4LJF41hu00d93IvhgmBhmm
A27LXnrZpXU/BK+RmKXrJ/UuddIwbInRkGceU46qI9N2QKuymjYhMpOq5v985ieT
ud1RlVf/dMFCspJNGE/KfMqpzGje7wA2ckzMWfF+67aefRQHiqEl+Of0dJ1rvuDK
E1QiAfyyKHuNRASA+inJ+8qzJbDS0OV3X5W7vBLtDS3bil9lGY1B1j5UMU4NpBNe
kPuwKOkhHws6UBd4WKc8WKsOIkEXM3W3RJp+UOaEQyh6pmMK1Q11KziSwsmpTusl
AFfVfNfnhJvUo+LPg8LYNY44U/WBn3ysDmk7OnDWNgeZ+iHm9gqaUkVTyl2i4NCX
NoI43eYjVuIi3itA2lbfjmxrx3Vmjzqgyx865qzhQayfB5ap4TxM+FvtRHM8LnXQ
8EOcGV6asaGwAS7pwY6rVAYe54OVN8p6M809L7KfBBaHo0HxXZXIAYoUlq3IfceQ
o89zOlrNPeGjeosMddMJxp0CfYYEVVHWpx6BRCqzBCROQ8nNSB4lO14ee+xMrLIy
cdbnRY/g77LpnZSnJ7c1FH+4fB4l9kr1U58j+r24mMQoMDZO6+o=
=faZs
-----END PGP SIGNATURE-----

--EY/WZ/HvNxOox07X--
