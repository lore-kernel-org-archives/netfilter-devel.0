Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D97C3EB64DD
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Aug 2023 08:13:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbjHAINh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Aug 2023 04:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232164AbjHAINd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Aug 2023 04:13:33 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D2F1FFD
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Aug 2023 01:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MKd5kaH22z2TdiO/QwaJPIVyWY8mPNjo/omd8r4inwY=; b=HLxy0tX4ENuJy2erRn2NQPVcsC
        47L03hrCE3jC+rXoCA24zeBUtVWpKmXe0UDdy4JKtjoiDum4xmTg3qgF7gM/zr/xV0DWzY3ntgjDP
        FqLCHVpHFq3/lKAY6ats/biG0iWQgERyo3pligTo5/l0mUHVATFu7n/KeCmLR2Js63Yq/UNWlQY3/
        V4OELzvh4H+GCPmNoC7O83zMDKEIYh84h0E1rW+JyfsZ/8uzxT7ocgcYIAMEuO1WFgr8Fof5x86Tg
        etjzkiOJqFAFfRxHCLAldyOR5ItqwrI1n/clAiuLmQwoP/DUFqxMaif2znpV1JQbcdZZxEE91+3nM
        OnhqSJMg==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
        by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qQkVR-000j0t-30;
        Tue, 01 Aug 2023 09:13:25 +0100
Date:   Tue, 1 Aug 2023 09:13:24 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ulogd2 patch ping
Message-ID: <20230801081324.GJ84273@celephais.dreamlands>
References: <20230725191128.GE84273@celephais.dreamlands>
 <20230726143533.GB2963@breakpoint.cc>
 <20230731221513.GA32288@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zXf8p6IEASpSptKA"
Content-Disposition: inline
In-Reply-To: <20230731221513.GA32288@breakpoint.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--zXf8p6IEASpSptKA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-08-01, at 00:15:13 +0200, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > I'll apply it on Friday in case noone objects until then.
>=20
> Just for completeness: I did not apply it due to the unanswered
> question from Pablo.

Thanks, Florian. I had hoped to have reponded over the week-end, but I
was busier than I expected and didn't pick this up again till yesterday
evening.  Answers should be forthcoming soon.

> Also, don't we risk ambiguity here, or is there a guarantee that
> kernel never emits mapped addresses?

It would indeed mean that real ipv4-in-ipv6 addresses would be output in
ipv4 format.  It's been several months, so I can't quite remember my
thinking, but I probably inclined towards regarding the ambiguity as
benign.  I have spotted a problem with the existing patch, however, so
another version will definitely be needed, and I can look at eliminating
the ambiguity at the same time.

J.

--zXf8p6IEASpSptKA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmTIvp4ACgkQKYasCr3x
BA3EZA//RGUBvVe00mZ3aV2FEr10FP0ks3y14px2MDZrI9iZueBiU5FkpW/tH7nK
Sm78cjDyJ/x1ONCmubLGZSp4edLOsLNPA7NBNasb8Ffjoy4fGdlC5oGxkB2xqA64
mSal8eu2YDtl96dIxVZG/YZzAZFCG4IbpXnPDfLJti8iyZ/En69n+Ers07E/H/Gf
NwGq3ScQKt8I26gv2BICOssFNW80VKJEN3KAiShteWEULLhgIGqAr8zCz4Mg5Bp7
CV251S44SBjrZnk8SdGTE10VyPKvCaR1Hlf+nNR0poqa/20IAcdSZtztkj1rol/1
Qrl2Eui8S5sjGDonEOFCkU8mUgIiVbjo8PXZ7fLvni0QYANH0izoILbC0LbHWddQ
LZ8NfOjRfI4AmxWZNTDBbBacuqEBQHt9KxLgR0Pkwqxtm7rGaQioSxjQSI3qI6jp
AmlJAnuIYQLGJXZAyP1MP/mWKT8dj7xT0PUaYX9qcoJLAJOEu7JHs5eJlm5ow8IB
VPHo59CX0QLFvbyXmfMBEOEutFkEf+hE4hwSUxMyDU6mbJNsN0049HlgfKYt0ceP
Mc2THByqyJXlwEgIa7uXG9YzOjnVeKNtaPej510axCDb9se9gRcI8s6DktoE/2Mr
yOSZf6+PLIUQo3AlPUVD/gGYwrCCBgBN1CEqDYDrlCKGLrs0QU4=
=n0Jt
-----END PGP SIGNATURE-----

--zXf8p6IEASpSptKA--
