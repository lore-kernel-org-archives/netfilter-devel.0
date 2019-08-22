Return-Path: <SRS0=orVX=WS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A879C3A5A1
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Aug 2019 15:24:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30B5D233FD
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Aug 2019 15:24:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="VSJ0fcPo";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="OVQmrej0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730839AbfHVPYe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Aug 2019 11:24:34 -0400
Received: from rcdn-iport-3.cisco.com ([173.37.86.74]:2885 "EHLO
        rcdn-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfHVPYd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Aug 2019 11:24:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=818; q=dns/txt; s=iport;
  t=1566487472; x=1567697072;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UgGN2raoLX8jnOFYTaDoA6MZ86ufMQUxuOtbPQPcngQ=;
  b=VSJ0fcPoWjrsaabmTUUA2folmL+QUusunWcaDs7eAYtXW2Ce3MVYROx9
   6tKBwSFC4faozwIK2WvhyzppAAHA/JNR20vAmCJSlMLrus2cRUkUM3iHl
   M7ddDQlqNuC529ds5rvYa232ZqGP5pvJnoarjhFSiecagZ7mF5qpZxOcy
   Y=;
IronPort-PHdr: =?us-ascii?q?9a23=3Auc34SxwJKVgf1H/XCy+N+z0EezQntrPoPwUc9p?=
 =?us-ascii?q?sgjfdUf7+++4j5YhWN/u1j2VnOW4iTq+lJjebbqejBYSQB+t7A1RJKa5lQT1?=
 =?us-ascii?q?kAgMQSkRYnBZueA0DpMvPwbAQxHd9JUxlu+HToeUU=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AnAADYsl5d/4YNJK1kGgEBAQEBAgE?=
 =?us-ascii?q?BAQEHAgEBAQGBVgIBAQEBCwGBRFADgUIgBAsqCoQWg0cDimqCXJdmglIDVAk?=
 =?us-ascii?q?BAQEMAQEtAgEBhD8CF4JIIzcGDgIJAQEEAQEDAQYEbYUtDIVLAQEBAxIREQw?=
 =?us-ascii?q?BATcBDwIBCA4KAgImAgICMBUQAgQOBSKDAIFrAx0Bn1sCgTiIYXOBMoJ7AQE?=
 =?us-ascii?q?FhR0YghYJgQwoAYtuGIFAP4E4H4JMPoREFyOCUTKCJo8YnEgJAoIdlD0bgiG?=
 =?us-ascii?q?WKaVyAgQCBAUCDgEBBYFmIoFYcBVlAYJBgkKDcopTcoEpij4BgSABAQ?=
X-IronPort-AV: E=Sophos;i="5.64,417,1559520000"; 
   d="scan'208";a="606909604"
Received: from alln-core-12.cisco.com ([173.36.13.134])
  by rcdn-iport-3.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 22 Aug 2019 15:24:32 +0000
Received: from XCH-ALN-013.cisco.com (xch-aln-013.cisco.com [173.36.7.23])
        by alln-core-12.cisco.com (8.15.2/8.15.2) with ESMTPS id x7MFOWAh028798
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 22 Aug 2019 15:24:32 GMT
Received: from xhs-rtp-003.cisco.com (64.101.210.230) by XCH-ALN-013.cisco.com
 (173.36.7.23) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 22 Aug
 2019 10:24:31 -0500
Received: from xhs-rtp-003.cisco.com (64.101.210.230) by xhs-rtp-003.cisco.com
 (64.101.210.230) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 22 Aug
 2019 11:24:30 -0400
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-003.cisco.com (64.101.210.230) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 22 Aug 2019 11:24:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IGBwVb5jo0JA5RqW7sihL/tG5N53+O3/JAtpyLJVUSHwh/63VJwAprGA58TrnaWS6FkcyU8BX2z8j+8jrT4UCS7Hv1yO9VZUM4P+H1faYNJSaFEcqASnWBXcVnhQffr+Ecvzc4gFNXylgyqIL5mGvkGRP1aBZEzz6M+9fSE27NH9ta7fv1//HVdc2JwHr15oRU8CJPPJHjvvjeOXGfeuzkfvnEofxe5pu8BohKV3gqS4igboEPrSWt/elZJAhCUCYV5iJEbUPVppjVax4JaW1VV39nnbBUQeJCzZ0lUIN4R5qHH0JfZcX7EvNWJwD/6+6hJZiRImxvXBUyVRKoYnbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UgGN2raoLX8jnOFYTaDoA6MZ86ufMQUxuOtbPQPcngQ=;
 b=QxnMi8Gn4Cmf69AbOavR/9BPwifjsAbmn9F8jPjys+/v3N3rQJvS4EoK3WzmMD2ZWmK4HMKJdUYGlEH4oaLeEKFlXjgf9Qr7RUrib8x6K/8ctSsDnPpH3wtRAfyGdEA9oFUr4Xfae2vdkyx2/GO+/7S4D+dG5AfY7nesBogiZBNE1vH7eFQXVAi3ISVqQSAANGduHNhNRHycr7+gQ8qgnU6McDRoQtfzs0plvpBAD9QE6PbbCLim9ImWyTWO+St8itDR1Z+4bgqahKNi4IIVK/PF6iLRqQq2M2y4Qy3GvpKzeWDkhUc1xR511Sze+9vv9jJD79XXX9Grrb2W2jF65Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UgGN2raoLX8jnOFYTaDoA6MZ86ufMQUxuOtbPQPcngQ=;
 b=OVQmrej055O/T54AW+rTvyjLY/RfKg6+S6p2Tl2QT4vMCePmQsWpCwRb+3ITylDs0pqg1X1Zs438pD6YtExcINl+F9+EpsQMmsfrojVbbGUC85ud1GjzetVvq3wZHHXhgqmUVf9s0xBu1ChDFbbNK8cLto7fWuGAK/9mxr0Zm/c=
Received: from BN6PR11MB1460.namprd11.prod.outlook.com (10.172.21.136) by
 BN6PR11MB0050.namprd11.prod.outlook.com (10.161.155.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Thu, 22 Aug 2019 15:24:29 +0000
Received: from BN6PR11MB1460.namprd11.prod.outlook.com
 ([fe80::531:1342:6daf:28d5]) by BN6PR11MB1460.namprd11.prod.outlook.com
 ([fe80::531:1342:6daf:28d5%11]) with mapi id 15.20.2178.020; Thu, 22 Aug 2019
 15:24:29 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Florian Westphal <fw@strlen.de>
CC:     Dan Williams <dcbw@redhat.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: nft equivalent of iptables command
Thread-Topic: nft equivalent of iptables command
Thread-Index: AQHVWPGGzbiV3UpkmEmnxgajwrqrkacHNpGAgAAJKwD//8E3gIAARj8A//+/PAA=
Date:   Thu, 22 Aug 2019 15:24:28 +0000
Message-ID: <8F2DB50D-3BD2-438F-9A89-E3C166E5CF05@cisco.com>
References: <69AAC254-AF78-4918-82B5-14B3EDB10EDB@cisco.com>
 <20190822141645.GH20113@breakpoint.cc>
 <b258d831a555293816d520eeace318e1e6a159bb.camel@redhat.com>
 <0DCF8898-C2D1-4637-9D78-C18261FE98AB@cisco.com>
 <20190822151616.GI20113@breakpoint.cc>
In-Reply-To: <20190822151616.GI20113@breakpoint.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1c.0.190812
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.84]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b46e9e2-b122-4729-2d31-08d72714d31b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BN6PR11MB0050;
x-ms-traffictypediagnostic: BN6PR11MB0050:
x-microsoft-antispam-prvs: <BN6PR11MB0050E11943BFBAA70EF79E6DC4A50@BN6PR11MB0050.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(136003)(39860400002)(346002)(396003)(189003)(199004)(51444003)(2616005)(6246003)(25786009)(4326008)(36756003)(76116006)(316002)(66066001)(229853002)(64756008)(71200400001)(256004)(53936002)(71190400001)(66446008)(86362001)(58126008)(66476007)(6506007)(66946007)(66556008)(54906003)(81166006)(81156014)(14454004)(8936002)(478600001)(5660300002)(99286004)(33656002)(102836004)(186003)(6916009)(6116002)(3846002)(6436002)(6512007)(6486002)(2906002)(8676002)(446003)(486006)(305945005)(26005)(7736002)(476003)(76176011)(11346002)(4744005);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR11MB0050;H:BN6PR11MB1460.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vdfamTRLxfk9xeibnmfIrKyC6tjkmGRUqYP3hxm6OIghytE6rQM0Zy8o7Xj2u67UDKfAz+16eKv/L4jUQ/ewupGYxFKN7mQ4Yb1sD0RKjzB5Gs1srhc7+YBXkg+4+oLiv0X0IwcUa2EeyooxHNsG67MmMTtRGiuwjI4AcXbSuxgFZFzliYkw6wy3hrFbO9ichthxfPUTIYNEce+ObYeCw0J1y/uUNuM9R2TtR1LGLfEUNdIzrnXxLDoVCW7MegtihYtjj3arOxPKVgCvZMCo2IifMNn2ROzXpK8jqRxmxhrj35k7meH40MNeCyJXP0xmVfuBtXR4PZ4xrxw8zUSapVo7Yg77sfksyRrHzV7J1m0ftTqOhYHr3W/+gwTUymghgHxTZdStggBieQ0rgrwWkRslhxmRdxN1oqkVDO/tl24=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <5C3333A1FC9B8E49A38FABD790E3F437@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b46e9e2-b122-4729-2d31-08d72714d31b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 15:24:28.9847
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O8oSdkLa43xS6quZBWOd0Xi86sdLHhOZ3QlHzkJpCQQb6MU/JRz1B0C5VJgqsvsEQ8UoyP3CeZQOYDp0nBezVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB0050
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.23, xch-aln-013.cisco.com
X-Outbound-Node: alln-core-12.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

DQoNCu+7v09uIDIwMTktMDgtMjIsIDExOjE2IEFNLCAiRmxvcmlhbiBXZXN0cGhhbCIgPGZ3QHN0
cmxlbi5kZT4gd3JvdGU6DQoNCiAgICBTZXJndWVpIEJlenZlcmtoaSAoc2JlenZlcmspIDxzYmV6
dmVya0BjaXNjby5jb20+IHdyb3RlOg0KICAgID4gVGhhdCB3YXMgZXhhY3RseSB3aGF0IEkgdGhv
dWdodCBhYm91dCAiLXMgITxDbHVzdGVyQ0lEUj4iIHdoZW4gSSBzYXcgRmxvcmlhbiByZXBseS4g
IEkgd2lsbCB1c2UgaXQgZm9yIG5vdyBpbiBuZnQgcnVsZXMgd2hpY2ggbmZ0IGt1YmUtcHJveHkg
YnVpbGRzIGZvciB0aGlzIHNwZWNpZmljIGNhc2UuDQogICAgDQogICAgSSB0aGluayB0aGF0IGlu
IGlkZWFsIGNhc2UsIG5vIHJ1bGVzIHdvdWxkIGJlIGdlbmVyYXRlZCBvbiB0aGUgZmx5LA0KICAg
IGFuZCB0aGF0IGluc3RlYWQgaXQgc2hvdWxkIGFkZC9yZW1vdmUgZWxlbWVudHMgZnJvbSBuZnRh
YmxlcyBtYXBzIGFuZCBzZXRzLg0KDQpHcmVhdCBpZGVhLCBvbmNlIHdlIGhhdmUgQVBJIGltcGxl
bWVudGVkIGZvciBtYXBzIEkgd2lsbCBnaXZlIGl0IGEgdHJ5IHRvIHNlZSBob3cgaXQgd291bGQg
Zml0IGludG8gcHJveHkgbG9naWMuDQoNCg==
