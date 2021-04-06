Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5BA3C433B4
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 11:21:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E45F6128B
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 11:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242088AbhDFLVp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 07:21:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:56642 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242052AbhDFLVo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 07:21:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BF4E9B14C;
        Tue,  6 Apr 2021 11:21:35 +0000 (UTC)
Subject: Re: [PATCH 1/2] ebtables: processing '--concurrent' beofore other
 arguments
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Firo Yang <firo.yang@suse.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Simon Lees <SimonF.Lees@suse.com>
References: <20210401040741.15672-1-firo.yang@suse.com>
 <20210401040741.15672-2-firo.yang@suse.com> <20210403181517.GA4624@salvia>
 <20210403182204.GA5182@salvia>
 <6cc20464d5814fe899d7fb1e21d5488c@DB8PR04MB5881.eurprd04.prod.outlook.com>
 <f5efb453-0197-658c-1886-a4d88fc3b193@suse.de>
 <64466cd69b054f5d803722dfbcf8c4be@DB8PR04MB5881.eurprd04.prod.outlook.com>
From:   Simon Lees <sflees@suse.de>
Message-ID: <d135ba6e-aa30-9a1d-136c-56a96aa10da6@suse.de>
Date:   Tue, 6 Apr 2021 20:51:30 +0930
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <64466cd69b054f5d803722dfbcf8c4be@DB8PR04MB5881.eurprd04.prod.outlook.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HFodkxwA44CCim5ptvNm1LOimnvyRxDAp"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HFodkxwA44CCim5ptvNm1LOimnvyRxDAp
Content-Type: multipart/mixed; boundary="QaoDH4Bozqh8F93YUXHpjgPGWvvPVE8Zq";
 protected-headers="v1"
From: Simon Lees <sflees@suse.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Firo Yang <firo.yang@suse.com>,
 "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
 Simon Lees <SimonF.Lees@suse.com>
Message-ID: <d135ba6e-aa30-9a1d-136c-56a96aa10da6@suse.de>
Subject: Re: [PATCH 1/2] ebtables: processing '--concurrent' beofore other
 arguments
References: <20210401040741.15672-1-firo.yang@suse.com>
 <20210401040741.15672-2-firo.yang@suse.com> <20210403181517.GA4624@salvia>
 <20210403182204.GA5182@salvia>
 <6cc20464d5814fe899d7fb1e21d5488c@DB8PR04MB5881.eurprd04.prod.outlook.com>
 <f5efb453-0197-658c-1886-a4d88fc3b193@suse.de>
 <64466cd69b054f5d803722dfbcf8c4be@DB8PR04MB5881.eurprd04.prod.outlook.com>
In-Reply-To: <64466cd69b054f5d803722dfbcf8c4be@DB8PR04MB5881.eurprd04.prod.outlook.com>

--QaoDH4Bozqh8F93YUXHpjgPGWvvPVE8Zq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 4/6/21 7:22 PM, Pablo Neira Ayuso wrote:
> Hi,
>=20
> On Tue, Apr 06, 2021 at 05:29:11PM +0930, Simon Lees wrote:
>>
>>
>> On 4/6/21 12:27 PM, Firo Yang wrote:
>>> The 04/03/2021 20:22, Pablo Neira Ayuso wrote:
>>>> On Sat, Apr 03, 2021 at 08:15:17PM +0200, Pablo Neira Ayuso wrote:
>>>>> Hi,
>>>>>
>>>>> On Thu, Apr 01, 2021 at 12:07:40PM +0800, Firo Yang wrote:
>>>>>> Our customer reported a following issue:
>>>>>> If '--concurrent' was passed to ebtables command behind other argu=
ments,
>>>>>> '--concurrent' will not take effect sometimes; for a simple exampl=
e,
>>>>>> ebtables -L --concurrent. This is becuase the handling of '--concu=
rrent'
>>>>>> is implemented in a passing-order-dependent way.
>>>>>>
>>>>>> So we can fix this problem by processing it before other arguments=
=2E
>>>>>
>>>>> Would you instead make a patch to spew an error if --concurrent is =
the
>>>>> first argument?
>>>>
>>>> Wrong wording:
>>>>
>>>> Would you instead make a patch to spew an error if --concurrent is
>>>> _not_ the first argument?
>>>
>>> Hi Pablo, I think it would make more sense if we don't introduce this=

>>> inconvenice to users. If you insist, I would go create the patch as y=
ou
>>> intended.
>>
>> Agreed, that also wouldn't be seen as a workable solution for us "SUSE=
"
>> as our customers who may have scripts or documented processes where
>> --concurrent is not first and such a change would be considered a
>> "Change in behavior" as such we can't ship it in a bugfix or minor
>> version update, only in the next major update and we don't know when
>> that will be yet.
>>
>> Sure this is probably only a issue for enterprise distro's but such a
>> change would likely inconvenience other users as well.
>=20
> --concurrent has never worked away from the early positions ever.
>=20
> What's the issue?

We had a customer complaining about the change in ordering causing
different results with one way working and the other not, looking back
at the report a second time I don't think they were ever using the "non
working way" in production but just to debug the other issue.

--=20
Simon Lees (Simotek)                            http://simotek.net

Emergency Update Team                           keybase.io/simotek
SUSE Linux                           Adelaide Australia, UTC+10:30
GPG Fingerprint: 5B87 DB9D 88DC F606 E489 CEC5 0922 C246 02F0 014B


--QaoDH4Bozqh8F93YUXHpjgPGWvvPVE8Zq--

--HFodkxwA44CCim5ptvNm1LOimnvyRxDAp
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEED0hBIYMo9ADHKtZgEdQumr4Y/JEFAmBsRDoFAwAAAAAACgkQEdQumr4Y/JHL
HwgAiC0vYahr1eAI1g24809ODVx1KWB6xSJprGufLASW/o4MHjaeMEBcbS7AmRPXoC7zEYbKIkis
CckqVBgx7m1swSdlnJySy3SyvbG1CvDzLEmG1+V77B//T+SVUwCGCEH9aeSlNcdyUwleD7qmkNnr
dv4IMngfjTEcprYAXCJ9/+ZlZkKH/sLNEw5gnap9QX5omBKblH17Q32+vixVVyPuy2qO96P/Aah9
ChipdpyYG5xoi4AYW43LRL9LJbQt/SXUomKMAA1rcUj5OrAl9QaFbNit1f3XZZQNcxfngMtfAFkK
LA9Y5uchBmC+XCAUszPbhmt1QKm8P1/Ye+peKixYqQ==
=q6Xi
-----END PGP SIGNATURE-----

--HFodkxwA44CCim5ptvNm1LOimnvyRxDAp--
