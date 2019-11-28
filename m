Return-Path: <SRS0=4QBM=ZU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDF2FC432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Nov 2019 13:34:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7414A21741
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Nov 2019 13:34:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="SvKxuFuu";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="K0JuzNMy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfK1NeF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Nov 2019 08:34:05 -0500
Received: from alln-iport-3.cisco.com ([173.37.142.90]:50539 "EHLO
        alln-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfK1NeE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Nov 2019 08:34:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=3724; q=dns/txt; s=iport;
  t=1574948043; x=1576157643;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kDYR1zty2ccZ1KoNS8Wp88VBYS2aNDHkzHnfMijeE/Y=;
  b=SvKxuFuuDvAxxzlbih0YG1GaDQrQOCoUzLtjQaaQm+DeJ5qEw8o559jT
   a7I/4nxPR/YxkxFcGEPU6Apj5EQGUdU/iLg9aHZHbT0MMjE80qrzyrIFx
   XtDiZ6fM8dWep8vwMlfLgznj185QTzfE1JXbaTYYaJwN0AhxvPkpanjym
   4=;
X-IPAS-Result: =?us-ascii?q?A0AeAAAxzN9d/5NdJa1lGQEBAQEBAQEBAQEBAQEBAQEBE?=
 =?us-ascii?q?QEBAQEBAQEBAQEBgW0BAQEBAQELAYFKKScFbFggBAsqCoQhg0YDimyCX5gEg?=
 =?us-ascii?q?lIDVAkBAQEMAQElCAIBAYRAAheBbSQ3Bg4CAwEBAQMCAwIBAQQBAQECAQUEb?=
 =?us-ascii?q?YU3DIVSAQEBAQIBEhERDAEBNwEPAgEIGAICJgICAjAVEAIEDgUigwABgkYDD?=
 =?us-ascii?q?iABAgynXQKBOIhgdYEygn4BAQWFIBiCFwMGgQ4oAYUahnsagUE/gTgggU5QL?=
 =?us-ascii?q?j6CZAKBYxeCeTKCLI1Xggo5nigKgi6HHoRyiUkbgkGHbYs3hD6XBpFbAgQCB?=
 =?us-ascii?q?AUCDgEBBYFoI4FYcBU7KgGCQVARFIpsgScBB4JEilN0gSiPRwGBDwEB?=
IronPort-PHdr: =?us-ascii?q?9a23=3AZ8x50xMjbejw+FPeSZEl6mtXPHoupqn0MwgJ65?=
 =?us-ascii?q?Eul7NJdOG58o//OFDEu6w/l0fHCIPc7f8My/HbtaztQyQh2d6AqzhDFf4ETB?=
 =?us-ascii?q?oZkYMTlg0kDtSCDBjgJvP4cSEgH+xJVURu+DewNk0GUMs=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.69,139,1571702400"; 
   d="scan'208";a="390778175"
Received: from rcdn-core-11.cisco.com ([173.37.93.147])
  by alln-iport-3.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 28 Nov 2019 13:34:03 +0000
Received: from XCH-RCD-006.cisco.com (xch-rcd-006.cisco.com [173.37.102.16])
        by rcdn-core-11.cisco.com (8.15.2/8.15.2) with ESMTPS id xASDY3bt011460
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 28 Nov 2019 13:34:03 GMT
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by XCH-RCD-006.cisco.com
 (173.37.102.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Nov
 2019 07:34:02 -0600
Received: from xhs-rcd-001.cisco.com (173.37.227.246) by xhs-rtp-002.cisco.com
 (64.101.210.229) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Nov
 2019 08:34:01 -0500
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-001.cisco.com (173.37.227.246) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 28 Nov 2019 07:34:01 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cp6BwbKY/hSSvD/LmsgnQTJGZvVtXkVZQL3xge/ZZtiPOLZ6txAPDARuhm8PLZW+fOWK0XV7pj/+myjmAz6Qq6/yvLEauRgp8OiNiKW+uvRA/NdqjXBuCXT0Q6faPjU4LMMhZzOZInEkBuf69h35fZ5yOePIdgqzTWWYA/a4n28upnphL87NUZaib4mkZ+RCTt1wWS60U+qvHZNXzqseU+V9avF6BCq/MOzseKV9Rm0Fjx6AWoxepXVdZt5SSvuLWABfgNLcD5h4BDwgdSGd5XLQWsFSBOqsmgAtl/VImK3n+7+xQc9MPJz12/xjDHs+fz6qhrC++Ag+GVxasbRjBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kDYR1zty2ccZ1KoNS8Wp88VBYS2aNDHkzHnfMijeE/Y=;
 b=gmz/AeRzZpDFF6kKwxzRIfb2G3N6TZUNrK48Vx6U5d4S2tWNwWTrFwNrjUNbAadQmUeANE3AaBGbq4HDd+6cJ3GiksFjyomC4dcJqQ4NqZuMsiCYkfPTg6fHOu8icdX7diRrno00i4So1UgW0pd3jvNoZdjTF7fVb+fLgVf8W/4Hpu8pL5wzIVDIu/ZFrXhiM3bp1wt9luUKtVY9O7JaYr5PCT4Ub5yNvi/qrCkbp2MgX0pPti5Sfsh8Gwd13a3clUEWgw+MsoHxacFJII4Dssui01zRkBytjWEH+448Peel65vuLoIwtcwQOQPnWY6+h1LKGZ6HxEev0xhISTc9BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kDYR1zty2ccZ1KoNS8Wp88VBYS2aNDHkzHnfMijeE/Y=;
 b=K0JuzNMy/T/iHtm/YMGZYxmPjbLBLQa8Jja+cEEz9HtPH44F8iWedSJn92vWvNJNl7vMqOU4MZRRGiCR7/2rfXwSbec9V+pzzvs33wrNJj46P/TpJdWoyUeWLy8beahE1U2NQ8pi8UZ2q4CVRB8RWxG9Kb2fXODLGfYitpwYl38=
Received: from SN6PR11MB3358.namprd11.prod.outlook.com (52.135.110.149) by
 SN6PR11MB3359.namprd11.prod.outlook.com (52.135.110.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.18; Thu, 28 Nov 2019 13:34:00 +0000
Received: from SN6PR11MB3358.namprd11.prod.outlook.com
 ([fe80::280e:21c6:3ef8:1a6d]) by SN6PR11MB3358.namprd11.prod.outlook.com
 ([fe80::280e:21c6:3ef8:1a6d%7]) with mapi id 15.20.2474.023; Thu, 28 Nov 2019
 13:34:00 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Phil Sutter <phil@nwl.cc>
CC:     Arturo Borrero Gonzalez <arturo@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "Laura Garcia" <nevola@gmail.com>
Subject: Re: Operation not supported when adding jump command
Thread-Topic: Operation not supported when adding jump command
Thread-Index: AQHVo8HvElEENwloc0uP91utUJLts6edYHQA///QMACAAGcLAP//rq8AgABU1YD//91EAAAL5rgA///LmgCAAStKAP//9huAgABc5QD//7OUAIAAXK0A//+4hIAAC5GiAAAGSjgAACMiCwAACZP8gA==
Date:   Thu, 28 Nov 2019 13:34:00 +0000
Message-ID: <3BBDEF3D-DFFF-4AFB-BA00-EA0771BE680E@cisco.com>
References: <20191126192752.GE8016@orbyte.nwl.cc>
 <AC4B6BFD-30FA-4A62-AD3C-3EB37029EC1B@cisco.com>
 <3a457e5b-be8f-e99d-fb0d-4826a15a4a55@netfilter.org>
 <89C24159-37F8-4D2F-B391-8A1D6AE403E7@cisco.com>
 <20191127150836.GJ8016@orbyte.nwl.cc>
 <3AE9B74A-37FB-4CDA-86FB-143F506D6C77@cisco.com>
 <20191127160646.GK8016@orbyte.nwl.cc>
 <7C2EF59A-57A3-4E55-92EB-7D64BC0A8417@cisco.com>
 <20191127172210.GM8016@orbyte.nwl.cc>
 <739A821F-2645-41B2-AADA-AA6C34A17335@cisco.com>
 <20191128130814.GQ8016@orbyte.nwl.cc>
In-Reply-To: <20191128130814.GQ8016@orbyte.nwl.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.77]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d5685ea4-985e-4a2d-890e-08d77407a09f
x-ms-traffictypediagnostic: SN6PR11MB3359:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <SN6PR11MB3359DEA550505B8D67B6BB7FC4470@SN6PR11MB3359.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0235CBE7D0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(366004)(39860400002)(136003)(346002)(199004)(189003)(186003)(8676002)(81166006)(66556008)(14454004)(26005)(81156014)(66476007)(966005)(91956017)(66946007)(76116006)(4326008)(316002)(6506007)(5660300002)(4001150100001)(102836004)(86362001)(478600001)(66066001)(2906002)(6246003)(6116002)(6306002)(3846002)(6916009)(6512007)(446003)(229853002)(8936002)(64756008)(66446008)(14444005)(25786009)(54906003)(58126008)(256004)(99286004)(33656002)(305945005)(71200400001)(6436002)(6486002)(36756003)(11346002)(7736002)(76176011)(71190400001)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB3359;H:SN6PR11MB3358.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Tv2CzD2K0stmwUs0tbjO+36nP6oAtDr6roqLw0hAVsiLGy3PxZSUEWMuNqvPHnejAeYVUUroNQ+4BKpZDulEbwk4egSq+75Hxa7DV5EDQ2SXsV2nAb+w9niWh7DRSPGlHzOOSRpGO4YgRhVRgL+hD6DPr7EAX8KAgR0+yWkUNSJB8UXyBMWjQIewUjmzKXm1I0ZV43urgU6vGX1qlLXgCfsQDkAPMoITEuR5dstev8yBYdCVOjSkwzbtxnIdONW36nSGJK920X3dAOuIw5bryoI7b6Wtyux0IWoV9oOImZ8JmA3ujdYZuPGqEjq/1ZxYf8qxSg4x1cXe132gPxQwT9kuYxqp+kJSynnIvzAo6g6QJR5lghO63kKkOQvUZncTAazn1GX2cU2452UzS4mR/A35CzJmxQOr6qrZub7yGJEYIwUajqFQGTG0lKFgt4yhibQTPyiaVG1gwYsttrmaRn4NEZRxiexIcEI2Qzk2rv8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <58367937F707034BBB462C144B54A190@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d5685ea4-985e-4a2d-890e-08d77407a09f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2019 13:34:00.2958
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HxE8wdu4mokz2TnpqxBqfyUwLDooRFLfHksSBc2yjOCsK4UIQe7ELCnhJuVr+ftl97+22SZI7AtSuy6i6SDKSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3359
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.16, xch-rcd-006.cisco.com
X-Outbound-Node: rcdn-core-11.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGVsbG8gUGhpbCwNCg0KVGhhbmtzIGEgbG90IGZvciB5b3VyIHN1Z2dlc3Rpb25zLCBJIHdpbGwg
cmVmYWN0b3IgdXNpbmcgYXBwcm9hY2guDQoNCkJlc3QgcmVnYXJkcw0KU2VyZ3VlaQ0KDQrvu79P
biAyMDE5LTExLTI4LCA4OjA4IEFNLCAibjAtMUBvcmJ5dGUubndsLmNjIG9uIGJlaGFsZiBvZiBQ
aGlsIFN1dHRlciIgPG4wLTFAb3JieXRlLm53bC5jYyBvbiBiZWhhbGYgb2YgcGhpbEBud2wuY2M+
IHdyb3RlOg0KDQogICAgSGkgU2VyZ3VlaSwNCiAgICANCiAgICBPbiBUaHUsIE5vdiAyOCwgMjAx
OSBhdCAwMToyMjoxN0FNICswMDAwLCBTZXJndWVpIEJlenZlcmtoaSAoc2JlenZlcmspIHdyb3Rl
Og0KICAgID4gUGxlYXNlIHNlZSBiZWxvdyB0aGUgbGlzdCBvZiBuZnRhYmxlcyBydWxlcyB0aGUg
Y29kZSBnZW5lcmF0ZSB0byBtaW1pYyBvbmx5IGZpbHRlciBjaGFpbiBwb3J0aW9uIG9mIGt1YmUg
cHJveHkuDQogICAgPiANCiAgICA+IEhlcmUgaXMgdGhlIGxvY2F0aW9uIG9mIGNvZGUgcHJvZ3Jh
bW1pbmcgdGhlc2UgcnVsZXMuIA0KICAgID4gaHR0cHM6Ly9naXRodWIuY29tL3NiZXp2ZXJrL25m
dGFibGVzbGliLXNhbXBsZXMvYmxvYi9tYXN0ZXIvcHJveHkvbWltaWMtZmlsdGVyL21pbWljLWZp
bHRlci5nbw0KICAgID4gDQogICAgPiBNb3N0IG9mIHJ1bGVzIGFyZSBzdGF0aWMsIHdpbGwgYmUg
cHJvZ3JhbWVkICBqdXN0IG9uY2Ugd2hlbiBwcm94eSBjb21lcyB1cCwgd2l0aCB0aGUgZXhjZXB0
aW9uIGlzIDIgcnVsZXMgaW4gazhzLWZpbHRlci1zZXJ2aWNlcyBjaGFpbi4gVGhlIHJlZmVyZW5j
ZSB0byB0aGUgbGlzdCBvZiBwb3J0cyBjYW4gY2hhbmdlLiBJZGVhbGx5IGl0IHdvdWxkIGJlIGdy
ZWF0IHRvIGV4cHJlc3MgdGhlc2UgdHdvIHJ1bGVzIHdpdGggYSBzaW5nbGUgcnVsZSBhbmQgYSB2
bWFwLCB3aGVyZSB0aGUga2V5IG11c3QgYmUgc2VydmljZSdzIGlwIEFORCBzZXJ2aWNlIHBvcnQs
IGFzIGl0IGlzIHBvc3NpYmxlIHRvIGhhdmUgYSBzaW5nbGUgc2VydmljZSBJUCB0aGF0IGNhbiBi
ZSBhc3NvY2lhdGVkIHdpdGggc2V2ZXJhbCBwb3J0cyBhbmQgc29tZSBvZiB0aGVzZSBwb3J0cyBt
aWdodCBoYXZlIGFuIGVuZHBvaW50IGFuZCBzb21lIGRvIG5vdC4gU28gZmFyIEkgY291bGQgbm90
IGZpZ3VyZSBpdCBvdXQuIEFwcHJlY2lhdGUgeW91ciB0aG91Z2h0L3N1Z2dlc3Rpb25zL2NyaXRp
Y3MuIElmIHlvdSBjb3VsZCBmaWxlIGFuIGlzc3VlIGZvciBhbnl0aGluZyB5b3UgZmVlbCBuZWVk
cyB0byBiZSBkaXNjdXNzZWQsIHRoYXQgd291bGQgYmUgZ3JlYXQuDQogICAgDQogICAgV2hhdCBh
Ym91dCBzb21ldGhpbmcgbGlrZSB0aGlzOg0KICAgIA0KICAgIHwgdGFibGUgaXAgdCB7DQogICAg
fCAJbWFwIG0gew0KICAgIHwgCQl0eXBlIGlwdjRfYWRkciAuIGluZXRfc2VydmljZSA6IHZlcmRp
Y3QNCiAgICB8IAkJZWxlbWVudHMgPSB7IDE5Mi4xNjguODAuMTA0IC4gODk4OSA6IGdvdG8gZG9f
cmVqZWN0IH0NCiAgICB8IAl9DQogICAgfCANCiAgICB8IAljaGFpbiBjIHsNCiAgICB8IAkJaXAg
ZGFkZHIgLiB0Y3AgZHBvcnQgdm1hcCBAbQ0KICAgIHwgCX0NCiAgICB8IA0KICAgIHwgCWNoYWlu
IGRvX3JlamVjdCB7DQogICAgfCAJCXJlamVjdCB3aXRoIGljbXAgdHlwZSBob3N0LXVucmVhY2hh
YmxlDQogICAgfCAJfQ0KICAgIHwgfQ0KICAgIA0KICAgIEZvciB1bmtub3duIHJlYXNvbnMgcmVq
ZWN0IHN0YXRlbWVudCBjYW4ndCBiZSB1c2VkIGRpcmVjdGx5IGluIGEgdmVyZGljdA0KICAgIG1h
cCwgYnV0IHRoZSBkb19yZWplY3QgY2hhaW4gaGFjayB3b3Jrcy4NCg0KVGhpcyBpcyBleGFjdGx5
IHdoYXQgSSB3YXMgbG9va2luZyBmb3IsIGl0IGlzIGp1c3QgSSBuZXZlciBrbmV3IHlvdSBjb3Vs
ZCBjb21iaW5lIGFkZHJlc3MgYW5kIHBvcnQgaW4gdGhlIGtleS4uDQogICAgDQogICAgPiBzdWRv
IG5mdCBsaXN0IHRhYmxlIGlwdjR0YWJsZQ0KICAgID4gdGFibGUgaXAgaXB2NHRhYmxlIHsNCiAg
ICA+IAlzZXQgc3ZjMS1uby1lbmRwb2ludHMgew0KICAgID4gCQl0eXBlIGluZXRfc2VydmljZQ0K
ICAgID4gCQllbGVtZW50cyA9IHsgODk4OSB9DQogICAgPiAJfQ0KICAgID4gDQogICAgPiAJY2hh
aW4gZmlsdGVyLWlucHV0IHsNCiAgICA+IAkJdHlwZSBmaWx0ZXIgaG9vayBpbnB1dCBwcmlvcml0
eSBmaWx0ZXI7IHBvbGljeSBhY2NlcHQ7DQogICAgPiAJCWN0IHN0YXRlIG5ldyBqdW1wIGs4cy1m
aWx0ZXItc2VydmljZXMNCiAgICA+IAkJanVtcCBrOHMtZmlsdGVyLWZpcmV3YWxsDQogICAgPiAJ
fQ0KICAgID4gDQogICAgPiAJY2hhaW4gZmlsdGVyLW91dHB1dCB7DQogICAgPiAJCXR5cGUgZmls
dGVyIGhvb2sgb3V0cHV0IHByaW9yaXR5IGZpbHRlcjsgcG9saWN5IGFjY2VwdDsNCiAgICA+IAkJ
Y3Qgc3RhdGUgbmV3IGp1bXAgazhzLWZpbHRlci1zZXJ2aWNlcw0KICAgID4gCQlqdW1wIGs4cy1m
aWx0ZXItZmlyZXdhbGwNCiAgICA+IAl9DQogICAgDQogICAgU2FtZSBydWxlc2V0IGZvciBpbnB1
dCBhbmQgb3V0cHV0PyBTZWVtcyB3ZWlyZCBnaXZlbiB0aGUgZGFkZHItYmFzZWQNCiAgICBmaWx0
ZXJpbmcgaW4gazhzLWZpbHRlci1zZXJ2aWNlcy4NCiAgICANCkkgd2lsbCByZXZpZXcgb25lIG1v
cmUgdGltZSBrOHMgZmlsdGVyIGlucHV0L291dHB1dCB0byBjb25maXJtIGlmIEkgZ290IHNvbWV0
aGluZyB3cm9uZy4NCg0KICAgIENoZWVycywgUGhpbA0KICAgIA0KDQo=
