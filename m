Return-Path: <SRS0=aW9c=VA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B88AC0650E
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 11:37:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 420F8218A3
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 11:37:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="lQ3953iJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfGCLho (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Jul 2019 07:37:44 -0400
Received: from kadath.azazel.net ([81.187.231.250]:41152 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbfGCLhn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 07:37:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=R0oo77Moa/JKiV+iQXUXYCX6uSJ1wU49WTMrKVkZEgA=; b=lQ3953iJ8oK8BiYbraYJUCJlRn
        OhQoRBudiH/xndeyPMB6d6isE455qC8M6UqLMANyRiOK0SCXTc3uRAyMLvuTfz4t+VlLGCUEWVN0t
        nac1tNHHhJuz7mOss2ypCXWQpX7WW05O2q0x3a02D8YT/wW/4SCDGZDrzf1PX6/odb8VK1u0I/42q
        knnuDN+ELTLo+e9o5DVRCBDPIUi1TUBUwkayjhbxpDST03bpXcAj8g27LYuAz3549Bnxk3cgwldY6
        S9xD6t/FaxvaLA4txByk4uNQ0n7mLTjEqhT3/Ez8kLgOb3pJlQF+Iz/ZqBMuvj5nfXoWneOrN3LbA
        brHiCAMg==;
Received: from kadath.azazel.net ([2001:8b0:135f:bcd1:e2cb:4eff:fedf:e608] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <jeremy@azazel.net>)
        id 1hida1-0005l0-LV; Wed, 03 Jul 2019 12:37:41 +0100
Date:   Wed, 3 Jul 2019 12:37:40 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Stefan Laufmann <stefan.laufmann@emlix.com>
Subject: Re: [PATCH] Added extern "C" declarations to header-files.
Message-ID: <20190703113740.3goijkyu342k3djp@azazel.net>
References: <20190703111806.qtygttpa34dmfghp@breakpoint.cc>
 <20190703112538.2506-1-jeremy@azazel.net>
 <20190703113535.t2e7m2kwpufqiomw@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rr7usock5s652ocl"
Content-Disposition: inline
In-Reply-To: <20190703113535.t2e7m2kwpufqiomw@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e2cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--rr7usock5s652ocl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-07-03, at 13:35:35 +0200, Pablo Neira Ayuso wrote:
> On Wed, Jul 03, 2019 at 12:25:38PM +0100, Jeremy Sowden wrote:
> > Declare functions with extern "C" for inclusion in C++.
>
> Applied, thanks.
>
> Please, next time specify [PATCH libnetfilter_log] so we know what
> tree this patch is going to :-)

Cheers.  Will do. :)

J.

--rr7usock5s652ocl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl0ck3wACgkQ0Z7UzfnX
9sOIhQ/+PYanHEsFJN83T9Q1mwHBv2tTf6u+Zb4ZfOuYmylu6hBKLeVn/pDXVyu+
bP5y8Ssxsj6175priQyQzoUKz+K08W1bN6utEEl91lHVDcc3az8oPfCzhZ17R2fy
mgRlJzE5jhg5Lvv19Tn12BYRN5aKiQMZelrZZfXWmTNIQ0k9iO9doI1hmrXbOdw0
b5SGFogeFzzLwgmi5nv7pGFklfcjG6HUwgHXKZCyXtZyuCsIIrG5ZhJ3gcZXAMsL
WWb8mUn//LZJt+B6rJoz5dmra9aSpaqLYmfvdCq1T950TVm+fxl4aAFcs0zi3BOX
hhU+FP+88zM86IGP2rZtdqnj1lL4c/7tQ8HWRnU1QsqKe67f3a5fKGXGKICTXvgs
/gwNE79F9LztjX08lzFDInBOaSexCcRdlCx2x5JxhyLsU1EencEm3UVtgmAxtMpg
H6Qegoicv8byyQF0yR0kGcaA/KaBuv1FjBOKSRtNDKyHg8OwTk6fuTAy6djJIqNX
tJmb9qI9xVpQcSyE1ZqnkcYTYSGItiC4X76wj5nHRR5vDxgHJdf7jz1cRbkF6Kzk
KTvyLklwkYO1Q07KKQSKkh5SpqYDaC76KdJUaZTFo131opsEkoiMKU+f/Agjs7I6
GNUsHedBUb535NqzzWwO6qa8lCZe0WM7hmeTXhSh2/MtMeLRi/E=
=sd2j
-----END PGP SIGNATURE-----

--rr7usock5s652ocl--
