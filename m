Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9E75C4338F
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Aug 2021 11:02:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EB9060FDA
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Aug 2021 11:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbhHULD1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Aug 2021 07:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbhHULD0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Aug 2021 07:03:26 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793F8C061575
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Aug 2021 04:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4aC8RqFO1YqdxuHs8feMlqVDqKfQ6ascsCFoNqKoy3c=; b=pSIUygp+YkxP1tqIs8hqg0rLDG
        8zziVEybqn9TZLzqC/CL+iqiXjGNMlkZMJ6RoSRXAaRcIoV/d3rRDZM/lzG3Z/f6R9RyPcmnKftzp
        cM8mxzp9tzp3rDDe6eETwjdhbOD0EpFSlTSdR/TtpkfN0thmq7la0P8VlWQaK4bv2ss9E4JQSNEPv
        Qko+qN2PrX8X6QztJ4Dod6aATSOBbpukQCTB0tfzywLJB7nzWkemUxFV5x6glb/bu5TgV2jvN7Xog
        P9GkHskGG6cq6zRdhCwkTmZ0kRyCxS6NciPinu+4lJ7hVACCo/yBHAEgXrf4ZjjwJS6adUeiErurH
        csOOfSrw==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mHOlx-00787K-Op; Sat, 21 Aug 2021 12:02:45 +0100
Date:   Sat, 21 Aug 2021 12:02:44 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] Add DWARF object files to .gitignore.
Message-ID: <YSDdVBvixWkwYYYJ@azazel.net>
References: <20210821101724.602037-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jid3SX/hYcKLFsWQ"
Content-Disposition: inline
In-Reply-To: <20210821101724.602037-1-jeremy@azazel.net>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--jid3SX/hYcKLFsWQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-08-21, at 11:17:24 +0100, Jeremy Sowden wrote:
> If we build against a kernel with `CONFIG_DEBUG_INFO_SPLIT` enabled, the
> kernel compiler flags will include `-gsplit-dwarf`, and the linker will
> emit .dwo files.
>
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  .gitignore | 1 +
>  1 file changed, 1 insertion(+)

Just noticed I forgot to indicate in the subject that this is for xtables-addons.

Apologies.

J.

> diff --git a/.gitignore b/.gitignore
> index 2ebbe0e89fe7..005e7f978d47 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -1,3 +1,4 @@
> +*.dwo
>  *.gcno
>  *.la
>  *.lo
> --
> 2.32.0
>
>

--jid3SX/hYcKLFsWQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmEg3VQACgkQKYasCr3x
BA3nRA/+Ic3jbQRuTSsE6H4KF84+mtQANZNUHS7gk9sYkho3fBoTiBfhP1KB97f6
OjmpynHoRjjMFcrCrvQKnUEqTouT1qpc66BfrbrWT5npeHvnTjcdL9isilrpZpAO
MSRQJlHRd3bli87cCa/CoYT46UeUO/g0ieF1XZ9qpHgFSkeWpwPHeR85l0BoVbCU
DbziDyevZoocBYD/bzPx272/tx4VFg53ICi3ieH9ZD6yC2bR7iugeD/jkaCQviYZ
RTTJFoRWlnbuk0GfBcVkG+6QvL8gic46tez/Fi4u6ZIKnBE2HGwoIZO3qMns+tXD
IuRC8/fGQuVeLO3x35n2up0eNb1E49zzIZvD2AEUfl5QFN2Z7IaABZ8cj8k21ODa
Ut80sDNNQqVbXFZz6f8qV68lNpOUJmi/x77ZVlS2HD0TSAEZF+HRKxlU+KvufzX5
nrRANGXoiX4sMFbEiKJvtcq0tVsKhMLYSy9pvjI713knlID0IWL4/YKwY/mg2tpi
P8i/MGm0ofuSwfnzmP51lYon61CHq+XoOLC+evsm0BmxcSgp8PHHHvPDBvfFqxkt
y+VQkrfY26pgnz5yRBJ3hxf5iFfRYTLytzmUF5ovAtH1NfntTi4AO4Mx28c0xi6F
4JyOKvYpL5cPtb6awkl7Sgpx09viKnbazJJwzPgkiEtEu4YzZbo=
=qh14
-----END PGP SIGNATURE-----

--jid3SX/hYcKLFsWQ--
