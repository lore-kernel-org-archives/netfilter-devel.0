Return-Path: <SRS0=sEEs=Z2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PDS_BTC_ID,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55AFCC3F68F
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 15:42:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0E332073B
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 15:42:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="bYjYE5R+";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="MdQggzyM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbfLDPmH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 10:42:07 -0500
Received: from rcdn-iport-9.cisco.com ([173.37.86.80]:48931 "EHLO
        rcdn-iport-9.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728340AbfLDPmH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 10:42:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=4148; q=dns/txt; s=iport;
  t=1575474126; x=1576683726;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zlb8LMJYzW8h0RpO0vSSnAve1Vz6bjQg+XyhomfZOLU=;
  b=bYjYE5R+W6UZlw8e23AYDnt5u02Hn5eN1Dwb4wgTcikRXmkZiCdN2ApF
   01mIbOpE6NDtlEBWt7EVg0vlH4wHyr5f5kHg6bgPhgHjSVuVPPKAQxgNv
   SMWxDJNAqTKw9wlh43mlRAuhm5Epmr/RN9nuw2ODcnPoSWzySM9LUCapn
   4=;
IronPort-PHdr: =?us-ascii?q?9a23=3AXu8bWRBidGqSSXRCZKPYUyQJPHJ1sqjoPgMT9p?=
 =?us-ascii?q?ssgq5PdaLm5Zn5IUjD/qs03kTRU9Dd7PRJw6rNvqbsVHZIwK7JsWtKMfkuHw?=
 =?us-ascii?q?QAld1QmgUhBMCfDkiuN/TnfTI3BsdqX15+9Hb9Ok9QS47z?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0CUBQCR0udd/4wNJK1iAxwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYF+gUtQBYFEIAQLKgqEIYNGA4p6gl+YBIJSA1QJAQEBDAEBLQI?=
 =?us-ascii?q?BAYRAAheBeSQ4EwIDDQEBBAEBAQIBBQRthTcMhVIBAQEBAgEOBBERDAEBIxQ?=
 =?us-ascii?q?BDwIBCBgCAiYCAgIwFRACBA4FIluCJYJHAw4gAaVoAoE4iGB1gTKCfgEBBYJ?=
 =?us-ascii?q?KgkQYghcJgQ4ojBcagUE/gREnIIJMPoRgCiaCSTKCLJAhni0Kgi6VWhuCQYd?=
 =?us-ascii?q?uj3eQD5heAgQCBAUCDgEBBYFpIoFYcBU7KgGCQVARFIxmg3OKU3SBKI1/gTE?=
 =?us-ascii?q?BMF8BAQ?=
X-IronPort-AV: E=Sophos;i="5.69,277,1571702400"; 
   d="scan'208";a="588715911"
Received: from alln-core-7.cisco.com ([173.36.13.140])
  by rcdn-iport-9.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 04 Dec 2019 15:42:04 +0000
Received: from XCH-RCD-008.cisco.com (xch-rcd-008.cisco.com [173.37.102.18])
        by alln-core-7.cisco.com (8.15.2/8.15.2) with ESMTPS id xB4Fg2Ko015739
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 4 Dec 2019 15:42:04 GMT
Received: from xhs-rcd-001.cisco.com (173.37.227.246) by XCH-RCD-008.cisco.com
 (173.37.102.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 4 Dec
 2019 09:42:02 -0600
Received: from xhs-aln-003.cisco.com (173.37.135.120) by xhs-rcd-001.cisco.com
 (173.37.227.246) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 4 Dec
 2019 09:42:01 -0600
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-003.cisco.com (173.37.135.120) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 4 Dec 2019 09:42:01 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dxAlnc3KT78/gdclMyL6D8hM3TaMekrFMtxk8DUwqrGZYNSpHGe8GGWIUetWUPWgkTmbmp/5PgILh02TLy1D7HD/YyMLOh7KI6rzGKgySGIfA96LP/BtuTnqTdd719S3HIId7ame8fwwYb9Yy+u9BibigY31Olar3P9pgqCfR2Bt2JHUa3lxpZjzMOdbery/9Xvn5R1TY2ETh8iSjG/B2eD5XQWlRof8hECNFSg3CKFI4A0y5F1aVns5QCRxagUt69BRAnoHkgZTvozGM+E+XkT4j/dG+kXtvijhyWIujwNFyVdba9fvlAK32F9757QtzNAP47CGOBzN5nOu0yi3jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zlb8LMJYzW8h0RpO0vSSnAve1Vz6bjQg+XyhomfZOLU=;
 b=Qerx4PqP1yOkYxx8DqF6uCL8g37IwS7Drm3zuAnAZUMMRPrNIUH5/gmiC+AWWnrUUuodljwEpoZfKzPJqxz4DhNMCpHnXdEwXfCPx+WDDaDzGvj7FzkUkUSvyv8kbFpRql/nrK+Ai1a2iFd5y85yZQROcdHGZRxrpRjHxyUE2Z/LdQO5vQey9xzQoG576DstEk3fJQxbfdg3XeM7PC807HopjBewyMMuzhzahp3gK8kTq7iSmkq/GcSCdEgQJEDjgyN+sQL4FMYctzrEK4p/ReaPLxBFiDh+TtoC7sSZnhB77FCCVCAYdrJvh9GYdiK36M/LjokVDQqiWcvw5vAmuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zlb8LMJYzW8h0RpO0vSSnAve1Vz6bjQg+XyhomfZOLU=;
 b=MdQggzyMhz++tUCeXMvWrNDrRZQaqGvHZl+ZLFXyHGyROMxrgJb4KLKNURHIaSMn4A9NWCwo47i64aDkID1IJ3A7BCrMqsglpg8bOzTz6oQbtapRrgP504qIG6xsawjbbMWJbbGF5p64gumgqRZ5wjwvR/GwYKzfxlRHKskdLaA=
Received: from DM5PR11MB1484.namprd11.prod.outlook.com (10.172.36.14) by
 DM5PR11MB1388.namprd11.prod.outlook.com (10.168.107.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Wed, 4 Dec 2019 15:42:00 +0000
Received: from DM5PR11MB1484.namprd11.prod.outlook.com
 ([fe80::b8d0:b659:6b84:fa7a]) by DM5PR11MB1484.namprd11.prod.outlook.com
 ([fe80::b8d0:b659:6b84:fa7a%10]) with mapi id 15.20.2516.003; Wed, 4 Dec 2019
 15:42:00 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Phil Sutter <phil@nwl.cc>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Numen with reference to vmap
Thread-Topic: Numen with reference to vmap
Thread-Index: AQHVqj1Ubs5ZA1L3AEmU3M7cfc9ezqepw9GA///mtACAAGztAP//svyA
Date:   Wed, 4 Dec 2019 15:42:00 +0000
Message-ID: <5337E60B-E81D-46ED-912F-196E23C76701@cisco.com>
References: <EC8889A1-27E2-4DC9-B752-514689982085@cisco.com>
 <20191204101819.GN8016@orbyte.nwl.cc>
 <AFC93A41-C4DD-4336-9A62-6B9C6817D198@cisco.com>
 <20191204151738.GR14469@orbyte.nwl.cc>
In-Reply-To: <20191204151738.GR14469@orbyte.nwl.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.86]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 16a233ff-8501-45fd-cffd-08d778d080df
x-ms-traffictypediagnostic: DM5PR11MB1388:
x-microsoft-antispam-prvs: <DM5PR11MB1388A3D05E63D69D8BCAB0C2C45D0@DM5PR11MB1388.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0241D5F98C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(199004)(189003)(66946007)(25786009)(478600001)(91956017)(4326008)(76116006)(14454004)(102836004)(6506007)(8676002)(53546011)(26005)(186003)(316002)(58126008)(99286004)(5660300002)(76176011)(66476007)(66556008)(64756008)(66446008)(71200400001)(81166006)(11346002)(305945005)(2616005)(14444005)(7736002)(36756003)(6436002)(2906002)(8936002)(6246003)(229853002)(6486002)(3846002)(6116002)(33656002)(6916009)(86362001)(81156014)(6512007)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB1388;H:DM5PR11MB1484.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bRl7rTrPHvnmYQ1/IJuyVfQoDx3lXWprskm6sY0AX8lgpp229uJOgM4NoPHvMxIhQXpoKndILB33P0+dFxuzUR4uleu0ZD8i1tt4+0JsV3+OJke6RuzdwGW8eyoO1mF/RG7q3BiKrlEZxsnFG+DXPI8yB5EyGLSh8Fjx5NP3o63mi3d8YWxER1SUPlQ4LM3eT1YxANkAbS4b3QiTz3jVMcar6aWh+PLNOho8bCGFDgHWEMI5bLymeOHcoRKH9rdKWpJ4io5Yogc2Pfxf9+ZzZBCc9bWdSzNcRQAw6Pq6xYhDzPECQMsKrpoaSO8rwYosKIYRVJIXcTVP3SF/Ij6B4cDhxQ0r441cqgql2QcIIde5kG18HRS1sPi7/Yv8ElFg8Q9ydG0JJO2n+G7Z45ebZ1uzLlwY/l8cfE7k7g48Vw/gifUdpsLpf2jcJTEiT4OV
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <7B8CD56D91326B43A9D50537E009821A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 16a233ff-8501-45fd-cffd-08d778d080df
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2019 15:42:00.5297
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jMldAgK7SJcbqSQ0T+uq4z5V+n7kr1YdF3OEOcymeypOZXQCX6v+EVU+JoRZJdb5i4j8yxLUps/nH+T4A7scVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1388
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.18, xch-rcd-008.cisco.com
X-Outbound-Node: alln-core-7.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGkgUGhpbCwNCg0KSSBjYW4gYWxzbyBtaW5pbWl6ZSBhbnkgaW1wYWN0IGJ5IGluc2VydGluZyBh
IG5ldyBydWxlIGluIGZyb250IG9mIHRoZSBvbGQgb25lLCBhbmQgdGhlbiBkZWxldGUgdGhlIG9s
ZCBvbmUuIFNvIGluIHRoaXMgY2FzZSB0aGVyZSBzaG91bGQgbm8gYW55IGltcGFjdC4gSGVyZSBp
cyBpcHRhYmxlcyBydWxlcyBJIHRyeSB0byBtaW1pYzoNCg0KLy8gLUEgS1VCRS1TVkMtNTdYVk9D
Rk5UTFRSM1EyNyAtbSBzdGF0aXN0aWMgLS1tb2RlIHJhbmRvbSAtLXByb2JhYmlsaXR5IDAuNTAw
MDAwMDAwMDAgLWogS1VCRS1TRVAtRlMzRlVVTEdaUFZENFZZQg0KLy8gLUEgS1VCRS1TVkMtNTdY
Vk9DRk5UTFRSM1EyNyAtaiBLVUJFLVNFUC1NTUZaUk9RU0xRM0RLT1FBDQovLyAhDQovLyAhIEVu
ZHBvaW50IDEgZm9yIEtVQkUtU1ZDLTU3WFZPQ0ZOVExUUjNRMjcNCi8vICENCi8vIC1BIEtVQkUt
U0VQLUZTM0ZVVUxHWlBWRDRWWUIgLXMgNTcuMTEyLjAuMjQ3LzMyIC1qIEtVQkUtTUFSSy1NQVNR
DQovLyAtQSBLVUJFLVNFUC1GUzNGVVVMR1pQVkQ0VllCIC1wIHRjcCAtbSB0Y3AgLWogRE5BVCAt
LXRvLWRlc3RpbmF0aW9uIDU3LjExMi4wLjI0Nzo4MDgwDQovLyAhDQovLyAhIEVuZHBvaW50IDIg
Zm9yIEtVQkUtU1ZDLTU3WFZPQ0ZOVExUUjNRMjcNCi8vICENCi8vIC1BIEtVQkUtU0VQLU1NRlpS
T1FTTFEzREtPUUEgLXMgNTcuMTEyLjAuMjQ4LzMyIC1qIEtVQkUtTUFSSy1NQVNRDQovLyAtQSBL
VUJFLVNFUC1NTUZaUk9RU0xRM0RLT1FBIC1wIHRjcCAtbSB0Y3AgLWogRE5BVCAtLXRvLWRlc3Rp
bmF0aW9uIDU3LjExMi4wLjI0ODo4MDgwDQoNCkFzIHlvdSBjYW4gc2VlIFNWQyBjaGFpbiBLVUJF
LVNWQy01N1hWT0NGTlRMVFIzUTI3IGxvYWQgYmFsYW5jZSBiZXR3ZWVuIDIgZW5kcG9pbnRzLg0K
DQpUaGFuayB5b3UNClNlcmd1ZWkNCu+7vw0KDQpPbiAyMDE5LTEyLTA0LCAxMDoxOSBBTSwgIm4w
LTFAb3JieXRlLm53bC5jYyBvbiBiZWhhbGYgb2YgUGhpbCBTdXR0ZXIiIDxuMC0xQG9yYnl0ZS5u
d2wuY2Mgb24gYmVoYWxmIG9mIHBoaWxAbndsLmNjPiB3cm90ZToNCg0KICAgIEhpLA0KICAgIA0K
ICAgIE9uIFdlZCwgRGVjIDA0LCAyMDE5IGF0IDAxOjQ3OjQ3UE0gKzAwMDAsIFNlcmd1ZWkgQmV6
dmVya2hpIChzYmV6dmVyaykgd3JvdGU6DQogICAgPiBUaGFuayB5b3UgZm9yIHlvdXIgcmVwbHku
IEl0IGlzIHZlcnkgdW5mb3J0dW5hdGUgaW5kZWVkLiBIZXJlIGlzIHRoZSBzY2VuYXJpbyB3aGVy
ZSBJIHRob3VnaHQgdG8gdXNlIGEgbm9uLWFub255bW91cyB2bWFwLg0KICAgID4gDQogICAgPiBF
YWNoIGs4cyBzZXJ2aWNlIGNhbiBoYXZlIDAsIDEgb3IgbW9yZSBhc3NvY2lhdGVkIGVuZHBvaW50
cywgYmFja2VuZHMgKHBvZHMgcHJvdmlkaW5nIHRoaXMgc2VydmljZSkuIDAgZW5kcG9pbnQgYWxy
ZWFkeSB0YWtlbiBjYXJlIG9mIGluIGZpbHRlciBwcmVyb3V0aW5nIGhvb2suICBXaGVuIHRoZXJl
IGFyZSAxIG9yIG1vcmUsIHByb3h5IG5lZWRzIHRvIGxvYWQgYmFsYW5jZSBpbmNvbWluZyBjb25u
ZWN0aW9ucyBiZXR3ZWVuIGVuZHBvaW50cy5JIHRob3VnaHQgdG8gY3JlYXRlIHZtYXAgcGVyIHNl
cnZpY2Ugd2l0aCAxIHJ1bGUgcGVyIHNlcnZpY2UgLiBXaGVuIGFuIGVuZHBvaW50IGdldHMgdXBk
YXRlZCAoYWRkL2RlbGV0ZWQpIHdoaWNoIGNvdWxkIGhhcHBlbiBhbnl0aW1lIHRoZW4gdGhlIG9u
bHkgdm1hcCBnZXQgY29ycmVzcG9uZGluZyB1cGRhdGUgYW5kIG15IGhvcGUgd2FzIHRoYXQgYXV0
b21hZ2ljYWxseSBsb2FkIGJhbGFuY2luZyB3aWxsIGJlIGFkanVzdGVkIHRvIHVzZSB1cGRhdGVk
IGVuZHBvaW50cyBsaXN0Lg0KICAgID4gDQogICAgPiBXaXRoIHdoYXQgeW91IGV4cGxhaW5lZCwg
SSBhbSBub3Qgc3VyZSBpZiBkeW5hbWljIGxvYWQgYmFsYW5jaW5nIGlzIHBvc3NpYmxlIGF0IGFs
bC4gSWYgbnVtZ2VuIHdvcmsgb25seSB3aXRoIHN0YXRpYyBhbm9ueW1vdXMgdm1hcCBhbmQgZml4
ZWQgbW9kdWx1cyAsIHRoZSBvbmx5IHdheSB0byBhZGRyZXNzIHRoaXMgZHluYW1pYyBuYXR1cmUg
b2YgZW5kcG9pbnRzIGlzIHRvIHJlY3JlYXRlIHNlcnZpY2UgcnVsZSBldmVyeXRpbWUgd2hlbiBu
dW1iZXIgb2YgZW5kcG9pbnRzIGNoYW5nZXMgKHJlY2FsY3VsYXRlIG1vZHVsdXMgYW5kIGVudHJp
ZXMgaW4gdm1hcCkuIEkgc3VzcGVjdCBpdCBpcyB3YXkgbGVzcyBlZmZpY2llbnQuDQogICAgDQog
ICAgV2VsbCwgaWYgeW91IGhhdmUgYSBtb2R1bHVzIG9mLCBzYXksIDUgYW5kIHlvdXIgdm1hcCBj
b250YWlucyBvbmx5DQogICAgZW50cmllcyAwIHRvIDMgeW91ciBzZXR1cCBpcyBicm9rZW4gYW55
d2F5LiBTbyBJIGd1ZXNzIHlvdSB3aWxsIG5lZWQgdG8NCiAgICBhZGp1c3QgbW9kdWx1cyBhbG9u
ZyB3aXRoIGVudHJpZXMgaW4gdm1hcCBhdCBhbGwgdGltZXMuDQogICAgDQogICAgV2hhdCBpcyB0
aGUgaXB0YWJsZXMtZXF1aXZhbGVudCB5b3Ugd2FudCB0byByZXBsYWNlPyBNYXliZSB0aGF0IHNl
cnZlcw0KICAgIGFzIGluc3BpcmF0aW9uIGZvciBob3cgdG8gc29sdmUgaXQgaW4gbmZ0YWJsZXMu
DQogICAgDQogICAgPiBXaGF0IHdpbGwgaGFwcGVuIHRvIGRhdGFwbGFuZSBhbmQgcGFja2V0cyBp
biB0cmFuc2l0IHdoZW4gdGhlIHJ1bGUgd2lsbCBiZSBkZWxldGVkIGFuZCB0aGVuIHJlY3JlYXRl
ZD8gSSBzdXNwZWN0IGl0IG1pZ2h0IHJlc3VsdCBpbiBkcm9wcGVkIHBhY2tldHMsIGNvdWxkIHlv
dSBwbGVhc2UgY29tbWVudCBvbiB0aGUgcG9zc2libGUgaW1wYWN0Pw0KICAgIA0KICAgIFdlbGws
IHlvdSBjb3VsZCByZXBsYWNlIHRoZSBydWxlIGluIGEgc2luZ2xlIHRyYW5zYWN0aW9uLCB0aGF0
IHdvdWxkDQogICAgZWxpbWluYXRlIHRoZSB0aW1lc3BhbiB0aGUgcnVsZSBkb2Vzbid0IGV4aXN0
LiBBRkFJQ1QsIHRoaXMgaXMgUkNVLWJhc2VkDQogICAgc28gcGFja2V0cyB3aWxsIGVpdGhlciBo
aXQgdGhlIG9sZCBvciB0aGUgbmV3IHJ1bGUgdGhlbi4NCiAgICANCiAgICBDaGVlcnMsIFBoaWwN
CiAgICANCg0K
