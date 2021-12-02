Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E0DC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Dec 2021 14:03:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358035AbhLBOGh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 09:06:37 -0500
Received: from dehost.average.org ([88.198.2.197]:36820 "EHLO
        dehost.average.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357998AbhLBOGf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 09:06:35 -0500
Received: from [IPV6:2a02:8106:1:6800:4d98:14f5:53ee:1b84] (unknown [IPv6:2a02:8106:1:6800:4d98:14f5:53ee:1b84])
        by dehost.average.org (Postfix) with ESMTPSA id 5465D394627F;
        Thu,  2 Dec 2021 15:03:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=average.org; s=mail;
        t=1638453791; bh=1EGQRLwJSPzEtuxEpemtQ7Y1uaoFnELIV9iNXMcRGAU=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=OAKnNigd5A2LT0L/MrIKU5JwT2f889kKPDqkpygj/YEyW8Aehd0OR2atXkfHmNasH
         7AGXrFa2n61KqJsXDpNzH66t5Fwa2rtTfiWUfVu2mwWKm2qjc6vSd5lwKo0NpBd8FN
         LdMOE4Z6XDvDLBsjCjP5R8s79pUxAQL3KfwkUHKg=
Message-ID: <ed4f2e2e-50c5-926a-305d-4cd1c7550392@average.org>
Date:   Thu, 2 Dec 2021 15:03:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Content-Language: en-GB
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
References: <45b08de8-13d7-b30d-ca47-b44deeeff83a@average.org>
 <YajP+n5qYEZOzmCD@salvia>
From:   Eugene Crosser <crosser@average.org>
Subject: Re: Suboptimal error handling in libnftables
In-Reply-To: <YajP+n5qYEZOzmCD@salvia>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------qYXRJaguY4d0jAf7Ft609s1t"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------qYXRJaguY4d0jAf7Ft609s1t
Content-Type: multipart/mixed; boundary="------------azSQEyzQR5E0naG9a27yjOco";
 protected-headers="v1"
From: Eugene Crosser <crosser@average.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Message-ID: <ed4f2e2e-50c5-926a-305d-4cd1c7550392@average.org>
Subject: Re: Suboptimal error handling in libnftables
References: <45b08de8-13d7-b30d-ca47-b44deeeff83a@average.org>
 <YajP+n5qYEZOzmCD@salvia>
In-Reply-To: <YajP+n5qYEZOzmCD@salvia>

--------------azSQEyzQR5E0naG9a27yjOco
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello Pablo,

On 02/12/2021 14:54, Pablo Neira Ayuso wrote:

>> 1. All read-from-the-socket functions should be run in a loop, repeati=
ng
>> if return code is -1 and errno is EINTR. I.e. EINTR should not be
>> treated as an error, but as a condition that requires retry.
[...]> This missing EINTR handling for iface_cache_update() is a bug, wou=
ld
> you post a patch for this?

I have a patch that is currently under our internal testing. Will post
it here once I get the results of testing.

>> There is another function that calls exit(), __netlink_abi_error(). I
>> believe that even in such a harsh situation, exit() is not the right w=
ay
>> to handle it.
>=20
> ABI breakage between kernel and userspace should not ever happen.

Well, maybe at least use abort() then? It's better to have a dump with a
stack trace than have the process silently terminate. Libnftables may be
deep down the stack of dependencies, it can be hard to find the source
of the problem from just an stderr message.

Best regards,

Eugene

--------------azSQEyzQR5E0naG9a27yjOco--

--------------qYXRJaguY4d0jAf7Ft609s1t
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEnAziRJw3ydIzIkaHfKQHw5GdRYwFAmGo0hgACgkQfKQHw5Gd
RYzGBgf/Qx7meWORqTjFbVhfALFqWpV1bc8YTsNcxhJu92u+PEfcS44sucH6BUki
syh7rzh8Ep2yxBEjs8522AQpBnv1hByPTXbHe8A5FS1vCvzGG7rCMNBoDaLhm8fi
RqcaOpftpdt5yrA89K386iGWL1WHlHGU67s6Zi00C3AGsDwGUbsNVK6DgfoUSOF3
l22/knyyLcxdfIxOyjn/OzwCKvgnIUq5pbWCnXIe91LXy1k97XRJE4k5H8vVKt1C
b0+6W5QOoOJoF9NzDAbBIRnmpXFffft1ugQ5FDD4J82c2whX457GP9LQ91+X3zm0
5jSI9tjmFDIYb2ig0fVekejz3SKGFQ==
=EIvu
-----END PGP SIGNATURE-----

--------------qYXRJaguY4d0jAf7Ft609s1t--
