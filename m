Return-Path: <SRS0=u4e5=WH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4A9AC433FF
	for <netfilter-devel@archiver.kernel.org>; Sun, 11 Aug 2019 12:42:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 445ED208C2
	for <netfilter-devel@archiver.kernel.org>; Sun, 11 Aug 2019 12:42:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="ROdp/ymL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbfHKMmv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 11 Aug 2019 08:42:51 -0400
Received: from kadath.azazel.net ([81.187.231.250]:55062 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbfHKMmv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Aug 2019 08:42:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=422uhGJWX660KB2C5F8fQ78dSJ76qTtj4kDc1CWxY8I=; b=ROdp/ymLYrQgfQTCHVODg4UmDe
        ptGQwQD4coW2ZQZyVDpHewqn8yB0bunH58j/hQ0bjCNjCLSX4yJRoRvJ+yEGsoQGsCX2qJKZussT2
        h7B6+3uAXKy3JqsDxS9BalW+oRE9BHYd3apC53CqCHRst9Gi18ESBiCbu57DSkLs72LRCbOPVGTwv
        BOKnavvdGEisY+POEgNtxr7+zMhGZQaNXY3elgnJqEDEpkv0wobKnN3SQR73NVgVbC3+cefCulZCO
        49aU/dtcsYuHJ6CbpT1YR+ekZmBTuRuVgoljN09mreEjfpxmgcz0M91m74hB6XaGjWWkPjYJ0DV4Y
        AIi3CpbA==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:5ec5:d4ff:fe95:cee6] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1hwnBP-0001Hj-7u; Sun, 11 Aug 2019 13:42:47 +0100
Date:   Sun, 11 Aug 2019 13:42:46 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Franta =?utf-8?Q?Hanzl=C3=ADk?= <franta@hanzlici.cz>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: xtables addons build on 5.2.6 ends with error: 'struct
 shash_desc' has no member named 'flags'
Message-ID: <20190811124245.GD4299@azazel.net>
References: <20190811113826.5e594d8f@franta.hanzlici.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3Gf/FFewwPeBMqCJ"
Content-Disposition: inline
In-Reply-To: <20190811113826.5e594d8f@franta.hanzlici.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:5ec5:d4ff:fe95:cee6
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--3Gf/FFewwPeBMqCJ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-08-11, at 11:40:20 +0200, Franta Hanzl=C3=ADk wrote:
> I'm using xtables-addons-3.3 on Fedora 30 from freshrpms, which is builded
> via akmods. On kernel 5.1.20-300.fc30 it build fine, but on 5.2.6-200.fc30
> it ends with error:
> [...]
>
> I report it as issue against Fedora 30 kernel-5.2.6, but it was
> rejected with "That error is from the add on itself. Fedora does not
> provide support for 3rd party modules."
>
> Know anyone, where problem may be?

According to the xtables-addons configure script, kernels after 5.0 are
not yet supported.  It would appear that the source-code has not yet
been updated to incorporate a couple of kernel API changes (a crypto one
in 5.1, and a netfilter one in 5.2).

J.

--3Gf/FFewwPeBMqCJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl1QDUUACgkQ0Z7UzfnX
9sPzRg//WQblazIE+DrybyAegznzaADPsobMZ/SAYBRDk9nnpw2AUKKvDXPtft2E
MZA0Wz8ETlXNvwTaPQhhWDNEWZYNjl3dW58Lsl+hBoMD67Dk665ovVu/40to3y2M
PEk9NgJAQQcxTTlonTE/2w0x8N04kdB5pxYzLwpCs78AbWJYOFzZisVx5MWWW4+D
t+IblEfZKvwNsoFkm0HslXBnaI7lAlYxWAYwkM3FCoRy+jXhLrG+mhPiRosqU+lR
0gEYRNnOMEJmw4mN4M6drz6HVLpoYvZwHwFvSZ74Mf4xPeQEu4H8r83L0G5ZWbi3
kK7sOgKCzgq9h7GaeYDcaUE2HCcoOy8PHfIBLth4IDfqOclEU7AosbuDBaX8Dnzs
qvtVp6mmqK6CClQWlP+GWMIUs2zpXGaeiG/L9AyvwqUQg0TITo1AQZl/u+j0N3Ud
5nH6shoOPPNPDllN3zl2b5CJS/WCjJZYiXxkd6/vltFe1bn/rHV2ps2E7ohFsTrT
zGXNx8NRddnKBPN6IfymZx30UHeLPN1UG0Q19l4zKIysTybYnTlPZEzCwfSTKCLQ
+L21OGrNkoyaj8KMFLfel5etzHKCHlWJp+CJhUi33wD+Bn8uiYyjZrb3Ln+JISlG
QXq5HeUTZv3mOvbrX5JVUEUhNcU+Vh1tZBj5wYuTRk923N2l7LE=
=k15B
-----END PGP SIGNATURE-----

--3Gf/FFewwPeBMqCJ--
