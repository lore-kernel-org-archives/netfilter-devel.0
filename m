Return-Path: <SRS0=D+Hy=4U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37F42C3F2C6
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 09:33:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10AAB21556
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 09:33:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="FFplUM1S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgCCJdj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Mar 2020 04:33:39 -0500
Received: from kadath.azazel.net ([81.187.231.250]:40126 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728157AbgCCJdj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Mar 2020 04:33:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=u4rVlHmO8ErXp80akfDlRbuwHreleju7OoU32r5raUA=; b=FFplUM1SWn1LpFXalyADgDwmc8
        PpYEobSd2zPBB2/PY2EKmzf+3N6sehE3cirHit0FXmpg+OBIm1/boALKcwdB5PMPzdZWHOiIbnE7Y
        jg3Z65x6xYKYt5RnrJNF28ji0lop+v5EWezzApENCvTInLeWdC5N0QeyHitH8CYqnXgplQRblIV/T
        RhzDLJO4wniYg/kbMHuY+to1gMrLaoJa+2amRcwuv963SFYzqraiLLEH/CENLC7YGADb7KXuhmaO0
        n38Sit/EouakejKXfGcBXnseI4QJz/kbQuJ7lUQoB1r0W+ZIR+AWBpG5aLWWvNvGHQvXPNs8aIQ2p
        G8hSxO1w==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j93vj-0007lb-Pf; Tue, 03 Mar 2020 09:33:35 +0000
Date:   Tue, 3 Mar 2020 09:33:34 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v2 11/18] netlink_linearize: round binop bitmask
 length up.
Message-ID: <20200303093334.GA2265@azazel.net>
References: <20200302221916.1005019-1-jeremy@azazel.net>
 <20200302221916.1005019-12-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <20200302221916.1005019-12-jeremy@azazel.net>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-03-02, at 22:19:09 +0000, Jeremy Sowden wrote:
> In this example:
>
> nft --debug=netlink add rule ip t c ip dscp set ip dscp
> ip t c
>   [ payload load 2b @ network header + 0 => reg 1 ]
>   [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00000000 ]
>   [ payload load 1b @ network header + 1 => reg 2 ]
>   [ bitwise reg 2 = (reg=2 & 0x0000003c ) ^ 0x00000000 ]
>   [ bitwise reg 2 = ( reg 2 >> 0x00000002 ) ]
>   [ bitwise reg 2 = ( reg 2 << 0x00000002 ) ]
>   [ bitwise reg 1 = (reg=1 & 0x0000ffff ) ^ reg 2 ]
>   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
>
> The mask at line 4 should be 0xfc, not 0x3c.
>
> Evaluation of the payload expression munges it from `ip dscp` to
> `(ip dscp & 0xfc) >> 2`.  When this AND expression is evaluated, its
> length is set to 6, the length of `ip dscp`.  When the bitwise netlink
> expression is generated, the length of the AND is used to generate the
> mask, 0x3f, used in combining the binop's.  The upshot of this is that
> the original mask gets mangled to 0x3c.  We can fix this by rounding
> the length of the mask to the nearest byte.

This is the wrong solution.

J.

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl5eJFIACgkQonv1GCHZ
79fr2wv/WwGFo6M9A1GAvEJAjedsVtGcQyH4/+MQ8v0Y1CE8pM8KeaFJdl5EzYEm
PP7+HnbLr6Wr82jwxFvQoD7HKujtnn3O0z9plZXznmuF7msQhikKf21V8D4aXk5g
pmaLFa5E8cXQupN+EYgXe7oYufxzSUZxJa+8TWcTzkRsmdwFkpZaSicSObNl/22e
x36S8N+TYQO+IOPTwUtXcrTkqS77qMEWrv1ro642VzjE5IE6vNF2vfexWuvNOLPi
+oyigbuPqL0ZKFuO+bXznJS16HjS2fzKnGUQ3KfIxjnJtlPWOAF6DA0o0MbrOHRC
e7Trp/V0xN/GkyomlsoL5EKsRMJJO9cDOqXMoqyOLC+Hyt9kjnWA2eudIsoE/s0H
c+z8+4Hu+yaz65Jq/SD+lUgW1gbb/wMAkOc8oqohvd3PVJ+p2X72tJ5khSSi+N8L
NS6cXI9HZV3wUI4zx2xgvFsS/AGukhG7MytX6/j2aQ4R64v0jh1hbMAnKJfEHCtS
cwMF01p4
=+A+n
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
