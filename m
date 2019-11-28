Return-Path: <SRS0=4QBM=ZU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 732C9C432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Nov 2019 14:51:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29A432084D
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Nov 2019 14:51:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="JvLwdA+k";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="DZGVQ9XF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbfK1Ovl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Nov 2019 09:51:41 -0500
Received: from rcdn-iport-7.cisco.com ([173.37.86.78]:61802 "EHLO
        rcdn-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbfK1Ovl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Nov 2019 09:51:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=6060; q=dns/txt; s=iport;
  t=1574952700; x=1576162300;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=iNPUuNVI0nSW1gcuGX5NhnnSgkPnjQ/GmVkIsS7OTpk=;
  b=JvLwdA+kcC76bxLevCQL4Cev3l09sx3aQarYOLNa3f1X4e07xozcJTrI
   0WUh8VDF80HZoYf96hHM4y9eWEEhaFRnHqFwF0nzlbomSn/L3ARljl8ol
   kWs/cjuwSVGGo7vCMqo7fVV7wz9VkLfjS+LsPtDOj3Tq7OXmFkZ/A6gBj
   0=;
IronPort-PHdr: =?us-ascii?q?9a23=3ADpZpJBY7uOCpStbxdWywuoP/LSx94ef9IxIV55?=
 =?us-ascii?q?w7irlHbqWk+dH4MVfC4el20gabRp3VvvRDjeee87vtX2AN+96giDgDa9QNMn?=
 =?us-ascii?q?1NksAKh0olCc+BB1f8KavxZSEoAslYV3du/mqwNg5eH8OtL1A=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AeAABs3t9d/51dJa1lGQEBAQEBAQE?=
 =?us-ascii?q?BAQEBAQEBAQEBEQEBAQEBAQEBAQEBgW0BAQEBAQELAYFKKScFbFggBAsqCoQ?=
 =?us-ascii?q?hg0YDimyCX5gEglIDVAkBAQEMAQElCAIBAYErAYMUAheBbyQ3Bg4CAw0BAQQ?=
 =?us-ascii?q?BAQECAQUEbYU3DIVSAQEBAQIBEhERDAEBNwEPAgEIGAICJgICAjAVEAIEDgU?=
 =?us-ascii?q?igwABgkYDDiABAgyoAAKBOIhgdYEygn4BAQWFHRiCFwMGgQ4oAYwVGoFBP4E?=
 =?us-ascii?q?4IIIeLj6CZAKBeoJ5MoIsjS8oggo5nigKgi6HHo47G4JBh22DKogNhD6XBo5?=
 =?us-ascii?q?+gl0CBAIEBQIOAQEFgWgjgVhwFTsqAYJBUBEUimyBJwEHAQGCQopTdIEoj0c?=
 =?us-ascii?q?BgQ8BAQ?=
X-IronPort-AV: E=Sophos;i="5.69,253,1571702400"; 
   d="scan'208";a="666890745"
Received: from rcdn-core-6.cisco.com ([173.37.93.157])
  by rcdn-iport-7.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 28 Nov 2019 14:51:39 +0000
Received: from XCH-RCD-006.cisco.com (xch-rcd-006.cisco.com [173.37.102.16])
        by rcdn-core-6.cisco.com (8.15.2/8.15.2) with ESMTPS id xASEpdSF029379
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 28 Nov 2019 14:51:39 GMT
Received: from xhs-aln-001.cisco.com (173.37.135.118) by XCH-RCD-006.cisco.com
 (173.37.102.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Nov
 2019 08:51:38 -0600
Received: from xhs-aln-003.cisco.com (173.37.135.120) by xhs-aln-001.cisco.com
 (173.37.135.118) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Nov
 2019 08:51:38 -0600
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-003.cisco.com (173.37.135.120) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 28 Nov 2019 08:51:37 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OCbgpBwGTStu4EM7Gp5qu487ljNqLUPVdE+FVNwbcCo9Kn+gXgosHtqbakB17C5/n97TzkTpiQQxnxnc1+4KseFuhrGyFc2dHJSRiJaALHs0x3NzgZiBKJk9C6sInxwziuFWQpXa4QQb+ipM4sIBRrXYrj0vb69b2eGcxI9SF8kwDqwlupiKWEz1zsR9hko4G+z9IFf32vq9mx40yykLzkfbwuivpzPa3LmnNlWnQuJNRM4nUzrmbc+PHtEXzFVeFK2hGn+usrEMS6c3w3MgurziaSb8pljCCN+7R9nZdvgmPh9q1vbMqWDvu6cfQiynvDQUgDhRF29X+SodWgZY3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iNPUuNVI0nSW1gcuGX5NhnnSgkPnjQ/GmVkIsS7OTpk=;
 b=mZSvA4lyZ7KSSsdN0cMWzLoYOOPil5LkHWhxVSSrZ04IYKzYHKL6k+uGbHI+QWbNoSYIWX2NOrdQ4VWdGhEIotWIohLtWEnGLeLMLKtHuE6mnkUI+b67DIIXm0rGkUvIzm0RGJQJnzlydwVuArOs984A/fhLvlaafboVFv0CUkMfw0ZawCSpSAgr4bCGVQOxGZwVkQAywzDWXGPZ58du1gpGdZ20sr35eieUFle5ounCGR26qDGguUkvpO7kqxs5zNcnMSwZmuvzZAfQsOZ9ln+k33gBmVMZP3s43cF30VWX5qveCPmmWRPG0UOQDf1zO9H/snEmsQSTvNADqbL1Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iNPUuNVI0nSW1gcuGX5NhnnSgkPnjQ/GmVkIsS7OTpk=;
 b=DZGVQ9XFU/7CrKAd54CoMX8dotPXs5bEeOR13UDdpmCe2sXhvVD+54rDMGgpngQnihgpHYQl3V7OA7at3SV02r5Tanyery7pBaZ7DQO7qp131UrmI40BeVJg8xw6RwwwhXB5IkIvVsWC/QzT9WFrj2zLN3WUNRdPrf8SobSZ0/U=
Received: from SN6PR11MB3358.namprd11.prod.outlook.com (52.135.110.149) by
 SN6PR11MB2781.namprd11.prod.outlook.com (52.135.96.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.17; Thu, 28 Nov 2019 14:51:36 +0000
Received: from SN6PR11MB3358.namprd11.prod.outlook.com
 ([fe80::280e:21c6:3ef8:1a6d]) by SN6PR11MB3358.namprd11.prod.outlook.com
 ([fe80::280e:21c6:3ef8:1a6d%7]) with mapi id 15.20.2474.023; Thu, 28 Nov 2019
 14:51:36 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Phil Sutter <phil@nwl.cc>
CC:     Arturo Borrero Gonzalez <arturo@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "Laura Garcia" <nevola@gmail.com>
Subject: Re: Operation not supported when adding jump command
Thread-Topic: Operation not supported when adding jump command
Thread-Index: AQHVo8HvElEENwloc0uP91utUJLts6edYHQA///QMACAAGcLAP//rq8AgABU1YD//91EAAAL5rgA///LmgCAAStKAP//9huAgABc5QD//7OUAIAAXK0A//+4hIAAC5GiAAAGSjgAACMiCwAABt4vgA==
Date:   Thu, 28 Nov 2019 14:51:36 +0000
Message-ID: <00B4F260-EA79-4EC1-B7B4-8A9C9D2C96DE@cisco.com>
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
x-ms-office365-filtering-correlation-id: aa1bb195-45c0-40ae-539c-08d7741277bf
x-ms-traffictypediagnostic: SN6PR11MB2781:
x-microsoft-antispam-prvs: <SN6PR11MB2781F84FE3CA68ED9C804F77C4470@SN6PR11MB2781.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 0235CBE7D0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(396003)(136003)(346002)(376002)(199004)(189003)(64756008)(76116006)(11346002)(8936002)(2616005)(76176011)(186003)(6246003)(6506007)(7736002)(26005)(229853002)(446003)(102836004)(6486002)(33656002)(81156014)(4326008)(8676002)(25786009)(81166006)(6512007)(6436002)(966005)(4001150100001)(66066001)(86362001)(256004)(478600001)(14454004)(305945005)(91956017)(6916009)(66446008)(66556008)(66476007)(5660300002)(54906003)(58126008)(66946007)(6306002)(36756003)(3846002)(6116002)(99286004)(2906002)(316002)(71200400001)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB2781;H:SN6PR11MB3358.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: poVjplUTzvtarE44rwvIPbK127YWzjDn0tBliRlQsVxds8QyiYzoFiXmy3SwG62tdHolQEwN4z85edOEWmFr2c/Uev/EgmFRWe9vsq85aycskAMxXiRTps0mA0CDPPPwVot5221DKImyT7IMuXArjCq9p+LWiJLV+kgQNoYh6WQ4yjkuLRD5RhgvuFGTZiZ1JGU+KGOMpWZhIUCG3euVIwT1v4Sg+Zrd/HBUtTpJ5lKcmS1JZuSZCCCMmip6dhf0h1yoIAr+ropVxGMbX8DDKs2lwxi7ig4GWUzBeRoSZbxmEND6Ic4S3FdqVo2hftgsasoekooqoWhyK+Mb0OUysSsuXcGPkbXwPgaKJi7pXjipcS0FBnH3OVDdF7yv64NA+7SMS2mZQ9v4unUwH5HgA9CLYWkqQLhZtoOkGGGdszlsKdRFCUuECGZktiaOIzf3DqQtVg2IsZ/+NfyMLK+AdjEuzpWMiBlFVX4pW3mp0qo=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <1210F3BE3B416947B5867F6EC6A883B1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: aa1bb195-45c0-40ae-539c-08d7741277bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2019 14:51:36.2236
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sIOJRwwgl8TrSPoXY7e+7/B237LRlI4y2JySAfn7vzPbMS0qX/KLZB/38Sq/mO6bOGCSk2ThrXrrW687qwOnfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2781
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.16, xch-rcd-006.cisco.com
X-Outbound-Node: rcdn-core-6.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGkgUGhpbCwNCg0KUXVpY2sgcXVlc3Rpb24sIGl0IGFwcGVhcnMgdGhhdCB3ZSBkbyBub3Qgc3Vw
cG9ydCB5ZXQgY29tYmluaW5nIG9mIHR3byB0eXBlcyBpbnRvIGEga2V5LCBzbyBJIG5lZWQgdG8g
cXVpY2tseSBhZGQgaXQsIHlvdXIgaGVscCB3b3VsZCBiZSBhcHByZWNpYXRlZC4gSGVyZSBpcyB0
aGUgc2VxdWVuY2UgSSBnZXQgdG8gY3JlYXRlIHN1Y2ggbWFwOg0Kc3VkbyBuZnQgLS1kZWJ1ZyBh
bGwgYWRkIG1hcCBpcHY0dGFibGUgbm8tZW5kcG9pbnQtc2VydmljZXMgICB7IHR5cGUgIGlwdjRf
YWRkciAuIGluZXRfc2VydmljZSA6IHZlcmRpY3QgXDsgfQ0KDQotLS0tLS0tLS0tLS0tLS0tCS0t
LS0tLS0tLS0tLS0tLS0tLQ0KfCAwMiAwMCAwMCAwMCAgfAl8ICBleHRyYSBoZWFkZXIgIHwNCnww
MDAxNHwtLXwwMDAwMXwJfGxlbiB8ZmxhZ3N8IHR5cGV8DQp8IDY5IDcwIDc2IDM0ICB8CXwgICAg
ICBkYXRhICAgICAgfAkgaSBwIHYgNA0KfCA3NCA2MSA2MiA2YyAgfAl8ICAgICAgZGF0YSAgICAg
IHwJIHQgYSBiIGwNCnwgNjUgMDAgMDAgMDAgIHwJfCAgICAgIGRhdGEgICAgICB8CSBlICAgICAg
DQp8MDAwMjV8LS18MDAwMDJ8CXxsZW4gfGZsYWdzfCB0eXBlfA0KfCA2ZSA2ZiAyZCA2NSAgfAl8
ICAgICAgZGF0YSAgICAgIHwJIG4gbyAtIGUNCnwgNmUgNjQgNzAgNmYgIHwJfCAgICAgIGRhdGEg
ICAgICB8CSBuIGQgcCBvDQp8IDY5IDZlIDc0IDJkICB8CXwgICAgICBkYXRhICAgICAgfAkgaSBu
IHQgLQ0KfCA3MyA2NSA3MiA3NiAgfAl8ICAgICAgZGF0YSAgICAgIHwJIHMgZSByIHYNCnwgNjkg
NjMgNjUgNzMgIHwJfCAgICAgIGRhdGEgICAgICB8CSBpIGMgZSBzDQp8IDAwIDAwIDAwIDAwICB8
CXwgICAgICBkYXRhICAgICAgfAkgICAgICAgIA0KfDAwMDA4fC0tfDAwMDAzfAl8bGVuIHxmbGFn
c3wgdHlwZXwgICBORlRBX1NFVF9GTEFHUw0KfCAwMCAwMCAwMCAwOCAgfAl8ICAgICAgZGF0YSAg
ICAgIHwJIE5GVF9TRVRfTUFQICAgICAgICAgICAgICAgICAgICAgICA9IDB4OCAgICAgIA0KDQp8
MDAwMDh8LS18MDAwMDR8CXxsZW4gfGZsYWdzfCB0eXBlfCAgIE5GVEFfU0VUX0tFWV9UWVBFICAg
ICAgICAgICAgICAgICA9IDB4NA0KfCAwMCAwMCAwMSBjZCAgfAl8ICAgICAgZGF0YSAgICAgIHwJ
ICAgICAgICANCg0KfDAwMDA4fC0tfDAwMDA1fAl8bGVuIHxmbGFnc3wgdHlwZXwgICBORlRBX1NF
VF9LRVlfTEVOICAgICAgICAgICAgICAgICAgPSAweDUNCnwgMDAgMDAgMDAgMDggIHwJfCAgICAg
IGRhdGEgICAgICB8CSAgICAgICAgDQoNCnwwMDAwOHwtLXwwMDAwNnwJfGxlbiB8ZmxhZ3N8IHR5
cGV8ICAgTkZUQV9TRVRfREFUQV9UWVBFICAgICAgICAgICAgICAgID0gMHg2ICBWZXJkaWN0DQp8
IGZmIGZmIGZmIDAwICB8CXwgICAgICBkYXRhICAgICAgfAkgICAgICAgIA0KDQp8MDAwMDh8LS18
MDAwMDd8CXxsZW4gfGZsYWdzfCB0eXBlfCAgIE5GVEFfU0VUX0RBVEFfTEVOICAgICAgICAgICAg
ICAgICA9IDB4Nw0KfCAwMCAwMCAwMCAwMCAgfAl8ICAgICAgZGF0YSAgICAgIHwJICAgICAgICAN
Cg0KfDAwMDA4fC0tfDAwMDEwfAl8bGVuIHxmbGFnc3wgdHlwZXwgICBORlRBX1NFVF9JRCAgICAg
ICAgICAgICAgICAgICAgICAgPSAweGENCnwgMDAgMDAgMDAgMDEgIHwJfCAgICAgIGRhdGEgICAg
ICB8CSAgICAgICAgDQp8MDAwMTZ8LS18MDAwMTN8CXxsZW4gfGZsYWdzfCB0eXBlfA0KfCAwMCAw
NCAwMCAwMCAgfAl8ICAgICAgZGF0YSAgICAgIHwJICAgICAgICANCnwgMDAgMDAgMDEgMDQgIHwJ
fCAgICAgIGRhdGEgICAgICB8CSAgICAgICAgDQp8IDAwIDAwIDAwIDAwICB8CXwgICAgICBkYXRh
ICAgICAgfAkgICAgICAgIA0KLS0tLS0tLS0tLS0tLS0tLQktLS0tLS0tLS0tLS0tLS0tLS0NCg0K
QWxtb3N0IGFsbCBpcyBjbGVhciBleGNlcHQgMiBwb2ludHM7IGhvdyBzZXQgZmxhZyAiMDAgMDAg
MDEgY2QgIiAgaXMgZ2VuZXJhdGVkIGFuZCB3aGVuIGtleSBsZW5ndGggaXMgOCBhbmQgbm90IDYu
IA0KDQpUaGFua3MgYSBsb3QNClNlcmd1ZWkNCg0K77u/T24gMjAxOS0xMS0yOCwgODowOCBBTSwg
Im4wLTFAb3JieXRlLm53bC5jYyBvbiBiZWhhbGYgb2YgUGhpbCBTdXR0ZXIiIDxuMC0xQG9yYnl0
ZS5ud2wuY2Mgb24gYmVoYWxmIG9mIHBoaWxAbndsLmNjPiB3cm90ZToNCg0KICAgIEhpIFNlcmd1
ZWksDQogICAgDQogICAgT24gVGh1LCBOb3YgMjgsIDIwMTkgYXQgMDE6MjI6MTdBTSArMDAwMCwg
U2VyZ3VlaSBCZXp2ZXJraGkgKHNiZXp2ZXJrKSB3cm90ZToNCiAgICA+IFBsZWFzZSBzZWUgYmVs
b3cgdGhlIGxpc3Qgb2YgbmZ0YWJsZXMgcnVsZXMgdGhlIGNvZGUgZ2VuZXJhdGUgdG8gbWltaWMg
b25seSBmaWx0ZXIgY2hhaW4gcG9ydGlvbiBvZiBrdWJlIHByb3h5Lg0KICAgID4gDQogICAgPiBI
ZXJlIGlzIHRoZSBsb2NhdGlvbiBvZiBjb2RlIHByb2dyYW1taW5nIHRoZXNlIHJ1bGVzLiANCiAg
ICA+IGh0dHBzOi8vZ2l0aHViLmNvbS9zYmV6dmVyay9uZnRhYmxlc2xpYi1zYW1wbGVzL2Jsb2Iv
bWFzdGVyL3Byb3h5L21pbWljLWZpbHRlci9taW1pYy1maWx0ZXIuZ28NCiAgICA+IA0KICAgID4g
TW9zdCBvZiBydWxlcyBhcmUgc3RhdGljLCB3aWxsIGJlIHByb2dyYW1lZCAganVzdCBvbmNlIHdo
ZW4gcHJveHkgY29tZXMgdXAsIHdpdGggdGhlIGV4Y2VwdGlvbiBpcyAyIHJ1bGVzIGluIGs4cy1m
aWx0ZXItc2VydmljZXMgY2hhaW4uIFRoZSByZWZlcmVuY2UgdG8gdGhlIGxpc3Qgb2YgcG9ydHMg
Y2FuIGNoYW5nZS4gSWRlYWxseSBpdCB3b3VsZCBiZSBncmVhdCB0byBleHByZXNzIHRoZXNlIHR3
byBydWxlcyB3aXRoIGEgc2luZ2xlIHJ1bGUgYW5kIGEgdm1hcCwgd2hlcmUgdGhlIGtleSBtdXN0
IGJlIHNlcnZpY2UncyBpcCBBTkQgc2VydmljZSBwb3J0LCBhcyBpdCBpcyBwb3NzaWJsZSB0byBo
YXZlIGEgc2luZ2xlIHNlcnZpY2UgSVAgdGhhdCBjYW4gYmUgYXNzb2NpYXRlZCB3aXRoIHNldmVy
YWwgcG9ydHMgYW5kIHNvbWUgb2YgdGhlc2UgcG9ydHMgbWlnaHQgaGF2ZSBhbiBlbmRwb2ludCBh
bmQgc29tZSBkbyBub3QuIFNvIGZhciBJIGNvdWxkIG5vdCBmaWd1cmUgaXQgb3V0LiBBcHByZWNp
YXRlIHlvdXIgdGhvdWdodC9zdWdnZXN0aW9ucy9jcml0aWNzLiBJZiB5b3UgY291bGQgZmlsZSBh
biBpc3N1ZSBmb3IgYW55dGhpbmcgeW91IGZlZWwgbmVlZHMgdG8gYmUgZGlzY3Vzc2VkLCB0aGF0
IHdvdWxkIGJlIGdyZWF0Lg0KICAgIA0KICAgIFdoYXQgYWJvdXQgc29tZXRoaW5nIGxpa2UgdGhp
czoNCiAgICANCiAgICB8IHRhYmxlIGlwIHQgew0KICAgIHwgCW1hcCBtIHsNCiAgICB8IAkJdHlw
ZSBpcHY0X2FkZHIgLiBpbmV0X3NlcnZpY2UgOiB2ZXJkaWN0DQogICAgfCAJCWVsZW1lbnRzID0g
eyAxOTIuMTY4LjgwLjEwNCAuIDg5ODkgOiBnb3RvIGRvX3JlamVjdCB9DQogICAgfCAJfQ0KICAg
IHwgDQogICAgfCAJY2hhaW4gYyB7DQogICAgfCAJCWlwIGRhZGRyIC4gdGNwIGRwb3J0IHZtYXAg
QG0NCiAgICB8IAl9DQogICAgfCANCiAgICB8IAljaGFpbiBkb19yZWplY3Qgew0KICAgIHwgCQly
ZWplY3Qgd2l0aCBpY21wIHR5cGUgaG9zdC11bnJlYWNoYWJsZQ0KICAgIHwgCX0NCiAgICB8IH0N
CiAgICANCiAgICBGb3IgdW5rbm93biByZWFzb25zIHJlamVjdCBzdGF0ZW1lbnQgY2FuJ3QgYmUg
dXNlZCBkaXJlY3RseSBpbiBhIHZlcmRpY3QNCiAgICBtYXAsIGJ1dCB0aGUgZG9fcmVqZWN0IGNo
YWluIGhhY2sgd29ya3MuDQogICAgDQogICAgPiBzdWRvIG5mdCBsaXN0IHRhYmxlIGlwdjR0YWJs
ZQ0KICAgID4gdGFibGUgaXAgaXB2NHRhYmxlIHsNCiAgICA+IAlzZXQgc3ZjMS1uby1lbmRwb2lu
dHMgew0KICAgID4gCQl0eXBlIGluZXRfc2VydmljZQ0KICAgID4gCQllbGVtZW50cyA9IHsgODk4
OSB9DQogICAgPiAJfQ0KICAgID4gDQogICAgPiAJY2hhaW4gZmlsdGVyLWlucHV0IHsNCiAgICA+
IAkJdHlwZSBmaWx0ZXIgaG9vayBpbnB1dCBwcmlvcml0eSBmaWx0ZXI7IHBvbGljeSBhY2NlcHQ7
DQogICAgPiAJCWN0IHN0YXRlIG5ldyBqdW1wIGs4cy1maWx0ZXItc2VydmljZXMNCiAgICA+IAkJ
anVtcCBrOHMtZmlsdGVyLWZpcmV3YWxsDQogICAgPiAJfQ0KICAgID4gDQogICAgPiAJY2hhaW4g
ZmlsdGVyLW91dHB1dCB7DQogICAgPiAJCXR5cGUgZmlsdGVyIGhvb2sgb3V0cHV0IHByaW9yaXR5
IGZpbHRlcjsgcG9saWN5IGFjY2VwdDsNCiAgICA+IAkJY3Qgc3RhdGUgbmV3IGp1bXAgazhzLWZp
bHRlci1zZXJ2aWNlcw0KICAgID4gCQlqdW1wIGs4cy1maWx0ZXItZmlyZXdhbGwNCiAgICA+IAl9
DQogICAgDQogICAgU2FtZSBydWxlc2V0IGZvciBpbnB1dCBhbmQgb3V0cHV0PyBTZWVtcyB3ZWly
ZCBnaXZlbiB0aGUgZGFkZHItYmFzZWQNCiAgICBmaWx0ZXJpbmcgaW4gazhzLWZpbHRlci1zZXJ2
aWNlcy4NCiAgICANCiAgICBDaGVlcnMsIFBoaWwNCiAgICANCg0K
