Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B6F4C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Dec 2021 20:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238125AbhLPUeB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 15:34:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241456AbhLPUeB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 15:34:01 -0500
Received: from dehost.average.org (dehost.average.org [IPv6:2a01:4f8:130:53eb::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C61FC061574
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Dec 2021 12:33:59 -0800 (PST)
Received: from [IPV6:2a02:8106:1:6800:7a98:db47:a81d:6ef0] (unknown [IPv6:2a02:8106:1:6800:7a98:db47:a81d:6ef0])
        by dehost.average.org (Postfix) with ESMTPSA id D949D3956677;
        Thu, 16 Dec 2021 21:33:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=average.org; s=mail;
        t=1639686836; bh=BqOURQISV9DydWfe7ondO0w72acjbfN7iMkrhxNDH8o=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=U8M4ii+jgkmibhcmECmbm2nAPy2AVldREH07SbITG8Oea2T7LN9DCIOqHPmJuBf0W
         TMFEN2QHJoAqsW7AwUefv+947sqV+Lv23DBTNPSLVck+19ik6ZlDgN22Qr23C+tI4G
         aXN+bSbGFerUZT0PIzlYa22kA4arwVNmTLxpLKxo=
Message-ID: <ad893f82-2490-af82-9ad2-ccb25d73d59d@average.org>
Date:   Thu, 16 Dec 2021 21:33:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH nft 2/2] Handle retriable errors from mnl functions
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <20211208134914.16365-1-crosser@average.org>
 <20211208134914.16365-3-crosser@average.org> <YbD0P44IvQYGU7Dm@salvia>
From:   Eugene Crosser <crosser@average.org>
In-Reply-To: <YbD0P44IvQYGU7Dm@salvia>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------NX3U0665GuQ5dI8xhjB0EFnS"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------NX3U0665GuQ5dI8xhjB0EFnS
Content-Type: multipart/mixed; boundary="------------f32B2vl1ZoG0IL0A5ZQqRFcI";
 protected-headers="v1"
From: Eugene Crosser <crosser@average.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Message-ID: <ad893f82-2490-af82-9ad2-ccb25d73d59d@average.org>
Subject: Re: [PATCH nft 2/2] Handle retriable errors from mnl functions
References: <20211208134914.16365-1-crosser@average.org>
 <20211208134914.16365-3-crosser@average.org> <YbD0P44IvQYGU7Dm@salvia>
In-Reply-To: <YbD0P44IvQYGU7Dm@salvia>

--------------f32B2vl1ZoG0IL0A5ZQqRFcI
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello,

On 08/12/2021 19:06, Pablo Neira Ayuso wrote:

>> ---
>>  src/iface.c | 73 ++++++++++++++++++++++++++++++++--------------------=
-
>>  1 file changed, 44 insertions(+), 29 deletions(-)
>>
>> diff --git a/src/iface.c b/src/iface.c
>> index d0e1834c..029f6476 100644
>> --- a/src/iface.c
>> +++ b/src/iface.c
>> @@ -66,39 +66,54 @@ void iface_cache_update(void)
>>  	struct nlmsghdr *nlh;
>>  	struct rtgenmsg *rt;
>>  	uint32_t seq, portid;
>> +	bool need_restart;
>> +	int retry_count =3D 5;
>=20
> Did you ever hit this retry count? What is you daemon going to do
> after these retries?
>=20
> Probably this can be made configurable for libraries in case you
> prefer your daemon to give up after many retries, but, by default,
> I'd prefer to to keep trying until you get a consistent cache from the
> kernel via netlink dump.
[...]
> BTW, could you just rename iface_cache_update() to
> __iface_cache_update() then add the loop to retry on EINTR? That would
> skip this extra large indent in this patch.


I have sent the new patches a week ago:

  [PATCH nft v2 0/2] Improve handling of errors from mnl* functions"
  [PATCH nft v2 1/2] Use abort() in case of netlink_abi_error
  [PATCH nft v2 2/2] Handle retriable errors from mnl functions

Do they look better now?

Thanks,

Eugene

--------------f32B2vl1ZoG0IL0A5ZQqRFcI--

--------------NX3U0665GuQ5dI8xhjB0EFnS
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEnAziRJw3ydIzIkaHfKQHw5GdRYwFAmG7oqoACgkQfKQHw5Gd
RYy44Af/SfsQ8geW2/Q0GkuaBnWPVvBnkA5JdfTHQeWALbYgXQbazXTDxm6zUImx
UGhE4shKafkNs7JbwrjNKXSbnpaN8IZplzp1kJjaAc2hTEVoZ+kZujS7CQ2SbjN2
io1mscorLO3+J9JyTg5pbS5NtOxR/8m/Fkc/jhf2OhbQ/hr8qAizfcm9HbB4vMAa
Oe7ONOQ6Q/80iwyCDh1CJ30oSVUwlj+XI8jIoQVBOX7fGOOm3spp3+4vIMrmIrCV
61Xt/Nd3GE090EgmYKXC9RFNk/EZCh5nO44OUsye/UiZv8LR5W9XczINzLat+i54
fXN+iy5DzvipHhjIcdesQxBQZ2SAGQ==
=aD/2
-----END PGP SIGNATURE-----

--------------NX3U0665GuQ5dI8xhjB0EFnS--
