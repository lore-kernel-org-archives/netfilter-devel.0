Return-Path: <SRS0=76Lg=ZW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10D14C432C0
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Nov 2019 15:24:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC53A2072C
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Nov 2019 15:24:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="VoTt6mpR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbfK3PYb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Nov 2019 10:24:31 -0500
Received: from kadath.azazel.net ([81.187.231.250]:48580 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbfK3PYb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Nov 2019 10:24:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ojHFy0uTyH7l0SgddZvOW8AVEObV9eRETe/THcyxOjU=; b=VoTt6mpRgIj7QZmI9/KWGx7vpv
        eWq1ei0wzNBk0ENiRBTJSNtuIOxjIjYHaHAxO0JkMteLcCCs1D6GTZi6pyHaNgLk8SdRTRqrRFg9+
        zyEZubX0G9rh23LickzhpWfaUK77GgiLxTG5OI0G4C6hS6YFFuSVhgDTwBlq38K/dkK3X1mXNqnFT
        ci3yevS1E7vSuThW2CrTwt+rtD5FRZ80/QzylIdJHypHlpfSXgJh5pTyqT1Gk26L9CFaF6Jh0yEWN
        pW5EpAwfsKbyjwhXKaox3rGuzSXZtvYowbOhi55zLa/kTompllQ7OrT/eL6cbOUS325hMZdmcpqFf
        5iD+iyqg==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1ib4bj-0007s1-HH; Sat, 30 Nov 2019 15:24:27 +0000
Date:   Sat, 30 Nov 2019 15:24:36 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     "Thomas B. Clark" <kernel@clark.bz>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: geoip doesn't work with ipv6
Message-ID: <20191130152436.GA133447@azazel.net>
References: <3971b408-51e6-d90e-f291-7a43e46e84c1@ferree-clark.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <3971b408-51e6-d90e-f291-7a43e46e84c1@ferree-clark.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-08-11, at 05:52:16 -0700, Thomas B. Clark wrote:
> I have tried exhaustively to get xt_geoip to match ipv6 addresses, and
> it doesn't.
>
> I believe my configuration is correct, and that the geoip databases
> are set up correctly.=C2=A0 Matching correctly works on ipv4 with an
> equivalent iptables.

There is an endianness mismatch between the ranges in the GeoIP DB and
the addresses when they are compared by xt_geoip.  I will submit a fix.

J.

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl3iia0ACgkQ0Z7UzfnX
9sMwjg//Q8iXtFOhRINysWZIxgZwIK+lbtwI9dNbg/WnLW8i3tn1W35OEbevsWmq
/kdhIMiei7NyDdlSzuD47g6bOtRoiqtdOKAxuM6W4rTnLoklrler8E6F3npc8mlY
ZvO33yMyPcPqpFjutmYXfyqK/XWrNDgtWkGcCbcoEoy18r9Ka2By//bnwu3V+tGJ
hetw6DlQZY+pKbj3g+/Fa+N5fEF0/IsAUntIDRxOlb+rjf+hUAqUgET83e/39479
ViZOkgQW4y4IZs++y/tBeg2XeFnoBWH+7Uh99pU1Y5QGhs5NV7UVfCWSxS3Vf1AB
Uyrt5OS8z8jWWSSY/bWCVQ9STqk7rxuF/okL4lR7hJ79WL6TUZaK49AUbA/ogFVY
7SvMfuLnt5AYhmB9i963db+ZgahxK9Yk0ZFvBBuduz7iGLLdbVzOE10XLVCtMEj+
Gq1TXj/PEDcHgGfGN73FUziktyG7Fs0OxOun8ZJBBuALeX7HYIRpA+ZclMTDXSfJ
d1+cZ8Z6LCW/9PZYjrxxFhCjhwdBh+qAyyd6tfmEaOe5/RPOdGir8WWst2+aH4tg
AWBaXgK4MJVm/9p/Eykt2Kc3j53J5DvnluxEDJIYq2UpTzodjsXZ/UFVNfW7DXVS
tfHqQso4h60W2v+Mdefm/AgsbHIbPsJJIK62IzawbjzG2r1WvXo=
=lqFb
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
