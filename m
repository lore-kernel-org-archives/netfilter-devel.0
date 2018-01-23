From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: [PATCH] tests: shell: fetch rule handle with '-a' option and
 then delete
Date: Wed, 24 Jan 2018 02:28:23 +0300
Message-ID: <20180123232822.GA20182@altlinux.org>
References: <20180123231739.6412-1-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vmicros1.altlinux.org ([194.107.17.57]:35182 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751807AbeAWX2Z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jan 2018 18:28:25 -0500
Content-Disposition: inline
In-Reply-To: <20180123231739.6412-1-harshasharmaiitr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 24, 2018 at 04:47:39AM +0530, Harsha Sharma wrote:
> Fetch rule handle and then delete rule via that rule handle.
>=20
> Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
> ---
>  tests/shell/testcases/cache/0001_cache_handling_0 | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/tests/shell/testcases/cache/0001_cache_handling_0 b/tests/sh=
ell/testcases/cache/0001_cache_handling_0
> index 9a73769..2bcb8c5 100755
> --- a/tests/shell/testcases/cache/0001_cache_handling_0
> +++ b/tests/shell/testcases/cache/0001_cache_handling_0
> @@ -24,6 +24,7 @@ table inet test {
>  set -e
> =20
>  $NFT -f $tmpfile
> -$NFT delete rule inet test test handle 2
> +rule_handle=3D$($NFT list ruleset -a | grep "saddr" | awk '{print $NF}')
> +$NFT delete rule inet test test handle $rule_handle

No need to use both grep and awk in the same pipeline.

If you prefer awk, then
  awk '/saddr/ {print $NF}'
would do the same thing.


--=20
ldv

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJaZ8UWAAoJEAVFT+BVnCUIXhAQAIifhU55+7le4FFxcsxFncEu
qlT/TYt0Zw2gQSUuo7yZSi1NyfrzIMFCzLy4RwxYEbHC9SIYI4dGhf3NApz3jvQH
x8Bg40uqjfxHjvvtd576dGyo4LCuidgQdc4afPcLFi6s2XdK/QrPBOC5reJ+i4a8
vRkH/JT4VMMccNlco+n6tMRo6QCTJCFURW9Hb/Ko2HgjyJjCD4Ed09WgO5eIgVU4
umdAa39oWMVQo94yWispNFN14H+mbyJu0AEO5wcToax1eESppy8mqn7cCWN3BaNL
SPB6y9xv73bj6ccWBqj5KQB1Pxr/JRxhc8mnrANaeGqaCWazeeNwphwYJu18azQs
c/JLbEmHHH649Xp15vjKmASLf2ATOn7kfXqlvGMB9uqrPPVENsMcmbh708wga2iF
Xk+fXwBAr1rrfhYX1gbf6bm+jaEJ45UHRVLQ1uyenD2obtqPBvLaAypIVacVQqmx
DNwaGE6IrP9AYURS4Z96DoiUkKCKeYfOwRBnOq+rZeB7pmOTgtLpc5yHRNV96dMg
D5iqTxse72Ff/CQtvJD3f2LODi8hMnk701Xb8y83yrGKMQx2cq0r2n6g1X7DKUeG
YoN3xMjbAkErrO/L+WBlOYRsVQ89mz8a/k7dKbQOBs5WFkxsTrvoJJwoP17/HPUK
oRRjRLPhB+le5+0T+ZDE
=S5Er
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
