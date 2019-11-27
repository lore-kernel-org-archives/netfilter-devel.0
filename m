Return-Path: <SRS0=TrSD=ZT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A266C432C0
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Nov 2019 15:35:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0AD020674
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Nov 2019 15:35:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="SH3Xs3CM";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="opnHwPDe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfK0PfN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Nov 2019 10:35:13 -0500
Received: from rcdn-iport-1.cisco.com ([173.37.86.72]:59797 "EHLO
        rcdn-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbfK0PfN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Nov 2019 10:35:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=3290; q=dns/txt; s=iport;
  t=1574868912; x=1576078512;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3sjPW1iy20tnJJYtmM4UuOeOJpoNN1+zOLWlVNI/Egs=;
  b=SH3Xs3CMNFjTloSQDU9FLJxP/dNERBQ5ivAed4HC7G/Yy2CzUISCGZRI
   sbJ4iXaJ/+bJyodkwCsWy+K1C0BX95g+PtobsFi9L7ZYdE/Wj+GFrDyRw
   dFWkLpCTTYENwFrM77ir1L+Hm7GlZU9hIcdvZflrAYkFUCljP2yixjuQr
   M=;
IronPort-PHdr: =?us-ascii?q?9a23=3AFw0b6xZbezTbngORJ75JdcL/LSx94ef9IxIV55?=
 =?us-ascii?q?w7irlHbqWk+dH4MVfC4el20gabRp3VvvRDjeee87vtX2AN+96giDgDa9QNMn?=
 =?us-ascii?q?1NksAKh0olCc+BB1f8KavxZSEoAslYV3du/mqwNg5eH8OtL1A=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0ApAACRlt5d/4gNJK1lGgEBAQEBAQE?=
 =?us-ascii?q?BAQMBAQEBEQEBAQICAQEBAYFtAgEBAQELAYFKUAVsWCAECyoKhCGDRgOKcYJ?=
 =?us-ascii?q?fmASCUgNUCQEBAQwBASMKAgEBhEACF4FpJDcGDgIDDQEBBAEBAQIBBQRthTc?=
 =?us-ascii?q?MhVMBAQEDEhERDAEBNwEPAgEIGAICJgICAjAVEAIEDgUigwABgkYDLgECDKc?=
 =?us-ascii?q?8AoE4iGB1gTKCfgEBBYE1AYNlGIIXCYEOKAGMFRqBQT+BOCCBTkkHLj6CSxk?=
 =?us-ascii?q?CgWMXgnkygiyPXzmeJQqCLYcdjjkbgkBzhniPdJcEkVgCBAIEBQIOAQEFgWg?=
 =?us-ascii?q?jN4EhcBVlAYJBCUcRFIZIg3OKU3QHgSGMBQGBDwEB?=
X-IronPort-AV: E=Sophos;i="5.69,249,1571702400"; 
   d="scan'208";a="669209078"
Received: from alln-core-3.cisco.com ([173.36.13.136])
  by rcdn-iport-1.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 27 Nov 2019 15:35:10 +0000
Received: from XCH-RCD-015.cisco.com (xch-rcd-015.cisco.com [173.37.102.25])
        by alln-core-3.cisco.com (8.15.2/8.15.2) with ESMTPS id xARFZAOm020551
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 27 Nov 2019 15:35:10 GMT
Received: from xhs-aln-002.cisco.com (173.37.135.119) by XCH-RCD-015.cisco.com
 (173.37.102.25) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 27 Nov
 2019 09:35:10 -0600
Received: from xhs-rtp-003.cisco.com (64.101.210.230) by xhs-aln-002.cisco.com
 (173.37.135.119) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 27 Nov
 2019 09:35:08 -0600
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-003.cisco.com (64.101.210.230) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 27 Nov 2019 10:35:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IxpmQG8rIovrOwIH6t9IMg/NfqVQpzwt+QWU47c92ErvsVcUNbrS+TbWKRLDyFAQAhRHr2edCR/x8Sg9E2QRUK+lkrEEEsT4uM482iDwRKw8XTEjCd1F5rl2Zk4Zx/APWzY/irtUu9cQWyCqP2XjIOgWgn/NtCyxwaHHFvqT5XpfnzmHxmHQkEnr1jJdInzavlt945XtG8d04OujNUI56iXcd9OXuHtjaGsLp2xPaQ7c0Nx31moiKry7CVZVasauCatM+eiw6icrmwsrJodutKh2kG8ilsbgbsluo+hkshJrduEybGGh8uYDFmPi0kPfueF24yZ+GhWKGuK35KwzFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3sjPW1iy20tnJJYtmM4UuOeOJpoNN1+zOLWlVNI/Egs=;
 b=cVjM19dC1F0xjMpxHHn1Rj0zRAjd47zn/oVVMC31tApRxLtKXoI789Ec542nQxtucxyK65X0ab0SvYzGyQ05tHa2fovFlZBFSV3yQcGKxpXft7XOiP4YVdGbc4zzqnU3pOSEzpQCgxHVod952lW4zrxN171z5pAYh2fR7ocLEe9qb2IUFzS4xLF5oUOS8KUNuwVGqSX8TOYh3lrPSuVY4c7Ej2RGZTIsDRVXNLiHdji5nvLgOwstI5CZbWfH8UTSykykFEs3AmV9sT07SF6FWh6cezh97xZfP75DXkcQ8atuFXnn1P900++FXidYojXktUZOkuZiZFOmK9IJUd+UeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3sjPW1iy20tnJJYtmM4UuOeOJpoNN1+zOLWlVNI/Egs=;
 b=opnHwPDe4hBJ15o+UnWYo5UM/3gT+uhXT25i1At2wKp2sgWn/9LZ4PYOS6x2/P0ka12ct72176JJmJ5XvhAdRaVFIAr7D4aCAhQIz5LEGmZc8LJnRTDMW38shRdNsvOBpevovod6bQ0y35c+tuNymUB44l9faa/fjKrSh1IrWW0=
Received: from SN6PR11MB3358.namprd11.prod.outlook.com (52.135.110.149) by
 SN6PR11MB3087.namprd11.prod.outlook.com (52.135.126.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.19; Wed, 27 Nov 2019 15:35:04 +0000
Received: from SN6PR11MB3358.namprd11.prod.outlook.com
 ([fe80::280e:21c6:3ef8:1a6d]) by SN6PR11MB3358.namprd11.prod.outlook.com
 ([fe80::280e:21c6:3ef8:1a6d%7]) with mapi id 15.20.2474.023; Wed, 27 Nov 2019
 15:35:04 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Phil Sutter <phil@nwl.cc>
CC:     Arturo Borrero Gonzalez <arturo@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "Laura Garcia" <nevola@gmail.com>
Subject: Re: Operation not supported when adding jump command
Thread-Topic: Operation not supported when adding jump command
Thread-Index: AQHVo8HvElEENwloc0uP91utUJLts6edYHQA///QMACAAGcLAP//rq8AgABU1YD//91EAAAL5rgA///LmgCAAStKAP//9huAgABc5QD//7OUAA==
Date:   Wed, 27 Nov 2019 15:35:04 +0000
Message-ID: <3AE9B74A-37FB-4CDA-86FB-143F506D6C77@cisco.com>
References: <20191126122110.GD795@breakpoint.cc>
 <3DBD9E39-A0DF-4A69-93CC-4344617BDB2F@cisco.com>
 <20191126153850.pblaoj4xklfz5jgv@salvia>
 <427E92A6-2FFA-47CF-BF3B-C08961C978C9@cisco.com>
 <20191126155125.GD8016@orbyte.nwl.cc>
 <0A92D5EA-B158-4C7A-B85C-1692AE7C828B@cisco.com>
 <20191126192752.GE8016@orbyte.nwl.cc>
 <AC4B6BFD-30FA-4A62-AD3C-3EB37029EC1B@cisco.com>
 <3a457e5b-be8f-e99d-fb0d-4826a15a4a55@netfilter.org>
 <89C24159-37F8-4D2F-B391-8A1D6AE403E7@cisco.com>
 <20191127150836.GJ8016@orbyte.nwl.cc>
In-Reply-To: <20191127150836.GJ8016@orbyte.nwl.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [24.200.205.158]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1832dc2e-0f23-44a8-a729-08d7734f6004
x-ms-traffictypediagnostic: SN6PR11MB3087:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <SN6PR11MB308756FC9F0776DA91D4D57BC4440@SN6PR11MB3087.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 023495660C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(366004)(39860400002)(346002)(376002)(189003)(199004)(5660300002)(76116006)(305945005)(8936002)(316002)(6512007)(6306002)(554214002)(81166006)(81156014)(8676002)(99286004)(66946007)(6916009)(36756003)(91956017)(4001150100001)(58126008)(54906003)(64756008)(66446008)(66476007)(86362001)(66556008)(7736002)(2616005)(14454004)(3846002)(25786009)(229853002)(446003)(11346002)(966005)(2906002)(33656002)(6116002)(4326008)(6246003)(102836004)(76176011)(26005)(6486002)(6436002)(186003)(6506007)(71190400001)(71200400001)(256004)(66066001)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB3087;H:SN6PR11MB3358.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ry78oEwDGC9DSAwGEPvx3y0UjrhqBJ5CUau0F+KQyyoseAMPX9pcGw5NGJskBRiqvf5QVMhgJdM40x3OgZBoiDkHDDlh9WDxXygZDVBshWzrrd8nrRXSsG7M/RquRFs8Tscrpe0+UageAmuX5rwzsvnj81XYADz5ss4Ekrau0uN3LVCkxY82Sp0unOFmDumsYfkuliM/gy6eA7aknjt8Eyc3QBVrjX3GjZCkg6HVlgRyucqYGsqHlF1t97ltZRueOme5dkw3gLOG9uRC3X72pvKQBvvRfisZ0Qe2Uqn+nVLRqKly9JKh2FAw5AwU2I2oIm+rk6g99WDPLrji+jdk0FyiCAKQe7zd9NHvtG2KzM987nj4wCWhvPISL8bi5feOo9NK30f8BMiqSVgPZdX9Gq1L6fNSVuk/dJVq9mgGviWze3xYph/WAwXswGSFpe3POBII/H/8RsiKXB+RYnn3DNsc/8dcSbgqs5BesoGwzL4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <60B6323400BC4546A44E1303162866B7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1832dc2e-0f23-44a8-a729-08d7734f6004
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2019 15:35:04.5633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nTTWMPtNibdEsqaBYvL7O6H07aIp45klVuR+9CZ9mXdqVPDBdko5n99wRMrMwoxITl7B1tAw4N4QNs8t55yeoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3087
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.25, xch-rcd-015.cisco.com
X-Outbound-Node: alln-core-3.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SEkgUGhpbCwNCg0KTm8sIEkgZG8gbm90LCBuZnRhYmxlc2xpYiB0YWxrcyBkaXJlY3RseSB0YWxr
IHRvIG5ldGxpbmsgY29ubmVjdGlvbi4NCg0KbmZ0YWJsZXNsaWIgb2ZmZXJzIGFuIEFQSSB3aGlj
aCBhbGxvd3MgY3JlYXRlIHRhYmxlcy9jaGFpbnMvcnVsZXMgYW5kIGV4cG9zZXMgYW4gaW50ZXJm
YWNlIHdoaWNoIGxvb2tzIHNpbWlsYXIgdG8gazhzIGNsaWVudC1nby4gIElmIHlvdSBjaGVjayBo
dHRwczovL2dpdGh1Yi5jb20vc2JlenZlcmsvbmZ0YWJsZXNsaWIvYmxvYi9tYXN0ZXIvY21kL2Uy
ZS9lMmUuZ28NCg0KSXQgd2lsbCBnaXZlIHlvdSBhIGdvb2QgaWRlYSBob3cgaXQgb3BlcmF0ZXMu
DQoNClRoZSByZWFzb24gZm9yIGdvaW5nIGluIHRoaXMgZGlyZWN0aW9uIGlzICBwZXJmb3JtYW5j
ZSwgZm9yIGEgcmVsYXRpdmVseSBzdGF0aWMgYXBwbGljYXRpb25zIGxpa2UgYSBmaXJld2FsbCwg
anNvbiBhcHByb2FjaCBpcyBncmVhdCwgYnV0IGZvciBhcHBsaWNhdGlvbnMgbGlrZSBhIGt1YmUt
cHJveHkgd2hlcmUgaHVuZHJlZHMgb3IgZXZlbiB0aG91c2FuZHMgb2Ygc2VydmljZS9lbmRwb2lu
dCBldmVudHMgaGFwcGVuLCBJIGRvIG5vdCBiZWxpZXZlIGpzb24gaXMgYSByaWdodCBhcHByb2Fj
aC4gV2hlbiBJIHRhbGtlZCB0byBhcGkgbWFjaGluZXJ5IGZvbGtzIEkgd2FzIGdpdmVuIDVrIGV2
ZW50cyBwZXIgc2Vjb25kIGFzIGEgdGFyZ2V0Lg0KDQpUaGFuayB5b3UNClNlcmd1ZWkNCg0K77u/
T24gMjAxOS0xMS0yNywgMTA6MDkgQU0sICJuMC0xQG9yYnl0ZS5ud2wuY2Mgb24gYmVoYWxmIG9m
IFBoaWwgU3V0dGVyIiA8bjAtMUBvcmJ5dGUubndsLmNjIG9uIGJlaGFsZiBvZiBwaGlsQG53bC5j
Yz4gd3JvdGU6DQoNCiAgICBIaSBTZXJndWVpLA0KICAgIA0KICAgIE9uIFdlZCwgTm92IDI3LCAy
MDE5IGF0IDAyOjM2OjA3UE0gKzAwMDAsIFNlcmd1ZWkgQmV6dmVya2hpIChzYmV6dmVyaykgd3Jv
dGU6DQogICAgPiBUaGFua3MgYSBsb3QgZm9yIHlvdXIgcmVwbHksIG15IHVsdGltYXRlIGdvYWwg
aXMgdG8gZGV2ZWxvcCBrdWJlLXByb3h5IHdoaWNoIGlzIGJ1aWxkaW5nICBuZnRhYmxlcyBydWxl
cyBpbnN0ZWFkIG9mIGlwdGFibGVzLCBpbiBhZGRpdGlvbiB0aGUgZ29hbCBpcyB0byB1c2UgZGly
ZWN0IEFQSSBjYWxscyB0byBuZXRsaW5rIHdpdGhvdXQgYW55IGV4dGVybmFsIGRlcGVuZGVuY2ll
cyBhbmQgb2YgY291cnNlIHRvIHRyeSB0byBsZXZlcmFnZSBuZnRhYmxlcycgYWR2YW5jZWQgZmVh
dHVyZXMgdG8gYWNoaWV2ZSB0aGUgYmVzdCBwZXJmb3JtYW5jZS4NCiAgICA+IA0KICAgID4gSSBh
bSBpbiB0aGUgcHJvY2VzcyBvZiBpZGVudGlmeWluZyBnYXBzIGluIGZ1bmN0aW9uYWxpdHkgYXZh
aWxhYmxlIGluIGdpdGh1Yi5jb20vZ29vZ2xlL25mdGFibGVzIGFuZCBnaXRodWIuY29tL3NiZXp2
ZXJrL25mdGFibGVzbGliIGxpYnJhcmllcywgZXhhbXBsZSB5ZXN0ZXJkYXkgSSBmb3VuZCBvdXQg
dGhhdCBuZWl0aGVyIG9mIHRoZXNlIGxpYnJhcmllcyBzdXBwb3J0cyAibnVtZ2VuIiwgd2hpY2gg
d291bGQgYmUgYSBtYW5kYXRvcnkgZmVhdHVyZSB0byBzdXBwb3J0IGxvYWQgYmFsYW5jaW5nIGJl
dHdlZW4gc2VydmljZSdzIG11bHRpcGxlIGVuZCBwb2ludHMuICBJIHdpbGwgaGF2ZSB0byBhZGQg
aXQgdG8gYm90aCB0byBiZSBhYmxlIHRvIG1vdmUgZm9yd2FyZC4NCiAgICA+IEkgdXNlIGlwdGFi
bGVzIGZyb20gYSB3b3JraW5nIGNsdXN0ZXIgYW5kIHRyeSB0byBidWlsZCBhIGNvZGUgd2hpY2gg
d291bGQgcHJvZ3JhbSBuZnRhYmxlcyB0aGUgc2FtZSB3YXkgKHdpdGggb3B0aW1pemF0aW9uKS4g
T25jZSBpdCBpcyBkb25lLCB0aGVuIGl0IGNhbiBiZSBhcnJhbmdlZCBpbnRvIGEgY29udHJvbGxl
ciBsaXN0ZW5pbmcgZm9yIHN2Yy9lbmRwb2ludHMgYW5kIHByb2dyYW0gIGludG8gbmZ0YWJsZXMg
YWNjb3JkaW5nbHkuDQogICAgPiANCiAgICA+IEkgYW0gbG9va2luZyBmb3IgcGVvcGxlIGludGVy
ZXN0ZWQgaW4gdGhlIHNhbWUgdG9waWMgdG8gYmUgYWJsZSB0byBkaXNjdXNzIGRpZmZlcmVudCBh
cHByb2FjaGVzLCBsaWtlIGl0IHdhcyBkb25lIHllc3RlcmRheSB3aXRoIFBoaWwgYW5kIHNlbGVj
dCB0aGUgYmVzdCBhcHByb2FjaCB0byBtYWtlIG5mdGFibGVzIHRvIHNoaW5lICgNCiAgICA+IA0K
ICAgID4gUGxlYXNlIGxldCBtZSBrbm93IGlmIHlvdSBhcmUgaW50ZXJlc3RlZCBpbiBmdXJ0aGVy
IGRpc2N1c3Npb25zLg0KICAgIA0KICAgIFllcywgd2UncmUgZGVmaW5pdGVseSBpbnRlcmVzdGVk
IGZ1cnRoZXIgZGlzY3Vzc2lvbi9jb29wZXJhdGlvbi4gWW91J3JlDQogICAgdXNpbmcgdGhlIEpT
T04gQVBJIGZvciBuZnRhYmxlc2xpYiwgcmlnaHQ/DQogICAgDQogICAgQ2hlZXJzLCBQaGlsDQog
ICAgDQoNCg==
