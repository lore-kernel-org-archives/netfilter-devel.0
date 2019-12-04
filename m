Return-Path: <SRS0=sEEs=Z2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PDS_BTC_ID,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 480EBC43603
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 13:48:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB54B20675
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 13:48:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="RPiif6eP";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="Oijxw+v/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbfLDNsL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 08:48:11 -0500
Received: from alln-iport-2.cisco.com ([173.37.142.89]:14509 "EHLO
        alln-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727792AbfLDNsL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 08:48:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=4804; q=dns/txt; s=iport;
  t=1575467290; x=1576676890;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bcuwVHaYR54qXCGwgT2GwvlBy7IAmSoASfjzQVJeG2s=;
  b=RPiif6ePKRIZDE2qiq469xV1U4iiF59TWUyc6WJNmaAG1ZRrOowZwKze
   M19+NlBhW3X6G3NklAggd89/s0kPJ3vaipEda37sR4Y9ASiJ9uVgLHRJz
   sKcSDbm7jgPvLkdoIO/rYpqKuSwQMGR8X+7lbhdMqvd1lEyNgZa3a5vq7
   s=;
IronPort-PHdr: =?us-ascii?q?9a23=3Ai9UGpBAMRn6XgH8szWyqUyQJPHJ1sqjoPgMT9p?=
 =?us-ascii?q?ssgq5PdaLm5Zn5IUjD/qs03kTRU9Dd7PRJw6rNvqbsVHZIwK7JsWtKMfkuHw?=
 =?us-ascii?q?QAld1QmgUhBMCfDkiuN/TnfTI3BsdqX15+9Hb9Ok9QS47z?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AWBwDjuOdd/5xdJa1lHAEBAQEBBwE?=
 =?us-ascii?q?BEQEEBAEBgX6BS1AFgUQgBAsqCoQhg0YDiniCOiWYBIJSA1QJAQEBDAEBLQI?=
 =?us-ascii?q?BAYRAAheBeSQ4EwIDDQEBBAEBAQIBBQRthTcMhVIBAQEBAgEOBBERDAEBIxQ?=
 =?us-ascii?q?BDwIBCBgCAiYCAgIwFRACBA4FIluCJYJHAw4gAaVrAoE4iGB1gTKCfgEBBYJ?=
 =?us-ascii?q?KgkEYghcJgQ4ohRyGexqBQT+BOAwUgkw+hEkXgnkygiyQIZ4tCoIulVobgkG?=
 =?us-ascii?q?Hbo93kA+YXgIEAgQFAg4BAQWBaSKBWHAVOyoBgkFQERSMZoNzilN0gSiNf4E?=
 =?us-ascii?q?xATBfAQE?=
X-IronPort-AV: E=Sophos;i="5.69,277,1571702400"; 
   d="scan'208";a="386900024"
Received: from rcdn-core-5.cisco.com ([173.37.93.156])
  by alln-iport-2.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 04 Dec 2019 13:47:50 +0000
Received: from XCH-ALN-005.cisco.com (xch-aln-005.cisco.com [173.36.7.15])
        by rcdn-core-5.cisco.com (8.15.2/8.15.2) with ESMTPS id xB4DloOe016729
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 4 Dec 2019 13:47:50 GMT
Received: from xhs-rcd-001.cisco.com (173.37.227.246) by XCH-ALN-005.cisco.com
 (173.36.7.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 4 Dec
 2019 07:47:49 -0600
Received: from xhs-aln-001.cisco.com (173.37.135.118) by xhs-rcd-001.cisco.com
 (173.37.227.246) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 4 Dec
 2019 07:47:48 -0600
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-001.cisco.com (173.37.135.118) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 4 Dec 2019 07:47:48 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V+BYrpf5enrX+Qpdj9O8LAIEt9CcuBTaklblx3GkZGl+F1VvFCqCD7BanlK4dl8QJi0NW5gnLpbUoMiIZ3e+bC6MW1Rph3+RnkrfWSlmFzKQj8Q9Y+gdSZskGnUVSTgT4wAqc4Rc6qYItpLHXdwsvD0fH5gATvbTcW0u5aS9z3mqNklkZoD/b06mvnFnVKv4W9ElZ0ceREuHSN9fFcJ2yv6JTecMRs60XRVuUoFh1pzh2OnxDJLvKJPXxPv3+8gRxmEoaPsywiG3jx3XMCAlboqXiIHB38G1KkzEKLe/1arc40mjH9PaE+I6Yq03vA4DdQFmmwtznYz9hpg0Wv8qrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bcuwVHaYR54qXCGwgT2GwvlBy7IAmSoASfjzQVJeG2s=;
 b=BA8erEpPaozSACGY4jHGZtYceHMChK4ewNBcjfPQfqs8bgIyhL96m3fQp6sBjKS9nyAvZq5lQugGWPSO9RU/u7Bij/FdbLCLeikuA3NU8ipoXRI0xJUNz3z6JBMc/G6Ym2uNMWabREqE+Qe5NCrW4yRPBTHbrQKu7+vfCsIuVzaUMcYyX44H25D1KlPNuPFVCZsAoPGdWm8+dO0V6gQgeM4+hYhHcvvlu+gomXgWgnOKvJoolFPdBtbwqOafT3jdUmkCF9GvT7ZPTYVgvHCxNgPTBXccMBCter5jmUXSd3H0Cu2/vdAN9szKkIFDP0OWIcEVN1+0TvOmAAFa/Ywn4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bcuwVHaYR54qXCGwgT2GwvlBy7IAmSoASfjzQVJeG2s=;
 b=Oijxw+v/gihUf5NTzyRD/7T5pDsHaFPXTle4+tcNBy1SN82/1C1xbW3i28VN0sxFHAB1pby+JJM0PiUL7XhYoLkLKATm3Sag6fkCnOn8ZoVmJh8pUgMGY2Kui22o4g01uoU96HdM6H1KcHTdKD85ekb5dGDdKKvpZ+IEfBD+51I=
Received: from DM5PR11MB1484.namprd11.prod.outlook.com (10.172.36.14) by
 DM5PR11MB1995.namprd11.prod.outlook.com (10.168.106.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Wed, 4 Dec 2019 13:47:47 +0000
Received: from DM5PR11MB1484.namprd11.prod.outlook.com
 ([fe80::b8d0:b659:6b84:fa7a]) by DM5PR11MB1484.namprd11.prod.outlook.com
 ([fe80::b8d0:b659:6b84:fa7a%10]) with mapi id 15.20.2516.003; Wed, 4 Dec 2019
 13:47:47 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Phil Sutter <phil@nwl.cc>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Numen with reference to vmap
Thread-Topic: Numen with reference to vmap
Thread-Index: AQHVqj1Ubs5ZA1L3AEmU3M7cfc9ezqepw9GA///mtAA=
Date:   Wed, 4 Dec 2019 13:47:47 +0000
Message-ID: <AFC93A41-C4DD-4336-9A62-6B9C6817D198@cisco.com>
References: <EC8889A1-27E2-4DC9-B752-514689982085@cisco.com>
 <20191204101819.GN8016@orbyte.nwl.cc>
In-Reply-To: <20191204101819.GN8016@orbyte.nwl.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.86]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 81992318-637f-4f85-7c22-08d778c08bf8
x-ms-traffictypediagnostic: DM5PR11MB1995:
x-microsoft-antispam-prvs: <DM5PR11MB199503716BCEE75574A4E400C45D0@DM5PR11MB1995.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0241D5F98C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(396003)(366004)(136003)(199004)(52314003)(189003)(33656002)(316002)(3846002)(229853002)(36756003)(6512007)(305945005)(6486002)(71200400001)(6436002)(2906002)(76176011)(14444005)(7736002)(71190400001)(58126008)(6116002)(478600001)(14454004)(99286004)(6506007)(25786009)(102836004)(26005)(186003)(6916009)(81156014)(81166006)(2616005)(11346002)(8936002)(8676002)(5660300002)(6246003)(64756008)(4326008)(66446008)(66946007)(91956017)(66476007)(66556008)(76116006)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB1995;H:DM5PR11MB1484.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +oCM6mm6iGWcEwVDcNcTisqib3UPh245UbdgVQ9Ha7D51QAGXCtr1M3pm7LuSqiYaYCvdFEJK+NHFjecAZHdRJ0KNovBaoBoguLcoFPtM4aQ+Lh1GiQ6Jd8EQ4FD7D/xqY4WldZhQmxqjtFdud8kYr5DTEJR9ibI5eT8LagbsD7gnYYfP4Zur8orU6zLor5z4f2iOAXYI+KeCnvAd+2xoWweVXTgfQCxuReBjAy3P2jWAkITQM+H2S4xo6q9wac7l4CbIqeQARQOoMKy/rqf8biwhOuqZ3jZLZqQDPrG3kY2Np4moYWRCeholZ2zE8a7U6AH/Ei3oE3xwq9FhOI7ZRzUqOfVQg4Yu8XoRw85mb85ylcdfxa6RIbipJZA7rGoSuV+/p+zKevvDVdT3/ytg7NdL3tP2Cnx3qFK9Nvj/WiCVMPZCIF+GrSsj2HepzhwiIqsYQ7WI2C8d2cfJoi4dwDCAA9+I1yceNvKkzQ4foEbntlOuMpSwUDRc3+2vT+F
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <6C3FA80147FD164698BACD80BD269C54@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 81992318-637f-4f85-7c22-08d778c08bf8
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2019 13:47:47.2306
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IAyoQUDbEUnSez56HqKfOkD4oVKWGMBSfRU7k9o3sz7Gtf4WyiValPYu7RQRjk42+CiCXicofJQ5PUu0FEdTHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1995
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.15, xch-aln-005.cisco.com
X-Outbound-Node: rcdn-core-5.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGVsbG8gUGhpbCwNCg0KVGhhbmsgeW91IGZvciB5b3VyIHJlcGx5LiBJdCBpcyB2ZXJ5IHVuZm9y
dHVuYXRlIGluZGVlZC4gSGVyZSBpcyB0aGUgc2NlbmFyaW8gd2hlcmUgSSB0aG91Z2h0IHRvIHVz
ZSBhIG5vbi1hbm9ueW1vdXMgdm1hcC4NCg0KRWFjaCBrOHMgc2VydmljZSBjYW4gaGF2ZSAwLCAx
IG9yIG1vcmUgYXNzb2NpYXRlZCBlbmRwb2ludHMsIGJhY2tlbmRzIChwb2RzIHByb3ZpZGluZyB0
aGlzIHNlcnZpY2UpLiAwIGVuZHBvaW50IGFscmVhZHkgdGFrZW4gY2FyZSBvZiBpbiBmaWx0ZXIg
cHJlcm91dGluZyBob29rLiAgV2hlbiB0aGVyZSBhcmUgMSBvciBtb3JlLCBwcm94eSBuZWVkcyB0
byBsb2FkIGJhbGFuY2UgaW5jb21pbmcgY29ubmVjdGlvbnMgYmV0d2VlbiBlbmRwb2ludHMuSSB0
aG91Z2h0IHRvIGNyZWF0ZSB2bWFwIHBlciBzZXJ2aWNlIHdpdGggMSBydWxlIHBlciBzZXJ2aWNl
IC4gV2hlbiBhbiBlbmRwb2ludCBnZXRzIHVwZGF0ZWQgKGFkZC9kZWxldGVkKSB3aGljaCBjb3Vs
ZCBoYXBwZW4gYW55dGltZSB0aGVuIHRoZSBvbmx5IHZtYXAgZ2V0IGNvcnJlc3BvbmRpbmcgdXBk
YXRlIGFuZCBteSBob3BlIHdhcyB0aGF0IGF1dG9tYWdpY2FsbHkgbG9hZCBiYWxhbmNpbmcgd2ls
bCBiZSBhZGp1c3RlZCB0byB1c2UgdXBkYXRlZCBlbmRwb2ludHMgbGlzdC4NCg0KV2l0aCB3aGF0
IHlvdSBleHBsYWluZWQsIEkgYW0gbm90IHN1cmUgaWYgZHluYW1pYyBsb2FkIGJhbGFuY2luZyBp
cyBwb3NzaWJsZSBhdCBhbGwuIElmIG51bWdlbiB3b3JrIG9ubHkgd2l0aCBzdGF0aWMgYW5vbnlt
b3VzIHZtYXAgYW5kIGZpeGVkIG1vZHVsdXMgLCB0aGUgb25seSB3YXkgdG8gYWRkcmVzcyB0aGlz
IGR5bmFtaWMgbmF0dXJlIG9mIGVuZHBvaW50cyBpcyB0byByZWNyZWF0ZSBzZXJ2aWNlIHJ1bGUg
ZXZlcnl0aW1lIHdoZW4gbnVtYmVyIG9mIGVuZHBvaW50cyBjaGFuZ2VzIChyZWNhbGN1bGF0ZSBt
b2R1bHVzIGFuZCBlbnRyaWVzIGluIHZtYXApLiBJIHN1c3BlY3QgaXQgaXMgd2F5IGxlc3MgZWZm
aWNpZW50Lg0KV2hhdCB3aWxsIGhhcHBlbiB0byBkYXRhcGxhbmUgYW5kIHBhY2tldHMgaW4gdHJh
bnNpdCB3aGVuIHRoZSBydWxlIHdpbGwgYmUgZGVsZXRlZCBhbmQgdGhlbiByZWNyZWF0ZWQ/IEkg
c3VzcGVjdCBpdCBtaWdodCByZXN1bHQgaW4gZHJvcHBlZCBwYWNrZXRzLCBjb3VsZCB5b3UgcGxl
YXNlIGNvbW1lbnQgb24gdGhlIHBvc3NpYmxlIGltcGFjdD8NCg0KSWYgeW91IGNvdWxkIHN1Z2dl
c3QgYSBiZXR0ZXIgYXBwcm9hY2ggZm9yIHRoZSBkZXNjcmliZWQgc2NlbmFyaW8sIGFwcHJlY2lh
dGUgaWYgeW91IHNoYXJlIGl0Lg0KDQpUaGFuayB5b3UNClNlcmd1ZWkNCg0K77u/T24gMjAxOS0x
Mi0wNCwgNToxOCBBTSwgIm4wLTFAb3JieXRlLm53bC5jYyBvbiBiZWhhbGYgb2YgUGhpbCBTdXR0
ZXIiIDxuMC0xQG9yYnl0ZS5ud2wuY2Mgb24gYmVoYWxmIG9mIHBoaWxAbndsLmNjPiB3cm90ZToN
Cg0KICAgIEhpIFNlcmd1ZWksDQogICAgDQogICAgT24gV2VkLCBEZWMgMDQsIDIwMTkgYXQgMTI6
NTQ6MDVBTSArMDAwMCwgU2VyZ3VlaSBCZXp2ZXJraGkgKHNiZXp2ZXJrKSB3cm90ZToNCiAgICA+
IE5mdGFibGVzIHdpa2kgZ2l2ZXMgdGhpcyBleGFtcGxlIGZvciBudW1nZW46DQogICAgPiANCiAg
ICA+IG5mdCBhZGQgcnVsZSBuYXQgcHJlcm91dGluZyBudW1nZW4gcmFuZG9tIG1vZCAyIHZtYXAg
eyAwIDoganVtcCBteWNoYWluMSwgMSA6IGp1bXAgbXljaGFpbjIgfQ0KICAgID4gDQogICAgPiBJ
IHdvdWxkIGxpa2UgdG8gdXNlIGl0IGJ1dCB3aXRoIG1hcCByZWZlcmVuY2UsIGxpa2UgdGhpczoN
CiAgICA+IA0KICAgID4gbmZ0IGFkZCBydWxlIG5hdCBwcmVyb3V0aW5nIG51bWdlbiByYW5kb20g
bW9kIDIgdm1hcCBAc2VydmljZTEtZW5kcG9pbnRzDQogICAgPiANCiAgICA+IENvdWxkIHlvdSBw
bGVhc2UgY29uZmlybSBpZiBpdCBpcyBzdXBwb3J0ZWQ/IElmIGl0IGlzIHdoYXQgd291bGQgYmUg
dGhlIHR5cGUgb2YgdGhlIGtleSBpbiBzdWNoIG1hcD8gSSB0aG91Z2h0IGl0IHdvdWxkIGJlIGlu
dGVnZXIsIGJ1dCBjb21tYW5kIGZhaWxzLg0KICAgID4gDQogICAgPiBzdWRvIG5mdCAtLWRlYnVn
IGFsbCBhZGQgbWFwIGlwdjR0YWJsZSBrOHMtNTdYVk9DRk5UTFRSM1EyNy1lbmRwb2ludHMgICB7
IHR5cGUgIGludGVnZXIgOiB2ZXJkaWN0IFw7IH0NCiAgICA+IEVycm9yOiB1bnF1YWxpZmllZCBr
ZXkgdHlwZSBpbnRlZ2VyIHNwZWNpZmllZCBpbiBtYXAgZGVmaW5pdGlvbg0KICAgID4gYWRkIG1h
cCBpcHY0dGFibGUgazhzLTU3WFZPQ0ZOVExUUjNRMjctZW5kcG9pbnRzIHsgdHlwZSBpbnRlZ2Vy
IDogdmVyZGljdCA7IH0NCiAgICA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBeXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXg0KICAgIA0KICAgIFllcywg
dGhpcyBpcyBzYWRseSBub3QgcG9zc2libGUgcmlnaHQgbm93LiBudW1nZW4gdHlwZSBpcyAzMmJp
dCBpbnRlZ2VyLA0KICAgIGJ1dCB3ZSBkb24ndCBoYXZlIGEgdHlwZSBkZWZpbml0aW9uIG1hdGNo
aW5nIHRoYXQuIFR5cGUgJ2ludGVnZXInIGlzDQogICAgdW5xdWFsaWZpZWQgcmVnYXJkaW5nIHNp
emUsIHRoZXJlZm9yZSB1bnN1aXRhYmxlIGZvciB1c2UgaW4gbWFwL3NldA0KICAgIGRlZmluaXRp
b25zLg0KICAgIA0KICAgIFRoaXMgYWxsIHdvcmtzIHdoZW4gdXNpbmcgYW5vbnltb3VzIHNldC9t
YXAgYmVjYXVzZSBrZXkgdHlwZSBpcw0KICAgIGRlZHVjZWQgZnJvbSBtYXAgTEhTLg0KICAgIA0K
ICAgIFdlIHBsYW4gdG8gc3VwcG9ydCBhICd0eXBlb2YnIGtleXdvcmQgYXQgc29tZSBwb2ludCB0
byBhbGxvdyBmb3IgdGhlDQogICAgc2FtZSBkZWR1Y3Rpb24gZnJvbSB3aXRoaW4gbmFtZWQgbWFw
L3NldCBkZWNsYXJhdGlvbnMsIGJ1dCBpdCBuZWVkcw0KICAgIGZ1cnRoZXIgd29yayBhcyB0aGUg
dHlwZSBpbmZvIGlzIGxvc3Qgb24gcmV0dXJuIHBhdGggKHdoZW4gbGlzdGluZykgc28NCiAgICBp
dCB3b3VsZCBjcmVhdGUgYSBydWxlc2V0IHRoYXQgY2FuJ3QgYmUgZmVkIGJhY2suDQogICAgDQog
ICAgPiBUaGUgdWx0aW1hdGUgIGdvYWwgaXMgdG8gdXBkYXRlIGR5bmFtaWNhbGx5IGp1c3QgdGhl
ICBtYXAgIHdpdGggYXZhaWxhYmxlIGVuZHBvaW50cyBhbmQgbG9hZGJhbGFuY2UgYmV0d2VlbiB0
aGVtIHdpdGhvdXQgIHRvdWNoaW5nIHRoZSBydWxlLg0KICAgIA0KICAgIEkgZG9uJ3QgcXVpdGUg
dW5kZXJzdGFuZCB3aHkgeW91IG5lZWQgdG8gZHluYW1pY2FsbHkgY2hhbmdlIHRoZQ0KICAgIGxv
YWQtYmFsYW5jaW5nIHJ1bGU6IG51bWdlbiBtb2R1bHVzIGlzIGZpeGVkIGFueXdheSwgc28gdGhl
IG51bWJlciBvZg0KICAgIGVsZW1lbnRzIGluIHZtYXAgYXJlIGZpeGVkLiBNYXliZSBqdXN0IGp1
bXAgdG8gY2hhaW5zIGFuZCBkeW5hbWljYWxseQ0KICAgIHVwZGF0ZSB0aG9zZSBpbnN0ZWFkPw0K
ICAgIA0KICAgIENoZWVycywgUGhpbA0KICAgIA0KDQo=
