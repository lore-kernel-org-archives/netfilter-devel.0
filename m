Return-Path: <SRS0=+PqO=WE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE56C433FF
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Aug 2019 16:08:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B768421743
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Aug 2019 16:08:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="P/DYG6ys";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="yRY3jtev"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732999AbfHHQIa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Aug 2019 12:08:30 -0400
Received: from alln-iport-6.cisco.com ([173.37.142.93]:20400 "EHLO
        alln-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732680AbfHHQIa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Aug 2019 12:08:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2480; q=dns/txt; s=iport;
  t=1565280508; x=1566490108;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=oAPZfpZKvERNNnABrYgzEEXzQ8A35HSgqH/zJVHh7QY=;
  b=P/DYG6ysoaS2AmyfWrDwpEqL33q5s+226YDkw7k2o/mmJzMfPDhGgcoB
   xpMo8PaXZ7obHhgM2hpqW17+3koI7ChO9wtyvIxLTCAA7uaqxzWX/ZHTt
   zKiyJEIKf77ruuSTQ4SzJ4koeGIja7QCrl/cMtH10HgN8nevmLfFB3MaY
   Q=;
IronPort-PHdr: =?us-ascii?q?9a23=3AQU4UMxGuR/g5nda088exQZ1GYnJ96bzpIg4Y7I?=
 =?us-ascii?q?YmgLtSc6Oluo7vJ1Hb+e4z1Q3SRYuO7fVChqKWqK3mVWEaqbe5+HEZON0pNV?=
 =?us-ascii?q?cejNkO2QkpAcqLE0r+eeXgYj4kEd5BfFRk5Hq8d0NSHZW2ag=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0ATAAC/SExd/4MNJK1mGgEBAQEBAgE?=
 =?us-ascii?q?BAQEHAgEBAQGBVQMBAQEBCwGBRCknA4FCIAQLKgqEFINHA4sOgluJW44FgS6?=
 =?us-ascii?q?BJANUCQEBAQwBAS0CAQGEPwIXgj8jNgcOAQQBAQQBAQQBCm2FJwyFSwEBAQM?=
 =?us-ascii?q?SEREMAQE3AQ8CAQgOCgICJgICAh8RFRACBA4FIoMAgWsDHQGhBAKBOIhgcYE?=
 =?us-ascii?q?ygnoBAQWCSIJPDQuCFAmBDCgBhHKGcReBQD+BOB+CTD6CGoIqF4J0MoImjw+?=
 =?us-ascii?q?OBY1qQAkCgh2QMYN4G5g2lyWOJAIEAgQFAg4BAQWBVwQtgVhwFTsqAYJBgkI?=
 =?us-ascii?q?MF4EDAQeCQ4pTcoEpik8BgSABAQ?=
X-IronPort-AV: E=Sophos;i="5.64,362,1559520000"; 
   d="scan'208";a="311567686"
Received: from alln-core-1.cisco.com ([173.36.13.131])
  by alln-iport-6.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 08 Aug 2019 16:08:17 +0000
Received: from XCH-RCD-004.cisco.com (xch-rcd-004.cisco.com [173.37.102.14])
        by alln-core-1.cisco.com (8.15.2/8.15.2) with ESMTPS id x78G8HjV010818
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 8 Aug 2019 16:08:17 GMT
Received: from xhs-rtp-003.cisco.com (64.101.210.230) by XCH-RCD-004.cisco.com
 (173.37.102.14) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 8 Aug
 2019 11:08:17 -0500
Received: from xhs-rcd-002.cisco.com (173.37.227.247) by xhs-rtp-003.cisco.com
 (64.101.210.230) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 8 Aug
 2019 12:08:16 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-002.cisco.com (173.37.227.247) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 8 Aug 2019 11:08:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZGeDEEkQ2IObuFLioAtdsVRBeapcMtEBLsqY00pTtIJLnRiYndCNYDNVKH1QoZlK32WodjJcCTwYZtNNkeOgga6WkyQZ0BGK0HKClaj84bxDX46vFf6OrEjZx/skFKt8HLDwe+U5o88sq9QxyZi4bmQjquxxRpOigoJfJhSR4Mn2d6fEKXrE0k1Q2QCsadDtMKJLvJJ5oIL5Dhdt91102cj+/dk0Z39etrhU1MvMIE5ZnwrjttauXJJuMcidHrrcUyxeeFDKWJ9wQGuaIcn4vhVd191M7puYounrqpp2NmY3PIwmVRWRXUBy5BlYdL+IBoW1RTq8gKf9/QpbrQXseQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oAPZfpZKvERNNnABrYgzEEXzQ8A35HSgqH/zJVHh7QY=;
 b=SAWKGTlYAeczHPFC19gnXikPAG8e+Uj3neaZXg7mYPn8ruhDx+GZnekIcVZnJyXUpTiHtuZpWsiatWIg9eEyf4cjsr2cGVQ68wSosWlCySuzpeUoK+I/HK8+QEqEXP+Vr1E/gu2m4McNm9oJcab4ia2HcpBpmJ6GMsW4wdbaddkeo9BfMq7tgwxcfb6udtJM0JhdGCHDomIwWouTJ9C9+qoIIb8gCoUGOPAJsymZE6oZBbjyZ6hyN7noxT4LxzztdaNaa1GPcMRsEkgG+2OljFqPHrAE250Vhkk/yUsX3UF3ukvsIimwytm1rHMw0ZS9+clRlDp9BvRTYAwS+pPKkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oAPZfpZKvERNNnABrYgzEEXzQ8A35HSgqH/zJVHh7QY=;
 b=yRY3jtevx95s/UURjS0A4E+vb5ppdGme4RLj87NJJBUVQkHZLRYRwtSn+b11jUpsaNjf0neB7oXPL0FGnGWE2cb3MYAGC4wutRQnLZZnvkvZbGw+scXDZqbuO4f3XlCXVgss9ScTbDDFWjmvROBdjLgKEvaekPQUzBBIqQcSg2s=
Received: from BN6PR11MB3972.namprd11.prod.outlook.com (10.255.130.75) by
 BN6PR11MB4113.namprd11.prod.outlook.com (10.255.128.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.13; Thu, 8 Aug 2019 16:08:14 +0000
Received: from BN6PR11MB3972.namprd11.prod.outlook.com
 ([fe80::cd3f:3974:3aee:cb31]) by BN6PR11MB3972.namprd11.prod.outlook.com
 ([fe80::cd3f:3974:3aee:cb31%3]) with mapi id 15.20.2157.015; Thu, 8 Aug 2019
 16:08:14 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Laura Garcia <nevola@gmail.com>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: nftables and set with interval
Thread-Topic: nftables and set with interval
Thread-Index: AQHVTd8QkCQXLF7+tEWAmPVNMgtj2qbxO9MA///sVIA=
Date:   Thu, 8 Aug 2019 16:08:13 +0000
Message-ID: <0C41EF82-F2D0-4F20-BC97-6EBF48817694@cisco.com>
References: <554E4490-524C-48D3-834A-F98F3D15D807@cisco.com>
 <CAF90-WhmQ3s2dhVSqHX0woC6eVXBNja3Qnm6Ma0HhHLozU3zSg@mail.gmail.com>
In-Reply-To: <CAF90-WhmQ3s2dhVSqHX0woC6eVXBNja3Qnm6Ma0HhHLozU3zSg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1b.0.190715
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.84]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e5d29afc-e93c-47ef-734f-08d71c1a9ded
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR11MB4113;
x-ms-traffictypediagnostic: BN6PR11MB4113:
x-microsoft-antispam-prvs: <BN6PR11MB41136792C11BEF0E084F8D14C4D70@BN6PR11MB4113.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(396003)(136003)(346002)(366004)(199004)(189003)(53936002)(8676002)(7736002)(6486002)(4326008)(6512007)(305945005)(6246003)(1411001)(14454004)(8936002)(478600001)(66066001)(81156014)(81166006)(86362001)(229853002)(256004)(6916009)(446003)(71200400001)(71190400001)(76116006)(5660300002)(91956017)(99286004)(53546011)(26005)(186003)(102836004)(6506007)(66556008)(66476007)(33656002)(76176011)(66946007)(66446008)(64756008)(486006)(36756003)(11346002)(6436002)(2906002)(25786009)(476003)(2616005)(3846002)(6116002)(316002)(58126008);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR11MB4113;H:BN6PR11MB3972.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pUO7Mjp5IxVvlffAvgt7xyzB4zSIQggwymiwUElLBKBXafHgZscwnBT1+R1OV0q3mA+19Jx21UdluvmbAeG21c5yIYb5SmZJkO9E2hK1Te7qTJ124GscIYnRaOeFnv5Zokxj9cpaa+Xn7zIi9DB+fYnQw+Vywc447+idrciVAgdFq+9Pt0usHOhLl7Pw0nxkY8ydTKn2VkV5Dx3HxWUEFAytVcxET+eMrkTO859Hfy7VnaJ8vMnvT2SPnPEodKBMgHMM7A+L3cKJlwYN7k+1qGv1fG0tQ2nb+xboSzIA6Qep0NbiETuKZbCVneS8ObSb4wjli9UFvmS9ejNaldGi9kzRKkFCXsaRkTfoEcd6TDBZiBW+cmCKyh1NRCqgrEprZoljrYjE0mCmTZLxSaX9zbXVq0xGWURZN2NzWg/YOzE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <AFF1CC307BCDAB45809E3633E3438290@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e5d29afc-e93c-47ef-734f-08d71c1a9ded
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 16:08:13.8157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vw3oJannE6KqX19QgTM8uC4fehaYjtgcViEfscKKOhQdvqUrSbXYmiK0pla9rR8AU3Ux0ChfRUEAE4qU0NBpmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB4113
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.14, xch-rcd-004.cisco.com
X-Outbound-Node: alln-core-1.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SSBoYXZlIG1hZGUgYSBsaXR0bGUgcHJvZ3Jlc3MsIHNvIG5vdyBJIGJ1aWxkIHRoaXMgZnJvbSB0
aGUgY29kZSwgYnV0IEkgZG8gbm90IHRoaW5rIGl0IHRvdGFsbHkgcmlnaHQsIGJlY2F1c2Ugb25s
eSAxMC4xNi4wLjAvMTYgYW5kIDE5Mi4xNi4wLjAvMTYgc2hvdWxkIHNob3cgdXAsIHRoZXNlIHRo
cmVlIGVsZW1lbnRzIA0KMC4wLjAuMC0xMC4xNS4yNTUuMjU1LCAxMC4xNy4wLjAtMTkyLjE1LjI1
NS4yNTUsIDE5Mi4xNy4wLjAtMjU1LjI1NS4yNTUuMjU1IGFyZSBzdXBwb3NlZCB0byBiZSBleGNs
dWRlZC4NCg0Kc3VkbyBuZnQgbGlzdCB0YWJsZSBpcHY0dGFibGUNCnRhYmxlIGlwIGlwdjR0YWJs
ZSB7DQoJc2V0IDI0NmFlNDI2ZjgxMCB7DQoJCXR5cGUgaXB2NF9hZGRyDQoJCWZsYWdzIGNvbnN0
YW50LGludGVydmFsDQoJCWVsZW1lbnRzID0geyAwLjAuMC4wLTEwLjE1LjI1NS4yNTUsIDEwLjE2
LjAuMC8xNiwNCgkJCSAgICAgMTAuMTcuMC4wLTE5Mi4xNS4yNTUuMjU1LCAxOTIuMTYuMC4wLzE2
LA0KCQkJICAgICAxOTIuMTcuMC4wLTI1NS4yNTUuMjU1LjI1NSB9DQoJfQ0KDQoJY2hhaW4gaXB2
NGNoYWluLTEgew0KCQl0eXBlIGZpbHRlciBob29rIGlucHV0IHByaW9yaXR5IGZpbHRlcjsgcG9s
aWN5IGFjY2VwdDsNCgkJaXAgZGFkZHIgQDI0NmFlNDI2ZjgxMCByZXR1cm4gY29tbWVudCAicFUi
DQoJfQ0KfQ0KDQpJbiBzZXQgd2l0aCBpbnRlcnZhbHMsIHdoYXQgYXR0cmlidXRlcyBvciBob3cg
dG8gaW5kaWNhdGUgRXhjbHVzaW9uIFNldEVsZW1lbnQ/DQoNClRoYW5rIHlvdQ0KU2VyZ3VlaQ0K
DQrvu79PbiAyMDE5LTA4LTA4LCA5OjE5IEFNLCAiTGF1cmEgR2FyY2lhIiA8bmV2b2xhQGdtYWls
LmNvbT4gd3JvdGU6DQoNCiAgICBPbiBUaHUsIEF1ZyA4LCAyMDE5IGF0IDE6NTYgUE0gU2VyZ3Vl
aSBCZXp2ZXJraGkgKHNiZXp2ZXJrKQ0KICAgIDxzYmV6dmVya0BjaXNjby5jb20+IHdyb3RlOg0K
ICAgID4NCiAgICA+IEhlbGxvLA0KICAgID4NCiAgICA+IEkgYW0gZGV2ZWxvcGluZyBnb2xhbmcg
bmZ0YWJsZXMgbGlicmFyeUkgYW0gZGVidWdnaW5nIG5mdGFibGVzIHNldCB3aXRoIGVsZW1lbnRz
IGRlZmluaW5nIGludGVydmFscy4gSSBjb21wYXJlIHdoYXQgZ2V0cyBnZW5lcmF0ZWQgYnkgbmZs
IGNvbW1hbmQgYW5kIHN0cmFjZSBvZiBteSBjb2RlLg0KICAgID4NCiAgICA+IEJhc2VkIG9uIHRo
ZSBvdXRwdXQgb2YgdGhpcyBjb21tYW5kOg0KICAgID4NCiAgICA+IHN1ZG8gbmZ0IC0tZGVidWcg
YWxsIGFkZCBydWxlIGlwdjR0YWJsZSBpcHY0Y2hhaW4tMSAgaXAgZGFkZHIgeyAxOTIuMTYuMC4w
LzE2LCAxMC4xNi4wLjAvMTYgfSByZXR1cm4NCiAgICA+DQogICAgPiBJdCBzZWVtcyBuZnQgc2V0
cyB1cCBORlROTF9TRVRfS0VZX1RZUEUgICgweDQpIGFzIDB4MiBhbmQgSSBjYW5ub3QgZmluZCBh
bnl3aGVyZSB3aGF0IGl0IG1lYW5zLg0KICAgID4ge3tubGFfbGVuPTgsIG5sYV90eXBlPTB4NH0s
ICJceDAwXHgwMFx4MDBceDAyIn0sDQogICAgPg0KICAgID4gV2hlbiBJIGRlY29kZSBzdHJhY2Ug
Z2VuZXJhdGVkIGZvciBteSBjb2RlLCBpdCBhbHdheXMgZ2V0cyBzZXQgdG8geDAxDQogICAgPiB7
e25sYV9sZW49OCwgbmxhX3R5cGU9MHg0fSwgIlx4MDBceDAwXHgwMFx4MDEifSwNCiAgICA+DQog
ICAgDQogICAgSGksIGFyZSB5b3UgaW50ZXJhY3RpbmcgZGlyZWN0bHkgd2l0aCBuZXRsaW5rPw0K
ICAgIERpZCB5b3UgY29uc2lkZXIgdXNpbmcgdGhlIGhpZ2hlciBsZXZlbCBsaWJyYXJ5IGxpYm5m
dGFibGVzIGluc3RlYWQ/DQogICAgDQogICAgQ2hlZXJzLg0KICAgIA0KDQo=
