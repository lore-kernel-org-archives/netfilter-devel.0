Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4A08C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Feb 2022 21:39:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbiBXVjt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 16:39:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbiBXVjt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 16:39:49 -0500
Received: from smtp.gentoo.org (dev.gentoo.org [IPv6:2001:470:ea4a:1:5054:ff:fec7:86e4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B97E184605
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Feb 2022 13:39:18 -0800 (PST)
From:   Sam James <sam@gentoo.org>
Content-Type: multipart/signed;
        boundary="Apple-Mail=_214D4628-A474-4033-8254-2A3184DC4560";
        protocol="application/pgp-signature";
        micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.60.0.1.1\))
Subject: Re: [PATCH 1/2] libnftables.map: export new
 nft_ctx_{get,set}_optimize API
Date:   Thu, 24 Feb 2022 21:39:05 +0000
References: <20220224194543.59581-1-sam@gentoo.org>
To:     netfilter-devel@vger.kernel.org
In-Reply-To: <20220224194543.59581-1-sam@gentoo.org>
Message-Id: <4B1D8E2C-F3F6-44B7-8C98-E896C1C406C6@gentoo.org>
X-Mailer: Apple Mail (2.3693.60.0.1.1)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--Apple-Mail=_214D4628-A474-4033-8254-2A3184DC4560
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii



> On 24 Feb 2022, at 19:45, Sam James <sam@gentoo.org> wrote:
>=20
> Without this, we're not explicitly saying this is part of the public
> API.
>=20
> This new API was added in 1.0.2 and is used by e.g. the main
> nft binary. Noticed when fixing the version-script option
> (separate patch) which picked up this problem when .map
> was missing symbols (related to when symbol visibility
> options get set).
>=20

Actually, I'm wondering if we need way more?

`abidiff` yields (between 1.0.1 and 1.0.2 for me):
```
 * 22 Removed functions:
 *
 *   [D] 'function int nft_ctx_add_include_path(nft_ctx*, const char*)'  =
  {nft_ctx_add_include_path@@LIBNFTABLES_1}
 *   [D] 'function int nft_ctx_add_var(nft_ctx*, const char*)'    =
{nft_ctx_add_var@@LIBNFTABLES_2}
 *   [D] 'function int nft_ctx_buffer_error(nft_ctx*)'    =
{nft_ctx_buffer_error@@LIBNFTABLES_1}
 *   [D] 'function int nft_ctx_buffer_output(nft_ctx*)'    =
{nft_ctx_buffer_output@@LIBNFTABLES_1}
 *   [D] 'function void nft_ctx_clear_include_paths(nft_ctx*)'    =
{nft_ctx_clear_include_paths@@LIBNFTABLES_1}
 *   [D] 'function void nft_ctx_clear_vars(nft_ctx*)'    =
{nft_ctx_clear_vars@@LIBNFTABLES_2}
 *   [D] 'function void nft_ctx_free(nft_ctx*)'    =
{nft_ctx_free@@LIBNFTABLES_1}
 *   [D] 'function bool nft_ctx_get_dry_run(nft_ctx*)'    =
{nft_ctx_get_dry_run@@LIBNFTABLES_1}
 *   [D] 'function const char* nft_ctx_get_error_buffer(nft_ctx*)'    =
{nft_ctx_get_error_buffer@@LIBNFTABLES_1}
 *   [D] 'function const char* nft_ctx_get_output_buffer(nft_ctx*)'    =
{nft_ctx_get_output_buffer@@LIBNFTABLES_1}
 *   [D] 'function nft_ctx* nft_ctx_new(uint32_t)'    =
{nft_ctx_new@@LIBNFTABLES_1}
 *   [D] 'function unsigned int nft_ctx_output_get_debug(nft_ctx*)'    =
{nft_ctx_output_get_debug@@LIBNFTABLES_1}
 *   [D] 'function unsigned int nft_ctx_output_get_flags(nft_ctx*)'    =
{nft_ctx_output_get_flags@@LIBNFTABLES_1}
 *   [D] 'function void nft_ctx_output_set_debug(nft_ctx*, unsigned =
int)'    {nft_ctx_output_set_debug@@LIBNFTABLES_1}
 *   [D] 'function void nft_ctx_output_set_flags(nft_ctx*, unsigned =
int)'    {nft_ctx_output_set_flags@@LIBNFTABLES_1}
 *   [D] 'function void nft_ctx_set_dry_run(nft_ctx*, bool)'    =
{nft_ctx_set_dry_run@@LIBNFTABLES_1}
 *   [D] 'function FILE* nft_ctx_set_error(nft_ctx*, FILE*)'    =
{nft_ctx_set_error@@LIBNFTABLES_1}
 *   [D] 'function FILE* nft_ctx_set_output(nft_ctx*, FILE*)'    =
{nft_ctx_set_output@@LIBNFTABLES_1}
 *   [D] 'function int nft_ctx_unbuffer_error(nft_ctx*)'    =
{nft_ctx_unbuffer_error@@LIBNFTABLES_1}
 *   [D] 'function int nft_ctx_unbuffer_output(nft_ctx*)'    =
{nft_ctx_unbuffer_output@@LIBNFTABLES_1}
 *   [D] 'function int nft_run_cmd_from_buffer(nft_ctx*, const char*)'   =
 {nft_run_cmd_from_buffer@@LIBNFTABLES_1}
 *   [D] 'function int nft_run_cmd_from_filename(nft_ctx*, const char*)' =
   {nft_run_cmd_from_filename@@LIBNFTABLES_1}
```

AFAIK none of these are internal so we I think want the whole context =
API.

> Signed-off-by: Sam James <sam@gentoo.org>
> ---
> src/libnftables.map | 2 ++
> 1 file changed, 2 insertions(+)
>=20
> diff --git a/src/libnftables.map b/src/libnftables.map
> index a511dd78..f8cf05dc 100644
> --- a/src/libnftables.map
> +++ b/src/libnftables.map
> @@ -32,4 +32,6 @@ LIBNFTABLES_2 {
> LIBNFTABLES_3 {
>   nft_set_optimize;
>   nft_get_optimize;
> +  nft_ctx_set_optimize;
> +  nft_ctx_get_optimize;
> } LIBNFTABLES_2;
> --
> 2.35.1
>=20

Best,
sam

--Apple-Mail=_214D4628-A474-4033-8254-2A3184DC4560
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQGTBAEBCgB9FiEEYOpPv/uDUzOcqtTy9JIoEO6gSDsFAmIX+vlfFIAAAAAALgAo
aXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5maWZ0aGhvcnNlbWFuLm5ldDYw
RUE0RkJGRkI4MzUzMzM5Q0FBRDRGMkY0OTIyODEwRUVBMDQ4M0IACgkQ9JIoEO6g
SDt9PAf+KiK0B6qfAtxJq/wNnxCTDimshhI60j8NX6MQnwKaElY2MbJehbKJhTdL
0ASooFlAs+l3vFDW0EnGpndx+iy9NxgeOKm3FNiVDOtAS80mURQUW7t3EolqYxIj
3mDSrZt5opMezUR7pYbsVwe8/EZOsTaGxvlmT4MF72KgNBVTT4mzXxMDcaEr+xeV
bTYC5SYYWExYVe63rBjIu/Y+g7ewU9gaxKGt6zMjnAJqWXRRhjr9XvsxIFAqvg8w
qbQvLPrX3NSrXbNLU9ZZz2nOUL/fJX0Ihsmy/6zz1MZ1gkGS1bzUgSycXz6eur11
ZdIURShZ6y/mdlZMkRFHgiJVnhFyqg==
=Ixbd
-----END PGP SIGNATURE-----

--Apple-Mail=_214D4628-A474-4033-8254-2A3184DC4560--
