Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE3FFC77B73
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jun 2023 21:40:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjFEVkg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Jun 2023 17:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbjFEVkg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jun 2023 17:40:36 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E7BF2
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Jun 2023 14:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wsTcQQIhiqpcz8FhawC4jyRDtSbK6LYYFp8rwMKZCZI=; b=VPt3vOW4rsffO8A0VXnmYDxU7x
        LYyiPdemoTwzMtopgDfjK8BwXv75duABI/kx1CexYSPS1RYrHqLzFJnkBE6idQTo/D6FpgV7pbJz+
        YuP7P5WHIOY6Cpp2mVdICMZja3kNMBZh4PR4KYzOU4H4QZisaJsXCbQeWYhDYvVyOBH4xlQzZfLz8
        b5d9UuGLUOEh1DvgQbtz4F8Sa0531n+HUXJh8ukDPGZbePnDComyAkCzzGEyqtWoIorKYo/Ezz0+J
        nauU2yhSJ0UWrjUg09mqaLVAqx9IqEBeOmhHa9fX7B0obcK5/QHsgBxd7X5+l13zjSZa8FyYe3zyr
        fKoY/RTg==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
        by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q6HwH-00H4J3-KN; Mon, 05 Jun 2023 22:40:33 +0100
Date:   Mon, 5 Jun 2023 22:40:32 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH xtables-addons 5/8] xt_ipp2p: rearrange some conditionals
 and a couple of loops
Message-ID: <20230605214032.GH187342@celephais.dreamlands>
References: <20230605191735.119210-1-jeremy@azazel.net>
 <20230605191735.119210-6-jeremy@azazel.net>
 <9qn76633-qp55-3q8n-osn7-p26s3ss2rsqq@vanv.qr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="P5MotHsAXE8oMjxs"
Content-Disposition: inline
In-Reply-To: <9qn76633-qp55-3q8n-osn7-p26s3ss2rsqq@vanv.qr>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--P5MotHsAXE8oMjxs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-06-05, at 22:36:34 +0200, Jan Engelhardt wrote:
> On Monday 2023-06-05 21:17, Jeremy Sowden wrote:
>=20
> >Reduce indentation and improve the readability of the code.
>=20
> Applying patch extensions/xt_ipp2p.c with 3 rejects...
> Hunk #1 applied cleanly.
> Hunk #2 applied cleanly.
> Rejected hunk #3.
> Hunk #4 applied cleanly.
> Hunk #5 applied cleanly.
> Hunk #6 applied cleanly.
> Hunk #7 applied cleanly.
> Rejected hunk #8.
> Hunk #9 applied cleanly.
> Rejected hunk #10.
> Hunk #11 applied cleanly.
> Hunk #12 applied cleanly.
> Hunk #13 applied cleanly.
> Hunk #14 applied cleanly.
> Patch failed at 0001 xt_ipp2p: rearrange some conditionals and a couple o=
f loops
> hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch

Mea culpa.  Was working from an out-of-date branch.  Will rebase and
send v2.

J.

--P5MotHsAXE8oMjxs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmR+VkkACgkQKYasCr3x
BA3OERAAjuoySE4BefhH1/VdOmTUOSz7BuEDp7TfUryq3VGlLyaOAvUfMHRwHfeY
KOTCFQD4kDfyR/QoKesGoUx6YLDZbqBU3KEamQVZKNi25Dhaqcmts16Tg6b8v7/c
+3a94mIR6/2xJIRuvQ1N2gzUVjLt9x3cfhSe5PBmebm/bSjtwyuOv420sUzJhQM9
GeOgMKEkccAatlR37esI6WmlUmrdDvk/pRuF2Urj47+ZZprfPep4W4vLor0GEVRj
dx1Ccq6f+kc7AVqkVeGkCX2dIvDdxmydWEG/8THODXxfxux488ho0NOeZPULVZLZ
julQpKmNIxs8nxABkRoqxcY8yhCp0GdaYI/8UeDE2cX0/3EQdjTsijbM3W8k2Whp
Mm7ysWrvIwhPvyL4qU0WyBHU4MMFNtRAlCXfGLHuUOyDq4B/4XBIQiMRQkvTw+Cb
u/6HZvsz+foXRqTOXLZSWLi/Do3nFBhlxHH7f+YK1G3QHyR8UbQ4ElFkyyW9hSwx
QNYozdkiQ/bUWGbIjZ5nbmzp/WzhiAQVdqgPETYG5xvKZUQbSL5KSfQFfG02M9Oj
mdTV2YfzPKDRDAVhHxPPah+P3I/9ACambI4BFh1LNh/jMrFS+Ai+jj2uPVvft3BR
llA6PfLlWzqJZ+plbNSmCA1YWYGl298JmxmKPn2/Sl5oBJel3I8=
=O7us
-----END PGP SIGNATURE-----

--P5MotHsAXE8oMjxs--
