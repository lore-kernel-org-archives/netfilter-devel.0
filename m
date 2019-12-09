Return-Path: <SRS0=ntVu=Z7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77772C43603
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Dec 2019 23:57:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FB9D20726
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Dec 2019 23:57:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=darbyshire-bryant.me.uk header.i=@darbyshire-bryant.me.uk header.b="VRHKyI03"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbfLIX5L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Dec 2019 18:57:11 -0500
Received: from mail-eopbgr00042.outbound.protection.outlook.com ([40.107.0.42]:14455
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727091AbfLIX5K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Dec 2019 18:57:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dyR3cdvkOOmD2vxuVYq79mQroybwW/kf9j8NyabCSboJ4b+EJxhS5Tw1kfwPCeTW5yjQBOcbocQBFO/tEAxDybQKuu1SrpDYTkTV46BsH1Wxk2d2e8U3wilGi2iYkI1NTeksmPjBiShZfZ70ae1zavSY7OZkZ0biJl2lqwN7piRX7Q9dXyrJODwHg3JTFZ0joAiAyNIIyc3p560ukCiDx8bJmzBxIGg2kk3rAtiqeY06BJRXu87+bKOU4VlTk5vpZY8vAnVFy+lRoe2G8jT+NVj+69iKOEQTdgAhgDVmmYAIyAuhcj4GaWXSnIz7nMKZjMT7z+9Rbgt52Bl9Z0ahzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b73n54iUreQr6XYbL/UAuZzCs/5gB85v1LWyTqtg1j0=;
 b=KtEVE4/pBgd1D4fg7v4ioD+IlHI6w0unxtSp8pJadlIKYR2FzheENbApjsNvs5nTqp64Wy0E9c4QCMghx3/bf6GYbEMaodlwG7B1BTjwUluNjciJcfcgMaxtqtKYft1jaBC37TBAZY4fT3FjEO7u5ZOkoQBogmo/MWkjYj6ZMqr7qG1K5tzTY8XeuReW09egTEhfA7ex7jPc1EUFh9Hx5NtW/r+8EtuD801wi1KtAHBAcfwh6zkfTfwq4vLEk3vfz7D2zM3ncbB83zrZuZH1RNOyUrVr7QJT5tJ6fJ5hM/BOE/jpGolsLI6yhoM6MkOSIccO+m7AXnhXtQa9H5UVCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=darbyshire-bryant.me.uk; dmarc=pass action=none
 header.from=darbyshire-bryant.me.uk; dkim=pass
 header.d=darbyshire-bryant.me.uk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=darbyshire-bryant.me.uk; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b73n54iUreQr6XYbL/UAuZzCs/5gB85v1LWyTqtg1j0=;
 b=VRHKyI03CFCFrEhlme2GgxW+Hgir30d/1f0aD/YluKKyxAm/UY47F5jvIWc9JJ40gFO1/LjytMBwmNZc20mgF4/+F4pMWTtIqUAiGxl230GiCwWN04GJofHZE9xkuQzFj/jb9tX8T7hF7pzXKQ3Yo3yzUopJsgaL0AJI4cIumBM=
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com (10.171.106.21) by
 VI1PR0302MB2671.eurprd03.prod.outlook.com (10.171.104.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.18; Mon, 9 Dec 2019 23:57:05 +0000
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::7585:5ab6:a348:de46]) by VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::7585:5ab6:a348:de46%7]) with mapi id 15.20.2516.018; Mon, 9 Dec 2019
 23:57:05 +0000
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH 1/1] netfilter: connmark: introduce set-dscpmark
Thread-Topic: [PATCH 1/1] netfilter: connmark: introduce set-dscpmark
Thread-Index: AQHVqfPShbD/oVi3MEm/Pk1ZXxTJ/6eyhM2A
Date:   Mon, 9 Dec 2019 23:57:05 +0000
Message-ID: <960F6D75-489D-41E7-AEF7-58D4013F9CFD@darbyshire-bryant.me.uk>
References: <20191203160652.44396-1-ldir@darbyshire-bryant.me.uk>
 <20191203160652.44396-2-ldir@darbyshire-bryant.me.uk>
In-Reply-To: <20191203160652.44396-2-ldir@darbyshire-bryant.me.uk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ldir@darbyshire-bryant.me.uk; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2a02:c7f:1243:8e00::dc83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6cf5ff63-f25c-45d5-c403-08d77d037e74
x-ms-traffictypediagnostic: VI1PR0302MB2671:
x-microsoft-antispam-prvs: <VI1PR0302MB267161AB096DD23177DB3A64C9580@VI1PR0302MB2671.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02462830BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39830400003)(136003)(396003)(376002)(366004)(189003)(199004)(66946007)(66616009)(33656002)(66476007)(66556008)(6916009)(316002)(64756008)(76116006)(6486002)(91956017)(5660300002)(229853002)(305945005)(36756003)(6512007)(4744005)(53546011)(81166006)(186003)(81156014)(2616005)(71190400001)(71200400001)(8676002)(6506007)(86362001)(5640700003)(2906002)(66446008)(8936002)(508600001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0302MB2671;H:VI1PR0302MB2750.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: darbyshire-bryant.me.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mGkR68KekTK74gyJQ93LKTPdGFfGOcJTDa9/cx3QgV87hoWt1OHecS6+E38S28vXN7MNE8jvT0HgEXVBvSV9fZIObBXsTXqXOU7NkV9MYeQm7Gm/16RCNEKI87eyu562nRWw6nhJRFLPvKINGy8gH+W/GgWPANhZvOxFeTtbN8Y1r9GtyAmvZaYmHllyHXgQ+h2i4CSlbv5NR86wxt1zO9rd7aK0hXyO4gefm7aZF2frIpGivV/hPpG1h5Kl03h8xXdBUq/PXURU0zPjnVzEAtsHDupWHT/BQ4WxTp1F1++LwbXmJX+5qRIJVZyHyB1RjEbhGil9k4D5o/UOg0NU3aJIhbYx9qnxxDkwEubMYiNE3IVVCYtlwUE68KVmf9W+hn6GsfIjXkXTXq5BvcXXQpBLOuN76TkLPO4PYQcJ4My3iOJ/vkA0h+qotgcZGLpN
x-ms-exchange-transport-forked: True
Content-Type: multipart/signed;
        boundary="Apple-Mail=_FEED59A3-C495-4FAF-9512-81F75D12135C";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
MIME-Version: 1.0
X-OriginatorOrg: darbyshire-bryant.me.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cf5ff63-f25c-45d5-c403-08d77d037e74
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2019 23:57:05.4180
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9151708b-c553-406f-8e56-694f435154a4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rtkvpC9l+fLfa5G/ABeQkIrIOR7SrV5DNh81yp4WlteSn91E/xbnqYpsQ8CC7Gen7css1aqXK9AIgXjVXT9ki6F4k4v96P+7NPeLW/TKtIg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB2671
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--Apple-Mail=_FEED59A3-C495-4FAF-9512-81F75D12135C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On 3 Dec 2019, at 16:06, Kevin Darbyshire-Bryant =
<ldir@darbyshire-bryant.me.uk> wrote:
>=20
> set-dscpmark is a method of storing the DSCP of an ip packet into
> conntrack mark.  In combination with a suitable tc filter action
> (act_ctinfo) DSCP values are able to be stored in the mark on egress =
and
> restored on ingress across links that otherwise alter or bleach DSCP.
>=20
<snip>

Well no one has yet screamed.  I do think I=E2=80=99ve done this wrong:

>=20
> +enum {
> +	XT_CONNMARK_VALUE =3D BIT(0),
> +	XT_CONNMARK_DSCP =3D BIT(1)
> +};

and they should be =3D (1 << bit_number) instead.

I=E2=80=99ll send a v2 with that change (to nf-next) but anything else? =
or is it all too horrid
to contemplate :-)

Cheers,

Kevin

--Apple-Mail=_FEED59A3-C495-4FAF-9512-81F75D12135C
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEASyssijGxT6XdZEjs6I4m53iM0oFAl3u308ACgkQs6I4m53i
M0rurA/8Dhfa7jpcQKu7/iu/53oBFI2SHqBu0rFjfw1NypnYcyK+J4FEka1lbO25
lnWU+ioGHftQoAuxe6o8hfjnyaKSHevgz6hNYWaI0jrBMVWFPAaIJHl4sZ3Y4QjB
GKr72gYdIxvtk4TPnji8HqPt+ZCxvqu3o4p1o+klRz+RVBf7aNr2JMQETDiWiZEt
vAo0DLzNNmPoyPjvDHhCqc5NJ8qzTjGgpCWfsGQN4ihuoAp9X9E0OyUIY8crDXK6
zrx1gkRrltJla52Zo/s5x+p8ME2wkSdh25X1SUmahTWURL/1a3XVwhbU1qkjgtxM
WJZoP5FBfmatRFIKHdP4iUvRszmQ+hoN39xOJQ7ceKuxdVVyI6AgpJhVCBWg4kCh
x/U7sHNrHm3DotT4+HzSxgnrC2zg0r/0+Fx+tqv8wMl0OIkp8W8LZFGHd9aG7E8q
+IQtjJZ70uKmLih1mdRn3FCq5Q8FyywpgM0god+L8Kdg5vETdCFJCSUKdxSnEeaG
B1WGavU0KL1zf3DpeAExEAHQEMftA51B2OJaPwyswiTUNY2aNtADS3FwUGJpgZNn
+cw+zfLW5uicT/Ys9DadvZhe4vPRBMnVAk4byZGfr7ugsfM/QMFOH5NvJB7861BO
ECGWCvKnYAgyj3b0DbDASP7jZVlfa7Ffc/T1NHRcs/EhwVso9hA=
=FJZf
-----END PGP SIGNATURE-----

--Apple-Mail=_FEED59A3-C495-4FAF-9512-81F75D12135C--
