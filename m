Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5223C43219
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Apr 2022 21:23:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234324AbiDEVUp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Apr 2022 17:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457126AbiDEQCq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Apr 2022 12:02:46 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEA2194557
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Apr 2022 08:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vXcaLjDIr9Gwx1k+x2wI4Lab7WUJFf37exQVPumkVzo=; b=K6/f0SN4fGAaxl2aNIIJ5dzeVm
        zgkiOveVBNDemFu5+5CU9cfRiqYWKutS3TDTxhwf5HWVCTHKFHpqKD1i5w7vyJ3f1mKO6PwX8E7gj
        PUYwK0uRL93bYgTnWGPAF/puD0KdH4SuAK+w324+2lIYkHCU8E3SyWEZm17mMr/NUmXIGyuVaMEHF
        wemYuvC9brAhm9/Qomn4G/v+QV+kbeZM6N841MPKxkc+P7043DT4mBx0oJn92wSt1xTVmM1ML3d21
        OFZGXxU1ukVgDoFZbkPybQ6si7Q8owv0A0Qk1m8RsESbvnaYDXwgnDy7Ov+t/0X9j38ifUWF86nYI
        M1Z8BXWw==;
Received: from [2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbl7Q-008JWx-MP; Tue, 05 Apr 2022 16:29:20 +0100
Date:   Tue, 5 Apr 2022 16:29:19 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: Re: [nft PATCH v4 05/32] ct: support `NULL` symbol-tables when
 looking up labels
Message-ID: <YkxgT+vH+99jKhxM@azazel.net>
References: <20220404121410.188509-1-jeremy@azazel.net>
 <20220404121410.188509-6-jeremy@azazel.net>
 <20220405111545.GA12048@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7UjrQIJff6btN64b"
Content-Disposition: inline
In-Reply-To: <20220405111545.GA12048@breakpoint.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--7UjrQIJff6btN64b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2022-04-05, at 13:15:45 +0200, Florian Westphal wrote:
> Jeremy Sowden <jeremy@azazel.net> wrote:
> > If the symbol-table passed to `ct_label2str` is `NULL`, return `NULL`.
>=20
> It would be nice to describe why, not what.
> Does this fix a crash when the label file is missing?

I've been putting debug logging in various places while developing and
testing things.  Here's a function for dumping expressions to stderr:

  static inline void
  dbg_print_expr(const char *func, const char *name,
                 const struct expr *expr)
  {
    struct output_ctx *dbgctx =3D &(struct output_ctx) { .output_fp =3D std=
err };

    nft_print(dbgctx, "%s: %s =3D (%s, %u, %s, %s) { ",
              func, name,
              expr_ops(expr)->name,
              expr->len,
              expr->dtype ? expr->dtype->name : "",
              byteorder_names[expr->byteorder]);
    expr_print(expr, dbgctx);
    nft_print(dbgctx, " }\n");
  }

There are two problems with this.  Firstly, the `byteorder_names` array
is defined in src/evaluate.c and so this function cannot be used
elsewhere.  Secondly, the symbol-tables in the output context are not
initialized, which results in crashes when trying to print symbolic
constants and CT labels.  Patch 3 fixes the former problem by moving the
`byteorder_names` array, and patches 4 & 5 fix the latter problem by
adding NULL checks before trying to dereference the symbol-tables.  They
seemed like small, low-impact changes that could be upstreamed, so that
I didn't have to carry them.

J.

--7UjrQIJff6btN64b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmJMYEkACgkQKYasCr3x
BA1t1BAAnUwsiiUOO+VMjhNBSCtVE7CpQFQtPWGi7fvrKOnplI7LmwMsqNT4B8fE
fD8I6Ye24PnjSz+zb8iyJA2jqjfuzpw9bbf/uSz/wtEKI8jiWxgZGPNp1BCCPxBR
zOThtPWR1oRspgF/mx2JuR7cBhxjxZBKW9SYJ9EwCBjLQB3zjY7QYqWQO23evNPI
qCrHYqBGgu+ycuLah2kMEeliKAHjRmJJe5DElT/w2AwnQ0VdSMyFhWRQZFSiG8nH
UQXT3fIVBGq7rG1OZ/oV8lQj+NY3a3HE55ghJd3JAikcWneshqSIyauVgPpj6/YM
mg39SHZVYgfuKmvaBVVqKAhFsy6yPA2MX7SBr+BEEYcjz7PUn+R2QkSsgsEvd2pI
gLcQM1g4QRzsyG8+vA28zJIyvM4FLvTQHys+upBadZqWfDGDXFhLcDRmdH4tuIpg
y3pcR4sHsANOvFOsQK4JugU1Wg0hQ82RqNR78qs/GuaNCQAxQGrWSd3Y6lTOmtZq
8OaKEgiaMNKT84Sa6Ze5dBhkTvfc784IXM+Q4uUX3bd/pECQfFsvjo7XGBEi/mIg
VGjCQIh0Jy2BCmNq/y8UX6aRIXEa3cM1hhkp63CrjdrjnbtiZgQfudA960XtrWe9
NnKKYPRqGDJkMJ8KqwGowEIvwaHVq61xtCHeUiQrX6GaSsxRA/M=
=Q2iV
-----END PGP SIGNATURE-----

--7UjrQIJff6btN64b--
