Return-Path: <SRS0=sEEs=Z2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF5EC43603
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 16:13:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B35AE2077B
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 16:13:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="fA1D91Uz";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="k3vXpBAH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbfLDQNu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 11:13:50 -0500
Received: from alln-iport-4.cisco.com ([173.37.142.91]:38828 "EHLO
        alln-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727912AbfLDQNu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 11:13:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=3404; q=dns/txt; s=iport;
  t=1575476028; x=1576685628;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=T4tWATdkTNhOz747bwhQrD6clqOprMGypddacDaomDk=;
  b=fA1D91UzTWYa2Z6AS3xCepyjKqao2rVPTCtjK9Nwr1e2v3YxgR5lcZ/f
   4YufDLOoudyqHm303RzRrNFA1DZGHOWjRsmW6lV6L8xmMn1sI6NyNUp6M
   iS7dXAgPUXQaQfzA+RfGRwhDkzRWJGlPyuEbaRuxQTSZci8miygo03SWC
   c=;
IronPort-PHdr: =?us-ascii?q?9a23=3ADl50HxPgqWM7A+38LGsl6mtXPHoupqn0MwgJ65?=
 =?us-ascii?q?Eul7NJdOG58o//OFDEu6w/l0fHCIPc7f8My/HbtaztQyQh2d6AqzhDFf4ETB?=
 =?us-ascii?q?oZkYMTlg0kDtSCDBjgJvP4cSEgH+xJVURu+DewNk0GUMs=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0CRBQBv2udd/4UNJK1iAxwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYF+gUtQBYFEIAQLKgqEIYNGA4p5gl+YBIJSA1QJAQEBDAEBLQI?=
 =?us-ascii?q?BAYRAAheBeSQ4EwIDDQEBBAEBAQIBBQRthTcMhVMBAQEDDgQREQwBASMUAQ8?=
 =?us-ascii?q?CAQgYAgImAgICMBUQAgQOBSKDAIJHAy4BpXcCgTiIYHWBMoJ+AQEFgkqCPRi?=
 =?us-ascii?q?CFwmBDiiMFxqBQT+BEScggkw+hGAKJoJJMoIskCGeLQqCLpVaG5omqG0CBAI?=
 =?us-ascii?q?EBQIOAQEFgWkigVhwFWUBgkFQERSMZoNzilN0gSiPMAGBDwEB?=
X-IronPort-AV: E=Sophos;i="5.69,277,1571702400"; 
   d="scan'208";a="377044888"
Received: from alln-core-11.cisco.com ([173.36.13.133])
  by alln-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 04 Dec 2019 16:13:47 +0000
Received: from XCH-ALN-014.cisco.com (xch-aln-014.cisco.com [173.36.7.24])
        by alln-core-11.cisco.com (8.15.2/8.15.2) with ESMTPS id xB4GDlk6019700
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 4 Dec 2019 16:13:47 GMT
Received: from xhs-rcd-002.cisco.com (173.37.227.247) by XCH-ALN-014.cisco.com
 (173.36.7.24) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 4 Dec
 2019 10:13:46 -0600
Received: from xhs-rcd-003.cisco.com (173.37.227.248) by xhs-rcd-002.cisco.com
 (173.37.227.247) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 4 Dec
 2019 10:13:46 -0600
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-003.cisco.com (173.37.227.248) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 4 Dec 2019 10:13:46 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a+YrBfhdV65UypWiZY7bk9BB6zw9RbQcZouP3LT7OMjCWVBBuF2O8bUMXI8t3TGngmSWzosjIdkFijNz4I7n5GDSWs+5E07TpgmUPIqcreJfwzTgqyhMZD+TwjqCRkBBPHYQJrCO1z4dnWIGcbZPtfg0NDA0Nc1PW3uhP5K4xV6jK515BS75MITgauSyO1yaI3ZuL5eDTmqP3u/jKH7pN3aCtHw7wszEet6L5g9gWaPRzXhrqUqyIGpNykZodXvhxPRlHkXanVjaAyQAQ18FR3HrtVZ5zWEv+eVkjK6tYoXl/oB+CHaJH1jq+GpJqNkC2fdWw2VdND3+Oddq1+QtZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T4tWATdkTNhOz747bwhQrD6clqOprMGypddacDaomDk=;
 b=jBweRHcLVWuphKm4qSnheuWxNa8cO2RiRRR9WeQgUmBfpDbchOSkffy84l4X1akmndGfhchBZGoCOEb0vJGraVDY3gP+kdFpPslsu+Akgbr3RCzV57ZsXSV8mnedlMGw7Gda4E0H6EcGD24Fo7MAKZ9CZwXmn18vFR/065rQbBLb5sH243bAxe++RcujcajOiHuGhIEnamspWNXfc0NM/SHGxJMWQZLgXB32rsEj5+aWv87tV4wM7HyGhKVwXWqcuL9zxI3HJEyAuslZiggPK6orfeGe6ONQwFhvgrMFuy12Ht3zXsfxRdanOe09FAFgASN7JGz9dFemOjW6KWHDzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T4tWATdkTNhOz747bwhQrD6clqOprMGypddacDaomDk=;
 b=k3vXpBAHrQbmtwC7kiaUkKU76PCnuAnZ6eNjTs9i4fk6oBcjWs9maoqlBFKgzouG0Vetjvj4mIwPNf8wPaK9Kpru5PjVOwM7iT/c3r5S7mNrFKbROvLtczMamBZWMQgC3surTOsxcYW1YYPVU3BwibKpLjLUMFWITzQbbMHE9Xc=
Received: from DM5PR11MB1484.namprd11.prod.outlook.com (10.172.36.14) by
 DM5PR11MB0041.namprd11.prod.outlook.com (10.164.143.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.21; Wed, 4 Dec 2019 16:13:45 +0000
Received: from DM5PR11MB1484.namprd11.prod.outlook.com
 ([fe80::b8d0:b659:6b84:fa7a]) by DM5PR11MB1484.namprd11.prod.outlook.com
 ([fe80::b8d0:b659:6b84:fa7a%10]) with mapi id 15.20.2516.003; Wed, 4 Dec 2019
 16:13:45 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Phil Sutter <phil@nwl.cc>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Numen with reference to vmap
Thread-Topic: Numen with reference to vmap
Thread-Index: AQHVqj1Ubs5ZA1L3AEmU3M7cfc9ezqepw9GA///mtACAAGztAP//svyAgABX04D//7ENgA==
Date:   Wed, 4 Dec 2019 16:13:45 +0000
Message-ID: <BC928D69-611E-4F9E-A457-7C78F6D0779A@cisco.com>
References: <EC8889A1-27E2-4DC9-B752-514689982085@cisco.com>
 <20191204101819.GN8016@orbyte.nwl.cc>
 <AFC93A41-C4DD-4336-9A62-6B9C6817D198@cisco.com>
 <20191204151738.GR14469@orbyte.nwl.cc>
 <5337E60B-E81D-46ED-912F-196E23C76701@cisco.com>
 <20191204155619.GU14469@orbyte.nwl.cc>
In-Reply-To: <20191204155619.GU14469@orbyte.nwl.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.86]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 07a561a9-8ea5-447e-d918-08d778d4f04a
x-ms-traffictypediagnostic: DM5PR11MB0041:
x-microsoft-antispam-prvs: <DM5PR11MB00413869C974C4980544813BC45D0@DM5PR11MB0041.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 0241D5F98C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(199004)(189003)(25786009)(66476007)(99286004)(2906002)(8676002)(58126008)(8936002)(26005)(81156014)(7736002)(6486002)(305945005)(316002)(6916009)(5660300002)(6436002)(71200400001)(71190400001)(36756003)(76176011)(102836004)(6116002)(229853002)(81166006)(6506007)(478600001)(4326008)(66556008)(66946007)(6512007)(86362001)(14444005)(186003)(64756008)(3846002)(33656002)(6246003)(76116006)(11346002)(66446008)(91956017)(2616005)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB0041;H:DM5PR11MB1484.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sTIAVvZXZYmSaFul2bV5v2MU7ne8h/lTqkXGRgWfUKZBGgYql1ASOxSR75Mx/bnRx+hJkKbC+i7o/89g14pTBRSSvVUJgEOrwmCtz7XJ1bxoaQJBDp4TWtZwf+PzbPKHWnUObcXJRKV68bfoSS5d5EelB+WjCySWqj061SFSoCOz98lATLf0NctV5JjJNKNRi+SGkmTYu1Z9ZLfb5ym8c74RSKVo8Eocnn+YzG4GKl21XKzRILvx+w7azK2T5w7ldjytmNrdTnrp+sOzlAwr6E3HbVCPzO0ZcXu4PkxD71eku0Jd23xLxvO0G0VcReaN/LBlfgVTejQs0VShAdG1/G3bZhevDcQdp63OrJTXrHW4pUFEZzug0Fis8mBXzSF9TRBCKvmADGBLELBR9OJqJZTcUnbRbh5A4p3aG9AQYBNCFhXAbn1My9O0jFWHDJDH
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <96A0C1EA9EBFC541AF8819ECBDD7CF52@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 07a561a9-8ea5-447e-d918-08d778d4f04a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2019 16:13:45.4232
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z7ze0OdJr0rUCYas7c4/RAx3DUG0dnoYyE7JsZFhy3RMn59SrFi+CXuo4SmDzmWdaAk9n4ffqKZsVB4UthskCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB0041
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.24, xch-aln-014.cisco.com
X-Outbound-Node: alln-core-11.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SXQgaXMgbm90IHN0YXRpYywgU1ZDIGNoYWluIGp1bXAgcnVsZXMgd2lsbCBiZSB1cGRhdGVkIG9u
IGV2ZXJ5IGVuZHBvaW50IGNoYW5nZSwgIHRoZSBkeW5hbWljIG5hdHVyZSBpcyAgYWNoaWV2ZWQg
YnkgbWFuaXB1bGF0aW5nIHJ1bGVzLiBJdCBpcyBkb2FibGUgd2l0aCBuZnRhYmxlcywgSSB1bmRl
cnN0YW5kIHRoYXQsIGJ1dCBJIHdhcyBhbHNvIGxvb2tpbmcgZm9yIGEgbW9yZSBlZmZpY2llbnQg
d2F5IHRvIGRvIGl0LCBteSBjb25jZXJuIGlzIGlmIHdlIHVzZSAxIHRvIDEgY29udmVyc2lvbiwg
d2Ugd2lsbCBlbmQgdXAgd2l0aCB0aGUgc2FtZSBpcHRhYmxlcyBzY2FsYWJpbGl0eS9wZXJmb3Jt
YW5jZSAgbGltaXRhdGlvbnMuDQoNCkhlcmUgaXMgaG93IHJ1bGVzIGxvb2sgYWZ0ZXIgYSB0aGly
ZCBhbmQgZm9ydGggZW5kcG9pbnQgZ2V0cyBkeW5hbWljYWxseSBhZGRlZCB0byB0aGUgc2Vydmlj
ZS4NCg0KLUEgS1VCRS1TVkMtNTdYVk9DRk5UTFRSM1EyNyAtbSBzdGF0aXN0aWMgLS1tb2RlIHJh
bmRvbSAtLXByb2JhYmlsaXR5IDAuMjUwMDAwMDAwMDAgLWogS1VCRS1TRVAtRlMzRlVVTEdaUFZE
NFZZQg0KLUEgS1VCRS1TVkMtNTdYVk9DRk5UTFRSM1EyNyAtbSBzdGF0aXN0aWMgLS1tb2RlIHJh
bmRvbSAtLXByb2JhYmlsaXR5IDAuMzMzMzI5OTk5ODIgLWogS1VCRS1TRVAtTU1GWlJPUVNMUTNE
S09RQQ0KLUEgS1VCRS1TVkMtNTdYVk9DRk5UTFRSM1EyNyAtbSBzdGF0aXN0aWMgLS1tb2RlIHJh
bmRvbSAtLXByb2JhYmlsaXR5IDAuNTAwMDAwMDAwMDAgLWogS1VCRS1TRVAtVEVXUlRBR1QzQ0Qz
RDQ3Wg0KLUEgS1VCRS1TVkMtNTdYVk9DRk5UTFRSM1EyNyAtaiBLVUJFLVNFUC00V01XRDczNFdK
UVcyNjRVDQogDQpUaGFuayB5b3UNClNlcmd1ZWkNCg0K77u/T24gMjAxOS0xMi0wNCwgMTA6NTYg
QU0sICJuMC0xQG9yYnl0ZS5ud2wuY2Mgb24gYmVoYWxmIG9mIFBoaWwgU3V0dGVyIiA8bjAtMUBv
cmJ5dGUubndsLmNjIG9uIGJlaGFsZiBvZiBwaGlsQG53bC5jYz4gd3JvdGU6DQoNCiAgICBPbiBX
ZWQsIERlYyAwNCwgMjAxOSBhdCAwMzo0MjowMFBNICswMDAwLCBTZXJndWVpIEJlenZlcmtoaSAo
c2JlenZlcmspIHdyb3RlOg0KICAgID4gSGkgUGhpbCwNCiAgICA+IA0KICAgID4gSSBjYW4gYWxz
byBtaW5pbWl6ZSBhbnkgaW1wYWN0IGJ5IGluc2VydGluZyBhIG5ldyBydWxlIGluIGZyb250IG9m
IHRoZSBvbGQgb25lLCBhbmQgdGhlbiBkZWxldGUgdGhlIG9sZCBvbmUuIFNvIGluIHRoaXMgY2Fz
ZSB0aGVyZSBzaG91bGQgbm8gYW55IGltcGFjdC4gSGVyZSBpcyBpcHRhYmxlcyBydWxlcyBJIHRy
eSB0byBtaW1pYzoNCiAgICANCiAgICBZZXMsIHRoYXQncyBtb3JlIG9yIGxlc3MgZXF1aXZhbGVu
dCB0byBkb2luZyBpdCBpbiBhIHNpbmdsZSB0cmFuc2FjdGlvbi4NCiAgICANCiAgICA+IC8vIC1B
IEtVQkUtU1ZDLTU3WFZPQ0ZOVExUUjNRMjcgLW0gc3RhdGlzdGljIC0tbW9kZSByYW5kb20gLS1w
cm9iYWJpbGl0eSAwLjUwMDAwMDAwMDAwIC1qIEtVQkUtU0VQLUZTM0ZVVUxHWlBWRDRWWUINCiAg
ICA+IC8vIC1BIEtVQkUtU1ZDLTU3WFZPQ0ZOVExUUjNRMjcgLWogS1VCRS1TRVAtTU1GWlJPUVNM
UTNES09RQQ0KICAgID4gLy8gIQ0KICAgID4gLy8gISBFbmRwb2ludCAxIGZvciBLVUJFLVNWQy01
N1hWT0NGTlRMVFIzUTI3DQogICAgPiAvLyAhDQogICAgPiAvLyAtQSBLVUJFLVNFUC1GUzNGVVVM
R1pQVkQ0VllCIC1zIDU3LjExMi4wLjI0Ny8zMiAtaiBLVUJFLU1BUkstTUFTUQ0KICAgID4gLy8g
LUEgS1VCRS1TRVAtRlMzRlVVTEdaUFZENFZZQiAtcCB0Y3AgLW0gdGNwIC1qIEROQVQgLS10by1k
ZXN0aW5hdGlvbiA1Ny4xMTIuMC4yNDc6ODA4MA0KICAgID4gLy8gIQ0KICAgID4gLy8gISBFbmRw
b2ludCAyIGZvciBLVUJFLVNWQy01N1hWT0NGTlRMVFIzUTI3DQogICAgPiAvLyAhDQogICAgPiAv
LyAtQSBLVUJFLVNFUC1NTUZaUk9RU0xRM0RLT1FBIC1zIDU3LjExMi4wLjI0OC8zMiAtaiBLVUJF
LU1BUkstTUFTUQ0KICAgID4gLy8gLUEgS1VCRS1TRVAtTU1GWlJPUVNMUTNES09RQSAtcCB0Y3Ag
LW0gdGNwIC1qIEROQVQgLS10by1kZXN0aW5hdGlvbiA1Ny4xMTIuMC4yNDg6ODA4MA0KICAgID4g
DQogICAgPiBBcyB5b3UgY2FuIHNlZSBTVkMgY2hhaW4gS1VCRS1TVkMtNTdYVk9DRk5UTFRSM1Ey
NyBsb2FkIGJhbGFuY2UgYmV0d2VlbiAyIGVuZHBvaW50cy4NCiAgICANCiAgICBPSywgc3RhdGlj
IGxvYWQtYmFsYW5jaW5nIGJldHdlZW4gdHdvIHNlcnZpY2VzIC0gbm8gYmlnIGRlYWwuIDopDQog
ICAgDQogICAgV2hhdCBoYXBwZW5zIGlmIGNvbmZpZyBjaGFuZ2VzPyBJLmUuLCBpZiBvbmUgb2Yg
dGhlIGVuZHBvaW50cyBnb2VzIGRvd24NCiAgICBvciBhIHRoaXJkIG9uZSBpcyBhZGRlZD8gKFRo
YXQncyB0aGUgdGhpbmcgd2UncmUgZGlzY3Vzc2luZyByaWdodCBub3csDQogICAgYXJlbid0IHdl
PykNCiAgICANCiAgICBDaGVlcnMsIFBoaWwNCiAgICANCg0K
