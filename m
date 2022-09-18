Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7BAEECAAD8
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Sep 2022 21:02:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiIRVCT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 18 Sep 2022 17:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiIRVCS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Sep 2022 17:02:18 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA83217A82
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Sep 2022 14:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=n61dc2ep3jOopBbhh7CC1OuBTbEC3Fp4jetZr94WYT8=; b=hRYWqTnMbPL0CkwqyHlGeFhSc7
        eYhHpWTvmFnWPMFsrVfSMC6luVL+QxkAj79L+4a+RX7k/45okXJbts9mtf1LJlWKpHkhvVHNuoqNV
        Kx6yUkr2NpKHXEtvIbCmcQwiPO6PPeGkjUO5Me8vP5+crm4vovDzp8ihKh9WY59LbPIkLHKwx/c5D
        DYODtzZfTJ08Kr0X7I6rMJJH7knIWsdb4/Vq0Unj3HCaCVF7vAXOr1QJ+Md/pbUkvH9VfuBBbpT8X
        jgq97uVDagSUcZDpOtvYYCXix4Ci5sGVVmz80eA0CJJQj9hgAEwfgWWwVP9cZjnJ5edXWdTzNidgx
        KA0Jaw6w==;
Received: from [2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oa1Qc-004YUa-OY
        for netfilter-devel@vger.kernel.org; Sun, 18 Sep 2022 22:02:14 +0100
Date:   Sun, 18 Sep 2022 22:02:13 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 0/2] Fix listing of sets containing unclosed address
 prefix intervals
Message-ID: <YyeHVcD9xwO2hc/B@azazel.net>
References: <20220918172212.3681553-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="VKT3LYG9EZp9Pcy0"
Content-Disposition: inline
In-Reply-To: <20220918172212.3681553-1-jeremy@azazel.net>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--VKT3LYG9EZp9Pcy0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2022-09-18, at 18:22:10 +0100, Jeremy Sowden wrote:
> The code which decomposes unclosed intervals in sets doesn't check for
> prefixes.  This means that a set containing such a prefix (e.g.,
> ff00::/8 or 192.0.0.0/2) is incorrectly listed:

The original Debian bug-report only covers the IPv6 case:

>   # nft list table ip6 t
>   table ip6 t {
>     chain c {
>       ip6 saddr ff00::/8 drop
>       ip6 saddr fe80::/10 drop
>       ip6 saddr { fe80::/10, ff00::-ffff:ffff:ffff:ffff:ffff:ffff:ffff:ff=
ff } drop
>     }
>   }

To the reporter that range looked like a garbled address with a negative
hex number embedded in it, and when I read the report it looked like
that to me too.  Inevitably, it was only after I sent this patch-set
that I finally parsed it correctly as the range ff00:: to
ffff:ffff:...:ffff:ffff, largely because of the IPv4 case:

>   # nft list table ip t
>   table ip t {
>     chain c {
>       ip saddr 192.0.0.0/2 drop
>       ip saddr 10.0.0.0/8 drop
>       ip saddr { 10.0.0.0/8, 192.0.0.0-255.255.255.255 } drop
>     }
>   }

which, to me at least, is easier to read.

The reason that I bring this up is that I should probably have phrased
the commit messages differently and avoided the use of "correct" and
"incorrect" if I hadn't misparsed the IPv6 range, like the original
reporter, since the ranges currently output are unexpected (and arguably
confusing), rather than wrong.  I'm happy to reword the commits if you
would like.

J.

> This patch-set refactors `interval_map_decompose` to use the same code
> to handle unclosed intervals that is used for closed ones.
>=20
> Jeremy Sowden (2):
>   segtree: refactor decomposition of closed intervals
>   segtree: fix decomposition of unclosed intervals containing address
>     prefixes
>=20
>  src/segtree.c                                 | 90 +++++++++----------
>  .../sets/0071unclosed_prefix_interval_0       | 23 +++++
>  .../dumps/0071unclosed_prefix_interval_0.nft  | 19 ++++
>  3 files changed, 85 insertions(+), 47 deletions(-)
>  create mode 100755 tests/shell/testcases/sets/0071unclosed_prefix_interv=
al_0
>  create mode 100644 tests/shell/testcases/sets/dumps/0071unclosed_prefix_=
interval_0.nft
>=20
> --=20
> 2.35.1
>=20
>=20

--VKT3LYG9EZp9Pcy0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmMnh0oACgkQKYasCr3x
BA3wnQ/+KICCcEXosU6DtJJoRGJdFJ0a/EG565XsbVAuzYgvtHclzArpb3O52S8o
4j+HfG1VTxR5adQsklscZnfm+ToTOOBeJGoKoeFbOGyZicm9F33NJoeruXarO1qp
ZjcxkXcjlVaJFRQ7H1VOwB1Q2otDsbr85BkfLR3gyi+Uc3sI8wrZQWlKlhGA3lzS
Q4xC/Z6GrYuFM8CdbtN6ZVNjxS+TQo34pfqiH2ICWWw9DYGcsKMs+Kojo9GtQTjn
f2bbb36h5TLeWx596u0cU4RMikqU1uK1w8N+XM1sQt5cu9EvKubT65RhI5YtAp7X
urS0dXe0t2+uDv4XTEFyK4eChTQr7PvEHGiY6G/bRVhRsQhd6EEbRm0LxTwrzBEc
8oStwzWjmhqFhi/Y5H9KVmblehdz06A0D5zf+qKpodnUqEbT64w3n1WRh92GeDfF
5xCY+VpwgsiuaCnVCvbKOAund9FE9Vzt1TwbLbm2KqBA5nwO5fvKJTwxT3rDZ6Ew
aExR3N2dLjwKXB4KzCciO/pr6T+QZpd807qkkYUibC9my9NbAcvS6Zb91YfqBjlj
ryCWiHPIt73rbnAkOTNH5p7OjWUWCpdEyolYKjebvZiSxFYUYQcynXsuAy20+f3T
25usiWrUxXNjm11BAEpTV1GQgeemKf9gzegbHbIywoCC4IlhIYk=
=U3vu
-----END PGP SIGNATURE-----

--VKT3LYG9EZp9Pcy0--
