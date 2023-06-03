Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CC1FC7EE24
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Jun 2023 10:08:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjFCKI3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 3 Jun 2023 06:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjFCKI2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 3 Jun 2023 06:08:28 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3D31B3
        for <netfilter-devel@vger.kernel.org>; Sat,  3 Jun 2023 03:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ORK5DIGRxIvkyF9gGLm6fa670fiC254KjbHVE3rbquc=; b=kDAfgoj+42+b7cOAwA51QgVMmv
        PIrMSaaGtbz90CANp89OzwKLHDUu6ZcEmbJ3damZcyt1UjmSBsLPN33BALJDLdCys0OlZbfwy+Wa6
        ixWA+ppjXmJaaWjvCtd6uHSmRQwmKZ8JbdH3Dk+PqYpBtV0T+EBwkK7jnA8TcdDTG/Pf7oejFcBq+
        2OrDGNQfxgjVLXQjiRIjqwLbzwPSGXOL1HkyQkoHTwXfAojaknp/G6lJYwUNdzNs11BbfMRRm4YCN
        lu9/x8ktx5i4GAO6Ibdvq7cUNVI9C4lFb5jG7uRdL1JzBm3IjPyZ5Xjpdhc4xXoPSp/CT3yyHNrrv
        QdFcdjaw==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
        by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q5OBM-00EjRP-1W; Sat, 03 Jun 2023 11:08:24 +0100
Date:   Sat, 3 Jun 2023 11:08:22 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nftables v2] exthdr: add boolean DCCP option matching
Message-ID: <20230603100822.GF187342@celephais.dreamlands>
References: <20230411204534.14871-1-jeremy@azazel.net>
 <ZHp5T9pWQ3u2Fugg@calendula>
 <ZHp5qAmgHKHQ5Dqr@calendula>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="HDmVGrci94VH+FgD"
Content-Disposition: inline
In-Reply-To: <ZHp5qAmgHKHQ5Dqr@calendula>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--HDmVGrci94VH+FgD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-06-03, at 01:22:16 +0200, Pablo Neira Ayuso wrote:
> On Sat, Jun 03, 2023 at 01:20:50AM +0200, Pablo Neira Ayuso wrote:
> > On Tue, Apr 11, 2023 at 09:45:34PM +0100, Jeremy Sowden wrote:
> > > Iptables supports the matching of DCCP packets based on the presence
> > > or absence of DCCP options.  Extend exthdr expressions to add this
> > > functionality to nftables.
> >=20
> > Applied, thanks.
> >=20
> > Not related to this patch: there is 'ip options' and 'tcp option',
> > probably enhance parser to allow for 'ip option' to address this
> > inconsistency in the syntax?
>=20
> BTW, may I add to this file:
>=20
> diff --git a/src/dccpopt.c b/src/dccpopt.c
> new file mode 100644
> index 000000000000..3a2eb9524a20
> --- /dev/null
> +++ b/src/dccpopt.c
>=20
> /*
>  * This program is free software; you can redistribute it and/or modify
>  * it under the terms of the GNU General Public License version 2 (or any
>  * later) as published by the Free Software Foundation.
>  */
>=20
> Thanks.

Absolutely.

J.

--HDmVGrci94VH+FgD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmR7EQ4ACgkQKYasCr3x
BA0XnRAA0UkIVZJFodbJ0SfTzxVkgqA9d7HSgT+5xy7ip1o3+XzvOdhas0D7Tj55
Tf0Jh2EJDZ1SdEv5MintRva9yLv2IO24wkL4pElgWLpfd8V2rwq61HJaMuegFeAQ
tzNz8es/R3k5D07WxOIl6F02ch4D7dN9+4TCBuAKolrjPaBWD9BF4z0XOGSzClHY
iUlYtYJvHPNrjRIV9OGXZQ2leFxPoRq6YzggUmdBLfxP0sdupamPe9wbpfTSGXs7
nKt09XxHF2YgfZcdosOLPsxlmVIbyhHkX5qsyUPw4DaqSHYskaN4lw5z+2Gs4cqj
QvEpehI9CDLst1xpQymrIe56psyJmOefFsxxmdeHrukD26nD8F3Nvf/FzH1uWV9S
Sbs+y2zXD29cJSAIQ7nTdzmis2CusUbYQ42hzvrD23hrvSNA10GemnHShngc0tnG
6yf6p/BvGqYL/FuCAhOXDsXr5m+sYFmIrycPzZGJssZ1PmtIQP583wkJpNJ65RJv
R5vBSVwSWd0VxCx2jBUY8k0obsW+0l66XAMQFsJPxHl726+alqq53dBLBhgTPDs2
lecXh+0srubhHghJIuDi0TVRZ0/nM5ji9hGcVpFsvxLAnLgz4WrcKOgcXCxCDbbo
pO75JmZLKV3WAy8DFDnTE5V/7LbEGYK2peDbzWHFbCDCdMBaXho=
=IzzT
-----END PGP SIGNATURE-----

--HDmVGrci94VH+FgD--
