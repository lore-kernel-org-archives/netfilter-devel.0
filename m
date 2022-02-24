Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0462C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Feb 2022 21:46:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbiBXVqj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 16:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbiBXVqj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 16:46:39 -0500
Received: from smtp.gentoo.org (mail.gentoo.org [IPv6:2001:470:ea4a:1:5054:ff:fec7:86e4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DF322A24F
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Feb 2022 13:46:08 -0800 (PST)
From:   Sam James <sam@gentoo.org>
Content-Type: multipart/signed;
        boundary="Apple-Mail=_B02697E6-1798-41D1-A30F-E71071CF4541";
        protocol="application/pgp-signature";
        micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.60.0.1.1\))
Subject: Re: [PATCH 1/2] libnftables.map: export new
 nft_ctx_{get,set}_optimize API
Date:   Thu, 24 Feb 2022 21:46:03 +0000
References: <20220224194543.59581-1-sam@gentoo.org>
 <4B1D8E2C-F3F6-44B7-8C98-E896C1C406C6@gentoo.org>
To:     netfilter-devel@vger.kernel.org
In-Reply-To: <4B1D8E2C-F3F6-44B7-8C98-E896C1C406C6@gentoo.org>
Message-Id: <B61ECA27-2B31-4833-A2EF-0F499B9699B6@gentoo.org>
X-Mailer: Apple Mail (2.3693.60.0.1.1)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--Apple-Mail=_B02697E6-1798-41D1-A30F-E71071CF4541
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii



> On 24 Feb 2022, at 21:39, Sam James <sam@gentoo.org> wrote:
>=20
>=20
>=20
>> On 24 Feb 2022, at 19:45, Sam James <sam@gentoo.org> wrote:
>>=20
>> Without this, we're not explicitly saying this is part of the public
>> API.
>>=20
>> This new API was added in 1.0.2 and is used by e.g. the main
>> nft binary. Noticed when fixing the version-script option
>> (separate patch) which picked up this problem when .map
>> was missing symbols (related to when symbol visibility
>> options get set).
>>=20
>=20
> Actually, I'm wondering if we need way more?
> [snip]
> AFAIK none of these are internal so we I think want the whole context =
API.
>=20

Sorry, disregard this last email. The patches stand as per the original =
series :)

Bit frazzled today.

--Apple-Mail=_B02697E6-1798-41D1-A30F-E71071CF4541
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQGTBAEBCgB9FiEEYOpPv/uDUzOcqtTy9JIoEO6gSDsFAmIX/JtfFIAAAAAALgAo
aXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5maWZ0aGhvcnNlbWFuLm5ldDYw
RUE0RkJGRkI4MzUzMzM5Q0FBRDRGMkY0OTIyODEwRUVBMDQ4M0IACgkQ9JIoEO6g
SDtR2gf+L7WbA4tA2rHqZBwFLtr6begtDvyBY6G8TKTYZPzB2kDpzapBVArY7dDC
eqktkp47gcBJ3myAHfB66Hr3Iz3d2xeZMpvFhgGu0K9ue3EGAf4THL53aEih3wCx
WFlBtWJuEcwacsoH/ixGknGVDKLnefTGtUlmKTWeQR75yfkmyEzTdiUMCUAHJAvM
FXsVu+7PR+HZpe15GH/er0z7BYrffEeXQDA8jnQUy0Y9URcShoZHNeLULpgFWteV
cDrZ547ihCIYUY/e+IY8nB4OlsDnyvhkOGnJWF9DrjarJOC475QDc0EBPRIlZA3F
/0Xefx3ZLHk9YPeXWHr2EwCoqxdpaQ==
=ZDZs
-----END PGP SIGNATURE-----

--Apple-Mail=_B02697E6-1798-41D1-A30F-E71071CF4541--
