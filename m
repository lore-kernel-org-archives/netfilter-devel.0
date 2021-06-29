Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 987C3C11F67
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Jun 2021 16:50:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AA1C61DA6
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Jun 2021 16:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbhF2Qwe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Jun 2021 12:52:34 -0400
Received: from sonic314-16.consmr.mail.bf2.yahoo.com ([74.6.132.126]:36420
        "EHLO sonic314-16.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232441AbhF2Qwe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 12:52:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=att.net; s=s1024; t=1624985406; bh=uf5qnL8WDsMQ9brNGDhaz0vro48oCRisEEr41Oy97sA=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=EM/x60Z+QewWfXt83sYd9hzvzTNOvwyfSFq4scYurHzhpE4gj9mOEKe9ZJeCW5XZwmUl29qd9W/GhDBM+1dTLw3UELQktrp4ZVz3TbC6qs4T1tSO1P6bqSxOkYZbTnxaxgN92ZbQVPiJToyFwWvbo3E5JH1+//erFAsZZVMg+bU=
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1624985406; bh=qQLm/0PGIMKpSZpiU3NbLfjXNFZ++fVTESgVWc/8r26=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=jL+pCKoPFuqq7n6gicYfwVdMbYQkH73NwsJBQgRQnucm55+50xqU+4DzWA2nAoxyRL0bxRWci8fVVtqx5LnECViRZdsL5DLObJHevfkRclnqeY6Ep5G1QI92bTH84yYKHdozsEcKUrZ97mydTJev0IzEwqdTUFwIO248G6pt+ynPP3jnqAbT1oPB/A79r2FoRzoKm9btFhLAv5BopZfpPP5UqSRJGWI/ChU4zqo+oCmyXK6b+OxZO0e34JOAVLteRq3wQgrGvNLrHJaBHIFtAvMwhiqYuY0QYH6qgniCeMOYNchZNEYrgyFVDflMzAZXsIJ2jCvVWaUiW538GVAWow==
X-YMail-OSG: tvn8YvIVM1kuEqoQQ.wgOkKJIq8.KNTjC.toCV4LkI34os7syl82JGhVH2GFpT2
 dxMzEfGI4VnmhcB5dwy_1yM3cZyyWFwrLRbS6bB9JEMsT56oyeBNyp9gyGIwwvLkkVDz7ERG7cnY
 ryb2pQWoUtNDfmp9t6lpWO1KLHYVRe7dE.k04YdQEtp9ZqGJO5GjAmrY63xcgnf0A4dTQvX2rDp9
 j24PVEpwj8Z5._nv05x4D8IfrfqmAdBnEN1eTL7mmLEwJ3PykigrboYNaucS4rB9FdY5hSvm1_tr
 0BFlPAcpVO4zm9Spsd4YD0p1EJtEW8783fCGNnzLkTZtMn.OdB2MKpS4V0WjGBo.oAJy1n_xmp9h
 LsTArCeUwtE_ahXowUr4gjvvrDolwHE7Js5uG5qM5i.1ssdb6QB_lMVGzPzu4wNedayXDE59_nIF
 9BCgG1AXyt8fuqRiw8O7oX3dfDPHyoKn.8oTd7mKqPp_urBITWlfa2rEaEw9kXhQyq0swiOlv2kM
 .GHIJlptQ7LC0QSvwxS__FHDF3ygviJ8MrL26f0XPtCYm4F9lgYDJaggiOK1X6IUU_N9DiOo.UzP
 SrLfNmd2sB7Haa7A3Wc9Be5kvtjj6KY05e5INSxiEQd0FdAT2wQ4gGsCQ.QmsJIyLX7hdXP2C4_f
 EtomGLGmM6ZrOeXXn_VFCFrQUHVyUF9FT5irdokxdyQPxhA7WrluOz_MzsBaTAZKEquMetL7kqrb
 MWi0JKYMT8GlTOqnu4Hd1C284kyGyTUr9nTxa3zkKOGyMwxnJn1.JkDTQcJHPE_ZSkKLXNw4sqrK
 6BplEbKAoelXkBSpxc5.uIqwJfwx7C7OhcGgJMl5R7yp5mDf.ztvFpUbOsFjql4l5Gd6kwUnTjrN
 uUWSS2Fj22Jx9Rn9x7mOR2zVQlsjF_YUKS8P.kD4c3vxUWVLi2x3qIEeJ4sWmnOigggtagnpOUI.
 SRXmT012E8udOONROeISgbW1Uvwfl1QsOd1cKrN19_25eIeg562rCgxuN6PAEbAQEMKLtuI7aofi
 1W.zPqqBl0izNaYSrc2DbkwmWUaLDI71yuLaAopNm_0hXoW2mhIHRaCro9kVjO6aHI7WZEjs4dF4
 5lAzN8THRQz4XWnY0M54ohCC0YGRJgVeE4vEUvDHGsW49FWLStA_xrxCjP3hS6_BE7RFh_oEf8PT
 c6omHXmptYkMvt3.Uao6icVYXGpN.G0eRBtKfc3ovFbip2mM5DJ3kbORAJ7ks8YOKBy.Due75YlL
 Eg_n0bz5CpBvEe7vYbbPyFyRJOZez6htmtTZpS5K3fWd3EZaJcSQWEvb8Epw.F5k7ISWLb1tzVrX
 6JudaxmL9QRCkYE12FfZ5bVtd2OFOmzV6.uXNJ2oTXCdoXuV08xEZNPTNlLCTNd.G1COTP9dmgoT
 twD6q1yu6._gp05GElple8TosGgrjccXmECPOlsakjIXYCED3zlWHtFQj3QOKOuDsnsZCDx0PruO
 Vgwyuj7Ch_eeJ1NCXD3Mrw9L8hiAHgmG_.AzLsfgy3brtia6fwQD2i2t74t_VuFsfYliFf14dPpp
 _2u42iYNJGIifv5eBzdgdv1tr4N8hETAdGGfSJHmCsRiCn7aURKvpwn6g2w8on6MFv_JUvIcKSjc
 utHd2U7o7gfKj_BHoMiEtm9K2k0GoXrXp1OXeApmWQBmXjvoIITMkavofmesQ6MyIoDBsy.Ne8mH
 AkRxvIcqisA3deanuWoNonFDYATK51IhqmZqYvMUU05SFBmN8hkOGdiivsKkC1sC5T_eUP_DwIsS
 3ZlQOkEHjNvt2ICYkhKgsDWmwu5li0WslcUnvTrd3AvSGR0RJpYqANWxqB4xhu9jyY8IxrwtEPgF
 iGsJVnsL33LjOZ7p6xitJjCGGXvf7K9mx8C0sNrCRQf7GkgiGjLgjDYntaemmNUNVM7e.WAPa_1.
 14qoJawHNtfsqTXXaBfmS1Qa8It.8Hx4dlKQTFFt8g4yYyZkpUkdKB46eiSwZWEk7mYLcCjY8eM3
 BnSWV8j560sIaNEeWL5wVGiL6m74NNLKzRRyybQ3kk52TZgez2ogsKB7nLpa55bXx2Lzg2NK3.ki
 4paox2LjelXNJGGYvZJ_85S2ku5Tt93ogvH_Zgg9aWcZ.ZeTb83eBAsfuSbBPeM21eUmwYhkUk7X
 8iABZjqlVveu4bCvVUo.a8CNo7wNRhMpMSLv6SIEiccHuJM9Iit66kM1GTHMXU9jPiSq2Q8CjfbB
 Lg8aR5KMDS04o7CpW2sCjbVctoPjBviwnHPTYDH7kXWfH87EgZJHofo0D59k_y7gQVZtoudbEt_T
 mGEKDAl7KR_hEP98qGm0lsyhEqXY8okfJwMuDByEcSjykOb0bT0.xW2TgUOT6W9oo8JV0SfmemDL
 3qmGKBwm.hPxgpOYI00VoZdDcJF0m47tohQLG9lnUrsPEYtUntvVvNJlHrwSn._FRpMgYPYP_Lu9
 HrzoORp8B_d0P4OIiK33hPBXTnWCak2OVEWOX9zUD1vkHScQzTY2jHoXNUhhG2HkLiw9q58e8lQk
 b
X-Sonic-MF: <slow_speed@att.net>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.bf2.yahoo.com with HTTP; Tue, 29 Jun 2021 16:50:06 +0000
Received: by kubenode547.mail-prod1.omega.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 2615a61c5a1882de5a1becaac5a8bb23;
          Tue, 29 Jun 2021 16:50:04 +0000 (UTC)
Subject: Re: Reload IPtables
To:     Reindl Harald <h.reindl@thelounge.net>,
        "Neal P. Murphy" <neal.p.murphy@alum.wpi.edu>
Cc:     netfilter-devel@vger.kernel.org
References: <08f069e3-914f-204a-dfd6-a56271ec1e55.ref@att.net>
 <08f069e3-914f-204a-dfd6-a56271ec1e55@att.net>
 <4ac5ff0d-4c6f-c963-f2c5-29154e0df24b@hajes.org>
 <6430a511-9cb0-183d-ed25-553b5835fa6a@att.net>
 <877683bf-6ea4-ca61-ba41-5347877d3216@thelounge.net>
 <d2156e5b-2be9-c0cf-7f5b-aaf8b81769f8@att.net>
 <f5314629-8a08-3b5f-cfad-53bf13483ec3@hajes.org>
 <adc28927-724f-2cdb-ca6a-ff39be8de3ba@thelounge.net>
 <96559e16-e3a6-cefd-6183-1b47f31b9345@hajes.org>
 <16b55f10-5171-590f-f9d2-209cfaa7555d@thelounge.net>
 <54e70d0a-0398-16e4-a79e-ec96a8203b22@tana.it>
 <f0daea91-4d12-1605-e6df-e7f95ba18cac@thelounge.net>
 <8395d083-022b-f6f7-b2d3-e2a83b48c48a@tana.it>
 <20210628104310.61bd287ff147a59b12e23533@plushkava.net>
 <20210628220241.64f9af54@playground>
 <c78c189b-efad-0d20-fa9e-989c828d7067@att.net>
 <9dab1af3-3041-0fc0-e5d0-bd377ede37a3@thelounge.net>
From:   slow_speed@att.net
Message-ID: <6e79f7e4-2954-b1e6-2efe-201cdf867d32@att.net>
Date:   Tue, 29 Jun 2021 12:50:03 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <9dab1af3-3041-0fc0-e5d0-bd377ede37a3@thelounge.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Mailer: WebService/1.1.18469 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 6/29/21 11:18 AM, Reindl Harald wrote:
>=20
>=20
> Am 29.06.21 um 16:52 schrieb slow_speed@att.net:
>>
>>
>> On 6/28/21 10:02 PM, Neal P. Murphy wrote:
>>> On Mon, 28 Jun 2021 10:43:10 +0100
>>> Kerin Millar <kfm@plushkava.net> wrote:
>>>
>>>> Now you benefit from atomicity (the rules will either be committed=20
>>>> at once, in full, or not at all) and proper error handling (the exit=
=20
>>>> status value of iptables-restore is meaningful and acted upon).=20
>>>> Further, should you prefer to indent the body of the heredoc, you=20
>>>> may write <<-EOF, though only leading tab characters will be=20
>>>> stripped out.
>>>>
>>>
>>> [minor digression]
>>>
>>> Is iptables-restore truly atomic in *all* cases? Some years ago, I=20
>>> found through experimentation that some rules were 'lost' when=20
>>> restoring more than 25 000 rules. If I placed a COMMIT every 20 000=20
>>> rules or so, then all rules would be properly loaded. I think COMMITs=
=20
>>> break atomicity. I tested with 100k to 1M rules. I was comparing the =

>>> efficiency of iptables-restore with another tool that read from=20
>>> STDIN; the other tool was about 5% more efficient.
>>>
>>
>> Please explain why you might have so many rules.=C2=A0 My server is pu=
shing=20
>> it at a dozen
>=20
> likely because people don't use "ipset" and "chains" instead repeat the=
=20
> same stuff again and again so that every single package has to travel=20
> over hundrets and thousands of rules :-)

Exactly my thoughts.  Of course I understand that there may be long=20
lists in some odd situations, but I wonder what kind of server is being=20
referenced.

