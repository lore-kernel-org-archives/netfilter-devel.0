Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0C70C432BE
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 22:19:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D7CF60E90
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 22:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbhH1WT4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 28 Aug 2021 18:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbhH1WTz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 28 Aug 2021 18:19:55 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F5BC061756
        for <netfilter-devel@vger.kernel.org>; Sat, 28 Aug 2021 15:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=a37XLKH6Hi930PC6Nyp9AdAW758fvJm78DLifjG77G8=; b=c/fqOFNZo0liUHmmUi8FLuCKRS
        ZvFDmv0pSBtB86TrvGk5U2CDy4p4GbRcuK4+YTN329osjZpHO6BcZLubGHN/xKA+zDVcaMq9NOMza
        K0jhrsWhkQN0UGHZVHjvNzrTdRUI8TwIWs8Vb3yNprDALYYGStPa4bSCmVfESqYZujiHclf1i1+AA
        hPvIQ94OaoWWVQuUbgHTkhFZ+8dA/eq2S2tAhonN6qKQtZnbBPbKHFs0fZFiUCJ/2KcwpIp9zq1sL
        jI2ISBhr91PKLRwuuAC1zblhb0WjUm2tCCWZS7+Ovz24bo3Zl3+zcFGvMzIZ1Z5KATPLbe2kmCN0h
        UTG/uVXA==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mK6fF-00Fiqr-QL; Sat, 28 Aug 2021 23:19:01 +0100
Date:   Sat, 28 Aug 2021 23:19:00 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_log 0/6] Implementation of some fields
 omitted by `ipulog_get_packet`.
Message-ID: <YSq2VKWMsLvig5Ef@azazel.net>
References: <20210828193824.1288478-1-jeremy@azazel.net>
 <5n2q9rr7-p920-pro6-3nn2-pn5qps91so64@vanv.qr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="E1rqog6t6LSNIBLZ"
Content-Disposition: inline
In-Reply-To: <5n2q9rr7-p920-pro6-3nn2-pn5qps91so64@vanv.qr>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--E1rqog6t6LSNIBLZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-08-28, at 21:53:19 +0200, Jan Engelhardt wrote:
> On Saturday 2021-08-28 21:38, Jeremy Sowden wrote:
> > Jeremy Sowden (6):
> >  Add doxygen directory to .gitignore.
> >  build: remove references to non-existent man-pages.
> >  doc: fix typo's in example.
> >  src: use calloc instead of malloc + memset.
> >  libipulog: use correct index to find attribute in packet.
> >  libipulog: fill in missing packet fields.
>
> Subjects are not full sentences, as such they should never contain
> trailing periods.

The ones above were certainly intended to be full sentences, but I see
that the kernel docuemntation talks about "summary phrases" in subjects,
so I take your point.

J.

--E1rqog6t6LSNIBLZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmEqtkwACgkQKYasCr3x
BA2KjhAApm4mPxOarNq3SDAlQuSk0C/iL1aVlGpoSjjRY2sU1PR43BNuDzTHUfut
AiyRDzx/96YAllIzr9ZxmUITlwoYh1w+L6jG4ECpIlsPC57TKfllQ8TxAhVjPOEV
QxGb2he4w5LXpzCPWNkaMPuE43GbvKLsbCDDvgHd/Zu10c6/T1xx+uC3qtHLshLt
AYp3uQ4vBWbnRwRFRfW7f5l5tVYE043gH5rVJQoJ/QCwRu9oFq8z871zy577ur7y
mfLbAk9YlPKqrX72TFszjsKKMUgDp7jGpjbVzjXLkV2G0e8Gntpm/IAYefpqa89m
DzKGTao6tB5SjgKbnEREA9MGxCm+QS+uUlMaZJxxdXaPQvqZ5gNee/e1Skc0aIaG
D5qh4xBjEUCf8eYO9QWiiQt+ZYQdU9U11tcZoAlOWhqd64qgpSo00iydsN1R6ZAz
MqmBlR+NGuS693F15QVoNDKIqC6UjcrMgYCV+HUo/hFPTfD8SCP5t2IjBebpv+3h
mPv70YtE5s2T0Qa1ezdqAWh9iJtwHkjqp62exgVp9mfbzBPrqbGIyEDlBDPBNRBN
wCoCJLwbS7KegFf/d+x6kVrAE+b8Gm2LX/jg3w0IYJKGnjRGGoOOjB8mMmE9A0GK
dfDuidJo/Bom6oX0GNrXDLk27mkbeXu/vxzet4iQsc+dA3kaYss=
=gZjj
-----END PGP SIGNATURE-----

--E1rqog6t6LSNIBLZ--
