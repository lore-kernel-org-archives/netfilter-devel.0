Return-Path: <SRS0=pcvh=2J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FEE9C43603
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Dec 2019 18:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26120227BF
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Dec 2019 18:19:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="Ac0XoBFv";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="ILBAD5np"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfLSST2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Dec 2019 13:19:28 -0500
Received: from alln-iport-8.cisco.com ([173.37.142.95]:50381 "EHLO
        alln-iport-8.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726797AbfLSST2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Dec 2019 13:19:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=3914; q=dns/txt; s=iport;
  t=1576779567; x=1577989167;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RIUrqIT4fVDL3r8WGiAb6a6txvo2hCoKaK1JJ3aYCnI=;
  b=Ac0XoBFvdnA6OO6zb4upy82n+X0CRcdpAtvDDd7+OoxmkoMhSiW1rzpO
   sPA1p7gcfz6oavxPQvF5yhWctvyzjLthI+cDveaUt7HmpA3YyXEoQxtPe
   hY3iy5ePq1Vex2dMVtl30CF5q5t5TrR4fmlCk5SPjpDttlU0H6cRk1vOU
   c=;
IronPort-PHdr: =?us-ascii?q?9a23=3AfePmMxK/mBlKRLIzPdmcpTVXNCE6p7X5OBIU4Z?=
 =?us-ascii?q?M7irVIN76u5InmIFeBvKd2lFGcW4Ld5roEkOfQv636EU04qZea+DFnEtRXUg?=
 =?us-ascii?q?Mdz8AfngguGsmAXFbxIez0YjY5NM9DT1RiuXq8NBsdFQ=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AUAACovvtd/5pdJa1lGgEBAQEBAQE?=
 =?us-ascii?q?BAQMBAQEBEQEBAQICAQEBAYFqAwEBAQELAYFMUAWBRCAECyoKg3yDRgOKc4J?=
 =?us-ascii?q?fmAiBLoEkA1QJAQEBDAEBLQIBAYRAAheCBSQ2Bw4CAw0BAQQBAQECAQUEbYU?=
 =?us-ascii?q?3DIVfAQEBAxIREQwBATcBDwIBCBgCAiYCAgIwFRACBAENBSKDAIJHAy4BoXc?=
 =?us-ascii?q?CgTiIYXWBMoJ+AQEFhSAYggwJgQ4oAYwYGoFBP4E4IIJMPoRJF4J5MoIsjUa?=
 =?us-ascii?q?CcZ5YCoI0lhgblhGEQI5RmlECBAIEBQIOAQEFgVkNJYFYcBU7KgGCQVAYDY0?=
 =?us-ascii?q?SDBeDUIpTdIEojlwBgQ8BAQ?=
X-IronPort-AV: E=Sophos;i="5.69,332,1571702400"; 
   d="scan'208";a="396425810"
Received: from rcdn-core-3.cisco.com ([173.37.93.154])
  by alln-iport-8.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 19 Dec 2019 18:19:27 +0000
Received: from XCH-RCD-001.cisco.com (xch-rcd-001.cisco.com [173.37.102.11])
        by rcdn-core-3.cisco.com (8.15.2/8.15.2) with ESMTPS id xBJIJR5c003378
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 19 Dec 2019 18:19:27 GMT
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by XCH-RCD-001.cisco.com
 (173.37.102.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 19 Dec
 2019 12:19:26 -0600
Received: from xhs-rcd-002.cisco.com (173.37.227.247) by xhs-rtp-002.cisco.com
 (64.101.210.229) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 19 Dec
 2019 13:19:25 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-002.cisco.com (173.37.227.247) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 19 Dec 2019 12:19:24 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EdDFx+iDNFflFd1zYJLKMSmNO7tv6lRenjR8wG6jjauM4Jif1G19rAn7KUFo0N3BbRMqwv061YYcyiKFmQQAUFfyFux80uhUWS3fkN8PF/j4KsjiBtkMXdz5E2mLqiEMSB/IAwAdHOiauGbiURtQOQYhmRjQINkYooONQxLAW4eMZkUQrybv5zRR/yxAeByx4XJaebCUbgzMmgLVliJZF4gCP41pkgcyNEshuDTvxa+TCIlHTyXT39KX+WXTE/HC0RqsmDfxevQLqKSzvqQrZ8mCanTWpSvSgiAs7vpxdBnMVaA6f1oRmXw4gakb4pa2wcLiKmfMgoqO20/9T4GMIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RIUrqIT4fVDL3r8WGiAb6a6txvo2hCoKaK1JJ3aYCnI=;
 b=Nuq2FJCX06WdMc/ONupx8Xg8Z4z+ChK8eXpTSgzi7Dd635647LNfUFYgBD1bT0+C+9wRJgj7gMmNeKrX5aX78LTQ3L3Qgx+93+BmKNlHXXWnKHnN3jwcgXXAw+52ZGWmJ9Tfkcvxbc5RnFJTJ+tfU6lK1bfoLdbWVQtaizYY2uX3CuYV/mlKuOLUQDEOCgwFmpLf3AgbWp7nmGHyKh1j3SGDBn3OAjpFeGl3a3wO8CebiO9PVkERETUpgjk6hvnwBAnGy4imz614BNmlotRtvI3WOHbAxKeM/Rpe8HNR3ehFrI50undQ9LrEUp3vcOs4MNGSS0uleEop+EwKXvL2HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RIUrqIT4fVDL3r8WGiAb6a6txvo2hCoKaK1JJ3aYCnI=;
 b=ILBAD5npDRpLo3KVO0AWPqLnG4d8c/KdoPkHyWG8IdpKu/ieXLiUJJVXHnRkMHidi3dRjkmPwkFYIsZVK8/vc6uKVIQzhtErgYXu9gaCKXFskLcfd+a3hobpmEqEtg8lNtSlkTbaa1IPpiIOYk+3G65a0T+l9gCtHAt/xrXOBzM=
Received: from DM5PR11MB1484.namprd11.prod.outlook.com (10.172.36.14) by
 DM5PR11MB1450.namprd11.prod.outlook.com (10.172.39.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Thu, 19 Dec 2019 18:19:24 +0000
Received: from DM5PR11MB1484.namprd11.prod.outlook.com
 ([fe80::e1fe:e33a:f856:7c26]) by DM5PR11MB1484.namprd11.prod.outlook.com
 ([fe80::e1fe:e33a:f856:7c26%10]) with mapi id 15.20.2538.022; Thu, 19 Dec
 2019 18:19:24 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>
CC:     Laura Garcia <nevola@gmail.com>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Numen with reference to vmap
Thread-Topic: Numen with reference to vmap
Thread-Index: AQHVqj1Ubs5ZA1L3AEmU3M7cfc9ezqepw9GA///mtACAAGztAP//svyAgABX04CAABp3AIAAVCiAgBKu9ACAARbtgP//xyeAAA/qeAAAKIIrgAALSEoA///THgCAAFfMAIAA+MQA///yJwCAAGDPAP//sEKAgAAm64A=
Date:   Thu, 19 Dec 2019 18:19:23 +0000
Message-ID: <6E35A7A0-481D-40B6-A504-04EF0A2DEDA2@cisco.com>
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
 <F56E73D4-3A7E-4CCE-AEA4-C867CC11A08B@cisco.com>
In-Reply-To: <F56E73D4-3A7E-4CCE-AEA4-C867CC11A08B@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.20.0.191208
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c216d30e-09bd-42d9-7649-08d784aff9d5
x-ms-traffictypediagnostic: DM5PR11MB1450:
x-microsoft-antispam-prvs: <DM5PR11MB1450D6A19D9FE4CE0DBAFE42C4520@DM5PR11MB1450.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0256C18696
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(346002)(39860400002)(136003)(366004)(199004)(189003)(66476007)(186003)(26005)(2616005)(2906002)(33656002)(4326008)(36756003)(81166006)(8936002)(5660300002)(86362001)(478600001)(8676002)(81156014)(53546011)(4001150100001)(6486002)(6506007)(66556008)(316002)(66946007)(76116006)(91956017)(110136005)(71200400001)(54906003)(6512007)(64756008)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB1450;H:DM5PR11MB1484.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FxIwdIZk1DJugmCguevPL3MbRKwx1s5mYQ6lVPMQ6AIFmdT/N0fEYQ5liw5Wjwhmrkv1LCtQXakMDTlPvMXpHoFGD1YN0YafGD+Wg55lpTBvfyAAkZDVkLOqCTKn3KuSJ+J/Iyi5MFtYaVZotitVEujXyx8BFAPR6oEuA+fqtsDMf/ZFzX0Wa2LHn+T93NSXGQWg62M4J5wHFNdu1e9WCGCoPqnuPpe0+8/OcRf9u8aYip7pvtQtzX2GMa/oJxoh1udziHs1ELyxC7SLmh7OHYrWENRf+RAjpymwlcqn4MBiDx6JPtr5PKxUpvR95qnxH6W8LQRkF7+ZN7XaTzRPdTNB19mkIl8a0uSIF5BTqjM2Ba9IMdSeIxWQdCEeEW4d2nkiFLfaIbBJpZfNghxP6kl1s/CjPbWOe6QRSbgZiaTm6VLepc8SCXzUYavzhvpt
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F9E7513E6BDC364A91A0914FB7356870@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c216d30e-09bd-42d9-7649-08d784aff9d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2019 18:19:23.9854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MwEgO3N7TV3hlKyZONXRPG6KLP0HdDF0bxZMKNkyoYpP1HTj/71K/5V8X2nMI0VPNMUokwf3rAalpl0xmW3Cqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1450
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.11, xch-rcd-001.cisco.com
X-Outbound-Node: rcdn-core-3.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

V2hpbGUgdHJ5aW5nIHRvIGFkZCBhbiBlbGVtZW50IHRvIHRoZSBzZXQsIEkgYW0gZ2V0dGluZyBl
cnJvcjoNCg0Kc3VkbyBuZnQgLS1kZWJ1ZyBhbGwgYWRkIGVsZW1lbnQgaXB2NHRhYmxlIG5vLWVu
ZHBvaW50cy1zZXJ2aWNlcyAgeyB0Y3AgLiAxOTIuMTY4LjgwLjEwNCAuIDg5ODkgOiBnb3RvIGRv
X3JlamVjdCB9DQoNCkVycm9yOiBDb3VsZCBub3QgcHJvY2VzcyBydWxlOiBJbnZhbGlkIGFyZ3Vt
ZW50DQphZGQgZWxlbWVudCBpcHY0dGFibGUgbm8tZW5kcG9pbnRzLXNlcnZpY2VzIHsgdGNwIC4g
MTkyLjE2OC44MC4xMDQgLiA4OTg5IDogZ290byBkb19yZWplY3QgfQ0KXl5eXl5eXl5eXl5eXl5e
Xl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5e
Xl5eXl5eXl5eXl5eXl5eXl5eXl5eDQpBbnl0aGluZyBhbSBJIGRvaW5nIHdyb25nPw0KVGhhbmsg
eW91DQpTZXJndWVpDQoNCu+7v09uIDIwMTktMTItMTksIDExOjAwIEFNLCAiU2VyZ3VlaSBCZXp2
ZXJraGkgKHNiZXp2ZXJrKSIgPHNiZXp2ZXJrQGNpc2NvLmNvbT4gd3JvdGU6DQoNCiAgICBISSBQ
aGlsLA0KICAgIA0KICAgIEkgYnVpbHQgMC45LjMgYW5kIG5vdyBpdCByZWNvZ25pemVzICJ0aCIs
IGJ1dCB0aGVyZSBpcyBJIHN1c3BlY3QgYSBjb3NtZXRpYyBpc3N1ZSBpbiB0aGUgb3V0cHV0IGlu
IG5mdCBjbGkuIFNlZSBiZWxvdyB0aGUgY29tbWFuZCBJIHVzZWQ6DQogICAgc3VkbyBuZnQgLS1k
ZWJ1ZyBhbGwgYWRkIHJ1bGUgaXB2NHRhYmxlIGs4cy1maWx0ZXItc2VydmljZXMgaXAgcHJvdG9j
b2wgLiBpcCBkYWRkciAuIHRoIGRwb3J0IHZtYXAgQG5vLWVuZHBvaW50cy1zZXJ2aWNlcw0KICAg
IA0KICAgIEl0IGxvb2tzIGxpa2UgY29ycmVjdGx5IGdlbmVyYXRpbmcgZXhwcmVzc2lvbnM6DQog
ICAgDQogICAgaXAgaXB2NHRhYmxlIGs4cy1maWx0ZXItc2VydmljZXMgDQogICAgICBbIHBheWxv
YWQgbG9hZCAxYiBAIG5ldHdvcmsgaGVhZGVyICsgOSA9PiByZWcgMSBdDQogICAgICBbIHBheWxv
YWQgbG9hZCA0YiBAIG5ldHdvcmsgaGVhZGVyICsgMTYgPT4gcmVnIDkgXQ0KICAgICAgWyBwYXls
b2FkIGxvYWQgMmIgQCB0cmFuc3BvcnQgaGVhZGVyICsgMiA9PiByZWcgMTAgXQ0KICAgICAgWyBs
b29rdXAgcmVnIDEgc2V0IG5vLWVuZHBvaW50cy1zZXJ2aWNlcyBkcmVnIDAgXQ0KICAgIA0KICAg
IEJ1dCB3aGVuIEkgcnVuICJzdWRvIG5mdCBsaXN0IHRhYmxlcyBpcHY0dGFibGUiIHRoZSBydWxl
IGlzIG1pc3NpbmcgdGhpcmQgcGFyYW1ldGVyLg0KICAgIA0KICAgIHRhYmxlIGlwIGlwdjR0YWJs
ZSB7DQogICAgCW1hcCBuby1lbmRwb2ludHMtc2VydmljZXMgew0KICAgIAkJdHlwZSBpbmV0X3By
b3RvIC4gaXB2NF9hZGRyIC4gaW5ldF9zZXJ2aWNlIDogdmVyZGljdA0KICAgIAl9DQogICAgDQog
ICAgCWNoYWluIGs4cy1maWx0ZXItc2VydmljZXMgew0KICAgIAkJaXAgcHJvdG9jb2wgLiBpcCBk
YWRkciB2bWFwIEBuby1lbmRwb2ludHMtc2VydmljZXMgICAgICAgICAgICA8IC0tLS0tLS0tLS0t
LS0tLS0tLS0gTWlzc2luZyAiIHRoIGRwb3J0Ig0KICAgIAl9DQogICAgfQ0KICAgIA0KICAgIEl0
IHNlZW1zIGp1c3QgYSBjb3NtZXRpYyB0aGluZywgYnV0IGV2ZW50dWFsbHkgd291bGQgYmUgbmlj
ZSB0byBoYXZlIGl0IGZpeGVkLCBpZiBpdCBoYXMgbm90IGJlZW4gYWxyZWFkeSBpbiB0aGUgbWFz
dGVyIGJyYW5jaC4gSSBhbSB1c2luZyB2MC45LjMgYnJhbmNoLg0KICAgIA0KICAgIFRoYW5rIHlv
dQ0KICAgIFNlcmd1ZWkNCiAgICBPbiAyMDE5LTEyLTE5LCAxMDo0NiBBTSwgIm4wLTFAb3JieXRl
Lm53bC5jYyBvbiBiZWhhbGYgb2YgUGhpbCBTdXR0ZXIiIDxuMC0xQG9yYnl0ZS5ud2wuY2Mgb24g
YmVoYWxmIG9mIHBoaWxAbndsLmNjPiB3cm90ZToNCiAgICANCiAgICAgICAgSGksDQogICAgICAg
IA0KICAgICAgICBPbiBUaHUsIERlYyAxOSwgMjAxOSBhdCAwMjo1OTowMVBNICswMDAwLCBTZXJn
dWVpIEJlenZlcmtoaSAoc2JlenZlcmspIHdyb3RlOg0KICAgICAgICA+IE5vdCBzdXJlIHdoeSwg
YnV0IGV2ZW4gd2l0aCAwLjkuMiAidGgiIGV4cHJlc3Npb24gaXMgbm90IHJlY29nbml6ZWQuDQog
ICAgICAgID4gDQogICAgICAgID4gZXJyb3I6IHN5bnRheCBlcnJvciwgdW5leHBlY3RlZCB0aA0K
ICAgICAgICA+IGFkZCBydWxlIGlwdjR0YWJsZSBrOHMtZmlsdGVyLXNlcnZpY2VzIGlwIHByb3Rv
Y29sIC4gaXAgZGFkZHIgLiB0aCBkcG9ydCB2bWFwIEBuby1lbmRwb2ludHMtc2VydmljZXMNCiAg
ICAgICAgPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
Xl4NCiAgICAgICAgPiBzYmV6dmVya0BkZXYtdWJ1bnR1LTE6bWltaWMtZmlsdGVyJCBzdWRvIG5m
dCAtdmVyc2lvbg0KICAgICAgICA+IG5mdGFibGVzIHYwLjkuMiAoU2NyYW0pDQogICAgICAgID4g
c2JlenZlcmtAZGV2LXVidW50dS0xOm1pbWljLWZpbHRlciQNCiAgICAgICAgPiANCiAgICAgICAg
PiBJdCBzZWVtcyAwLjkuMyBpcyBvdXQgYnV0IHN0aWxsIG5vIERlYmlhbiBwYWNrYWdlLiBJcyBp
dCBwb3NzaWJsZSBpdCBkaWQgbm90IG1ha2UgaXQgaW50byAwLjkuMj8NCiAgICAgICAgDQogICAg
ICAgIE5vdCBzdXJlIHdoYXQncyBtaXNzaW5nIG9uIHlvdXIgZW5kLiBJIGNoZWNrZWQgMC45LjIg
dGFyYmFsbCwgYXQgbGVhc3QNCiAgICAgICAgcGFyc2VyIHNob3VsZCB1bmRlcnN0YW5kIHRoZSBz
eW50YXguDQogICAgICAgIA0KICAgICAgICBDaGVlcnMsIFBoaWwNCiAgICAgICAgDQogICAgDQog
ICAgDQoNCg==
