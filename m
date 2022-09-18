Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49451C54EE9
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Sep 2022 12:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiIRMnd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 18 Sep 2022 08:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiIRMnc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Sep 2022 08:43:32 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587011903C
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Sep 2022 05:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hhUcTtKujOyIcBH2TaygXSmMF9mQqWK4IJKmm9YQcwc=; b=mXMzJTZ3gFSHVlrgmp8VE39Yt5
        SJU+uLsfoKEUBKAJao3CBS6asmMW6OmLGpaKmxKa9I38/WWNW8Vn8tu06sw2P4n3Vy4b3mZwQv7hz
        US2WBSI50moxXwJsitjK2VdayoLLHevcAbDEyo9ivEMqq0QZyNTeCtnLrsV00Jm2WVWyqs/7ahbSv
        AIZMmEa0dpMV1RcqUthbpHkDn8E1vQ/qfsbvyPZ9UaT8RPj7iUDbDpoTWKPu5bMLYzBYeZ/1Z8kTX
        jId65GRoA9/PpfML5BrEIZIvDYP9cp+7W/tk/8Tryl9axDNE5hX9TuWPDf4F82IJLqoDauvMWlUUU
        e/7UiwbQ==;
Received: from [2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oZtdx-004Sen-Kl
        for netfilter-devel@vger.kernel.org; Sun, 18 Sep 2022 13:43:29 +0100
Date:   Sun, 18 Sep 2022 13:43:28 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] tests: py: fix payloads for sets with user data
Message-ID: <YycScC64fLzYOF8C@azazel.net>
References: <20220918123932.3519245-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="sLronTISs+J4lMRm"
Content-Disposition: inline
In-Reply-To: <20220918123932.3519245-1-jeremy@azazel.net>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--sLronTISs+J4lMRm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2022-09-18, at 13:39:32 +0100, Jeremy Sowden wrote:
> A change was recently made to libnftnl to stop set user data being truncated in
> dumps.  This causes mismatches in the payloads of certain Python test-cases.
> This commit updates them to include the formerly truncated user data.

Just noticed that Pablo has already fixed this.  Never mind.

J.

--sLronTISs+J4lMRm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmMnEmQACgkQKYasCr3x
BA1XQA/9Gqv8AG/I3pHZ0FqN9mzGGFyLdsB3p8HCKpmYe4t1XLLo5+9oJm3D52w4
OLRnto3uqK8wJ1j4NRhjNKoxrhus8XA48JHayM54to03VrMZFrERHbAzFgf+ue1i
ENCxD6HHvuLvz5oI5kFVcDKsvrz0sLUZo4TisPZyEVA3VloAzcHQx9cgEOcvk3Y1
PEqPgjsHlNon5d9qCNYKKRiFtAzwsuwCnQNCcPp370OEXnx7JxGzQEL+OsXcQAM7
x0P8wRoZId8O8mJG7BCnf7woNOYKKzVddA40PDadz1aJCkaIUsXZWJYHAhUcsM3b
MjkTcH5WqxIdQe9B81TW0Kzg0QtyS5PUJSJjDZND0qpbrJYrgw9FShobNc6uwCA4
GaEsyHBD5a7Tkehb19Rl5c8aHO+yGEFvVnwq26fVsAWe22zbCv8MX7UTWlRj2But
r30xN1jtwJMQCRJsN/jvTIMI2lUDjuy6wALhEhow2AYJhfBhBCndELwIiMmEZZnf
Zm4eRNeQsGGDqu9SvSmA08S4acvvxTAB6OGgggHoxRB/04jrro3xMixfcQy53ULz
Onp5wmefXHSkp8Zn2G0SFqTpCgwvU12CTj/JdpZyiXh012AwbmVjNl6tJ3CquLO/
hygAYvinphvl745LEGV6ymhqsZiKiKBC5dSdyq3HK9sTMEKVv1g=
=zHhe
-----END PGP SIGNATURE-----

--sLronTISs+J4lMRm--
