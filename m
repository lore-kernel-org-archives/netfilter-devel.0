Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C259DC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 11:06:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AAD4611C4
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 11:06:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbhKFLJK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 07:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhKFLJJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 07:09:09 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8011AC061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 04:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4gsudbzNJtbTCWChhuZkcOItcvYLF32skbbJe9emneE=; b=rIkBlC3/gAv1DTjWbGjjZWw8K5
        IPkVugkdz5mjqQlVJJlu4VquwCZYU0rEA9+OkqgOMEYglVtZsYbAOWiTKPG3KpsTubFs7I2AnwECo
        GWwZnv/mihtjL/VRiJKX1r7EebeZouocGRLPSuMqzZIu09JeIHnhRJ+NFJVKWtGhPxWkOxtdShP+V
        JEhqFV1ngy7ynNBPQcgT8RRVLqpWFdus6dRHplGqdEbKl/iZaGkWUiUqAR7fpM/OBKOdkZe1PlN39
        GSZ90qN17fAqGegdIza7wIyZKKB2lYMehBiwrIVrGjJClOY3mIPFQ+9DIXXNwH+FyqjHO6dq/kD1K
        7YnLV0Fg==;
Received: from ec2-18-200-185-153.eu-west-1.compute.amazonaws.com ([18.200.185.153] helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjJWj-004g7n-Vn; Sat, 06 Nov 2021 11:06:26 +0000
Date:   Sat, 6 Nov 2021 11:06:20 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [ulogd2 PATCH 02/13] gitignore: ignore util/.dirstamp
Message-ID: <YYZhrKBuHYl+qPOi@azazel.net>
References: <20211030160141.1132819-1-jeremy@azazel.net>
 <20211030160141.1132819-3-jeremy@azazel.net>
 <o699p255-rqo-5s10-s3sq-1q8q858646p9@vanv.qr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="JcXNI2t2eQHSkHM0"
Content-Disposition: inline
In-Reply-To: <o699p255-rqo-5s10-s3sq-1q8q858646p9@vanv.qr>
X-SA-Exim-Connect-IP: 18.200.185.153
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--JcXNI2t2eQHSkHM0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-10-30, at 19:05:34 +0200, Jan Engelhardt wrote:
> On Saturday 2021-10-30 18:01, Jeremy Sowden wrote:
> > Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> > ---
> >  .gitignore | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/.gitignore b/.gitignore
> > index 3f218218dfc9..fd2189de5748 100644
> > --- a/.gitignore
> > +++ b/.gitignore
> > @@ -27,3 +27,4 @@ TAGS
> >  /doc/ulogd.*
> >  !/doc/ulogd.sgml
> >  ulogd.conf.5
> > +/util/.dirstamp
>
> .dirstamp should be globally ignored, without a path anchor.

Will update in v2.

> (Best shotgun hypothesis I have that this file is created whenever
> a Makefile.am contains a '/' in some _SOURCES)

Yes, if the `subdir-objects` automake option is defined and there is a
source outside the current source directory (../../utils/db.c,
../util/printpkt.c and ../util/printflow.c, in this case), automake adds
a rule to create .dirstamp in order to make sure that the corresponding
build directory gets created.

J.

--JcXNI2t2eQHSkHM0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmGGYaUACgkQKYasCr3x
BA3f9RAAod51tT1qNj27QJBR5zqQCg64RF8q1LOCQ5Xe0wPuJwskxaJvhgfYzuAo
oQr6Y9zJMW82sRrglhkyJ7PxBQjsS6kLzDD7gWUi97JNAQNXh5+/KbwB3Sy+vBgh
WRoODlQ5fGkWfOpGR1dYxUDuTQ2YM/KijHkIASlzTPJ9/Iam0XsC+lOUYkoCubpD
zvPLhC4XWTHli7vljDLSRHciU250mkyzdmCk61h8tO7SNw25jxRpQF/HgVN5oSX/
rslPzwQjNtXXTaY+TrP1ofZPavgp2l0WdFOtpFUPGk/wLu+b2aTvxYZaXe+rJRGw
4wxVT1KzCG0Rd+G5DbR9lbLjOept+ZGgUifjFjZdO3i96dg2O/FXtl5aIulyYcNM
CnWPaIiKcoqmtrOxizo/ZKAZEsry8VYit0WshxWzDSzhWF67ZL08ckPghvm15xXr
M1eJmhXn/abE4dkzNkjrTahfMbz+ZvJI8KaDZmMjIqBsN6+K+5P7DYA+E2FmFpZ0
xsaeAjlAg7pmPAHrPIhGoXW3hF/EXySn3Th4HGMWFiJqBgVuh/FywHiRMzv3AlMK
xraobEir13ZyFwGjCvtZtWdowaImZvE5eWpxCfcnkEkoyLQxfbpvc30aywwx4m2w
/WuOSHaVuavE4W48ArN+FHDv3uoBttnNBNFu1poP9/i/UoEVIsw=
=ypeQ
-----END PGP SIGNATURE-----

--JcXNI2t2eQHSkHM0--
