Return-Path: <SRS0=+PqO=WE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FF88C0650F
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Aug 2019 13:32:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C8A321479
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Aug 2019 13:32:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="b2TWf8JX";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="j8SmIRsm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733158AbfHHNc4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Aug 2019 09:32:56 -0400
Received: from alln-iport-3.cisco.com ([173.37.142.90]:1781 "EHLO
        alln-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733103AbfHHNc4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Aug 2019 09:32:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2818; q=dns/txt; s=iport;
  t=1565271175; x=1566480775;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=irzu5BYA6SyNnpgApHq47Ga1ykx90grEY8o5wh02UZ4=;
  b=b2TWf8JXtAKhNGjhHkpqWwztndjYtmEw+YDJukHsdYVDAcpz+CmmUKna
   LQSkJyeOqYjiebt+KQmatgIt+QvQv4x05Is+O5YtkAxq0o3NbJ6Dy0J0E
   A9XFV/oD8pC8tZ58dBX/6aCD3AFsaGWxFoCzCa2Py4WsMB6B0myYkBqzX
   c=;
IronPort-PHdr: =?us-ascii?q?9a23=3AUWRQsx/rPMUJff9uRHGN82YQeigqvan1NQcJ65?=
 =?us-ascii?q?0hzqhDabmn44+8ZR7E/fs4iljPUM2b8P9Ch+fM+4HYEW0bqdfk0jgZdYBUER?=
 =?us-ascii?q?oMiMEYhQslVdWPBF/lIeTpRyc7B89FElRi+iLzPA=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AgAABBJExd/5NdJa1mGQEBAQEBAQE?=
 =?us-ascii?q?BAQEBAQcBAQEBAQGBVgEBAQEBAQsBgURQA4FCIAQLKgqEFINHA4szgjYliVu?=
 =?us-ascii?q?OBYJSA1QJAQEBDAEBLQIBAYQ/AheCPyM3Bg4BBAEBBAEBBAEKbYUnDIVLAQE?=
 =?us-ascii?q?BAxIREQwBATcBDwIBCA4KAgImAgICHxEVEAIEDgUigwCBawMdAaB0AoE4iGB?=
 =?us-ascii?q?xgTKCegEBBUWCA4JQDQuCFAmBDCgBhHKGcReBQD+BOAwTgkw+ghqCKheCdDK?=
 =?us-ascii?q?CJo8PhSuIWo1qQAkCgh2QMYN4G5g2lyWLUoJSAgQCBAUCDgEBBYFmIoFYcBV?=
 =?us-ascii?q?lAYJBUBAUgU4MF4NOilNygSmKTwGBIAEB?=
X-IronPort-AV: E=Sophos;i="5.64,361,1559520000"; 
   d="scan'208";a="315087604"
Received: from rcdn-core-11.cisco.com ([173.37.93.147])
  by alln-iport-3.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 08 Aug 2019 13:32:55 +0000
Received: from XCH-RCD-007.cisco.com (xch-rcd-007.cisco.com [173.37.102.17])
        by rcdn-core-11.cisco.com (8.15.2/8.15.2) with ESMTPS id x78DWs1R024319
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 8 Aug 2019 13:32:54 GMT
Received: from xhs-rcd-003.cisco.com (173.37.227.248) by XCH-RCD-007.cisco.com
 (173.37.102.17) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 8 Aug
 2019 08:32:54 -0500
Received: from xhs-aln-003.cisco.com (173.37.135.120) by xhs-rcd-003.cisco.com
 (173.37.227.248) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 8 Aug
 2019 08:32:52 -0500
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-003.cisco.com (173.37.135.120) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 8 Aug 2019 08:32:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CWxiMH1/LeRSj+vs8E9GqEKmbvsbfD3wcTbloFiAjuCVaS3006XZl6x6F3kOKIAVVLM913R3BCnQdxYZkUvqWDjazeYawH1YPQ6Qq4VCArQ21C6H/fxuh9JAaDz6wL80NGAD02vyePQQki01F3edIgQmehc5EuSh3tVHK8nvgHJoPGdPYkaMscTfrI7IuUc+6gJg4BUpvirPCPtm+LnPInjs/UK9clGXMGjqseNv1gaU3iT+J6RSlt+bnAHLmLc8qfpkRk4tqzfjXHH9kLM36lm4Uw0hdDT1Spd7Kj+++8B/vNtijs9sxEY7pz6dZkV+WyR3qX1NpZsoRbJULFp/9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=irzu5BYA6SyNnpgApHq47Ga1ykx90grEY8o5wh02UZ4=;
 b=SWSKstfYnZel9ZspqQPmcn1ybfz4R/mzOnoG7nu6CMST0FimHPLVFVBXV9b7NrJZvj4lRbdHZQFZgXezAZlMA5Aj0KHvvOlchrqMnpjQIUM8UMqbQ99rnG0N/RJIdCovIxQ2YUQ7Hb0b6OTjmCW3slSBdvJvfPmLSlvW4Pu8fn3esxOb7MCt9f0GUmFmZLL3hneHOhronHA00bDs+tk650xXsnVNDSGmC4XhDZ0NFCPWOu1drTBvrp6slxfunZIAJosnLXpJQdeiEKkKBpxhMWKWnLOk6H4dxED+DGE6FIO+sjEUcob2Ejmomci0KDUOofQe/UPo2J7n72l7AAdNgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=irzu5BYA6SyNnpgApHq47Ga1ykx90grEY8o5wh02UZ4=;
 b=j8SmIRsmBarFoB/CAoeqajebvlgpGrP+qjLvP3r7HlM8Myrqvva59Dsc0R/IGI0fkePwBe42rPSknQU+4HsY3MJ7u56C/acpYlelwI5HVrT469DnearHDjdPAW62SrazWc/DAJaIyxaQLNEYCWpy0JDgGHByL9w6FjVOA5Pqmo8=
Received: from BN6PR11MB3972.namprd11.prod.outlook.com (10.255.130.75) by
 BN6PR11MB1745.namprd11.prod.outlook.com (10.175.99.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Thu, 8 Aug 2019 13:32:50 +0000
Received: from BN6PR11MB3972.namprd11.prod.outlook.com
 ([fe80::cd3f:3974:3aee:cb31]) by BN6PR11MB3972.namprd11.prod.outlook.com
 ([fe80::cd3f:3974:3aee:cb31%3]) with mapi id 15.20.2157.015; Thu, 8 Aug 2019
 13:32:50 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Laura Garcia <nevola@gmail.com>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: nftables and set with interval
Thread-Topic: nftables and set with interval
Thread-Index: AQHVTd8QkCQXLF7+tEWAmPVNMgtj2qbxO9MA///A64A=
Date:   Thu, 8 Aug 2019 13:32:50 +0000
Message-ID: <A82140E3-137F-4381-94B5-53B1D95FD6E1@cisco.com>
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
x-ms-office365-filtering-correlation-id: 2d2aa349-c14e-4457-321d-08d71c04e8df
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR11MB1745;
x-ms-traffictypediagnostic: BN6PR11MB1745:
x-microsoft-antispam-prvs: <BN6PR11MB174580264E55E72DF0321A7EC4D70@BN6PR11MB1745.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(39860400002)(376002)(396003)(366004)(189003)(199004)(40764003)(2906002)(6486002)(446003)(2616005)(476003)(11346002)(229853002)(71200400001)(99286004)(14454004)(3846002)(6436002)(1411001)(6116002)(486006)(478600001)(6916009)(102836004)(33656002)(76116006)(6512007)(25786009)(186003)(8676002)(36756003)(64756008)(76176011)(305945005)(316002)(5660300002)(8936002)(81166006)(71190400001)(256004)(81156014)(6246003)(53936002)(66066001)(4326008)(26005)(53546011)(66556008)(58126008)(66476007)(66446008)(66946007)(86362001)(6506007)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR11MB1745;H:BN6PR11MB3972.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: B6IDPt98rgM4TvcqmgTYmrBqVF6KCBrCe92WtzLZZe5nJhTVuzLRxXfAq74xiWS2OtpYpqoFulh8YBt3BMfrik4ppgdaNhdY+ytAL9SDuoMA7ydtS7EoZA1KzLNS3BoRvHVycOXKB03ZJ77dbIfohf4XgWDVKUSMbaJBAWoCj+5zURi6Z/2dOxjFcaip2hRkg7qnF61u0TcQW1PzZujJIRIxuS12b2M09+FomuW6mM8tTDIAQBol83erlEXKYi2Bs6W7sZDWvKRpDe6sGzznuv+Uw2Fz3PiJ5SxRZxlo8LTBRlsXmchsRz2moZds2ftYJfWVr/TPCe4y67soE+6natMLc2tfB05jzphjU/eN/7PDOJG+vtyDvf78Mi7/njZKd028pmllbateq8ijvb6k8EXW8VpdV9ona1zML/4CdR8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <120BB11239ED6146A7DB82E555354A0D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d2aa349-c14e-4457-321d-08d71c04e8df
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 13:32:50.6334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HJUOlku3CPTQgZTcUfdbLrnP+evFObEEJ1Lr7zvNc9OgagoKwI/W1/pTl/GHdAUYGY/HwCdNGZDn06GokmaGTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1745
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.17, xch-rcd-007.cisco.com
X-Outbound-Node: rcdn-core-11.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGVsbG8gTGF1cmEsDQoNCkFzIEkgbWVudGlvbmVkIHRoZSBjb2RlIHVzZXMgZ29sYW5nLCB0byBp
bnRlcmFjdCB3aXRoIG5ldGxpbmsgSSB1c2UgZ29sYW5nIGxpYnJhcnkgZm9yIG5ldGxpbmsgYW5k
IGFub3RoZXIgZ29sYW5nIGxpYnJhcnkgZm9yIGV4cHJlc3Npb25zIHByaW1pdGl2ZXMuIA0KQmFz
aWNhbGx5IGl0IHdvcmtzIGZvciBnb29kIG51bWJlciBvZiBleHByZXNzaW9ucywgYnV0IHdoZW4g
SSBnZXQgdG8gbW9yZSBjb21wbGV4IHRoaW5ncyBsaWtlIHNldHMgd2l0aCBpbnRlcnZhbHMsIEkg
aGl0IHByb2JsZW0gd2hlbiBzZXQgZG9lcyBub3QgZ2V0IGNyZWF0ZWQsIHRoZSBzdHJhbmdlIHRo
aW5nIGlzIG5ldGxpbmsgZG9lcyBub3QgcmV0dXJuIGFueSBlcnJvcnMgb24gc2V0IGNyZWF0ZSBl
aXRoZXIuIA0KDQpIZXJlIGlzIGhvdyBJIGNyZWF0ZSBzZXQgd2l0aCBpbnRlcnZhbHM6DQoJYy5B
ZGRTZXQoJm5mdGFibGVzLlNldHsNCgkJVGFibGU6ICAgICB0LA0KCQlJRDogICAgICAgIHVpbnQz
Mig1KSwNCgkJTmFtZTogICAgICAiaW50ZXJ2YWwtc2V0IiwNCgkJQW5vbnltb3VzOiBmYWxzZSwN
CgkJQ29uc3RhbnQ6ICB0cnVlLA0KCQlJbnRlcnZhbDogIHRydWUsDQoJCUtleVR5cGU6ICAgbmZ0
YWJsZXMuVHlwZUlQQWRkciwgLy8gMHg3DQoJCURhdGFMZW46ICAgNCwNCgl9LCBbXW5mdGFibGVz
LlNldEVsZW1lbnR7DQoJCXtLZXk6IFtdYnl0ZXswLCAwLCAwLCAwfSwgVmFsOiBbXWJ5dGV7MX19
LA0KCQl7S2V5OiBbXWJ5dGV7MTAsIDE2LCAwLCAwfSwgVmFsOiBbXWJ5dGV7MH19LA0KCQl7S2V5
OiBbXWJ5dGV7MTAsIDE3LCAwLCAwfSwgVmFsOiBbXWJ5dGV7MX19LA0KCQl7S2V5OiBbXWJ5dGV7
MTkyLCAxNiwgMCwgMH0sIFZhbDogW11ieXRlezB9fSwNCgkJe0tleTogW11ieXRlezE4MiwgMTcs
IDAsIDB9LCBWYWw6IFtdYnl0ZXsxfX0sDQoJfSkNCg0KQW0gSSBtaXNzaW5nIGFueXRoaW5nIGZy
b20gRmxhZ3Mgb3IgYXR0cmlidXRlcyBwZXJzcGVjdGl2ZT8NCg0KVGhhbmsgeW91IGZvciB5b3Vy
IGhlbHANClNlcmd1ZWkgDQoNCu+7v09uIDIwMTktMDgtMDgsIDk6MTkgQU0sICJMYXVyYSBHYXJj
aWEiIDxuZXZvbGFAZ21haWwuY29tPiB3cm90ZToNCg0KICAgIE9uIFRodSwgQXVnIDgsIDIwMTkg
YXQgMTo1NiBQTSBTZXJndWVpIEJlenZlcmtoaSAoc2JlenZlcmspDQogICAgPHNiZXp2ZXJrQGNp
c2NvLmNvbT4gd3JvdGU6DQogICAgPg0KICAgID4gSGVsbG8sDQogICAgPg0KICAgID4gSSBhbSBk
ZXZlbG9waW5nIGdvbGFuZyBuZnRhYmxlcyBsaWJyYXJ5SSBhbSBkZWJ1Z2dpbmcgbmZ0YWJsZXMg
c2V0IHdpdGggZWxlbWVudHMgZGVmaW5pbmcgaW50ZXJ2YWxzLiBJIGNvbXBhcmUgd2hhdCBnZXRz
IGdlbmVyYXRlZCBieSBuZmwgY29tbWFuZCBhbmQgc3RyYWNlIG9mIG15IGNvZGUuDQogICAgPg0K
ICAgID4gQmFzZWQgb24gdGhlIG91dHB1dCBvZiB0aGlzIGNvbW1hbmQ6DQogICAgPg0KICAgID4g
c3VkbyBuZnQgLS1kZWJ1ZyBhbGwgYWRkIHJ1bGUgaXB2NHRhYmxlIGlwdjRjaGFpbi0xICBpcCBk
YWRkciB7IDE5Mi4xNi4wLjAvMTYsIDEwLjE2LjAuMC8xNiB9IHJldHVybg0KICAgID4NCiAgICA+
IEl0IHNlZW1zIG5mdCBzZXRzIHVwIE5GVE5MX1NFVF9LRVlfVFlQRSAgKDB4NCkgYXMgMHgyIGFu
ZCBJIGNhbm5vdCBmaW5kIGFueXdoZXJlIHdoYXQgaXQgbWVhbnMuDQogICAgPiB7e25sYV9sZW49
OCwgbmxhX3R5cGU9MHg0fSwgIlx4MDBceDAwXHgwMFx4MDIifSwNCiAgICA+DQogICAgPiBXaGVu
IEkgZGVjb2RlIHN0cmFjZSBnZW5lcmF0ZWQgZm9yIG15IGNvZGUsIGl0IGFsd2F5cyBnZXRzIHNl
dCB0byB4MDENCiAgICA+IHt7bmxhX2xlbj04LCBubGFfdHlwZT0weDR9LCAiXHgwMFx4MDBceDAw
XHgwMSJ9LA0KICAgID4NCiAgICANCiAgICBIaSwgYXJlIHlvdSBpbnRlcmFjdGluZyBkaXJlY3Rs
eSB3aXRoIG5ldGxpbms/DQogICAgRGlkIHlvdSBjb25zaWRlciB1c2luZyB0aGUgaGlnaGVyIGxl
dmVsIGxpYnJhcnkgbGlibmZ0YWJsZXMgaW5zdGVhZD8NCiAgICANCiAgICBDaGVlcnMuDQogICAg
DQoNCg==
