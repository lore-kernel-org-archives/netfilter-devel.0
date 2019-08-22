Return-Path: <SRS0=orVX=WS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 522E0C3A5A1
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Aug 2019 15:04:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 186F12133F
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Aug 2019 15:04:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="BaDPcdC6";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="m46EpZas"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387590AbfHVPE4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Aug 2019 11:04:56 -0400
Received: from rcdn-iport-1.cisco.com ([173.37.86.72]:10871 "EHLO
        rcdn-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733195AbfHVPE4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Aug 2019 11:04:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2944; q=dns/txt; s=iport;
  t=1566486296; x=1567695896;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+e4Ev+5ugjGmX25ZEVMwfqpNPi5WRdcr5r986Gf3EJs=;
  b=BaDPcdC6pDeEHGYJbdh9K+3Rg4cFW7rp9vpJSDwzQ5xuF8op/W0N8CmY
   arGbnIfuyEmf3/DuHY1+t/oC/Uxbged6jqQc9BbyV9zp9GA34zJCldyok
   /oEK0kvI3R2VSTUOf0+Yl18s/EASGXP5rF/71GWDVsOCoJSSsmF2NYntY
   I=;
IronPort-PHdr: =?us-ascii?q?9a23=3A89jiiBNe2kRrbG+1PZcl6mtXPHoupqn0MwgJ65?=
 =?us-ascii?q?Eul7NJdOG58o//OFDEu6w/l0fHCIPc7f8My/HbtaztQyQh2d6AqzhDFf4ETB?=
 =?us-ascii?q?oZkYMTlg0kDtSCDBjgJvP4cSEgH+xJVURu+DewNk0GUMs=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AjAACRrl5d/5FdJa1kGQEBAQEBAQE?=
 =?us-ascii?q?BAQEBAQcBAQEBAQGBVgEBAQEBAQsBgURQA4FCIAQLKgqEFoNHA4pqgjcll2a?=
 =?us-ascii?q?CUgNUCQEBAQwBAS0CAQGEPwIXgkgjNwYOAgkBAQQBAQMBBgRthS0MhUoBAQE?=
 =?us-ascii?q?BAgESEREMAQE3AQ8CAQgOCgICJgICAjAVEAIEAQ0FIoMAgWsDDg8Bn1ECgTi?=
 =?us-ascii?q?IYXOBMoJ7AQEFgkeCUxiCFgmBDCgBhHmGdRiBQD+BEScME4JMPoREFyOCUTK?=
 =?us-ascii?q?CJo8YnEgJAoIdlD0bmEqNX5gTAgQCBAUCDgEBBYFmIoFYcBVlAYJBgkIMF4N?=
 =?us-ascii?q?PilNygSmKPgGBIAEB?=
X-IronPort-AV: E=Sophos;i="5.64,417,1559520000"; 
   d="scan'208";a="617222845"
Received: from rcdn-core-9.cisco.com ([173.37.93.145])
  by rcdn-iport-1.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 22 Aug 2019 15:04:54 +0000
Received: from XCH-ALN-005.cisco.com (xch-aln-005.cisco.com [173.36.7.15])
        by rcdn-core-9.cisco.com (8.15.2/8.15.2) with ESMTPS id x7MF4svQ009349
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 22 Aug 2019 15:04:55 GMT
Received: from xhs-aln-003.cisco.com (173.37.135.120) by XCH-ALN-005.cisco.com
 (173.36.7.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 22 Aug
 2019 10:04:54 -0500
Received: from xhs-aln-001.cisco.com (173.37.135.118) by xhs-aln-003.cisco.com
 (173.37.135.120) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 22 Aug
 2019 10:04:52 -0500
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-001.cisco.com (173.37.135.118) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 22 Aug 2019 10:04:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LQ/Tey1gZFLNihxH9s9/RiCr4p3FHx+MRD1VyWwpoiUa8C7dc6SJQQjbHfHQWsXcYlDDYO6oa1yIcMQ2V9NHbsbBm8fx3kKN7fNlKZeW1Slk3X4PkyihDIwLz0vCOUkoLGnFEnR965Z0hmKjHRy3pvTyUg/psQFrhYkKGiqSyQb8yyyuT/uJ3C0M94q1UkvriX/9qA/OujVcrocxxatSAx10qJ2S6tEiZeVgBe5vLr+gtjF6ogY2YAZyXIrr/IKhDOxK/scz44GDS9tgLsWd9Ksh7zUgiwPhVF+1cNuMqjWLuo0JdkwxxE9ERQOFR+WKpPT71PitrbyA/nsjPX6VTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+e4Ev+5ugjGmX25ZEVMwfqpNPi5WRdcr5r986Gf3EJs=;
 b=BJzvlUWHMiuP5w4jrmZkOkcAdANqFRhXWMa2JgJqkuN08jRPXZ/r/ky+392hCaR4MZ4UL9sBjH/7yU6pzValIWfl7iA7Bghgt35Kfe2NUoRq6UtwCWZVUVw1KG7UD1N9I5t3WdieumS7OVq3Gzc2EPHU4Z8zExspgnwI+UQRSjSo0iN7k7fqIKvpGlxcsGWQzg+ZZes7a4CVpwOQYjRx9kND6Hqgf0jYU7HPoKCpCOtltvhfcQAy4dmt/pAXEiMhLopMUdzMK7qsvCh2CPxMsgk3YxzDueNCGcMczrKjQZ598h6X0x3q4tsSOQjQOBsYo5fVTC9tXPopwHGZZ+2KFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+e4Ev+5ugjGmX25ZEVMwfqpNPi5WRdcr5r986Gf3EJs=;
 b=m46EpZasmEezcZhYsyqp940zy9aHkgx2JeuK552JgIHd3RDKhr8VPokQxj1zn5FXf0h+rIWSGXWRAWffaV+WspDOfgeRsXMQy7Xe9U9QwyDhomr3dc19ehl84mH/YlkL7goERApdwuH4KKjQus/16JFlCi7Qerfsl9M1rTGnz2I=
Received: from BN6PR11MB1460.namprd11.prod.outlook.com (10.172.21.136) by
 BN6PR11MB1570.namprd11.prod.outlook.com (10.172.21.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Thu, 22 Aug 2019 15:04:51 +0000
Received: from BN6PR11MB1460.namprd11.prod.outlook.com
 ([fe80::531:1342:6daf:28d5]) by BN6PR11MB1460.namprd11.prod.outlook.com
 ([fe80::531:1342:6daf:28d5%11]) with mapi id 15.20.2178.020; Thu, 22 Aug 2019
 15:04:51 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Dan Williams <dcbw@redhat.com>, Florian Westphal <fw@strlen.de>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: nft equivalent of iptables command
Thread-Topic: nft equivalent of iptables command
Thread-Index: AQHVWPGGzbiV3UpkmEmnxgajwrqrkacHNpGAgAAJKwD//8E3gA==
Date:   Thu, 22 Aug 2019 15:04:51 +0000
Message-ID: <0DCF8898-C2D1-4637-9D78-C18261FE98AB@cisco.com>
References: <69AAC254-AF78-4918-82B5-14B3EDB10EDB@cisco.com>
 <20190822141645.GH20113@breakpoint.cc>
 <b258d831a555293816d520eeace318e1e6a159bb.camel@redhat.com>
In-Reply-To: <b258d831a555293816d520eeace318e1e6a159bb.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1c.0.190812
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.84]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c74969d-4be8-47d2-25e6-08d727121579
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BN6PR11MB1570;
x-ms-traffictypediagnostic: BN6PR11MB1570:
x-microsoft-antispam-prvs: <BN6PR11MB157008BFEFDE19050A8C3388C4A50@BN6PR11MB1570.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(39860400002)(346002)(376002)(396003)(199004)(189003)(2616005)(64756008)(476003)(81156014)(478600001)(486006)(6512007)(446003)(14454004)(229853002)(99286004)(58126008)(110136005)(33656002)(256004)(11346002)(5660300002)(102836004)(186003)(26005)(6506007)(71190400001)(81166006)(36756003)(76116006)(3846002)(66446008)(25786009)(4326008)(316002)(86362001)(66476007)(6246003)(8676002)(66946007)(66556008)(91956017)(2906002)(76176011)(6486002)(53936002)(6436002)(305945005)(66066001)(7736002)(6116002)(8936002)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR11MB1570;H:BN6PR11MB1460.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: HupqsAV4sR1UDZ2hb7CkYFCI1leQMHAl00hUfcwzXyo1jPZNlwVT++Yzecn4u8voO/R/YYnt06RHuFVrjGboX/70ZCYmZFcpebioPHvHr7opysszUIwVebNzydokLhy7qlby/wQqPvaU/cwVt0LPa/MWCMvdCFA1h+gTacXa4MCXKNhaHkX1XChGs5RHRZ4LxWAoOKuOqsM7gkaUkZS6fJ5j054L4UeNdHtKWVigASa0zqfokLE/qy+rcgDq29SJjutH5o/PfKzVzmMIzx3hWt6QZEOPvpeSqi5NRUFCL1Hg+lEtrlu32p0/u1dXnZscMlJlQpJm2feyAdpIKDylc7ixbdMchkFZQSSVPqbCpDKdZcMM7+RZ6FHfHkrmswfBxXdNE9ggrHXqTF2w8Up2WKkBHqsDhljzmWPEDY1WWZc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C4A53B5EA5DFD41909D39B1C17A06FA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c74969d-4be8-47d2-25e6-08d727121579
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 15:04:51.8090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vkDkIsVgBcPO2SEHoxlZBJzV08N6oGXOBNWQeJyshZi5MWpMEZvuvFUv9ZybAwMfBpQt70PYTiC0wDcOnWSdrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1570
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.15, xch-aln-005.cisco.com
X-Outbound-Node: rcdn-core-9.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

DQoNCu+7v09uIDIwMTktMDgtMjIsIDEwOjQ5IEFNLCAiRGFuIFdpbGxpYW1zIiA8ZGNid0ByZWRo
YXQuY29tPiB3cm90ZToNCg0KICAgIE9uIFRodSwgMjAxOS0wOC0yMiBhdCAxNjoxNiArMDIwMCwg
RmxvcmlhbiBXZXN0cGhhbCB3cm90ZToNCiAgICA+IFNlcmd1ZWkgQmV6dmVya2hpIChzYmV6dmVy
aykgPHNiZXp2ZXJrQGNpc2NvLmNvbT4gd3JvdGU6DQogICAgPiA+IEhlbGxvLA0KICAgID4gPiAN
CiAgICA+ID4gSSBhbSB0cnlpbmcgdG8gZmluZCBhbiBlcXVpdmFsZW50IG5mdCBjb21tYW5kIGZv
ciB0aGUgZm9sbG93aW5nDQogICAgPiA+IGlwdGFibGVzIGNvbW1hbmQuICBTcGVjaWZpY2FsbHkg
InBoeXNkZXYiIGFuZCAiYWRkcnR5cGUiLCBJIGNvdWxkDQogICAgPiA+IG5vdCBmaW5kIHNvIGZh
ciwgc29tZSBoZWxwIHdvdWxkIGJlIHZlcnkgYXBwcmVjaWF0ZWQuDQogICAgPiA+IC1tIHBoeXNk
ZXYgISAtLXBoeXNkZXYtaXMtaW4gICAgICAgICAgICANCiAgICA+IA0KICAgID4gVGhpcyBoYXMg
bm8gZXF1aXZhbGVudC4gIFRoZSBydWxlIGFib3ZlIG1hdGNoZXMgd2hlbiAnY2FsbC1pcHRhYmxl
cycNCiAgICA+IHN5c2N0bA0KICAgID4gaXMgZW5hYmxlZCBhbmQgdGhlIHBhY2tldCBkaWQgbm90
IGVudGVyIHZpYSBhIGJyaWRnZSBpbnRlcmZhY2UuDQogICAgPiBTbywgaXRzIG9ubHkgZmFsc2Ug
d2hlbiBpdCBkaWQgZW50ZXIgdmlhIGEgYnJpZGdlIGludGVyZmFjZS4NCiAgICANCiAgICBBbHNv
IG5vdGUgdGhhdCB0aGUgcnVsZSBpbiBrdWJlLXByb3h5IHRoYXQgYWRkcyBwaHlzZGV2L3BoeXNk
ZXYtaXMtaW4NCiAgICBoYXMgdGhlIGNvbW1lbnQ6DQogICAgDQogICAgLy8gVGhpcyBpcyBpbXBl
cmZlY3QgaW4gdGhlIGZhY2Ugb2YgbmV0d29yayBwbHVnaW5zIHRoYXQgbWlnaHQgbm90IHVzZQ0K
ICAgIGEgYnJpZGdlLCBidXQgd2UgY2FuIHJldmlzaXQgdGhhdCBsYXRlci4NCiAgICANCiAgICBh
bmQgaXQgY2xlYXJseSBkb2Vzbid0IHdvcmsgd2hlbiB0aGUgbmV0d29yayBwbHVnaW4gZG9lc24n
dCB1c2UgYQ0KICAgIGJyaWRnZSBpbnRlcmZhY2UgZm9yIGNvbnRhaW5lcnMsIHdoaWNoIGlzIGEg
bG90IG9mIHRoZW0uIEluIGZhY3QsIHRoYXQNCiAgICBydWxlIHNob3VsZCBpbnN0ZWFkIGJlIHJl
d3JpdHRlbiB1cHN0cmVhbSB0byB1c2UgIi1zICE8Q2x1c3RlckNJRFI+IiBvcg0KICAgIHNvbWV0
aGluZyByYXRoZXIgdGhhbiBydWxlcyBhYm91dCBhIG5ldHdvcmsgaW50ZXJmYWNlIHRoYXQgbWF5
L21heSBub3QNCiAgICBleGlzdC4NCg0KDQpUaGFuayB5b3UgRGFuIGZvciB5b3VyIGlucHV0LiAg
IA0KVGhhdCB3YXMgZXhhY3RseSB3aGF0IEkgdGhvdWdodCBhYm91dCAiLXMgITxDbHVzdGVyQ0lE
Uj4iIHdoZW4gSSBzYXcgRmxvcmlhbiByZXBseS4gIEkgd2lsbCB1c2UgaXQgZm9yIG5vdyBpbiBu
ZnQgcnVsZXMgd2hpY2ggbmZ0IGt1YmUtcHJveHkgYnVpbGRzIGZvciB0aGlzIHNwZWNpZmljIGNh
c2UuDQoNClNlcmd1ZWkNCg0KICAgIElNSE8gdGhpcyBpcyByZWFsbHkgYW4gaXNzdWUgaW4ga3Vi
ZS1wcm94eSAoY29kZSB3YXMgYWRkZWQgaW4gMjAxNSkNCiAgICB0aGF0IGhhc24ndCBiZWVuIGNs
ZWFuZWQgdXAgc2luY2UgS3ViZXJuZXRlcyBzdGFydGVkIHN1cHBvcnRpbmcgbW9yZQ0KICAgIGRp
dmVyc2UgbmV0d29yayBwbHVnaW5zLg0KICAgIA0KICAgIERhbg0KICAgIA0KICAgID4gSW4gY2Fz
ZSB0aGUgc3lzY3RsIGlzIG9mZiwgdGhlIHJ1bGUgYWx3YXlzIG1hdGNoZXMgYW5kIGNhbiBiZQ0K
ICAgID4gb21pdHRlZC4NCiAgICA+IA0KICAgID4gbmZ0YWJsZXMgY3VycmVudGx5IGFzc3VtZXMg
dGhhdCBjYWxsLWlwdGFibGVzIGlzIG9mZiwgYW5kIHRoYXQNCiAgICA+IGJyaWRnZXMgaGF2ZSB0
aGVpciBvd24gZmlsdGVyIHJ1bGVzIGluIHRoZSBuZXRkZXYgYW5kL29yDQogICAgPiBicmlkZ2Ug
ZmFtaWxpZXMuDQogICAgPiANCiAgICA+IGluZXQvaXAvaXA2IGFyZSBhc3N1bWVkIHRvIG9ubHkg
c2VlIHBhY2tldHMgdGhhdCBhcmUgcm91dGVkIGJ5IHRoZSBpcA0KICAgID4gc3RhY2suDQogICAg
PiANCiAgICA+ID4gLW0gYWRkcnR5cGUgISAtLXNyYy10eXBlIExPQ0FMIA0KICAgID4gDQogICAg
PiBmaWIgc2FkZHIgdHlwZSAhPSBsb2NhbA0KICAgIA0KICAgIA0KDQo=
