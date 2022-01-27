Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40109C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jan 2022 18:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242684AbiA0Spm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jan 2022 13:45:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240823AbiA0Spl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jan 2022 13:45:41 -0500
X-Greylist: delayed 332 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 27 Jan 2022 10:45:41 PST
Received: from dehost.average.org (dehost.average.org [IPv6:2a01:4f8:130:53eb::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1BAC061714
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jan 2022 10:45:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=average.org; s=mail;
        t=1643308806; bh=RQK7j5xHMDn9T92tnIF/s2ik6gg5dUsjFYM/2ACfct0=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=JONPZuQl5wMfqQbZotrJGgzaTls9fIN7+PM/KPBD5x4bcCqv1Ql90ii/RE5OYWXDb
         XeNdV1hg2dK3TyKYBgwqdXDC+J6Smoum5VJLPto20ibqKSmG/4vEfyFem1XgzEtflk
         adn5ko0DjgY11L0N1R5btitR5SHwASDGZIfujYfs=
Received: from [IPV6:2a02:8106:1:6800:32a7:fa17:c0f9:20a] (unknown [IPv6:2a02:8106:1:6800:32a7:fa17:c0f9:20a])
        by dehost.average.org (Postfix) with ESMTPSA id F04153A020AD;
        Thu, 27 Jan 2022 19:40:05 +0100 (CET)
Message-ID: <33c871d0-ec0e-2039-3a83-837c76d64fbe@average.org>
Date:   Thu, 27 Jan 2022 19:39:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <20211209182607.18550-1-crosser@average.org>
 <20211209182607.18550-3-crosser@average.org> <YfLiitlOadGmfK7v@salvia>
From:   Eugene Crosser <crosser@average.org>
Subject: Re: [PATCH nft v2 2/2] Handle retriable errors from mnl functions
In-Reply-To: <YfLiitlOadGmfK7v@salvia>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------ax0UK6FITGB5ODkmSHypEx0R"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------ax0UK6FITGB5ODkmSHypEx0R
Content-Type: multipart/mixed; boundary="------------NDfy5fxUCG8ISSYtH6hY72ao";
 protected-headers="v1"
From: Eugene Crosser <crosser@average.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Message-ID: <33c871d0-ec0e-2039-3a83-837c76d64fbe@average.org>
Subject: Re: [PATCH nft v2 2/2] Handle retriable errors from mnl functions
References: <20211209182607.18550-1-crosser@average.org>
 <20211209182607.18550-3-crosser@average.org> <YfLiitlOadGmfK7v@salvia>
In-Reply-To: <YfLiitlOadGmfK7v@salvia>

--------------NDfy5fxUCG8ISSYtH6hY72ao
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 27/01/2022 19:20, Pablo Neira Ayuso wrote:
> On Thu, Dec 09, 2021 at 07:26:07PM +0100, Eugene Crosser wrote:
>> rc =3D=3D -1 and errno =3D=3D EINTR mean:
>>
>> mnl_socket_recvfrom() - blindly rerun the function
>> mnl_cb_run()          - restart dump request from scratch
>>
>> This commit introduces handling of both these conditions
>=20
> Sorry it took me a while to come back to this.
>=20
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/202201271818=
35.571673-1-pablo@netfilter.org/
>=20
> This follows the same approach as src/mnl.c, no need to close the
> reopen the socket to drop the existing messages.

Thanks for getting back to it and producing the fix!

I think it is slightly less clean, because if some (not EINTR) error happ=
ens
while it is draining the queue (the second call to `mnl_socket_recvfrom()=
` with
`eintr =3D=3D true`), `errno` will be overwritten and the error misrepres=
ented. This
should not be a _practical_ problem because presumably the same error wil=
l be
raised upon retry, and this time it will be reported correctly.

Thanks again,

Eugene

--------------NDfy5fxUCG8ISSYtH6hY72ao--

--------------ax0UK6FITGB5ODkmSHypEx0R
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEnAziRJw3ydIzIkaHfKQHw5GdRYwFAmHy5vwACgkQfKQHw5Gd
RYww+ggApNLo20elSiJ8eEUplIH283JNdOznDsDVIdaLbgvgUHyoeC58Y+igr28a
mkVsvsPggD8vCA8ZtNJGX6+Zik0RBodhvO14KRI7Yol0ZMXrZZDolmek4Icok8T/
juGP9A0gbHyHNyJkl/DmueLAbYHrlqk5ycBGRPCGPSNIcJQ0BTXvQ3iMWZ+hS+dZ
OIxp+gl4qf+aGMu0L/0uN1Sx02obZO4Q2VSOm1k1nJGXV74bRLattAWbzZB543Zz
DzNEVJONU9fRrySYq6D7GCAoqUtLrL0YWw5zVDFYLfazCwIFJEpL8wYAXVcMlePE
uwFUn/DFxh9wd9kBjiCga3NG/IuDqQ==
=9mUB
-----END PGP SIGNATURE-----

--------------ax0UK6FITGB5ODkmSHypEx0R--
