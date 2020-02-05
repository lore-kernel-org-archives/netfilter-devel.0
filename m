Return-Path: <SRS0=2+fO=3Z=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NORMAL_HTTP_TO_IP,NUMERIC_HTTP_ADDR,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE540C35247
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Feb 2020 15:20:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7311A20659
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Feb 2020 15:20:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="lO+8pJ26";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="IhzjWwog"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbgBEPU7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Feb 2020 10:20:59 -0500
Received: from rcdn-iport-4.cisco.com ([173.37.86.75]:49541 "EHLO
        rcdn-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727441AbgBEPU6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Feb 2020 10:20:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=970; q=dns/txt; s=iport;
  t=1580916058; x=1582125658;
  h=from:to:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=X3P4lS4wjxNM3SPKFWzEqqwfJrNL4lCvzhkUKJQqWgA=;
  b=lO+8pJ26qz+9pxQrtI3MTSS2yHti8bVO/RqwAZjrO7csxQQILnU6Auab
   ZxUbmD0KbnmgVANleF+tjKicKIi/ap9x5O+bGW3G6dFEo+OpiRX3k+V2I
   ZjHxnVuyAJHUuSP68siCvcUjDgTJg0RlFO+fuGYk1iQhwtvsWwNrTrdvL
   o=;
IronPort-PHdr: =?us-ascii?q?9a23=3AIc+RchAz2DOpsGyXUCK4UyQJPHJ1sqjoPgMT9p?=
 =?us-ascii?q?ssgq5PdaLm5Zn5IUjD/qs03kTRU9Dd7PRJw6rNvqbsVHZIwK7JsWtKMfkuHw?=
 =?us-ascii?q?QAld1QmgUhBMCfDkiuN/TnfTI3BsdqX15+9Hb9Ok9QS47z?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0DFEAAP3Tpe/4cNJK1lHgELHINPUAV?=
 =?us-ascii?q?sWCAECyoKhAuDRgOKe06FFpBlhCiCUgNUCQEBAQwBARsSAgEBg2xtKIF7JDg?=
 =?us-ascii?q?TAgMNAQEEAQEBAgEFBG2FNwELhX8REQwBAQkBLhEBGwcCJgIEIw0VCggENYM?=
 =?us-ascii?q?EAYJKAy4BAqEgAoE5iGJ1gTKCfwEBBYECAYFBglYYggwJgQ4qhR4MhngagUE?=
 =?us-ascii?q?/gTggimUygiyNa4JsnxMKgjqGYY9iFAeCOJhREUCDJIptmx8CBAIEBQIOAQE?=
 =?us-ascii?q?FgWkigVhwFWUBgXQBAUsJRxgNjh2Dc4pTdAKBJ4wWAYEPAQE?=
X-IronPort-AV: E=Sophos;i="5.70,406,1574121600"; 
   d="scan'208";a="717199068"
Received: from alln-core-2.cisco.com ([173.36.13.135])
  by rcdn-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 05 Feb 2020 15:20:57 +0000
Received: from XCH-RCD-001.cisco.com (xch-rcd-001.cisco.com [173.37.102.11])
        by alln-core-2.cisco.com (8.15.2/8.15.2) with ESMTPS id 015FKvN7018276
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL)
        for <netfilter-devel@vger.kernel.org>; Wed, 5 Feb 2020 15:20:57 GMT
Received: from xhs-rcd-001.cisco.com (173.37.227.246) by XCH-RCD-001.cisco.com
 (173.37.102.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 5 Feb
 2020 09:20:56 -0600
Received: from xhs-aln-003.cisco.com (173.37.135.120) by xhs-rcd-001.cisco.com
 (173.37.227.246) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 5 Feb
 2020 09:20:56 -0600
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-003.cisco.com (173.37.135.120) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 5 Feb 2020 09:20:56 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aloHbDw8Z4qDBy6dAVfuCODJNgbVzz7RMS8pBv8PCV786c9n4SklsKGMCz7vaQk4blPWVRkh/LB8kNCFGBX0rmK6YmxQO8F53QfterpDrDrv1vEv06FuDeSwdrWLZQ7A5W+ZCGe5wZ67h0NJMAISWSkLpfYG7mNbs9Pf+DniD8TLMVZ41wpWemeccw4JgODVGy7sA3qrYBE6LpJMk6UUBMis+Uon5LUw71agX6hFqevT3yR5lxyUp71JuyeD8iqPwy0o9Ip5j8MRHYPhjkGS4EHUpEeBihjksqXMKRJs/uV0DLXE7OZiADCZuic8hee+6PYmoNl2srbSgC1fcUZxnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X3P4lS4wjxNM3SPKFWzEqqwfJrNL4lCvzhkUKJQqWgA=;
 b=gnhny+a2AmkD6PXyC+E8m4jcgs8MPJXfS0HBguPk2VXj7ce4Q4MJpkDhbeGUbtFVK95W4osU0JJzRr5KeSJIrY00+QIJRlMwkDX0TP7TKCnioJb/7E6wE7/J36qD0kMRAuS55GXUeihwrEf1X+B3kV7feXzXNWQiU3aVhKGULKTk6XsZ+uKFPhIVvymjpgeiPQOK1C8jPpBW99C8bRSDR7M6k3HqH2jrYkzZdwwnPDivWY4Ub5+/4PwLV0apjQ7pVWF53Mx8F9y509TgTtDiHsQ4Iu74Fe3hEhf9W1xxlFp0XhdrmPLHZ9hvU4DAoTbUXDYQ0xt2eGOaCwn7ZHAaDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X3P4lS4wjxNM3SPKFWzEqqwfJrNL4lCvzhkUKJQqWgA=;
 b=IhzjWwog6lUsA7qhJXuCl2rUKtyG2+zrNr1eOv6vp+SeIIjoDXbfarLI1ZQAvlvmcLUANX7kJSukjmbwJIOFXfnY+WCWQOYytuc/X29tKD4oaKEKnvITHQyzhru/Netl8BoL0K0nA7OcBLmtyVm5077z3fOzBOmgQ8nlGWjGCnk=
Received: from MN2PR11MB3598.namprd11.prod.outlook.com (20.178.252.28) by
 MN2PR11MB4448.namprd11.prod.outlook.com (52.135.39.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Wed, 5 Feb 2020 15:20:55 +0000
Received: from MN2PR11MB3598.namprd11.prod.outlook.com
 ([fe80::e526:356d:d654:f135]) by MN2PR11MB3598.namprd11.prod.outlook.com
 ([fe80::e526:356d:d654:f135%7]) with mapi id 15.20.2686.031; Wed, 5 Feb 2020
 15:20:55 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: masquerade
Thread-Topic: masquerade
Thread-Index: AQHV3Dfbi3vLyGvKvky2O8HfsW2uxQ==
Date:   Wed, 5 Feb 2020 15:20:54 +0000
Message-ID: <E019C7FD-C763-465B-A32B-BE35A27C0B7A@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.21.0.200113
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.65]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e711757-0e19-4c51-2d15-08d7aa4efe98
x-ms-traffictypediagnostic: MN2PR11MB4448:
x-microsoft-antispam-prvs: <MN2PR11MB4448CE693D9F161ADAA6247EC4020@MN2PR11MB4448.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0304E36CA3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(6019001)(4636009)(136003)(366004)(39860400002)(346002)(376002)(396003)(189003)(199004)(7116003)(6916009)(6506007)(33656002)(26005)(36756003)(66946007)(6512007)(86362001)(5660300002)(316002)(66476007)(66446008)(2616005)(66556008)(64756008)(71200400001)(478600001)(76116006)(81166006)(81156014)(966005)(4744005)(3480700007)(8936002)(2906002)(8676002)(6486002)(186003)(166393002)(220243001)(344275003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4448;H:MN2PR11MB3598.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Kc9TvAvnNaWGUYhC0FDlWDoBKZSpX2+KmVf2+ESY4r469S4c1yHgKGFSRxY3a+enA7lw7B4DZXXl7g11lb+WG45Fu80a997+QBYF2sPOu+bC1hKaHn7zTVqVPI31h4MXO7mEAPoqSd2NvH4BBioQF4rLHLQy6z97qxAWJ3wcQ16MwJjF/ELB7it77ZDa2nHrnG2plgtKRECDlaqMczNXn1xj4A4c5zFlhK6Hlw7DVtGODcVK6BhHUBXo+2zzQpxeePoIUCHVIG/J2FKgYdfg8/fC9YhBs5uvwxGGQ4kblwVmTMXHk5N2AJxF+1ezIIwk+7W6LuWWwUjUCW6Im2Gqr2H9oyGP5cCOD8nghaqkLaVM2Fb+T86wcuST2vzAQwGQ38fSf4SiG9k3fsXKtgrHaIzDiZLYHGNotn/YzYhogWbwFFIZRrpP/DjPA3J4AV7+wkS623om5rIQwKo6Sw/jFT/HK06oX7pI7pfwfI/3AtlvvAwdaDdXnz3IL5vaNNB0AdW9mDZdOaMopgIU9kxNUp5uui3afe+8y8hjT75GmW6CLhuoGZocyGwz42o+BqjIe+f6hMuEoYVIKAgTonPSv9kEjr9AoZt3XdKPAHAZv5sirxO0eEFsBKP4YkbziH+q
x-ms-exchange-antispam-messagedata: Fu6UB23kZd9NNrBG4fkFObqBRm/yunD+dlXYrrmG3LNxYimn3k3/zaXetcZd4IabwY+dcIv6RCfz/RK8w0xxeVWXJXkvfPIuhoztNZ++sQjlSjAbfalEH/jSsq9xNCNUCaDvjet3+Pxlsydzq8nY9A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <1EFF3E4297A9DF469BAF6D1F1F529C64@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e711757-0e19-4c51-2d15-08d7aa4efe98
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2020 15:20:54.8903
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P/yD/FIUv6ZxIReS4tVlO0Y7UDS1du1NyO++FO+BqxhwohkZhNWiCvkW9X7FbOS543KXXheKZI3gBcJyayPl1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4448
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.11, xch-rcd-001.cisco.com
X-Outbound-Node: alln-core-2.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGVsbG8sDQoNCkkgd2FzIGFkZHJlc3Npbmcga3ViZXJuZXRlcyBoYWlycGluIGNhc2Ugd2hlbiBh
IGNvbnRhaW5lciBjb25uZWN0cyB0byBpdHNlbGYgdmlhIGV4cG9zZWQgc2VydmljZS4NCg0KRXhh
bXBsZSBwb2Qgd2l0aCBpcCAxLjEuMS4xIGxpc3RlbmluZyBvbiBwb3J0IHRjcCA4MDgwIGFuZCBl
eHBvc2VkIHZpYSAgIHNlcnZpY2UgMi4yLjIuMjo4MDgwLCBpZiBjdXJsIGlzIHJ1biBmcm9tIGlu
c2lkZSB0aGUgcG9kLCBsaWtlIGN1cmwgaHR0cDovLzIuMi4yLjI6ODA4MCB0aGVuIHRoZSBwYWNr
ZXQgd291bGQgYmUgZmlyc3QgZG5hdCB0byAxLjEuMS4xOjgwODAgYW5kIHRoZW4gaXRzIHNvdXJj
ZSBuZWVkcyB0byBiZSBtYXNxdWVyYWRlZC4gSW4gaXB0YWJsZXMgaW1wbGVtZW50YXRpb24gaXQg
c2VlbXMgaXQgaXMgYXV0b21hdGljYWxseSBtYXNxdWVyYWRlZCB0byBob3N0J3MgSVAgd2hlcmVh
cyBpbiBuZnRhYmxlcyAoYWxsIHJ1bGVzIGFyZSBlcXVpdmFsZW50KSBzb3VyY2UgZ2V0cyBtYXNx
dWVyYWRlZCBpbnRvIFBPRCdzIGludGVyZmFjZS4NCg0KSSB3b3VsZCBhcHByZWNpYXRlIGlmIHNv
bWVib2R5IGNvdWxkIGNvbmZpcm0gdGhpcyBiZWhhdmlvciBhbmQgZGlmZmVyZW50IGluIG1hc3F1
ZXJhZGluZyBiZXR3ZWVuIGlwdGFibGVzIGFuZCBuZnRhYmxlcyBmb3IgY29udGFpbmVycy4NCg0K
VGhhbmsgeW91DQpTZXJndWVpDQoNCg==
