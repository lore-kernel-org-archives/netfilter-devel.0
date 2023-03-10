Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76BE3C64EC4
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Mar 2023 11:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjCJLJD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Mar 2023 06:09:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjCJLJB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Mar 2023 06:09:01 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BB6B754
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Mar 2023 03:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=skcXk0sgDx0xs/JqJTT/X6zmijNmdkvMz4Ttgy+wGuA=; b=HN9FPjPnzojwq9W2LlNnlYmjAy
        OCzqJSwm5gBnG1n5sV/6l6jJc3TlPNgTDhkpeBwEnhqXNDoqJTm7JEuc9U+9Z9APldUQVPeWEjWYc
        7TPL3Gpv/hbSg9IK4rLA7yOiPlR1u3D0YYIynb5djyDBR2fEP4E/A64v4lTUCEaxrp6+SEJZ1sM3M
        OZZ7bA/x2z+z/CuKk6GqGdFWka905tMNQgSk3YJFM9Vn3mGM+YGSw4HwHedszlYBj8mN1BN3M59QT
        a/uuguontW4+QhRHygrZbUOti3WM1F+44Pw94UtCyBNjUEA01VYYy2D3lsXgsnXbd2ar7B6pVwAHZ
        Yka7Cq/Q==;
Received: from [2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] (helo=celephais.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1paacL-0032Oi-F2; Fri, 10 Mar 2023 11:08:57 +0000
Date:   Fri, 10 Mar 2023 11:08:56 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net 0/4] Netfilter fixes for net
Message-ID: <20230310110856.GG226246@celephais.dreamlands>
References: <20230309174655.69816-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="oVbiu2LkYeXiOSOn"
Content-Disposition: inline
In-Reply-To: <20230309174655.69816-1-pablo@netfilter.org>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--oVbiu2LkYeXiOSOn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-03-09, at 18:46:51 +0100, Pablo Neira Ayuso wrote:
> The following patchset contains Netfilter fixes for net:
>=20
> 1) nft_parse_register_load() gets an incorrect datatype size
>    as input, from Jeremy Sowden.
>=20
> 2) incorrect maximum netlink attribute in nft_redir, also
>    from Jeremy.
>=20
> Please, pull these changes from:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Have you actually pushed these changes to nf.git?  Can't see them. :)

J.

--oVbiu2LkYeXiOSOn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmQLD7QACgkQKYasCr3x
BA0gGQ/9FfbY/lY15IGNdsBK4zNnqFvnwWKtE7cPzmoyqJIkhdnUtfQRuYQJ94DE
sOYcXaCLNGJjW4CPTUhOVRN2Z1CbdhEt96heTLkVOLo14PCPPAuQ+UaDTEh4eyHI
fKHiq+vLvkaUxJ03sIhPDq0d2B7wzGFwE3wqualSVljsKpp0iS8fIBEoUBV/mxrh
vX7QwOmSmKLCT+5Ca0grnT8/Q9UGYYXQowwD7EVtDF1gflO5oTOk4yD/h+L/gvZI
+wQpmW7nwgciW0gwsPePoRMg7G7CAXrkOvhv73hOLvHG9AaZVL4VffDzRrKnLadm
1uRPhOpxiaDreCmb3xh5wah5fWFGGG1jn41hsElYVFunVCZCDb54yYCpHNPPaAK0
DoV9WD9Ij10KFuX4oymI4EVPCbr9rIB/1cIC3yqf4RWkrpZWzXJ4GIpYt50AlD3m
B9dWsxcSk2ScRm1dZGrkUO/nbEXsiXQzli45GagPZ8qAP7QiMx1MB9glbYfBOnbW
XDuaFUGc/6zLlBe6ddi75JXH2LH81kR6yOG5v2ngQ00PlYQ5EfqqaBfFqqRyYB6y
ZMQgr/OMEdEwyhsoz5xvaxpspntdUpt9isyAl9TPCgZUYJ0ihSwNXg/84nSAx+RQ
n8csfxVVGAV3zuEIlS1XIkl7i+6zMYH48MLerc3dd4WcYzstb2M=
=6hYv
-----END PGP SIGNATURE-----

--oVbiu2LkYeXiOSOn--
