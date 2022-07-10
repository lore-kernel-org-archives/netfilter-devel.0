Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D8CFC433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 10 Jul 2022 15:09:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiGJPJL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 10 Jul 2022 11:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGJPJL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Jul 2022 11:09:11 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B47FA197
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Jul 2022 08:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GZBtgK5TbjlUF+Acj5ulok9ifxGUaRxGkUX4qFxZjtE=; b=McY8Y4ZkyYfwrgdcRKfjXqjhIM
        f5BgRzG5AUn/G/23/iTT43Z23ClZZdeVxmAoOBazSy3jHiVAIjS+1yPGEo6XYxueZawYRQikWU95O
        kudmpP2DwhRApZ2SGYcZZU/wseb4okuGC+JD3+iQVq0mZw33u+Wvx6QTGOQmAhWp0mMr0Lq9aBjvs
        iQaRHTjbin0M40GFi0+w+99K7uP/sdsH7yUekto/5GYPju02c2UhzAOISl0rj3sXbxhwzHudH9IxE
        tcN30i1s/cymv4ghFH9xmJcqDZjr5qXUhdGX4DhU45TsrgAZrOM7idVj0ocdnv2X7oa+Yx1qAls6F
        MYFjppZQ==;
Received: from [2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oAYYU-0002qo-8G; Sun, 10 Jul 2022 16:09:06 +0100
Date:   Sun, 10 Jul 2022 16:09:05 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Lupe Christoph <lupe@lupe-christoph.de>
Cc:     netfilter-devel@vger.kernel.org, Robert Kirmayer <kiri@kiri.de>
Subject: Re: FTBS on Debian  Bullseye with xtables-addons-dkms 3.13-1 and
 kernel 5.10.0-16-amd64
Message-ID: <YsrrkeKKS1wE4jk3@azazel.net>
References: <Ysrkz8OHUK8TbPCs@lupe-christoph.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="+PhPnretYpprmFzc"
Content-Disposition: inline
In-Reply-To: <Ysrkz8OHUK8TbPCs@lupe-christoph.de>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--+PhPnretYpprmFzc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2022-07-10, at 16:40:15 +0200, Lupe Christoph wrote:
> In case you're not already aware of this, please have a look at
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1014680

I am working on it.

J.

--+PhPnretYpprmFzc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmLK65EACgkQKYasCr3x
BA1qLxAAk1XE5b6a7m8PZe3mBvatJq52pdQXdYPypqBUfs25iR8EkOJuBaJtSviz
QON1vGlyjMMA5d+RkvUGt2vJGxl7mWtqeAXGTsikK6X/T2MuPTU25yGOzaFxIrVo
izUOXybbZPpLjXDyjExnMpsz3ug+8uirB0yQKYK1RCumYOm9mWOtcu3vkhxDlIQV
X33d87eLYpL6fCwuDzc5BqqCusuzWfIcjV4Uk3Etoy5g9kiFKlJ3zKZzfbbC8BUk
xDmrImR1mjUW2saTahPCg4o5mBmitLuW6nZSijCY0Wl2sTstxPKhhNygdK60ngeg
GEfyr165DzHoHnBdM10WKByG/LzOHd6EwZ9NVtm44Ed3wnN4I9zMMSR6X1Tx722s
1DY2iXA2xzxjUA45lA3h4Z6zwNwq5aFYNazX/4Bb9Y9fjkaa+KWOR0mjhjAPl8QU
/NQYgtA4iIgRDSh1E515vRxNbAu471s0mCXq0TWWlRhVhD+p4tYFcyoyoIrLi4Ik
0KIJb54QZ0BePtZ4DjM4jR+vY/kfpPYg7ZQG7dxtfT4Rw0Z5fXRD6vitGDqoTelc
wwXSHKjz6OFQNOPbhuii5Nvn9Os0ecojF4mzUxbxzqqMIicANUDhzHY1gBskk2bp
OltBCc5665wRh8BFYso12IR1isq38ck6E3zmBeuM/xafRPgdgYs=
=/dFQ
-----END PGP SIGNATURE-----

--+PhPnretYpprmFzc--
