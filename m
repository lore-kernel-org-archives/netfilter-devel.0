Return-Path: <SRS0=LaOm=Z3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 946F2C43603
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Dec 2019 09:46:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A44F2464D
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Dec 2019 09:46:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=darbyshire-bryant.me.uk header.i=@darbyshire-bryant.me.uk header.b="uEv7fQB0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbfLEJqo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Dec 2019 04:46:44 -0500
Received: from mail-eopbgr00055.outbound.protection.outlook.com ([40.107.0.55]:55714
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728604AbfLEJqn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Dec 2019 04:46:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MOiZUOiqQF4FRrqZrXYdA8scWCtqISy30mfvx6JQBU+VMdfnsZZBv0D/yQDfTLnkHAA4gCWiU/twXOnXvvSS14kWKhUE00J/5rZm5QKz7sAdFVaxd0aMT4gRgyD4/XDD2iA/SfzrojWVT7dSLtItfnoDUciv949qWY3CdHPloalKCPqztfQpi/6tVGo3qo5qhqqJZgA1AlpCePWZPJZtn+jvNaDAWR9Y77D/K+m+QRjCrdmpLFGT5IJYCnbjhEF5D8+aMXp0lvsBV0xSEwGgWpeEe7g+oPcJm3db34U5+lXE4D2xFsjfU6RihNy/u603tjLI8RS+hz2pe/hcyhrAmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCCcKSYwPDEQiaQ3ikSSIwnDavIriUZfdod0i7bEdg0=;
 b=jq5dukoONKuUhjJ6cbJj0Lu93gNi8puTe4J3+d8vyMvniokxRq47c0f1suz1T68RqJkFMLMVEv36BWllztgL82MhHQ4S8pvnOXwDoQoeOO5juOCkD3Eu0Dg0sK0plXGJinmvq61RdCcPD5tMwyGUUCb3nSiRmx3BBYJwN9xBLTRH5GlkO8k/T89J5MXlEra5oB2kUkgYNbBH71++0hMm7rWSA1pARUbpz7p8Ai9tEH4rZX5Qh8TBmw7BApVGr9m4DaLppluhTtROCHVsWqe9RgXGCWdgd19n+f//YY7ykqU5r8iq5LKpShfoYIvgTYalMBPGH0iD3rSO2fcCkeRSUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=darbyshire-bryant.me.uk; dmarc=pass action=none
 header.from=darbyshire-bryant.me.uk; dkim=pass
 header.d=darbyshire-bryant.me.uk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=darbyshire-bryant.me.uk; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCCcKSYwPDEQiaQ3ikSSIwnDavIriUZfdod0i7bEdg0=;
 b=uEv7fQB0Vouy18ICNLoZSsLxYkmI/dTllaRtVPsrlkQCsde3eZX1jO9YNthlyUf8hZuk5oBDicy8ZHN95IcmOvq15iKdtuU4po+so/f0F0N/fWXzX3cyFKtUF19lH+ACZx0CLtSrbrg/KPfm0TrMFzro5P/jqAJFAeHXwb7NBLI=
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com (10.171.106.21) by
 VI1PR0302MB3263.eurprd03.prod.outlook.com (52.134.15.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.19; Thu, 5 Dec 2019 09:46:39 +0000
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::7585:5ab6:a348:de46]) by VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::7585:5ab6:a348:de46%7]) with mapi id 15.20.2516.014; Thu, 5 Dec 2019
 09:46:38 +0000
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     Jeremy Sowden <jeremy@azazel.net>
CC:     Pablo Neira Ayuso <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH 0/1] netfilter: connmark: introduce set-dscpmark
Thread-Topic: [PATCH 0/1] netfilter: connmark: introduce set-dscpmark
Thread-Index: AQHVqfPPM5lmJGUCOkWeTCiCbHiFfKerP/2AgAAN4gA=
Date:   Thu, 5 Dec 2019 09:46:38 +0000
Message-ID: <DA14999D-D2D2-42C5-91BC-E3A8A7D0AA46@darbyshire-bryant.me.uk>
References: <20190324142314.92539-1-ldir@darbyshire-bryant.me.uk>
 <20191203160652.44396-1-ldir@darbyshire-bryant.me.uk>
 <20191205085657.GF133447@azazel.net>
In-Reply-To: <20191205085657.GF133447@azazel.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ldir@darbyshire-bryant.me.uk; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2a02:c7f:1243:8e00::dc83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 96da1f83-49ca-4bf7-feee-08d779680685
x-ms-traffictypediagnostic: VI1PR0302MB3263:
x-microsoft-antispam-prvs: <VI1PR0302MB326371E8B6E0FDF34A3D31CAC95C0@VI1PR0302MB3263.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(376002)(39830400003)(366004)(396003)(189003)(199004)(99286004)(6916009)(66556008)(14454004)(36756003)(33656002)(2906002)(25786009)(66446008)(6512007)(64756008)(66476007)(76116006)(5660300002)(8936002)(66616009)(102836004)(2616005)(229853002)(316002)(8676002)(81156014)(91956017)(81166006)(186003)(71200400001)(6506007)(4326008)(305945005)(508600001)(54906003)(6486002)(53546011)(76176011)(86362001)(66946007)(71190400001)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0302MB3263;H:VI1PR0302MB2750.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: darbyshire-bryant.me.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yYb1m40cI6It3mC15Xp5ShJFuqeh47okcEFBN8gWHQKRSiX/78MoFFHA29/2nAjyTr46FsRMaHmyKrpE8mbaITLZaWFpsSR1nE/G2oFcCTnBwgKcWb7EzTO/4PD6WHcyNZEnDb4djpLPHjPGyBR2TXTxPxXuCnjWtiFZ7wLOrw9OxPlWS4RZb4QmbA3f+nRJf50n0LNPZSvJvfgLcCOlu/2pHMcZ5U5Su7joihEcHGAVazh5yMLHOcOxr8qGoMuFKd3RtxIPxttEKwAKQwDjZoe38YpziX6EUYWWICMS87ZcQgrG+ed3GfI/BvGJe0RD6yD7QyyflwnEZ5qWmrgzybuxAbiwsYEWILFyKLYMoFSWW+tmbdqiyVZWHYNj7Inu58yGpMrI7ueGPrTDZJogNckmYuhCJVrmBVdfnK3E0bHObF2No0P5yTZf2k7VZHSC
x-ms-exchange-transport-forked: True
Content-Type: multipart/signed;
        boundary="Apple-Mail=_7B69CD29-CE6F-44B6-9F36-7440A47ACE4C";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
MIME-Version: 1.0
X-OriginatorOrg: darbyshire-bryant.me.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: 96da1f83-49ca-4bf7-feee-08d779680685
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 09:46:38.7729
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9151708b-c553-406f-8e56-694f435154a4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XYDzOZpTHM7EROOLIOFkZsVSnVX4Yr7boPhKMPbyqEjyNXxHyXCokNtAQhM9JZpOLBv8r3e6hbZs0nxFQ+tH3VZ78QouT/EDHl2uqMyymLI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB3263
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--Apple-Mail=_7B69CD29-CE6F-44B6-9F36-7440A47ACE4C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On 5 Dec 2019, at 08:56, Jeremy Sowden <jeremy@azazel.net> wrote:
>=20
> On 2019-12-03, at 16:06:52 +0000, Kevin Darbyshire-Bryant wrote:
>> Greetings.  The following patch is similar to one I submitted as an
>> RFC quite a while back (April).  Since then I've realised that the
>> option should have been in the 'set mark' family as opposed to 'save
>> mark' because 'set' is about setting the ct mark directly, whereas
>> 'save' is about copying a packet's mark to the ct mark.
>>=20
>> Similarly I've been made aware of the revision infrastructure and now
>> that I understand that a little more have made use of it for this
>> change.  Hopefully this addresses one of Pablo's concerns.
>>=20
>> I've not been able to address the 'I'd like an nftables version'.
>> Quite simply it is beyond my knowledge and ability.  I am willing to
>> contribute financially if someone wishes to step up to the nftables
>> plate...yes I'd like to see the functionality implemented *that* =
much.
>=20
> I'll do it (no financial contribution required :)). There is one thing =
I
> want to find out before I get started.

Hi Jeremy,

You=E2=80=99ll permit me to make a donation in appreciation of your =
efforts though?

I=E2=80=99m not totally convinced that what I=E2=80=99ve submitted for =
x_tables is the
=E2=80=98perfect=E2=80=99 way of implementing the function so it=E2=80=99s=
 a plea for guidance as
much as anything :-)

> Pablo, comparing the x_tables and nftables connmark implementations I
> see that nftables doesn't support all the bit-twiddling that x_tables
> does.  Why is this?  Was it not wanted or has it just not been imple-
> mented?
>=20
> J.

Thanks,

Kevin

--Apple-Mail=_7B69CD29-CE6F-44B6-9F36-7440A47ACE4C
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEASyssijGxT6XdZEjs6I4m53iM0oFAl3o0f4ACgkQs6I4m53i
M0oHeRAAmrhEQhsMqnUESwhw7HNBDxz537UYqNbNGV0m3EK6/+gcVpsCrVZ9T9Lr
QnawIETdnApJM72OdVM5LyRNA0Y4dEdj9sLrewtDVIhSCM8AOSzk4hWoMXIArsfn
PmshrYm+drqhJ6E/xFb9N7imEaisEPrP4VgXEPtlJFdyfREm83ZwpS1uBlC4a3iK
lZmvsQnGg87T2VEeOgepvEJdqUhfsCnd4kGAfBc+dI3Q/SrPFt5LNgy5+yOvYgoo
weRgs+I8JDFgLOdx56Juh+MLcgXEIfZtWfYf/Gi6nPwD6G1DYJVp+ZQfVY2k5Hvd
LssAqb2kPWz+0BBJjJWNqO8znqFQgqT540ryYR0F8r7xgdksXhB+kS/H1/oYALBy
1gfTduFVrX+8eJjW6LQNNlo5OQB+rdJiH9cX2OfUwbUnsNNmPw/C7OUkgeLw3xMh
c7DZsj2acZpBBrPrk4pJ0PH5Rg9F5lc/bQ4q/FUxJNP7DXITasKzIcZdJK3HD+IL
whDcHxwtgsWeY5+8CTBTq7EqOZQmM0Q9/QzNyeblixDtN3t1n7ZHLIfqzUbIuI0F
dn6RqM+V+mSpogo2PJz7BmzarUUY4A9ja/X4TQGm3pmDxHoYoyN7uyuyzOAeBQi7
zk/6pLkmCscHo1qjcFMyzDJpfw/XpOOuj9nQjoL88nkE14IXbf0=
=sn2V
-----END PGP SIGNATURE-----

--Apple-Mail=_7B69CD29-CE6F-44B6-9F36-7440A47ACE4C--
