Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4000AC4167D
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Nov 2022 18:17:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238876AbiKPSQ7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Nov 2022 13:16:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239099AbiKPSQ4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Nov 2022 13:16:56 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB5961B94
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Nov 2022 10:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=W4t2I1Az5E+xySBqrekfY+kfAZgsZeOOdso7n7l5a/0=; b=aOW22J2SRBkuGf7qdON8QYoASS
        SM5QGKt56hlQGJYVfcLnAlIanNGPPXJhJsqm/5Vugov2HcTZNIsV2c79XqgR/bFIFuwb3uMyoUASo
        4kuffAmNUXEEerOShf6NoG1p0e62DZyIvP4k11s5AUqIOHndo6rwxVrjzt5snTwqh3GZTzy2FOTzE
        KyjzRW2P4xm+DlmrUqPBtuDlHyHWiCy6I8cEbPrxexIw3Isu00wRIzJrPzx+RB/DFuUPzra2joXUO
        f63u/OrIMuh3zWOC7CSJcJRC5EqForAMwPDR9inx4vp4DynNePKMpgNSfx8gzlnv4rmwUBgQnLv8f
        i+ZnOGcg==;
Received: from [2001:8b0:fb7d:d6d6:d237:45ff:fe20:4c6f] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1ovMxu-00Gumw-Cs; Wed, 16 Nov 2022 18:16:50 +0000
Date:   Wed, 16 Nov 2022 18:16:47 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Shockedder <shockedder@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: Missing definition of struct "pkt_buff" for libnetfilter_queue
Message-ID: <Y3UpD+6HQxYbkF2x@azazel.net>
References: <15e85292-dfce-edf4-794e-410d8cffaf33@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4L1oxuJISa9f8Ovy"
Content-Disposition: inline
In-Reply-To: <15e85292-dfce-edf4-794e-410d8cffaf33@gmail.com>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d6:d237:45ff:fe20:4c6f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--4L1oxuJISa9f8Ovy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2022-11-16, at 19:42:01 +0200, Shockedder wrote:
> I'm running with a slightly older version of "libnetfilter_queue"
> (1.0.2).
>
> I have installed both the standard and devel packages, along with the
> same for "libnfnetlink" I can't for the life of me find the definition
> of "struct pkt_buff" in any of the source or headers.

  https://git.netfilter.org/libnetfilter_queue/tree/src/internal.h?h=3Dlibn=
etfilter_queue-1.0.2

The public API for `struct pkg_buff` is:

  https://git.netfilter.org/libnetfilter_queue/tree/include/libnetfilter_qu=
eue/pktbuff.h?h=3Dlibnetfilter_queue-1.0.2

> Due to that I'm getting errors when trying to compile accessing
> structure members:
>
>   "etf_nq.c:78:93: error: dereferencing pointer to incomplete type =E2=80=
=98struct pkt_buff=E2=80=99
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fprintf(stdout,"[PACKET] UDP pB->th =
pointer val=3D%p pktb_tail pointer val=3D%p\n",pktBuff->transport_header,pk=
tb_tail(pktBuff));"

Try:

  fprintf(stdout,"[PACKET] UDP pB->th pointer val=3D%p pktb_tail pointer va=
l=3D%p\n",
          (void *) pktb_transport_header(pktBuff), pktb_tail(pktBuff));"

>
> And also having issues accessing the payload for UDP (null pointer
> exception).
>
> What am I missing ? Does something else also needs to be installed ?

J.

--4L1oxuJISa9f8Ovy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmN1KPkACgkQKYasCr3x
BA3CGRAAwpuEgV3UQ3ZH3qTC2Z9U7EkXems7PImIYh2dMxjktxTRnP6Bxn2aoiZB
lW3yWlowbAS1zcWYtUOAPFF4p3XD9GNeuSdCrRKhB4CR+ZEJ9u0xjVM1Vu9T6UYc
6QIcilmP3MJoQO1OASl+A/Xb745zW6Fv/I105mMZ2fyzMnZNq/Uok7t23NTnFXUO
xpOnDbaG+7apyLWBXOrdvH/4sOcgmShEmnEo42O7/7ZzV4/cxayNvoDUwuOpeAok
o4NWZZ9xuAFgv1QPkvtVWiOldyM583b5orgE7q1wxXFD1sNUGvaPewEHCl27Y7yO
pVdCO2qf/xTaSBFdf99RE/K4oWNDU/SfHie2VJI022I/7fWzbBgDutlb80ma0J4h
2Xz7LfG+xt0KDJ4307Hm3Jtm1WyisXo1AgY3aNxLJi5wzBuB+8ueM0bdKzCsuWQs
eIlaXP/hPZoQxoa4Xx6Ms3tsiFwBzsIwdY9gb64vJuMYyqkC/kOocWlPng23FwVP
a3Gb5aa67CxuT9jj4nOjMKx1YhM8DJ/4cTZ/lLxcFXgMj9IqAQm7LHbXzW1xaUBr
hiTaGU9vmcrfE7LPS71Hj7p4kWzIKbixapM1BFWRdesWpuWYNloPjQqZ9TCT5+Ev
lOfFAAn9fj0C6jGG4Ap533dSEtHJvHh2uhUk//Scig2G/uAQXf4=
=Xoxa
-----END PGP SIGNATURE-----

--4L1oxuJISa9f8Ovy--
