Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 403E6C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 Dec 2021 12:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384859AbhLDMI7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 4 Dec 2021 07:08:59 -0500
Received: from dehost.average.org ([88.198.2.197]:39798 "EHLO
        dehost.average.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355048AbhLDMI6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 4 Dec 2021 07:08:58 -0500
Received: from [IPV6:2a02:8106:1:6800:625a:a812:a95b:4e26] (unknown [IPv6:2a02:8106:1:6800:625a:a812:a95b:4e26])
        by dehost.average.org (Postfix) with ESMTPSA id F40883947BCB;
        Sat,  4 Dec 2021 13:05:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=average.org; s=mail;
        t=1638619530; bh=PKvViDPLORg8+bSALvhEW+x4Yg2bTIx4EYamFFaB5Ls=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=E6qRlXYJnIzEOqt3afQYrKbsT9f+GM+nhZTeF1IW+wwmG+iDtzmKSltfU7/KfYifw
         HNWk6z+SCAy5ypmEqg6n0Wb/aVqB7iizSn/PPDNIf1a8XmJjNdhq/T6HsNUvGbREhi
         6Iqi6iDbUX8G7khpE6ZmNZv64s/MIkF2+rg1nC0g=
Message-ID: <9d66247c-51c5-b2d9-584b-0422c99d08bd@average.org>
Date:   Sat, 4 Dec 2021 13:05:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: Meaning of "." (dot) in netfilter
Content-Language: en-US
To:     netfilter@vger.kernel.org,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <CAK3NTRAQE7UD9_0EuzyS0UGQ_s++Dg_hbZPXscHBrStnGJHGjw@mail.gmail.com>
 <YascpztWuzJgKRgq@slk1.local.net>
From:   Eugene Crosser <crosser@average.org>
In-Reply-To: <YascpztWuzJgKRgq@slk1.local.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------uukmFQYdyBQKr4UI5wrf5b8x"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------uukmFQYdyBQKr4UI5wrf5b8x
Content-Type: multipart/mixed; boundary="------------j7oSEXizHa9bkn0a3PHQ0Xyd";
 protected-headers="v1"
From: Eugene Crosser <crosser@average.org>
To: netfilter@vger.kernel.org,
 Netfilter Development <netfilter-devel@vger.kernel.org>
Message-ID: <9d66247c-51c5-b2d9-584b-0422c99d08bd@average.org>
Subject: Re: Meaning of "." (dot) in netfilter
References: <CAK3NTRAQE7UD9_0EuzyS0UGQ_s++Dg_hbZPXscHBrStnGJHGjw@mail.gmail.com>
 <YascpztWuzJgKRgq@slk1.local.net>
In-Reply-To: <YascpztWuzJgKRgq@slk1.local.net>

--------------j7oSEXizHa9bkn0a3PHQ0Xyd
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Duncan,

On 04/12/2021 08:45, Duncan Roe wrote:

> "." is the symbol for concatenation. It's been missing from the man pag=
e
> forever.
>=20
> I was going to submit a patch to add "." but wasn't really sure when yo=
u could
> use it so I never did.

It is my understanding that the only use for concatenation is to define
composite value for the key in a `map` / `vmap` or the element in a `set`=
=2E Maybe
someone more knowledgeable can correct me.

Regards,

Eugene

--------------j7oSEXizHa9bkn0a3PHQ0Xyd--

--------------uukmFQYdyBQKr4UI5wrf5b8x
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEnAziRJw3ydIzIkaHfKQHw5GdRYwFAmGrWYEACgkQfKQHw5Gd
RYxItAf/Vk8vU7PeochVHAGIJyWPB7H6JfW/tOr+y9lVYTK1IqO6DynynbwaYrIj
nYZHAhYeuRWF+QQuKSOqBcYQbfZUq6pxMVQr2MVDD8JFk00soTmor97KPnJknWlQ
FsOgG8xCderRfJB/YfAFfxm2CbGB5QwTxlGGkAojbfb1AEhhAW7fSRrU5/UsQ8WV
noEKua3fdpvNuWxRLJ56QHFU5FZ8uSZ0y3egoMx6ybKlByly1m6k9tMXQhejGy/W
MnAdpqrI2yw8HT2wUazQ32Awsnj3HxdsijP5fWiA0YBPge3QErc6LK7maWWAvInf
owmi5w6qrdPRT2zTqUfsuipEAiyIdg==
=09Fz
-----END PGP SIGNATURE-----

--------------uukmFQYdyBQKr4UI5wrf5b8x--
