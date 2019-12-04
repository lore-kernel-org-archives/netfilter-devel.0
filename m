Return-Path: <SRS0=sEEs=Z2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PDS_BTC_ID,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A212DC43603
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 21:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B3AF206DB
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 21:05:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="eIEcUSc9";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="FLiiRNJc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbfLDVFw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 16:05:52 -0500
Received: from alln-iport-8.cisco.com ([173.37.142.95]:26142 "EHLO
        alln-iport-8.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728089AbfLDVFw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 16:05:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=7878; q=dns/txt; s=iport;
  t=1575493549; x=1576703149;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8oTmIQygy2tSSGzofcGlloeeklr1ZNfMGhiYxwuABhk=;
  b=eIEcUSc9vmtAms2Ihm0q8y/h4OBYzNp7tyIt/COMx/h8VLoy9NR7lnnW
   xmEWs56kB6FWXxBaHRsb9Hm5VnGBJmVRaTiZzkPVjRDYh1h683jk6UKJb
   iPft++a1NL//ezM7f86whDUQEMR2HSxpv0K2vEbkDrxYxwz+oJCNTkH60
   I=;
IronPort-PHdr: =?us-ascii?q?9a23=3A11gxYxYQQ3+dXT2WV0puzTr/LSx94ef9IxIV55?=
 =?us-ascii?q?w7irlHbqWk+dH4MVfC4el20gabRp3VvvRDjeee87vtX2AN+96giDgDa9QNMn?=
 =?us-ascii?q?1NksAKh0olCc+BB1f8KavxZSEoAslYV3du/mqwNg5eH8OtL1A=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0DgAABQH+hd/4gNJK1hAxoBAQEBAQE?=
 =?us-ascii?q?BAQEDAQEBAREBAQECAgEBAQGBfoFLKScFgUQgBAsqCoQhg0YDinmCOiWBAZc?=
 =?us-ascii?q?DglIDVAkBAQEMAQEtAgEBhEACF4F5JDgTAgMNAQEEAQEBAgEFBG2FNwyFUwE?=
 =?us-ascii?q?BAQMSEREMAQE3AQ8CAQgYAgImAgICMBUQAgQBDQUigwCCRwMuAaYCAoE4iGB?=
 =?us-ascii?q?1gTKCfgEBBYJKgj8YghcJgQ4ohRyDCINzGoFBP4ERJwwUghc1PoRgCiaCSTK?=
 =?us-ascii?q?CLJAhni0Kgi6VWhuaJo5KmiMCBAIEBQIOAQEFgWkigVhwFWUBgkFQERSMZoE?=
 =?us-ascii?q?nAQeCRIpTdIEojzABgQ8BAQ?=
X-IronPort-AV: E=Sophos;i="5.69,278,1571702400"; 
   d="scan'208";a="387134815"
Received: from alln-core-3.cisco.com ([173.36.13.136])
  by alln-iport-8.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 04 Dec 2019 21:05:34 +0000
Received: from XCH-RCD-005.cisco.com (xch-rcd-005.cisco.com [173.37.102.15])
        by alln-core-3.cisco.com (8.15.2/8.15.2) with ESMTPS id xB4L5Xcj002721
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 4 Dec 2019 21:05:33 GMT
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by XCH-RCD-005.cisco.com
 (173.37.102.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 4 Dec
 2019 15:05:33 -0600
Received: from xhs-rcd-001.cisco.com (173.37.227.246) by xhs-rtp-002.cisco.com
 (64.101.210.229) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 4 Dec
 2019 16:05:32 -0500
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-001.cisco.com (173.37.227.246) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 4 Dec 2019 15:05:32 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SwTDBk6BYLnJs5DF8wE8i0l0sxCdeJsBjpgDK2y//j2dHF5fmRM+TUnhbGncP1zUFStsQR/+4zju56tM4MJCyOl7g5pVuSKJFoQS8kDimGA0WKMBKnv5mBS6pTnIeCcEFZOck2ytMuY/Cswj1E7XEJE9YcYeRonBVkOYVw2IUbxfHvHmaO5IiGYY9+B40UK1874VqyzUcCgkQDWz+O08JJBK79wG1R4xyPXZxspbVV4XBVs0mHK4X1hypR1SQ6d03w72rintbq+R8lTb941rS5O4n1i5vKxiaZKF7Gx9cd8aGpMN38tu7rYtHXa0FE07a+SB6Hq6CVO/MvRArFyhfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8oTmIQygy2tSSGzofcGlloeeklr1ZNfMGhiYxwuABhk=;
 b=aN3xie6K9ZrowKiM6cst1kCh8CX7S4ULFrzX+en5rTU8kBnkwMpWSqO8KIPxzMah9rvHdea1+E00nMp8kJ18b5Ps2XG/9Frcg+IkUUcN+k7XqRbBW/AqS3pLS5O4pxg5iewzQoFuix58p5lZJ28yQwRt5emHZ0Gg/5RHq7NHB6A/nYy0xjhGVxiMSfXhpJxYZBwk2VTCldKoI3p292J46f/QvZT2GU9PBSFKnh+oK22jphsCtPlxiSi1EBCLfkTvLAYmthwFqUhpO1iDjNSu4GY08CaII9To4HkgCIhkdpH6BvQmsOYaAXgB7EzfwnsHz8pj76zkoQZWrgIuLuk4Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8oTmIQygy2tSSGzofcGlloeeklr1ZNfMGhiYxwuABhk=;
 b=FLiiRNJcMMAHp/EpZ8BdNO5Imsh91NB7fogi+BS/OJq4pbvx9YNmKoDvg8Wet9PwybXFJ0uJstBgLueEmG9ohaQiQE6HfQbU6t9l9qkoSB6M0YvCphtN2ns+2WpvuwbPg0/WPmB2d4q+xJnfdQcZcpdKGDIVQ0uccBVQoYrloIE=
Received: from DM5PR11MB1484.namprd11.prod.outlook.com (10.172.36.14) by
 DM5PR11MB1817.namprd11.prod.outlook.com (10.175.89.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.20; Wed, 4 Dec 2019 21:05:31 +0000
Received: from DM5PR11MB1484.namprd11.prod.outlook.com
 ([fe80::b8d0:b659:6b84:fa7a]) by DM5PR11MB1484.namprd11.prod.outlook.com
 ([fe80::b8d0:b659:6b84:fa7a%10]) with mapi id 15.20.2516.003; Wed, 4 Dec 2019
 21:05:31 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>,
        Phil Sutter <phil@nwl.cc>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Numen with reference to vmap
Thread-Topic: Numen with reference to vmap
Thread-Index: AQHVqj1Ubs5ZA1L3AEmU3M7cfc9ezqepw9GA///mtACAAGztAP//svyAgABX04CAABp3AP//sVOAAAbY5gA=
Date:   Wed, 4 Dec 2019 21:05:31 +0000
Message-ID: <8F45EB6F-B2DD-4498-9F5A-34D6CEB36F6A@cisco.com>
References: <EC8889A1-27E2-4DC9-B752-514689982085@cisco.com>
 <20191204101819.GN8016@orbyte.nwl.cc>
 <AFC93A41-C4DD-4336-9A62-6B9C6817D198@cisco.com>
 <20191204151738.GR14469@orbyte.nwl.cc>
 <5337E60B-E81D-46ED-912F-196E23C76701@cisco.com>
 <20191204155619.GU14469@orbyte.nwl.cc>
 <624cc1ac-126e-8ad3-3faa-f7869f7d2d5b@netfilter.org>
 <92609998-F3BF-42A5-AF95-A75AAE941C27@cisco.com>
In-Reply-To: <92609998-F3BF-42A5-AF95-A75AAE941C27@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.86]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f928e55f-053a-4d8c-0812-08d778fdb2a0
x-ms-traffictypediagnostic: DM5PR11MB1817:
x-microsoft-antispam-prvs: <DM5PR11MB1817FB4978AA70E2FFE5D128C45D0@DM5PR11MB1817.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0241D5F98C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(366004)(136003)(376002)(39860400002)(189003)(199004)(86362001)(53546011)(8936002)(81156014)(33656002)(229853002)(91956017)(5660300002)(64756008)(66556008)(66446008)(66946007)(305945005)(66476007)(102836004)(81166006)(11346002)(6506007)(14454004)(2616005)(7736002)(25786009)(36756003)(76176011)(478600001)(76116006)(8676002)(6512007)(110136005)(99286004)(6246003)(6436002)(3846002)(6116002)(26005)(2906002)(71200400001)(71190400001)(14444005)(6486002)(316002)(186003)(4326008)(58126008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB1817;H:DM5PR11MB1484.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0UzP3NWZpyrWANQzNEwxph7tFVr6sTRtwY7Iuasw6duC14I+LrXKvDaB0YNXLKH+Qn2p5x1FAJlFro3i25FD99hXxrJeALvL4W//2y3bbfjYDgBHGvOhNwj50sMNuVRNCoeXTagxF1MxuRNRAj4cazsMKobhmPXml3gDKPFtGVJsHBFecmrpPwUs6ITp3Gl1Apo6BE1EOlP8UkZ2YWTbeRQrKVPau+S4LkKsj16dFdOs6nloOXt3XhmC9uNWPlUiMnxrvF9b2n/5HWLEFVnTfVsWGGthqD9cj7HjPzkPcAxD8qGmClKgbmQfTfkKvNkN7sqrHFhnuR3unKUwbZ5WwIhb5hziSp1LB86ewRRWQD8zqx3DPRCwYvOnuw5LTFPA6/do/TG9Fg3msWyGeu3955Vano2UsUM8s3fKJLlifYOvSk1PcLJO9/EYnESF+Pft
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <08513F1FD6AD794BBA0D917BB22607A9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f928e55f-053a-4d8c-0812-08d778fdb2a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2019 21:05:31.3786
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PX6QBmTq292NtUfGl/HndYcEGIRMhzAJqZzeY/YXwYhi28aBc1Ft8sJjmmt+QYuJrVRxrguGCiZ2LruQdYgJHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1817
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.15, xch-rcd-005.cisco.com
X-Outbound-Node: alln-core-3.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGVyZSBhcmUgY29kZSBnZW5lcmF0ZWQgIG5mdGFibGVzIHJ1bGVzIGZvciAgbmF0IHBvcnRpb24g
b2YgazhzIHByb3h5LiAgUHJvYmFibHkgaXQgZG9lcyBub3QgY292ZXIgYWxsIGNhc2VzLCBidXQg
b24gYSBub3JtYWwgazhzIGNsdXN0ZXIgaXQgd291bGQgYmUgc3VmZmljaWVudC4gQXBwcmVjaWF0
ZSByZXZpZXdzIGFuZCBzdWdnZXN0aW9ucyBmb3Igb3B0aW1pemF0aW9uLiBUaGFuayB5b3UgdmVy
eSBtdWNoLg0KU2VyZ3VlaQ0KDQp0YWJsZSBpcCBpcHY0dGFibGUgew0KCWNoYWluIG5hdC1wcmVy
b3V0aW4gew0KCQl0eXBlIG5hdCBob29rIHByZXJvdXRpbmcgcHJpb3JpdHkgZmlsdGVyOyBwb2xp
Y3kgYWNjZXB0Ow0KCQlqdW1wIGs4cy1uYXQtc2VydmljZXMNCgl9DQoNCgljaGFpbiBuYXQtb3V0
cHV0IHsNCgkJdHlwZSBuYXQgaG9vayBvdXRwdXQgcHJpb3JpdHkgZmlsdGVyOyBwb2xpY3kgYWNj
ZXB0Ow0KCQlqdW1wIGs4cy1uYXQtc2VydmljZXMNCgl9DQoNCgljaGFpbiBuYXQtcG9zdHJvdXRp
bmcgew0KCQl0eXBlIG5hdCBob29rIHBvc3Ryb3V0aW5nIHByaW9yaXR5IGZpbHRlcjsgcG9saWN5
IGFjY2VwdDsNCgkJanVtcCBrOHMtbmF0LXBvc3Ryb3V0aW5nDQoJfQ0KDQoJY2hhaW4gazhzLW5h
dC1tYXJrLWRyb3Agew0KCQltZXRhIG1hcmsgc2V0IDB4MDAwMDgwMDANCgl9DQoNCgljaGFpbiBr
OHMtbmF0LXNlcnZpY2VzIHsNCgkJaXAgc2FkZHIgIT0gNTcuMTEyLjAuMC8xMiBpcCBkYWRkciA1
Ny4xNDIuMjIxLjIxIHRjcCBkcG9ydCA4MCBtZXRhIG1hcmsgc2V0IDB4MDAwMDQwMDANCgkJaXAg
ZGFkZHIgNTcuMTQyLjIyMS4yMSB0Y3AgZHBvcnQgODAganVtcCBLVUJFLVNWQy01N1hWT0NGTlRM
VFIzUTI3DQoJCWlwIHNhZGRyICE9IDU3LjExMi4wLjAvMTIgaXAgZGFkZHIgNTcuMTQyLjM1LjEx
NCB0Y3AgZHBvcnQgMTU0NDMgbWV0YSBtYXJrIHNldCAweDAwMDA0MDAwDQoJCWlwIGRhZGRyIDU3
LjE0Mi4zNS4xMTQgdGNwIGRwb3J0IDE1NDQzIGp1bXAgS1VCRS1TVkMtUzRTMjQyTTJXTkZJQVQ2
WQ0KCQlpcCBkYWRkciA1Ny4xMzEuMTUxLjE5IHRjcCBkcG9ydCA4OTg5IGp1bXAgS1VCRS1TVkMt
TVVQWFBWSzRYQVpIU1dBUg0KCQlpcCBkYWRkciAxOTIuMTY4LjgwLjEwNCB0Y3AgZHBvcnQgODk4
OSBtZXRhIG1hcmsgc2V0IDB4MDAwMDQwMDANCgkJZmliIHNhZGRyIHR5cGUgIT0gbG9jYWwgaXAg
ZGFkZHIgMTkyLjE2OC44MC4xMDQgdGNwIGRwb3J0IDg5ODkgaWlmbmFtZSAhPSAiYnJpZGdlKiIg
anVtcCBLVUJFLVNWQy1NVVBYUFZLNFhBWkhTV0FSDQoJCWZpYiBkYWRkciB0eXBlIGxvY2FsIGlw
IGRhZGRyIDE5Mi4xNjguODAuMTA0IHRjcCBkcG9ydCA4OTg5IGp1bXAgS1VCRS1TVkMtTVVQWFBW
SzRYQVpIU1dBUg0KCX0NCg0KCWNoYWluIGs4cy1uYXQtbm9kZXBvcnRzIHsNCgkJdGNwIGRwb3J0
IDMwNzI1IG1ldGEgbWFyayBzZXQgMHgwMDAwNDAwMCBqdW1wIEtVQkUtU1ZDLVM0UzI0Mk0yV05G
SUFUNlkNCgl9DQoNCgljaGFpbiBrOHMtbmF0LXBvc3Ryb3V0aW5nIHsNCgkJbWV0YSBtYXJrIDB4
MDAwMDQwMDAgbWFzcXVlcmFkZSByYW5kb20scGVyc2lzdGVudA0KCX0NCg0KCWNoYWluIEtVQkUt
U1ZDLVM0UzI0Mk0yV05GSUFUNlkgew0KCQlqdW1wIEtVQkUtU0VQLUNVQVo2UFNTVEVEUEo0M1YN
Cgl9DQoNCgljaGFpbiBLVUJFLVNWQy01N1hWT0NGTlRMVFIzUTI3IHsNCgkJbnVtZ2VuIHJhbmRv
bSBtb2QgMiB2bWFwIHsgMCA6IGp1bXAgS1VCRS1TRVAtRlMzRlVVTEdaUFZENFZZQiwgMSA6IGp1
bXAgS1VCRS1TRVAtTU1GWlJPUVNMUTNES09RQSB9DQoJfQ0KDQoJY2hhaW4gS1VCRS1TVkMtTVVQ
WFBWSzRYQVpIU1dBUiB7DQoJCWp1bXAgS1VCRS1TRVAtTE82VEVWT0k2R1Y1MjRGMw0KCX0NCg0K
CWNoYWluIEtVQkUtU0VQLUNVQVo2UFNTVEVEUEo0M1Ygew0KCQlpcCBzYWRkciA1Ny4xMTIuMC4y
NDQgbWV0YSBtYXJrIHNldCAweDAwMDA0MDAwDQoJCWRuYXQgdG8gNTcuMTEyLjAuMjQ0OjE1NDQz
IGZ1bGx5LXJhbmRvbQ0KCX0NCg0KCWNoYWluIEtVQkUtU0VQLUZTM0ZVVUxHWlBWRDRWWUIgew0K
CQlpcCBzYWRkciA1Ny4xMTIuMC4yNDcgbWV0YSBtYXJrIHNldCAweDAwMDA0MDAwDQoJCWRuYXQg
dG8gNTcuMTEyLjAuMjQ3OjgwODAgZnVsbHktcmFuZG9tDQoJfQ0KDQoJY2hhaW4gS1VCRS1TRVAt
TU1GWlJPUVNMUTNES09RQSB7DQoJCWlwIHNhZGRyIDU3LjExMi4wLjI0OCBtZXRhIG1hcmsgc2V0
IDB4MDAwMDQwMDANCgkJZG5hdCB0byA1Ny4xMTIuMC4yNDg6ODA4MCBmdWxseS1yYW5kb20NCgl9
DQoNCgljaGFpbiBLVUJFLVNFUC1MTzZURVZPSTZHVjUyNEYzIHsNCgkJaXAgc2FkZHIgNTcuMTEy
LjAuMjUwIG1ldGEgbWFyayBzZXQgMHgwMDAwNDAwMA0KCQlkbmF0IHRvIDU3LjExMi4wLjI1MDoz
ODk4OSBmdWxseS1yYW5kb20NCgl9DQp9DQoNCu+7v09uIDIwMTktMTItMDQsIDEyOjQ5IFBNLCAi
U2VyZ3VlaSBCZXp2ZXJraGkgKHNiZXp2ZXJrKSIgPHNiZXp2ZXJrQGNpc2NvLmNvbT4gd3JvdGU6
DQoNCiAgICBIZWxsbyBAUGhpbCwNCiAgICANCiAgICBKdXN0IHRvIGNvbmZpcm0sDQogICAgDQog
ICAgSWYgSSBkbywNCiAgICANCiAgICBOdW1nZW4gcmFuZG9tIG1vZCAzIHZtYXAgeyAwICA6ICBq
dW1wIGVuZHBvaW50MSwgMSAgOiAganVtcCBlbmRwb2ludDIsICAyICA6ICBqdW1wIGVuZHBvaW50
MyB9DQogICAgDQogICAgVGhlbiBpZiA0dGggZW5kcG9pbnQgYXBwZWFycyBJIHJlcGxhY2UgdGhl
IHByZXZpb3VzIHJ1bGUgd2l0aDoNCiAgICANCiAgICBOdW1nZW4gcmFuZG9tIG1vZCA0IHZtYXAg
eyAwICA6ICBqdW1wIGVuZHBvaW50MSwgMSAgOiAganVtcCBlbmRwb2ludDIsIDIgIDogIGp1bXAg
ZW5kcG9pbnQzLCAgMyAgOiAganVtcCBlbmRwb2ludDQgfQ0KICAgIA0KICAgIEl0IHNob3VsZCBk
byB0aGUgdHJpY2sgb2YgbG9hZGJhbGFuY2luZywgcmlnaHQ/DQogICAgDQogICAgQEFydHVybw0K
ICAgIA0KICAgIEkgYW0gbm8gcGxhbm5pbmcgdG8gdXNlICAiIGRuYXQgbnVtZ2VuIHJhbmRtbyB7
IDAtNDkgOiA8aXA+Ojxwb3J0PiB9LiINCiAgICANCiAgICBFYWNoIGVuZCBwb2ludCB3aWxsIGhh
dmUgaXQgaXMgb3duIGNoYWluIGFuZCBpdCB3aWxsIHRvIGRuYXQgdG8gaXAgYW5kIHNwZWNpZmlj
IHRvIGVuZHBvaW50IHRhcmdldCBwb3J0LiBUaGUgbG9hZCBiYWxhbmNpbmcgd2lsbCBiZSBkb25l
IGluIHNlcnZpY2UgY2hhaW4gYmV0d2VlbiBtdWx0aXBsZSBlbmRwb2ludCBjaGFpbnMuDQogICAg
U2VlIGV4YW1wbGUgYWJvdmUuIERvZXMgaXQgbWFrZSBzZW5zZT8NCiAgICANCiAgICBUaGFuayB5
b3UNCiAgICBTZXJndWVpDQogICAgDQogICAgT24gMjAxOS0xMi0wNCwgMTI6MzEgUE0sICJBcnR1
cm8gQm9ycmVybyBHb256YWxleiIgPGFydHVyb0BuZXRmaWx0ZXIub3JnPiB3cm90ZToNCiAgICAN
CiAgICAgICAgT24gMTIvNC8xOSA0OjU2IFBNLCBQaGlsIFN1dHRlciB3cm90ZToNCiAgICAgICAg
PiBPSywgc3RhdGljIGxvYWQtYmFsYW5jaW5nIGJldHdlZW4gdHdvIHNlcnZpY2VzIC0gbm8gYmln
IGRlYWwuIDopDQogICAgICAgID4gDQogICAgICAgID4gV2hhdCBoYXBwZW5zIGlmIGNvbmZpZyBj
aGFuZ2VzPyBJLmUuLCBpZiBvbmUgb2YgdGhlIGVuZHBvaW50cyBnb2VzIGRvd24NCiAgICAgICAg
PiBvciBhIHRoaXJkIG9uZSBpcyBhZGRlZD8gKFRoYXQncyB0aGUgdGhpbmcgd2UncmUgZGlzY3Vz
c2luZyByaWdodCBub3csDQogICAgICAgID4gYXJlbid0IHdlPykNCiAgICAgICAgDQogICAgICAg
IGlmIHRoZSBub24tYW5vbiBtYXAgZm9yIHJhbmRvbSBudW1nZW4gd2FzIGFsbG93ZWQsIHRoZW4g
b25seSBlbGVtZW50cyB3b3VsZCBuZWVkDQogICAgICAgIHRvIGJlIGFkanVzdGVkOg0KICAgICAg
ICANCiAgICAgICAgZG5hdCBudW1nZW4gcmFuZG9tIG1vZCAxMDAgbWFwIHsgMC00OSA6IDEuMS4x
LjEsIDUwLTk5IDogMi4yLjIuMiB9DQogICAgICAgIA0KICAgICAgICBZb3UgY291bGQgYWx3YXlz
IHVzZSBtb2QgMTAwIChvciAxMDAwMCBpZiB5b3Ugd2FudCkgYW5kIGp1c3QgcGxheSB3aXRoIHRo
ZSBtYXANCiAgICAgICAgcHJvYmFiaWxpdGllcyBieSB1cGRhdGluZyBtYXAgZWxlbWVudHMuIFRo
aXMgaXMgYSB2YWxpZCB1c2UgY2FzZSBJIHRoaW5rLg0KICAgICAgICBUaGUgbW9kIG51bWJlciBj
YW4ganVzdCBiZSB0aGUgbWF4IG51bWJlciBvZiBhbGxvd2VkIGVuZHBvaW50cyBwZXIgc2Vydmlj
ZSBpbg0KICAgICAgICBrdWJlcm5ldGVzLg0KICAgICAgICANCiAgICAgICAgQFBoaWwsDQogICAg
ICAgIA0KICAgICAgICBJJ20gbm90IHN1cmUgaWYgdGhlIHR5cGVvZigpIHRoaW5neSB3aWxsIHdv
cmsgaW4gdGhpcyBjYXNlLCBzaW5jZSB0aGUgaW50ZWdlcg0KICAgICAgICBsZW5ndGggd291bGQg
ZGVwZW5kIG9uIHRoZSBtb2QgdmFsdWUgdXNlZC4NCiAgICAgICAgV2hhdCBhYm91dCBpbnRyb2R1
Y2luZyBzb21ldGhpbmcgbGlrZSBhbiBleHBsaWNpdCB1MTI4IGludGVnZXIgZGF0YXR5cGUuIFBl
cmhhcHMNCiAgICAgICAgaXQncyB1c2VmdWwgZm9yIG90aGVyIHVzZSBjYXNlcyB0b28uLi4NCiAg
ICAgICAgDQogICAgICAgIEBTZXJndWVpLA0KICAgICAgICANCiAgICAgICAga3ViZXJuZXRlcyBp
bXBsZW1lbnRzIGEgY29tcGxleCBjaGFpbiBvZiBtZWNoYW5pc21zIHRvIGRlYWwgd2l0aCB0cmFm
ZmljLiBXaGF0DQogICAgICAgIGhhcHBlbnMgaWYgZW5kcG9pbnRzIGZvciBhIGdpdmVuIHN2YyBo
YXZlIGRpZmZlcmVudCBwb3J0cz8gSSBkb24ndCBrbm93IGlmDQogICAgICAgIHRoYXQncyBzdXBw
b3J0ZWQgb3Igbm90LCBidXQgdGhlbiB0aGlzIGFwcHJvYWNoIHdvdWxkbid0IHdvcmsgZWl0aGVy
OiB5b3UgY2FuJ3QNCiAgICAgICAgdXNlIGRuYXQgbnVtZ2VuIHJhbmRtbyB7IDAtNDkgOiA8aXA+
Ojxwb3J0PiB9Lg0KICAgICAgICANCiAgICAgICAgQWxzbywgd2UgaGF2ZSB0aGUgbWFzcXVlcmFk
ZS9kcm9wIHRoaW5nIGdvaW5nIG9uIHRvbywgd2hpY2ggbmVlZHMgdG8gYmUgZGVhbA0KICAgICAg
ICB3aXRoIGFuZCB0aGF0IGN1cnJlbnRseSBpcyBkb25lIGJ5IHlldCBhbm90aGVyIGNoYWluIGp1
bXAgKyBwYWNrZXQgbWFyay4NCiAgICAgICAgDQogICAgICAgIEknbSBub3Qgc3VyZSBpbiB3aGlj
aCBzdGF0ZSBvZiB0aGUgZGV2ZWxvcG1lbnQgeW91IGFyZSwgYnV0IHRoaXMgaXMgbXkNCiAgICAg
ICAgc3VnZ2VzdGlvbjogVHJ5IHRvIGRvbid0IG92ZXItb3B0aW1pemUgaW4gdGhlIGZpcnN0IGl0
ZXJhdGlvbi4gSnVzdCBnZXQgYQ0KICAgICAgICB3b3JraW5nIG5mdCBydWxlc2V0IHdpdGggdGhl
IGZldyBvcHRpbWl6YXRpb24gdGhhdCBtYWtlIHNlbnNlIGFuZCBhcmUgZWFzeSB0bw0KICAgICAg
ICB1c2UgKGFuZCB1bmRlcnN0YW5kKS4gRm9yIGl0ZXJhdGlvbiAjMiB3ZSBjYW4gZG8gYmV0dGVy
IG9wdGltaXphdGlvbnMsIGluY2x1ZGluZw0KICAgICAgICBwYXRjaGluZyBtaXNzaW5nIGZlYXR1
cmVzIHdlIG1heSBoYXZlIGluIG5mdGFibGVzLg0KICAgICAgICBJIHJlYWxseSB3YW50IGEgcnVs
ZXNldCB3aXRoIHZlcnkgbGl0dGxlIHJ1bGVzLCBidXQgd2UgYXJlIHN0aWxsIGNvbXBhcmluZyB3
aXRoDQogICAgICAgIHRoZSBpcHRhYmxlcyBydWxlc2V0LiBJIHN1Z2dlc3Qgd2UgbGVhdmUgdGhl
IGhhcmQgb3B0aW1pemF0aW9uIGZvciBhIGxhdGVyIHBvaW50DQogICAgICAgIHdoZW4gd2UgYXJl
IGNvbXBhcmluZyBuZnQgdnMgbmZ0IHJ1bGVzZXRzLg0KICAgICAgICANCiAgICANCiAgICANCg0K
