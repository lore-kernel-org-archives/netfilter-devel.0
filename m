Return-Path: <SRS0=i/iJ=2H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 945C5C43603
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 14:06:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AFC52072D
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 14:06:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="Nvd8ZRQr";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="DJBHzQY3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbfLQOGF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Dec 2019 09:06:05 -0500
Received: from alln-iport-5.cisco.com ([173.37.142.92]:61110 "EHLO
        alln-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbfLQOGE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 09:06:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=3338; q=dns/txt; s=iport;
  t=1576591563; x=1577801163;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=a2PBN7Q52KF6Cw3znyJSsssW2/Ad6l6otkyVceKyCY4=;
  b=Nvd8ZRQrVMMBQim8C692gUCjCpyIj3oL1L1OKKmWoqo1+oPzofaBEkLl
   jN+FTw7ZTViNxbpW0EAP/DkdNmBY01/oixGzpPKYan6J2b7IdEgf/sVH9
   8teFW4Dn5fkZTGn1wvw29zAzqJyZg2FvK/orCChRJNZGx/0andWmgKXuA
   M=;
IronPort-PHdr: =?us-ascii?q?9a23=3A/56QRhZxpoFs1GKH1wq2VaD/LSx94ef9IxIV55?=
 =?us-ascii?q?w7irlHbqWk+dH4MVfC4el20gabRp3VvvRDjeee87vtX2AN+96giDgDa9QNMn?=
 =?us-ascii?q?1NksAKh0olCc+BB1f8KavxZSEoAslYV3du/mqwNg5eH8OtL1A=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0CgBQAi4Phd/4oNJK1lHAEBAQEBBwE?=
 =?us-ascii?q?BEQEEBAEBgX6BS1AFbFggBAsqCoN6g0YDiw+COiWYBoJSA1QJAQEBDAEBJQg?=
 =?us-ascii?q?CAQGEQAIXggEkOBMCAw0BAQQBAQECAQUEbYU3DIVeAQEBAQIBEhERDAEBIxQ?=
 =?us-ascii?q?BDwIBCBgCAiYCAgIwFRACBA4FGweDAAGCRgMOIAEOowUCgTiIYXWBMoJ+AQE?=
 =?us-ascii?q?FgTUBE0GDFRiCFwMGgQ4ojBgagUE/gREnDBSCTD6CZAICGoFHF4J5MoIsjSG?=
 =?us-ascii?q?DFIV6mFoKgjSHL45hG4JDmAaQE4cKkX0CBAIEBQIOAQEFgWkiN4EhcBVlAYJ?=
 =?us-ascii?q?BUBEUjRKDc4pTdIEoj0gBgQ8BAQ?=
X-IronPort-AV: E=Sophos;i="5.69,325,1571702400"; 
   d="scan'208";a="391903294"
Received: from alln-core-5.cisco.com ([173.36.13.138])
  by alln-iport-5.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 17 Dec 2019 14:06:02 +0000
Received: from XCH-RCD-008.cisco.com (xch-rcd-008.cisco.com [173.37.102.18])
        by alln-core-5.cisco.com (8.15.2/8.15.2) with ESMTPS id xBHE61uZ020523
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 17 Dec 2019 14:06:02 GMT
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by XCH-RCD-008.cisco.com
 (173.37.102.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Dec
 2019 08:06:00 -0600
Received: from xhs-aln-001.cisco.com (173.37.135.118) by xhs-rtp-002.cisco.com
 (64.101.210.229) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Dec
 2019 09:05:59 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-001.cisco.com (173.37.135.118) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 17 Dec 2019 08:05:59 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m/VA3hpV3tEoEts6FXVObpCGLgrb2YnWTH0amGqDhzc8Ob60t9kUFQJvNdJx3oRhL7dD6sE2U47wxyrHZDqnzRm+yNlVLL3IWp7qNUiEg1tsNHy84oS7XAyu9oL9POdYE5iSz3FAw5e4JlIwE/2AyI0mLM0ZCQJ1W/C7teMKNxZpYln3Gp9e00qpEaBwxon5W+RTk0fq3dNZm8EOd+hPrOc4112yacH2w72dJ9b4cFOAXJkCFRH2yNFRuWohUCEXptODg1gs0Pn4xpnNBWjYl1hKy5FRetfIsZU2j8IWPKCQsOzUr9quYr1OSR7edouqcS2eRc+d5GRSaV//6vmCPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a2PBN7Q52KF6Cw3znyJSsssW2/Ad6l6otkyVceKyCY4=;
 b=l6+hbd3rpX9dFpe70PTh0a7UE5g1di/AcLnmmZ3WbQ0AVOgaimbIJEm5jE+1nXHW2ED8lCiC8xHcGq6I+udgRxT5jqzI4+8yOh2KdBCdV1T2xyaSYUW6Ss+J6rD1biTYBfdO/TruIQfrx+N0b4kcIx2e6jyt/XlJRRtOR6Um2URgF9ey7wfZaSw7hMhh4WFgYX68hSovPoAqbNE8sMbrO0HA5QgXH4Bs2Gv/g8SIVFOfsFx1L/x9ja10tIM/FhhvrFschqVpdF5EBuZ+c5oakyc0y44qchCF9Nfj6Fu1ShZTRZwDwEg/JWhx6iF5e1VZVv4K/xA1oYRGgaW7hG3Aew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a2PBN7Q52KF6Cw3znyJSsssW2/Ad6l6otkyVceKyCY4=;
 b=DJBHzQY3tc4KmnqasQ9uMaNzViOPyMhAC6RJzUCxEt64fVIhkNK8SshZmum/a2/qwTo5zpmL73GNjh8e9e38RkcvlJBglZ2yG9ZIm7l0+w8a1yUXrkxwlUkMpa7tvVJI0nu7dgvEnj839/EL5dwDR3LRSIuKGi7EtEOwwOYzaQI=
Received: from DM5PR11MB1484.namprd11.prod.outlook.com (10.172.36.14) by
 DM5PR11MB1609.namprd11.prod.outlook.com (10.172.36.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Tue, 17 Dec 2019 14:05:59 +0000
Received: from DM5PR11MB1484.namprd11.prod.outlook.com
 ([fe80::e1fe:e33a:f856:7c26]) by DM5PR11MB1484.namprd11.prod.outlook.com
 ([fe80::e1fe:e33a:f856:7c26%10]) with mapi id 15.20.2538.019; Tue, 17 Dec
 2019 14:05:58 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Phil Sutter <phil@nwl.cc>
CC:     Arturo Borrero Gonzalez <arturo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Numen with reference to vmap
Thread-Topic: Numen with reference to vmap
Thread-Index: AQHVqj1Ubs5ZA1L3AEmU3M7cfc9ezqepw9GA///mtACAAGztAP//svyAgABX04CAABp3AIAAVCiAgBKu9ACAARbtgP//xyeA
Date:   Tue, 17 Dec 2019 14:05:58 +0000
Message-ID: <C5103001-881F-46A8-8738-EC8F8117FAE6@cisco.com>
References: <EC8889A1-27E2-4DC9-B752-514689982085@cisco.com>
 <20191204101819.GN8016@orbyte.nwl.cc>
 <AFC93A41-C4DD-4336-9A62-6B9C6817D198@cisco.com>
 <20191204151738.GR14469@orbyte.nwl.cc>
 <5337E60B-E81D-46ED-912F-196E23C76701@cisco.com>
 <20191204155619.GU14469@orbyte.nwl.cc>
 <624cc1ac-126e-8ad3-3faa-f7869f7d2d5b@netfilter.org>
 <20191204223215.GX14469@orbyte.nwl.cc>
 <98A8233C-1A83-44A1-A122-6F80212D618F@cisco.com>
 <20191217122925.GD8553@orbyte.nwl.cc>
In-Reply-To: <20191217122925.GD8553@orbyte.nwl.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.20.0.191208
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ecfc0cf-ba61-4258-6ca9-08d782fa3dec
x-ms-traffictypediagnostic: DM5PR11MB1609:
x-microsoft-antispam-prvs: <DM5PR11MB160924F5B26632B9DED74BC6C4500@DM5PR11MB1609.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(39860400002)(346002)(136003)(376002)(189003)(199004)(64756008)(76116006)(66946007)(66556008)(5660300002)(66446008)(66476007)(36756003)(71200400001)(966005)(26005)(2616005)(33656002)(86362001)(186003)(316002)(6512007)(8936002)(81156014)(81166006)(2906002)(478600001)(4326008)(8676002)(6506007)(54906003)(6916009)(6486002)(4001150100001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB1609;H:DM5PR11MB1484.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r+I5khAgDv/Fro9GFyM9Na+wV2V62SoPuOyb8hQ7zmj9ii/vldStrHwY3NmxmrW746AtrU9GBW4hStMkwJUwR75jIRFPhvn9gzfF5QLl5fn6+JqVMPYVdudOAYGSD0j1s1Yq1EhEBmkdRi3MmGBxZHAqvzOxsbggowJ4yNnEVpEjqZHmXWt0LaPYTwc+pFYA43X2GA6WpxVJUbtf0e3K/0qDlEXnwhxoutj4Jvu5W7x0qvcpTIcxconi5upuATUfoHfdu4g1uhhX99fn6nhu9hQDuUcL/KZqgA6bM8jZRhQdgkqJrWE/V00Fv3y4ZtsBI0lFBCic+bNHo3rMR5oqpNN3tNgcBUUEtHt1RXAvQiL0ZfNjXgYJywSnhMYFYQ18+sXcavfE/uRVHZuKRcZ8O/B0DBBvq8R4a1sunnKlLgIx0FmDBcOwfNFi01ew5VGjH6WZfLT8bmePF0X26t3xU4uD4zM8amJpZFp8Tzs+aJg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <171547C0F3299740ACCE820923D5651F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ecfc0cf-ba61-4258-6ca9-08d782fa3dec
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 14:05:58.6694
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AOgYVFXM1zybEhbrWQq2qBVEUyrsj7ANnZMWhaoRVJ7eLAi0H+sgjTg1yzhUITuoMKbmTrjWppz1EZd3VekDCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1609
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.18, xch-rcd-008.cisco.com
X-Outbound-Node: alln-core-5.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGkgUGhpbCwNCg0KVGhhbmsgeW91IHZlcnkgbXVjaCBmb3IgeW91ciByZXBseS4gQ2FuIEkgcGFz
dGUgeW91ciByZXBseSBpbnRvIHRoZSBkb2Mgd2l0aCByZWZlcmVuY2UgdG8geW91ciBuYW1lPyBJ
ZiB5b3UgZG8gbm90IHdpc2guIEkgd2lsbCByZXBocmFzZSBpdCBhbmQgcG9zdCBpdCB0aGVyZS4N
Cg0KSSBoYXZlIG9uZSBxdWVzdGlvbiwgDQoNCmNoYWluIEtVQkUtU1ZDLTU3WFZPQ0ZOVExUUjNR
Mjcgew0KCW51bWdlbiByYW5kb20gbW9kIDIgdm1hcCB7IDAgOiBqdW1wIEtVQkUtU0VQLUZTM0ZV
VUxHWlBWRDRWWUIsIA0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAxIDoganVtcCBLVUJFLVNFUC1NTUZaUk9RU0xR
M0RLT1FBIH0NCn0NCg0KSW4gdGhpcyBydWxlLCBhcyBmYXIgYXMgSSB1bmRlcnN0b29kIHlvdSBs
YXN0IHRpbWUsIHRoZXJlIGlzIG5vIHdheSBkeW5hbWljYWxseSBjaGFuZ2UgZWxlbWVudHMgb2Yg
YW5vbnltb3VzIHZtYXAuIFNvIGlmIHRoZSBzZXJ2aWNlIGhhcyBsYXJnZSBudW1iZXIgb2YgZHlu
YW1pYyAoc2hvcnQgbGl2ZWQpIGVuZHBvaW50cywgdGhpcyBydWxlIHdpbGwgaGF2ZSB0byBiZSBy
ZXByb2dyYW1tZWQgZm9yIGV2ZXJ5IGNoYW5nZSBhbmQgaXQgd291bGQgYmUgZXh0cmVtZWx5IGlu
ZWZmaWNpZW50LiBJcyB0aGVyZSBhbnkgd2F5IHRvIG1ha2UgaXQgbW9yZSBkeW5hbWljIG9yIHBs
YW5zIHRvIGNoYW5nZSB0aGUgc3RhdGljIGJlaGF2aW9yPyAgVGhhdCB3b3VsZCBleHRyZW1lbHkg
aW1wb3J0YW50Lg0KDQpUaGFuayB5b3UNClNlcmd1ZWkNCg0K77u/T24gMjAxOS0xMi0xNywgNzoy
OSBBTSwgIm4wLTFAb3JieXRlLm53bC5jYyBvbiBiZWhhbGYgb2YgUGhpbCBTdXR0ZXIiIDxuMC0x
QG9yYnl0ZS5ud2wuY2Mgb24gYmVoYWxmIG9mIHBoaWxAbndsLmNjPiB3cm90ZToNCg0KICAgIEhp
IFNlcmd1ZWksDQogICAgDQogICAgT24gVHVlLCBEZWMgMTcsIDIwMTkgYXQgMTI6NTE6MDdBTSAr
MDAwMCwgU2VyZ3VlaSBCZXp2ZXJraGkgKHNiZXp2ZXJrKSB3cm90ZToNCiAgICA+IEluIHRoaXMg
Z29vZ2xlIGRvYywgc2VlIGxpbms6IGh0dHBzOi8vZG9jcy5nb29nbGUuY29tL2RvY3VtZW50L2Qv
MTI4Z2xsYnJfby00MHBEMmkwRDE0ek1OZHRDd1JZUjdZTTQ5VDRMMkV5YWMvZWRpdD91c3A9c2hh
cmluZw0KICAgIA0KICAgIEkgYXZvaWQgR29vZ2xlLURvYyBhcyBmYXIgYXMgcG9zc2libGUuIDsp
DQogICAgDQogICAgPiBUaGVyZSBpcyBhIHF1ZXN0aW9uIGFib3V0IHBvc3NpYmxlIG9wdGltaXph
dGlvbnMuIEkgd2FzIHdvbmRlcmluZyBpZiB5b3UgY291bGQgY29tbWVudC9yZXBseS4gQWxzbyBJ
IGdvdCBvbmUgbW9yZSBxdWVzdGlvbiBhYm91dCB1cGRhdGVzIG9mIGEgc2V0LiBMZXQncyBzYXkg
dGhlcmUgaXMgYSBzZXQgd2l0aCAxMGsgZW50cmllcywgaG93IGNvc3RseSB3b3VsZCBiZSB0aGUg
dXBkYXRlIG9mIHN1Y2ggc2V0Lg0KICAgIA0KICAgIFJlZ2FyZGluZyBSb2IncyBxdWVzdGlvbjog
V2l0aCBpcHRhYmxlcywgZm9yIE4gYmFsYW5jZWQgc2VydmVycyB0aGVyZQ0KICAgIGFyZSBOIHJ1
bGVzLiBXaXRoIGVxdWFsIHByb2JhYmlsaXRpZXMgYSBwYWNrYWdlIHRyYXZlcnNlcyBOLzIgcnVs
ZXMgb24NCiAgICBhdmVyYWdlICh1bmxlc3MgSSdtIG1pc3Rha2VuKS4gV2l0aCBuZnRhYmxlcywg
dGhlcmUncyBhIHNpbmdsZSBydWxlDQogICAgd2hpY2ggdHJpZ2dlcnMgdGhlIG1hcCBsb29rdXAu
IEluIGtlcm5lbCwgdGhhdCdzIGEgbG9va3VwIGluIHJoYXNodGFibGUNCiAgICBhbmQgdGhlcmVm
b3JlIHBlcmZvcm1zIHF1aXRlIHdlbGwuDQogICAgDQogICAgQW5vdGhlciBhc3BlY3QgdG8gUm9i
J3MgcXVlc3Rpb24gaXMgaml0dGVyOiBXaXRoIGlwdGFibGVzIHNvbHV0aW9uLCBhDQogICAgcGFj
a2V0IG1heSB0cmF2ZXJzZSBhbGwgTiBydWxlcyBiZWZvcmUgaXQgaXMgZGlzcGF0Y2hlZC4gVGhl
IG5mdGFibGVzDQogICAgbWFwIGxvb2t1cCB3aWxsIGhhcHBlbiBpbiBhbG1vc3QgY29uc3RhbnQg
dGltZS4NCiAgICANCiAgICBJIGNhbid0IGdpdmUgeW91IHBlcmZvcm1hbmNlIG51bWJlcnMsIGJ1
dCBpdCBzaG91bGQgYmUgZWFzeSB0byBtZWFzdXJlLg0KICAgIEdpdmVuIHRoYXQgeW91IHdvbid0
IG5lZWQgc2V0IGNvbnRlbnQgZm9yIGluc2VydCBvciBkZWxldGUgb3BlcmF0aW9ucw0KICAgIHdo
aWxlIGlwdGFibGVzIGZldGNoZXMgdGhlIHdob2xlIHRhYmxlIGZvciBlYWNoIHJ1bGUgaW5zZXJ0
IG9yIGRlbGV0ZQ0KICAgIGNvbW1hbmQsIEkgZ3Vlc3MgeW91IGNhbiBpbWFnaW5lIGhvdyB0aGUg
bnVtYmVycyB3aWxsIGxvb2sgbGlrZS4gQnV0DQogICAgZmVlbCBmcmVlIHRvIHZlcmlmeSwgaXQn
cyBmdW4hIDopDQogICAgDQogICAgQ2hlZXJzLCBQaGlsDQogICAgDQoNCg==
