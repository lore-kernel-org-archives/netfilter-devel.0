Return-Path: <SRS0=Z7Wb=5B=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8967CC0044D
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Mar 2020 08:16:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F9A620674
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Mar 2020 08:16:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=iaea.org header.i=@iaea.org header.b="S2IKBhi8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730016AbgCPIQe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Mar 2020 04:16:34 -0400
Received: from mail-eopbgr40134.outbound.protection.outlook.com ([40.107.4.134]:56704
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729975AbgCPIQe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Mar 2020 04:16:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yk8LUlVHShCY32r9hvsMmVN58aNpLK+31gsGjhZrJM1uasRKWy+x/2o9dqvDpVhgMXSaZonFRgwLUL/GNYwZ6z+yHju6jbW2SkHPVJnNsvmv17cmKa40Kc2jllA5WR0G4yxgXgTLDHd/Ss+qIVOgR3ylJetoBBYqcBqJN97oi5/g4D0IlUNpkhO9c4d56fne1ITJXuW1xaSwZKfWXN4l928JnyzqZWuKXB1/uF7Um3dGg6cWS84vndVD0Thj7wNoNUAEbi8vLSPK5jeYzzU4rui+v0M+XpUtFJRt01sm/cWH/FwrvIB/CdCZPfwi3qhZunJfUGFQoUMRpXYU7Tl/bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7OsljJfPAxWfmaJubZdAfdO9frEM8azsugT4ToIFCoQ=;
 b=QFpiWhOgrGwHjU9dfLsmvtrrr0l+zu3swThD6XMgLEaJTP12mUc0Ia2uvl8srRftLRVtMfvIn1KyoyJdxRQR3YAf3JUl7+DlaArm1jacjqhkanYS7hwtX34Hbjh+sMQDfMtu5YZC5ngubJDiB0j1D12xyHTzOEVCBoFOLvLAXBKVAiq9XUDipIWVb9QqqiO9/ENcmzbM9sjYX3p703/Yizu3FQ3D8lwNq5ZuBTRLzN/V0mzemz8my/PypBLV/6TbqH9sK8qXUrYXRfXD+wE+HY97dsktqrVAxDq3JePNNa9aDfAV/ur6PSHcUuP0f+1l3fN171YOMQgfClTSzhJJ/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=iaea.org; dmarc=pass action=none header.from=iaea.org;
 dkim=pass header.d=iaea.org; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iaea.org; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7OsljJfPAxWfmaJubZdAfdO9frEM8azsugT4ToIFCoQ=;
 b=S2IKBhi8XznGlUsFaxZfD741aDLywcbN7jJY3E5NhQ177UqJz+6FkMSETUNPvckge0U1PtE4jsxJlhWELSiwFfdM6xefIWC3nTiVYEkYrNky49rFbc63tm75clNU24gt2Fy5n2lzbxZlGn59TxkLfI6+F6KYUR8wiYJp1SpLVFU=
Received: from AM0PR01MB6290.eurprd01.prod.exchangelabs.com (10.186.188.20) by
 AM0PR01MB5731.eurprd01.prod.exchangelabs.com (20.179.254.222) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.22; Mon, 16 Mar 2020 08:16:28 +0000
Received: from AM0PR01MB6290.eurprd01.prod.exchangelabs.com
 ([fe80::9485:a0d8:93b1:37bd]) by AM0PR01MB6290.eurprd01.prod.exchangelabs.com
 ([fe80::9485:a0d8:93b1:37bd%6]) with mapi id 15.20.2814.021; Mon, 16 Mar 2020
 08:16:28 +0000
From:   "MELCHOR PENA, Bernardo Santiago" <B.S.Melchor-Pena@iaea.org>
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: compilation of netfilter missing libnftnl functions - undefined
 reference - (RASPBERRY pi 3B)
Thread-Topic: compilation of netfilter missing libnftnl functions - undefined
 reference - (RASPBERRY pi 3B)
Thread-Index: AdX7azCPzi3NqDeySWW84x7O+iK7qQ==
Date:   Mon, 16 Mar 2020 08:16:28 +0000
Message-ID: <AM0PR01MB62900376D6F0DCAA682DB966F6F90@AM0PR01MB6290.eurprd01.prod.exchangelabs.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=B.S.Melchor-Pena@iaea.org; 
x-originating-ip: [161.5.6.233]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c6db49f-be5c-4d90-bbe9-08d7c98253c5
x-ms-traffictypediagnostic: AM0PR01MB5731:
x-microsoft-antispam-prvs: <AM0PR01MB5731345E15824C001C2552AAF6F90@AM0PR01MB5731.eurprd01.prod.exchangelabs.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 03449D5DD1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(366004)(39850400004)(136003)(376002)(346002)(199004)(2906002)(186003)(26005)(81156014)(8676002)(81166006)(6916009)(6506007)(9686003)(55016002)(15974865002)(86362001)(7696005)(8936002)(478600001)(316002)(52536014)(66476007)(33656002)(5660300002)(76116006)(66446008)(66556008)(64756008)(66946007)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR01MB5731;H:AM0PR01MB6290.eurprd01.prod.exchangelabs.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: iaea.org does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JJT5ucIC3+fr72q/NHkKGc8q+68h46R7mUyiaGhjTRxor3/9GT3Uec1TgYUeY1sRhk3O8U1jpPA8PqTN2p06rJyGmGlZ3QLkCwyY0P5g7WMSsEVrj9TPOc7agzzm4uXL32vPOnht8jQq6l2zVWTN4fG5ovzACnEMFnSO3kNGefCjBrRanj9gcs2kSOTJMsPGv5jMLw6NOhmMo0ZHlrDqos7DDv0QM7qylROUQjX2AJA3LIXEXRqrQTSmg9Nptq3dWFSSCzTGhzJDQo3lLWaoq5SCvqdqkmdJ+VJoz0/fKLxI9gLCA7B62NxamvIHn9EW6vz6BURoVk5kSG/DiTw7MkIYDzRDc9ZKbefo1kuX4gKAOmWBwiifVp80DvLo/A1XaZo6zNy/yrg/qmeBJKHemVZPz30vFe0MRvdhZAu+d/wxOxWfTaV/+uOGVOwWd1378ONIeAyGw8AUZhlaffAw5dOSTcalF3Zt/eeHazeSrdnhQr8o6AQqIRwoY2qJyuWN7y5WZ4n8c3RTjZKpi8aQhw==
x-ms-exchange-antispam-messagedata: bY4Av+Lk5MuaL+j7fywDpfAFh0MBNZCVO5MPRs1DhyKGVIA/IFubn3mwrukJIB1NMZNNgcKlxi9sAqPGWgLgt6e8U0VPl0BR50iaGq5WdIgEquU21EGv4Lx1TtQt7p39twbIXyvwMZ1Y4jEtOmxJgg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: iaea.org
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c6db49f-be5c-4d90-bbe9-08d7c98253c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2020 08:16:28.3647
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a2f21493-a4d1-4b7f-ad07-819c824f5c4a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rkm34ssfrEIHQwvpHqIF4fbon0iYBTAPG8sBMjqYg1PQw7/2GK19DK0KR0QRaTBIg86w8B0NJ4koXQagxlb19yY9a55q/YGUjgElE3NYym0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR01MB5731
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


Hi,

After downloading snapshots for NFTABLES and LIBNFTNL for 20200314 I procee=
ded to compile both library and NFTABLES

Library compiled with no errors.
libnftnl installed in /usr/local/lib

pi@raspberrypi:~/nftables-20200314 $ ls -lia /usr/local/lib/libnftnl.*
130735 -rwxr-xr-x 1 root root 974 Mar 15 10:55 /usr/local/lib/libnftnl.la
150748 lrwxrwxrwx 1 root root 18 Mar 15 10:55 /usr/local/lib/libnftnl.so ->=
 libnftnl.so.11.2.0
150737 lrwxrwxrwx 1 root root 18 Mar 15 10:55 /usr/local/lib/libnftnl.so.11=
 -> libnftnl.so.11.2.0
130734 -rwxr-xr-x 1 root root 969712 Mar 15 10:55 /usr/local/lib/libnftnl.s=
o.11.2.0


nftables gives this error when compiling with Make

/usr/bin/ld: ./.libs/libnftables.so: undefined reference to `nftnl_flowtabl=
e_set_data@LIBNFTNL_13'
/usr/bin/ld: ./.libs/libnftables.so: undefined reference to `nftnl_udata_ne=
st_end@LIBNFTNL_14'
/usr/bin/ld: ./.libs/libnftables.so: undefined reference to `nftnl_obj_set_=
data@LIBNFTNL_13'
/usr/bin/ld: ./.libs/libnftables.so: undefined reference to `nftnl_flowtabl=
e_get_u64@LIBNFTNL_11'
/usr/bin/ld: ./.libs/libnftables.so: undefined reference to `nftnl_flowtabl=
e_set_u64@LIBNFTNL_11'
/usr/bin/ld: ./.libs/libnftables.so: undefined reference to `nftnl_udata_ne=
st_start@LIBNFTNL_14'

I have tried to  point link under nftables-20200314/src/.libs
to point to /usr/local/lib with ln -sf /usr/local/lib/libnftnl.so ./libnfta=
bles.so

Errors then are the following after running Make
/usr/bin/ld: main.o: in function `main':
/home/pi/nftables-20200314/src/main.c:260: undefined reference to `nft_ctx_=
new'
/usr/bin/ld: /home/pi/nftables-20200314/src/main.c:305: undefined reference=
 to `nft_ctx_output_get_debug'
/usr/bin/ld: /home/pi/nftables-20200314/src/main.c:276: undefined reference=
 to `nft_ctx_set_dry_run'
/usr/bin/ld: /home/pi/nftables-20200314/src/main.c:285: undefined reference=
 to `nft_ctx_add_include_path'
/usr/bin/ld: /home/pi/nftables-20200314/src/main.c:331: undefined reference=
 to `nft_ctx_output_set_debug'
/usr/bin/ld: /home/pi/nftables-20200314/src/main.c:367: undefined reference=
 to `nft_ctx_output_set_flags'
/usr/bin/ld: /home/pi/nftables-20200314/src/main.c:384: undefined reference=
 to `nft_run_cmd_from_buffer'
/usr/bin/ld: /home/pi/nftables-20200314/src/main.c:400: undefined reference=
 to `nft_ctx_free'
/usr/bin/ld: /home/pi/nftables-20200314/src/main.c:386: undefined reference=
 to `nft_run_cmd_from_filename'
/usr/bin/ld: cli.o: in function `cli_complete':
/home/pi/nftables-20200314/src/cli.c:133: undefined reference to `nft_run_c=
md_from_buffer'
collect2: error: ld returned 1 exit status
make[3]: *** [Makefile:644: nft] Error 1
make[3]: Leaving directory '/home/pi/nftables-20200314/src'
make[2]: *** [Makefile:500: all] Error 2
make[2]: Leaving directory '/home/pi/nftables-20200314/src'
make[1]: *** [Makefile:479: all-recursive] Error 1
make[1]: Leaving directory '/home/pi/nftables-20200314'
make: *** [Makefile:388: all] Error 2


running RASPBIAN (buster) on raspberry 3B

Please, tell me what combination of lib and user app should I compile. I go=
t kernel compiled for RASPBERRY with all nft enabled options but I am strug=
gling with this part.

Thanks


Bernardo Santiago Melchor Pena,
IT Security Engineer | IT Security Infrastructure Unit
Infrastructure Services Section | Division of Information Technology
International Atomic Energy Agency | M: (+43) 699-165-22924 | Vienna Intern=
ational Centre, PO Box 100, 1400 Vienna, Austria |
Follow us on www.iaea.org

This email message is intended only for the use of the named recipient. Inf=
ormation contained in this email message and its attachments may be privile=
ged, confidential and protected from disclosure. If you are not the intende=
d recipient, please do not read, copy, use or disclose this communication t=
o others. Also please notify the sender by replying to this message and the=
n delete it from your system.
