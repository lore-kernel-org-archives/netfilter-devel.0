Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D983C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jan 2022 08:39:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235055AbiA1Ija (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Jan 2022 03:39:30 -0500
Received: from dehost.average.org ([88.198.2.197]:54634 "EHLO
        dehost.average.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbiA1Ija (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jan 2022 03:39:30 -0500
X-Greylist: delayed 50359 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Jan 2022 03:39:30 EST
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=average.org; s=mail;
        t=1643359169; bh=qIYwo8DTK7/rtUneg3e0ZuzkkHmcqHQ/TEkFnBtd1hY=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=U+kCCUrFUUpISl/46BLz39gDK9edbQdl7Plmd1H/1hITo1W27QxdzKoGh4j8O7nig
         qPQ1K6XSRcLAW7zukB0UyVxg3ZfZoh0y40ykhCMTX75rSS6+2zHbn52W3x+XYK6Ax4
         glSjZ5HYD47UZ/bI2b/gqwE9/IxGGIJpb46jczqM=
Received: from [IPV6:2a02:8106:1:6800:9825:f04d:cafa:872c] (unknown [IPv6:2a02:8106:1:6800:9825:f04d:cafa:872c])
        by dehost.average.org (Postfix) with ESMTPSA id D10453A0DA43;
        Fri, 28 Jan 2022 09:39:28 +0100 (CET)
Message-ID: <890e77c9-f65d-ad5c-3640-f9268dc419f5@average.org>
Date:   Fri, 28 Jan 2022 09:39:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH nftables,v2] iface: handle EINTR case when creating the
 cache
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220127230629.573287-1-pablo@netfilter.org>
From:   Eugene Crosser <crosser@average.org>
In-Reply-To: <20220127230629.573287-1-pablo@netfilter.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------WiOqf08jWz25Zpk2ewlzi5CT"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------WiOqf08jWz25Zpk2ewlzi5CT
Content-Type: multipart/mixed; boundary="------------XejaiyxZM9kXmwzwYWD2Qv9Z";
 protected-headers="v1"
From: Eugene Crosser <crosser@average.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Message-ID: <890e77c9-f65d-ad5c-3640-f9268dc419f5@average.org>
Subject: Re: [PATCH nftables,v2] iface: handle EINTR case when creating the
 cache
References: <20220127230629.573287-1-pablo@netfilter.org>
In-Reply-To: <20220127230629.573287-1-pablo@netfilter.org>

--------------XejaiyxZM9kXmwzwYWD2Qv9Z
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Eugene Crosser <crosser@average.org>

On 28/01/2022 00:06, Pablo Neira Ayuso wrote:
> If interface netlink dump is interrupted, then retry.
>=20
> Before this patch, the netlink socket is reopened to drop stale dump
> messages, instead empty the netlink queue and retry.
>=20
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: immediately return on non-eintr error (instead of breaking the loop=
),
>     per Eugene Crosser.
>=20
>  src/iface.c | 50 ++++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 38 insertions(+), 12 deletions(-)
>=20
> diff --git a/src/iface.c b/src/iface.c
> index d0e1834ca82f..c0642e0cc397 100644
> --- a/src/iface.c
> +++ b/src/iface.c
> @@ -59,13 +59,13 @@ static int data_cb(const struct nlmsghdr *nlh, void=
 *data)
>  	return MNL_CB_OK;
>  }
> =20
> -void iface_cache_update(void)
> +static int iface_mnl_talk(struct mnl_socket *nl, uint32_t portid)
>  {
>  	char buf[MNL_SOCKET_BUFFER_SIZE];
> -	struct mnl_socket *nl;
>  	struct nlmsghdr *nlh;
>  	struct rtgenmsg *rt;
> -	uint32_t seq, portid;
> +	bool eintr =3D false;
> +	uint32_t seq;
>  	int ret;
> =20
>  	nlh =3D mnl_nlmsg_put_header(buf);
> @@ -75,6 +75,38 @@ void iface_cache_update(void)
>  	rt =3D mnl_nlmsg_put_extra_header(nlh, sizeof(struct rtgenmsg));
>  	rt->rtgen_family =3D AF_PACKET;
> =20
> +	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0)
> +		return -1;
> +
> +	ret =3D mnl_socket_recvfrom(nl, buf, sizeof(buf));
> +	while (ret > 0) {
> +		ret =3D mnl_cb_run(buf, ret, seq, portid, data_cb, NULL);
> +		if (ret =3D=3D 0)
> +			break;
> +		if (ret < 0) {
> +			if (errno !=3D EINTR)
> +				return ret;
> +
> +			/* process all pending messages before reporting EINTR */
> +			eintr =3D true;
> +		}
> +		ret =3D mnl_socket_recvfrom(nl, buf, sizeof(buf));
> +	}
> +
> +	if (eintr) {
> +		ret =3D -1;
> +		errno =3D EINTR;
> +	}
> +
> +	return ret;
> +}
> +
> +void iface_cache_update(void)
> +{
> +	struct mnl_socket *nl;
> +	uint32_t portid;
> +	int ret;
> +
>  	nl =3D mnl_socket_open(NETLINK_ROUTE);
>  	if (nl =3D=3D NULL)
>  		netlink_init_error();
> @@ -84,16 +116,10 @@ void iface_cache_update(void)
> =20
>  	portid =3D mnl_socket_get_portid(nl);
> =20
> -	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0)
> -		netlink_init_error();
> +	do {
> +		ret =3D iface_mnl_talk(nl, portid);
> +	} while (ret < 0 && errno =3D=3D EINTR);
> =20
> -	ret =3D mnl_socket_recvfrom(nl, buf, sizeof(buf));
> -	while (ret > 0) {
> -		ret =3D mnl_cb_run(buf, ret, seq, portid, data_cb, NULL);
> -		if (ret <=3D MNL_CB_STOP)
> -			break;
> -		ret =3D mnl_socket_recvfrom(nl, buf, sizeof(buf));
> -	}
>  	if (ret =3D=3D -1)
>  		netlink_init_error();
> =20


--------------XejaiyxZM9kXmwzwYWD2Qv9Z--

--------------WiOqf08jWz25Zpk2ewlzi5CT
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEnAziRJw3ydIzIkaHfKQHw5GdRYwFAmHzq7kACgkQfKQHw5Gd
RYyVcQgArrAQIoaeYAvgx+DohlTqy+d+Kcx23bJ3VuLZq5w1bu07HrCfFniylVXb
wYWJdHZtGLkwtLVZpo0VjtkGFB+E1qrPyCuYWTC7o5FEZJzybWIzOq6QX1cYcNCQ
OkIxs+uHKMKFDAXtRQFlOFNm6rs3G3fTCHnJ8YMyI/5doa3RYnBF3t/2UyZIXLMs
Lez5tEhiEwUQOjg5UOQ18UbgC6Skt49w0l2S7wmCOKw5AiDlz6WaDfnI/IHsvCwK
3uEmzPzNQXH5VKlxk5ERuKDQuPVz3MZjWQDZjRwOzbrTDrZK9HcgK5rR78hE0UhY
hL1c4Qm3cZZ5UYn9YOW4wMsZNirknQ==
=EERG
-----END PGP SIGNATURE-----

--------------WiOqf08jWz25Zpk2ewlzi5CT--
