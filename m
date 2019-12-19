Return-Path: <SRS0=pcvh=2J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 138E9C43603
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Dec 2019 16:00:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD29C24650
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Dec 2019 16:00:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="I2PuW5Ud";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="ij4NqaHd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbfLSQAg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Dec 2019 11:00:36 -0500
Received: from rcdn-iport-3.cisco.com ([173.37.86.74]:22695 "EHLO
        rcdn-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbfLSQAg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Dec 2019 11:00:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2858; q=dns/txt; s=iport;
  t=1576771233; x=1577980833;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6UAlfK0bxX5oez6LrMMz/6EBIgyziCmKlYX7Fc/yc8M=;
  b=I2PuW5UdVdkyBQnpHCW8ke+KRxGNwDrKvmPiUnW7E/QGDX30op3SNi4D
   1jLw3rUKAf1HWCDLgcXbwTDNne252DRvfM8GgIwlurxWbkgH/FZddDCEB
   KeDMQn9tAwkrrEltiXUOpAP6HqXEc1PhJmWseZULrL4WBT9gZaJOUEdY0
   g=;
IronPort-PHdr: =?us-ascii?q?9a23=3AwPCzTBE/E5iG7a1M8l/Gcp1GYnJ96bzpIg4Y7I?=
 =?us-ascii?q?YmgLtSc6Oluo7vJ1Hb+e4z1Q3SRYuO7fVChqKWqK3mVWEaqbe5+HEZON0pNV?=
 =?us-ascii?q?cejNkO2QkpAcqLE0r+eeXgYj4kEd5BfFRk5Hq8d0NSHZW2ag=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0B6AACcnftd/4cNJK1lHAEBAQEBBwE?=
 =?us-ascii?q?BEQEEBAEBgWkGAQELAYFMUAWBRCAECyoKg3yDRgOKdIJfmAiBLoEkA1QJAQE?=
 =?us-ascii?q?BDAEBLQIBAYRAAheCBSQ1CA4CAw0BAQQBAQECAQUEbYU3DIVfAQEBAxIREQw?=
 =?us-ascii?q?BATcBDwIBCBgCAiYCAgIwFRACBAENBSKDAIJHAy4BoXoCgTiIYXWBMoJ+AQE?=
 =?us-ascii?q?FhSEYggwJgQ4oAYwYGoFBP4E4IIJMPoRJF4J5MoIsjUaCcZ5YCoI0lhgblhG?=
 =?us-ascii?q?EQI5RmlECBAIEBQIOAQEFgVQDNIFYcBU7KgGCQVAYDY0SDBeDUIpTdIEojl4?=
 =?us-ascii?q?BgQ8BAQ?=
X-IronPort-AV: E=Sophos;i="5.69,332,1571702400"; 
   d="scan'208";a="673734161"
Received: from alln-core-2.cisco.com ([173.36.13.135])
  by rcdn-iport-3.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 19 Dec 2019 16:00:17 +0000
Received: from XCH-ALN-003.cisco.com (xch-aln-003.cisco.com [173.36.7.13])
        by alln-core-2.cisco.com (8.15.2/8.15.2) with ESMTPS id xBJG036O004199
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 19 Dec 2019 16:00:15 GMT
Received: from xhs-rtp-003.cisco.com (64.101.210.230) by XCH-ALN-003.cisco.com
 (173.36.7.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 19 Dec
 2019 10:00:07 -0600
Received: from xhs-aln-002.cisco.com (173.37.135.119) by xhs-rtp-003.cisco.com
 (64.101.210.230) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 19 Dec
 2019 11:00:07 -0500
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-002.cisco.com (173.37.135.119) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 19 Dec 2019 10:00:07 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c5aNrvZmtiit1YW8qopaYv91+iIK8V6Kmncl0vD7L7XNrXKbEAeeo18uiSdFJCYCGqwcF2icROlgKiMAg8FWMojsWhEMAj0K7My/8C3GKhYFHmcQYHe7wDRfGdhfymo/0dC9siuKyo7mvVr8wwkciC8ODZTeopj4YHN4dnpeJ6lifkAEMBER4AzGYGrcZEhofQAMYdkAsDPbDAHTxFh0TwKqlvT3BqnrD2MMxi/3VGo4j+SgwbA8NRdTziS7GpZxCl0Kz+V8cxYnmbDUuTVd5nreX+gvlIm4Fy5j4wVVBdW66tCF/YOAyOPMaLwt3JvDn63SLPaFfZB1GDwhsva5RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6UAlfK0bxX5oez6LrMMz/6EBIgyziCmKlYX7Fc/yc8M=;
 b=XlGVvCpi3RTl91FkrAPmj3NsvsoD7aoOhngV7tzPNo125JstcSo7raroXj0GpQOPetWlju65zg+wCClYco0x95Z6SobDo7vIUaFkEwg5J4dcduGX2/SuIKdjSnk0nO83R8k95g21Zwan3QfVicL3xjqALcuojhxAPpiW9YyFg+990RaaJd04B1fJXBRFxaLLrsPgJIHBPVXGK3b9eYSET+MrklwDMN+xrzdOkAOU9Unqothc8wRF5bPrEnqDGYF3+ZvmZuNlWAjCsSwC90+yr0JNY0//7gLaHVjHWDoPemuJF19jjHoC+aLwBlg97MhmaW3YgschkpOLGT1e+QALww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6UAlfK0bxX5oez6LrMMz/6EBIgyziCmKlYX7Fc/yc8M=;
 b=ij4NqaHdv85np68+x6C8MmowKRjsTU/WuTMs/Zb3r2RTUVF0Nwq7FQ3TaBBsescKl2rV83HOw+fa+NKmJPQdwln9ntUmnO/J8im/H1vBsrsHwWvsHsx2zdrqk6+IIjbWq3RtQNqq3cFHhQTKCHQ44QcP1xLtFg48p1CYVEWFS/Y=
Received: from DM5PR11MB1484.namprd11.prod.outlook.com (10.172.36.14) by
 DM5PR11MB1594.namprd11.prod.outlook.com (10.172.34.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Thu, 19 Dec 2019 16:00:06 +0000
Received: from DM5PR11MB1484.namprd11.prod.outlook.com
 ([fe80::e1fe:e33a:f856:7c26]) by DM5PR11MB1484.namprd11.prod.outlook.com
 ([fe80::e1fe:e33a:f856:7c26%10]) with mapi id 15.20.2538.022; Thu, 19 Dec
 2019 16:00:06 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>
CC:     Laura Garcia <nevola@gmail.com>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Numen with reference to vmap
Thread-Topic: Numen with reference to vmap
Thread-Index: AQHVqj1Ubs5ZA1L3AEmU3M7cfc9ezqepw9GA///mtACAAGztAP//svyAgABX04CAABp3AIAAVCiAgBKu9ACAARbtgP//xyeAAA/qeAAAKIIrgAALSEoA///THgCAAFfMAIAA+MQA///yJwCAAGDPAP//sEKA
Date:   Thu, 19 Dec 2019 16:00:05 +0000
Message-ID: <F56E73D4-3A7E-4CCE-AEA4-C867CC11A08B@cisco.com>
References: <98A8233C-1A83-44A1-A122-6F80212D618F@cisco.com>
 <20191217122925.GD8553@orbyte.nwl.cc>
 <C5103001-881F-46A8-8738-EC8F8117FAE6@cisco.com>
 <20191217164140.GE8553@orbyte.nwl.cc>
 <6F72FC38-4238-4CCC-BAEB-A7F4B07817D7@cisco.com>
 <20191218172436.GA24932@orbyte.nwl.cc>
 <36EA0652-C146-4ED4-A004-2D729AB69BA7@cisco.com>
 <CAF90-Whnsiw=kEGyYroERYwo+_E2vWEv_3RtT89oSbp-9xoc1A@mail.gmail.com>
 <20191219104834.GD24932@orbyte.nwl.cc>
 <F1A3EFFB-7C17-4AC1-B543-C4789F2418A9@cisco.com>
 <20191219154530.GB30413@orbyte.nwl.cc>
In-Reply-To: <20191219154530.GB30413@orbyte.nwl.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.20.0.191208
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f76dcd4a-aff8-425f-e371-08d7849c8411
x-ms-traffictypediagnostic: DM5PR11MB1594:
x-microsoft-antispam-prvs: <DM5PR11MB15946EE30A6FF40043E82EFFC4520@DM5PR11MB1594.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0256C18696
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(346002)(136003)(396003)(366004)(189003)(199004)(36756003)(5660300002)(71200400001)(8676002)(316002)(8936002)(6506007)(81166006)(6512007)(54906003)(81156014)(2616005)(86362001)(4001150100001)(91956017)(66476007)(66556008)(64756008)(66446008)(33656002)(76116006)(110136005)(26005)(4326008)(186003)(2906002)(6486002)(66946007)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB1594;H:DM5PR11MB1484.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 702GflKRtxTZqzLtzB0FOKxe61ylvTs/oPLuaFHAMLvJkSFPSG0+nNZSKPTI8ScbYYKJLg5ggef9gHKcnkXNXP7SlbfdcCJbI5ys6X1RtW2WeS96iCwSsVrqlbHN1BfxdioPJAkRgMM1kjx0DQaxZQSMz2A6XaC+kAO7jml9pdia5ssPZXtghFPelzlMgDxD8DS6O5jRWXIKrN8sENGKSOrIbqYwIENKitdsFa0ubzUxkK5sC7ba7cIanGOGo8H2J56t9TtLv/3QYMJLDt/WG2wLbVsxYUodZPjoS/X/JKzXpqi5VAKxvYsXjgPjy952uvmjXDr8ZNm/RD88M1e2joVDTD9iwnsH0FD3F/N0fB1oXh0nCF/rp3ZUYakvzXWUYycNY7HKL7H1xTVT3Lb+IA6SaBA16uK+i8aaUKGSe99lW7cX6RcIaS1M5dwi5Su3
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <94018EAAC56A7A4A8B46CD918869F06D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f76dcd4a-aff8-425f-e371-08d7849c8411
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2019 16:00:05.9564
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vXAzJ6u7yO3Uf8xkl/mVWBxWTu5hgkJrnG9jpZ4f2O1ZYaDNW78LdFgoOyj/XEU9ru8woHcrMi0BlvFIq54Q1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1594
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.13, xch-aln-003.cisco.com
X-Outbound-Node: alln-core-2.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SEkgUGhpbCwNCg0KSSBidWlsdCAwLjkuMyBhbmQgbm93IGl0IHJlY29nbml6ZXMgInRoIiwgYnV0
IHRoZXJlIGlzIEkgc3VzcGVjdCBhIGNvc21ldGljIGlzc3VlIGluIHRoZSBvdXRwdXQgaW4gbmZ0
IGNsaS4gU2VlIGJlbG93IHRoZSBjb21tYW5kIEkgdXNlZDoNCnN1ZG8gbmZ0IC0tZGVidWcgYWxs
IGFkZCBydWxlIGlwdjR0YWJsZSBrOHMtZmlsdGVyLXNlcnZpY2VzIGlwIHByb3RvY29sIC4gaXAg
ZGFkZHIgLiB0aCBkcG9ydCB2bWFwIEBuby1lbmRwb2ludHMtc2VydmljZXMNCg0KSXQgbG9va3Mg
bGlrZSBjb3JyZWN0bHkgZ2VuZXJhdGluZyBleHByZXNzaW9uczoNCg0KaXAgaXB2NHRhYmxlIGs4
cy1maWx0ZXItc2VydmljZXMgDQogIFsgcGF5bG9hZCBsb2FkIDFiIEAgbmV0d29yayBoZWFkZXIg
KyA5ID0+IHJlZyAxIF0NCiAgWyBwYXlsb2FkIGxvYWQgNGIgQCBuZXR3b3JrIGhlYWRlciArIDE2
ID0+IHJlZyA5IF0NCiAgWyBwYXlsb2FkIGxvYWQgMmIgQCB0cmFuc3BvcnQgaGVhZGVyICsgMiA9
PiByZWcgMTAgXQ0KICBbIGxvb2t1cCByZWcgMSBzZXQgbm8tZW5kcG9pbnRzLXNlcnZpY2VzIGRy
ZWcgMCBdDQoNCkJ1dCB3aGVuIEkgcnVuICJzdWRvIG5mdCBsaXN0IHRhYmxlcyBpcHY0dGFibGUi
IHRoZSBydWxlIGlzIG1pc3NpbmcgdGhpcmQgcGFyYW1ldGVyLg0KDQp0YWJsZSBpcCBpcHY0dGFi
bGUgew0KCW1hcCBuby1lbmRwb2ludHMtc2VydmljZXMgew0KCQl0eXBlIGluZXRfcHJvdG8gLiBp
cHY0X2FkZHIgLiBpbmV0X3NlcnZpY2UgOiB2ZXJkaWN0DQoJfQ0KDQoJY2hhaW4gazhzLWZpbHRl
ci1zZXJ2aWNlcyB7DQoJCWlwIHByb3RvY29sIC4gaXAgZGFkZHIgdm1hcCBAbm8tZW5kcG9pbnRz
LXNlcnZpY2VzICAgICAgICAgICAgPCAtLS0tLS0tLS0tLS0tLS0tLS0tIE1pc3NpbmcgIiB0aCBk
cG9ydCINCgl9DQp9DQoNCkl0IHNlZW1zIGp1c3QgYSBjb3NtZXRpYyB0aGluZywgYnV0IGV2ZW50
dWFsbHkgd291bGQgYmUgbmljZSB0byBoYXZlIGl0IGZpeGVkLCBpZiBpdCBoYXMgbm90IGJlZW4g
YWxyZWFkeSBpbiB0aGUgbWFzdGVyIGJyYW5jaC4gSSBhbSB1c2luZyB2MC45LjMgYnJhbmNoLg0K
DQpUaGFuayB5b3UNClNlcmd1ZWkNCu+7v09uIDIwMTktMTItMTksIDEwOjQ2IEFNLCAibjAtMUBv
cmJ5dGUubndsLmNjIG9uIGJlaGFsZiBvZiBQaGlsIFN1dHRlciIgPG4wLTFAb3JieXRlLm53bC5j
YyBvbiBiZWhhbGYgb2YgcGhpbEBud2wuY2M+IHdyb3RlOg0KDQogICAgSGksDQogICAgDQogICAg
T24gVGh1LCBEZWMgMTksIDIwMTkgYXQgMDI6NTk6MDFQTSArMDAwMCwgU2VyZ3VlaSBCZXp2ZXJr
aGkgKHNiZXp2ZXJrKSB3cm90ZToNCiAgICA+IE5vdCBzdXJlIHdoeSwgYnV0IGV2ZW4gd2l0aCAw
LjkuMiAidGgiIGV4cHJlc3Npb24gaXMgbm90IHJlY29nbml6ZWQuDQogICAgPiANCiAgICA+IGVy
cm9yOiBzeW50YXggZXJyb3IsIHVuZXhwZWN0ZWQgdGgNCiAgICA+IGFkZCBydWxlIGlwdjR0YWJs
ZSBrOHMtZmlsdGVyLXNlcnZpY2VzIGlwIHByb3RvY29sIC4gaXAgZGFkZHIgLiB0aCBkcG9ydCB2
bWFwIEBuby1lbmRwb2ludHMtc2VydmljZXMNCiAgICA+ICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBeXg0KICAgID4gc2JlenZlcmtAZGV2LXVidW50dS0x
Om1pbWljLWZpbHRlciQgc3VkbyBuZnQgLXZlcnNpb24NCiAgICA+IG5mdGFibGVzIHYwLjkuMiAo
U2NyYW0pDQogICAgPiBzYmV6dmVya0BkZXYtdWJ1bnR1LTE6bWltaWMtZmlsdGVyJA0KICAgID4g
DQogICAgPiBJdCBzZWVtcyAwLjkuMyBpcyBvdXQgYnV0IHN0aWxsIG5vIERlYmlhbiBwYWNrYWdl
LiBJcyBpdCBwb3NzaWJsZSBpdCBkaWQgbm90IG1ha2UgaXQgaW50byAwLjkuMj8NCiAgICANCiAg
ICBOb3Qgc3VyZSB3aGF0J3MgbWlzc2luZyBvbiB5b3VyIGVuZC4gSSBjaGVja2VkIDAuOS4yIHRh
cmJhbGwsIGF0IGxlYXN0DQogICAgcGFyc2VyIHNob3VsZCB1bmRlcnN0YW5kIHRoZSBzeW50YXgu
DQogICAgDQogICAgQ2hlZXJzLCBQaGlsDQogICAgDQoNCg==
