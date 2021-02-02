Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AD4CC43381
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Feb 2021 17:49:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E14F64F6D
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Feb 2021 17:49:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237873AbhBBRsi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Feb 2021 12:48:38 -0500
Received: from dd49818.kasserver.com ([85.13.165.158]:53954 "EHLO
        dd49818.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237874AbhBBRqJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Feb 2021 12:46:09 -0500
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Feb 2021 12:46:08 EST
Received: from [192.168.179.70] (dynamic-077-012-061-119.77.12.pool.telefonica.de [77.12.61.119])
        by dd49818.kasserver.com (Postfix) with ESMTPSA id 0BBF05680163;
        Tue,  2 Feb 2021 18:39:23 +0100 (CET)
Subject: Re: [PATCH nft 2/2] payload: check icmp dependency before removing
 previous icmp expression
To:     Eric Garver <eric@garver.life>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
References: <20210201215005.26612-1-fw@strlen.de>
 <20210201215005.26612-2-fw@strlen.de>
 <20210202132102.GY3286651@egarver.remote.csb>
From:   Michael Biebl <biebl@debian.org>
Message-ID: <27012ffa-87a9-b313-007f-6ef77be9448b@debian.org>
Date:   Tue, 2 Feb 2021 18:39:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210202132102.GY3286651@egarver.remote.csb>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uMp2931bQ8ZkmB7HZyaINd7Rymsq7Z9dt"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uMp2931bQ8ZkmB7HZyaINd7Rymsq7Z9dt
Content-Type: multipart/mixed; boundary="SNlvuaQB88fzfhXuc55OeO33qYB0td0sD";
 protected-headers="v1"
From: Michael Biebl <biebl@debian.org>
To: Eric Garver <eric@garver.life>, Florian Westphal <fw@strlen.de>,
 netfilter-devel@vger.kernel.org
Message-ID: <27012ffa-87a9-b313-007f-6ef77be9448b@debian.org>
Subject: Re: [PATCH nft 2/2] payload: check icmp dependency before removing
 previous icmp expression
References: <20210201215005.26612-1-fw@strlen.de>
 <20210201215005.26612-2-fw@strlen.de>
 <20210202132102.GY3286651@egarver.remote.csb>
In-Reply-To: <20210202132102.GY3286651@egarver.remote.csb>

--SNlvuaQB88fzfhXuc55OeO33qYB0td0sD
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Am 02.02.21 um 14:21 schrieb Eric Garver:
> On Mon, Feb 01, 2021 at 10:50:04PM +0100, Florian Westphal wrote:
>> nft is too greedy when removing icmp dependencies.
>> 'icmp code 1 type 2' did remove the type when printing.
>>
>> Be more careful and check that the icmp type dependency of the
>> candidate expression (earlier icmp payload expression) has the same
>> type dependency as the new expression.
>>
>> Reported-by: Eric Garver <eric@garver.life>
>> Reported-by: Michael Biebl <biebl@debian.org>
>> Fixes: d0f3b9eaab8d77e ("payload: auto-remove simple icmp/icmpv6 depen=
dency expressions")
>> Signed-off-by: Florian Westphal <fw@strlen.de>
>> ---
>=20
> Tested-by: Eric Garver <eric@garver.life>
>=20
> Thanks Florian. This fixes the issue [1] reported against firewalld.
>=20
> [1]: https://github.com/firewalld/firewalld/issues/752

I can confirm that as well.


Regards,
Michael


--SNlvuaQB88fzfhXuc55OeO33qYB0td0sD--

--uMp2931bQ8ZkmB7HZyaINd7Rymsq7Z9dt
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEECbOsLssWnJBDRcxUauHfDWCPItwFAmAZjkoFAwAAAAAACgkQauHfDWCPItwU
dA/+Mx8hNXcCnABm/VIPTzJmP8EmcGCptxU9UN+EkGXNnWpNoJpQQh2Iix3ZkBz8PeyCx89oLoXG
c6lPXani3xCmmGlzv1llsrdI9BBaEE+a1KM/QG8avJ9AAAgsbNAnGuDMurnGMhCBwfjeKXMsN5AI
w0MYe58aN8fC3tbmF1a91xcwuJtx8MMgylsq/KbMxOx9pmZp9oY0rXn8cx+fOA1vtvBp9DljK9Iu
QlZpq0M70+C5Te5SXbv91CzfWO8CxTvWcutTe43EYTSLl6RqwhDkJt58/rCHh56lwu45TRMCDH5h
1ovZ6iMH0rNDfzcWxFipDlryLuhK3F1RYXtDGclfnMa5DW89Q+ulle4ksRq07zwGW6Gw6yP0tSNP
V+dTHpRpHLmPeXIgmOoXw8JO1R4BfRrTSeKlDOP3B3OCL27cAbnYoIryPdQR38WM+lAy4mPpS/vB
h8WinjTT6fkld0BlPSHFMz4gQnAui931pO95raC4HRVQxdky20fC9VHjgfMYETAMq43NAPbkY2o6
Oer6aUKSawHrMEfb+P4bpEdc9IkDMUVE+coiweGBIjvXNTmx0I47/rSvKI9Aqr3RzTXC5z6zg4Jt
G0n2fqQvE9JCZFXO0U4Pax6i2X8/pje/dpIALFfI204We0+hnvDQWPL8CsCBK9/Vk54IiXRydiAn
AVQ=
=rrq9
-----END PGP SIGNATURE-----

--uMp2931bQ8ZkmB7HZyaINd7Rymsq7Z9dt--
