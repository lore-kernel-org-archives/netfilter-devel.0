Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64D10C433ED
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 07:59:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28011613C0
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 07:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235945AbhDFH7Z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 03:59:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:58292 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235940AbhDFH7Z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 03:59:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C113CB013;
        Tue,  6 Apr 2021 07:59:16 +0000 (UTC)
To:     Firo Yang <firo.yang@suse.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Simon Lees <SimonF.Lees@suse.com>
References: <20210401040741.15672-1-firo.yang@suse.com>
 <20210401040741.15672-2-firo.yang@suse.com> <20210403181517.GA4624@salvia>
 <20210403182204.GA5182@salvia>
 <6cc20464d5814fe899d7fb1e21d5488c@DB8PR04MB5881.eurprd04.prod.outlook.com>
From:   Simon Lees <sflees@suse.de>
Subject: Re: [PATCH 1/2] ebtables: processing '--concurrent' beofore other
 arguments
Message-ID: <f5efb453-0197-658c-1886-a4d88fc3b193@suse.de>
Date:   Tue, 6 Apr 2021 17:29:11 +0930
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <6cc20464d5814fe899d7fb1e21d5488c@DB8PR04MB5881.eurprd04.prod.outlook.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FTvxt5LtzBbJt3yUd0v8eJfuVLdztk9Cb"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FTvxt5LtzBbJt3yUd0v8eJfuVLdztk9Cb
Content-Type: multipart/mixed; boundary="cKl1IvHn5VMhWlPMUBAi7Mvm2GCH66hQ4";
 protected-headers="v1"
From: Simon Lees <sflees@suse.de>
To: Firo Yang <firo.yang@suse.com>, Pablo Neira Ayuso <pablo@netfilter.org>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
 Simon Lees <SimonF.Lees@suse.com>
Message-ID: <f5efb453-0197-658c-1886-a4d88fc3b193@suse.de>
Subject: Re: [PATCH 1/2] ebtables: processing '--concurrent' beofore other
 arguments
References: <20210401040741.15672-1-firo.yang@suse.com>
 <20210401040741.15672-2-firo.yang@suse.com> <20210403181517.GA4624@salvia>
 <20210403182204.GA5182@salvia>
 <6cc20464d5814fe899d7fb1e21d5488c@DB8PR04MB5881.eurprd04.prod.outlook.com>
In-Reply-To: <6cc20464d5814fe899d7fb1e21d5488c@DB8PR04MB5881.eurprd04.prod.outlook.com>

--cKl1IvHn5VMhWlPMUBAi7Mvm2GCH66hQ4
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 4/6/21 12:27 PM, Firo Yang wrote:
> The 04/03/2021 20:22, Pablo Neira Ayuso wrote:
>> On Sat, Apr 03, 2021 at 08:15:17PM +0200, Pablo Neira Ayuso wrote:
>>> Hi,
>>>
>>> On Thu, Apr 01, 2021 at 12:07:40PM +0800, Firo Yang wrote:
>>>> Our customer reported a following issue:
>>>> If '--concurrent' was passed to ebtables command behind other argume=
nts,
>>>> '--concurrent' will not take effect sometimes; for a simple example,=

>>>> ebtables -L --concurrent. This is becuase the handling of '--concurr=
ent'
>>>> is implemented in a passing-order-dependent way.
>>>>
>>>> So we can fix this problem by processing it before other arguments.
>>>
>>> Would you instead make a patch to spew an error if --concurrent is th=
e
>>> first argument?
>>
>> Wrong wording:
>>
>> Would you instead make a patch to spew an error if --concurrent is
>> _not_ the first argument?
>=20
> Hi Pablo, I think it would make more sense if we don't introduce this
> inconvenice to users. If you insist, I would go create the patch as you=

> intended.

Agreed, that also wouldn't be seen as a workable solution for us "SUSE"
as our customers who may have scripts or documented processes where
--concurrent is not first and such a change would be considered a
"Change in behavior" as such we can't ship it in a bugfix or minor
version update, only in the next major update and we don't know when
that will be yet.

Sure this is probably only a issue for enterprise distro's but such a
change would likely inconvenience other users as well.

Cheers

--=20
Simon Lees (Simotek)                            http://simotek.net

Emergency Update Team                           keybase.io/simotek
SUSE Linux                           Adelaide Australia, UTC+10:30
GPG Fingerprint: 5B87 DB9D 88DC F606 E489 CEC5 0922 C246 02F0 014B


--cKl1IvHn5VMhWlPMUBAi7Mvm2GCH66hQ4--

--FTvxt5LtzBbJt3yUd0v8eJfuVLdztk9Cb
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB4BAABCAAjFiEED0hBIYMo9ADHKtZgEdQumr4Y/JEFAmBsFM8FAwAAAAAACgkQEdQumr4Y/JGz
Pwf4zAJ0SwoSl0Q9v0bFza/UdMwaL0gwYu+YNakjBvx/0hWnJELVxF0jgQlvpD/VKQHfpYTiOAc0
uwhqlihMnqbonZc40qv5fYOYbCkfUfnRMdkJvustX1mOppjAKW6OAum8vVTpjdkoZkmzW1tM7KUt
RtvReleETnpP1h54CQz3MgmmW18NH9QrZ+uhWd6XG+KAEP96SfvP43CZFOVD9kPJ3a5wQ5z0t4gS
i9lZ6IqHDrq6Gr8a9ZSZRs7HJ923yQHpw8kZE+FUBLBM894awgm4YcAFckbnKBMjPk4JsvBVdbdb
ECjln5w8+2XlfggRCST8S924cMNwzt8diDGbLpyc
=9PZ7
-----END PGP SIGNATURE-----

--FTvxt5LtzBbJt3yUd0v8eJfuVLdztk9Cb--
