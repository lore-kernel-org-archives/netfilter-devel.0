Return-Path: <SRS0=U5wk=2I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 077ABC43603
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Dec 2019 17:01:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B05022176D
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Dec 2019 17:01:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="E7ikNPwc";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="P3+Pt6m8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbfLRRBi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Dec 2019 12:01:38 -0500
Received: from rcdn-iport-2.cisco.com ([173.37.86.73]:22827 "EHLO
        rcdn-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727184AbfLRRBi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Dec 2019 12:01:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=3010; q=dns/txt; s=iport;
  t=1576688497; x=1577898097;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DuB7jtNu+yJx1QzYm4Anwca1MRmMIVELQR5C+ej5+vM=;
  b=E7ikNPwcClIB/0HVbHE+VQwlqJsCCo9kpWZRCvDFQ8exwgVgjCidNOoc
   cPKKkJjU/SViN+m5OmnEQ9WGl6MJ3EHJUtguhjOiCWq1Q4VayljpK9SNv
   IH74FILYz7tjrKwgNoPy09DjCeme9fAQP9LuEYDtpAUUdopg+FIazSznT
   g=;
IronPort-PHdr: =?us-ascii?q?9a23=3A+As/1R+DehJUn/9uRHGN82YQeigqvan1NQcJ65?=
 =?us-ascii?q?0hzqhDabmn44+8ZR7E/fs4iljPUM2b8P9Ch+fM+4HYEW0bqdfk0jgZdYBUER?=
 =?us-ascii?q?oMiMEYhQslVdWPBF/lIeTpRyc7B89FElRi+iLzPA=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AUCAA7Wvpd/5hdJa1lHQEBAQkBEQU?=
 =?us-ascii?q?FAYF8gU0pJwWBRCAECyoKg3qDRgOKcoI6JZgGgUKBEANUCQEBAQwBAS0CAQG?=
 =?us-ascii?q?EQAIXggIkOBMCAw0BAQQBAQECAQUEbYU3DIVeAQEBAQIBEhERDAEBNwEPAgE?=
 =?us-ascii?q?IGAICJgICAjAVEAIEDgUbB4MAgkcDDiABomgCgTiIYXWBMoJ+AQEFhRQYghA?=
 =?us-ascii?q?JgQ4ohRyGfBqBQT+BEScMFIJMPoQVFAEBBggngnkygiyNT4JohXqYXAqCNYZ?=
 =?us-ascii?q?Lj0gbmk6pHAIEAgQFAg4BAQWBaSKBWHAVZQGCQVAYDY0SgScBCIJDilN0gSi?=
 =?us-ascii?q?LU4EiAYEPAQE?=
X-IronPort-AV: E=Sophos;i="5.69,330,1571702400"; 
   d="scan'208";a="690045900"
Received: from rcdn-core-1.cisco.com ([173.37.93.152])
  by rcdn-iport-2.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 18 Dec 2019 17:01:36 +0000
Received: from XCH-ALN-008.cisco.com (xch-aln-008.cisco.com [173.36.7.18])
        by rcdn-core-1.cisco.com (8.15.2/8.15.2) with ESMTPS id xBIH1akc023020
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 18 Dec 2019 17:01:36 GMT
Received: from xhs-aln-001.cisco.com (173.37.135.118) by XCH-ALN-008.cisco.com
 (173.36.7.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 18 Dec
 2019 11:01:35 -0600
Received: from xhs-rcd-002.cisco.com (173.37.227.247) by xhs-aln-001.cisco.com
 (173.37.135.118) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 18 Dec
 2019 11:01:35 -0600
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-002.cisco.com (173.37.227.247) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 18 Dec 2019 11:01:35 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y+mSBTKFVlflVZQJr7mU5LiDkurK1/gLpZSDyyMtmgx6s4y9XSl3UhsiFb1bSnRvHvylnks2sRpn7uigt3zoCnN7JlLTEwiXnxYtFaQrF60XNTs0mSRQAwLrAd9KbdGqEn53BVUB6L1VwRDip7L/CMbny8hZFz+YTIvVzvlIQvpCOaaWqCgPoCuevUp6wsAtUA2baQTEPogxNGvYrRG74o71lsfp3nfzmXHhUFWrV5QmEg0qa2rFttheWlCISVgcn0O485LqjB0fVEtfhfUYbvSv+i2eS7/KtNPVkDdUfK4uf/an9vgHLb1VUSf+gwENy/E5/Vod7vzSXwS6iDl0NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DuB7jtNu+yJx1QzYm4Anwca1MRmMIVELQR5C+ej5+vM=;
 b=a/PeUYBvgMCbk9pDAmymxqI1emr7k1GK/Z6hzq9hqncZPbJiEnCmoUqAkn2RJKouvJtz7YyzJI/XTOYLjVLOnJuRqW9ULjUmgf2KSvcEXH+tOiOtRDWDmweHnRr7ruSNuEYyn3rgbWd5P4e7gtmeFv3X6JfrvRi2jiyR4ek3k3uMpPNpxQgp3/AOG+92Vnygad/BueGqJZmt2Eu/1MY71D7Qe9ENZZGMqHSczUqN19Fz+TDNV/nUaG+v4y18of71SrR1GR6wPYlHeWzsWmEMPxm9lRr7JzOJ7SZM1xqwz97JRq7sYtZhwuU4alNeeoOvtumOyCBbFy5KyXEXvS4O+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DuB7jtNu+yJx1QzYm4Anwca1MRmMIVELQR5C+ej5+vM=;
 b=P3+Pt6m8hj3UWqEgXGeDqOQPOO3iRccbogCPJoVcDbU9F3DhhLzPVOAj/wdfNzY601loZ1Kz6UcdXuvM2TJbPZXgMFw+DR4Ket9XPt9/aNXY/U19ryhNCh3C3VrCpgkuCLc0YAT/FCDfpt2DgESIyqIBtxaIcNW7ZehgBq4NJ1A=
Received: from DM5PR11MB1484.namprd11.prod.outlook.com (10.172.36.14) by
 DM5PR11MB1516.namprd11.prod.outlook.com (10.172.37.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Wed, 18 Dec 2019 17:01:34 +0000
Received: from DM5PR11MB1484.namprd11.prod.outlook.com
 ([fe80::e1fe:e33a:f856:7c26]) by DM5PR11MB1484.namprd11.prod.outlook.com
 ([fe80::e1fe:e33a:f856:7c26%10]) with mapi id 15.20.2538.019; Wed, 18 Dec
 2019 17:01:34 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Phil Sutter <phil@nwl.cc>
CC:     Arturo Borrero Gonzalez <arturo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Numen with reference to vmap
Thread-Topic: Numen with reference to vmap
Thread-Index: AQHVqj1Ubs5ZA1L3AEmU3M7cfc9ezqepw9GA///mtACAAGztAP//svyAgABX04CAABp3AIAAVCiAgBKu9ACAARbtgP//xyeAAA/qeAAAKIIrgA==
Date:   Wed, 18 Dec 2019 17:01:33 +0000
Message-ID: <6F72FC38-4238-4CCC-BAEB-A7F4B07817D7@cisco.com>
References: <20191204101819.GN8016@orbyte.nwl.cc>
 <AFC93A41-C4DD-4336-9A62-6B9C6817D198@cisco.com>
 <20191204151738.GR14469@orbyte.nwl.cc>
 <5337E60B-E81D-46ED-912F-196E23C76701@cisco.com>
 <20191204155619.GU14469@orbyte.nwl.cc>
 <624cc1ac-126e-8ad3-3faa-f7869f7d2d5b@netfilter.org>
 <20191204223215.GX14469@orbyte.nwl.cc>
 <98A8233C-1A83-44A1-A122-6F80212D618F@cisco.com>
 <20191217122925.GD8553@orbyte.nwl.cc>
 <C5103001-881F-46A8-8738-EC8F8117FAE6@cisco.com>
 <20191217164140.GE8553@orbyte.nwl.cc>
In-Reply-To: <20191217164140.GE8553@orbyte.nwl.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.20.0.191208
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3e78c8e2-3f75-464c-bb6f-08d783dbefea
x-ms-traffictypediagnostic: DM5PR11MB1516:
x-microsoft-antispam-prvs: <DM5PR11MB1516680BEC524626BD22260DC4530@DM5PR11MB1516.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(346002)(136003)(396003)(39860400002)(199004)(189003)(4001150100001)(71200400001)(8936002)(8676002)(26005)(6486002)(4326008)(81156014)(6512007)(186003)(66446008)(81166006)(6916009)(54906003)(33656002)(66556008)(64756008)(36756003)(66476007)(5660300002)(2906002)(76116006)(66946007)(91956017)(478600001)(86362001)(2616005)(316002)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB1516;H:DM5PR11MB1484.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cE/A0uZgjJXHmchhB2K2Tyr1+vSKDbTXDn3dgLB5qsV8BLP32VIVFP01dkSKEc0NVu4SE3nvWnmvM9ayNn5EoUbHNzOI6H5mscuAae133POVa3s7vVqy8qIC7Wvvkyg7TWImg0UGCu92LPRrYtDBBeqlFjbMxjK5Cc8Q/x2/dOGE9qstiP0tcETYbW1DBSGVpK+2wpL4NVtC4Fjx0YnhD8BXRMbU1XKqSj9Fl1hcYXMbRMqo0AYQSLBPIBYfhuwaS5slEvKy95eSFZbGX5XRlVftm+PLPNog8q/uItjw0sJHgiQv/FFKYQDrzLrct3/Y9Yzk1hZAG+xCJ3OiYLmeX1imtA09y9tw1a2rKBUDvKdp3BrL9D7P/IsUthxLya5qkmO1XDYou6ErO+OOrUk3aut1G1VoPM7LrkTNvyL2GLRuXMDRfPtRbCVtvpY6Vo5g
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <D4722CB81B21FF4DBDD7E57F60FF95EC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e78c8e2-3f75-464c-bb6f-08d783dbefea
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 17:01:34.0689
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KAI8ZfXm8ADyLM8bc9Ar8LWzrISssNHUR+xiK97oBrhz97WIRv7afwZD00J+HsJxDpTvtWNdq1RuqtWCSYutIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1516
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.18, xch-aln-008.cisco.com
X-Outbound-Node: rcdn-core-1.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGVsbG8sDQoNCkkgY2FtZSBhY3Jvc3MgYSBzaXR1YXRpb24gd2hlbiBJIG5lZWQgdG8gbWF0Y2gg
YWdhaW5zdCBMNCBwcm90byAodGNwL3VkcCksIEwzIGRhZGRyIGFuZCBMNCBwb3J0KHBvcnQgdmFs
dWUpIHdpdGggdm1hcC4NCg0KVm1hcCBsb29rcyBsaWtlIHRoaXM6DQoNCgltYXAgbm8tZW5kcG9p
bnRzLXNlcnZpY2VzIHsNCgkJdHlwZSBpbmV0X3Byb3RvIC4gaXB2NF9hZGRyIC4gaW5ldF9zZXJ2
aWNlIDogdmVyZGljdA0KCX0NCg0KSSB3YXMgd29uZGVyaW5nIGlmIHNvbWVib2R5IGNvdWxkIGNv
bWUgdXAgd2l0aCBhIHNpbmdsZSBsaW5lIHJ1bGUgd2l0aCByZWZlcmVuY2UgdG8gdGhhdCB2bWFw
Lg0KDQpUaGFuayB5b3UNClNlcmd1ZWkNCg0K77u/T24gMjAxOS0xMi0xNywgMTE6NDEgQU0sICJu
MC0xQG9yYnl0ZS5ud2wuY2Mgb24gYmVoYWxmIG9mIFBoaWwgU3V0dGVyIiA8bjAtMUBvcmJ5dGUu
bndsLmNjIG9uIGJlaGFsZiBvZiBwaGlsQG53bC5jYz4gd3JvdGU6DQoNCiAgICBIaSBTZXJndWVp
LA0KICAgIA0KICAgIE9uIFR1ZSwgRGVjIDE3LCAyMDE5IGF0IDAyOjA1OjU4UE0gKzAwMDAsIFNl
cmd1ZWkgQmV6dmVya2hpIChzYmV6dmVyaykgd3JvdGU6DQogICAgPiBUaGFuayB5b3UgdmVyeSBt
dWNoIGZvciB5b3VyIHJlcGx5LiBDYW4gSSBwYXN0ZSB5b3VyIHJlcGx5IGludG8gdGhlIGRvYyB3
aXRoIHJlZmVyZW5jZSB0byB5b3VyIG5hbWU/IElmIHlvdSBkbyBub3Qgd2lzaC4gSSB3aWxsIHJl
cGhyYXNlIGl0IGFuZCBwb3N0IGl0IHRoZXJlLg0KICAgIA0KICAgIE5vbywgZG9uJ3QgdGVsbCBh
bnlvbmUgd2hhdCBJIHdyaXRlIGluIG1haWxzIHRvIHB1YmxpYyBsaXN0cyEgOykNCiAgICBTZXJp
b3VzbHksIEkgZG9uJ3QgY2FyZSBpZiB5b3UgcGFzdGUgaXQgdGhlcmUgb3IganVzdCBsaW5rIHRv
IG15IHJlcGx5DQogICAgaW4gYSBwdWJsaWMgYXJjaGl2ZS4NCiAgICANCiAgICA+IEkgaGF2ZSBv
bmUgcXVlc3Rpb24sIA0KICAgID4gDQogICAgPiBjaGFpbiBLVUJFLVNWQy01N1hWT0NGTlRMVFIz
UTI3IHsNCiAgICA+IAludW1nZW4gcmFuZG9tIG1vZCAyIHZtYXAgeyAwIDoganVtcCBLVUJFLVNF
UC1GUzNGVVVMR1pQVkQ0VllCLCANCiAgICA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgMSA6IGp1bXAgS1VCRS1T
RVAtTU1GWlJPUVNMUTNES09RQSB9DQogICAgPiB9DQogICAgPiANCiAgICA+IEluIHRoaXMgcnVs
ZSwgYXMgZmFyIGFzIEkgdW5kZXJzdG9vZCB5b3UgbGFzdCB0aW1lLCB0aGVyZSBpcyBubyB3YXkg
ZHluYW1pY2FsbHkgY2hhbmdlIGVsZW1lbnRzIG9mIGFub255bW91cyB2bWFwLiBTbyBpZiB0aGUg
c2VydmljZSBoYXMgbGFyZ2UgbnVtYmVyIG9mIGR5bmFtaWMgKHNob3J0IGxpdmVkKSBlbmRwb2lu
dHMsIHRoaXMgcnVsZSB3aWxsIGhhdmUgdG8gYmUgcmVwcm9ncmFtbWVkIGZvciBldmVyeSBjaGFu
Z2UgYW5kIGl0IHdvdWxkIGJlIGV4dHJlbWVseSBpbmVmZmljaWVudC4gSXMgdGhlcmUgYW55IHdh
eSB0byBtYWtlIGl0IG1vcmUgZHluYW1pYyBvciBwbGFucyB0byBjaGFuZ2UgdGhlIHN0YXRpYyBi
ZWhhdmlvcj8gIFRoYXQgd291bGQgZXh0cmVtZWx5IGltcG9ydGFudC4NCiAgICANCiAgICBDb25z
ZW5zdXMgd2FzIHRoYXQgeW91IHNob3VsZCBlaXRoZXIgY29weSB0aGUgaXB0YWJsZXMgc29sdXRp
b24gZm9yIG5vdw0KICAgIChhY2NlcHRpbmcgdGhlIGRyYXdiYWNrcyBJIGV4cGxhaW5lZCBpbiBt
eSBsYXN0IG1haWwpIG9yIGdvIHdpdGgNCiAgICByZXBsYWNpbmcgdGhhdCBydWxlIGZvciBlYWNo
IGFkZGVkL3JlbW92ZWQgbm9kZS4gWW91J2xsIGhhdmUgdG8gYWRqdXN0DQogICAgYm90aCBtYXBw
aW5nIGNvbnRlbnRzIGFuZCBtb2R1bHVzIHZhbHVlIQ0KICAgIA0KICAgIFdoaWxlIGl0IHdvdWxk
IGJlIG5pY2UgdG8gaGF2ZSBhIGJldHRlciB3YXkgb2YgbWFuYWdpbmcgdGhpcw0KICAgIGxvYWQt
YmFsYW5jaW5nLCBJIGhhdmUgbm8gaWRlYSBob3cgb25lIHdvdWxkIGlkZWFsbHkgaW1wbGVtZW50
IGl0LiBGZWVsDQogICAgZnJlZSB0byBmaWxlIGEgdGlja2V0IGluIG5ldGZpbHRlciBidWd6aWxs
YSwgYnV0IGRvbid0IGhvbGQgeW91ciBicmVhdGgNCiAgICBmb3IgYSBxdWljayBzb2x1dGlvbi4N
CiAgICANCiAgICBDaGVlcnMsIFBoaWwNCiAgICANCg0K
