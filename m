Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70DECC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Oct 2021 15:09:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 587A2610C9
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Oct 2021 15:09:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239017AbhJFPLl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Oct 2021 11:11:41 -0400
Received: from dehost.average.org ([88.198.2.197]:47266 "EHLO
        dehost.average.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238124AbhJFPLl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Oct 2021 11:11:41 -0400
Received: from [IPv6:2a02:8106:1:6800:644:959e:952f:424a] (unknown [IPv6:2a02:8106:1:6800:644:959e:952f:424a])
        by dehost.average.org (Postfix) with ESMTPSA id C1C7D38EAC01;
        Wed,  6 Oct 2021 17:09:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=average.org; s=mail;
        t=1633532987; bh=LRY65M9m8eNT0XDtIoPwtyL6+AX4t//UrBwLwzaU6pE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=WUCTweYbrqGcO0EGO4W5pvGuX7FlxF0UOeGK40dohw/V36+c9xqmpYdrBNfVImdLg
         qWfYRE2BSeKQYQ0ykHlZzefLUQBzRUoDz+sxmMF5b2DjK12SrtOQj84PNC9voj4tcT
         mkyOzxhpGH0J2d/1v5C/RjTFutXt8gpH8tBC6iS4=
Subject: Re: In raw prerouting, `iif` matches different interfaces in
 different kernels when enslaved in a vrf
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, Jinpu Wang <jinpu.wang@ionos.com>
References: <17326577-1ab7-aaaa-0911-13ee131bdee0@average.org>
 <20211002185036.GJ2935@breakpoint.cc>
 <dc693a0b-cb3f-877e-1352-cfeb97f2f092@average.org>
 <026e1d28-c76c-fab8-7766-98ad126dbd49@average.org>
 <20211006150301.GA7393@breakpoint.cc>
From:   Eugene Crosser <crosser@average.org>
Message-ID: <060e0d5e-b40f-204a-1894-c1eef8c8411d@average.org>
Date:   Wed, 6 Oct 2021 17:09:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211006150301.GA7393@breakpoint.cc>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DjYYZ8cuOtqXsEqh0w3BSfLVTWUcWp1aY"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DjYYZ8cuOtqXsEqh0w3BSfLVTWUcWp1aY
Content-Type: multipart/mixed; boundary="gLM5TF2GlkVb2JBWgqmPwqqycrJpVCbhD";
 protected-headers="v1"
From: Eugene Crosser <crosser@average.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Jinpu Wang <jinpu.wang@ionos.com>
Message-ID: <060e0d5e-b40f-204a-1894-c1eef8c8411d@average.org>
Subject: Re: In raw prerouting, `iif` matches different interfaces in
 different kernels when enslaved in a vrf
References: <17326577-1ab7-aaaa-0911-13ee131bdee0@average.org>
 <20211002185036.GJ2935@breakpoint.cc>
 <dc693a0b-cb3f-877e-1352-cfeb97f2f092@average.org>
 <026e1d28-c76c-fab8-7766-98ad126dbd49@average.org>
 <20211006150301.GA7393@breakpoint.cc>
In-Reply-To: <20211006150301.GA7393@breakpoint.cc>

--gLM5TF2GlkVb2JBWgqmPwqqycrJpVCbhD
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

On 06/10/2021 17:03, Florian Westphal wrote:

>> It looks like Jinpu Wang <jinpu.wang@ionos.com> has found the offendin=
g
>> commit, it's 09e856d54bda5f28 "vrf: Reset skb conntrack connection on =
VRF
>> rcv" from Aug 15 2021.
>=20
> This change is very recent, you reported failure between 5.4 and 5.10, =
or was
> that already backported?
>=20
> This change doesn't influcence matching either, but it does zap the ct
> zone association afaics.

Yes, looks like it was backported to Debian/Ubuntu kernels

Jinpu reported that reverting the change restores the "old" behaviour.

But we have not yet checked how it affects SNAT.


--gLM5TF2GlkVb2JBWgqmPwqqycrJpVCbhD--

--DjYYZ8cuOtqXsEqh0w3BSfLVTWUcWp1aY
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEnAziRJw3ydIzIkaHfKQHw5GdRYwFAmFdvDUACgkQfKQHw5Gd
RYyx5gf/YQZ03D3eEZ8KxjEvesQuXhbfPS7KD+xXfWqvk6IueIYuI7/buuyGc3Ds
+fU6W3iYZPO2GHi/BiRVRMzls8aOKhtHIauVZSuMjC0Jd9gL3N4MpXTdjBbj31G1
fWpjGNIB+idN/oZ6UMQD95UdewMqAJhB8J3uidiniV3Lfiji7JwwLZW7ZLQAxg79
6XdRBOWpmzGpAAILdTyVpibl0UF8nIlSKvk+SVYMeM0zztHHCcVemjG9K56pZAaA
z52DwCAPXTVtzxcQF7efBITYyWrooFTBGHjb/lF9ZZ2uNzP0G1q7p8mmjDruSZLH
qEOuAfvPgZYX3Xl2Maq4Xehz5tQv8Q==
=eADt
-----END PGP SIGNATURE-----

--DjYYZ8cuOtqXsEqh0w3BSfLVTWUcWp1aY--
