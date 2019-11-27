Return-Path: <SRS0=TrSD=ZT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 305ACC432C0
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Nov 2019 16:51:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E22882075C
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Nov 2019 16:51:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="fCRWSEWz";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="dYIrtL3o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfK0QvB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Nov 2019 11:51:01 -0500
Received: from alln-iport-6.cisco.com ([173.37.142.93]:25435 "EHLO
        alln-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbfK0QvB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Nov 2019 11:51:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=4082; q=dns/txt; s=iport;
  t=1574873460; x=1576083060;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=iUVLQafYnz7tNimv3qzQbpxjkzsAep2OV7uIhdGUb0g=;
  b=fCRWSEWzwtirbeRX4WXMElIES5ZIBYx4pJFkzW3d2S2296+6MXWWbCmO
   h+xfGPYdeVL0ALBL3zu5e0VkR5iz9mKdS5PGOAhB1MqT1mPtrfGSLPUEZ
   BUs7jqwoCOrU/uOJMXRc3VB7kqyQIAWe+wCLZRV92yarZ2071b+xo/dlK
   0=;
IronPort-PHdr: =?us-ascii?q?9a23=3A6Kib2x/5nrk8Xf9uRHGN82YQeigqvan1NQcJ65?=
 =?us-ascii?q?0hzqhDabmn44+8ZR7E/fs4iljPUM2b8P9Ch+fM+4HYEW0bqdfk0jgZdYBUER?=
 =?us-ascii?q?oMiMEYhQslVdWPBF/lIeTpRyc7B89FElRi+iLzPA=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0CwAADLqN5d/5FdJa1lGgEBAQEBAQE?=
 =?us-ascii?q?BAQMBAQEBEQEBAQICAQEBAYF+gUspJwVsWCAECyoKhCGDRgOKaYJfmASCUgN?=
 =?us-ascii?q?UCQEBAQwBASMKAgEBhEACF4FpJDgTAgMNAQEEAQEBAgEFBG2FNwyFUwEBAQM?=
 =?us-ascii?q?SEREMAQE3AQ8CAQgYAgImAgICMBUQAgQOBSKDAAGCRgMuAQIMqBACgTiIYHW?=
 =?us-ascii?q?BMoJ+AQEFgTUBg2oYghcDBoEOKIwWGoFBP4E4IIFOSQcuPoJLGQKBL0uCeTK?=
 =?us-ascii?q?CLI9fOZ4lCoIthx2OORuaH5cEkVgCBAIEBQIOAQEFgWkiKoEucBVlAYJBUBE?=
 =?us-ascii?q?UhkgMF4EEAQmCQopTdAeBIYwFAYEPAQE?=
X-IronPort-AV: E=Sophos;i="5.69,250,1571702400"; 
   d="scan'208";a="389857725"
Received: from rcdn-core-9.cisco.com ([173.37.93.145])
  by alln-iport-6.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 27 Nov 2019 16:51:00 +0000
Received: from XCH-ALN-008.cisco.com (xch-aln-008.cisco.com [173.36.7.18])
        by rcdn-core-9.cisco.com (8.15.2/8.15.2) with ESMTPS id xARGoxTr018675
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 27 Nov 2019 16:50:59 GMT
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by XCH-ALN-008.cisco.com
 (173.36.7.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 27 Nov
 2019 10:50:59 -0600
Received: from xhs-aln-001.cisco.com (173.37.135.118) by xhs-rtp-002.cisco.com
 (64.101.210.229) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 27 Nov
 2019 11:50:57 -0500
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-001.cisco.com (173.37.135.118) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 27 Nov 2019 10:50:57 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ke6W7X05SPWmuSpIphMKxZxnAC3MSEDq+3yA7DzsFMxrQ+B+YdGcxXL5FBXVfITMONIV5jetC3GBhojusoKMQTW+kBXReyfxNs3eIXKVwGWICn5WroDQ9LhhO36Sk7gmVtGEnoXCrd8PaonqF65VhsUd3p3bAAHes6utkIbDHvtAyhcxnA0qhiWmjB4JKWIrGTigYMcYXkILESZk6rYT9EJ4ycliOlsYvFTmXas9BkU5yqot2uRszTfQNP+I3xY/e0QERsuqBQGSqLGinoHb9ULrpQb8nSE98iAU4NNAAoGHX9zDO+JqCsiWmqyQ3kArEAhEezaUqJdWDsYcB0+3vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iUVLQafYnz7tNimv3qzQbpxjkzsAep2OV7uIhdGUb0g=;
 b=a4ShjhoFPGvm25EMc8tfEP0qHwEzPplOTy/updLBeUnQJFE9OHAiTe+EZaJSigSdy6FIB37fIugkTfFYiVYKScIpkYeOdaQzcUXLHRZ7/u+JhUAh6stEc4erge7i4YStf39ocR+PEa07535DKWu7Bs+Ka1I1YxWuU4eVHXKUo/bJ5bgT13y35PGQyourYqjVWSFJT6aub0M5pg9RM4A/qsBgvmNKk+tzFGZNGF/8SeQ7UtNuSWtXEoEOx1yi9uW4lehNRC1H7yBDYI4h+HWxa8TVbW8LYPgPcV+jl+FFxE7IBh0TqMVzmEhmT+Z/x1Z2gO7lgQJWsv8c1iM21GP6Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iUVLQafYnz7tNimv3qzQbpxjkzsAep2OV7uIhdGUb0g=;
 b=dYIrtL3ov1jZ6426Mjw+E2A4Gipxu3o6CIS23mpLoDeVY5jwjzpaV55c2vqTB7EptGX9WuaffxFlF9Lv0keU6IgMjUHhbnlBXuo6JB7+FYDxf5H83NRVObUd9WW0X8zIZsSiI5B0t1Sm3vuRiCuHTmrrlHhqEat3IiIBI1efefE=
Received: from SN6PR11MB3358.namprd11.prod.outlook.com (52.135.110.149) by
 SN6PR11MB2845.namprd11.prod.outlook.com (52.135.93.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.18; Wed, 27 Nov 2019 16:50:56 +0000
Received: from SN6PR11MB3358.namprd11.prod.outlook.com
 ([fe80::280e:21c6:3ef8:1a6d]) by SN6PR11MB3358.namprd11.prod.outlook.com
 ([fe80::280e:21c6:3ef8:1a6d%7]) with mapi id 15.20.2474.023; Wed, 27 Nov 2019
 16:50:56 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Phil Sutter <phil@nwl.cc>
CC:     Arturo Borrero Gonzalez <arturo@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "Laura Garcia" <nevola@gmail.com>
Subject: Re: Operation not supported when adding jump command
Thread-Topic: Operation not supported when adding jump command
Thread-Index: AQHVo8HvElEENwloc0uP91utUJLts6edYHQA///QMACAAGcLAP//rq8AgABU1YD//91EAAAL5rgA///LmgCAAStKAP//9huAgABc5QD//7OUAIAAXK0A//+4hIA=
Date:   Wed, 27 Nov 2019 16:50:56 +0000
Message-ID: <7C2EF59A-57A3-4E55-92EB-7D64BC0A8417@cisco.com>
References: <20191126153850.pblaoj4xklfz5jgv@salvia>
 <427E92A6-2FFA-47CF-BF3B-C08961C978C9@cisco.com>
 <20191126155125.GD8016@orbyte.nwl.cc>
 <0A92D5EA-B158-4C7A-B85C-1692AE7C828B@cisco.com>
 <20191126192752.GE8016@orbyte.nwl.cc>
 <AC4B6BFD-30FA-4A62-AD3C-3EB37029EC1B@cisco.com>
 <3a457e5b-be8f-e99d-fb0d-4826a15a4a55@netfilter.org>
 <89C24159-37F8-4D2F-B391-8A1D6AE403E7@cisco.com>
 <20191127150836.GJ8016@orbyte.nwl.cc>
 <3AE9B74A-37FB-4CDA-86FB-143F506D6C77@cisco.com>
 <20191127160646.GK8016@orbyte.nwl.cc>
In-Reply-To: <20191127160646.GK8016@orbyte.nwl.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.77]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bbac315b-0de5-4e6c-af4e-08d77359f905
x-ms-traffictypediagnostic: SN6PR11MB2845:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <SN6PR11MB28459A36F96C68C0C30D6625C4440@SN6PR11MB2845.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 023495660C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(376002)(136003)(39860400002)(366004)(46564003)(189003)(199004)(2906002)(316002)(26005)(66066001)(5660300002)(99286004)(102836004)(6506007)(229853002)(4001150100001)(36756003)(8936002)(81156014)(81166006)(446003)(2616005)(186003)(256004)(6116002)(33656002)(3846002)(6486002)(11346002)(305945005)(8676002)(7736002)(54906003)(86362001)(4326008)(76176011)(6512007)(6306002)(6246003)(6916009)(25786009)(6436002)(91956017)(478600001)(71200400001)(58126008)(66446008)(66946007)(14454004)(66556008)(966005)(76116006)(66476007)(64756008)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB2845;H:SN6PR11MB3358.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e4tGpmFg5etmUDBMPpgt7tGaUr/EsVDXQN9mxp4tdPVxe/SiSVq422jMiSv8YJDIjUSE920u8MGCdyH5NXWL7tsVfzldtpdsTXVwIU2jlAC2NbAfArzocIKYhcR6Lxb1tM4dzCfPW8K8JkK7GbE4TPtvPoVUSIh9vEGMOKE43zii4vpnU2Qwr/c5a6xo9GpLixlcD0Oue97kyN623eDOxt6wpvDKQXqw4P3b5D/E9Zm7ACUOzfcKDoyUr9ep1vvX6yoB/EQL4xJSQOQKgF3wjuCHVTo1UYWUP5tKGWOOxMyuUzlGMX2mGaPzq+ma37RX3pWNLAzoVK3mm0OiPZPbCmawhYnvSPLeKhQrr20v7CUHOMjl0kUxxwbgsZVV01ZepsdkEneZu5rWkjobOezTP0QNrh5wZafmYehaYO6vbXnaqQpPOz3ZZryXNaRZjoeKwhwSYQj+9aaEXW1d4wALZYYLWnnMSUMunfYandLarw8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <3CC4D10AE4DDCE449981272EB1D4BECA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bbac315b-0de5-4e6c-af4e-08d77359f905
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2019 16:50:56.2298
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EvIV/g2bdvLOYk8rxFJ4KmtMzRipIb2rOaSi3sWa7b5Homk/pWJraYrhIlZ7M5SN9wZ/7uRgGokv0vt8cMe69Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2845
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.18, xch-aln-008.cisco.com
X-Outbound-Node: rcdn-core-9.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGksDQoNCkFjY29yZGluZyB0byBhcGkgZm9sa3Mga3ViZS1wcm94eSBtdXN0IHN1c3RhaW4gNWsg
b3IgYWJvdXQgdGVzdCBvdGhlcndpc2UgaXQgd2lsbCBuZXZlciBzZWUgcHJvZHVjdGlvbiBlbnZp
cm9ubWVudC4gSW1wbGVtZW50aW5nIG9mIG51bWdlbiBleHByZXNzaW9uIGlzIHJlbGF0aXZlbHkg
c2ltcGxlLCB0aGFua3MgdG8gIm5mdCAtLWRlYnVnIGFsbCIgb25jZSBpdCdzIGRvbmUsIGEgdXNl
ciBjYW4gdXNlIGl0IGFzIGVhc2lseSBhcyAgd2l0aCBqc29uIF9fDQoNClJlZ2FyZGluZyBjb25j
dXJyZW50IHVzYWdlLCBzaW5jZSBteSBwcmltYXJ5IGdvYWwgaXMga3ViZS1wcm94eSBJIGRvIG5v
dCByZWFsbHkgY2FyZSBhdCB0aGlzIG1vbWVudCwgYXMgazhzIGNsdXN0ZXIgaXMgbm90IGFuIGFw
cGxpY2F0aW9uIHlvdSBjby1sb2NhdGUgaW4gcHJvZHVjdGlvbiB3aXRoIHNvbWUgb3RoZXIgYXBw
bGljYXRpb25zIHBvdGVudGlhbGx5IGFsdGVyaW5nIGhvc3QncyB0YWJsZXMuIEkgYWdyZWUgZmly
ZXdhbGxkIG1pZ2h0IGJlIGludGVyZXN0aW5nIGFuZCBtb3JlIGdlbmVyaWMgYWx0ZXJuYXRpdmUs
IGJ1dCBzZWVpbmcgaG93IHF1aWNrbHkgdGhpbmdzIGFyZSBkb25lIGluIGs4cywgIG1heWJlIGl0
IHdpbGwgYmUgZG9uZSBieSB0aGUgZW5kIG9mIDIxc3QgY2VudHVyeSBfXw0KDQpPbmNlIEkgZ2V0
IGZpbHRlciBjaGFpbiBwb3J0aW9uIGluIHRoZSBjb2RlIEkgd2lsbCBzaGFyZSBhIGxpbmsgdG8g
cmVwbyBzbyB5b3UgY291bGQgcmV2aWV3Lg0KDQpUaGFua3MgYSBsb3QgZm9yIHRoaXMgZGlzY3Vz
c2lvbiwgdmVyeSB1c2VmdWwNClNlcmd1ZWkNCg0K77u/T24gMjAxOS0xMS0yNywgMTE6MDggQU0s
ICJuMC0xQG9yYnl0ZS5ud2wuY2Mgb24gYmVoYWxmIG9mIFBoaWwgU3V0dGVyIiA8bjAtMUBvcmJ5
dGUubndsLmNjIG9uIGJlaGFsZiBvZiBwaGlsQG53bC5jYz4gd3JvdGU6DQoNCiAgICBIaSwNCiAg
ICANCiAgICBPbiBXZWQsIE5vdiAyNywgMjAxOSBhdCAwMzozNTowNFBNICswMDAwLCBTZXJndWVp
IEJlenZlcmtoaSAoc2JlenZlcmspIHdyb3RlOg0KICAgID4gTm8sIEkgZG8gbm90LCBuZnRhYmxl
c2xpYiB0YWxrcyBkaXJlY3RseSB0YWxrIHRvIG5ldGxpbmsgY29ubmVjdGlvbi4NCiAgICA+IA0K
ICAgID4gbmZ0YWJsZXNsaWIgb2ZmZXJzIGFuIEFQSSB3aGljaCBhbGxvd3MgY3JlYXRlIHRhYmxl
cy9jaGFpbnMvcnVsZXMgYW5kIGV4cG9zZXMgYW4gaW50ZXJmYWNlIHdoaWNoIGxvb2tzIHNpbWls
YXIgdG8gazhzIGNsaWVudC1nby4gIElmIHlvdSBjaGVjayBodHRwczovL2dpdGh1Yi5jb20vc2Jl
enZlcmsvbmZ0YWJsZXNsaWIvYmxvYi9tYXN0ZXIvY21kL2UyZS9lMmUuZ28NCiAgICA+IA0KICAg
ID4gSXQgd2lsbCBnaXZlIHlvdSBhIGdvb2QgaWRlYSBob3cgaXQgb3BlcmF0ZXMuDQogICAgPiAN
CiAgICA+IFRoZSByZWFzb24gZm9yIGdvaW5nIGluIHRoaXMgZGlyZWN0aW9uIGlzICBwZXJmb3Jt
YW5jZSwgZm9yIGEgcmVsYXRpdmVseSBzdGF0aWMgYXBwbGljYXRpb25zIGxpa2UgYSBmaXJld2Fs
bCwganNvbiBhcHByb2FjaCBpcyBncmVhdCwgYnV0IGZvciBhcHBsaWNhdGlvbnMgbGlrZSBhIGt1
YmUtcHJveHkgd2hlcmUgaHVuZHJlZHMgb3IgZXZlbiB0aG91c2FuZHMgb2Ygc2VydmljZS9lbmRw
b2ludCBldmVudHMgaGFwcGVuLCBJIGRvIG5vdCBiZWxpZXZlIGpzb24gaXMgYSByaWdodCBhcHBy
b2FjaC4gV2hlbiBJIHRhbGtlZCB0byBhcGkgbWFjaGluZXJ5IGZvbGtzIEkgd2FzIGdpdmVuIDVr
IGV2ZW50cyBwZXIgc2Vjb25kIGFzIGEgdGFyZ2V0Lg0KICAgIA0KICAgIFNvIHlvdSdyZSBieXBh
c3NpbmcgYm90aCBsaWJuZnRhYmxlcyBhbmQgbGlibmZ0bmwuIFRob3NlIDVrIGV2ZW50cyBwZXIN
CiAgICBzZWNvbmQgYXJlIGEgYmVuY2htYXJrLCBub3QgYW4gZXhwZWN0ZWQgbG9hZCwgcmlnaHQ/
DQogICAgDQogICAgV2hpbGUgeW91J3JlIG9idmlvdXNseSBzZWFyY2hpbmcgZm9yIHRoZSBtb3N0
IHBlcmZvcm1hbmNlLCB0aGUgZHJhd2JhY2sNCiAgICBpcyBjb21wbGV4aXR5LiBVc2luZyBKU09O
IChhbmQgdGhlcmVieSBsaWJuZnRhYmxlcyBhbmQgbGlibmZ0bmwgYXMNCiAgICBiYWNrZW5kcykg
YSB0YXNrIGxpa2UgdXRpbGl6aW5nIG51bWdlbiBleHByZXNzaW9uIGlzIHJlbGF0aXZlbHkgc2lt
cGxlLg0KICAgIA0KICAgIEEgcHJvYmxlbSB5b3Ugd29uJ3QgZ2V0IHJpZCBvZiB3aXRoIHRoZSBt
b3ZlIGZyb20gaXB0YWJsZXMgdG8gbmZ0YWJsZXMNCiAgICBpcyBjb25jdXJyZW50IHVzZTogVGhl
ICJsZXQncyBpbnNlcnQgb3VyIHJ1bGVzIG9uIHRvcCIgYXBwcm9hY2ggdG8NCiAgICBkZWFsaW5n
IHdpdGggYW4gZXhpc3RpbmcgcnVsZXNldCBvciBvdGhlciB1c2VycyBpcyBvYnZpb3VzbHkgbm90
IHRoZQ0KICAgIGJlc3Qgb25lLiBJIGd1ZXNzIHlvdSdyZSBhaW1pbmcgYXQgZGVkaWNhdGVkIGFw
cGxpY2F0aW9ucyB3aGVyZSB0aGlzIGlzDQogICAgbm90IGFuIGlzc3VlIGJ1dCBmb3IgImdlbmVy
YWwgcHVycG9zZSIgYXBwbGljYXRpb25zIEkgZ3Vlc3MgYSBrOHMNCiAgICBiYWNrZW5kIGNvbW11
bmljYXRpbmcgd2l0aCBmaXJld2FsbGQgd291bGQgYmUgYSBnb29kIGFwcHJvYWNoIG9mDQogICAg
Y3VzdG9taXppbmcgaG9zdCdzIGZpcmV3YWxsIHNldHVwIHdpdGhvdXQgc3RlcHBpbmcgb250byBv
dGhlcnMnIHRvZXMuDQogICAgDQogICAgQmFjayB0byB0b3BpYywgeW91IGFyZSBjcmVhdGluZyBh
IHN0YXRpYyBydWxlc2V0IGJhc2VkIG9uIHRoZSBpcHRhYmxlcw0KICAgIG9uZSB5b3UgZ290IGZv
ciBzaW1wbGUgY29tcGFyaXNvbiB0ZXN0cyBvciBhcmUgeW91IGFscmVhZHkgb3ZlciB0aGF0PyBJ
Zg0KICAgIG5vdCwgSSBndWVzcyBpdCB3b3VsZCBiZSBhIGdvb2QgYmFzaXMgZm9yIGhpZ2ggbGV2
ZWwgcnVsZXNldA0KICAgIG9wdGltaXphdGlvbiBkaXNjdXNzaW9ucy4NCiAgICANCiAgICBDaGVl
cnMsIFBoaWwNCiAgICANCg0K
