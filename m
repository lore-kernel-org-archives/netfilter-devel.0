Return-Path: <SRS0=M/8g=ZS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64E39C432C0
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Nov 2019 21:20:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E4DB2071E
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Nov 2019 21:20:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="akxn94uS";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="0KQQaBmC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfKZVUZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Nov 2019 16:20:25 -0500
Received: from alln-iport-5.cisco.com ([173.37.142.92]:58071 "EHLO
        alln-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfKZVUZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Nov 2019 16:20:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=5920; q=dns/txt; s=iport;
  t=1574803224; x=1576012824;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KNC3H2YWMGXw3hJVrPdv6tSz2sSIuPwhkR75xZFiz6A=;
  b=akxn94uSgChBEStqHZlFbAJ1Ls07AOZSpydq/egELZF4qkJ0WGgc/VL1
   H4GC3mz2vYrqGxdOPW09sw2MAK5NI+h/hOqVChf/IMVcAvjZ9yxM3PjOm
   fEo8F/RyT/lApsXZ6rWM04iQyaeygqKDrMf3lSWpL07aXhPbnQG/KMC6X
   E=;
IronPort-PHdr: =?us-ascii?q?9a23=3AWBoxjhc179L1vE6i2Q4wcQkplGMj4e+mNxMJ6p?=
 =?us-ascii?q?chl7NFe7ii+JKnJkHE+PFxlwGQD57D5adCjOzb++D7VGoM7IzJkUhKcYcEFn?=
 =?us-ascii?q?pnwd4TgxRmBceEDUPhK/u/dCY3DtpPTlxN9HCgOk8TE8H7NBXf?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0BoLgCRlt1d/51dJa1iAxwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYF+gUskBSUCBWxYIAQLKgqEIYNGA4pxgl+BAZcDgUKBEANUCQE?=
 =?us-ascii?q?BAQwBAS0CAQGEQAIXgV8kOBMCAw0BAQQBAQECAQUEbYU3DIVTAQEBAw4EERE?=
 =?us-ascii?q?MAQEjFAEPAgEIGAICJgICAjAVEAIEDgUUDoMAAYJGAy4BAqdbAoE4iGB1gTK?=
 =?us-ascii?q?CfgEBBYUbGIIXCYEOKIUbEVyGDhqBQD+BEScgghcHLj6EMhcXCiaCSTKCLJA?=
 =?us-ascii?q?XniEKgiyVVhuaHaV+glwCBAIEBQIOAQEFgWkigVhwFTsqAYJBUBEUhkiBJwE?=
 =?us-ascii?q?HgkSKU3SBKI06AYEOAQE?=
X-IronPort-AV: E=Sophos;i="5.69,246,1571702400"; 
   d="scan'208";a="378860736"
Received: from rcdn-core-6.cisco.com ([173.37.93.157])
  by alln-iport-5.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 26 Nov 2019 21:20:23 +0000
Received: from XCH-RCD-003.cisco.com (xch-rcd-003.cisco.com [173.37.102.13])
        by rcdn-core-6.cisco.com (8.15.2/8.15.2) with ESMTPS id xAQLKNbK024117
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 26 Nov 2019 21:20:23 GMT
Received: from xhs-aln-001.cisco.com (173.37.135.118) by XCH-RCD-003.cisco.com
 (173.37.102.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Nov
 2019 15:20:22 -0600
Received: from xhs-rcd-002.cisco.com (173.37.227.247) by xhs-aln-001.cisco.com
 (173.37.135.118) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Nov
 2019 15:20:22 -0600
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-002.cisco.com (173.37.227.247) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 26 Nov 2019 15:20:21 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MY/aEQeRXCbIO3OyLpA7SViAnjusgAceVw2HnJFj4z0XEDBHlkD2Vjwm63LHjeQY5RGlTNpu4gtX10KUWQi97wOwlmh7DGwvJh1x3B7SoAvXFUrFHqjgLJypJSLzowCKtGBWSnZ8tPLWR2ng2ITES5rNEoxwzvE/V7ZlhDT2y9PId8hhDMm1hq96QloMKJXBiNDyQFFsozYzoPiyt+BmVTWZ9xDf9dVa4EuZ4886YG3K8jlJX7auveU7u7VnPrm6G8MxUQuk88juT8P2/iqb6K/7s9GnL5kt+5DjxAReJZGpUt1BNI/jQZ11soAvNFc5L2yVDu+MCR3JYLJ/u+lgNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNC3H2YWMGXw3hJVrPdv6tSz2sSIuPwhkR75xZFiz6A=;
 b=XrSWr4ohRaPzaXunIx6oQ5dJzU3Iu2iXKPaUzylWVSo6zyJ2h1UjTENMOUa5iYawc72hikmUp3WSzWtvNznlK/1TTRU8gvfoz/TEi5k+xoV68lon9GduxchNJVxEl0kSWPoemdF2CJv8wr0gbU5bEkIykl4tkXXvk08HCn/B/PN5rz9LCV9rGykRI4PBXkpxr9w6d1IrsQLLjPJEi8eedrxTUkrKLv/MK9/B6vvRFBCEReaYh7cDqABGcO2vnjR6tbFVpYQUsnNwL5UPsEO94e1uy63OHyQ2YxRjRTLACUAHvgO+eaYcqYtaD1SSyrJLNxJ3pXZuJIDkr1YJmashqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNC3H2YWMGXw3hJVrPdv6tSz2sSIuPwhkR75xZFiz6A=;
 b=0KQQaBmCNn5bbj/cMvQGQ1Rh48oVIPTAnxc9o7XW123ClQjwkK5e3cG8cgczRZ4sEgz1ev6aEG+xZXfZumY+IjLaG0W//+ZVuiVRDd6z0eOcbWHuclnnvlE+MZEduIGHoenERxgx2/V37ja3Mi8JHelTLkU0tAoHkF2fI41YpK0=
Received: from SN6PR11MB3358.namprd11.prod.outlook.com (52.135.110.149) by
 SN6PR11MB2783.namprd11.prod.outlook.com (52.135.92.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.21; Tue, 26 Nov 2019 21:20:21 +0000
Received: from SN6PR11MB3358.namprd11.prod.outlook.com
 ([fe80::280e:21c6:3ef8:1a6d]) by SN6PR11MB3358.namprd11.prod.outlook.com
 ([fe80::280e:21c6:3ef8:1a6d%7]) with mapi id 15.20.2474.023; Tue, 26 Nov 2019
 21:20:20 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Phil Sutter <phil@nwl.cc>
CC:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Operation not supported when adding jump command
Thread-Topic: Operation not supported when adding jump command
Thread-Index: AQHVo8HvElEENwloc0uP91utUJLts6edYHQA///QMACAAGcLAP//rq8AgABU1YD//91EAAAL5rgA///LmgA=
Date:   Tue, 26 Nov 2019 21:20:20 +0000
Message-ID: <AC4B6BFD-30FA-4A62-AD3C-3EB37029EC1B@cisco.com>
References: <5248B312-60A9-48A7-B4CF-E00D1BDF1CD2@cisco.com>
 <20191126122110.GD795@breakpoint.cc>
 <3DBD9E39-A0DF-4A69-93CC-4344617BDB2F@cisco.com>
 <20191126153850.pblaoj4xklfz5jgv@salvia>
 <427E92A6-2FFA-47CF-BF3B-C08961C978C9@cisco.com>
 <20191126155125.GD8016@orbyte.nwl.cc>
 <0A92D5EA-B158-4C7A-B85C-1692AE7C828B@cisco.com>
 <20191126192752.GE8016@orbyte.nwl.cc>
In-Reply-To: <20191126192752.GE8016@orbyte.nwl.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b26b755-763d-42b4-abb2-08d772b67171
x-ms-traffictypediagnostic: SN6PR11MB2783:
x-microsoft-antispam-prvs: <SN6PR11MB278302D0B51BABAA735210C0C4450@SN6PR11MB2783.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0233768B38
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(376002)(39860400002)(366004)(136003)(189003)(199004)(99286004)(76116006)(66476007)(2906002)(6116002)(91956017)(5660300002)(64756008)(81166006)(81156014)(8936002)(86362001)(6916009)(4001150100001)(3846002)(33656002)(7736002)(8676002)(6486002)(6246003)(25786009)(305945005)(229853002)(554214002)(71200400001)(71190400001)(6512007)(478600001)(4326008)(256004)(26005)(14454004)(66066001)(446003)(11346002)(6506007)(36756003)(102836004)(2616005)(316002)(66446008)(186003)(76176011)(58126008)(66946007)(66556008)(54906003)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB2783;H:SN6PR11MB3358.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zyQmqqKUhYEmlHJDhjADkXoHeuKkFJ0MTF+suc4C7EWPLtNeTdrrD2wT2HLWx+pqW/smq6KGdxXCGNNoq/hdzi34+rBNCFnsQceEOStKC8rfRY9f1KRDaYWkCgEe3jfEurW+fVuEvgPXDBQSeslRbt9xoyPPcfUX+BWNag8wu2hgvzxtdc8VLBWP3yNbGmmbkR9nrqvF5ILp47oAk27Z58e3q3STsTz6ToUrecg5qR4gWk7hgNfT5NjLv7AO175Pzs7FYSbXtPCBYps42L1NQOIiqNm3/1eLgRCotbPDFJpxu3LcyA9ATBrxjgA/Gw8SjQOZTgxlzwJWDfsqWMHKwfXs0T2ARo1TpFu6w0gXSoosjnqpA7O3PEEeLYXwBvc6ZOjErhj7gBe55gM75FlJiWy+/6vTacRFmVoMZizebHatdtSSIp57t0MM76ypcIjX
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <7FB3723551DA91498DD055B5DEE90575@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b26b755-763d-42b4-abb2-08d772b67171
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2019 21:20:20.7954
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZU1rKWHQeJMSiIUhfcVDZZfcvMBd2eUw/QqvtsyBKXkvN0FwXi6LAzzpPD2djWx/kfQKrqBkSCMJjtCpPRV7WQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2783
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.13, xch-rcd-003.cisco.com
X-Outbound-Node: rcdn-core-6.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGVsbG8gUGhpbCwNCg0KSXQgYWxtb3N0IHdvcmtlZCAoIENoZWNrIHRoaXMgb3V0Og0Kc3VkbyBu
ZnQgbGlzdCB0YWJsZSBpcHY0dGFibGUNCnRhYmxlIGlwIGlwdjR0YWJsZSB7DQoJc2V0IG5vLWVu
ZHBvaW50LXN2Yy1wb3J0cyB7DQoJCXR5cGUgaW5ldF9zZXJ2aWNlDQoJCWVsZW1lbnRzID0geyA4
MDgwLCA4OTg5IH0NCgl9DQoNCglzZXQgbm8tZW5kcG9pbnQtc3ZjLWFkZHJzIHsNCgkJdHlwZSBp
cHY0X2FkZHINCgkJZmxhZ3MgaW50ZXJ2YWwNCgkJZWxlbWVudHMgPSB7IDEwLjEuMS4xLCAxMC4x
LjEuMn0NCgl9DQoNCgljaGFpbiBpbnB1dC1uZXQgew0KCQl0eXBlIG5hdCBob29rIGlucHV0IHBy
aW9yaXR5IGZpbHRlcjsgcG9saWN5IGFjY2VwdDsNCgkJanVtcCBzZXJ2aWNlcw0KCX0NCg0KCWNo
YWluIGlucHV0LWxvY2FsIHsNCgkJdHlwZSBuYXQgaG9vayBvdXRwdXQgcHJpb3JpdHkgZmlsdGVy
OyBwb2xpY3kgYWNjZXB0Ow0KCQlqdW1wIHNlcnZpY2VzDQoJfQ0KDQoJY2hhaW4gc2VydmljZXMg
ew0KCQlpcCBkYWRkciBAbm8tZW5kcG9pbnQtc3ZjLWFkZHJzIHRjcCBkcG9ydCBAbm8tZW5kcG9p
bnQtc3ZjLXBvcnRzIHJlamVjdCB3aXRoIHRjcCByZXNldA0KCQlpcCBkYWRkciBAbm8tZW5kcG9p
bnQtc3ZjLWFkZHJzIHVkcCBkcG9ydCBAbm8tZW5kcG9pbnQtc3ZjLXBvcnRzIHJlamVjdCB3aXRo
IGljbXAgdHlwZSBuZXQtdW5yZWFjaGFibGUNCgl9DQoNCgljaGFpbiBzdmMxLWVuZHBvaW50LTEg
ew0KCQlpcCBwcm90b2NvbCB0Y3AgZG5hdCB0byAxMi4xLjEuMTo4MDgwDQoJfQ0KDQoJY2hhaW4g
c3ZjMS1lbmRwb2ludC0yIHsNCgkJaXAgcHJvdG9jb2wgdGNwIGRuYXQgdG8gMTIuMS4xLjI6ODA4
MA0KCX0NCg0KCWNoYWluIHN2YzItZW5kcG9pbnQtMSB7DQoJCWlwIHByb3RvY29sIHRjcCBkbmF0
IHRvIDEyLjEuMS4zOjgwOTANCgl9DQoNCgljaGFpbiBzdmMyLWVuZHBvaW50LTIgew0KCQlpcCBw
cm90b2NvbCB0Y3AgZG5hdCB0byAxMi4xLjEuNDo4MDkwDQoJfQ0KDQoJY2hhaW4gc3ZjMSB7DQoJ
fQ0KDQoJY2hhaW4gc3ZjMiB7DQoJfQ0KDQoJY2hhaW4gcHJlcm91dGluZyB7DQoJCXR5cGUgbmF0
IGhvb2sgcHJlcm91dGluZyBwcmlvcml0eSBmaWx0ZXI7IHBvbGljeSBhY2NlcHQ7DQoJCWlwIGRh
ZGRyIDEuMS4xLjEgdGNwIGRwb3J0IDg4IG51bWdlbiByYW5kb20gbW9kIDIgdm1hcCB7IDAgOiBq
dW1wIHN2YzEtZW5kcG9pbnQtMSwgMSA6IGp1bXAgc3ZjMS1lbmRwb2ludC0yIH0NCgkJaXAgZGFk
ZHIgMi4yLjIuMiB0Y3AgZHBvcnQgOTkgbnVtZ2VuIHJhbmRvbSBtb2QgMiB2bWFwIHsgMCA6IGp1
bXAgc3ZjMi1lbmRwb2ludC0xLCAxIDoganVtcCBzdmMyLWVuZHBvaW50LTIgfQ0KCX19DQoNCklk
ZWFsbHkgSSBuZWVkIHRvIGFwcGx5ICB0aGlzIHJ1bGUgIiBudW1nZW4gcmFuZG9tIG1vZCAyIHZt
YXAgeyAwIDoganVtcCBzdmMxLWVuZHBvaW50LTEsIDEgOiBqdW1wIHN2YzEtZW5kcG9pbnQtMiB9
IiB0byBzdmMxIGFuZCBzdmMyIGNoYWlucyB0byBsb2FkIGJhbGFuY2UgYmV0d2VlbiBzZXJ2aWNl
cycgZW5kcG9pbnRzIGJ1dCB3aGVuIEkgZG8gdGhhdCBpdCBmYWlscyB3aXRoIFVuc3VwcG9ydGVk
IG9wZXJhdGlvbi4NCkluIGNvbnRyYXN0IGl0IGxldCBtZSBhcHBseSB0aGlzIHJ1bGUgdG8gcHJl
cm91dGluZyBjaGFpbi4NCg0KVGhpcyBzcGxpdCBzdXBwb3J0IG9mIHJlamVjdCBpbiBpbnB1dC9m
b3J3YXJkL291dHB1dCBhbmQgbnVtZ2VuIG9ubHkgaW4gcHJlcm91dGluZyBpcyBub3QgaWRlYWwg
YXMgYSBwYWNrZXQgZm9yIGEgY2xpZW50ICBvZiBhIHNlcnZpY2Ugd2l0aG91dCByZWdpc3RlcmVk
IGVuZHBvaW50IHdpbGwgbmVlZCB0byBnbyB0aHJvdWdoIGFsbCBjaGVja3MgaW4gcHJlcm91dGlu
ZyBjaGFpbiBiZWZvcmUgaXQgcmVhY2hlcyBpbnB1dCBjaGFpbiBhbmQgZ2V0IGl0cyByZWplY3Qg
YmFjay4NCg0KVGhhbmsgeW91IHZlcnkgbXVjaCBmb3IgeW91ciBoZWxwLg0KU2VyZ3VlaQ0KDQrv
u79PbiAyMDE5LTExLTI2LCAyOjI4IFBNLCAibjAtMUBvcmJ5dGUubndsLmNjIG9uIGJlaGFsZiBv
ZiBQaGlsIFN1dHRlciIgPG4wLTFAb3JieXRlLm53bC5jYyBvbiBiZWhhbGYgb2YgcGhpbEBud2wu
Y2M+IHdyb3RlOg0KDQogICAgSGksDQogICAgDQogICAgT24gVHVlLCBOb3YgMjYsIDIwMTkgYXQg
MDY6NDc6MDlQTSArMDAwMCwgU2VyZ3VlaSBCZXp2ZXJraGkgKHNiZXp2ZXJrKSB3cm90ZToNCiAg
ICA+IE9rLCBJIGd1ZXNzIEkgd2lsbCB3b3JrIGFyb3VuZCBieSB1c2luZyBpbnB1dCBhbmQgb3V0
cHV0IGNoYWluIHR5cGVzLCBldmVuIHRob3VnaCBpdCB3aWxsIHJhaXNlIHNvbWUgYnJvd3MgaW4g
azhzIG5ldHdvcmtpbmcgY29tbXVuaXR5Lg0KICAgID4gDQogICAgPiBJIGhhdmUgYSBzZWNvbmQg
aXNzdWUgSSBhbSBzdHJ1Z2dsaW5nIHRvIHNvbHZlIHdpdGggbmZ0YWJsZXMuIEhlcmUgaXMgYSBz
ZXJ2aWNlIGV4cG9zZWQgZm9yIHRjcCBwb3J0IDgwIHdoaWNoIGhhcyAyIGNvcnJlc3BvbmRpbmcg
YmFja2VuZHMgbGlzdGVuaW5nIG9uIGEgY29udGFpbmVyIHBvcnQgODA4MC4NCiAgICA+IA0KICAg
ID4gIQ0KICAgID4gISBCYWNrZW5kIDENCiAgICA+ICENCiAgICA+IC1BIEtVQkUtU0VQLUZTM0ZV
VUxHWlBWRDRWWUIgLXMgNTcuMTEyLjAuMjQ3LzMyIC1qIEtVQkUtTUFSSy1NQVNRDQogICAgPiAt
QSBLVUJFLVNFUC1GUzNGVVVMR1pQVkQ0VllCIC1wIHRjcCAtbSB0Y3AgLWogRE5BVCAtLXRvLWRl
c3RpbmF0aW9uIDU3LjExMi4wLjI0Nzo4MDgwDQogICAgPiAhDQogICAgPiAhIEJhY2tlbmQgMg0K
ICAgID4gIQ0KICAgID4gLUEgS1VCRS1TRVAtTU1GWlJPUVNMUTNES09RQSAtcyA1Ny4xMTIuMC4y
NDgvMzIgLWogS1VCRS1NQVJLLU1BU1ENCiAgICA+IC1BIEtVQkUtU0VQLU1NRlpST1FTTFEzREtP
UUEgLXAgdGNwIC1tIHRjcCAtaiBETkFUIC0tdG8tZGVzdGluYXRpb24gNTcuMTEyLjAuMjQ4Ojgw
ODANCiAgICA+ICENCiAgICA+ICEgU2VydmljZQ0KICAgID4gIQ0KICAgID4gLUEgS1VCRS1TRVJW
SUNFUyAtZCA1Ny4xNDIuMjIxLjIxLzMyIC1wIHRjcCAtbSBjb21tZW50IC0tY29tbWVudCAiZGVm
YXVsdC9hcHA6aHR0cC13ZWIgY2x1c3RlciBJUCIgLW0gdGNwIC0tZHBvcnQgODAgLWogS1VCRS1T
VkMtNTdYVk9DRk5UTFRSM1EyNw0KICAgID4gIQ0KICAgID4gISBMb2FkIGJhbGFuY2luZyBiZXR3
ZWVuIDIgYmFja2VuZHMNCiAgICA+ICENCiAgICA+IC1BIEtVQkUtU1ZDLTU3WFZPQ0ZOVExUUjNR
MjcgLW0gc3RhdGlzdGljIC0tbW9kZSByYW5kb20gLS1wcm9iYWJpbGl0eSAwLjUwMDAwMDAwMDAw
IC1qIEtVQkUtU0VQLUZTM0ZVVUxHWlBWRDRWWUINCiAgICA+IC1BIEtVQkUtU1ZDLTU3WFZPQ0ZO
VExUUjNRMjcgLWogS1VCRS1TRVAtTU1GWlJPUVNMUTNES09RQQ0KICAgID4gDQogICAgPiBJIGFt
IGxvb2tpbmcgZm9yIG5mdGFibGVzIGVxdWl2YWxlbnQgZm9yIHRoZSBsb2FkIGJhbGFuY2luZyBw
YXJ0IGFuZCBhbHNvIGluIHRoaXMgY2FzZSB0aGVyZSBhcmUgZG91YmxlIGRuYXQgdHJhbnNsYXRp
b24sICBkZXN0aW5hdGlvbiBwb3J0IGZyb20gODAgdG8gODA4MCBhbmQgZGVzdGluYXRpb24gSVA6
ICA1Ny4xMTIuMC4yNDcgb3IgNTcuMTEyLjAuMjQ4Lg0KICAgID4gQ2FuIGl0IGJlIGV4cHJlc3Nl
ZCBpbiBhIHNpbmdsZSBuZnQgZG5hdCBzdGF0ZW1lbnQgd2l0aCB2bWFwcyBvciBzZXRzPw0KICAg
IA0KICAgIFJlZ2FyZGluZyB4dF9zdGF0aXN0aWMgcmVwbGFjZW1lbnQsIEkgb25jZSBpZGVudGlm
aWVkIHRoZSBlcXVpdmFsZW50IG9mDQogICAgJy1tIHN0YXRpc3RpYyAtLW1vZGUgcmFuZG9tIC0t
cHJvYmFiaWxpdHkgMC41JyB3b3VsZCBiZSAnbnVtZ2VuIHJhbmRvbQ0KICAgIG1vZCAweDIgPCAw
eDEnLg0KICAgIA0KICAgIEtlZXBpbmcgYm90aCB0YXJnZXQgYWRkcmVzcyBhbmQgcG9ydCBpbiBh
IHNpbmdsZSBtYXAgZm9yICpOQVQgc3RhdGVtZW50cw0KICAgIGlzIG5vdCBwb3NzaWJsZSBBRkFJ
Sy4NCiAgICANCiAgICBJZiBJJ20gbm90IG1pc3Rha2VuLCB5b3UgbWlnaHQgYmUgYWJsZSB0byBo
b29rIHVwIGEgdm1hcCB0b2dldGhlciB3aXRoDQogICAgdGhlIG51bWdlbiBleHByZXNzaW9uIGFi
b3ZlIGxpa2Ugc286DQogICAgDQogICAgfCBudW1nZW4gcmFuZG9tIG1vZCAweDIgdm1hcCB7IFwN
CiAgICB8CTB4MDoganVtcCBLVUJFLVNFUC1GUzNGVVVMR1pQVkQ0VllCLCBcDQogICAgfAkweDE6
IGp1bXAgS1VCRS1TRVAtTU1GWlJPUVNMUTNES09RQSB9DQogICAgDQogICAgUHVyZSBzcGVjdWxh
dGlvbiwgdGhvdWdoLiA6KQ0KICAgIA0KICAgIENoZWVycywgUGhpbA0KICAgIA0KDQo=
