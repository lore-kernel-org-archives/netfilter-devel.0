Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1CB1C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  8 Jan 2022 17:05:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbiAHRFl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 8 Jan 2022 12:05:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiAHRFl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Jan 2022 12:05:41 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FAFC06173F
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Jan 2022 09:05:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=taWMa41y9WTKVy5/uF66FIbyPfPdo0aU3iW/rmARjfc=; b=QKqE5om8cm0b4yAn3fK6cEU3fA
        dEgeschLUc8CDJp+LoHcxD5lLXYEz46m010Xbu4X4G5T8wdvaHhyyJcetRHJ6BhTE7N6OW5CGbR1D
        RT1pOnvx1YBsWWdFOPrLgGce3jyEzyRO2WvD/vocXPdk6v3HB2X981rFurQgqLSFJCNoCvvJ1qlTj
        i0ZFRr4mm9olFsbDid0eMb1mRQwOpVj3p3K6bPsXqxX3SxIKkrdIbBl5jjPGChPeVeP1ME+gTQrHi
        zACvO9ED5daAkAUrmDz0ODmAd5I8p3IQmqtLcJqeaqkN/YQKdMQjiBnDQrehnQdGvjHRvsqVusMau
        EV6YB3jg==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1n6F9u-001Is3-3r; Sat, 08 Jan 2022 17:05:38 +0000
Date:   Sat, 8 Jan 2022 17:05:37 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [ulogd2 PATCH 03/10] build: use pkg-config or upstream M4 for
 mysql
Message-ID: <YdnEYem+9arx088i@azazel.net>
References: <20220106210937.1676554-1-jeremy@azazel.net>
 <20220106210937.1676554-4-jeremy@azazel.net>
 <q6p24q-47r9-p184-69s7-165p7264o123@vanv.qr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4tpM/atE8TB0eNFJ"
Content-Disposition: inline
In-Reply-To: <q6p24q-47r9-p184-69s7-165p7264o123@vanv.qr>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--4tpM/atE8TB0eNFJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2022-01-06, at 23:15:31 +0100, Jan Engelhardt wrote:
> On Thursday 2022-01-06 22:09, Jeremy Sowden wrote:
>
> >Recent versions of mariadb and mysql have supported pkg-config.
>
> (This made me read up on Stackexchange about exact rules for present
> perfect, only to find it is not neatly delineated.) IMO better to
> just use present. They (still) support pkg-config.

Agreed.

> >+  dnl Recent versions of MySQL and MariaDB have included pkg-config support.
> >+  dnl Older versions have included an mysql.m4 file which provides macros to
>
> "had included", as I don't see that m4 file anymore on my (mariadb) systems.
> (There are a few mysql-related m4 files in autoconf-archive,
> but that's not the same package as mysql/mariadb, I suppose.)

It's still present in the libmariadb-dev 10.6 package in Debian
Unstable.

> >+    dnl The [MYSQL_CLIENT] macro calls [_MYSQL_CONFIG] to locate mysql_config.
> >+
> >+    _MYSQL_CONFIG
>
> One caveat of m4 macros is that they may be left unexpanded if not
> found, and it is up to the tarball producer to ensure the m4 macro is
> expanded.  Over the years, I built the opinion that this is not always
> a nice experience to have.
>
> I would do away with _MYSQL_CONFIG and just attempt to run
> `mysql_config` out the blue. sh failing to execute mysql_config, or a
> compiler failing to find mysql.h as part of AC_CHECK_HEADER is a nicer
> experience than _MYSQL_CONFIG being left accidentally unexpanded.

I'll use `m4_ifdef` to add a fall-back.

J.

--4tpM/atE8TB0eNFJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmHZxFoACgkQKYasCr3x
BA0/NxAAkvL+5GvfC2aCHCjNfTbrEV4VBEW2NDLeFm1Tzw8+9W7Y0zZfBcNW1M8T
Z7ASiTuTDuWczdXTPTX4NLv78bcISVFM35wP81MNJmrdXurJn9McrG7Q5UYYie8e
l2RwIQzdvoi/UOpyfhKASlVWyjZZ/3vsNp8cLpGcylYQ8urt/KIyP7uTMQyLshCT
HcsAVr+lE6Vg+yJwO3GqVQdt55py+vwPQyQ/ekV72QQPSzMcTwhyjhD+eOBJE7lV
7vucQR/dbEWWfMrjSSrbudstSHeSQPw+xGa9SWcpH9UT089ZCdmglJuNgDQAJX74
wj1G6PticYIeSRmy5tlPjgyTtNE9JZVhZRrpRUXIgi6XmKBKEQQmalXDAE/Q/VRO
n/GF1GxMxk+qOlVgMPlNhHeumtxMZUUddf6MnV53vdEFabB9C6bueFPalgEW2rYC
SeaAdJ7H5NpUESaNQecXsmcNxgPoWChnE2AonRGi23EHkCZx3Fb0s/iTh5/JnADa
5pdA7oLhTnz1Oq7MkD+8MoHCT8LI0BbL976XeLKwzLkUYo0CIK7YbCmnvYI9ZAYc
9KbIWhOnWqNBvEt8b+GKbspwEi6hYhBHizGuBdji1cq6pB2YBLFtNBwC0vRxB5Q3
0jhkJZwO+yM4uMhMI6MAWGPdwd05SoYJQZmdvE8OBbc+UZWHlvk=
=fZ0Q
-----END PGP SIGNATURE-----

--4tpM/atE8TB0eNFJ--
