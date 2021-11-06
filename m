Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6675C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 14:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89E7960F9D
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 14:13:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbhKFOQd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 10:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbhKFOQd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 10:16:33 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDEBC061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 07:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ybVUpTOEimRbGi0r2y+/yCYBqAdnIxyDWLtyjX3N5cI=; b=tYY9hNfY5wdaUsCPHabruGx1Go
        25cj0rVrxI/H46sW75Nl31VUkNWbiaJqOXImfHUwIMdJUxLgFqw0tCvR6FCgyrc81hc2XI9FW7n0y
        Z5Ha7JmpMH+kqcH40lsbPhKb4TlSsRDUClNzZiJixxMeBfGc2c2MbdnnUezTZyiMWhwb+9d78iqdm
        JGY3Gnw1f9EgGoUXgPhcmNiQLgH7NbDe7NqiG2pUqCyyFwkGzruRo216SDzRgqw4Zglo7z0wz+Mf6
        KCg1RDnIpfSpn/M54nLLgsOPZEclZtSBDE8oN/3RKTLzPuDf45IDbX/fgwaigpQTlnk/6OhDdNDWB
        jb2hwptw==;
Received: from ec2-18-200-185-153.eu-west-1.compute.amazonaws.com ([18.200.185.153] helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjMS3-004ja3-U5; Sat, 06 Nov 2021 14:13:48 +0000
Date:   Sat, 6 Nov 2021 14:13:43 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [ulogd2 PATCH 15/26] input: UNIXSOCK: prevent unaligned pointer
 access.
Message-ID: <YYaNl0X8whnnZuqI@azazel.net>
References: <20211030164432.1140896-1-jeremy@azazel.net>
 <20211030164432.1140896-16-jeremy@azazel.net>
 <5op325n6-6077-p0n2-r33o-npr9905n47s3@vanv.qr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="1cmxNxUMxEsIsR/W"
Content-Disposition: inline
In-Reply-To: <5op325n6-6077-p0n2-r33o-npr9905n47s3@vanv.qr>
X-SA-Exim-Connect-IP: 18.200.185.153
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--1cmxNxUMxEsIsR/W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-10-30, at 19:42:25 +0200, Jan Engelhardt wrote:
> On Saturday 2021-10-30 18:44, Jeremy Sowden wrote:
> >`struct ulogd_unixsock_packet_t` is packed, so taking the address of its
> >`struct iphdr payload` member may yield an unaligned pointer value.
>
> That may not be a problem. Dereferencing through a pointer to
> a packed struct generates very pessimistic code even when there is no
> padding internally:

Having taken another look at this, I've adopted different approach to
pacify the compiler: the pointer is only actually dereferenced to read
one member (`ip->version`), so I shall replace the local pointer
variable with an `ip_version` variable instead.

J.

--1cmxNxUMxEsIsR/W
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmGGjZcACgkQKYasCr3x
BA1guhAAyuF/Fs7cH4/Hq8qbIz/rDuc/0PedxFnbTU+31qBuFQaXx113VSNdbvp6
V5dU5+fXV8ShTE397/H5KAfqEsDX5YC7hdPCU53aG/BpAKWdCZbxNyaWuVuiUH8j
+mNcEDOlWpRaiRanTB05fSqsRhhOuWkRM72F9S8GcwXErbP7iCmqTdb2/Eh2zRfy
+hZOGodfxmtRfqris32uph0g9TXXodJi9ePGAZuUAADirb9zwU9ODDZLtaLlCd/I
v+3sERU9zBdH1ZPllfGexah2GWYIZIE5UHFnYrD7w2OU1TuwQqZkeIIznQ5AGVw/
TogT84jv3FU13h0ldI6f6E/y5/SeWFzNIY7LZntehJq0Oug7wTHB41XPk+yw2jY4
jF0+n87zMd9nrMwLzlzwFbmEvnIHeOFlwNL5BVKZf4pRg85CLdT2nvRbXd5mjBUX
MjENkiS5IZ8gV7U2iPlt2Y120JXh3m3nXO1K6ABDL0jGRx0UujKhrE2+Oo1tXE0i
XTLhJffx/OGgsW0ZEhvmu5yHDTti9bRhFWY6/FsVjGbvG6eeECpsGI1hM0MMrF71
kIckLgx8FhL3gcMcc+M75OubyoG54LXWtanKimfFkHaIWOUTFGuKEaMfO+pGYh2x
e0uiQwX+RdJKyQZ0WXqh1OZyUT+CNQoEYpTmJG3d0Xvp3TUggzs=
=bLu7
-----END PGP SIGNATURE-----

--1cmxNxUMxEsIsR/W--
