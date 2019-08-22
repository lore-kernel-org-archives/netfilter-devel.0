Return-Path: <SRS0=orVX=WS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5663FC3A5A1
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Aug 2019 15:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 135BA233A2
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Aug 2019 15:04:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="bItvN2gw";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="AEB08C0X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387529AbfHVPEh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Aug 2019 11:04:37 -0400
Received: from rcdn-iport-7.cisco.com ([173.37.86.78]:3995 "EHLO
        rcdn-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733195AbfHVPEh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Aug 2019 11:04:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1548; q=dns/txt; s=iport;
  t=1566486277; x=1567695877;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ztS4PtRoY718hR1LCHUoBb1zvqJ1Ot9UIDQruWEdbOo=;
  b=bItvN2gwCZ3QvmhwZZyl4WEeigser8bhIhf8+DwQu5K0MO/swxL46kzz
   1mFnyT27QGzj7KLiwZDUmvHOtHTr6XZg5RWDGR67N7CCT3pySJx1dtQxv
   ZeH83hRcAQOIprOjCvSMgE/B/HjkIuHEQJDxeYmQ/MpVNmtpqPjFQPL6P
   g=;
IronPort-PHdr: =?us-ascii?q?9a23=3A7TBTsBHacrZnV+9swJ2JQp1GYnJ96bzpIg4Y7I?=
 =?us-ascii?q?YmgLtSc6Oluo7vJ1Hb+e4z1Q3SRYuO7fVChqKWqK3mVWEaqbe5+HEZON0pNV?=
 =?us-ascii?q?cejNkO2QkpAcqLE0r+eeXgYj4kEd5BfFRk5Hq8d0NSHZW2ag=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0CpAACRrl5d/4QNJK1kGgEBAQEBAgE?=
 =?us-ascii?q?BAQEHAgEBAQGBZ4FFUAOBQiAECyoKhBaDRwOKaoJcl2aCUgNUCQEBAQwBAS0?=
 =?us-ascii?q?CAQGEPwIXgkgjOBMCCQEBBAEBAwEGBG2FLQyFSwEBAQMSEREMAQE3AQ8CAQg?=
 =?us-ascii?q?OCgICJgICAjAVEAIEDgUigwCBawMdAZ9RAoE4iGFzgTKCewEBBYJHglMYghY?=
 =?us-ascii?q?JgQwohHqGdRiBQD+BOB+CTD6ERBeCdDKCJo8YnEgJAoIdlD0bmEqlcgIEAgQ?=
 =?us-ascii?q?FAg4BAQWBZyGBWHAVZQGCQYJCDBeDT4pTcoEpij4BgSABAQ?=
X-IronPort-AV: E=Sophos;i="5.64,417,1559520000"; 
   d="scan'208";a="614310346"
Received: from alln-core-10.cisco.com ([173.36.13.132])
  by rcdn-iport-7.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 22 Aug 2019 15:04:36 +0000
Received: from XCH-ALN-008.cisco.com (xch-aln-008.cisco.com [173.36.7.18])
        by alln-core-10.cisco.com (8.15.2/8.15.2) with ESMTPS id x7MF4aM7007974
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 22 Aug 2019 15:04:36 GMT
Received: from xhs-aln-001.cisco.com (173.37.135.118) by XCH-ALN-008.cisco.com
 (173.36.7.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 22 Aug
 2019 10:04:35 -0500
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by xhs-aln-001.cisco.com
 (173.37.135.118) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 22 Aug
 2019 10:04:34 -0500
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-002.cisco.com (64.101.210.229) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 22 Aug 2019 11:04:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A/DTPVicvkBLvOiu0jnYubNfeDDobk99WBazuaGxjRsukE7d6EUo6pyeGbhcFvcKFBQxoYxMVFz3PjMZooba7sooSQrJIGrbyDkF9ZSPJBW7UpoAEYOxV2dCOwldFK5p4ZHPFti/3+9SWAd7cxvPhoKphKdT0mF13vQfF6muegqidHyA2Qff7LVGPIzlZHG0c05i+UR9Dh4jBNqF4eE1HvWYOfEirfYtdklJp4SHtn2JZgeIqCngUR2pPlLvvQiWr7Q90gNHyQMhFdPRgL5lL0pxRZkAcynLtufgkfBUnWlBvciZcyyCaPzCJfyhA16sT5235I3Z3zluVeBs6C8h1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ztS4PtRoY718hR1LCHUoBb1zvqJ1Ot9UIDQruWEdbOo=;
 b=nx+L+BfxOw2JpM0HErJ1/8A7N6sYdebEEEzC0DiDnxT5IWovAPKCbtpjseu7eWFoBgzyzqfbYrpGkHq/cnYDxWAOcm4jHvo56k+fxkOqa/busyjKWssMIKPSKVqeT/5T15l1nfgsqQFkcQTnqvsR9Hlj1ejeSI7KEa5YMxRH4e3pyz2eMZ5RsboOh0Od4Qg7XiRYWvRbn+LwDwbqbBaxkZIXqqwsVxUY4qbdMoN0NrraLkfkg36uvI6Sgky7QLAhQuOulKYSZP9SfArLHa8P2271R+nrkgYMIyNMJQpyFNCkm5i922sHAEAnsvVWxitcgsV9s64N+Y4pHZF6ZG5bKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ztS4PtRoY718hR1LCHUoBb1zvqJ1Ot9UIDQruWEdbOo=;
 b=AEB08C0XP6YlEd6OofS7HQVtfc2iOLWuDkfsCkEEyScSWL3PlvVw70rLndLUYMEYZzBxaUrmQkPXUO/apiOpbvGvUKPgzorxJCISfaL/RQXpTmtmSGgrIcuurbSuQzlgvKSNf/+XT4pPpW8F5H263p4swkr+WmBr8+fY5oVWeIs=
Received: from BN6PR11MB1460.namprd11.prod.outlook.com (10.172.21.136) by
 BN6PR11MB1570.namprd11.prod.outlook.com (10.172.21.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Thu, 22 Aug 2019 15:04:32 +0000
Received: from BN6PR11MB1460.namprd11.prod.outlook.com
 ([fe80::531:1342:6daf:28d5]) by BN6PR11MB1460.namprd11.prod.outlook.com
 ([fe80::531:1342:6daf:28d5%11]) with mapi id 15.20.2178.020; Thu, 22 Aug 2019
 15:04:32 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Florian Westphal <fw@strlen.de>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: nft equivalent of iptables command
Thread-Topic: nft equivalent of iptables command
Thread-Index: AQHVWPGGzbiV3UpkmEmnxgajwrqrkacHNpGA///KTAA=
Date:   Thu, 22 Aug 2019 15:04:32 +0000
Message-ID: <C6DBAA3A-A50D-47C5-97B8-D01977820E7F@cisco.com>
References: <69AAC254-AF78-4918-82B5-14B3EDB10EDB@cisco.com>
 <20190822141645.GH20113@breakpoint.cc>
In-Reply-To: <20190822141645.GH20113@breakpoint.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1c.0.190812
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.84]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 67f1325e-dbe4-4411-570c-08d727120a14
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BN6PR11MB1570;
x-ms-traffictypediagnostic: BN6PR11MB1570:
x-microsoft-antispam-prvs: <BN6PR11MB1570F0FF536FC29064EB6092C4A50@BN6PR11MB1570.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(39860400002)(346002)(376002)(396003)(199004)(189003)(2616005)(64756008)(476003)(81156014)(478600001)(486006)(6512007)(446003)(14454004)(229853002)(99286004)(58126008)(33656002)(256004)(11346002)(5660300002)(102836004)(186003)(26005)(6506007)(4744005)(71190400001)(81166006)(36756003)(76116006)(3846002)(66446008)(25786009)(4326008)(316002)(86362001)(66476007)(6246003)(8676002)(66946007)(66556008)(91956017)(2906002)(76176011)(6916009)(6486002)(53936002)(6436002)(305945005)(66066001)(7736002)(6116002)(8936002)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR11MB1570;H:BN6PR11MB1460.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Dp7D7K6DvW11iwCBkKR6EKmPA/QlZsE/beUMeB5Sex2HxWrpPEjzQqBrC7vPRH+bx6OFk9twnBn06e5Eey5pAEJiHjW9cQ7HUyV0tZFIC53VaYjl17258L9+A8YXr9fsWgQJR9pre8mStavaanIHatVKIkXam7NFL2IG/N424oaAFfA5X3K3aHvpRnCr7fnDbc5+MaWRKPg8ScflBAb2ABDYDWBHwRngijN+aANcjnmX9IHlSH5+MwJ2I3v9El6UZso+7cPDw7shU8nk54W+YgoyHjoax6/6zMQoIryoqSb3Ni4dNrNwDrZJc2ONkZxPt6DuSceWNLqKN7X6ZUHvbsM8/f9wdUSdqfZStSmMF3fLhNR8Jo6UHgSn/697BzwvZt7xM67S5xpe6lTTyz/hj8Qp8ZFWN5mvD16rN0N0iwo=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <ABF977FBF53D464483B52AD689823133@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 67f1325e-dbe4-4411-570c-08d727120a14
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 15:04:32.7074
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fVOmVKN9ju5LjsMRnYt++H3o5qB5k+eZ9z8CBc8YqeRHnH76VWOEkrXsb9CbinkpTCuWAGm9rSWdl0cSdJQ3KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1570
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.18, xch-aln-008.cisco.com
X-Outbound-Node: alln-core-10.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

VGhhbmsgeW91IHZlcnkgbXVjaCBGbG9yaWFuLiBJIHdpbGwgdXNlIGZpYiB0eXBlIGxvY2FsIGFz
IGEgcmVwbGFjZW1lbnQuDQpTZXJndWVpIA0KDQrvu79PbiAyMDE5LTA4LTIyLCAxMDoyMCBBTSwg
IkZsb3JpYW4gV2VzdHBoYWwiIDxmd0BzdHJsZW4uZGU+IHdyb3RlOg0KDQogICAgU2VyZ3VlaSBC
ZXp2ZXJraGkgKHNiZXp2ZXJrKSA8c2JlenZlcmtAY2lzY28uY29tPiB3cm90ZToNCiAgICA+IEhl
bGxvLA0KICAgID4gDQogICAgPiBJIGFtIHRyeWluZyB0byBmaW5kIGFuIGVxdWl2YWxlbnQgbmZ0
IGNvbW1hbmQgZm9yIHRoZSBmb2xsb3dpbmcgaXB0YWJsZXMgY29tbWFuZC4gIFNwZWNpZmljYWxs
eSAicGh5c2RldiIgYW5kICJhZGRydHlwZSIsIEkgY291bGQgbm90IGZpbmQgc28gZmFyLCBzb21l
IGhlbHAgd291bGQgYmUgdmVyeSBhcHByZWNpYXRlZC4NCiAgICANCiAgICA+IC1tIHBoeXNkZXYg
ISAtLXBoeXNkZXYtaXMtaW4gICAgICAgICAgICANCiAgICANCiAgICBUaGlzIGhhcyBubyBlcXVp
dmFsZW50LiAgVGhlIHJ1bGUgYWJvdmUgbWF0Y2hlcyB3aGVuICdjYWxsLWlwdGFibGVzJyBzeXNj
dGwNCiAgICBpcyBlbmFibGVkIGFuZCB0aGUgcGFja2V0IGRpZCBub3QgZW50ZXIgdmlhIGEgYnJp
ZGdlIGludGVyZmFjZS4NCiAgICBTbywgaXRzIG9ubHkgZmFsc2Ugd2hlbiBpdCBkaWQgZW50ZXIg
dmlhIGEgYnJpZGdlIGludGVyZmFjZS4NCiAgICANCiAgICBJbiBjYXNlIHRoZSBzeXNjdGwgaXMg
b2ZmLCB0aGUgcnVsZSBhbHdheXMgbWF0Y2hlcyBhbmQgY2FuIGJlIG9taXR0ZWQuDQogICAgDQog
ICAgbmZ0YWJsZXMgY3VycmVudGx5IGFzc3VtZXMgdGhhdCBjYWxsLWlwdGFibGVzIGlzIG9mZiwg
YW5kIHRoYXQNCiAgICBicmlkZ2VzIGhhdmUgdGhlaXIgb3duIGZpbHRlciBydWxlcyBpbiB0aGUg
bmV0ZGV2IGFuZC9vcg0KICAgIGJyaWRnZSBmYW1pbGllcy4NCiAgICANCiAgICBpbmV0L2lwL2lw
NiBhcmUgYXNzdW1lZCB0byBvbmx5IHNlZSBwYWNrZXRzIHRoYXQgYXJlIHJvdXRlZCBieSB0aGUg
aXANCiAgICBzdGFjay4NCiAgICANCiAgICA+IC1tIGFkZHJ0eXBlICEgLS1zcmMtdHlwZSBMT0NB
TCANCiAgICANCiAgICBmaWIgc2FkZHIgdHlwZSAhPSBsb2NhbA0KICAgIA0KDQo=
