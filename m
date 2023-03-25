Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48914C6FD1C
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Mar 2023 11:10:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbjCYLK0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 25 Mar 2023 07:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbjCYLKZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Mar 2023 07:10:25 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E24CDF6
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Mar 2023 04:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7CNQLfPek5ms0Dr8yYOMXLOtSlEUY79lGo7I23gzS7k=; b=HzaJWB30q5+59nolXJIncJ4iU1
        dy3aNa+RizQ0jBfS1CzKOgOj5vetJrGqyy+sK7jMyY+QRie+WrDhBz+LgR4l5SOTv3iPXu9Oz30jv
        kREhp5UqvNPe9X9InD1A67TfGR/lhXdf1sWDxM52Y+IpV+Ul+00C61BQgeW9VlPeDKjOCFrleUoju
        j/9wx2lIj6klHv0oSUjqRBMfkJCv3LEuom5yS0plcS553Hf5TSvQC6Xx2OSTs2I716tqPlDeS7csb
        P74qG7afyfzQ3j1oZ4i1lH4gkzKKw3itFSUPkfgDjkIgL8wPg0XxpoKUF1dHy+9AelJuGCPS7P4xn
        3b5p+lPg==;
Received: from [2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] (helo=celephais.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pg1ms-00560V-Tt; Sat, 25 Mar 2023 11:10:19 +0000
Date:   Sat, 25 Mar 2023 11:10:17 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nftables 8/8] test: py: add tests for shifted nat
 port-ranges
Message-ID: <20230325111017.GG80565@celephais.dreamlands>
References: <20230305101418.2233910-1-jeremy@azazel.net>
 <20230305101418.2233910-9-jeremy@azazel.net>
 <20230324225904.GB17250@breakpoint.cc>
 <ZB7Og6wos1oyDiug@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="0BAQjfyKU+5bjAH1"
Content-Disposition: inline
In-Reply-To: <ZB7Og6wos1oyDiug@orbyte.nwl.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--0BAQjfyKU+5bjAH1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2023-03-25, at 11:35:47 +0100, Phil Sutter wrote:
> On Fri, Mar 24, 2023 at 11:59:04PM +0100, Florian Westphal wrote:
> > Jeremy Sowden <jeremy@azazel.net> wrote:
> > > +ip daddr 10.0.0.1 tcp dport 55900-55910 dnat ip to 192.168.127.1:5900-5910/55900;ok
> > > +ip6 daddr 10::1 tcp dport 55900-55910 dnat ip6 to [::c0:a8:7f:1]:5900-5910/55900;ok
> >
> > This syntax is horrible (yes, I know, xtables fault).
> >
> > Do you think this series could be changed to grab the offset register from the
> > left edge of the range rather than requiring the user to specify it a
> > second time?  Something like:
> >
> > ip daddr 10.0.0.1 tcp dport 55900-55910 dnat ip to 192.168.127.1:5900-5910
> >
> > I'm open to other suggestions of course.
>
> Initially, a map came to mind. Something like:
>
> | dnat to : tcp dport map { 1000-2000 : 5000-6000 }
>
> To my surprise, nft accepts the syntax (listing is broken, though). But
> IIUC, it means "return 5000-6000 for any port in [1000;2000]" and dnat
> does round-robin?

That does ring a bell.  IIRC, when I initially looked into this, I did
have a look at maps to see if they might already offer analogous func-
tionality.

> At least it's not what one would expect. Maybe one could control the
> lookup behaviour somehow via a flag?

Thanks for the suggestion.

J.

--0BAQjfyKU+5bjAH1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmQe1pMACgkQKYasCr3x
BA1rcxAAw8emF17Gv5SKkOxVMB4YM1NoeDcNko5peKpGRGxyLSCBGoLSRS0XpJ0d
yOF2TngJl5mq5ltP0qOY4tFNXkIZ2wmh6pCitPYiL3XEWwBviH2VpYiFqFpcCSsF
zk9y5RDorZKc7peon3XHpBKuSkBRA+bf6PXtZo8CO6rk9CtY1Fn4yTItKWFwLNU9
EZXtdS3CKgFeKm3+atGSxH65tu/rifvlNSwAB21ZptEyFQO4Ka80z0+ks24u8Z7K
ZbysMUz6qXXHnKeNPF1Rtsz7nq7UMxFvMxY8pdqJUjkDRvMy+6Tz3LuqY18JvulK
X4v7D7y+t2n7TIIFmtZWaSeH51kHE7JottFhKQG8s9+7RKu1ZGfzew6JkxzCPuOM
kMpun262Fm+0aG+zrqVgqmsnDP49+PGXBoHU06V0LbPqmvU4Wy/sTNhwcDx1DXDN
hn59QmZSb+MXpwEpKyN0k4GH9haCq53rt0YXm0iE1WvuMO37ba2+HTVRhnNXLm04
XK/sNKZCZsoxdBDyTbZyAaO1P1u2wO4zYb8imMYCPQCmxdVkcmnjl+ZpkkPsbc49
Sx1AmAk3E1/+F4WDiGlAhp9fpBmTcNh9ZQJt7iMRbYZoHKgZD3HWY+7YZjjyvC7s
K173Vbuyd/kG5Jox8c2NXqvaRRDHaCWD5MiYlDHxRQBZdBgEa5M=
=xcFH
-----END PGP SIGNATURE-----

--0BAQjfyKU+5bjAH1--
