Return-Path: <SRS0=jWs9=AB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4957C433DF
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Jun 2020 21:17:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FEC5246C0
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Jun 2020 21:17:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=average.org header.i=@average.org header.b="fq1rSBfp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbgFTVRT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 20 Jun 2020 17:17:19 -0400
Received: from dehost.average.org ([88.198.2.197]:52092 "EHLO
        dehost.average.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728891AbgFTVRS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Jun 2020 17:17:18 -0400
Received: from [IPv6:2a02:8106:1:6800::640] (unknown [IPv6:2a02:8106:1:6800::640])
        by dehost.average.org (Postfix) with ESMTPSA id 14E48354C9CE;
        Sat, 20 Jun 2020 23:17:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=average.org; s=mail;
        t=1592687829; bh=XKlh8w1b9GfZdeNtUSMvhSUrALwkftwavguCL9NI0hE=;
        h=To:Cc:References:From:Subject:Date:In-Reply-To:From;
        b=fq1rSBfpyvaPjW8leTFzw2wMMhakmJUtiMVIImnTtepaVWZgqFeLP+pj+HUgCr0MH
         S51Knz0f5mf8wBrtonrzYOvUL7gI26D4hBmrQo/xGk9zXSUygCT7vIjKutq7/x1zTG
         DW0WhFXRFpfoYbQzG6gduvnUz15nsF9Qq3d6vF2Q=
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jan Engelhardt <jengelh@inai.de>,
        netfilter-devel@vger.kernel.org
References: <76cd59a3-6403-9408-1b8c-af5f11d5fa85@average.org>
 <nycvar.YFH.7.77.849.2006161717590.16107@n3.vanv.qr>
 <1566db8a-00d4-d9de-8c3d-6625fe2149fa@average.org>
 <nycvar.YFH.7.77.849.2006161830320.16707@n3.vanv.qr>
 <874fd8a8-dfd2-f6c3-ae01-61884ca9bcff@average.org>
 <20200619151530.GA3894@salvia>
 <13977ee9-d93b-62fd-c86a-6c4466f63e38@average.org>
 <20200620110404.GF26990@breakpoint.cc>
From:   Eugene Crosser <crosser@average.org>
Autocrypt: addr=crosser@average.org; prefer-encrypt=mutual; keydata=
 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
Subject: Re: Expose skb_gso_validate_network_len() [Was: ebtables:
 load-on-demand extensions]
Message-ID: <2dad5797-6643-da2b-3dcf-350d1d501be1@average.org>
Date:   Sat, 20 Jun 2020 23:16:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200620110404.GF26990@breakpoint.cc>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="LjL89XtcEW3bvr1tbzWpzMSmqvQDMFRYY"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LjL89XtcEW3bvr1tbzWpzMSmqvQDMFRYY
Content-Type: multipart/mixed; boundary="oDfbZjgxzIDXJJESRwzOFNozYoHTVZy6j";
 protected-headers="v1"
From: Eugene Crosser <crosser@average.org>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Jan Engelhardt
 <jengelh@inai.de>, netfilter-devel@vger.kernel.org
Message-ID: <2dad5797-6643-da2b-3dcf-350d1d501be1@average.org>
Subject: Re: Expose skb_gso_validate_network_len() [Was: ebtables:
 load-on-demand extensions]
References: <76cd59a3-6403-9408-1b8c-af5f11d5fa85@average.org>
 <nycvar.YFH.7.77.849.2006161717590.16107@n3.vanv.qr>
 <1566db8a-00d4-d9de-8c3d-6625fe2149fa@average.org>
 <nycvar.YFH.7.77.849.2006161830320.16707@n3.vanv.qr>
 <874fd8a8-dfd2-f6c3-ae01-61884ca9bcff@average.org>
 <20200619151530.GA3894@salvia>
 <13977ee9-d93b-62fd-c86a-6c4466f63e38@average.org>
 <20200620110404.GF26990@breakpoint.cc>
In-Reply-To: <20200620110404.GF26990@breakpoint.cc>

--oDfbZjgxzIDXJJESRwzOFNozYoHTVZy6j
Content-Type: text/plain; charset=koi8-r
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 20/06/2020 13:04, Florian Westphal wrote:

>>>>>>> Why not make a patch to publicly expose the skb's data via nft_me=
ta?
>>>>>>> No more custom modules, no more userspace modifications [..]
>>>>>>
>>>>>> For our particular use case, we are running the skb through the ke=
rnel
>>>>>> function `skb_validate_network_len()` with custom mtu size [..]

>> makes sense to implement the functionality that we need within the "ne=
w" nft
>> infrastructure.
>=20
> Yes, just do what Jan suggested and expost this in nft_meta.c
>=20
>> As far as I understand, the part that is missing in the existing imple=
mentation
>> is exposure (in some form) of `skb_gso_validate_network_len()` functio=
n to
>> user-configurable filters.
>=20
> No, nft already has "< $value" logic.
> The only missing piece of the puzzle is a way to populate an nft
> register with the "size per segment" value.

I don't think that it works. `skb_gso_network_seglen()` gives the (same f=
or all
segments) segment length _only_ when `shinfo->gso_size !=3D GSO_BY_FRAGS`=
=2E If we
were to expose maximum segment length for skbs with `gso_size =3D=3D GSO_=
BY_FRAGS`,
we'd need a new function that basically replicates the functionality of
`skb_gso_size_check()` and performs `skb_walk_frags()`, only instead of
returning `false` on first violation finds and then returns the maximum
encoutered value.

That means we'd need to introduce a new function for the sole purpose of =
making
the proposed check fit in the "less-equal-greater" model. And the only pr=
actical
use of the feature is to check "fits-doesn't fit" anyway. It would seem l=
ogical
to rather use the kernel function that already exists and already has the=

"fits-doesn't fit" semantic.

Do you think this is a valid argument to implement a boolean predicate ra=
ther
than expose an arithmetic value?

Regards,

Eugene

>> Because the kernel does now expose the _size_ under
>> which a gso skb can be segmented, but only the _boolean_ with the mean=
ing "this
>> gso skb can fit in mtu that you've specified",
>=20
> It would be best to remove "static" from skb_gso_network_seglen() and
> add an EXPORT_SYMBOL_GPL for it.
>=20
> Then, extend nft_meta.c to set register content to that for gso
> or the ip/ipv6 packet size for !gso.
>=20
> Then, extend nft to support something like
>=20
>       nft insert rule bridge filter FORWARD \
>         ip frag-off & 0x4000 !=3D 0 \
>         ip protocol tcp \
> 	meta nh_segment_length > 1400 \
>         reject with icmp type frag-needed
>=20
> [ NB: I suck at naming, so feel free to come up
>   with somethng more descriptive than "nh_segment_length".
>   l3size? nh-len...? ]
>=20



--oDfbZjgxzIDXJJESRwzOFNozYoHTVZy6j--

--LjL89XtcEW3bvr1tbzWpzMSmqvQDMFRYY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEnAziRJw3ydIzIkaHfKQHw5GdRYwFAl7ufM8ACgkQfKQHw5Gd
RYz+Egf/dWgnPUbYhvjYZbmxM38mtj+mHDaGpxWUMG3zTbO9D8ebt/6m/ulI6CS2
dxDgVeqQYxkYZPVTpLJF0lrrmaRlcuoFbYSVU+ulUWHB27Ldfmjb3gfUfu4LXQEC
LYL1ULTjI6Z8PJmNjzLOl0hpVx+36szKpEJjl/1zaG7YXWwc/Botyq4ub8uxWHoa
w3U/u4DMYMo04p1McptHILnJGi0D+z5LxFchYkc1nwvecPgFDcC1SQ3exjC1S4u7
/RmZyFuNvzlloy+b9qIK5obJJMslFLLq8Fdu5jfiuxtRO3p9sXJ3lFeBngrKWwF1
Ygz0t8D9LMAS2JWOumbhouDg3uKJ/w==
=a/hQ
-----END PGP SIGNATURE-----

--LjL89XtcEW3bvr1tbzWpzMSmqvQDMFRYY--
